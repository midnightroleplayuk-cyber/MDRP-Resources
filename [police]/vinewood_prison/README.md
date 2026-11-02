# Vinewood Prison

Version 1.0.0. See `CHANGELOG.md`.

British-style prison system for FiveM. Qbox, QBCore and ESX through a bridge; requires **ox_lib**, **oxmysql** and **ox_inventory**.

Phase 1 delivers a working prison: build it in-game, receive prisoners (from Vinewood MoJ, the API or the desk), hold them in cells behind server-owned doors, count their time, and discharge them with property and clothing returned.

Phase 6 adds AI officers and inmates, movements and escorts, escapes and recapture, parole, preset listing and a setup check.

Phase 5 adds visits, the prison phone, gangs and reputation, and healthcare with safer custody.

Phase 4 adds searches, contraband and stashes, the black market, intelligence, alarms and incidents, lockdowns, CCTV and dispatch.

Phase 3 adds jobs and industries, education with qualifications, and gym, library and shower activities.

Phase 2 adds the daily regime with roll checks, the incentives scheme, adjudications and segregation, prisoner accounts with wages and deposits, and the canteen through a prisoner kiosk.

## Install

1. Drop `vinewood_prison` into your resources folder.
2. `server.cfg`, after your framework, ox_lib, oxmysql and ox_inventory:
   ```
   ensure vinewood_prison
   add_ace group.admin vinewood_prison.editor allow
   add_ace group.admin vinewood_prison.admin allow
   ```
3. Start the server. Tables are created automatically (`sql/install.sql` is there if you prefer to run it by hand).
4. Add a `prison` job to your framework (or change `Config.Jobs` and `Config.GradeRanks`).
5. Add the items below to `ox_inventory/data/items.lua`.
6. In game: `/prisoneditor` and build your prison (see **Setting up a prison**).
7. Run `/prisoncheck` (or read the console after start) for anything still missing.

### ox_inventory items

```lua
['prison_tablet'] = {
    label = 'Prison tablet',
    weight = 500,
    stack = false,
    client = { export = 'vinewood_prison.useTablet' },
},
['prison_keycard'] = {
    label = 'Prison keycard',
    weight = 10,
    stack = false,
    -- give with metadata = { level = 1-5 }
},
```

## Setting up a prison

Open `/prisoneditor`. It starts on the **Setup checklist**, which lists what the prison still needs in order:

| Must have (to receive prisoners) | Strongly recommended |
| --- | --- |
| The prison (name and code) | Boundary |
| A standard wing | Cell doors |
| Cells on it | A segregation wing with a cell |
| Reception desk | Prisoner kiosk |
| Discharge point | Holding area |

Below those it lists the points each feature you have switched on needs (workstations, phones, visits, CCTV and so on), then server checks such as missing items. Each line has a button that takes you to the right page. The pages, in order:

1. **Prison and boundary** — create the prison. Its code must match `Config.DefaultPrison` (default `VINEWOOD`) or be sent by your justice script. Press *Draw boundary in the world*, then walk or fly (G) round the fence placing corners where you aim (E). The boundary shows as see-through yellow walls as you go; aim at a corner to pick it up and move it (E) or delete it (R), aim at a blue + on an edge to insert a corner, Z undoes, Enter saves.
2. **Wings** — add wings. A wing's rating is the highest category it holds (B holds B, C, D). Only *standard* wings take automatic allocations.
3. **Cells** — *Place cells in the world*: choose the wing, the first number and beds, then walk or fly (G) from cell to cell pressing E where the prisoner should appear, facing the way they should face. Numbers count up as you go; Z undoes.
4. **Doors** — choose Single or Double, plus type, wing, keycard level and name (each can stay on Auto), then *Add doors in the world*. Single: walk up to a door (or aim at it), it's outlined with the name it will get, E or Enter saves it, then walk to the next. Double: E on each half of the doorway; it saves when both are picked. Q switches between single and double. Keys 1 to 5 switch type (auto, cell, gate, normal door, perimeter) without leaving. Choose whether doors start locked or unlocked when the server starts. A blue line shows which cell a cell door will attach to; left and right arrows pick a different nearby cell. Cells that already have a door show green with the door's name. Doors are named and set up from where they are: next to a cell becomes that cell's door (and is linked to it), elsewhere in a wing becomes a wing gate, away from the wings becomes a perimeter door. Keep going door to door. Edit a door afterwards to rename it, change its kind or level, or re-pick it. Placing cells before doors means cell doors link themselves.
5. **Desks and points** — choose the type and label and *Place in the world*: E where you aim (seats, posts, holding and discharge use where you stand and face), scroll for radius, place as many as you like. CCTV opens a free camera you fly into position; E saves the view. At minimum a `reception` desk and a `discharge` point. `holding` is optional (where new arrivals wait). Phase 2 adds `kiosk` (inside, for prisoners) and `finance` (outside, where visitors pay money in).
   For segregation, add a wing of type *segregation* with its own cells and doors.
   Phase 3 points: `workstation` (pick the job it belongs to), `education` (classroom), `gym` (one exercise or all), `library`, `shower`.
   Phase 4 points: `hiding_spot`, `market`, `evidence` (staff store for seized items) and `cctv` (line up your camera, then *Use my current view*).
   Phase 6 points: `officer_post` (AI officer when the prison runs itself) and `inmate_spot` (ambient AI prisoner when cells are unlocked).
   Phase 5 points: `visits_booking` (visitor centre), `visits_checkin` (visits entrance, also where visitors leave), `visits_table` (placed seat by seat: the prisoner's chair, then visitor chairs; sit in each with F to check it), `phone`, `meds_hatch` and `territory` (set the radius to cover the area).
6. **Presets** — export the layout to `data/presets/<code>.json` to ship it with an MLO.

Tick *Show markers in the world* to see cells, doors, zones and the boundary while you build.

## How custody works

| Step | What happens |
| --- | --- |
| Imprison | A custody record and sentence are created. Prison number is UK-style (`A1234BC`) and is reused if the person returns. |
| Reception | If staff are on duty and `RequireOfficer = true`, the arrival is moved to the holding point and staff are notified. Otherwise (or after `ArrivalTimeout`) reception runs automatically. |
| Reception desk | Property is moved into a sealed ox_inventory stash (move, never copy), kit is issued, clothing is saved and swapped for the uniform, a cell is allocated, the MDT is told. |
| Time served | Ticks every `TickInterval` seconds. Modes: `online`, `realtime`, `hybrid` (offline at `OfflineRate`). |
| Containment | Prisoners outside the boundary (or 250 m from their cell if none is drawn) are returned to their cell. Escape gameplay replaces this in Phase 6. |
| Release | At the release point (`ReleasePoint`, or per sentence from MoJ). Property and clothing returned, teleported to the discharge point, MoJ told about licence time. Offline prisoners are discharged at next login. |

Left-behind property (full pockets) can be collected at any discharge point.

## Phase 2: daily life

### Regime (`config/regime.lua`)

Phases run on a regime clock. `Clock = 'cycle'` squeezes a full regime day into `CycleMinutes` of real time (default 2 hours), so a session sees unlock, work, lock-up and canteen. `Clock = 'real'` follows the server clock.

| Mode | When | What happens at each phase |
| --- | --- | --- |
| Staffed | On-duty staff >= `MinStaff` | Staff are notified. Unlock or lock-up and the roll check wait for an officer on the tablet's Regime page. After `StaffGrace` seconds the system does it. |
| Automated | Fewer staff than `MinStaff` | Cell doors on standard wings open or lock straight away. At lock-up, prisoners out of their cell are returned and get a negative entry. Roll is counted. |

`Config.Regime.Cells` decides what the regime does with cell doors: `'regime'` (unlock in unlocked phases, lock at lock-up), `'lockonly'` (lock at lock-up only, staff unlock from the tablet) or `'manual'` (never). Locking or unlocking cells together plays a door buzzer and the locks, using GTA's own sounds at the nearest door (`Config.DoorSounds`). Run `/prisonsoundtest` to hear the alternatives, or use your own recordings.

A roll check counts everyone in custody. Offline prisoners are treated as accounted for; online prisoners outside the boundary are reported missing; at lock-up, anyone away from their cell is listed as out of cell. Results are kept on the Regime page.

### Incentives (`config/iep.lua`)

Officers add positive, negative or warning entries. The score over `windowHours` moves prisoners up or down a level automatically, or a Supervising Officer reviews them by hand. Each level sets the canteen spend limit and a wage multiplier.

### Adjudications and segregation (`config/discipline.lua`)

Officers place prisoners on report with a Prison Rule 51 charge. A Duty Governor hears it from the Adjudications page: plea, finding, and any of caution, loss of privileges (treated as Basic), stoppage of earnings, canteen stopped, cellular confinement (moved to segregation for the time given) and additional days (Governor only). A proven charge also adds a negative entry.

Custodial Managers can move someone to segregation with or without an end time. Timed segregation ends by itself and returns them to their old cell if it is free.

### Accounts and wages (`config/accounts.lua`)

Each person has *spends* (earned inside) and *private cash* (paid in at a finance desk by anyone outside, using cash). Prisoners present for a work phase are paid `SessionPay` × their level's multiplier, less any stoppage of earnings. On release, the balance is paid out in cash. Balances stay with the person, not the sentence.

### Canteen and kiosk (`config/canteen.lua`)

Prisoners use the kiosk to see their sentence, record and account, and to order canteen. Orders are paid when placed, limited by their level's spend limit per period (a regime day in cycle mode, a week in real mode), and handed over at the phase marked `canteen = true`. Anyone who misses the round gets it at their next kiosk visit or login. Unfulfilled orders are refunded at release.

## Phase 3: work and activities

### Jobs and industries (`config/industries.lua`)

Eight jobs ship by default: kitchen, laundry, wing cleaner, maintenance, carpentry, recycling, gardens and engineering workshop. Each has spaces, a minimum incentive level, allowed categories, an optional qualification, and its tasks.

1. A prisoner applies at the kiosk. Staff with `industries.manage` approve on the tablet's Industries page, or it's automatic (`AutoApprove`: `always`, `no_staff` or `never`). Staff can also give or remove a job from the prisoner file.
2. During work phases, the prisoner uses their job's workstations. Each task runs a progress bar with an animation, pays into spends, and adds experience.
3. Five levels (`LevelXp`). Higher levels pay more and unlock better tasks (`minLevel`).
4. Work orders: each regime day creates the job's `dailyOrder`, and staff can add their own. Every task counts towards the oldest open order; when it is finished, everyone who worked on it gets `OrderBonus`.

Prisoners with a job or a course no longer get the flat session pay; their pay comes from tasks and lessons.

### Education (`config/activities.lua`)

Four courses ship: Level 2 Food Hygiene, Health and Safety at Work, Functional Skills Maths and English Level 1. Prisoners enrol at the kiosk and attend lessons at a classroom point in work phases. Each lesson ends with a question; a right answer moves them on and pays `LessonPay`. Passing every lesson awards the qualification and a positive entry. The kitchen needs Food Hygiene, and maintenance and the workshop need Health and Safety.

### Gym, library and showers

Available whenever cells are unlocked and the prisoner is not in segregation. Each records a stat (`fitness`, `books`, `showers`) shown in the prisoner file. Every `BooksForEntry` books earns a positive entry. Showers can relieve stress through your HUD's event (`Shower.Stress`).

All tasks are timed on the server: finishing early, from somewhere else or without starting is refused and logged as `security.task_too_fast`.

## Phase 4: security (`config/security.lua`)

### Contraband and stashes

`Config.Security.Contraband` lists illicit items with a severity of 1 to 3; any `WEAPON_` item also counts. Prisoners can hide items in a stash in their own cell (shared with cellmates) or at a hiding spot.

### Searches

| Search | Who | How | Chance |
| --- | --- | --- | --- |
| Cell | `search.cell` | Stand inside the cell and press E, or `/prisonsearchcell` | `CellFindChance` of finding the cell stash |
| Hiding spot | `search.cell` | At the spot | `SpotFindChance` |
| Rub-down | `search.person` | `/prisonsearch` (nearest prisoner) | `RubDownChance` per contraband item |
| Full | `search.full` | `/prisonsearch full` | Every contraband item |
| Random | Automatic | When the regime runs itself | `chancePerPhase`, `cells` per phase |

An intelligence report on a prisoner adds `IntelBonus` to every search of them for 24 hours. Finds are moved into the evidence store with the cell or prison number and time on the item, and logged. The prisoner gets a negative entry; at `ChargeAtSeverity` or above a 51(12) charge is raised for a governor to hear. A system intelligence entry is added too. Other resources can call `exports.vinewood_prison:SearchNearest(full)` from a radial menu.

### Black market

At `market` points prisoners buy contraband with a currency item (canteen goods by default). Prices rise as stock runs low, and by `HeatMultiplier` for `HeatMinutes` after staff seize contraband. Stock refills slowly.

### Intelligence

Staff submit reports graded on source (1 reliable, 2 untested, 3 not reliable) and intelligence (A to E), marked shareable or confidential. `intel.read` sees the log and a prisoner's reports in their file. Search history is on the Security page for everyone.

### Alarms and incidents (`Config.Incidents`)

- Staff bind *Prison: alarm* in FiveM key settings (`/prisonalarm`): general alarm, Code Red, Code Blue, fight or fire. Prisoners use the same key in their cell as a cell bell.
- Staff get a notification, a flashing map blip and, for priority 1, an alarm tone.
- Fights are detected when one prisoner hurts another (checked on the server for distance and health). A prisoner going down raises a Code Blue.
- `Riot.fights` fights within `Riot.windowSeconds` raise concerted indiscipline and, with `autoLockdown`, lock the prison down.
- Incidents are listed on the tablet. Staff mark themselves attending and close with a written report.
- Code Red and Blue go to `ambulance`, fire to `fire`, concerted indiscipline to `police` through the dispatch adapter.

### Lockdowns

Wing (`lockdown.wing`) or whole prison (`lockdown.prison`) from the Incidents page. Every door in scope locks, prisoners are told to return and anyone still out after `ReturnGrace` is returned to their cell. The regime cannot unlock those cells, and work and activities stop until it is lifted. Automatic lockdowns lift themselves after `AutoLiftMinutes` if nobody is on duty.

### CCTV

`cctv.view` opens the CCTV page and watches any camera. WASD pans and tilts like an operator's controls, the mouse fine-adjusts, scroll zooms (panning slows as you zoom in), R resets to the saved view, the arrow keys change camera, and Backspace returns to the tablet's CCTV page. Tune the feel in `Config.CCTV` (PanSpeed, MouseSensitivity, ZoomStep, Smoothing).

## Phase 5: contact and welfare (`config/social.lua`)

### Visits

1. Family and friends book at the visitor centre with the prisoner's number. Visitors with a job in `LegalJobs` book legal visits, which don't use the allowance.
2. Each incentive level has a daily allowance of social visits (`Allowance`). Bookings go into the next visiting session (`Phases`). Staff can approve bookings first (`RequireApproval`).
3. During the session the visitor checks in at the visits entrance. A drug dog may indicate on a visitor carrying contraband, which cancels the visit and logs intelligence.
4. Both are seated across a free table for `Duration`, or until the session ends.
5. A visitor can try to pass something with `/prisonpass`. If staff spot it, the item is seized, the visitor is banned for `BanDays`, and the prisoner is charged and flagged in intelligence.
6. Prisoners with nobody to visit can book a family visit at the kiosk; an NPC relative sits with them.

### Prison phone

- Every prisoner gets a PIN at reception, shown on the kiosk.
- They add contacts at the kiosk (marking solicitors as legal); staff approve them, or it's automatic when no staff are on (`ApproveContacts`).
- Credit is bought with spends at the kiosk. Calls cost `CostPerMinute`.
- At a phone point, the prisoner enters their PIN and picks a contact. If someone online has that number, their screen rings with a warning that the call is from prison. Answering joins both into a private **pma-voice** call channel.
- Calls end when either side hangs up (`/prisonhangup`, or E at the phone), credit runs out, the prisoner walks away, or lock-up or a lockdown starts.
- Calls are logged. `Monitor` flags all, a random share or none as monitored; legal calls never are.
- Phone numbers are looked up through lb-phone if it's running, otherwise the character's framework phone number.

### Gangs and reputation (`Config.Gangs`)

Prisoners earn reputation by winning fights, buying on the black market and holding territory. With enough reputation, `/prisongang` lets them start a gang, recruit the nearest prisoner, throw people out, and set other gangs as allies or rivals.

Territory points are counted every `TerritoryTick` seconds while cells are unlocked. The gang with the most members present for `ControlPoints` counts in a row takes it over. Held territory earns influence and reputation, and members pay `MarketDiscount` less at markets inside it. Rival gangs in the same territory alert security staff and log intelligence.

Staff with `intel.read` see gangs, members, relations and territory on the tablet's Gangs page; `gangs.manage` can break a gang up. Leaving prison ends membership.

### Healthcare and safer custody (`Config.Healthcare`)

Healthcare staff come from another job (default `ambulance`, set in `Config.Healthcare.Jobs`) and get the nodes listed there while on duty.

- **Requests:** prisoners ask for the GP, nurse, dentist and so on at the kiosk. Healthcare books an appointment and closes it with an outcome.
- **Medical notes:** confidential to healthcare staff.
- **Prescriptions:** given at medication rounds (`MedsRounds`). Prisoners collect from the medication hatch; anything not collected by the end of the round is logged as missed. `MedsItem` optionally hands over an item for each dose.
- **Safer custody plans:** a Custodial Manager or healthcare opens a plan with a check interval. Any officer records checks standing near the prisoner. When a check is overdue, staff are notified and the plan shows it in red.

## Phase 6: operations (`config/operations.lua`)

### AI officers and inmates

AI officers stand at `officer_post` points while the regime runs itself; ambient prisoners hang about at `inmate_spot` points while cells are unlocked. Both are local peds on each client, spawned only within `SpawnDistance`, so they cost no network traffic. When no staff are on duty, minor incidents are dealt with after `ResponseSeconds`: fighters are returned to their cells and placed on report, cell bells are answered, and the incident is closed with a report.

### Movements and escorts

Plan a court or hospital movement from the prisoner file, or a transfer from the Movements page. An officer starts the escort standing with the prisoner and completes it back at reception, or at the receiving prison for transfers. Transfers can go with a contractor when nobody can escort. While out, the prisoner is exempt from the boundary, but straying more than `EscortLeash` from every officer for 15 seconds is an escape. Overdue escorts alert staff.

Escort helpers for staff: `/prisoncuff`, `/prisonescort` (walk them), `/prisonvan` (seat them in the nearest vehicle). They only work on prisoners and escapees, so they won't clash with your police script.

### Escapes and recapture (`Config.Escape`)

With `Mode = 'escape'`, a prisoner outside the boundary for `GraceSeconds` has escaped. That triggers:

- a perimeter alarm and incident
- a police dispatch alert with a description
- an optional prison lockdown
- their MDT status set to unlawfully at large (`SetCustodyStatus(identifier, 'unlawfully_at_large', ...)`)

Sentence time stops while they are out.

Police (`PoliceJobs`) and prison staff use `/prisonrecapture` next to them. Recapture adds `AdditionalMinutes`, raises a 51(7) charge, sets category `CategoryAfter`, and holds them in segregation for `SegregationMinutes`. Walking back inside the boundary counts as handing themselves in, with half the extra time.

Prisoners with a lockpick can try doors (a skill check). A success opens the door for `PickSeconds`; a failure can break the pick and set off a door alarm. `Mode = 'contain'` keeps the old behaviour of returning them to their cell.

### Parole (`Config.Parole`)

Prisoners on sentences of at least `MinTermMinutes` can apply at the kiosk once they have served `EligibleFraction`. Each application is scored on incentive level, behaviour, proven adjudications, category, qualifications, work and escape history. A Duty Governor reviews it on the Parole page, sees the score breakdown, picks licence conditions and releases or refuses. If nobody reviews it within `AutoDecideMinutes`, the score decides. Release goes to MoJ as `type = 'parole'` with the conditions.

### Setup check

At start, and with `/prisoncheck` in game (editor ACE), the resource lists:

- missing points, cells, segregation cells and boundary
- ox_inventory items that don't exist
- phase ids in config that don't match the regime
- pma-voice not running

## Releasing it

- `fxmanifest.lua` keeps `config/`, `bridge/`, `integrations/`, `locales/` and `sql/` out of escrow, so buyers can configure and write adapters. Everything under `modules/`, `server/`, `client/` and `shared/` is escrowed.
- The built NUI is in `web/build`. Remove `web/src`, `web/package.json`, `web/package-lock.json`, `web/tsconfig.json`, `web/vite.config.ts` and `web/public` from the customer build if you don't want to ship the source; nothing at runtime needs them.
- `data/presets/` ships empty. Exported layouts for popular MLOs make good add-on products.

## Clothing

At reception the player's own look is saved, the prison uniform goes on, and at release their look comes back. With a supported clothing script the whole look is kept (hair, tattoos, face) and written back to the script on release, so a relog can never bring the uniform back.

| Clothing system | Supported through |
| --- | --- |
| 17mov Character System | its illenium-appearance bridge |
| illenium-appearance | `getPedAppearance`, `setPlayerAppearance`, `saveAppearance` |
| fivem-appearance | `getPedAppearance`, `setPlayerAppearance`, `saveAppearance` |
| qs-appearance | `getPedAppearance`, `setPlayerAppearance` |
| ESX skinchanger / esx_skin | `skinchanger:getSkin`, `skinchanger:loadSkin`, `esx_skin:save` |
| Anything else | GTA's clothing functions (clothes and props) |

`Config.Reception.Clothing = 'auto'` picks the one running; set a name to force one, or `'native'` for GTA's functions only. Set the uniform itself in `Config.Reception.Uniform`.

## Opening doors

| Where | Who |
| --- | --- |
| At a cell door or wing gate (E or target) | Officers with `cell.lock` (OSG and above), or anyone with a keycard of that door's level or higher |
| At a normal door (offices, stores) | Officers with `cell.lock`, or a keycard of that door's level (normal doors default to 2) |
| At a perimeter door | Supervising Officer and above (`door.remote`), or a keycard of that door's level (perimeter doors default to 3) |
| From the tablet, *Cells and doors* | Supervising Officer and above. Cells and gates are listed by wing; perimeter gates are under *Perimeter and other doors* |

**Door lockdown** (tablet, *Cells and doors*, Duty Governor and above) locks every door in the prison and holds them: nothing unlocks a door until it's lifted, except those same governors opening a single door. A full prison lockdown turns it on and off automatically.

Admins with the `vinewood_prison.admin` ace open every door; set `Config.AdminDoorBypass = false` to test as staff do.

Keycards are the `prison_keycard` item with `level` (1 to 5) in its metadata, e.g. `exports.ox_inventory:AddItem(source, 'prison_keycard', 1, { level = 3 })`. A door's level is set when it's added and can be changed with Edit in the editor.

## The officer tablet

The tablet opens inside a rugged device. Hover a button to see what it does.

| Button | Default |
| --- | --- |
| Power | Close the tablet |
| P1 | Roll |
| P2 | Incidents |
| P3 | Raise a general alarm (press twice within 3 seconds) |
| Home (bottom bezel) | Back to the roll |

Change them in `Config.Tablet.Buttons`: any page (`roll`, `regime`, `incidents`, `adjudications`, `industries`, `security`, `cctv`, `visits`, `movements`, `parole`, `healthcare`, `cells`, `audit`), `alarm` or `none`. Set `Config.Tablet.Device = false` for a plain window. The artwork is `web/build/tablet/frame.webp`; a replacement with the screen and buttons in the same places drops straight in.

## Interaction: prompts or targets

Every point placed in the editor is an [E] prompt, or an ox_target / qb-target zone if either is running (`Config.Interact.Target = 'auto'`; set `false` to force prompts). Doors and cells stay as [E] prompts.

Most prisoner features (phone, kiosk, workstations, meds hatch, hiding spots, the market) only show for players in custody. To try them as staff, run `/prisontest 60` (editor ACE) to go into test custody for 60 minutes, and `/prisontest release` to come out.

## Commands

| Command | Who |
| --- | --- |
| `/prisontablet` | Staff with `roster.view` (or use the `prison_tablet` item) |
| `/prisoneditor` | ACE `vinewood_prison.editor` |
| `/prisonsearch` | Staff: search the nearest prisoner (`rub` or `full` to skip the menu) |
| `/prisonsearchcell` | Staff: search the cell you're standing in |
| `/prisonalarm` | Staff: raise an alarm. Prisoners: cell bell. Bind it in key settings. |
| `/prisongang` | Prisoners: gang menu |
| `/prisonpass` | Visitors: pass an item across the table during a visit |
| `/prisonhangup` | End a prison call |
| `/prisoncuff`, `/prisonescort`, `/prisonvan` | Staff: escort helpers (prisoners and escapees only) |
| `/prisonrecapture` | Police and staff: recapture the nearest escapee |
| `/prisoncheck` | Editor ACE: setup check |
| `/prisonsoundtest [n]` | Play GTA's door and buzzer sounds one by one, with the config line for each |
| `/prisondoorcheck` | Toggle door labels: name, saved state, game state, and whether the door is at its saved spot |
| `/prisontest [minutes]` / `/prisontest release` | Editor ACE: go into test custody to try prisoner features |

## Permissions

Nodes are granted to ranks in `config/permissions.lua`; ranks inherit. Grades map to ranks per job in `Config.GradeRanks`. ACE `vinewood_prison.admin` grants every node. Anyone in custody has no staff permissions.

| Node | Default rank | Lets them |
| --- | --- | --- |
| `roster.view` | OSG | Open the tablet, see the roll, regime and adjudications |
| `account.view` | OSG | See prisoner accounts |
| `cell.lock` | OSG | Lock and unlock doors at the door |
| `cctv.view` | OSG | Watch CCTV |
| `alarm.raise` | OSG | Raise alarms |
| `intel.submit` | OSG | Submit intelligence reports |
| `reception.process` | Officer | Use the reception desk |
| `cell.allocate` | Officer | Move cells |
| `behaviour.add` | Officer | Add behaviour entries |
| `regime.run` | Officer | Unlock, lock up and count the roll |
| `adjudication.charge` | Officer | Place on report |
| `search.cell` / `search.person` | Officer | Cell, area and rub-down searches |
| `evidence.access` | Officer | Open the evidence store |
| `incident.manage` | Officer | Attend and close incidents |
| `transport.escort` / `escape.recapture` | Officer (and police) | Escorts, cuffs, recapture |
| `visits.manage` | Officer | Approve, cancel and end visits, lift visitor bans |
| `phone.manage` | Officer | Approve phone contacts, see the call log |
| `door.remote` | Supervising Officer | Doors from the tablet, wing lock-all |
| `search.full` | Supervising Officer | Full searches |
| `transport.manage` | Supervising Officer | Plan and cancel movements, contractor transfers |
| `lockdown.wing` | Supervising Officer | Wing lockdowns |
| `industries.manage` | Supervising Officer | Approve applications, give and remove jobs, add work orders |
| `iep.review` | Supervising Officer | Change incentive level |
| `segregation.place` | Custodial Manager | Start and end segregation |
| `category.set` | Custodial Manager | Change security category |
| `release.authorise` | Custodial Manager | Release from the tablet |
| `adjudication.hear` | Duty Governor | Hear adjudications |
| `sentence.adjust` | Duty Governor | Change the release date |
| `account.adjust` | Duty Governor | Adjust balances |
| `intel.read` | Custodial Manager | Read intelligence, see gangs |
| `welfare.manage` | Custodial Manager | Open and close safer custody plans |
| `gangs.manage` | Custodial Manager | Break up gangs |
| `healthcare.view` / `healthcare.manage` | Healthcare job | Requests, notes, prescriptions |
| `lockdown.prison` | Duty Governor | Whole-prison lockdowns |
| `audit.view` | Duty Governor | Audit log |
| `parole.review` | Duty Governor | Parole decisions |
| `adjudication.additional_days` | Governor | Give additional days at a hearing |

## Server exports

```lua
local inCustody, prisoner = exports.vinewood_prison:IsInCustody(source or identifier)
local prisoner = exports.vinewood_prison:GetPrisoner(source or identifier)

local ok, prisonNoOrError = exports.vinewood_prison:Imprison(source or identifier, {
    termSeconds  = 7200,
    remand       = false,
    releasePoint = 0.5,          -- optional, overrides config
    caseRef      = 'T20261014-0042',
    offences     = { { code = 'TH01', title = 'Theft' } },
    category     = 'C',          -- optional
    prison       = 'auto',       -- or a prison code
})

exports.vinewood_prison:Release(target, reason)
exports.vinewood_prison:AdjustSentence(target, seconds, reason)  -- +/- moves the release date
exports.vinewood_prison:MoveCell(target, cellId)
exports.vinewood_prison:SetDoorLocked(doorId, locked)
exports.vinewood_prison:IsDoorLocked(doorId)

exports.vinewood_prison:GetRegimePhase('VINEWOOD')             -- { id, label, locked, automated }
exports.vinewood_prison:GetPrivileges(target)               -- { level, label, spendLimit, wageMultiplier }
exports.vinewood_prison:AddBehaviour(target, 'positive', 2, 'Completed course')
exports.vinewood_prison:RaiseCharge(target, '51(12)', 'Found with a phone in cell')
exports.vinewood_prison:Segregate(target, 30, 'Pending investigation')
exports.vinewood_prison:GetAccount(target)                  -- { spends, private }
exports.vinewood_prison:AddFunds(target, 10, 'Kitchen shift') -- into spends
exports.vinewood_prison:GetJob(target)                      -- 'kitchen' or nil
exports.vinewood_prison:HasQualification(target, 'food_hygiene')
exports.vinewood_prison:AwardQualification(target, 'forklift', 'Forklift licence')
exports.vinewood_prison:GetStat(target, 'fitness')
exports.vinewood_prison:RaiseAlarm('VINEWOOD', 'fire', coords, 'Smoke from B wing')
exports.vinewood_prison:StartLockdown('VINEWOOD', 'Escape attempt')
exports.vinewood_prison:LiftLockdown('VINEWOOD')
exports.vinewood_prison:IsLockedDown('VINEWOOD')
exports.vinewood_prison:GetPrisonGang(target)             -- { id, name, rank, influence } or nil
exports.vinewood_prison:AddReputation(target, 5)
exports.vinewood_prison:Recapture(target)
exports.vinewood_prison:IsUnlawfullyAtLarge(target)

exports.vinewood_prison:RegisterHook('beforeRelease', function(payload)
    -- return false to block
end)
```

Hooks: `beforeImprison`, `beforeRelease`, `beforeDoorChange`, `beforeCellMove`.

Server events: `vinewood_prison:received (identifier, prisonNo)`, `vinewood_prison:released (identifier, prisonNo, reason)`, `vinewood_prison:escaped` and `vinewood_prison:recaptured (identifier, prisonNo)`, `vinewood_prison:gangCreated (gangId, name, identifier)`, `vinewood_prison:activity (source, 'gym' | 'library' | 'shower', key)` for tying gym sessions into your own skills script.

State bag: `Player(src).state['prison:prisoner']` = `{ prisonNo, category, iep, cell, status }` while in custody.

Imprisoning someone already in custody adds the term to their current sentence. A remand prisoner who is later sentenced keeps the time already served.

## Integration contracts

Adapters live in `integrations/` and are open source. `'auto'` picks the running resource, otherwise the fallback.

**Vinewood MoJ** (`integrations/justice/vinewood_moj.lua`) — MoJ calls `Imprison` after sentencing or remand. At discharge the prison calls:
```lua
exports.vinewood_moj:OnCustodyReleased(identifier, caseRef, {
    type = 'licence' | 'unconditional' | 'remand_release',
    licenceSeconds = 3600,
    prisonNo = 'A1234BC',
    reason = 'sentence_complete',
})
```

**Vinewood MDT** (`integrations/records/vinewood_mdt.lua`) — custody status changes:
```lua
exports.vinewood_mdt:SetCustodyStatus(identifier, 'in_custody' | 'released', {
    prisonNo = 'A1234BC', prison = 'Vinewood Prison', cell = 'A-1-01', releaseEstimate = 3600,
})
```

**Vinewood Dispatch** (`integrations/dispatch/vinewood_dispatch.lua`):
```lua
exports.vinewood_dispatch:CreateAlert({
    code = 'PRISON-CODE_RED', title = 'Code Red (bleeding) at Vinewood Prison', description = 'Cell A-1-03',
    coords = vec3(...), jobs = { 'ambulance' }, priority = 1, source = 'vinewood_prison',
})
```
**Phone numbers** (`integrations/phone/phones.lua`). The prison phone asks the server's phone script who owns the number a prisoner dials.

- **LB Phone:** the person's own phone rings with the prison as the caller (the *Phone caller name* in the editor's prison details, or the prison name). lb-phone carries the voice and the call shows in their recent calls. The prison still bills per minute and ends the call when credit runs out, the prisoner leaves the phone, or lock-up starts. Turn off with `Config.Phone.NativeCalls = false`.
- **Every other phone:** an answer or decline pop-up showing the prison name and the prisoner, with voice over **pma-voice** (`setPlayerCall`).

| Phone | Resource | How the number is found |
| --- | --- | --- |
| LB Phone | `lb-phone` | `GetSourceFromNumber`, `GetEquippedPhoneNumber` |
| Quasar Smartphone PRO | `qs-smartphone-pro` | `GetPhoneNumberFromIdentifier` |
| Quasar Smartphone | `qs-smartphone` | `qs-base` `GetPlayerPhone` |
| NPWD | `npwd` | `getPhoneNumber` |
| YSeries / YFlip / YPhone | `yseries`, `yflip`, `yphone` | `GetPlayerSourceIdByPhoneNumber`, `GetPhoneNumberBySourceId` |
| GKSPHONE v2 | `gksphone` | `GetSourceByPhone`, `GetPhoneBySource` |
| High Phone | `high-phone` | `getPlayerByPhone`, `getPlayerPhoneNumber` |
| RoadPhone | `roadphone` | `getPlayerFromPhone`, `getNumberFromIdentifier` |
| Anything else | | The character's number: `charinfo.phone` (Qbox/QBCore) or ESX `phoneNumber` |

The running phone is picked automatically (`Config.Integrations.phone = 'auto'`), or force one by name. The server console prints which one is in use at start. Numbers are stored as players type them and matched ignoring dashes and spaces, so `555-1234` and `5551234` are the same. To support another phone, add an adapter to `phones.lua` with `sourceOf(number)` and/or `numberOf(source)`.

Without a dispatch script, alerts go out as the server event `vinewood_prison:dispatch` (alert table), so any dispatch script can pick them up.

All three are called inside `pcall`, so a missing export logs a warning and never breaks custody.

## Logs

Everything important writes to `prison_audit` (visible on the tablet with `audit.view`). Discord webhooks per category are set in `config/logs.lua` (server-only file): `reception`, `release`, `sentence`, `doors`, `editor`, `security`, `custody`, plus `default`.

## NUI

React + TypeScript + Vite. The built UI is in `web/build`, so nothing needs building to run. To change it:
```
cd web
npm install
npm run build
```

## Phase 1 scope

Included: bridge (qbx/qb/esx, ox_inventory), migrations, cache, permissions, audit and Discord logs, module loader, estate editor with presets, server-owned doors and keycards, sentence engine (three time modes, offline credit, sweeps), reception (MoJ, API and manual desk), cell allocation by category, uniform and clothing restore, containment, release and property return, MoJ and MDT adapters, officer tablet (roll, prisoner file, cell moves, category, release date changes, release, cells and doors, audit log).

Phase 2 adds: regime scheduler (cycle or real clock, staffed and automated modes, grace period), roll checks, incentives scheme with automatic reviews, Prison Rule 51 adjudications with six punishment types, segregation, time-limited restrictions, prisoner accounts with ledger, wages by attendance, finance desk deposits, payout on release, canteen with spend limits and delivery rounds, and the prisoner kiosk.

Phase 3 adds: server-timed task engine, eight jobs with tasks, animations, levels and level-locked tasks, applications and approvals, work orders with completion bonuses, four courses with lesson questions and qualifications that unlock jobs, gym, library and showers with stats, and the Industries page on the tablet.

Phase 4 adds: contraband list, cell and hiding-spot stashes, cell, area, rub-down, full and random searches with evidence chain, automatic charges and intel, a black market with scarcity and heat pricing, graded intelligence reports, alarms with blips and an alarm tone, fight and Code Blue detection, concerted indiscipline, wing and prison lockdowns tied into the regime, incidents with attendance and reports, CCTV with an overlay, and the dispatch adapter.

Phase 5 adds: visit booking with allowances and legal visits, check-in with a drug dog, seated visits with item passing, bans and NPC family visits, the prison phone with PINs, approved contacts, credit, pma-voice calls and monitoring, gangs with reputation, recruitment, alliances, rivalries and territory control, and healthcare requests, confidential notes, prescriptions, medication rounds and safer custody plans with timed checks.

Phase 6 adds: AI officers and ambient inmates, automated incident response, court, hospital and transfer movements with contractor transfers and escort helpers, escapes with alarms, dispatch, MDT status, lockdown and recapture, lockpicking, scored parole with licence conditions, a preset list in the editor, a setup check, and version 1.0.0.
