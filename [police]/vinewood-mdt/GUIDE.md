# Vinewood MDT: Setup and User Guide

Vinewood MDT is a British-style police computer for FiveM: officers check people and vehicles, book suspects into custody, record evidence and send cases to the CPS, all from one tablet.

This guide has two parts:

- **Part 1, server owners:** installing it, linking it to your other scripts, and fixing common problems.
- **Part 2, officers:** how to use it on shift, from a vehicle stop to a charge.

Three kinds of player use it, and each sees only their own pages:

| Who | Job (set in `config.lua`) | What they see |
| --- | --- | --- |
| Police | `Config.Jobs` (police, sheriff) | Everything |
| CPS lawyers | `Config.CPS.jobs` (cps) | Cases sent for a charging decision, the sentencing guide, interviews |
| Solicitors | `Config.Defence.jobs` (lawyer, solicitor) | Only the clients a custody officer assigns to them |

Members of the public never open the MDT, but they receive notices (bail, fines, stop and search records) and pay fines with `/fines`.

## Part 1: Installing the MDT

**You need:** Qbox, QBCore or ESX; `ox_lib`; `oxmysql`; OneSync (on by default). Everything else is optional.

1. Put the folder in your resources and **keep it named `vinewood-mdt`**. Other Vinewood scripts look for it by that name.
2. In `server.cfg`, start it after your framework and any scripts you want it to read from:

   ```
   ensure ox_lib
   ensure oxmysql
   ensure qbx_core
   ensure ox_inventory
   ensure vinewood_licensing
   ensure vinewood-mdt
   ```
3. Start the server. The database tables are created automatically on first start (`sql/install.sql` is there if you prefer to run it yourself).
4. Open `config.lua` and set the basics below, then restart.

| Setting | What it does | Default |
| --- | --- | --- |
| `Config.ForceName`, `Config.ForceShort` | Name in the header, and the prefix on every reference (custody, incidents, fines) | Los Santos Police, LSP |
| `Config.ForceCrest` | Your logo (image URL), or `false` for the built-in star | false |
| `Config.Jobs` | Police jobs and the minimum grade to use the MDT | police, sheriff, grade 0 |
| `Config.RequireOnDuty` | Only officers on duty can open it | true |
| `Config.SupervisorGrade` | Grade for supervisor actions (remove markers, delete records, court results) | 3 |
| `Config.Command`, `Config.Keybind` | How officers open it | /mdt, F6 |
| `Config.Item` | Optional tablet item that opens it | false |

On ESX, duty is taken from `vinewood_police` if it is running; otherwise every police player counts as on duty.

## Connecting your other scripts

The MDT finds most scripts by itself: if one is running, its information appears. You only edit config to switch one off or point it at a renamed resource. The dashboard's **System status** panel shows what it found.

| Area | Works with | Where to change it |
| --- | --- | --- |
| Driving licences | vinewood_licensing, citydriving, framework licences, esx_license | `Config.Licences` |
| Addresses | RX Housing, Next Housing, qbx_properties, ps-housing, qb-houses, qs-housing | `Config.Housing` |
| Live calls | vinewood-dispatch, cd_dispatch3d, cd_dispatch, ps-dispatch, qs-dispatch, rcore_dispatch | `Config.Dispatch` |
| Evidence bags | ox_inventory, qb-inventory, qs-inventory, ps-inventory, lj-inventory | `Config.Evidence` |
| Remand to prison | vinewood_prison, rcore_prison, tk_jail, qb_tk_jail, qb-prison | `Config.Prison` |
| Insurance, MOT, tax | vinewood-vehicleservices | `Config.VehicleServices` |
| Interview recordings | vinewood-interviews | `Config.Interviews` |
| Courts and sentences | vinewood-moj | `Config.MoJ` |

A script that isn't listed can still be added. The licence, housing, prison and inventory files in `server/` are left open for this, with an example at the bottom of each.

### Server-only settings

`server/sv_config.lua` is never sent to players. Put two things there:

- **Fivemanage key** for custody photos (or set the `fivemanage_key` convar).
- **Discord webhooks**: one URL per channel (audit, custody, warrants, CPS, fines, statements, stop and search, ANPR). Leave any blank to switch it off.

### Items

Two optional paper items are handed out: `bail_notice` and `stop_search_record`. Using one shows the notice again. For ox_inventory, add them to `data/items.lua`:

```lua
['bail_notice'] = { label = 'Bail notice', weight = 10, stack = false, close = true, server = { export = 'vinewood-mdt.useDocument' } },
['stop_search_record'] = { label = 'Stop and search record', weight = 10, stack = false, close = true, server = { export = 'vinewood-mdt.useDocument' } },
```

Other inventories: add items with the same names. Set `Config.BailNoticeItem` or `Config.StopSearch.ReceiptItem` to `false` to hand out nothing.

### Permissions for ANPR setup

Placing ANPR cameras and fitting vehicles (`/anpradmin`) is allowed for police at `Config.ANPR.ManageGrade`, or anyone with this ace:

```
add_ace group.admin vinewood-mdt.anpradmin allow
```

## First run and troubleshooting

After installing, run through this with a test police character and a test civilian:

- [ ] `/mdt` opens on duty and refuses off duty
- [ ] Searching the civilian finds them, and their licence and address show
- [ ] Booking them into custody creates a record with a custody clock
- [ ] Releasing them on bail gives them a notice and the `bail_notice` item
- [ ] Issuing a fixed penalty gives them a notice, and `/fines` shows it
- [ ] The dashboard's System status shows each script you expect as Online

| Problem | Cause and fix |
| --- | --- |
| "You need to be on duty as police" | Their job isn't in `Config.Jobs`, their grade is too low, or they're off duty. Check the job name matches exactly. |
| MDT opens but searches find nobody | The framework wasn't detected. Make sure the framework starts before `vinewood-mdt`, or set `Config.Framework`. |
| Licence or address missing | That script isn't running, or it was renamed. Check System status and the resource name in config. |
| Offline players show no licence | Make sure `vinewood_licensing` loads `@oxmysql/lib/MySQL.lua` in its manifest. |
| A solicitor can't be found | Their job must be in `Config.Defence.jobs` (lawyer or solicitor by default). |
| Custody photo fails | Check the Fivemanage key in `server/sv_config.lua`, and that screenshot-basic is running. The console says why it failed. |
| `No such export useDocument` | You're running an MDT older than 2.19.3. Update it. |
| Discord gets nothing | Check the webhook URL in `server/sv_config.lua`. A failed send prints the reason in the console. |

When reporting a problem, include the error from the server console (F8 for client errors) and the MDT version from `fxmanifest.lua`.

## Part 2: Using the MDT on shift

Open the MDT with **F6** or `/mdt` while on duty. Close it with the X or **Esc**.

- **Header:** your callsign and name, an on-duty light, the time, and your **purpose** button.
- **Left menu:** every section. You only see the ones your role and the server allow.
- **Main area:** the page you're on. Click any row to open it.

### Set your purpose first

Like the real PNC, every check is logged with a reason. The first time you search a person or vehicle, the MDT asks why: vehicle stop, arrest, incident enquiry and so on. That reason stays in the header until you close the MDT or click it to change it. Supervisors can see who looked at what, and why.

### The dashboard

The first page you see. Each card opens its list:

- **Active calls** (or open incidents), **Wanted persons**, **Stolen vehicles**, **Bail due** in the next 48 hours.
- **Live calls** from dispatch, by priority. Click one to set a waypoint or turn it into an incident.
- **Recent searches**: click to run them again.
- **System status**: which linked scripts are online.
- **Bail returns** due soon, and this week's **CPS decisions**.

## Checking people and vehicles

### People

1. Go to **Persons**. With nothing typed, you'll see everyone currently wanted.
2. Search by first name, last name, date of birth or PNC ID. Capitals and word order don't matter: "smith james" finds James Smith. A driving licence number works too.
3. Results show **WANTED**, **CAUTION** (markers or on bail) or **CLEAR**. Click a person to open their record.

The record shows their photo, details and address at the top, red **warning marker** tiles (Violent, Weapons and so on), and cards for their licence, vehicles, convictions and arrests. Banners warn you if they're on bail, wanted on a warrant, in prison or in hospital. The tabs underneath hold the detail:

| Tab | What's in it |
| --- | --- |
| Activity | Everything that's happened to them, newest first |
| Licences and address | DVLA record: categories, points, endorsements, bans. Endorse or disqualify from here. |
| Custody, Bail | Every arrest with its custody clock, and every bail |
| Incidents, Evidence | Incidents they're linked to, and exhibits seized from them or linked to them |
| Intelligence, Notes, Warrants | Intel, officers' notes, and warrants |
| Stop and search, Fines | Searches of them and tickets issued |
| Court and sentences | From vinewood-moj, if installed |

Buttons along the top let you create a report (incident), add a note, open a custody record, release on bail or add a warning marker.

### Vehicles

1. Go to **Vehicles** and type a registration. Matching plates appear as you type.
2. With nothing typed, you'll see stolen vehicles. The buttons switch to other markers (No insurance, Seize s.165 and others).
3. Open a vehicle to see the keeper, their address and licence, insurance, MOT and tax, markers, ANPR hits, speed detections and history.

**Check driver** (on a vehicle record): pick the person driving from the list of people near you. It tells you whether they're insured to drive that car, whether they can legally drive, and whether they're wanted or bailed not to drive.

**Add to ANPR** puts the plate on the ANPR system with a reason and an action, so every ANPR car and camera alerts on it.

## Walkthrough: from arrest to charge

This is the full journey for one suspect. You won't need every step every time.

1. **Create the incident.** **Incidents → New incident** (or *Create report* on a person). The location fills in from where you're standing. Give it a type, grade and the details.
2. **Link everyone involved.** On the incident, **Link person** (the box lists people near you first) and give each a role: Suspect, Victim, Witness. **Link vehicle** for any cars.
3. **Seize evidence.** **Seize from suspect**: pick them, press *Search their pockets*, tick what to take. It moves from their inventory into a sealed evidence bag with its own exhibit number (for example JC/14). For things found at the scene, use **Add exhibit**.
4. **Book them in.** Press **Book in** next to the suspect. Tick the offences and write the circumstances. The record starts as *In custody* and gets a reference like LSP/2611/00012. Their DNA and fingerprints are added to the database automatically.
5. **Custody clock.** Each record shows how long they've been in. Reviews are due at 6 hours, then every 9, with a 24-hour limit. An inspector records each review; a superintendent or court can extend it. The clock turns amber when a review is due and red at the limit.
6. **Custody photo.** **Take custody photo** points a camera at their face. Stand within 4 metres of them.
7. **Solicitor.** **Assign solicitor**, search by name, and write the pre-interview disclosure (what you're telling the defence). The solicitor sees only what you put there.
8. **Interview.** Start the interview with vinewood-interviews using the custody reference. The recording then appears on the custody record and the incident.
9. **Decide the outcome** with **Record outcome**. The **Sentencing guidance** button suggests what the offences usually get.

| Outcome | What happens |
| --- | --- |
| Charged | The case goes to court |
| Released on bail | Pick the bail type, return date, station and conditions. They get a bail notice and item. |
| Released under investigation | Released with no return date |
| Remanded in custody | Sent to the prison script on remand until court |
| No further action | Case closed, bail cancelled, they're told |
| Caution, community resolution, fixed penalty | Dealt with there and then |

10. **Need a charging decision?** **Submit to CPS** sends the case with the charges, your summary and the evidence list. Statements, exhibits, lab results, injury statements and interviews are attached automatically. The CPS replies with a charge, NFA, or an action plan asking for more evidence. You'll get a notification either way.

## Everyday tools

| Task | Where | Good to know |
| --- | --- | --- |
| Stop and search | **Stop and search → New**, or the tab on a person | Pick the person from those nearby (or describe them if they won't give a name). Give the power, what you're looking for and your grounds. You must tick each part of **GOWISELY** before saving. They get a copy of the record. |
| Fixed penalty or ticket | **Fines and TORs → Issue**, or the Fines tab on a person | Choose fixed penalty (traffic), penalty notice for disorder, or report for court (TOR). Points go straight onto their licence. They pay with `/fines` within 28 days. |
| Court result for a TOR | Open the TOR (supervisor) | Record the fine, points and any ban the court gave. |
| Warrant | **Warrants → Record warrant**, or the tab on a person | Arrest warrants make the person show as **WANTED** everywhere, including ANPR keeper hits. Mark it executed or cancelled when done. |
| Intelligence | **Intelligence → Submit**, or a person or vehicle | Grade it source, assessment and handling (3x5x2). |
| Warning marker | **Marker** button on a person or vehicle | Shows as a tile or badge to every officer. Only supervisors can remove one. |
| Note | **Add note** on a person or vehicle | Free text for other officers. |
| Witness statement | **Take statement** on an incident | Officer statements are signed when saved. A witness reads theirs on their own screen and types their name to sign. |

## On the road: ANPR, speed and live calls

### In-car ANPR

Get into a fitted police vehicle and ANPR switches on (`/anpr` toggles it). A strip at the bottom of the screen shows the plate and speed of the vehicle in front (F) and behind (R), the road's speed limit and your own speed.

- **A hit** beeps and slides in an alert: the plate, vehicle, keeper, why it flagged (stolen, no insurance, keeper wanted, speeding) and what to do. The car gets a blip for a minute. Press **J** to open it in the MDT.
- **Speeding:** anyone over the limit + 10% + 2 is recorded automatically and alerts you.
- **Lock a speed:** press **K** to record the vehicle in front's speed as evidence, even if they're under the limit.
- **Move the alert and strip:** `/anprlayout`, drag them, Save.

Roadside cameras alert every officer on duty and add the hit to Live calls. Speed cameras record anyone over their limit.

### Tickets from speed detections

**ANPR → Speed detections** lists every reading with the keeper. **Ticket keeper** opens a fixed penalty already filled in with the speed, limit, device and time.

### Forensics at a scene

1. Type `/forensics` or hold a torch. Shell casings show as small yellow markers and blood as red splats.
2. Walk up and press **E** to collect each one.
3. To lift fingerprints, stand next to a vehicle and press **G**. Bare hands leave prints; gloves don't.
4. In the MDT, open the incident and press **Bag forensic samples**. Each sample becomes an exhibit.
5. Press **Send to lab** on each exhibit. Results come back in about 10 minutes, and you're notified.

The lab names the person if their DNA or prints are on the database, and gives the weapon and serial for casings. A match links them to the incident as a suspect. Samples with no match are checked again automatically when that person is later arrested.

### Live calls

With a dispatch script running, **Live calls** lists every call for your service. **Waypoint** sets your GPS. **Create incident** turns the call into an incident with the details filled in.

## Other roles

### Supervisors

Officers at `Config.SupervisorGrade` and above can also:

- Read the **Audit log** (every check and sensitive change, with the reason) and the **Access log** tab on any person.
- Remove warning markers, delete records, lift a driving ban, clear points and cancel fines.
- Record court results for traffic offence reports, and destroy evidence.
- Record custody reviews and extensions, depending on the grades set in `Config.Custody`.

### CPS lawyers

The MDT opens straight to the **CPS** queue: cases awaiting a decision, cases waiting on the police, and decided cases. Open a case to see the file: summary, statements, exhibits and lab results, interviews you can play, and previous custody. Then apply the Full Code Test:

1. **Evidential stage:** is there a realistic prospect of conviction?
2. **Public interest stage:** is a prosecution needed? This only appears once the evidential stage is met.
3. **Decide:** charge (both stages met), no further action, or send an action plan asking for more evidence.

### Solicitors

The MDT shows **My clients**: only the people a custody officer has assigned to you. Each client shows the officer's disclosure, the offences, bail, interview recordings, the CPS outcome and their history. **My notes** are private: the police and CPS can never read them.

### Members of the public

They never open the MDT. They see on-screen notices for bail, fines and stop and search records, and get paper items they can use to read them again. Typing **`/fines`** shows anything they owe, with a button to pay from their bank. Unpaid fines go up by 50% after 28 days.

## Quick reference

Keys can be changed by each player in **Settings → Key Bindings → FiveM**. Command names can be changed in `config.lua`.

| Command or key | Who | What it does |
| --- | --- | --- |
| `/mdt` or **F6** | Police, CPS, solicitors | Open the MDT |
| `/anpr` | Police in a fitted vehicle | Turn in-car ANPR on or off |
| **J** (`/anprview`) | Police | Open the last ANPR hit in the MDT |
| **K** (`/anprlock`) | Police | Lock the speed of the vehicle in front |
| `/anprlayout` | Anyone using ANPR | Move the ANPR alert and plate strip |
| `/anpradmin` | Admins, senior officers | Fit vehicles with ANPR and place cameras |
| `/forensics` (or hold a torch) | Police | Show casings and blood at a scene |
| **E** | Police in forensics mode | Collect a casing or blood sample |
| **G** | Police in forensics mode | Dust a vehicle for fingerprints |
| `/fines` | Everyone | See and pay fines |
