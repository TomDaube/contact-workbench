<#
  Contact Workbench - Exchange helper (version 5)

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

  Or from a PowerShell window (it uses Tom's Contact Workbench app by default):
    powershell -ExecutionPolicy Bypass -NoExit -File "$HOME\Desktop\ExchangeBridge.ps1"
    powershell -ExecutionPolicy Bypass -File .\ExchangeBridge.ps1 Get
    powershell -ExecutionPolicy Bypass -File .\ExchangeBridge.ps1 Apply -Path .\Changes-for-Exchange.csv
    powershell -ExecutionPolicy Bypass -File .\ExchangeBridge.ps1 Restore -Path .\Exchange-deleted-....json

  Safety:
    - Nothing changes until you type YES after reading the preview.
    - A full backup of every Exchange contact is saved first.
    - Contacts it deletes are also saved on their own, so Restore can put them back.
    - It never removes a phone number, email or address from a contact unless you
      add -AllowRemove. Without it, it only adds and corrects.
    - Exchange holds 3 emails, 2 business, 2 home and 1 mobile number. Emails and
      numbers that don't fit are written into the contact's Notes as
      "Other emails: ..." and "Other phones: ...", so none is lost.

  Files go to: Documents\Contact Workbench\Exchange
#>
param(
  [Parameter(Position = 0)][string]$Action = '',
  [string]$Path = '',
  # Defaults: Tom's own "Contact Workbench" app in his Microsoft 365 (Entra).
  # Someone else can pass -ClientId and -Tenant for their own app.
  [string]$ClientId = '302ffbfc-1c93-4683-905d-42a4e9a57d86',
  [string]$Tenant = '3a80c2bf-b5d1-4908-8900-046f9d8ab061',
  [switch]$AllowRemove,
  [switch]$Yes,
  [switch]$DeviceCode   # use the old code sign-in instead of the browser
)

$ErrorActionPreference = 'Stop'
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

$Scopes = 'https://graph.microsoft.com/Contacts.ReadWrite https://graph.microsoft.com/User.Read offline_access'
$GraphRoot = 'https://graph.microsoft.com/v1.0'
$Select = 'id,displayName,givenName,middleName,surname,title,generation,nickName,emailAddresses,businessPhones,homePhones,mobilePhone,companyName,jobTitle,department,homeAddress,businessAddress,otherAddress,birthday,businessHomePage,personalNotes,categories,parentFolderId'
$OutDir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Contact Workbench\Exchange'
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Force -Path $OutDir | Out-Null }
$TokenDir = Join-Path $env:LOCALAPPDATA 'ContactWorkbench'
# App IDs pasted in earlier (see Ask-AppIds) win over the built-in defaults,
# unless -ClientId was typed on the command line.
$AppFile = Join-Path $TokenDir 'exchange-app-ids.txt'
if (-not $PSBoundParameters.ContainsKey('ClientId') -and (Test-Path $AppFile)) {
  try {
    $ids = @(Get-Content -Path $AppFile | ForEach-Object { ([string]$_).Trim() } | Where-Object { $_ })
    if ($ids.Count -ge 2) { $ClientId = $ids[0]; $Tenant = $ids[1] }
  } catch {}
}
$TokenFile = Join-Path $TokenDir ('exchange-signin-' + $ClientId + '.txt')
$script:AccessToken = $null
$script:AccessUntil = [datetime]::MinValue

function Say([string]$t, [string]$c = 'Gray') { Write-Host $t -ForegroundColor $c }
function Stamp { (Get-Date).ToString('yyyy-MM-dd_HHmm') }
function S($v) { if ($null -eq $v) { return '' } return ([string]$v).Trim() }

# ---------------- sign-in (Microsoft's device-code page) ----------------
function Get-ErrRaw($e) {
  # The text Microsoft sent back with an error (JSON), or ''.
  try { if ($e.ErrorDetails -and $e.ErrorDetails.Message) { return [string]$e.ErrorDetails.Message } } catch {}
  try {
    $st = $e.Exception.Response.GetResponseStream()
    try { $st.Position = 0 } catch {}
    $rd = New-Object IO.StreamReader($st)
    return [string]$rd.ReadToEnd()
  } catch {}
  return ''
}

function Get-ErrBody($e) {
  $raw = Get-ErrRaw $e
  if ($raw) { try { return ($raw | ConvertFrom-Json) } catch {} }
  return $null
}

function Get-ErrText($e) {
  # One readable line: HTTP status + Microsoft's own code and message.
  $code = 0; try { $code = [int]$e.Exception.Response.StatusCode } catch {}
  $raw = Get-ErrRaw $e
  $b = $null; if ($raw) { try { $b = $raw | ConvertFrom-Json } catch {} }
  $txt = ''
  if ($b -and $b.error -and $b.error.code) {
    # Microsoft Graph style: { error: { code, message } }
    $txt = [string]$b.error.code; if ($b.error.message) { $txt += ': ' + [string]$b.error.message }
  } elseif ($b -and $b.error) {
    # Microsoft sign-in style: { error, error_description }
    $txt = [string]$b.error; if ($b.error_description) { $txt += ': ' + (([string]$b.error_description) -split "`r?`n")[0] }
  } elseif ($raw) {
    $txt = $raw.Trim(); if ($txt.Length -gt 400) { $txt = $txt.Substring(0, 400) + '...' }
  } else {
    $txt = $e.Exception.Message
  }
  if ($code) { $txt = '(' + $code + ') ' + $txt }
  return $txt
}

function New-GraphError([string]$text, [int]$code, [string]$gcode) {
  $ex = New-Object System.Exception($text)
  $ex.Data['status'] = $code; $ex.Data['gcode'] = $gcode
  return $ex
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

function Ask-AppIds {
  # Microsoft did not recognise the app. Ask for the two IDs from the Entra page and remember them.
  Say ''
  Say 'Microsoft does not recognise the app ID or directory ID this helper is using.' 'Yellow'
  Say 'Copy the right ones from Microsoft Entra:' 'White'
  Say '  1. Go to entra.microsoft.com and sign in.'
  Say '  2. App registrations > All applications > Contact Workbench.'
  Say '  3. On its Overview page, copy "Application (client) ID" and paste it below.'
  Say '  4. Then copy "Directory (tenant) ID" and paste it below.'
  try { Start-Process 'https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade' } catch {}
  $g = '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
  $c = ''; while ($c -notmatch $g) { $c = ([string](Read-Host 'Application (client) ID')).Trim(); if ($c -notmatch $g) { Say '  That does not look right. It is 36 characters like 1234abcd-12ab-34cd-56ef-1234567890ab.' 'Yellow' } }
  $t = ''; while ($t -notmatch $g) { $t = ([string](Read-Host 'Directory (tenant) ID')).Trim(); if ($t -notmatch $g) { Say '  That does not look right. It is 36 characters like 1234abcd-12ab-34cd-56ef-1234567890ab.' 'Yellow' } }
  $script:ClientId = $c; $script:Tenant = $t
  $script:TokenFile = Join-Path $TokenDir ('exchange-signin-' + $c + '.txt')
  if (-not (Test-Path $TokenDir)) { New-Item -ItemType Directory -Force -Path $TokenDir | Out-Null }
  Set-Content -Path $AppFile -Value @($c, $t)
  Say 'Saved. The helper will use these IDs from now on.' 'Green'
}

function B64Url([byte[]]$b) { return ([Convert]::ToBase64String($b)).TrimEnd('=').Replace('+', '-').Replace('/', '_') }
function Rand-Bytes([int]$n) { $b = New-Object byte[] $n; (New-Object Security.Cryptography.RNGCryptoServiceProvider).GetBytes($b); return , $b }

function Send-Page($client, [int]$status, [string]$html) {
  try {
    $body = [Text.Encoding]::UTF8.GetBytes('<!doctype html><html><body style="font-family:Segoe UI,Arial;font-size:18px;margin:40px">' + $html + '</body></html>')
    $head = 'HTTP/1.1 ' + $status + ' OK' + "`r`n" + 'Content-Type: text/html; charset=utf-8' + "`r`n" + 'Content-Length: ' + $body.Length + "`r`n" + 'Connection: close' + "`r`n`r`n"
    $hb = [Text.Encoding]::ASCII.GetBytes($head)
    $st = $client.GetStream(); $st.Write($hb, 0, $hb.Length); $st.Write($body, 0, $body.Length); $st.Flush()
  } catch {}
  try { $client.Close() } catch {}
}

function SignIn-Browser {
  # Normal Microsoft sign-in in your web browser (authorization code + PKCE).
  # Microsoft sends the browser back to this PC (http://localhost), where the helper picks up the answer.
  $tcp = New-Object Net.Sockets.TcpListener([Net.IPAddress]::Loopback, 0)
  $tcp.Start()
  try {
    $port = $tcp.LocalEndpoint.Port
    $redirect = 'http://localhost:' + $port
    $verifier = B64Url (Rand-Bytes 48)
    $sha = [Security.Cryptography.SHA256]::Create()
    $challenge = B64Url ($sha.ComputeHash([Text.Encoding]::ASCII.GetBytes($verifier)))
    $state = B64Url (Rand-Bytes 16)
    $url = 'https://login.microsoftonline.com/' + $Tenant + '/oauth2/v2.0/authorize?client_id=' + $ClientId +
      '&response_type=code&response_mode=query&prompt=select_account' +
      '&redirect_uri=' + [Uri]::EscapeDataString($redirect) +
      '&scope=' + [Uri]::EscapeDataString($Scopes) +
      '&code_challenge=' + $challenge + '&code_challenge_method=S256&state=' + $state
    Say ''
    Say 'SIGN IN TO MICROSOFT 365' 'Cyan'
    Say '  Your web browser opens on Microsoft''s sign-in page. Sign in with your work account.'
    Say '  If it asks for permission to read and write your contacts, accept.'
    Say '  When the page says you are signed in, come back to this window.'
    Say '  (If the browser shows an error instead, copy it and send it to Claude.)'
    Say '  Waiting for you to finish signing in (up to 5 minutes)...'
    Start-Process $url
    $deadline = (Get-Date).AddMinutes(5)
    while ((Get-Date) -lt $deadline) {
      if (-not $tcp.Pending()) { Start-Sleep -Milliseconds 300; continue }
      $client = $tcp.AcceptTcpClient()
      $line = ''
      try { $client.ReceiveTimeout = 5000; $rd = New-Object IO.StreamReader($client.GetStream()); $line = [string]$rd.ReadLine() } catch {}
      $parts = $line.Split(' ')
      $path = ''; if ($parts.Count -ge 2) { $path = $parts[1] }
      $qi = $path.IndexOf('?')
      if ($qi -lt 0) { Send-Page $client 404 'Not here.'; continue }
      $qs = @{}
      foreach ($kv in $path.Substring($qi + 1).Split('&')) {
        $eq = $kv.IndexOf('='); if ($eq -lt 1) { continue }
        $qs[$kv.Substring(0, $eq)] = [Uri]::UnescapeDataString($kv.Substring($eq + 1).Replace('+', ' '))
      }
      if ($qs['state'] -ne $state) { Send-Page $client 400 'This sign-in page is out of date. Close it and try again from the helper.'; continue }
      if ($qs['error']) {
        Send-Page $client 200 ('<b>Sign-in did not work.</b><br><br>' + [Net.WebUtility]::HtmlEncode($qs['error_description']) + '<br><br>You can close this tab.')
        throw ('Sign-in did not work: ' + $qs['error'] + ': ' + (([string]$qs['error_description']) -split "`r?`n")[0])
      }
      if (-not $qs['code']) { Send-Page $client 404 'Not here.'; continue }
      Send-Page $client 200 '<b>You are signed in.</b><br><br>You can close this tab and go back to the Exchange helper window.'
      try {
        $t = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$Tenant/oauth2/v2.0/token" -Body @{ grant_type = 'authorization_code'; client_id = $ClientId; code = $qs['code']; redirect_uri = $redirect; code_verifier = $verifier; scope = $Scopes }
      } catch { throw ('Sign-in did not work: ' + (Get-ErrText $_)) }
      Use-Token $t; Say 'Signed in.' 'Green'; return
    }
    throw 'Sign-in ran out of time. Start the helper again.'
  } finally { try { $tcp.Stop() } catch {} }
}

function SignIn-DeviceCode {
  $dc = $null
  for ($n = 1; $n -le 3 -and $null -eq $dc; $n++) {
    try {
      $dc = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$Tenant/oauth2/v2.0/devicecode" -Body @{ client_id = $ClientId; scope = $Scopes }
    } catch {
      $why = Get-ErrText $_
      # 700016 app not found, 90002/900023 bad directory, 700038 not a valid app ID
      if ($n -lt 3 -and $why -match 'AADSTS(700016|90002|900023|700038)') { Say ('Microsoft says: ' + $why) 'DarkYellow'; Ask-AppIds; continue }
      throw ('Microsoft sign-in would not start: ' + $why)
    }
  }
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
      throw ('Sign-in did not work: ' + (Get-ErrText $_))
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
    } catch {
      Say ('Your saved sign-in no longer works, so you need to sign in again. (' + (Get-ErrText $_) + ')') 'Yellow'
      Remove-Item -Path $TokenFile -ErrorAction SilentlyContinue
    }
  }
  if ($DeviceCode) { SignIn-DeviceCode } else { SignIn-Browser }
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
      $gcode = ''; $b = Get-ErrBody $_; if ($b -and $b.error -and $b.error.code) { $gcode = [string]$b.error.code }
      $short = $Url; if ($short.StartsWith($GraphRoot)) { $short = $short.Substring($GraphRoot.Length) }
      $q = $short.IndexOf('?'); if ($q -gt 0) { $short = $short.Substring(0, $q) }
      throw (New-GraphError ('Microsoft said ' + (Get-ErrText $_) + '  [' + $Method + ' ' + $short + ']') $code $gcode)
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
  try {
    $me = Invoke-Graph 'GET' '/me?$select=displayName,userPrincipalName,mail'
    Say ('Signed in as ' + (S $me.displayName) + ' (' + (S $me.userPrincipalName) + ')') 'Green'
  } catch {
    if (-not $_.Exception.Data['status']) { throw }   # sign-in itself failed
    Say ('Could not read who is signed in: ' + $_.Exception.Message) 'Yellow'
  }
  Say 'Reading the Contacts folder...'
  # Some mailboxes refuse big pages or the field list, so step down until one works.
  $tries = @(('?$top=100&$select=' + $Select), '?$top=100', '?$top=25', '')
  $q = $null; $first = $null; $lastErr = $null
  foreach ($t in $tries) {
    try { $first = Get-Paged ('/me/contacts' + $t); $q = $t; break }
    catch {
      $lastErr = $_
      Say ('  ' + $_.Exception.Message) 'DarkYellow'
      $st = 0; try { $st = [int]$_.Exception.Data['status'] } catch {}
      if ($st -ne 400) { break }
      Say '  Trying again a simpler way...' 'DarkYellow'
    }
  }
  if ($null -eq $q) {
    $gc = ''; try { $gc = [string]$lastErr.Exception.Data['gcode'] } catch {}
    if ($gc -match 'MailboxNotEnabledForRESTAPI|ErrorInvalidUser|MailboxNotFound|ResourceNotFound|ErrorNonExistentMailbox') {
      Say ''
      Say 'Microsoft says this account has no Exchange Online mailbox it can reach.' 'Yellow'
      Say 'Check you signed in with the account that holds the contacts, and that it has' 'Yellow'
      Say 'an Exchange Online (email) license. Choose 4 to sign out and sign in as another account.' 'Yellow'
    }
    throw $lastErr
  }
  foreach ($c in $first) { if (-not $seen.ContainsKey($c.id)) { $seen[$c.id] = 1; [void]$all.Add($c) } }
  $todo = New-Object System.Collections.ArrayList
  try { foreach ($f in (Get-Paged '/me/contactFolders?$top=100')) { [void]$todo.Add($f) } }
  catch { Say ('Could not list your other contact folders, so only the main Contacts folder was read. ' + $_.Exception.Message) 'Yellow' }
  while ($todo.Count -gt 0) {
    $f = $todo[0]; $todo.RemoveAt(0)
    $folders[$f.id] = $f.displayName
    Say ('Reading folder ' + $f.displayName + '...')
    try {
      foreach ($c in (Get-Paged ('/me/contactFolders/' + $f.id + '/contacts' + $q))) { if (-not $seen.ContainsKey($c.id)) { $seen[$c.id] = 1; [void]$all.Add($c) } }
      foreach ($k in (Get-Paged ('/me/contactFolders/' + $f.id + '/childFolders?$top=100'))) { [void]$todo.Add($k) }
    } catch { Say ('  Skipped folder ' + $f.displayName + ': ' + $_.Exception.Message) 'Yellow' }
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

# v5 safety rules: keep junk from old imports out of Exchange
function Clean-Name([string]$v) {
  $v = S $v
  $v = ($v -replace '\s*\((c|v|l|customer|vendor|lead)\)\s*$', '').Trim()   # Zoho tags such as "(c)"
  if ($v -match '^(?i)([a-z]{1,3})\1+$') { return '' }                   # repeated junk such as "Zxzx"
  if ($v.Length -ge 3 -and $v -match '^[A-Za-z]+$' -and $v -notmatch '(?i)[aeiouy]') { return '' }   # no vowels at all
  return $v
}
function Clean-Notes([string]$v) {
  $t = (S $v) -replace "`r`n", "`n"
  # drop "Contact Imported:" blocks (field dumps from old imports, such as Zoho Record Id lines)
  $t = [regex]::Replace($t, '(?ms)^\s*Contact Imported:\s*\n.*?(?=\n\s*\n|\z)', '')
  $t = [regex]::Replace($t, '(?m)^\s*-{5,}\s*$', '')                        # divider lines
  $t = [regex]::Replace($t, "\n{3,}", "`n`n")
  return $t.Trim()
}

function Build-Patch($row, $c) {
  $patch = @{}; $notes = New-Object System.Collections.ArrayList
  $extraEmails = New-Object System.Collections.ArrayList; $extraPhones = New-Object System.Collections.ArrayList
  $map = [ordered]@{ 'First Name' = 'givenName'; 'Middle Name' = 'middleName'; 'Last Name' = 'surname'; 'Title' = 'title'; 'Suffix' = 'generation'; 'Nickname' = 'nickName'; 'Company' = 'companyName'; 'Job Title' = 'jobTitle'; 'Department' = 'department'; 'Web Page' = 'businessHomePage'; 'Notes' = 'personalNotes' }
  foreach ($k in $map.Keys) {
    $new = Col $row $k; if ($null -eq $new) { continue }
    $prop = $map[$k]; $old = S $c.$prop
    if ($k -eq 'Last Name' -and $old -eq '' -and $new -ne '' -and $new -eq (Col $row 'Company') -and (Col $row 'First Name') -eq '') { continue }
    if ($k -eq 'Notes') {
      $old = $old -replace "`r`n", "`n"; $new = Clean-Notes $new
      # safe mode: never drop what Notes already says; keep it and add only what is new
      if (-not $AllowRemove -and $old) { $oc = Clean-Notes $old; if ($oc -and -not $new.Contains($oc)) { $new = $(if ($new) { $oc + "`n`n" + $new } else { $oc }) } }
      if ((Clean-Notes $old) -ceq $new) { continue }
    }
    if ($k -in @('First Name', 'Middle Name', 'Last Name', 'Nickname')) { $new = Clean-Name $new; if ($new -ceq (Clean-Name $old)) { continue } }
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
      elseif ($om -and $nm -and (Digits $om) -ne (Digits $nm) -and -not (@($nb + $nh) | Where-Object { (Digits $_) -eq (Digits $om) })) {
        # v5: keep the mobile Exchange already has; the new number goes with the other phones
        $nh += $nm; $nm = $om
      }
    }
    while ($nb.Count -gt 2 -and $nh.Count -lt 2) { $nh = @($nh) + @($nb[2]); $nb = @(@($nb | Select-Object -First 2) + @($nb | Select-Object -Skip 3)) }
    while ($nh.Count -gt 2 -and $nb.Count -lt 2) { $nb = @($nb) + @($nh[2]); $nh = @(@($nh | Select-Object -First 2) + @($nh | Select-Object -Skip 3)) }
    if ($nb.Count -gt 2 -or $nh.Count -gt 2) {
      # v5: numbers that don't fit go into Notes instead (safe mode), so none is lost
      if (-not $AllowRemove) { foreach ($p in @(@($nb | Select-Object -Skip 2) + @($nh | Select-Object -Skip 2))) { [void]$extraPhones.Add([string]$p) } }
      $nb = @($nb | Select-Object -First 2); $nh = @($nh | Select-Object -First 2)
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
    if (-not $AllowRemove) {
      # v5 safe mode: the emails Exchange already has stay first, in their order; new ones follow (extras go to Notes)
      $keepFirst = @($oe | ForEach-Object { [string]$_.address })
      $seen = @{}; foreach ($e in $keepFirst) { $seen[$e.ToLower()] = 1 }
      $ne = @($keepFirst) + @($ne | Where-Object { -not $seen.ContainsKey(([string]$_).ToLower()) })
    }
    $oa = @($oe | ForEach-Object { [string]$_.address })
    # v5: emails that don't fit (Exchange holds 3) go into Notes instead (safe mode), so none is lost
    if ($ne.Count -gt 3 -and -not $AllowRemove) { foreach ($e in @($ne | Select-Object -Skip 3)) { [void]$extraEmails.Add([string]$e) } }
    if ($true) {
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
    if ($ok -and $d.Year -gt 1900 -and $d.Year -le ((Get-Date).Year - 5)) {   # v5: a birthday under 5 years ago is a date typed by mistake
      $iso = $d.ToString('yyyy-MM-dd')
      $obd = Date-Part $c.birthday
      if ($iso -ne $obd) { $patch['birthday'] = ($iso + 'T11:59:00Z'); [void]$notes.Add(('Birthday: {0} -> {1}' -f (Show-List @($obd)), $iso)) }
    }
  }

  # v5: extra emails and phones that don't fit go into Notes, unless Notes already has them
  # Any "Other emails:" / "Other phones:" lines are rebuilt so they never repeat what is already in the email and phone fields.
  $base = ($(if ($patch.ContainsKey('personalNotes')) { [string]$patch['personalNotes'] } else { S $c.personalNotes })) -replace "`r`n", "`n"
  $oldNotes = (S $c.personalNotes) -replace "`r`n", "`n"
  $finalEm = @($(if ($patch.ContainsKey('emailAddresses')) { $patch['emailAddresses'] | ForEach-Object { [string]$_.address } } else { @($c.emailAddresses) | ForEach-Object { [string]$_.address } }) | Where-Object { $_ } | ForEach-Object { $_.ToLower() })
  $finalPh = @(@($(if ($patch.ContainsKey('businessPhones')) { $patch['businessPhones'] } else { $c.businessPhones })) + @($(if ($patch.ContainsKey('homePhones')) { $patch['homePhones'] } else { $c.homePhones })) + @($(if ($patch.ContainsKey('mobilePhone')) { $patch['mobilePhone'] } else { $c.mobilePhone })) | Where-Object { $_ } | ForEach-Object { Digits $_ })
  $ee = New-Object System.Collections.ArrayList; $pp = New-Object System.Collections.ArrayList
  foreach ($m in [regex]::Matches($base, '(?im)^\s*Other emails:\s*(.*)$')) { foreach ($x in ($m.Groups[1].Value -split ';')) { if ((S $x)) { [void]$ee.Add((S $x)) } } }
  foreach ($m in [regex]::Matches($base, '(?im)^\s*Other phones:\s*(.*)$')) { foreach ($x in ($m.Groups[1].Value -split ';')) { if ((S $x)) { [void]$pp.Add((S $x)) } } }
  foreach ($x in $extraEmails) { [void]$ee.Add([string]$x) }; foreach ($x in $extraPhones) { [void]$pp.Add([string]$x) }
  $body = [regex]::Replace($base, '(?im)^\s*Other (emails|phones):.*$\n?', '').Trim()
  $seenE = @{}; $eeF = @(foreach ($x in $ee) { $k = $x.ToLower(); if ($finalEm -notcontains $k -and -not $seenE.ContainsKey($k)) { $seenE[$k] = 1; $x } })
  $seenP = @{}; $ppF = @(foreach ($x in $pp) { $k = Digits $x; if ($k -and $finalPh -notcontains $k -and -not $seenP.ContainsKey($k)) { $seenP[$k] = 1; $x } })
  $lines = @(); if ($eeF.Count) { $lines += ('Other emails: ' + ($eeF -join '; ')) }; if ($ppF.Count) { $lines += ('Other phones: ' + ($ppF -join '; ')) }
  $final = $body; if ($lines.Count) { $final = $(if ($body) { $body + "`n`n" } else { '' }) + ($lines -join "`n") }
  if ($final -cne $oldNotes) {
    if ($final -eq '' -and -not $AllowRemove) { $patch.Remove('personalNotes') }
    else {
      $patch['personalNotes'] = ($final -replace "`n", "`r`n")
      $i = -1; for ($j = 0; $j -lt $notes.Count; $j++) { if ([string]$notes[$j] -like 'Notes:*') { $i = $j } }
      $msg = ('Notes: "{0}" -> "{1}"' -f (Short $oldNotes), (Short $final)); if ($i -ge 0) { $notes[$i] = $msg } else { [void]$notes.Add($msg) }
      foreach ($l in $lines) { [void]$notes.Add(('          (Notes keeps "{0}")' -f (Short $l))) }
    }
  } elseif ($patch.ContainsKey('personalNotes')) {
    $patch.Remove('personalNotes'); $tmp = @($notes | Where-Object { -not ([string]$_ -like 'Notes:*') }); $notes.Clear(); foreach ($t in $tmp) { [void]$notes.Add($t) }
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
  if (-not $Path) {
    # v5: use the newest "Changes for Exchange" file in Downloads (or the Exchange folder) without asking
    $cands = @(foreach ($d in @((Join-Path $env:USERPROFILE 'Downloads'), $OutDir)) { if (Test-Path $d) { Get-ChildItem -Path $d -Filter '*.csv' -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)changes.?for.?exchange' } } })
    $newest = $cands | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($newest) {
      $script:Path = $newest.FullName
      Say ('Using your newest Changes for Exchange file: ' + $newest.Name + '  (saved ' + $newest.LastWriteTime.ToString('MMM d, h:mm tt') + ')') 'Green'
    } else {
      Say 'No "Changes for Exchange" file found in Downloads.' 'Yellow'
      Say 'In Contact Workbench, open the Export page and tap "Download changes for Exchange", then choose 2 again.' 'Yellow'
      return
    }
  }
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
  $raw = Get-ErrRaw $_; if ($raw) { Say ('Details: ' + (Get-ErrText $_)) 'Red' }
  Say 'If you ask Claude for help, copy the red lines above and paste them in.' 'Gray'
}
Say ''
Read-Host 'Press Enter to close' | Out-Null
