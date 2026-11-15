<#
  Contact Workbench - Exchange helper (version 1)

  Reads and changes the contacts in YOUR OWN Microsoft 365 (Exchange) mailbox,
  using Microsoft's own sign-in page. It never touches Zoho, Apple or Google.

  How to start it on Windows:
    Right-click ExchangeBridge.ps1 and choose "Run with PowerShell".
    A small menu appears:
      1  Get my Exchange contacts   (makes a file to add to Contact Workbench)
      2  Apply changes to Exchange  (reads "Changes for Exchange" from the app,
                                      shows a preview, makes a backup, asks YES)
      3  Put back deleted contacts  (from the file Apply saves before deleting)
      4  Sign out

  Or from a PowerShell window:
    powershell -ExecutionPolicy Bypass -File .\ExchangeBridge.ps1 Get
    powershell -ExecutionPolicy Bypass -File .\ExchangeBridge.ps1 Apply -Path .\Changes-for-Exchange.csv
    powershell -ExecutionPolicy Bypass -File .\ExchangeBridge.ps1 Restore -Path .\Exchange-deleted-....json

  Safety:
    - Nothing changes until you type YES after reading the preview.
    - A full backup of every Exchange contact is saved first.
    - Contacts it deletes are also saved on their own, so Restore can put them back.
    - It never removes a phone number, email or address from a contact unless you
      add -AllowRemove. Without it, it only adds and corrects.

  Files go to: Documents\Contact Workbench\Exchange
#>
param(
  [Parameter(Position = 0)][string]$Action = '',
  [string]$Path = '',
  [string]$ClientId = '14d82eec-204b-4c2f-b7e8-296a70dab67e',
  [string]$Tenant = 'organizations',
  [switch]$AllowRemove,
  [switch]$Yes
)

$ErrorActionPreference = 'Stop'
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

$Scopes = 'https://graph.microsoft.com/Contacts.ReadWrite https://graph.microsoft.com/User.Read offline_access'
$GraphRoot = 'https://graph.microsoft.com/v1.0'
$Select = 'id,displayName,givenName,middleName,surname,title,generation,nickName,emailAddresses,businessPhones,homePhones,mobilePhone,companyName,jobTitle,department,homeAddress,businessAddress,otherAddress,birthday,businessHomePage,personalNotes,categories,parentFolderId'
$OutDir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Contact Workbench\Exchange'
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Force -Path $OutDir | Out-Null }
$TokenDir = Join-Path $env:LOCALAPPDATA 'ContactWorkbench'
$TokenFile = Join-Path $TokenDir ('exchange-signin-' + $ClientId + '.txt')
$script:AccessToken = $null
$script:AccessUntil = [datetime]::MinValue

function Say([string]$t, [string]$c = 'Gray') { Write-Host $t -ForegroundColor $c }
function Stamp { (Get-Date).ToString('yyyy-MM-dd_HHmm') }
function S($v) { if ($null -eq $v) { return '' } return ([string]$v).Trim() }

# ---------------- sign-in (Microsoft's device-code page) ----------------
function Get-ErrBody($e) {
  try { if ($e.ErrorDetails -and $e.ErrorDetails.Message) { return ($e.ErrorDetails.Message | ConvertFrom-Json) } } catch {}
  try {
    $st = $e.Exception.Response.GetResponseStream(); $rd = New-Object IO.StreamReader($st)
    return ($rd.ReadToEnd() | ConvertFrom-Json)
  } catch {}
  return $null
}

function Save-Refresh([string]$rt) {
  if (-not $rt) { return }
  if (-not (Test-Path $TokenDir)) { New-Item -ItemType Directory -Force -Path $TokenDir | Out-Null }
  # Encrypted with Windows (DPAPI): only this Windows account on this PC can read it.
  ConvertTo-SecureString $rt -AsPlainText -Force | ConvertFrom-SecureString | Set-Content -Path $TokenFile
}

function Read-Refresh {
  if (-not (Test-Path $TokenFile)) { return $null }
  try {
    $sec = Get-Content -Path $TokenFile | ConvertTo-SecureString
    $b = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
    try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($b) } finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($b) }
  } catch { return $null }
}

function Use-Token($t) {
  $script:AccessToken = $t.access_token
  $script:AccessUntil = (Get-Date).AddSeconds([int]$t.expires_in - 120)
  if ($t.refresh_token) { Save-Refresh $t.refresh_token }
}

function SignIn-DeviceCode {
  $dc = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$Tenant/oauth2/v2.0/devicecode" -Body @{ client_id = $ClientId; scope = $Scopes }
  Say ''
  Say 'SIGN IN TO MICROSOFT 365' 'Cyan'
  Say ('  1. A web page opens: ' + $dc.verification_uri)
  Say ('  2. Paste or type this code:  ' + $dc.user_code) 'Yellow'
  Say '  3. Sign in with your Microsoft 365 work account. If it asks for permission'
  Say '     to read and write your contacts, accept. (As the admin you may see'
  Say '     "Consent on behalf of your organization": leave it unticked.)'
  Say '  Waiting for you to finish signing in...'
  try { Set-Clipboard -Value $dc.user_code } catch {}
  try { Start-Process $dc.verification_uri } catch {}
  $interval = [int]$dc.interval; if ($interval -lt 2) { $interval = 5 }
  $deadline = (Get-Date).AddSeconds([int]$dc.expires_in)
  while ((Get-Date) -lt $deadline) {
    Start-Sleep -Seconds $interval
    try {
      $t = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$Tenant/oauth2/v2.0/token" -Body @{ grant_type = 'urn:ietf:params:oauth:grant-type:device_code'; client_id = $ClientId; device_code = $dc.device_code }
      Use-Token $t; Say 'Signed in.' 'Green'; return
    } catch {
      $b = Get-ErrBody $_
      if ($b -and $b.error -eq 'authorization_pending') { continue }
      if ($b -and $b.error -eq 'slow_down') { $interval += 5; continue }
      if ($b) { throw ('Sign-in did not work: ' + $b.error_description) }
      throw
    }
  }
  throw 'The sign-in code ran out of time. Start the helper again.'
}

function Get-AccessToken {
  if ($script:AccessToken -and (Get-Date) -lt $script:AccessUntil) { return $script:AccessToken }
  $rt = Read-Refresh
  if ($rt) {
    try {
      $t = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$Tenant/oauth2/v2.0/token" -Body @{ grant_type = 'refresh_token'; client_id = $ClientId; refresh_token = $rt; scope = $Scopes }
      Use-Token $t; return $script:AccessToken
    } catch { Remove-Item -Path $TokenFile -ErrorAction SilentlyContinue }
  }
  SignIn-DeviceCode
  return $script:AccessToken
}

# ---------------- Microsoft Graph calls ----------------
function Invoke-Graph([string]$Method, [string]$Url, $Body = $null) {
  if ($Url -notmatch '^https://') { $Url = $GraphRoot + $Url }
  for ($try = 1; $try -le 6; $try++) {
    $h = @{ Authorization = ('Bearer ' + (Get-AccessToken)) }
    try {
      if ($null -ne $Body) {
        $json = ConvertTo-Json -InputObject $Body -Depth 8 -Compress
        $bytes = [Text.Encoding]::UTF8.GetBytes($json)
        return Invoke-RestMethod -Method $Method -Uri $Url -Headers $h -Body $bytes -ContentType 'application/json; charset=utf-8'
      }
      return Invoke-RestMethod -Method $Method -Uri $Url -Headers $h
    } catch {
      $code = 0; try { $code = [int]$_.Exception.Response.StatusCode } catch {}
      if (($code -eq 429 -or $code -ge 500) -and $try -lt 6) {
        $wait = 5 * $try
        try { $ra = $_.Exception.Response.Headers['Retry-After']; if ($ra) { $wait = [int]$ra } } catch {}
        Start-Sleep -Seconds $wait; continue
      }
      if ($code -eq 401 -and $try -lt 2) { $script:AccessToken = $null; continue }
      throw
    }
  }
}

function Get-Paged([string]$Url) {
  $out = New-Object System.Collections.ArrayList
  while ($Url) {
    $r = Invoke-Graph 'GET' $Url
    foreach ($x in @($r.value)) { if ($null -ne $x) { [void]$out.Add($x) } }
    $Url = $r.'@odata.nextLink'
  }
  return , $out
}

function Get-AllContacts {
  # Returns @{ list = all contacts; folders = id -> folder name }
  $folders = @{}
  $seen = @{}
  $all = New-Object System.Collections.ArrayList
  $q = '?$top=500&$select=' + $Select
  Say 'Reading the Contacts folder...'
  foreach ($c in (Get-Paged ('/me/contacts' + $q))) { if (-not $seen.ContainsKey($c.id)) { $seen[$c.id] = 1; [void]$all.Add($c) } }
  $todo = New-Object System.Collections.ArrayList
  foreach ($f in (Get-Paged '/me/contactFolders?$top=500')) { [void]$todo.Add($f) }
  while ($todo.Count -gt 0) {
    $f = $todo[0]; $todo.RemoveAt(0)
    $folders[$f.id] = $f.displayName
    Say ('Reading folder ' + $f.displayName + '...')
    foreach ($c in (Get-Paged ('/me/contactFolders/' + $f.id + '/contacts' + $q))) { if (-not $seen.ContainsKey($c.id)) { $seen[$c.id] = 1; [void]$all.Add($c) } }
    foreach ($k in (Get-Paged ('/me/contactFolders/' + $f.id + '/childFolders?$top=500'))) { [void]$todo.Add($k) }
  }
  return @{ list = $all; folders = $folders }
}

# ---------------- contact <-> Outlook-style row ----------------
function Date-Part($v) {
  if ($null -eq $v) { return '' }
  if ($v -is [datetime]) { return $v.ToString('yyyy-MM-dd') }
  $s = [string]$v; if ($s.Length -ge 10) { return $s.Substring(0, 10) } return ''
}

function Contact-Row($c, $folders) {
  $bp = @($c.businessPhones); $hp = @($c.homePhones); $em = @($c.emailAddresses)
  $ha = $c.homeAddress; $ba = $c.businessAddress; $oa = $c.otherAddress
  $bd = Date-Part $c.birthday; $bdOut = ''
  if ($bd) { try { $bdOut = ([datetime]::ParseExact($bd, 'yyyy-MM-dd', $null)).ToString('M/d/yyyy') } catch {} }
  $fname = 'Contacts'; if ($c.parentFolderId -and $folders.ContainsKey($c.parentFolderId)) { $fname = $folders[$c.parentFolderId] }
  $o = [ordered]@{}
  $o['First Name'] = S $c.givenName; $o['Middle Name'] = S $c.middleName; $o['Last Name'] = S $c.surname
  $o['Title'] = S $c.title; $o['Suffix'] = S $c.generation; $o['Nickname'] = S $c.nickName
  $o['E-mail Address'] = S $(if ($em.Count -gt 0) { $em[0].address }); $o['E-mail 2 Address'] = S $(if ($em.Count -gt 1) { $em[1].address }); $o['E-mail 3 Address'] = S $(if ($em.Count -gt 2) { $em[2].address })
  $o['Business Phone'] = S $(if ($bp.Count -gt 0) { $bp[0] }); $o['Business Phone 2'] = S $(if ($bp.Count -gt 1) { $bp[1] })
  $o['Home Phone'] = S $(if ($hp.Count -gt 0) { $hp[0] }); $o['Home Phone 2'] = S $(if ($hp.Count -gt 1) { $hp[1] })
  $o['Mobile Phone'] = S $c.mobilePhone
  $o['Company'] = S $c.companyName; $o['Job Title'] = S $c.jobTitle; $o['Department'] = S $c.department
  foreach ($p in @(@('Home', $ha), @('Business', $ba), @('Other', $oa))) {
    $a = $p[1]
    $o[$p[0] + ' Street'] = S $a.street; $o[$p[0] + ' City'] = S $a.city; $o[$p[0] + ' State'] = S $a.state
    $o[$p[0] + ' Postal Code'] = S $a.postalCode; $o[$p[0] + ' Country/Region'] = S $a.countryOrRegion
  }
  $o['Birthday'] = $bdOut; $o['Web Page'] = S $c.businessHomePage; $o['Notes'] = S $c.personalNotes
  $o['Categories'] = (@($c.categories) | Where-Object { $_ }) -join ';'
  $o['Exchange Folder'] = $fname
  $o['Exchange Id'] = S $c.id
  return New-Object PSObject -Property $o
}

function Do-Get {
  $r = Get-AllContacts
  $file = Join-Path $OutDir ('Exchange-contacts-' + (Stamp) + '.csv')
  $rows = foreach ($c in $r.list) { Contact-Row $c $r.folders }
  @($rows) | Export-Csv -Path $file -NoTypeInformation -Encoding UTF8
  Say ''
  Say ('Saved ' + $r.list.Count + ' Exchange contacts to:') 'Green'
  Say ('  ' + $file) 'Green'
  Say 'Next: in Contact Workbench, open Add & Clean Up and add this file. Remove any older'
  Say 'Exchange or Outlook list there first, so each person is only counted once.'
  try { Start-Process explorer.exe ('/select,"' + $file + '"') } catch {}
  return $r
}

# ---------------- working out what to change ----------------
function Digits([string]$p) { return ($p -replace '[^0-9]', '') -replace '^1(?=\d{10}$)', '' }
function Col($row, [string]$name) { $p = $row.PSObject.Properties[$name]; if ($p) { return S $p.Value } return $null }
function Same-List($a, $b) { $a = @($a); $b = @($b); if ($a.Count -ne $b.Count) { return $false }; for ($i = 0; $i -lt $a.Count; $i++) { if ([string]$a[$i] -cne [string]$b[$i]) { return $false } }; return $true }
function Show-List($a) { $a = @($a | Where-Object { $_ }); if ($a.Count -eq 0) { return '(none)' } return ($a -join ', ') }
function Short([string]$t) { $t = $t -replace "`r?`n", ' / '; if ($t.Length -gt 70) { return $t.Substring(0, 67) + '...' } return $t }

function Build-Patch($row, $c) {
  $patch = @{}; $notes = New-Object System.Collections.ArrayList
  $map = [ordered]@{ 'First Name' = 'givenName'; 'Middle Name' = 'middleName'; 'Last Name' = 'surname'; 'Title' = 'title'; 'Suffix' = 'generation'; 'Nickname' = 'nickName'; 'Company' = 'companyName'; 'Job Title' = 'jobTitle'; 'Department' = 'department'; 'Web Page' = 'businessHomePage'; 'Notes' = 'personalNotes' }
  foreach ($k in $map.Keys) {
    $new = Col $row $k; if ($null -eq $new) { continue }
    $prop = $map[$k]; $old = S $c.$prop
    if ($k -eq 'Last Name' -and $old -eq '' -and $new -ne '' -and $new -eq (Col $row 'Company') -and (Col $row 'First Name') -eq '') { continue }
    if ($k -eq 'Notes') { $new = $new -replace "`r`n", "`n"; $old = $old -replace "`r`n", "`n" }
    if ($new -ceq $old) { continue }
    if ($new -eq '') {
      if ($AllowRemove) { $patch[$prop] = $null; [void]$notes.Add(('{0}: remove "{1}"' -f $k, (Short $old))) }
      continue
    }
    if ($k -eq 'Notes') { $patch[$prop] = ($new -replace "`n", "`r`n") } else { $patch[$prop] = $new }
    [void]$notes.Add(('{0}: "{1}" -> "{2}"' -f $k, (Short $old), (Short $new)))
  }
  if ($patch.ContainsKey('givenName') -or $patch.ContainsKey('middleName') -or $patch.ContainsKey('surname')) {
    $g = $(if ($patch.ContainsKey('givenName')) { S $patch['givenName'] } else { S $c.givenName })
    $m = $(if ($patch.ContainsKey('middleName')) { S $patch['middleName'] } else { S $c.middleName })
    $l = $(if ($patch.ContainsKey('surname')) { S $patch['surname'] } else { S $c.surname })
    $dn = (@($g, $m, $l) | Where-Object { $_ }) -join ' '
    if ($dn) { $patch['displayName'] = $dn }
  }

  # phones: Exchange holds 2 business, 2 home and 1 mobile number
  $hasPhoneCols = $null -ne (Col $row 'Business Phone')
  if ($hasPhoneCols) {
    $nb = @(@((Col $row 'Business Phone'), (Col $row 'Business Phone 2')) | Where-Object { $_ })
    $nh = @(@((Col $row 'Home Phone'), (Col $row 'Home Phone 2')) | Where-Object { $_ })
    $nm = S (Col $row 'Mobile Phone')
    $ob = @(@($c.businessPhones) | Where-Object { $_ }); $oh = @(@($c.homePhones) | Where-Object { $_ }); $om = S $c.mobilePhone
    # "Other Phone" has no place of its own in Exchange: keep it where Exchange already has that number
    $oth = Col $row 'Other Phone'
    if ($oth) {
      $od = Digits $oth
      if (@($ob | Where-Object { (Digits $_) -eq $od }).Count -gt 0) { $nb += $oth }
      elseif ($om -and (Digits $om) -eq $od) { if (-not $nm) { $nm = $oth } }
      else { $nh += $oth }
    }
    $newDigits = @{}; foreach ($p in ($nb + $nh + @($nm))) { if ($p) { $newDigits[(Digits $p)] = 1 } }
    $ok = $true; $why = ''
    if (-not $AllowRemove) {
      foreach ($p in $ob) { if (-not $newDigits.ContainsKey((Digits $p))) { $nb += $p; $newDigits[(Digits $p)] = 1 } }
      foreach ($p in $oh) { if (-not $newDigits.ContainsKey((Digits $p))) { $nh += $p; $newDigits[(Digits $p)] = 1 } }
      if ($om -and -not $nm) { $nm = $om }
      elseif ($om -and $nm -and (Digits $om) -ne (Digits $nm) -and -not (@($nb + $nh) | Where-Object { (Digits $_) -eq (Digits $om) })) { $ok = $false; $why = 'the mobile number would be replaced' }
    }
    while ($nb.Count -gt 2 -and $nh.Count -lt 2) { $nh = @($nh) + @($nb[2]); $nb = @(@($nb | Select-Object -First 2) + @($nb | Select-Object -Skip 3)) }
    while ($nh.Count -gt 2 -and $nb.Count -lt 2) { $nb = @($nb) + @($nh[2]); $nh = @(@($nh | Select-Object -First 2) + @($nh | Select-Object -Skip 3)) }
    if ($nb.Count -gt 2 -or $nh.Count -gt 2) {
      if ($AllowRemove) { $nb = @($nb | Select-Object -First 2); $nh = @($nh | Select-Object -First 2) } else { $ok = $false; $why = 'there are more numbers than Exchange has room for' }
    }
    if ($ok) {
      if (-not (Same-List $nb $ob)) { $patch['businessPhones'] = [object[]]$nb; [void]$notes.Add(('Business phones: {0} -> {1}' -f (Show-List $ob), (Show-List $nb))) }
      if (-not (Same-List $nh $oh)) { $patch['homePhones'] = [object[]]$nh; [void]$notes.Add(('Home phones: {0} -> {1}' -f (Show-List $oh), (Show-List $nh))) }
      if ($nm -cne $om) {
        if ($nm -eq '') { $patch['mobilePhone'] = $null } else { $patch['mobilePhone'] = $nm }
        [void]$notes.Add(('Mobile: {0} -> {1}' -f (Show-List @($om)), (Show-List @($nm))))
      }
    } else { [void]$notes.Add(('Phones left as they are, because ' + $why + ' (run with -AllowRemove to allow that)')) }
  }

  # email: Exchange holds up to 3
  if ($null -ne (Col $row 'E-mail Address')) {
    $ne = @(@((Col $row 'E-mail Address'), (Col $row 'E-mail 2 Address'), (Col $row 'E-mail 3 Address')) | Where-Object { $_ })
    $oe = @(@($c.emailAddresses) | Where-Object { $_ -and $_.address })
    $have = @{}; foreach ($e in $ne) { $have[$e.ToLower()] = 1 }
    if (-not $AllowRemove) { foreach ($e in $oe) { if (-not $have.ContainsKey(([string]$e.address).ToLower())) { $ne += [string]$e.address; $have[([string]$e.address).ToLower()] = 1 } } }
    $oa = @($oe | ForEach-Object { [string]$_.address })
    if ($ne.Count -gt 3 -and -not $AllowRemove) { [void]$notes.Add('Emails left as they are, because there are more than Exchange has room for (run with -AllowRemove to allow that)') }
    else {
      $ne = @($ne | Select-Object -First 3)
      if (-not (Same-List @($ne | ForEach-Object { $_.ToLower() }) @($oa | ForEach-Object { $_.ToLower() }))) {
        $dn = S $c.displayName; if ($patch.ContainsKey('displayName')) { $dn = $patch['displayName'] }
        $objs = foreach ($e in $ne) {
          $nm2 = $dn; foreach ($x in $oe) { if (([string]$x.address).ToLower() -eq $e.ToLower() -and $x.name) { $nm2 = [string]$x.name } }
          @{ address = $e; name = $nm2 }
        }
        $patch['emailAddresses'] = [object[]]@($objs)
        [void]$notes.Add(('Emails: {0} -> {1}' -f (Show-List $oa), (Show-List $ne)))
      }
    }
  }

  # addresses: Home and Business. A blank address in the file never clears one in Exchange.
  foreach ($kind in @(@('Home', 'homeAddress'), @('Business', 'businessAddress'))) {
    $pre = $kind[0]; $prop = $kind[1]
    if ($null -eq (Col $row ($pre + ' Street'))) { continue }
    $old = $c.$prop
    $parts = [ordered]@{ street = 'Street'; city = 'City'; state = 'State'; postalCode = 'Postal Code'; countryOrRegion = 'Country/Region' }
    $new = [ordered]@{}; $any = $false
    foreach ($k in $parts.Keys) { $v = S (Col $row ($pre + ' ' + $parts[$k])); $new[$k] = $v; if ($v) { $any = $true } }
    if (-not $any) { continue }
    $changed = $false
    foreach ($k in $parts.Keys) {
      $ov = S $old.$k
      if ($new[$k] -eq '' -and -not $AllowRemove) { $new[$k] = $ov }
      if ($new[$k] -cne $ov) { $changed = $true }
    }
    if ($changed) {
      $patch[$prop] = @{ street = $new.street; city = $new.city; state = $new.state; postalCode = $new.postalCode; countryOrRegion = $new.countryOrRegion }
      $was = (@($old.street, $old.city, $old.state, $old.postalCode, $old.countryOrRegion) | Where-Object { $_ }) -join ', '
      $now = (@($new.street, $new.city, $new.state, $new.postalCode, $new.countryOrRegion) | Where-Object { $_ }) -join ', '
      [void]$notes.Add(('{0} address: "{1}" -> "{2}"' -f $pre, (Short $was), (Short $now)))
    }
  }

  # birthday
  $nbd = Col $row 'Birthday'
  if ($nbd) {
    $d = [datetime]::MinValue
    $ok = [datetime]::TryParse($nbd, [Globalization.CultureInfo]::GetCultureInfo('en-US'), [Globalization.DateTimeStyles]::None, [ref]$d)
    if ($ok -and $d.Year -gt 1900) {
      $iso = $d.ToString('yyyy-MM-dd')
      $obd = Date-Part $c.birthday
      if ($iso -ne $obd) { $patch['birthday'] = ($iso + 'T11:59:00Z'); [void]$notes.Add(('Birthday: {0} -> {1}' -f (Show-List @($obd)), $iso)) }
    }
  }
  return @{ patch = $patch; notes = $notes }
}

function Pick-File([string]$title, [string]$filter) {
  try {
    Add-Type -AssemblyName System.Windows.Forms
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Title = $title; $dlg.Filter = $filter
    $dl = Join-Path $env:USERPROFILE 'Downloads'; if (Test-Path $dl) { $dlg.InitialDirectory = $dl }
    if ($dlg.ShowDialog() -eq 'OK') { return $dlg.FileName }
    return ''
  } catch { return (Read-Host 'Type or paste the full path of the file') }
}

function Do-Apply {
  if (-not $Path) { $script:Path = Pick-File 'Pick the "Changes for Exchange" file from Contact Workbench' 'CSV files (*.csv)|*.csv' }
  if (-not $Path -or -not (Test-Path $Path)) { Say 'No file picked, so nothing was changed.' 'Yellow'; return }
  $rows = @(Import-Csv -Path $Path -Encoding UTF8)
  if ($rows.Count -eq 0 -or -not $rows[0].PSObject.Properties['Action'] -or -not $rows[0].PSObject.Properties['Exchange Id']) {
    Say 'That file is not a "Changes for Exchange" file from Contact Workbench (it needs Action and Exchange Id columns). Nothing was changed.' 'Red'; return
  }
  $st = Stamp
  Say 'Step 1 of 3: backing up every Exchange contact first...' 'Cyan'
  $r = Get-AllContacts
  $bk = Join-Path $OutDir ('Exchange-backup-' + $st)
  @($r.list | ForEach-Object { Contact-Row $_ $r.folders }) | Export-Csv -Path ($bk + '.csv') -NoTypeInformation -Encoding UTF8
  ConvertTo-Json -InputObject @($r.list) -Depth 8 | Set-Content -Path ($bk + '.json') -Encoding UTF8
  Say ('  Backup saved: ' + $bk + '.csv (and .json)') 'Green'
  $byId = @{}; foreach ($c in $r.list) { $byId[[string]$c.id] = $c }

  Say 'Step 2 of 3: working out the changes...' 'Cyan'
  $plan = New-Object System.Collections.ArrayList
  $lines = New-Object System.Collections.ArrayList
  $missing = 0; $same = 0; $done = @{}
  foreach ($row in $rows) {
    $act = (S $row.Action).ToLower(); $id = S $row.'Exchange Id'
    if (-not $id -or $done.ContainsKey($id)) { continue }
    $done[$id] = 1
    if (-not $byId.ContainsKey($id)) { $missing++; continue }
    $c = $byId[$id]; $nm = S $c.displayName; if (-not $nm) { $nm = (@((S $c.givenName), (S $c.surname)) | Where-Object { $_ }) -join ' ' }; if (-not $nm) { $nm = S $c.companyName }
    if ($act -eq 'delete') {
      [void]$plan.Add(@{ act = 'delete'; id = $id; name = $nm; c = $c })
      [void]$lines.Add(('DELETE  {0}   ({1})' -f $nm, (S $row.Reason)))
    } elseif ($act -eq 'update') {
      $b = Build-Patch $row $c
      if ($b.patch.Count -gt 0) {
        [void]$plan.Add(@{ act = 'update'; id = $id; name = $nm; patch = $b.patch })
        [void]$lines.Add(('UPDATE  {0}' -f $nm)); foreach ($n in $b.notes) { [void]$lines.Add('          ' + $n) }
      } else {
        $same++
        if ($b.notes.Count -gt 0) { [void]$lines.Add(('NOTE    {0}' -f $nm)); foreach ($n in $b.notes) { [void]$lines.Add('          ' + $n) } }
      }
    }
  }
  $nu = @($plan | Where-Object { $_.act -eq 'update' }).Count; $nd = @($plan | Where-Object { $_.act -eq 'delete' }).Count
  $head = @(
    'CONTACT WORKBENCH - CHANGES FOR EXCHANGE (PREVIEW)',
    ('File: ' + $Path),
    ('Contacts to update: ' + $nu),
    ('Contacts to delete: ' + $nd),
    ('Already the same, no change: ' + $same),
    ('No longer in Exchange, skipped: ' + $missing),
    $(if ($AllowRemove) { 'Mode: may REMOVE phone numbers, emails and fields that the app removed.' } else { 'Mode: safe. Nothing is removed from a contact; it only adds and corrects.' }),
    ('Backup: ' + $bk + '.csv'),
    '')
  $pv = Join-Path $OutDir ('Exchange-preview-' + $st + '.txt')
  ($head + $lines) | Set-Content -Path $pv -Encoding UTF8
  Say ''
  foreach ($h in $head) { Say $h 'White' }
  if ($plan.Count -eq 0) { Say 'Exchange already matches. Nothing to do.' 'Green'; return }
  Say ('The full list of changes is in: ' + $pv) 'Yellow'
  try { Start-Process notepad.exe ('"' + $pv + '"') } catch {}
  if (-not $Yes) {
    $ans = Read-Host 'Read the preview. Type YES (capitals) to make these changes in Exchange, or press Enter to stop'
    if ($ans -cne 'YES') { Say 'Stopped. Nothing was changed in Exchange.' 'Yellow'; return }
  }

  Say 'Step 3 of 3: making the changes...' 'Cyan'
  $dels = @($plan | Where-Object { $_.act -eq 'delete' } | ForEach-Object { $_.c })
  $delFile = Join-Path $OutDir ('Exchange-deleted-' + $st + '.json')
  if ($dels.Count -gt 0) { ConvertTo-Json -InputObject $dels -Depth 8 | Set-Content -Path $delFile -Encoding UTF8 }
  $log = New-Object System.Collections.ArrayList; $okN = 0; $badN = 0; $i = 0
  foreach ($p in $plan) {
    $i++; Write-Progress -Activity 'Updating Exchange contacts' -Status $p.name -PercentComplete ([int](100 * $i / $plan.Count))
    try {
      if ($p.act -eq 'delete') { Invoke-Graph 'DELETE' ('/me/contacts/' + $p.id) | Out-Null }
      else { Invoke-Graph 'PATCH' ('/me/contacts/' + $p.id) $p.patch | Out-Null }
      $okN++; [void]$log.Add((New-Object PSObject -Property ([ordered]@{ Action = $p.act; Name = $p.name; Result = 'done'; 'Exchange Id' = $p.id })))
    } catch {
      $badN++; $msg = $_.Exception.Message; $eb = Get-ErrBody $_; if ($eb -and $eb.error) { $msg = $eb.error.message }
      [void]$log.Add((New-Object PSObject -Property ([ordered]@{ Action = $p.act; Name = $p.name; Result = ('failed: ' + $msg); 'Exchange Id' = $p.id })))
    }
  }
  Write-Progress -Activity 'Updating Exchange contacts' -Completed
  $lf = Join-Path $OutDir ('Exchange-apply-log-' + $st + '.csv')
  @($log) | Export-Csv -Path $lf -NoTypeInformation -Encoding UTF8
  Say ''
  Say ('Finished: ' + $okN + ' done, ' + $badN + ' failed.') $(if ($badN) { 'Yellow' } else { 'Green' })
  Say ('Log: ' + $lf)
  if ($dels.Count -gt 0) { Say ('Deleted contacts were saved first to: ' + $delFile + '  (choose 3 in the menu to put them back)') }
  Say 'Tip: run Get again and add the new file to Contact Workbench, so the app sees Exchange as it is now.'
}

function Do-Restore {
  if (-not $Path) { $script:Path = Pick-File 'Pick an Exchange-deleted file to put those contacts back' 'Deleted contacts (Exchange-deleted-*.json)|Exchange-deleted-*.json|JSON files (*.json)|*.json' }
  if (-not $Path -or -not (Test-Path $Path)) { Say 'No file picked, so nothing was changed.' 'Yellow'; return }
  $json = Get-Content -Path $Path -Raw -Encoding UTF8 | ConvertFrom-Json
  $list = @($json | ForEach-Object { $_ })
  $keep = @('givenName', 'middleName', 'surname', 'title', 'generation', 'nickName', 'emailAddresses', 'businessPhones', 'homePhones', 'mobilePhone', 'companyName', 'jobTitle', 'department', 'homeAddress', 'businessAddress', 'otherAddress', 'birthday', 'businessHomePage', 'personalNotes', 'categories', 'displayName')
  Say ('This puts back ' + $list.Count + ' contacts (as new copies) into your Exchange Contacts folder.') 'White'
  if (-not $Yes) { $ans = Read-Host 'Type YES (capitals) to go ahead'; if ($ans -cne 'YES') { Say 'Stopped. Nothing was changed.' 'Yellow'; return } }
  $okN = 0
  foreach ($c in $list) {
    $body = @{}
    foreach ($k in $keep) { $v = $c.$k; if ($null -ne $v -and -not ($v -is [string] -and $v -eq '')) { if ($v -is [array]) { if ($v.Count -gt 0) { $body[$k] = [object[]]$v } } else { $body[$k] = $v } } }
    try { Invoke-Graph 'POST' '/me/contacts' $body | Out-Null; $okN++ } catch { Say ('Could not put back ' + (S $c.displayName) + ': ' + $_.Exception.Message) 'Yellow' }
  }
  Say ('Put back ' + $okN + ' of ' + $list.Count + ' contacts.') 'Green'
}

function Do-SignOut {
  Remove-Item -Path $TokenFile -ErrorAction SilentlyContinue
  Say 'Signed out on this PC. Next time it will ask you to sign in again.' 'Green'
}

# ---------------- start ----------------
if ($env:CWB_EXCHANGE_TEST) { return }   # lets a test load the functions without running anything
try {
  $act = $Action
  if (-not $act) {
    Say ''
    Say 'CONTACT WORKBENCH - EXCHANGE HELPER' 'Cyan'
    Say '  1  Get my Exchange contacts (to add to Contact Workbench)'
    Say '  2  Apply changes to Exchange (from the app''s "Changes for Exchange" file)'
    Say '  3  Put back deleted contacts'
    Say '  4  Sign out'
    $n = Read-Host 'Type 1, 2, 3 or 4 and press Enter'
    $act = @{ '1' = 'Get'; '2' = 'Apply'; '3' = 'Restore'; '4' = 'SignOut' }[([string]$n).Trim()]
  }
  switch ($act) {
    'Get' { Do-Get | Out-Null }
    'Apply' { Do-Apply }
    'Restore' { Do-Restore }
    'SignOut' { Do-SignOut }
    default { Say 'Nothing chosen.' 'Yellow' }
  }
} catch {
  Say ''
  Say ('Something went wrong: ' + $_.Exception.Message) 'Red'
  $eb = Get-ErrBody $_; if ($eb -and $eb.error -and $eb.error.message) { Say ('Microsoft says: ' + $eb.error.message) 'Red' }
}
Say ''
Read-Host 'Press Enter to close' | Out-Null
