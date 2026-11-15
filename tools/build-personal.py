"""Build the clean Personal Contact Workbench from the Work edition file.

Usage: python3 build-personal.py work/index.html personal/index.html

The Personal edition is for sharing with friends and family: Apple and Android
address books only. This script flips the edition switch and strips everything
work related (Zoho, NetSuite, sales, customers, leads, work contacts, Exchange)
and every business detail. Each replacement asserts it matched, so a change in
the Work file that breaks a rule stops the build instead of leaking work text.
"""
import sys, re
src, out = sys.argv[1], sys.argv[2]
s = open(src).read()

PERSONAL_VER = '1.9'
PERSONAL_DATE = 'Nov 14, 2026'

def R(a, b, n=1):
    global s
    c = s.count(a)
    assert c == n, ('count', c, 'expected', n, a[:90])
    s = s.replace(a, b)

def RX(pat, b, n=1, flags=re.S):
    global s
    s2, c = re.subn(pat, b, s, flags=flags)
    assert c == n, ('regex count', c, 'expected', n, pat[:90])
    s = s2

# ---- edition switch, title, tag, version ----
R("const EDITION='work';", "const EDITION='personal';")
R("<title>Contact Workbench</title>", "<title>Personal Contact Workbench</title>")
R('<span class="edtag" id="edtag">Work</span>', '<span class="edtag" id="edtag">Personal</span>')
RX(r"const APP_VER='\d+';", "const APP_VER='%s';" % PERSONAL_VER)
RX(r">v\d+</button></h1>", ">v%s</button></h1>" % PERSONAL_VER)
R("Contact-Workbench-app-v", "Personal-Contact-Workbench-v", 4)
R("Contact Workbench <b>v${APP_VER}</b>", "Personal Contact Workbench <b>v${APP_VER}</b>")
R('<span class="small mute">Contact Workbench v${APP_VER}</span>', '<span class="small mute">Personal Contact Workbench v${APP_VER}</span>')

# ---- own change log, starting fresh ----
RX(r"^const CHANGELOG=\[.*?\]\]\];$",
   'const CHANGELOG=[["%s","%s",["New Select all button: tap Select above the list, then Select all to tick everyone shown (for example after a search or filter). Then Delete, Archive or Merge them in one go."]],["1.8","%s",["The A–Z letters on the right no longer sit on top of the Windows scroll bar, so they’re fully on screen on Windows laptops."]],["1.7","%s",["🗂 Format ▾ (Filters and Sort) has two new sections. Only in one, such as Only in Google, shows people found in no other list. In one, not the other, such as Apple, not in Google, shows people in the first list but missing from the second."]],["1.6","%s",["New Dark charcoal color in ⚙ Settings › Appearance › Color: a deep, near-black gray for buttons, links and highlights. In dark mode it shows as a softer gray so it stays visible."]],["1.5","%s",["The Start over button (Remove all…) is gone, so you can’t wipe everything by mistake. To remove one list, use its own Remove button."]],["1.4","%s",["Buttons are a little shorter and no longer bold, including Reset, Search and Choose files.","New Button size slider in ⚙ Settings › Appearance (Clean style) to make every button smaller or larger."]],["1.3","%s",["Calmer, more consistent buttons: blue for the main action, red text for anything that deletes or removes, and soft gray for everything else, all in one set of sizes."]],["1.2","%s",["New Clean style: a calmer, simpler look with more white space, soft lines, quiet buttons and one accent color, in light and dark. To go back, open ⚙ Settings › Appearance › Style and choose Classic."]],["1.1","%s",["Private saving: each person who opens the app saves their contacts in their own private space in their Claude account. Nobody else can see them, not even the person who shared the app with you. If the app can’t save there, the ☁ badge says Saved on this device only, and your contacts stay on this device.","Where your contacts are kept (in Help) explains this."]],["1.0","%s",["First version of Personal Contact Workbench, for Apple and Android (Google) address books.",'
   '"Bring in your Apple Contacts (.vcf) and Google Contacts (CSV) files, find and merge duplicates, tidy names, phones, addresses and notes, then send the clean list back to Apple or Android.",'
   '"Your contacts stay in your own Claude account. Nobody else can see them."]]];' % (PERSONAL_VER, 'Nov 15, 2026', 'Nov 15, 2026', 'Nov 15, 2026', 'Nov 15, 2026', 'Nov 15, 2026', 'Nov 15, 2026', 'Nov 15, 2026', 'Nov 15, 2026', PERSONAL_DATE, PERSONAL_DATE),
   flags=re.S | re.M)

# ---- business details ----
R("\"Tom's contacts\"", '"My contacts"', 3)
R("const CRM=()=>false; // Apple-only for now (Tom, Nov 5 2026). S.settings.crm is kept for when Zoho/Exchange come back.", "const CRM=()=>false;")
RX(r"const WORK_SURE_DEF='[^']*';", "const WORK_SURE_DEF='';")
RX(r"const WORK_WORDS_DEF='[^']*';", "const WORK_WORDS_DEF='';")
R(",'washingtondiamond.com']", "]")

# ---- Zoho connector code removed entirely ----
RX(r"/\* v140: Get from Zoho.*?(?=async function readSheets)",
   "function zhBox(){}\nasync function zohoGet(){}\nfunction zohoRow(){return''}\n")

# ---- groups: no Customer or Work in Personal ----
R("const GRP_FIXED=['Customer','Work','Business','Person'];", "const GRP_FIXED=['Business','Person'];")
R("Business, Person, Customer and Work", "Business and Person", 4)
R("[['Work','💼'],['Customer','💎'],...G.map", "[...G.map")
R("'Not work, customers, business or person'", "'Not in Business or Person'")
R("For example Work or Customers", "For example an old club or team")
R("People (Customers, Work, Business, Person, Ungrouped)", "People (Business, Person, Ungrouped)")
R("html.ed-personal [data-act=zohoget],", "html.ed-personal [data-act=zohoget],html.ed-personal [data-act=custsel],html.ed-personal [data-act=custset],html.ed-personal [data-act=worksel],html.ed-personal [data-act=workset],html.ed-personal [data-act=workall],")

# ---- work-contact settings and export options removed ----
RX(r'<label class="small" style="display:flex;flex-direction:column;gap:3px">Words that suggest a work contact<input[^>]*></label>', '')
RX(r'<label class="small" style="display:flex;flex-direction:column;gap:3px">Notes text that always means work[^<]*<input[^>]*></label>', '')
RX(r'<label class="small"><input type="checkbox" data-set="workNY"[^>]*> Suggest contacts with a New York, NY address as work</label>', '')
RX(r'<label class="small"><input type="checkbox" data-set="vcWork"[^>]*><span>💼 Include work contacts</span></label>', '')
RX(r'<label class="small"><input type="checkbox" data-set="vcWork"[^>]*> Include work contacts \(normally kept in the separate work list\)</label>', '')

# ---- import, backup and help wording ----
R("Add every list you have: Apple Contacts, Outlook, Google, spreadsheets.", "Add every list you have: Apple Contacts, Google (Android), spreadsheets.")
R(" For a fresh Zoho backup, tap Use Zoho contacts in Add &amp; Clean Up first, then back up the new Zoho list here.", "")
R("grouped by where it came from (Zoho, Exchange / Outlook, Google, Apple).", "grouped by where it came from (Apple, Google).")
R(" For a fresh Zoho backup, tap Use Zoho contacts first, then back up the new Zoho list.", "")
R(" Under <b>Which contacts</b>, <b>Only my Apple contacts</b> keeps your Zoho, Exchange and Google contacts out of it; <b>Everyone</b> puts them all in.", "")
R("<li><b>Work contacts (.vcf)</b>, when you have some.</li>", "")
R("Apple, Exchange / Outlook, Google, Zoho or another spreadsheet (after", "Apple, Google or another spreadsheet (after")
R("such as <b>In both Apple and Zoho</b>", "such as <b>In both Apple and Google</b>")
R("; Outlook Referred By, Assistant and Manager names, Profession, User 1–4 and similar; any kept Google, Zoho or spreadsheet column)", "; any kept Google or spreadsheet column)")
R("<b>More from Apple / Exchange / Google / Zoho</b>", "<b>More from Apple / Google</b>")
R("const PH=new Set(['zohoget','sales','srcbackup']);", "const PH=new Set(['zohoget','sales','work']);")

# ---- leftover work wording in checks and help ----
R("()=>{UI.mFilter=c[0]}]});", "()=>{UI.mFilter=c[0]}]}).filter(x=>x[0]!=='work');")
R("'Not yet in Customers, Work, Business or Person'", "'Not yet in Business or Person'")
R("(for example an old Work list)", "(for example an old club list)")
R("notes, work contacts and people with no phone", "notes and people with no phone")
R("(name fixes, Advanced mode, work words, Neighbors, sources)", "(name fixes, Advanced mode, Neighbors, sources)")

# ---- hidden work help topics removed outright, and leftover NetSuite labels ----
RX(r"^  \['zohoget',.*\n", "", flags=re.M)
RX(r"^  \['sales',.*\n", "", flags=re.M)
RX(r"^  \['work','Work contacts',.*\n", "", flags=re.M)
R("total sales in NetSuite", "total sales")
R("Total sales in NetSuite", "Total sales")
R(" (from Zoho / NetSuite)", "")

# ---- start-up guide and import card: no Zoho buttons or wording ----
R('<button class="b big zhbtn" data-act="zohoget" data-v="Contacts">Use Zoho contacts</button><button class="b big" data-act="zohoget" data-v="Leads">Zoho leads</button>', '', 2)
R("Add your Apple Contacts export (.vcf), Google, Outlook or any spreadsheet, several at once, or get your contacts straight from Zoho.", "Add your Apple Contacts export (.vcf), your Google Contacts (Android) file, or any spreadsheet, several at once.")
R("Add any other lists you have, or get your contacts straight from Zoho. Check", "Add any other lists you have. Check")
R("· Zoho, Google, Outlook / Exchange, Apple Contacts, or any spreadsheet", "· Apple Contacts, Google Contacts (Android), or any spreadsheet")
# ---- AI prompts: a personal address book, not a business ----
R("in a US jeweler's address book.", "in a personal address book.")
R("in a jeweler's address book.", "in a personal address book.")

# ---- privacy help for people the app is shared with ----
R("Your contacts stay in this browser and in your own Claude account. They are never shared, and Claude (the assistant) can’t see them.",
  "Your contacts stay on this device and in your own private space in your Claude account. Nobody else can see them: not other people using this app, not the person who shared it with you, and not Claude (the assistant). If the ☁ badge at the top says <b>Saved on this device only</b>, the app could not save to your account (for example, the app was shared with you to view only), so your contacts are kept in this browser on this device. Download a backup now and then from Export so you never lose them.")

# v163 format help examples
R("such as <b>Only in Exchange</b>", "such as <b>Only in Google</b>")
R("such as <b>Exchange, not in Zoho</b>", "such as <b>Apple, not in Google</b>")

# v164: no chat button, no Exchange helper, no Exchange Id field
RX(r'<a class="b s themebtn" id="chatbtn" [^>]*>💬</a>', '')
RX(r'<script type="text/plain" id="exps1">.*?</script>\n', '')
RX(r"^  \['exchange',.*\n", "", flags=re.M)
R("['exchId','Exchange Id'],", "")
RX(r"/\* v164: Exchange bridge\..*?(?=\nconst EXPORTS=)", "function exHelperSave(){}\nfunction exchangeRows(){return[[]]}\nfunction exchCounts(){return{up:0,dup:0,del:0}}\nfunction exchTile(){return''}")
RX(r"    case 'exhelp':.*?\n    case 'exhelper':exHelperSave\(\);break;\n", "")

open(out, 'w').write(s)
print('built', out)
