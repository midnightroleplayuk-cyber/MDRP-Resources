# Apex MDT - Dual-Mode Police + EMS Tablet

A single in-game tablet that automatically loads a **Police MDT** or an
**EMS / Hospital MDT** depending on the character's job. Built on the Apex
design system (brand `#1F5EFF`), framework-agnostic, and **every feature is a
config toggle**.

> The tablet boots like a real device (boot splash → badge auth → tactical OS
> with an iOS-style status bar, app rail and live clock/battery). The live map
> uses the **exact same method as `apex_bossmenu`** (Leaflet + the gtamap.xyz
> `styleAtlas` tiles).

---

## ✨ Highlights

- **One tablet, two modes** - auto-switches by job (`Config.jobs[...].mode`).
- **Device experience** - boot animation, badge lock screen, status bar
  (clock, battery, signal, 10-code chip), inactivity auto-logout, per-department
  accent colour, light/scale settings.
- **Live map** - real-time on-duty units + active calls on the GTA atlas
  (apex_bossmenu method), waypoint-from-popup, recenter.
- **Framework auto-detect** - ESX Legacy / QBCore / QBox, no config change.
- **Persistence** - oxmysql; all tables auto-create on first start.
- **Discord webhooks**, **audit log**, **client + server exports**.

---

## 🚓 Police mode apps

| App | What it does |
|-----|--------------|
| **Dashboard** | Officer card, live clock, units/calls/warrants/BOLO counts, bulletins, activity feed |
| **Dispatch (CAD)** | Live 911 calls, create calls, assign units, respond → waypoint, unit board |
| **Live Map** | All on-duty units + calls plotted on the GTA atlas |
| **Citizens** | Search by name/ID/phone, full profile, licenses, vehicles, criminal record, flags, notes |
| **Vehicles** | Plate lookup → owner, model, garage status, BOLO hit, notes |
| **Reports** | Incident / arrest / investigation / use-of-force / field - draft → submit → supervisor approval |
| **Warrants** | Arrest/search warrants, supervisor approval flow, auto-flags the citizen, all-units alert |
| **BOLOs** | Person/vehicle BOLOs with priority, last seen, archive |
| **Penal Code** | Searchable charges + **sentence calculator** (fine + months + points) |
| **Booking** | Build charges → book (creates arrest report + fine, fires a jail event) |
| **Citations** | Issue traffic fines, history |
| **Evidence** | Digital locker with **chain of custody** logging |
| **Court** | Docket scaffold (toggle) |
| **Roster / Comms / Stats / Audit / Settings** | Shared (below) |

## 🚑 EMS mode apps

| App | What it does |
|-----|--------------|
| **Dashboard / Dispatch / Live Map** | EMS-specific call types (Code Blue/Red/Yellow…) |
| **Patients** | Clinical record: blood type, flags, admissions, prescriptions, **Treat** button (revives a downed patient, then restores health) |
| **Triage** | Colour triage + **vital signs** (out-of-range highlighting) + diagnosis + admit |
| **Admissions** | Ward/bed manager (occupied/free), assign doctor, discharge |
| **Surgery** | Schedule procedures, complete with outcome |
| **Pharmacy** | Medication stock + prescriptions → **dispense** |
| **Billing** | Service price table, invoices, insurance coverage |
| **Morgue** | Death records + autopsies, controlled sharing to Police |
| **Blood Bank / Telemedicine** | Scaffold modules (toggle) |

## 🤝 Shared apps (both modes)

**Roster** (on-duty board + stats), **Comms** (channels, DMs, broadcasts),
**Statistics** (counts + 7-day chart), **Audit Log** (supervisor-only),
**Settings** (brand/bg colour, opacity, UI scale; shows active modules),
**Panic button** (broadcasts location + alarms the device).

---

## 📦 Installation

1. Drop `apex_mdt` in your resources folder.
2. Dependencies: **oxmysql** (required), **ox_lib** (recommended for notify;
   `apex_notify` is also auto-used if present).
3. `ensure apex_mdt` in `server.cfg` (after your framework + oxmysql).
4. (Optional) add the `tablet` item - see [installation/items.md](installation/items.md).
5. Edit `shared/config.lua` - set your job names, ranks, and toggle features.

All MySQL tables (`apex_mdt_*`) are created automatically on first start.
Citizen/vehicle data is read from your framework's tables
(`users`/`owned_vehicles` on ESX, `players`/`player_vehicles` on QB).

**Prefer to create the tables yourself?** Import
[installation/apex_mdt.sql](installation/apex_mdt.sql) into your framework's
database. It is optional (the resource runs the same statements on start), safe
to run more than once, and needed only if your database user cannot
`CREATE`/`ALTER` tables.

---

## 📸 Profile photos (`Config.photo`)

The account-setup wizard, **My Profile**, the citizen/patient **Mugshot**
button and the **Comms** photo button all open the same photo booth: mouse to
orbit, scroll to zoom, arrows for height, **Space** to capture, **Esc** to
cancel.

The real framed photo needs the standalone **`screenshot-basic`** resource
(`ensure screenshot-basic` in `server.cfg`, *before* `apex_mdt`). Without it,
the booth falls back to the native ped headshot - which shows in the tablet
but cannot be persisted to the database, because the browser is not allowed to
read pixels from `nui-img`.

Two safeguards, because a screenshot resource that stops answering is
completely silent - no F8 error, no server console error:

- `Config.photo.timeoutMs` (default **10000**) - if the capture has not come
  back by then, the booth closes itself and falls back to the headshot. **Esc
  also keeps working while a capture is in flight.** The player can never be
  left sitting in the photo camera.
- `/mdtphototest` - asks the screenshot resource for one frame and prints the
  verdict (state, round-trip time, payload size, or exactly what failed) to
  F8. Run this first whenever photos misbehave.

`/mdtcamreset` is the manual escape hatch if any other resource ever leaves a
scripted camera on screen.

Set `Config.photo.method = 'headshot'` to skip the booth entirely and use only
the native ped headshot, or `Config.photo.enable = false` to turn photos off.

---

## ⚙️ Configuration (everything is a toggle)

`Config.features` is an exhaustive on/off list - disabling a key removes the
app/behaviour from **both** the server logic and the NUI rail. Key groups:

- **Device** - boot/lock screen, status bar, battery, inactivity logout, theme.
- **Shared apps** - dashboard, dispatch, live map, roster, comms, stats, audit.
- **Police apps** - profiles, vehicles, reports, warrants, bolos, charges,
  citations, evidence, booking, court, ALPR.
- **EMS apps** - patients, triage, beds, surgery, pharmacy, billing, morgue,
  reports, blood bank, telemedicine.
- **World/duty** - duty toggle, station blips, duty markers, panic, unit
  tracking, ALPR, auto-waypoint, auto EMS call on player down
  (`enableEmsDownCall`), auto **10-71 Shots Fired** call when any player
  fires a gun (`enableAutoWeaponsCall`, tuned in `Config.weaponsCall`:
  who counts, silenced/vehicle rules, ignored weapons, merge radius,
  cooldown, Discord opt-in).
- **Integrations** - Discord webhooks, PD↔EMS data sharing, facial recognition,
  bodycam, offline sync.
- **Permissions** - restrict by job, require duty to open, warrant/report
  approval flows, edit-lock, audit everything.

Other config: `Config.jobs` (job → mode + department), `Config.ranks`
(grade → rank + supervisor), `Config.penalCode`, `Config.callTypes`,
`Config.statuses`, `Config.triage/vitals/diagnoses/wards/medications/surgeries`,
`Config.billing`, `Config.map` (Leaflet tiles + transform), `Config.discord`.

---

## 🔌 Exports

**Client** - `OpenMDT()`, `CloseMDT()`, `IsOpen()`, `IsOnDuty()`,
`ToggleDuty()`, `Panic()`.

**Server** - `GetMode(src)`, `IsOnDuty(src)`, `GetUnits(mode)`,
`CreateCall(data)`, `OpenFor(src)`, `CloseFor(src)`, `Audit(src,action,detail)`,
`Discord(channel,title,desc,color)`.

**Events to hook your own systems:**
- `apex_mdt:playerBooked` `{ officer, citizenId, seconds, fine, charges }` - wire your jail.
- `apex_mdt:patientTreated` `{ medic, patient, amount }` - wire your injury system.
- `apex_mdt:staffAction` `{ by, targetId, action, value }` - wire promote/fire to your society.

---

## ✅ Wired vs. 🧩 Scaffold

**Fully wired & persisted:** dashboard, dispatch/CAD, live map, citizen &
patient lookup, vehicle registry, reports (+approval), warrants (+approval),
BOLOs, penal code + sentence calculator, booking, citations, evidence + custody,
bulletins, comms, roster, stats, audit, triage/vitals, admissions/beds, surgery,
pharmacy, billing, morgue, duty, panic, ALPR, Discord webhooks.

**Scaffold modules (toggle + UI placeholder + export hook, ready to wire to your
data):** Court, Blood Bank, Telemedicine, Facial Recognition, Bodycam, Offline
Sync. These are intentionally off-data so you can connect them to your own
systems - they will not error and can be hidden via `Config.features`.

---

*Apex Scriptz - compatible with ESX Legacy, QBCore and QBox.*
