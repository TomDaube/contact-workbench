# Exchange helper (ExchangeBridge.ps1)

A small Windows PowerShell script that lets Contact Workbench read and change the contacts in **your own** Microsoft 365 (Exchange) mailbox. It signs in on Microsoft's own page (Microsoft Graph, permission "read and write your contacts"). It never touches Zoho, Apple or Google.

## One-time setup
1. In Contact Workbench, open **Export** and tap **Exchange helper (Windows)**. Open the .zip and drag **ExchangeBridge.ps1** to your Desktop.
2. Right-click it and choose **Run with PowerShell** (on Windows 11 it is under **Show more options**).
3. Type **1** (Get). A Microsoft page opens. Paste the code (it is already copied), sign in with your work account, and tap **Accept**. As the admin you may see "Consent on behalf of your organization": leave it unticked. After this, the helper remembers you on this PC.

## Each time
1. **Get**: the helper saves `Exchange-contacts-<date>.csv` in **Documents > Contact Workbench > Exchange**.
2. In Contact Workbench, **Add & Clean Up**: remove any older Exchange or Outlook list, then add the new file. Each contact now remembers its Exchange Id.
3. Clean up, merge duplicates, delete as usual.
4. **Export > Microsoft 365 / Exchange > Download changes**.
5. Run the helper, type **2** (Apply) and pick that file. It backs up every Exchange contact, opens a preview in Notepad, and changes nothing until you type **YES**.
6. Run **Get** again and swap the new file into the app, so it sees Exchange as it is now.

## Safety
- Full backup (CSV and JSON) before any change.
- Safe mode by default: it never removes a phone number, email or address from a contact; it only adds and corrects. `-AllowRemove` lets it remove too.
- Contacts it deletes are saved first to `Exchange-deleted-<date>.json`; choose **3** (Put back) to restore them.
- Sign out any time with **4**.

## Which Microsoft app it signs in with
The helper signs in with Tom's own **Contact Workbench** app registered in his Microsoft 365 (Entra), so no extra arguments are needed:
`powershell -ExecutionPolicy Bypass -NoExit -File "C:\Users\Owner-Pc\Desktop\ExchangeBridge.ps1"`

Someone else can register their own app (App registrations > New registration; Authentication > Allow public client flows = Yes; API permissions > Microsoft Graph > Delegated > Contacts.ReadWrite and User.Read) and add `-ClientId <Application (client) ID> -Tenant <Directory (tenant) ID>`.

## If something goes wrong
Version 2 prints Microsoft's own error code and message (for example `(400) ErrorInvalidRequest: ...`) and which request failed. If reading contacts is refused, it tries again with smaller, simpler requests before giving up. Copy the red lines and send them to Claude.
