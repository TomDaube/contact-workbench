# Contact Workbench

A single-file web app for importing, cleaning up, merging and exporting contacts. It comes in two editions:

| Edition | File | For | Current version |
|---|---|---|---|
| **Work** | `work/index.html` | Everything: Apple, Google, Exchange/Outlook, Zoho (live connector), NetSuite sales, customers and work contacts | v156 |
| **Personal** | `personal/index.html` | Friends and family: Apple and Android (Google) address books only, with no work features | v1.1 |

## How the two editions relate

The Work file is the source. The Personal file is built from it:

```
python3 tools/build-personal.py work/index.html personal/index.html
```

The build script turns on the Personal switch. It then strips Zoho, sales, customers, work contacts and all business details. Each step checks that it matched, so a change that would leak work text stops the build.

`tools/personal-check.js` (Playwright) then opens the Personal file and sweeps every screen, help topic and the change log for work words.

## Change logs

- `CHANGELOG.md`: Work edition
- `personal/CHANGELOG.md`: Personal edition

## Running it

Each `index.html` runs on its own in a browser. The live versions run as Claude artifacts. Those add saving to your Claude account, the Zoho connector (Work only) and AI tidy-up. A plain browser copy saves on that device only.
