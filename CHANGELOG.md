# Contact Workbench change log

Every version of the app and what changed in it, newest first.

## Version 170 (Nov 16, 2026)
- ? Help › Exchange helper has the new steps (run it from PowerShell, sign in in the browser), and a new topic, Exchange helper: one-time Microsoft setup, records the Entra setup and the app’s IDs.

## Version 169 (Nov 16, 2026)
- Exchange helper version 4: signs in on Microsoft's normal page in your web browser, because some Microsoft 365 setups block the code sign-in.

## Version 168 (Nov 16, 2026)
- Exchange helper version 3: if Microsoft does not recognise the app, the helper asks you to paste the Application ID and Directory ID from Microsoft Entra and remembers them.

## Version 167 (Nov 16, 2026)
- Exchange helper version 2: shows Microsoft's own error message when something fails, retries reading contacts in a simpler way if Exchange refuses, says which account is signed in, and signs in with your own Contact Workbench app without any extra typing.

## Version 166 (Nov 15, 2026)
- The Exchange helper is easier to find: it shows on the Export page even before any contacts are added, and ? Help › Exchange helper has a Get the Exchange helper button.

## Version 165 (Nov 15, 2026)
- New Select all button: tap Select above the list, then Select all to tick everyone shown. Then Delete, Archive or Merge them in one go.

## Version 164 (Nov 15, 2026)
- New 💬 button at the top opens the Contact Workbench chat with Claude in a new tab.
- The A–Z letters on the right no longer sit on top of the Windows scroll bar (Lenovo Yoga).
- New Exchange helper (ExchangeBridge.ps1, Windows): Get brings Exchange contacts in with their Exchange Id; Export › Microsoft 365 / Exchange › Download changes lists clean-ups, merged duplicates and deletions; Apply previews, backs up and asks YES before changing anything; Put back restores deleted contacts. Zoho is never touched.

## Version 163 (Nov 15, 2026)
- Format filter: new Only in one (e.g. Only in Exchange) and In one, not the other (e.g. Exchange, not in Zoho) sections, alongside In both.

## Version 162 (Nov 15, 2026)
- New Dark charcoal color in Settings › Appearance › Color (#2b2d31; a softer gray in dark mode).

## Version 161 (Nov 15, 2026)
- Use Zoho contacts is now a calm gray button like the others (no orange, same size as Zoho leads).

## Version 160 (Nov 15, 2026)
- Removed the Start over button (Remove all…) from Settings and from Step 1, so everything can't be wiped by mistake.

## Version 159 (Nov 15, 2026)
- Buttons are a little shorter and no longer bold (Reset, Search, Choose files and the rest).
- New Button size slider in Settings › Appearance (Clean style), 75% to 125%, default 90%.

## Version 158 (Nov 15, 2026)
- Calmer, more consistent buttons in the Clean style: blue for the main action, red text for anything that deletes or removes, soft gray for everything else, one set of sizes. Classic keeps the colored buttons.

## Version 157 (Nov 15, 2026)
- New Clean style, on by default: more white space, hairline borders, quiet buttons, one accent color, in light and dark. Settings › Appearance › Style switches between Clean and Classic.

## Version 156 (Nov 14, 2026)
- Behind the scenes: groundwork so the Personal edition saves each person's contacts in their own private space. Nothing changes in the Work app.

## Version 155 (Nov 14, 2026)
- Two editions. Work edition (orange Work tag) keeps everything: Zoho, Exchange, sales, work contacts. New Personal edition (green Personal tag) is for Apple and Android address books only, with its own separate data. Files: work/index.html, personal/index.html; build-personal.py makes the Personal file from the Work file.

## Version 154 (Nov 14, 2026)
- Export › Apple Contacts: Which contacts (Only my Apple contacts, default / Everyone).
- Export › Back up each source: original CSV of each imported list, grouped by Zoho, Exchange, Google, Apple.

## Version 153 (Nov 14, 2026)
- 💰 Customers with sales (was Has sales): own title with count and combined total; tappable Last sale / Sales / Total headings sort ascending or descending.

## Version 152 (Nov 14, 2026)
- Has sales / sales sort rows: no group buttons; last sale date, number of sales and total on the right of the name line. Last Invoice Date is now kept (was ignored); contact page shows last sale date.

## Version 151 (Nov 14, 2026)
- Sort: Sales highest first / lowest first (no sales last); amount shown in green on each row while sorting by sales.

## Version 150 (Nov 14, 2026)
- Contact page shows Total sales in NetSuite (large green) with number of sales.

## Version 149 (Nov 14, 2026)
- 💰 Has sales list (☰ Views) and Highest sales sort, from Zoho Total Sales / TotSalesInNetsuite / Num of Sales.

## Version 148 (Nov 14, 2026)
- 🗂 Format menu: new In both section (e.g. In both Apple and Zoho) lists people found in both kinds of list.

## Version 147 (Nov 13, 2026)
- Use Zoho contacts shows a status box (connecting, running count, done or the reason it failed).

## Version 146 (Nov 13, 2026)
- Modern Reset button: solid blue with an outlined house icon instead of the 🏠 emoji.

## Version 145 (Nov 13, 2026)
- Import & Combine always opens on step 1, Bring in lists.

## Version 144 (Nov 13, 2026)
- Orange 🟠 Use Zoho contacts button (Contacts only) plus a separate Zoho leads button.

## Version 143 (Nov 13, 2026)
- Import & Combine step 2: Fields in each file and Extra columns are folded panels that start shut (state remembered).

## Version 142 (Nov 13, 2026)
- Advanced mode renamed Import & Combine (was Clean Up & Merge). Steps: 1 Bring in lists, 2 What each list adds, 3 Combine duplicates, 4 Final touches.

## Version 141 (Nov 13, 2026)
- Advanced mode: 🟠 Get from Zoho also sits next to Add more files at the top of Import.

## Version 140 (Nov 13, 2026)
- New 🟠 Get from Zoho button in Add & Clean Up, Step 1: loads Zoho Contacts and Leads straight from Zoho (every field, Zoho Record Id kept) through the Zoho CRM connector. Read-only.

## Version 139 (Nov 13, 2026)
- Search now includes notes automatically: Include notes starts on (✓). Tap it to turn it off.

## Version 138 (Nov 12, 2026)
- The ⟳ Refresh button at the top is larger.

## Version 137 (Nov 12, 2026)
- Notes typed in an address: address boxes holding a note, phone, email or link are spotted (Step 3 check and Step 4 › Notes typed in an address). On the card, Move to notes adds the text to the notes and takes it out of the addresses (asks first; Manage addresses can restore it).

## Version 136 (Nov 12, 2026)
- 🏷 Address labels for Apple (Export › Apple tile, or ⚙ Settings › Contacts): every address label with a count, and what it becomes in the Apple download: Home, Work, Other, keep its own name, or rename it. Used on every Apple download.

## Version 135 (Nov 12, 2026)
- Contact cards have a fold-up panel per file format: 🍎 More from Apple (social profiles, extra dates, maiden name), 📧 More from Exchange / Outlook (Referred By, Assistant and Manager names, Profession, Office location, Hobby, User 1–4…), plus Google, Zoho and spreadsheet panels for kept columns.
- ✏️ Edit has the same panels with editable boxes. Apple changes go back to Apple in the download; kept columns travel in the Excel download.
- Hidden fields now lists only the technical leftovers.

## Version 134 (Nov 12, 2026)
- The 🔍 Hidden fields section shows only on cards that have hidden fields filled in (still open by default).

## Version 133 (Nov 12, 2026)
- The 🔍 Hidden fields section is on every contact card now, open by default. If a contact has nothing hidden, it says so and links to Hidden fields by file. Closing it is remembered.

## Version 132 (Nov 12, 2026)
- 🗂 Format ▾ in Filters and Sort: show only the contacts that came from Apple, Exchange / Outlook, Google, Zoho or another spreadsheet, with a count for each. Works with Groups, Tags and Sort; Reset clears it.

## Version 131 (Nov 12, 2026)
- Add & Clean Up steps fold up: tap a step's title to open or close it. Steps 2 to 4 start closed with a one-line summary, and the app remembers what you opened.
- The Advanced step row (Import, Compare, Duplicates, Options) lines up with the panels below it.

## Version 130 (Nov 12, 2026)
- Hidden fields by file (☰ Views, or 🔍 Hidden fields in Step 1): per list, its format and every field the cards don't show, what the app does with it (kept for Apple, kept as an extra column, or not used), how many contacts have it, and the fields that are shown. Tap a number to see the people and values.
- Every card has a 🔍 Hidden fields section at the bottom (replaces More from Apple).
- Favorites now also appears in ☰ Views.

## Version 129 (Nov 12, 2026)
- Favorites: star anyone with ☆ Favorite on their card; a gold ★ shows by their name; ☰ Views › Favorites lists them; Select bar has ⭐ Favorite / Not favorite. They go to Apple as the Favorites group (Apple's Phone favorites live only on each device and can't be set from a contact file).
- ⟳ Refresh button at the top saves your work and reloads the app.

## Version 128 (Nov 12, 2026)
- Reference contacts: contacts with no phone, email or street address but with notes can go in a Reference group with one tap (on the Left out and No phone or email lists, and in Options). Reference contacts are never marked Left out and drop off the No phone or email list.

## Version 127 (Nov 12, 2026)
- Add & Clean Up ends at Step 4 (Clean up). The old Step 5 download box is gone, and the Advanced steps end at Options, so new lists are for checking and fixing first. Download when you are ready from the Export tab at the top. Its Apple tile now also has Skip contacts marked Left out and Include work contacts.

## Version 126 (Nov 12, 2026)
- Options: Leave them out now skips only personal contacts in the Apple and Google downloads. The Left out button says what Left out means (no phone, email or street address) and whether those people are in your downloads.

## Version 125 (Nov 12, 2026)
- Options (Advanced mode, step 4): the Personal contacts part is rebuilt. It explains what looks personal, lets you edit the words, has Keep them / Leave them out buttons for your Apple and Google downloads, and See them buttons that open those people on Contacts.

## Version 124 (Nov 12, 2026)
- Possible duplicates on Contacts has a Merge all button at the top that merges every group shown at once (it asks first), plus Merge only likely duplicates.

## Version 123 (Nov 12, 2026)
- The Imported lists box on Import now shows one list per row, in the same table as Step 1: name, contacts, new, date added and Remove. Long file names wrap instead of being cut off.

## Version 122 (Nov 12, 2026)
- Step 1 lists table has a New column: how many people first came in with each list. Tap the number to see their names and open their cards.

## Version 121 (Nov 12, 2026)
- Step 1 on Add & Clean Up shows your lists as one table, one row per file: name, number of contacts, date added, group, and Remove. Combine into one list sits at the top of the table.

## Version 120 (Nov 12, 2026)
- Combine into one list also in Settings › Saving and backups and at the top of Import in Advanced mode.

## Version 119 (Nov 12, 2026)
- New: Combine into one list (Add & Clean Up, Step 1). All added lists become one clean list exactly as contacts look now (edits, merges, photos, groups, tags, relations, archive, added dates kept; deleted stay on the do-not-import list). Old list names and Recent changes history go away. Help topic added.

## Version 118 (Nov 12, 2026)
- Step 1 no longer lists every file added: one line with the count and Show the list names. Lists stay because contacts come from them; a warning explains Remove also removes that list's contacts.

## Version 117 (Nov 12, 2026)
- Help rewritten from scratch: 44 short topics in 8 task-based groups (Start here, Finding people, A contact's card, Photos, Adding lists and cleaning up, Groups and tags, Sending to Apple and others, Saving, backups and settings), each matching today's buttons and with a Take me there button.

## Version 116 (Nov 11, 2026)
- Tapping a top tab always opens it at the very top, so Add & Clean Up starts at Step 1.

## Version 115 (Nov 11, 2026)
- Full backup files are named with Full-Backup in the title (e.g. Toms-contacts-Full-Backup-2026-11-11_1304.json).

## Version 114 (Nov 11, 2026)
- Tap the photo at the top of a contact card to see it big. Tap anywhere to close it.

## Version 113 (Nov 11, 2026)
- Buttons are rounded rectangles everywhere instead of ovals and circles (header, +, Speak, Search, Include notes, Filters and Sort, footer, card Message/Call/Copy/Map).

## Version 112 (Nov 11, 2026)
- The Photos filter moved from Filters and Sort to Settings › Contact photos › Show in the contact list (Everyone / Only with a photo / Only without a photo). The Contacts panel count says when it is on; Reset goes back to Everyone.

## Version 111 (Nov 11, 2026)
- Each contact in the list shows a small round photo left of the name (initials when there is none).
- New Photos button in Filters and Sort: with photo, then no photo, then everyone.

## Version 110 (Nov 11, 2026)
- Settings › Contact photos (the first box) now shows two buttons: Add or change photos, and Get photos back from an old file.

## Version 109 (Nov 11, 2026)
- The Apple Contacts box on the Export tab now shows its choices: Include contact photos (on by default), Make Apple lists from my groups, and Put tags in each contact's Notes.

## Version 108 (Nov 11, 2026)
- New: get old contact photos back (Settings › Contact photos › Get photos back from an old file). Pick an older .vcf or .zip with pictures; the app matches them by email, phone or name, shows tick boxes, and adds only the ticked photos. Help topic: Exporting › Getting old contact photos back.

## Version 107 (Nov 11, 2026)
- New 1 line / 2 lines switch in the Contacts panel. 1 line shows each contact on a single line (name, with Groups on the right). 2 lines adds phone and email underneath. The choice is remembered.

## Version 106 (Nov 11, 2026)
- Contacts panel on the home page: the blue Select button sits right up against the top of the panel, the number shown is in small gray type in the middle of that top line, and the empty line of space is gone.

## Version 105 (Nov 11, 2026)
- Call, Message and Email on a contact card now open the Phone, Messages or Mail app on iPhone and iPad. If iOS still blocks it, a sheet pops up with the number or address (already copied), a big button to try again, and Copy.

## Version 104 (Nov 11, 2026)
- The ✨ Ask button on the home page is now 🔍 Search, with the magnifying glass on the left. When you finish typing or speaking your question, it turns green: tap it to search.

## Version 103 (Nov 11, 2026)
- Every contact in the list is now separated by a faint thin line (also in dark mode). Cards view gets a matching faint outline.

## Version 102 (Nov 11, 2026)
- Add & Clean Up numbered 1–5: Add your lists, Done for you, Check step by step, Clean up, Put them in Apple Contacts.

## Version 101 (Nov 11, 2026)
- Clean-up lists are now big buttons in their own 🧹 Clean up box on Add & Clean Up (under Step 3; also on the Import step in Advanced mode), each with its count. The small menu in Step 3 is gone.

## Version 100 (Nov 11, 2026)
- Panel renamed Filters and Sort.

## Version 99 (Nov 11, 2026)
- A to Z elevator bar is top-justified at the right, just under the page title; the ↑ Top button moves left of it.

## Version 98 (Nov 11, 2026)
- 🧹 Clean up menu moved from the Contacts Filter panel to Add & Clean Up › Step 3 (top right).
- Filters panel renamed Filter & sort.

## Version 97 (Nov 11, 2026)
- Notes switch moved inside the search box (right side), labeled 'Include notes' (✓ when on).

## Version 96 (Nov 11, 2026)
- Contacts search box is blank (no placeholder words).

## Version 95 (Nov 11, 2026)
- New Export tab (Contacts | Add & Clean Up | Export). Part 1, your contacts (data): Apple .vcf, Google/Android .csv, spreadsheet .xlsx/.csv, work contacts .vcf, full backup .json, each with Download and Share/email. Part 2, the app (.html, no contacts): Download or Share/email.
- Share/email uses the device share sheet; if not allowed, saves the file and opens an email to attach it.
- Step 4, Settings and the footer now point to Export.
- Help revised: three tabs, new Exporting group (The Export tab, Emailing a file, The app vs. your contacts), updated Apple, Google and backup topics.

## Version 94 (Nov 11, 2026)
- Sources hidden: no Source row on cards; Source:, @@source tags, 'Merged from N records' and 'From file:' lines removed from notes and exports. Settings › Contacts › 'Show where each contact came from' brings them back (S.settings.keepSources).

## Version 93 (Nov 11, 2026)
- iPhone/iPad (and Android): 🎤 Speak opens the keyboard in the search box right away with a short tip, no help pop-up. The ? dictation help shows only on Windows and Mac.

## Version 92 (Nov 11, 2026)
- Contact rows: one line under the name with phone and email on the left and the 👥 Groups drop-down on the right (separate email/phone columns removed).

## Version 91 (Nov 11, 2026)
- A to Z letters now run down the right side as an elevator bar: tap a letter or slide along it; a big letter shows where you are, and the current letter lights up as you scroll.

## Version 90 (Nov 11, 2026)
- 🏠 Reset no longer focuses the search box (keyboard stays closed).

## Version 89 (Nov 11, 2026)
- 🏠 Reset now clears everything and puts the cursor in the search box.

## Version 88 (Nov 11, 2026)
- 📇 Download all my data (backup): everything incl. archived and deleted, restorable. 📇 Download active contacts (Excel): only active contacts. In Settings › Saving and backups, the backup card and Step 4.
- Home list renamed Active contacts (everyone except archived and deleted), also in ☰ Views and the filter pill.

## Version 87 (Nov 11, 2026)
- New ⬇ Download the app button (purple, dashed) in Settings › Download the app and in the footer; saves Contact-Workbench-app-vNN.html with no contacts in it.
- Every data download now starts with 📇 and says 'my contacts', with a green YOUR DATA tag.
- Help: Downloading the app vs. your contacts updated.

## Version 86 (Nov 10, 2026)
- Apple help guide: turning off Google/Outlook contacts on devices is fine now; they stay on their servers for later.

## Version 85 (Nov 10, 2026)
- New Help guide under Sending to Apple: Getting Apple Contacts ready, then replacing them (iCloud as the only source, last backup, download from the app, replace in iCloud, check).

## Version 84 (Nov 10, 2026)
- The 👥 Groups drop-down on each contact is now quiet gray text with no colored fill; it turns blue only while its menu is open.

## Version 83 (Nov 10, 2026)
- The group buttons on each contact row (Business, Person, Customer, Work, other groups) can be one 👥 Groups drop-down instead.
- Settings › Group buttons on contact rows: After an import (default; buttons right after adding a list until ✓ Done grouping), Drop-down, or Buttons.

## Version 82 (Nov 10, 2026)
- Every panel in the app now has its small name tag on its top border: Add & Clean Up steps (Step 1 to Step 4) and boxes, Views sections, Settings sections, Edit form sections, export choices and more. The tag replaces the panel's old title.
- Help: new Panel names topic under Getting started; Looking up a contact now names the Search & Ask panel.

## Version 81 (Nov 10, 2026)
- Panel name tags are smaller and no longer have a white outline; they sit right on the border line.

## Version 80 (Nov 10, 2026)
- Each panel on the Contacts page now has a small name tag sitting on its top border: Search & Ask, Filters, and Contacts (or Archived / Deleted contacts).

## Version 79 (Nov 10, 2026)
- Search panel buttons always fit on one line; on narrow screens Speak shows just the 🎤 and Search notes too becomes Notes. The help text sits below the buttons.

## Version 78 (Nov 10, 2026)
- Business names get a capital at the start of each word (acme plumbing / ACME PLUMBING -> Acme Plumbing), keeping short all-caps words (LLC, IBM), small words (of, and) and names like eBay.

## Version 77 (Nov 10, 2026)
- Nicer search panel: taller search box; Speak, ✨ Ask and Search notes too are matching rounded buttons (Ask blue gradient, green Start when ready; Search notes too outlined blue when on).

## Version 76 (Nov 10, 2026)
- New switch in Settings › Names (on by default): clears first/middle/last when together they equal the company name, so the contact shows as just the company. Turning it off brings the names back.

## Version 75 (Nov 10, 2026)
- Copy and paste contact photos: ⧉ Copy photo / 📋 Paste photo in Edit (paste applies on Save), and ⧉ Copy / 📋 Paste in Settings › Contact photos. Paste also accepts an image copied elsewhere when the browser allows.

## Version 74 (Nov 10, 2026)
- Lighter example text (Dr., Jr.) in the Prefix and Suffix boxes in Edit.

## Version 73 (Nov 10, 2026)
- Contacts set to show the company first also show on one line in the list as "Company, Person".

## Version 72 (Nov 10, 2026)
- Prefix, Middle and Suffix boxes in Edit a little narrower again.

## Version 71 (Nov 10, 2026)
- Business contacts with both a company and a person's name show on the list as "Company, Person" and sort by company.

## Version 70 (Nov 10, 2026)
- Edit: Prefix, Middle and Suffix boxes narrower so First and Last name get more room.

## Version 69 (Nov 10, 2026)
- Department box in the Work section of Edit (under Job title); shown on the card's Work block and exported to Apple (ORG: Company;Department) and Google.

## Version 68 (Nov 9, 2026)
- Contact photos in Edit: photo at the top with Add / Change photo and Remove photo (applies on Save).
- New ⚙ Settings › 📷 Contact photos panel: With a photo / No photo tabs, find by name, Add, Change or Remove (asks first). Pictures are shrunk to a small square JPEG and go to Apple with the export.

## Version 67 (Nov 9, 2026)
- ✕ Clear all filters moved to the bottom right of the Filter panel, on the same row as Clean up.

## Version 66 (Nov 9, 2026)
- 🗑 Deleted has its own section in ☰ Views below 🗄 Archive, described as a do-not-import list.
- Deleted people stay on the do-not-import list even if the file they came from is removed, so new imports always leave them out.

## Version 65 (Nov 9, 2026)
- Archived group names show in ☰ Views › Archive (Archived groups: Work), the Archive page title (🗄 Archive: Work) and on archived contact cards (Archived with the Work group).

## Version 64 (Nov 9, 2026)
- Removed the "Not updated in 3 years" clean-up list and its Check step by step step (Tom: all records were just updated).

## Version 63 (Nov 9, 2026)
- Removed the 🗄 Move to archive button from the Filter panel (Tom asked). Archive via the 🗄 buttons in ☰ Views or Select › 🗄 Archive.

## Version 62 (Nov 9, 2026)
- In ☰ Views, every group with people in it (Customers, Work, Business, Person and each group under Groups) has a small 🗄 button on the right to move that group to the archive (asks first).

## Version 61 (Nov 9, 2026)
- Archiving a group archives the whole group: it leaves the lists up top (e.g. Work leaves ☰ Views › People), and anyone added to it later goes to the archive too.
- Archived groups are listed in ☰ Views › 🗄 Archive and on the Archive page, each with its own Restore button.

## Version 60 (Nov 9, 2026)
- 🗄 Move to archive button at the right of the Filter panel: archives exactly the contacts showing (list, group, tag or search), or lets you pick a group when nothing is filtered.

## Version 59 (Nov 9, 2026)
- New 🗄 Archive: ☰ Views › Move a group to the archive (Work, Customers or any group), or Select contacts › 🗄 Archive. Archived contacts leave lists, searches, clean-up and exports, but nothing is deleted. ☰ Views › 🗄 Archive shows them; restore one from its card, several via Select › Restore, or Restore all.

## Version 58 (Nov 9, 2026)
- On Windows the purple button says 🎤 Voice typing: it puts the cursor in the search box and shows a big "Now press ⊞ Windows + H" reminder. A web page can't press Windows + H itself.

## Version 57 (Nov 9, 2026)
- Speak on Windows laptops: if the browser blocks the microphone or it doesn't start within 3 seconds, the app explains and shows Windows voice typing (Windows key + H). The ? tips now match the device (Windows, Mac, iPad/iPhone, Android).

## Version 56 (Nov 9, 2026)
- Fixed the sticky page title (All contacts) shaking near the top of the screen: it shrinks only after scrolling further and grows back only at the very top.

## Version 55 (Nov 9, 2026)
- ☰ Lists renamed ☰ Views.
- New ⭐ Save view (next to the count, and in ☰ Views): saves the current list, search or question, groups/tags and sort under a name. Saved views are listed at the top of ☰ Views; ✕ deletes one (asks first).

## Version 54 (Nov 9, 2026)
- The ? help button on the search panel moved to the right.
- The Ask button stays blue while typing and turns green (Start) only about a second after typing stops, so it no longer flickers.

## Version 53 (Nov 9, 2026)
- The search box and the Ask box are now one box. Typing narrows the list as before; ✨ Ask (or Speak) sends the same words to Claude as a plain-words question. Return searches when the words match people and asks otherwise. Search notes too moved to the row under the box.

## Version 52 (Nov 9, 2026)
- Removed the Retired feature (button, Edit tick box, labels, and the "(retired)" job title in exports) at Tom's request.

## Version 51 (Nov 9, 2026)
- ✨ Fix addresses only shows when an address needs it. Once fixed, the button goes away on the card and in Edit, and comes back in Edit if an address is changed so it needs fixing again.

## Version 50 (Nov 9, 2026)
- Retired is per person. Nobody is retired until you tap it on their card. Other cards show only a small gray "retired?" link in the Work block instead of the big 🌴 button.

## Version 49 (Nov 9, 2026)
- New 🌴 Mark as retired button in the Work block of the contact card (and a Retired tick box in Edit). Company and job title are kept as Last company / Last job title, the card says Retired · was …, and Apple gets the job title with (retired) after it. Not retired undoes it.

## Version 48 (Nov 9, 2026)
- Look up on the contact card shows what's missing (phone, email, address, job, birthday) and adds Google searches for exactly that.
- New 📋 Paste what you found box in Look up: copy text from a web page, paste it, tap Read it. Claude picks out only this person's phone, email, address, company, job title, website and birthday; you tick what to keep and it fills Edit (Save to keep).

## Version 47 (Nov 9, 2026)
- On the contact card each relation has a blue label you can tap to change the type (e.g. Wife to Daughter) and a red ✕ to remove a wrong link (asks first).
- Relation guesses from notes use the family word right next to the name (daughter Abby, his wife Mary), not the first family word anywhere in the notes.

## Version 46 (Nov 9, 2026)
- In Edit, Spouse / partner sits on the same line as Nickname.

## Version 45 (Nov 9, 2026)
- Addresses missing a city or ZIP is now Addresses to check (🧹 Clean up, and step 8 of Check step by step). It also checks each address against its country: postal code format, house number after the street in Germany and much of Europe, missing US state, and foreign-looking addresses with no country.
- Addresses that need a look show an orange ⚠️ note on the card with a ✨ Fix button.
- ✨ Fix addresses formats addresses for their own country (e.g. Hauptstraße 12, 80331 München, Germany) and can fill in a missing country.
- Addresses in Germany and most of Europe show the postal code before the town.

## Version 44 (Nov 9, 2026)
- New Spouse / partner field next to Nickname in Edit, with a label: Spouse, Wife, Husband, Partner, Girlfriend or Boyfriend.
- While you type, the app looks for that person in your contacts and offers 🔗 Link as wife (husband, partner…). Linking adds the relation on both cards.
- Once linked, the field shows the linked contact's real name. The card shows the spouse or partner, with a Link button when a likely match exists.
- An unlinked spouse or partner name still goes to Apple as a related name.

## Version 43 (Nov 9, 2026)
- Every button that saves contact data now says so (for example ⬇ Download contacts for Apple, ⬇ Download backup of my contacts, ⬇ Download work contacts).
- New Help topic: Downloading the app vs. your contacts. Claude's own Download menu saves only the app (no contacts); the ⬇ buttons in the app save contacts.

## Version 42 (Nov 9, 2026)
- A small red Delete next to Edit at the top of the contact card. It asks before deleting, like the Delete Contact button at the bottom.

## Version 41 (Nov 9, 2026)
- On the contact card, the Previous and Next buttons are centered in the top bar.

## Version 40 (Nov 9, 2026)
- New 🧭 Check step by step: one guided path through every clean-up check, in order (duplicates, look-alike addresses, shared phones or emails, family, email typos, phone numbers, name capitals, missing city or ZIP, notes, work contacts, no phone or email, not updated in 3 years).
- A purple guide bar on the Contacts page shows the step, how many contacts need a look, and a Next button; steps with nothing to do are skipped.
- Add & Clean Up is now four steps: 1 Add lists, 2 Done for you, 3 Check step by step, 4 Download. After adding a list it points you to the next step.
- Re-check existing contacts any time: Add & Clean Up › Start checking, or 🧹 Clean up › Check step by step.

## Version 39 (Nov 9, 2026)
- Contacts with exactly the same name (even a first name only, like Ally) are marked Duplicate? and counted in the possible-duplicates bar, so you can compare and merge them.
- The Add & Clean Up page has a More clean-up list with the same tools as the 🧹 Clean up button, each with its count.

## Version 38 (Nov 9, 2026)
- New ✉️ Check info button on the contact card: opens your mail app with an email listing that person's details and simple steps to correct them and reply.
- When they reply, tap Check info › Paste their reply and paste the email. The app lists each change to tick, then fills them into Edit. Nothing is saved until you tap Save.

## Version 37 (Nov 9, 2026)
- ✨ Fix addresses now looks up a missing ZIP code (and a missing state or city) and fills it in. Filled-in boxes are marked in orange with a link to the USPS ZIP lookup so you can double-check.

## Version 36 (Nov 9, 2026)
- Text is one size on the contact card and in Edit, so names, phones, emails, addresses and the other boxes match.
- New Work section (Company, Job title, Website) on the card and in Edit.
- Birthday and anniversary have their own Birthday & dates section.

## Version 35 (Nov 9, 2026)
- When editing a contact, Tab moves to the next box (First, Middle, Last, Suffix, Nickname and on), Shift+Tab goes back, and buttons are skipped.
- On the iPad and iPhone on-screen keyboard, Return says next and jumps to the next box.

## Version 34 (Nov 9, 2026)
- ✨ Auto rewrite notes now puts an empty line between unrelated topics, so each topic stands apart.
- Empty lines between paragraphs in notes are now kept when you save, instead of being squeezed out.

## Version 33 (Nov 9, 2026)
- New ✨ Fix addresses button on the contact card (address section) and in Edit. It splits a whole address typed on one line into street, city, state and ZIP, fixes ALL CAPS, state names and ZIP format, and has Claude check spelling. You see before and after; anything filled in is flagged; nothing is saved until you tap Save.

## Version 32 (Nov 9, 2026)
- As soon as words are in the Ask box (spoken or typed), the Ask button turns green and says Start. Tap it to run your question.

## Version 31 (Nov 9, 2026)
- A small ? button next to Speak opens a pop-up with tips for talking to Ask: the keyboard 🎤, the 🎤/F5 key, or pressing Control twice. It also pops up by itself when Speak can't listen.

## Version 30 (Nov 9, 2026)
- Groups & Tags is no longer a tab at the top: you pick groups and tags from the Groups and Tags buttons on the Contacts page.
- To rename, delete or add people to a group or tag, tap Manage groups… or Manage tags… inside those pickers (also in the ☰ Lists menu).

## Version 29 (Nov 9, 2026)
- The voice button next to Ask is now a bright purple-blue 🎤 Speak button, and it pulses red while listening.

## Version 28 (Nov 9, 2026)
- After you save a contact, its Close button turns green and reads ✓ Saved · Close.
- The 🏠 button in the top bar is now 🏠 Reset: it clears every filter, group, tag, list, search and question and goes back to all contacts.
- New 🎤 button next to Ask: speak your question. If the microphone is not allowed here, it opens the keyboard so you can use its 🎤 dictation.

## Version 27 (Nov 9, 2026)
- New 🧹 Clean up menu next to Sort on the home page, with seven lists: no phone or email, phone numbers to check, same phone or email on two people, names in ALL CAPS or lowercase, addresses missing a city or ZIP, not updated in 3 years, and notes to tidy. Each shows how many contacts it has.

## Version 26 (Nov 9, 2026)
- New ✨ Ask box under the search box: type a question in plain words, such as plumbers in Virginia or last name Paul in Arkansas, and tap Ask. Claude turns it into a filter and the list shows the matches. Only your question and your group and tag names are sent, never your contacts.

## Version 25 (Nov 9, 2026)
- Message and Call buttons try harder to open Messages and the phone call on iPad and iPhone, and always copy the number so you can paste it if the app does not open.
- Settings now comes before Help in the top bar.

## Version 24 (Nov 9, 2026)
- The Edit screen has new Phone and Email sections like Apple Contacts: one row per number or address, a label you tap to change (Mobile, Home, Work, Fax, Other), a red − to remove (it asks first) and a green + to add another.

## Version 23 (Nov 9, 2026)
- Phone and email rows on the contact card now look more like Apple Contacts: a gray label above the number or address, and round Message, Call, Email and Copy buttons on the right of each row.

## Version 22 (Nov 9, 2026)
- The Groups list on the home page now ends with Ungrouped: tick it to see the contacts that are in no group at all.

## Version 21 (Nov 9, 2026)
- Settings › Notes: Show contacts with notes that may need to be updated or revised. It lists contacts whose notes have run-on text, repeats, stray symbols, ALL CAPS or are very long.

## Version 20 (Nov 9, 2026)
- Version numbers are now whole numbers. This is version 20 (it follows 18.1).

## Version 18.1 (Nov 9, 2026)
- The ✨ Auto rewrite notes button now sits just above the Notes, on the contact card and the Edit screen.

## Version 18.0 (Nov 9, 2026)
- The Edit screen now shows a Source section too, right below Related to, the same order as the contact card.

## Version 17.9 (Nov 9, 2026)
- On the contact card, Source now sits below Related.

## Version 17.8 (Nov 9, 2026)
- New ✨ Auto rewrite notes button on the contact card and the Edit screen. Claude rewrites the notes so they read clearly, keeping every fact, and shows you the result first. Tap Use this, then Save, to keep it.

## Version 17.7 (Nov 9, 2026)
- Tags are no longer made automatically from words in notes (you can turn this back on in Settings). Tags you made yourself, and ##tags typed in notes, stay.
- Service tags (Service, Service people and the like) are removed everywhere.
- Labels that name where a contact came from (iPhone, Google, Outlook, iCloud, Imported…, file names) now show under Source instead of Tags.

## Version 17.6 (Nov 9, 2026)
- On the contact card, Tags moved up to sit right below Groups.

## Version 17.5 (Nov 9, 2026)
- The search box always reads Search name, phone, email or address. Searching notes is shown only by the Search notes too button.

## Version 17.4 (Nov 9, 2026)
- Address labels (Work address, Home address…) are now gray, so they stand apart from the address itself.

## Version 17.3 (Nov 9, 2026)
- On the contact card, address labels now read Work address, Home address and so on, in larger type.
- The Map button sits at the top right of each address.

## Version 17.2 (Nov 9, 2026)
- On the Edit screen, the Notes box now grows to show the whole note, so there is no small window to scroll inside.

## Version 17.1 (Nov 9, 2026)
- The Notes button in the search box now reads ✓ Search notes too.

## Version 17.0 (Nov 9, 2026)
- On the Edit screen, the + Add address button stays hidden while an address block (usually Home) is still empty. It comes back once you type into it.

## Version 16.9 (Nov 9, 2026)
- The search box now sits above the Filter box on the home page.
- Search notes is now a Notes button inside the search box: tap it to include notes in the search.

## Version 16.8 (Nov 9, 2026)
- The Sort button now opens a small menu of its own instead of the iPad's built-in picker, so the screen no longer goes dark. Tap outside the menu to close it.

## Version 16.7 (Nov 9, 2026)
- The Groups and Tags pickers now open below the app header, so the header (Home, Lists, Help, Settings, section tabs) stays visible. Tapping anything in the header closes the picker.

## Version 16.6 (Nov 9, 2026)
- The Groups and Tags pickers now have a clear ‹ Back button at the top left, so you can always get back to your contacts without picking anything. Clear only shows once something is picked.

## Version 16.5 (Nov 9, 2026)
- New Sort button next to Groups and Tags on the home page: Last name, First name, Company, Newest added or Recently updated. Your choice is remembered on this device. The old Sort by box lower down was removed.

## Version 16.4 (Nov 9, 2026)
- Notes now end with a tidy block in this order: &&groups, then ##tags, then @@sources, each on its own line. Tokens typed anywhere in the notes are gathered into that block.

## Version 16.3 (Nov 9, 2026)
- Tags now sit right above Notes on the contact card.

## Version 16.2 (Nov 9, 2026)
- Notes moved to the bottom of the contact card, below tags, groups and relations.

## Version 16.1 (Nov 9, 2026)
- New relation type: Colleague. Pick it under Related to on the Edit screen; it shows as Colleague on both cards.

## Version 16.0 (Nov 9, 2026)
- Notes now use ##Tag for tags, &&Group for groups and @@Source for where a contact came from. Hyphens stand for spaces (##Custom-design, &&Golf-Club, @@Linda-iPhone).
- Older #Tag and &Group notes still work and are switched to the new form automatically.
- Downloads write ##tags into notes instead of a separate "Tags:" line.

## Version 15.9 (Nov 9, 2026)
- Each contact shows where it came from as a Source, not a tag: 📥 source row on the card and a notes line like "Source: Linda iPhone, Google 2024".
- Tags that were really sources (Google "Imported on …" labels, file names) move to Source; Google's "* myContacts" label is dropped.
- Rename a source on its list in Add & Clean Up (📥 Source box). The Source line goes out in downloads and is read back on re-import.

## Version 15.8 (Nov 9, 2026)
- Filter colors: Groups/Tags buttons gray when nothing picked, light blue when something is; each picked group or tag chip is darker blue (red when hidden).

## Version 15.7 (Nov 9, 2026)
- A contact with a company but no first name shows the company first (card and list); the Show first switch still overrides.

## Version 15.6 (Nov 9, 2026)
- Contact card restyled like Apple Contacts: gray background, white rounded sections, small label (mobile, work, email, home) above each value, tappable phone/email in blue.
- Delete Contact moved to the bottom in red (still confirms).

## Version 15.5 (Nov 9, 2026)
- Edit: Prefix, First, Middle, Last and Suffix on one line; Middle box is narrow and grows as you type.

## Version 15.4 (Nov 9, 2026)
- Contact card shows the full name: prefix, first, middle, last (and suffix), e.g. Dr. John Q. Smith, Jr.

## Version 15.3 (Nov 9, 2026)
- Fixed: the 14.8 notes clean-up could drop #hashtags and &groups sitting next to repeated text. They are always kept now, each once.

## Version 15.2 (Nov 9, 2026)
- Contact card switch "Show first: 👤 Person / 🏢 Company" (for contacts with a name and a company).
- Company first shows and sorts by company name with the person underneath, and exports X-ABShowAs:COMPANY so Apple Contacts shows it as a company.

## Version 15.1 (Nov 9, 2026)
- The Email button (and tapping an email address) opens your mail app with a new message. If the device blocks it, the address is copied to paste.

## Version 15.0 (Nov 9, 2026)
- On the contact card, the group button now reads "+ Add / modify groups".

## Version 14.9 (Nov 9, 2026)
- On the contact card, the tag button now reads "+ Add / modify tags".

## Version 14.8 (Nov 9, 2026)
- Notes: much stronger clean-up of repeated blocks. Any run of six or more words already in the notes is removed, even when copies were glued together with no line breaks or punctuation. Old "Merged from…/From file…" and "Last updated" text stuck inside notes is cleared and rebuilt once.

## Version 14.7 (Nov 9, 2026)
- Work is just a group: tap 💼 Work on a contact or pick Work in 👥 Groups. No more guessing who might be work; Personal labels removed.
- Addresses: a city stuck on the street line (e.g. "Ashburn" above the street, or "Ashburn, VA 20147" typed as the street) moves to City/State/ZIP.
- Exactly-matching addresses always merge, even without a house number and on hand-edited contacts.
- Notes: repeated sentences in long run-on notes are removed; Google ::: separators become new lines; the "From file:" merge note no longer lists addresses that were merged.

## Version 14.6 (Nov 9, 2026)
- Removed the row of lists (All, To review, Customers, Work, Business, Person, Ungrouped) from the top of Contacts; use the 👥 Groups filter instead.
- Those lists are still in the ☰ Lists menu; when one is open a small List chip shows with ✕ to go back to All.

## Version 14.5 (Nov 9, 2026)
- Group and tag filtering rebuilt from scratch, shopping-site style. On Contacts, tap 👥 Groups ▾ or # Tags ▾ and tick what you want to see.
- Several ticked groups show people in any of them (switchable to every ticked group); groups plus tags show only people matching both.
- Hide leaves a group or tag out. Each shows how many contacts would match.
- The filter reads as a sentence under the buttons; ✕ removes any part. Replaces the v14.3 AND/OR/NOT pills.

## Version 14.4 (Nov 9, 2026)
- Each page (Contacts, Groups & Tags, Add & Clean Up) keeps its title fixed at the top while you scroll.
- On Contacts the fixed title also shows how many are showing when a list, search or filter is on.

## Version 14.3 (Nov 9, 2026)
- Groups and tags work as filters you can combine: tap ＋ Filter by group or tag on the Contacts screen.
- Each group or tag has Has it and NOT buttons that show how many contacts you'd see after tapping.
- With two or more filters, choose ALL (AND) or ANY (OR); tap the AND/OR word between filters to switch.
- Tap a filter to flip it to NOT; ✕ removes it. The total that match shows next to the filters.

## Version 14.2 (Nov 9, 2026)
- Tapping a contact now opens the card every time, even while the list is still scrolling.
- Smaller Business/Person/group/Customer/Work buttons under each name, plus a › arrow on each row, so taps open the card instead of pressing a button by mistake.
- After closing a card, the list no longer jumps under your finger.
- In Cards view the tick boxes only show after you tap Select.

## Version 14.1 (Nov 9, 2026)
- Tap a name in Groups & Tags to open that contact card.
- In the People picker, tap a name to see the card; ‹ Back returns to your ticks.

## Version 14.0 (Nov 9, 2026)
- New Groups & Tags section in the top bar (Contacts | Groups & Tags | Add & Clean Up).
- Switch between Groups and Tags; each row shows who is in it, with Show, People, Rename, Delete.
- People picker: tick contacts to add or remove them, then Save.
- New, Find, order (A–Z / Most used), tick several to Merge or Delete, change history with Undo.
- Contacts screen keeps a simple "Pick a group / Pick a tag" line.

## Version 13.3 (Nov 9, 2026)

- Groups and Tags are now separate choices in the Show panel: tap Groups or Tags to switch. Only the chosen one shows, with its own Find box, A–Z / Most used order and Manage button. A dot on the other means it has a filter on.

## Version 13.2 (Nov 9, 2026)

- View as: the List / Cards / One by one / Similar buttons are replaced by one View as selector next to Sort by, with List, Cards and One at a time. Possible duplicates and Related contacts are in Lists.

## Version 13.1 (Nov 9, 2026)

- Find box in the Show panel: type part of a name and the Groups and Tags rows shrink to just the matches, as you type.
- Order switch next to it: A–Z, or Most used (biggest groups and tags first).

## Version 13.0 (Nov 9, 2026)

- Service is removed everywhere, as a tag and as a group, so it no longer shows in the Show panel. Undo is under Manage › Tag changes or Group changes.

## Version 12.9 (Nov 9, 2026)

- On a phone, Contact Workbench and the version have the top line to themselves; the Home, Address books, Lists, Help and Settings buttons sit on the line under it. The footer matches: name and version first, then the address book and save status underneath.

## Version 12.8 (Nov 9, 2026)

- The app no longer tags people Service provider automatically, and the Service provider tag is removed from every contact and from the Tags row. To get it back: Manage tags › Tag changes › Undo.

## Version 12.7 (Nov 9, 2026)

- The Saved pill is gone from the top bar. The save status is in the footer instead: green when your contacts are saved, red if something went wrong. Tap it to save right away.

## Version 12.6 (Nov 9, 2026)

- On iPhone and iPad, the Business, Person, group, Customer and Work buttons now sit on their own line under each name in the contact list, so none are cut off. On a wide screen they stay at the right.

## Version 12.5 (Nov 9, 2026)

- The contacts screen now opens on All contacts, and Home and Clear all filters bring you back to it. All is first in the Lists row; To review is still there for just the unsorted ones.

## Version 12.4 (Nov 9, 2026)

- Related moved off the contacts screen. It is now Related contacts in Lists, under Clean up, with the number still to confirm.

## Version 12.3 (Nov 9, 2026)

- New footer at the bottom of every screen: the version (tap for What's new), which address book is open and how many contacts it has, when it was last saved, quick links (Home, Lists, Address books, Help, Settings, Back up, Top), and a note that your contacts stay private.

## Version 12.2 (Nov 9, 2026)

- The Tools row is gone from the contacts screen. Birthdays and anniversaries, Missing info, Email typos, Recent changes and Work to confirm are all in Lists, under Clean up, Keep in touch and History.

## Version 12.1 (Nov 9, 2026)

- New 🏠 Home button at the top: one tap clears every filter, search and open panel and takes you back to To review.
- When anything is filtered, a ✕ Clear all filters button shows at the top of the Show panel and does the same thing.

## Version 12.0 (Nov 9, 2026)

- A cleaner way to browse. One Show panel at the top of My contacts has three rows: Lists (To review, Customers, Work, Business, Person, Ungrouped, All, Deleted), Groups and Tags. Each is a pill with a count; tap to show those contacts, tap again to undo. Pick a list, a group and a tag together to narrow down; a line underneath says what is showing, with Clear.
- Manage sits at the end of the Groups and Tags rows. Long rows show the first 10 with + more.
- Cleared up: the top bar is just Contacts and Add & Clean Up; the second filter bar, the Tag and Group drop-downs, and the Tags, Work, Customers and Groups chips are gone. The remaining chips are tools: Work to confirm, Dates, Missing info, Email typos, Changes.

## Version 11.1 (Nov 9, 2026)

- Lists › Groups now starts with Manage groups (rename, merge or delete), just like Manage tags under Tags.

## Version 11.0 (Nov 8, 2026)

- Manage groups: the Groups panel is now a table, like Tags. Rename a group, delete it (it asks first; the contacts stay), or tick two or more and Merge them. Changes stick even if a file or note would bring the old name back, and &Group words in notes follow along. Undo any of them under Group changes.
- Customer, Work, Business and Person are built in: they can't be renamed or deleted, but other groups can be merged into them.

## Version 10.9 (Nov 8, 2026)

- New Ungrouped list: everyone who is in no group at all (not Customer, Work, Business, Person or any other group). It is on the top bar, in the list filter, and in Lists. Put someone in a group and they drop off it.

## Version 10.8 (Nov 8, 2026)

- Business and Person now have their own lists, like Customers and Work. Tap Business or Person on a contact and they move off the Contacts list into that list. Tap it again to move them back.
- New All contacts button at the top shows everyone in one list. The top bar reads Contacts, Customers, Work, Business, Person, All contacts, Add & Clean Up; on a phone, swipe it sideways. They are in Lists too.

## Version 10.7 (Nov 8, 2026)

- New Look up button on each contact card. It lists Whitepages (by name and city, and by each phone number), Google, LinkedIn, USPS and Google Maps, each already filled in with this person. They open in a new tab; nothing is sent anywhere or changed until you add it with Edit.

## Version 10.6 (Nov 8, 2026)

- New Business and Person buttons on each row of the contact list (and in Cards view), to the left of the group labels. Tap one to put the contact in that group; tap again to take them out. Choosing one clears the other. They work like any group in Lists, Groups and exports.

## Version 10.5 (Nov 8, 2026)

- The contact list now shows every group a contact is in, instead of two and a +2. The extra group labels wrap onto a second line when there is no room.

## Version 10.4 (Nov 8, 2026)

- Contacts tagged Deceased show a quiet gray 🕊 Deceased banner at the top of their card, and their picture turns gray.

## Version 10.3 (Nov 8, 2026)

- The 📒 button at the top now holds the address book's name inside it, so the name no longer overlaps the buttons on an iPad.

## Version 10.2 (Nov 8, 2026)

- Address books: keep separate address books for different people, like Tom, Linda or Joe. Tap 📒 at the top, type a name, and tap Put this one away and start new. The open one is saved exactly as it is (merges, edits, tags, deleted list) and the app is cleared for the other person's lists. Tap 📒 and Open to switch back; the one you were in is put away in its place.
- The 📒 button shows whose address book is open. Exported files and backups start with that name, for example Lindas-contacts-Apple-Contacts.
- New Help page: Work on someone else's address book.

## Version 10.1 (Nov 8, 2026)

- New Download for Google / Android button next to the Apple one. It makes a CSV in Google Contacts' own layout: groups become Google labels, birthdays, anniversaries, relatives, websites and address labels go in Google's own fields.
- A setting on the Export tab also turns tags into Google labels (otherwise they go in the notes).
- New Help page: Use the app with Android or Google Contacts.

## Version 10.0 (Nov 8, 2026)

- The Edit button on a contact card is now orange with a pencil, so it stands out from the contact's name next to it.
- While you are editing, the top of the screen says Editing in an orange label, followed by the contact's name. On a phone the top Save button is shortened to Save so the name fits.

## Version 9.9 (Nov 8, 2026)

- iPhone fix: on a contact card and in Edit, the bar at the top (Close, Edit, Cancel, Save) no longer slides off the top of the screen. It now stays fully in view while you scroll.

## Version 9.8 (Nov 8, 2026)

- Last updated: every contact's notes now end with when the record was last changed, whether by you in the app, in Apple Contacts, or by adding a file. It shows on the contact card and in Edit, and goes out in the Apple export as a Last updated line in the notes. It is refreshed each time, never repeated. Turn it off in Settings under Add a Last updated line to notes.

## Version 9.7 (Nov 8, 2026)

- Recent changes: every change now has its own Reset button that undoes just that one change and leaves everything else as it is. It keeps working after you close and reopen the app. A reset is listed too, so you can reset the reset if you change your mind. Resetting an Added file entry removes that file.
- Recent changes now has its own place near the top of the ☰ Lists menu.

## Version 9.6 (Nov 8, 2026)

- Search notes: tick Search notes too under the search box, and the search also looks inside every contact's notes. Under each name you see the part of the note that matched, with your words highlighted. The app remembers your choice.

## Version 9.5 (Nov 8, 2026)

- Search now looks in addresses too: street, apartment, city, state, ZIP and country. Type part of a street (12 Oak), a town, a ZIP code, or a state by its code or full name (VA or Virginia).

## Version 9.4 (Nov 8, 2026)

- The app has its own logo: two faded contact cards coming together into one clean card, with a sparkle for a tidy address book. It shows next to the name at the top of the app. Logo files are in contact-workbench/logo (SVG, 512 and 180 pixel PNG).

## Version 9.3 (Nov 8, 2026)

- Manage tags: the Tags panel now lists every tag with how many contacts have it, and buttons to Rename or Delete it. Tick two or more tags and tap Merge to make them one tag (you choose the name), or Delete picked. Changes stick: a renamed or deleted tag stays that way even if a rule or a note would make it again, and #hashtags in notes are renamed or removed to match. Each change is listed under Tag changes, with Undo.
- The ☰ Lists menu has Manage tags at the top of Tags.

## Version 9.2 (Nov 8, 2026)

- New ☰ Lists menu at the top. It has one entry for each main list (Contacts, Customers, Work, Everyone, Possible duplicates, Merged, Missing info, Name only, Birthdays and anniversaries, Email typos, Deleted, Recent changes), with how many are in each. Below them, Tags and Groups each fold open to show every tag and every group. Tap any entry to go straight to that list.

## Version 9.1 (Nov 8, 2026)

- Notes clean themselves up: on every contact, lines that appear more than once (or are already part of a longer line) are taken out automatically, including notes you typed in Edit. It is on by default. Turn it off in Settings under Remove repeated lines in notes automatically. The Remove repeats button in Edit still works for one contact at a time.

## Version 9.0 (Nov 8, 2026)

- Dates: a new 🎂 Dates button above the list shows birthdays and anniversaries coming up in the next 7, 30 or 90 days, soonest first, with how many days away and the age or number of years. Tap a name to open the card.
- Missing info: a new button shows contacts with no phone and no email, so you can fill them in or delete them. A second choice narrows it to Name only (no phone, email or address).
- Email typos: addresses that look mistyped (gmial.com, yaho.com, hotmail.con and the like) are found for you. Tap Fix to correct one, Fix all for every one, or Not a typo to leave it. Fixes show everywhere and in every export, and Undo fix puts the old address back.
- Save one group: in Groups, each group has a Save button that saves just that group as an Apple file (.vcf).
- Recent changes: a 🕘 Changes button lists what you merged, edited, deleted, marked or fixed, newest first, with the time. Undo takes you back to how things were just before that change (it also undoes anything you did after it) and always asks first.

## Version 8.9 (Nov 8, 2026)

- Stray colons such as ::: are taken out of every address (street, city, state, ZIP, country and label), in what you see, in Edit and in every export. An address that was nothing but colons is dropped.

## Version 8.8 (Nov 8, 2026)

- The round ✕ in the search box is now a button that says Clear.

## Version 8.7 (Nov 8, 2026)

- A round Top button (↑) appears at the bottom right whenever you have scrolled down, on every page and inside open contact cards and Edit. Tap it to jump back to the top.

## Version 8.6 (Nov 8, 2026)

- Pick the addresses to merge or delete yourself. In Edit, each address has a tick box. Tick two or more and tap Merge picked to make them one (the fullest one is kept and the others fill in anything it is missing), or tick any and tap Delete picked. Tap Save to keep it, or Cancel to undo.
- Addresses you have arranged by hand in Edit are left exactly as you saved them. The app no longer merges them again on its own.
- On the contact card, the button is now called Change, merge or delete addresses and opens Edit at the addresses. The old Merge duplicate addresses button is gone.

## Version 8.5 (Nov 8, 2026)

- Remove a phone number everywhere: type the number in the search box and tap Remove from every contact. It is taken off every contact's phone list and out of their notes, and it stays gone when you add files again. Removed numbers are listed on the Deleted page, where Put back undoes it.

## Version 8.4 (Nov 8, 2026)

- Deleted records have their own list. They no longer show under the main contacts list. Tap Deleted next to Everyone to see them, restore any, or delete them for good. The Blocked list is there too. The search box also works on this list.
- The search box has a clear button (✕) on its right side whenever something is typed in it. Tap it to empty the search and show everyone again.

## Version 8.3 (Nov 8, 2026)

- New setting: Merge duplicate addresses on each contact. It is on unless you turn it off. When it is off, repeated addresses stay as they are and the Merge duplicate addresses button on a card does the merging only when you tap it.
- The contact list shows each person's groups (Family, Repair and so on) as small tags just left of the Customer button. Tap a group tag to see everyone in that group.

## Version 8.2 (Nov 8, 2026)

- Better at finding the same address twice on one card: Virginia and VA (and every other state name) now count as the same, an entry with only a city, state or ZIP is folded into the full address it belongs to, and contacts you edited by hand now get their repeated addresses merged too.
- Contact cards with two or more addresses have a Merge duplicate addresses button. It merges every look-alike on that card in one tap and tells you how many it merged, or that they are all different.

## Version 8.1 (Nov 8, 2026)

- Clean up notes: in Edit, the new Remove repeats button next to Notes takes out lines that appear more than once (or are already contained in a longer line), and tells you how many it removed. Tap Save to keep it, or Cancel to undo.
- Possible duplicates: two or more contacts with the same name and the same phone number are flagged. They show a Duplicate? tag in the list, a banner at the top of Contacts says how many, and in the Similar view they come first, marked Same name and phone, with Merge all ready to tap.

## Version 8.0 (Nov 8, 2026)

- People you delete can't come back by accident. Anyone on the Deleted list is blocked: if a file you add has them again (same email, or same name and phone), they are left out and the message says how many. Delete for good now keeps a short Blocked entry (name, email, phone) so they stay blocked; tap Allow again if you ever want one back. Check files also marks them as deleted earlier.
- Work contacts get the &Work group, and customers the &Customer group, in their notes. It shows in the Notes on the card and goes out to Apple. A contact that arrives with &Work in its notes is treated as work.
- Customers button next to Work at the top of the review list.
- The list keeps your place: after you open, edit or step through contacts and close, the list scrolls back to the contact you were on, even after the app is reopened.

## Version 7.9 (Nov 8, 2026)

- Customers have their own list, like Work. The switch at the top is now Contacts · Customers · Work · Add & Clean Up. When you tap Customer on someone in Contacts, they leave the review list and move to Customers. Tap ✓ Customer there to move them back. Someone who is both a customer and a work contact shows in both lists. Everyone still shows all your contacts together.

## Version 7.8 (Nov 8, 2026)

- Work contacts have their own place. The switch at the top is now Contacts · Work · Add & Clean Up. Contacts shows everyone except work contacts, so when you tap Work on someone they leave the list straight away. Work shows only your work contacts, with the same search, A to Z, cards and buttons; tap 💼 Work on someone there to move them back. Everyone (in the filter row) still shows both together.

## Version 7.7 (Nov 8, 2026)

- Contact cards have bigger, more button-like buttons: Call, Email, Map, Copy and Delete are larger with a soft shadow, and Add a tag, Mark as work, Add to a group, Add a relation and Change addresses are solid, taller buttons instead of thin dashed outlines. Close, Previous, Next and Edit at the top are now real buttons (Edit in blue), tags you already have are solid blue, and the other buttons further down the card are bigger too.

## Version 7.6 (Nov 8, 2026)

- The contact list now fits the screen on an iPad: long email addresses are shortened with … (tap the contact to see it all), and the Customer and Work buttons always stay fully on screen at the right.
- The top and bottom Save changes buttons in the Edit screen now look the same: green, same size. Cancel matches too.
- Bigger, taller buttons at the top: Close, Edit, Save, Cancel and Previous/Next on contact screens, the view switches (All, Work, List, Cards…), and the Tags, Work and Groups buttons.

## Version 7.5 (Nov 8, 2026)

- The A to Z letters above the contact list are bigger and spread across the full width, so they are easier to tap. On a phone they sit in two rows.

## Version 7.4 (Nov 8, 2026)

- New Customer group with its own button, just left of Work, on every contact in the list and card views. Tap Customer to add that person to the Customer group; tap it again (it then shows ✓ Customer) to take them out. When you select several contacts, the bar has Customer too. The group works like any other: it shows under Groups, in the Group filter, and goes out to Apple as &Customer in the notes.

## Version 7.3 (Nov 8, 2026)

- Work button on the right of every contact in the list and card views. Tap Work to make that person a work contact; tap it again (it then shows 💼 Work) to undo. Suggested work contacts show Work? so they stand out.
- When you select several contacts, the bar now has Mark as work and Not work, so you can mark a whole group at once.

## Version 7.2 (Nov 8, 2026)

- Check files: you can now pick several CSV, Excel or .vcf files at once. Results open on the New tab (records not in your contacts yet), show which file each record came from, and New and Maybe records can be saved as a CSV with Download as CSV.

## Version 7.1 (Nov 8, 2026)

- Check a file: on Add & Clean Up, tap Check a file without adding it and pick any list. The app compares every record with your contacts and shows which are already in (same email, same name and phone, or an exact copy), which may be in (same phone or same name only), and which are new. Already-in records that carry something you don't have yet, like an extra phone or email, are flagged. Nothing is added unless you tap Add the new ones or Add the whole file.

## Version 7.0 (Nov 5, 2026)

- New, cleaner look in the style of Apple's own apps: system font, light gray background with white rounded panels, soft tinted buttons, and a large Contacts title.
- Simpler header: just the app name, Contacts / Add & Clean Up, and round Help and Settings buttons. The record counts and Home button are gone (tap the app name to go home).
- My contacts is simpler: one search bar at the top of the list, letter headings (A, B, C…) like the Contacts app, last names in bold, and a Select button that shows tick boxes only when you want to merge or delete several. Similar and Related live in the view switch only.
- Contact cards have round Call, Email, Map, Copy and Delete buttons like the iPhone, and plain Close / Edit at the top.

## Version 6.9 (Nov 5, 2026)

- Contacts whose notes contain your NetSuite link (https://213155.app.netsuite.com/app) are marked as work automatically, with no need to confirm. They move to the work list and Work-Contacts.vcf and are left out of the personal Apple export. You can add more links or text in Settings › Contacts › Notes text that always means work. Marking one Not work still wins.

## Version 6.8 (Nov 5, 2026)

- Duplicate records are no longer imported (new default). When you add a list, any contact that is exactly the same as one already in, or repeated inside the same list, is left out, and a message says how many were skipped. A list with nothing new is skipped completely. Turn this off in Settings › Contacts to get the warning and choice from 6.7 instead.

## Version 6.7 (Nov 5, 2026)

- Warning when a file was already imported: if you add a file with exactly the same contacts as one already in, a file with the same name, or a file whose contacts are mostly already in, the app tells you which file and when it was imported, and asks whether to skip it or import it anyway.

## Version 6.6 (Nov 5, 2026)

- Merge selected: tick contacts anywhere in My contacts (list, cards or Similar) and a bar pinned to the top shows Merge selected with the count, so it never scrolls away.
- In the Similar view, each group gets its own Merge selected button once you tick two or more of its contacts, next to Merge all.
- On a contact card, the Similar contacts section has tick boxes and a Merge selected button, to merge this contact with just the ones you pick.

## Version 6.5 (Nov 5, 2026)

- Work contacts: the app spots contacts that look work related, such as a New York, NY address or the words diamond, jewelry, jeweler, gem or 47th Street in the company, job title, email, website, street or notes. The 💼 Work button in My contacts lists them with the reason, so you can answer Yes, work or Not work one at a time or all at once.
- Every contact card has a Work row to mark or unmark it by hand.
- Work contacts are kept out of the personal Apple export and have their own Download work list button, ready for a future work export. The words and the New York check can be changed in Settings.

## Version 6.4 (Nov 5, 2026)

- The Deleted list at the bottom of My contacts has Delete for good on each record and Delete all for good at the top. After you confirm, those records are erased from the app and can no longer be restored. Your original files on your computer are not changed.

## Version 6.3 (Nov 5, 2026)

- Addresses and phone numbers on each contact are now compared and merged automatically. Look-alike addresses (a typo, a missing or different ZIP or apartment) become one, keeping the fullest version; the card shows "Also seen as" under it with a Keep separate button in case two were really different.
- The same phone number written different ways becomes one: with or without +1, with or without the area code, with an extension, or saved twice under different labels. The fullest number and the most useful label (mobile, home, work) are kept.
- The easy page shows how many addresses and phone numbers were merged. Settings has a switch to turn this off.

## Version 6.2 (Nov 5, 2026)

- Merge look-alike addresses: each comparison box on a contact card has a Merge them button, which makes one address from the two (the first one wins where they differ, and the other fills in anything missing). The easy page and the look-alike list have Merge all, which does this for every contact at once after asking.

## Version 6.1 (Nov 5, 2026)

- Addresses on one contact are compared. Copies of the same address are combined automatically, keeping the fullest version: 12 Oak St and 12 Oak Street, Arlington VA 22201 become one, and an apartment number or ZIP that only one copy had is kept.
- Addresses that only look alike (a typo in the street, a different ZIP, city or apartment) are shown side by side on the contact card with the differences marked. Choose Keep this one under either version, or Keep both. Keep this one fills in anything the other version had that this one was missing.
- The easy page shows how many contacts have look-alike addresses, with a button to go through them.

## Version 6.0 (Nov 5, 2026)

- Easy mode is now the default. Section 2 is called Add & clean up: add as many lists as you like, and the app merges the duplicates, keeps everything unique from each record, adds tags from words in your notes, and finds possible relations on its own. One page shows what it did, with a button to check the few it wasn't sure about, and a button to download the clean list for Apple.
- Merged contacts now say in their notes where the information came from: a line such as "Merged from 3 records: Apple.vcf, Outlook.csv", then "From Outlook.csv: phone (703) 555-1212" for each thing that only that list had.
- Tags are made automatically from common words in notes (Family, Friend, Repair, Wedding and others). Turn this off in Settings.
- Advanced mode, in Settings, brings back the five steps (Import, Compare, Duplicates, Options, Export) for full control.

## Version 5.7 (Nov 5, 2026)

- Apple only for now: customers, leads, sales columns and the Zoho and Outlook tools are put away, including the switch that showed them. They come back when Zoho and Exchange are added.
- The pinned header on the contact card and in Edit no longer has a Related button. Relations still live in the Related row on the card and the Related to section in Edit.
- Related view is clearer: each pair shows the two names and why they might be related, then a sentence to finish, such as "Jen is Kyle's Wife", with a ⇄ button to swap who is whose and Link beside it. Not related and Same person? Merge sit apart at the end of the row. The relation is guessed as Wife, Husband, Son or Daughter from the first name when it can be.

## Version 5.6 (Nov 5, 2026)

- Groups: every contact can belong to groups, separate from tags. The contact card has a Groups row; tap a group to see everyone in it. In Edit, the Groups bar adds or removes a group, and adding one writes &GroupName into the notes, the same way #tags work. Typing &Family in a note also puts the contact in the Family group.
- My contacts has a 👥 Groups button that lists every group with its count, and a Group filter next to the Tag filter.
- Add to group when importing: each imported file has an "Add everyone to group" box, so a file exported from one Apple group puts everyone in it in that group. Apple group cards are read too, when a file has them.
- Apple export: groups go into the notes as &GroupName so they come back on the next import. Under Export you can also tick "Make Apple groups too", which adds group cards to the file.

## Version 5.5 (Nov 5, 2026)

- Edit always shows address blocks: a contact with no address gets an empty Home block ready to fill in, and new contacts do too.

## Version 5.4 (Nov 5, 2026)

- Addresses are easier to see: on the contact card each address shows right under Email, with its label (Home, Work, or your own like Cabin), the street on one line and city, state and ZIP on the next, a Main marker and a Map link.
- Edit now has an Addresses section: change any part of an address, pick its label, add a new address, remove one, or make one the main address. Your changes go into the Apple export.
- Apple contacts with more than two addresses keep all of them (up to six), along with Apple's own labels such as Other or a custom name. Re-import your Apple file once to pick up addresses that were left out before.

## Version 5.3 (Nov 5, 2026)

- The contact card and Edit now have a header that stays pinned at the top while you scroll. On the card it holds Close, Edit, + Related, Previous and Next. In Edit it holds Save changes, Related to and Cancel, so they never get lost below the fold.

## Version 5.2 (Nov 5, 2026)

- Contact cards are easier to read: the name, phones, emails, addresses, tags, relations and notes are larger and darker, with clear labels and a line between rows. The Edit, Call, Email, Copy and Delete buttons are smaller and softer so the details stand out.

## Version 5.1 (Nov 5, 2026)

- Apple's hidden fields now show in a collapsible section at the bottom of Edit: last modified, Apple's card IDs, the photo, Show as, and any instant message, social profile, phonetic name, maiden name or extra dates. They are kept and go back out with the Apple export.
- Related to is easier to find and use: a 👪 Related to button sits at the top of Edit and jumps to the section, the contact search there works like the main search, and the app tells you if you press Link before picking someone. Picking Father or Mother now suggests Son or Daughter for the other way round when the first name makes it clear; you can always change it.

## Version 5.0 (Nov 5, 2026)

- Apple's hidden fields are kept: contact photos, the last-modified date, Apple's card ID, instant message and social profiles, phonetic and maiden names, and extra dates. Photos show on the card, and a More from Apple section lists the rest. All of it goes back into the Apple export. Re-import your Apple file once to pick these up for contacts you imported earlier.

## Version 4.9 (Nov 5, 2026)

- The contact card now has Tags and Related rows. Tap a tag to see everyone with it, tap a related name to open that person, or use + Add a tag and + Add a relation to jump straight to those parts of Edit.

## Version 4.8 (Nov 5, 2026)

- Every button is now colored by what it does, automatically: red removes, green saves or approves, light green adds or restores, orange merges, amber marks Not duplicates or Not related, purple downloads, copies or sends, blue edits, teal opens a panel or help, a light tint moves you around, and slate gray closes. Help has a color key, and Settings › Appearance can turn the colors off.

## Version 4.7 (Nov 5, 2026)

- Button colors: every Delete, Remove, Unlink and Undo all button is red. Close, Cancel and Done buttons are slate gray. Previous, Next, Back and page buttons are a light tint of the app color.
- Tag bar in the editor: above Notes you see this contact's tags, each with × to remove it, plus every other tag you use with + to add it, and a box to make a new tag. Adding writes the #tag into the notes, removing takes it out, and the notes update as you go. Tags that come from a rule or your Neighbors address are marked auto.

## Version 4.6 (Nov 5, 2026)

- Search: typing a name like Steve shows a list of every Steve, sorted by name, with the matching letters highlighted and a count at the top. Each letter you add shortens the list. Pressing Enter or Search no longer opens the first match; it opens a contact only when just one matches. Show all in My contacts lists the matches there.

## Version 4.5 (Nov 5, 2026)

- Tag picker: when you edit a contact, tap any tag you have used before, just above Notes. It writes the #tag into the notes and adds the tag.
- Related to: the contact editor has a Related to section. Find another contact, choose how they are related (for example Kyle Bradshaw is Bella's Father, and Bella is Kyle's Daughter) and press Link. The relation shows on both contacts and goes into the Apple export on both cards.
- New relation types: Father, Mother, Son, Daughter, Husband, Wife, Brother, Sister, Grandparent, Grandchild, Assistant and Manager.

## Version 4.4 (Nov 5, 2026)

- Text size: in Settings › Appearance, make the whole app smaller or larger, and set a separate size for contact cards.
- Color themes: pick the app's color (Blue, Emerald, Amethyst, Ruby, Gold, Teal or Graphite), and turn on Stronger contrast if you like. Each device remembers your choices.

## Version 4.3 (Nov 5, 2026)

- Closing tags: the Tags panel has a ✕ Close tags button at the top and the bottom. Tapping a tag now closes the panel and shows those contacts with a bar that says which tag you are looking at, plus Back to tags and ✕ Done buttons.

## Version 4.2 (Nov 5, 2026)

- New Help (? at the top): a table of contents with every feature, a search box, and a Take me there button on each topic that opens that feature.

## Version 4.1 (Nov 5, 2026)

- Tapping a contact now always opens it in view mode, at the top of the card. Quick taps on iPad no longer zoom instead of opening, and a tap that lands while the list is refreshing still opens the contact. Names in the Related view open the contact too.
- New Settings menu (⚙ at the top) with Appearance, confirmations, Zoho and Outlook tools, name clean-up, saving and backups, your home address for Neighbors, the change log, and Start over.

## Version 4.0 (Nov 5, 2026)

- Related contacts: a new Merge into one button joins two contacts that should be a single record. You pick which one stays, and the name of the other is written into the notes of the one that stays.
- A cleaner header: the app name, counts and settings sit on the top line, and a larger search bar sits next to the two sections.

## Version 3.9 (Nov 5, 2026)

- Neighbors: enter your home address in the Tags panel and the app tags everyone on your street, in your ZIP code, or in ZIP codes you list, as Neighbor (or a tag name you choose).
- Appearance: choose Light, Dark or System (follows your device) from the ◐ button at the top. Your choice is remembered.

## Version 3.8 (Nov 5, 2026)

- Possible relations: the app finds contacts that may be related, such as a husband and wife, by a shared address, home phone or email, notes like “wife Ann”, or Apple’s related names.
- Open them with the new Related button in My contacts, or on each contact card. Link a pair as Spouse, Partner, Child, Parent, Sibling, Family, Friend or Other, or mark it Not related.
- Linked relations go into the Apple .vcf export as Apple’s related names, and into the Master file’s Related column.
- Possible duplicates have a new Related, not the same person button.

## Version 3.7 (Nov 5, 2026)

- Every Delete, Remove and Undo all button now asks you to confirm in a pop-up first, including removing an address, a tag rule or your edits.
- Delete and Remove always ask, even if you ticked Don't ask me again.

## Version 3.6 (Nov 5, 2026)

- The Tags panel, renamed Tags, now opens with a list of every tag in use and how many contacts have it. Tap a tag to see those contacts.
- The button in My contacts is now called Tags and shows how many tags you have.

## Version 3.5 (Nov 5, 2026)

- Merged contacts can be approved. Approved merges move to their own Approved tab and stop showing in the list to check, unless a new record joins them later.
- Merges you make yourself are approved automatically.
- Merged contacts show a Merged ✓ tag in My contacts and on the contact card.

## Version 3.4 (Nov 5, 2026)

- Tapping a contact in My contacts opens its card in view mode, with large Edit, Call, Email, Map, Copy and Delete buttons.
- Previous and Next buttons move through the list without closing the card.
- Address management and original records moved under their own expandable sections.

## Version 3.3 (Nov 5, 2026)

- Added this change log. Tap the version number at the top to see what changed in each version.
- After an update, the app tells you once that a new version is ready.

## Version 3.2 (Nov 5, 2026)

- After any merge, a green bar shows what was merged, with buttons to open the merged contact or clear and go back to My contacts.
- Added a Clear and go back button in My contacts whenever a search, filter or selection is active.

## Version 3.1 (Nov 5, 2026)

- Added Save as: choose the file name and type (full backup .json, Excel .xlsx, CSV .csv or Apple Contacts .vcf).
- Apple .vcf downloads now arrive as a .zip with the .vcf inside, because a plain .vcf download was blocked.

## Version 3.0 (Nov 5, 2026)

- Tags are saved with each contact. Save tags to contacts keeps today's tags even if a rule changes.
- Added a Tags box when editing a contact.
- The Apple .vcf export writes a Tags: line into Notes, so Apple Contacts keeps them, and the app reads it back on import.

## Version 2.9 (Nov 5, 2026)

- Your work now saves automatically to your Claude account and loads again each time you open the app, on any device.
- Added the cloud status label at the top right. Tap it to save now.

## Version 2.8 (Nov 5, 2026)

- Every merge line now starts with the contact's name. The one-at-a-time button reads Merge [name].

## Version 2.7 (Nov 5, 2026)

- Merge pairs one at a time, with Skip and Back.
- Merge every pair or similar group matched the same way, for example all Same phone number matches, in one step.
- Fixed: Not duplicates sometimes left the pair on screen.

## Version 2.6 (Nov 5, 2026)

- Duplicates show how many fields each record has filled in. The fullest record is highlighted, and holding on the count lists the fields.

## Version 2.5 (Nov 5, 2026)

- Apple-only mode: customer and lead sorting and the Zoho and Outlook exports are hidden. Turn them back on at the bottom of Export.
- The Master list step is now called Options.

## Version 2.4 (Nov 5, 2026)

- Removed last sale date everywhere: lists, cards, rules and exports.

## Version 2.3 (Nov 4, 2026)

- Added the Home button, which clears every search and filter and goes back to My contacts.

## Version 2.2 (Nov 4, 2026)

- The app always opens on My contacts.
- The Tags from notes button is easier to spot.

## Version 2.1 (Nov 4, 2026)

- My contacts is now section 1 and Clean up & merge is section 2.

## Version 2.0 (Nov 4, 2026)

- Exports are named with the date and time.
- The Master file adds Date Added, Date Changed and Export Date columns.
- Added a changes-only master export and an export history.

## Version 1.9 (Nov 4, 2026)

- The top header always stays in view while you scroll.

## Version 1.8 (Nov 4, 2026)

- Added Tags from notes: suggested tags, common words, your own rules and #hashtags.

## Version 1.7 (Nov 4, 2026)

- Moved the imported lists panel, with Remove, onto the Import page.

## Version 1.6 (Nov 4, 2026)

- Imported lists show in My contacts. Tap one to see only its contacts, or remove it.

## Version 1.5 (Nov 4, 2026)

- Added Remove last import.

## Version 1.4 (Nov 4, 2026)

- Similar contacts: groups look-alike contacts, including nicknames such as Bob and Robert, so you can merge them.

## Version 1.3 (Nov 4, 2026)

- Asks before deleting or merging, with a Don't ask me again option.

## Version 1.2 (Nov 4, 2026)

- New look, styled like a native Apple app.

## Version 1.1 (Nov 4, 2026)

- Split the app into two sections: Clean up & merge, and My contacts.
- Added list, cards and one-at-a-time views, plus New contact.

## Version 1.0 (Nov 4, 2026)

- First version of Contact Workbench: import vCard, CSV and Excel files, compare, remove duplicates, merge, edit, delete and export to Apple .vcf.
- Version number shown in the header.
