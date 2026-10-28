# vinewood-mdt

British police MDT for Qbox, QBCore and ESX. PNC-style person and vehicle checks,
DVLA driver records, property lookups, custody records, PACE bail and interview playback.

## Requirements
- OneSync (on by default on current servers)
- ox_lib, oxmysql
- Optional: citydriving, RX Housing / qbx_properties / ps-housing / qb-houses / qs-housing,
  vinewood-interviews, ox_inventory (bail notice item)

## Install
Keep the folder named `vinewood-mdt`: other Vinewood scripts call it by that name.

1. Drop `vinewood-mdt` into your resources and `ensure vinewood-mdt` after your framework,
   licence, housing and interview resources.
2. Tables are created on first start (`sql/install.sql` if you prefer to run it yourself).
3. Edit `config.lua`: police jobs, force name, stations, offences, markers.
4. Open with `/mdt` or F6 (rebindable in Settings > Key Bindings > FiveM).

## Layout
PNC-style tablet: Dashboard, Persons, Vehicles, Incidents, Custody, Intelligence, Warrants,
CCTV / Interviews and CPS. CPS staff and solicitors only see their own sections.
Set `Config.ForceName`, `Config.ForceShort` (used in incident and custody numbers) and
`Config.ForceCrest` (image URL, or false for the built-in star).

## Dispatch / live calls
Live calls appear on the Dashboard and a Live calls page (waypoint, or turn a call into an incident).

| Script | How |
|---|---|
| cd_dispatch3d | `GetDispatchCalls_PS` export, read directly |
| cd_dispatch | `GetDispatchCalls_PS` export, read directly |
| ps-dispatch | `GetDispatchCalls` export, read directly |
| qs-dispatch | listens to `qs-dispatch:server:CreateDispatchCall` |
| rcore_dispatch | listens to `rcore_dispatch:server:sendAlert` |
| Anything else (tk_dispatch, core_dispatch, your own alerts) | one line next to the alert |

Scripts that only expose a "send alert" export (tk_dispatch, core_dispatch) give nothing to read
back, so add a line beside your alert:

```lua
-- server
exports['vinewood-mdt']:AddCall({ title = 'Store robbery', code = '10-90', coords = coords, priority = 1, jobs = { 'police' } })
-- client
TriggerServerEvent('vinewood-mdt:server:clientCall', { title = 'Shots fired', code = '10-71', priority = 1 })
```

Priority accepts numbers (1 = Grade 1), true/false, or words like "high"/"medium"/"low".
Calls the MDT stores itself drop off after `Config.Dispatch.KeepMinutes`.

## ANPR
**In-car.** Officers in a fitted vehicle (`Config.ANPR.Vehicles`, or every emergency vehicle if
left empty) with a job in `Config.ANPR.Jobs` get a front and rear camera. It turns on when they get
in (`/anpr` toggles it) and a strip at the bottom of the screen shows the last plate read each way.
A hit beeps, shows an alert with the plate, vehicle, keeper, reasons and what to do, and puts a
flashing blip on the car for a minute. Press `J` (`Config.ANPR.ViewKey`) to open the vehicle in the MDT.

**Moving the ANPR boxes.** `/anprlayout` (`Config.ANPR.LayoutCommand`) lets each player drag the
plate strip and the hit alert anywhere on screen. Save keeps it on their PC; Reset puts both back.

**Setting up in game.** `/anpradmin` (police at `ManageGrade`, or the ace `vinewood-mdt.anpradmin`):
- *Fit this model* gives every vehicle of the model you're sitting in ANPR; *Fit only this vehicle*
  fits that one car by its plate. Both add to `Config.ANPR.Vehicles`.
- *Place a camera here* puts a roadside camera where you stand, facing the way you face, with a
  name, read distance (shown as a zone while you set it) and an optional camera pole.
- *Cameras* lists every camera, nearest first: go to it, rename, change distance, move it to you,
  switch it off or remove it. *Show camera zones* draws every camera's read area.
- Changes apply to everyone straight away and are saved in the database. The MDT's ANPR page has a
  "Cameras and fitted vehicles" tab listing both, where supervisors can switch off or remove them.
Config cameras and models still work and show as "config.lua".

**Roadside cameras.** `Config.ANPR.Cameras` lists fixed cameras. When anyone drives past one, their
plate is checked; a hit alerts on-duty police (or only officers with ANPR on, see `CameraAlerts`)
and appears on Live calls.

**What causes a hit**
- Plates put on ANPR from the MDT (ANPR page, or "Add to ANPR" on a vehicle). Any plate, with a
  reason, an action (stop, arrest, report sighting...), notes and an expiry.
- Vehicle markers listed in `Config.ANPR.HitMarkers` (Stolen, No insurance, Seize s.165...).
- Keeper checks: keeper wanted, keeper disqualified (citydriving), keeper bailed not to drive.

Every hit is logged. The ANPR page shows recent hits and the plates on ANPR, and hits appear in
the vehicle record's activity as "ANPR hit".

## Audit log
Every person or vehicle check needs a lawful purpose (`Config.Audit.Reasons`). Officers pick it
once; it shows in the header and applies until they close the MDT or change it. Searches, record
views, interview playback, CPS and solicitor access, and sensitive changes (removing markers,
deleting records, lifting disqualifications, closing warrants, NFA, custody reviews and
extensions) are logged with who, what, when and why.

Supervisors (`Config.Audit.ViewGrade`) get an Audit log page with filters, and an "Access log" tab
on every person showing who opened that record and why. Entries older than `KeepDays` are removed
on start.

## Custody clock
Records that are "In custody" show a PACE clock: time in custody against the limit, the next
review (6 hours, then every 9) and overdue warnings. Inspectors record reviews with a reason;
superintendent and court extensions raise the limit to 36, 72 or 96 hours.
`Config.Custody.HourLength` sets how many real minutes make one custody hour (default 2, so the
24 hour limit is 48 real minutes).

## Custody photos
"Take custody photo" points a camera at the detainee's face, takes a screenshot on the officer's
client (screenshot-basic) and the server uploads it to Fivemanage. The newest custody photo becomes
the PNC photo; older ones stay in the photo history. Put your Fivemanage media key in
`server/sv_config.lua` (server only, never sent to players) or the `fivemanage_key` convar.
The officer must be within `Config.Mugshot.MaxDistance` of the detainee.

## Stop and search
Record the person (pick from people nearby, or describe them if they won't give a name), the power,
the object, grounds, location, vehicle, what was found and the outcome. Officers must tick GOWISELY
before saving. s.60 and s.60AA ask for the authorisation instead of grounds. The person searched
gets an on-screen record with the reference (and an item if `ReceiptItem` is set). An "Arrest"
outcome goes straight to a new custody record.

## Fines and traffic offence reports
Issue from the Fines and TORs page or a person's Fines tab. Pick the person (nearby, or from their
record), the type and the offences from `Config.Fines.Offences`:
- **FPN** (fixed penalty, traffic) and **PND** (penalty notice for disorder): the person gets a notice
  with the amount and pays with `/fines` from their bank within `DueDays`. Endorsable offences add
  points through citydriving straight away, so the driver must be in the city. Unpaid after the due
  date, the amount goes up by `UnpaidIncrease` %.
- **TOR** (traffic offence report): no fine at the roadside; it waits for court. A supervisor records
  the court result: fine (then payable with `/fines`), points and an optional disqualification.

`Config.Fines.OnPaid(amount, fine)` runs on every payment, for paying fines into a society account.

## Statements (MG11)
On an incident, "Take statement": officer, witness, victim or expert. Officer statements are signed
when saved. Others go to the person's screen, where they read it with the MG11 declaration and type
their name to sign, or refuse. The officer is told either way; unsigned statements can be sent again.
Signed statements are added to the CPS case file automatically.

## Discord webhooks
Put webhook URLs in `server/sv_config.lua` under `SvConfig.Webhooks.Channels`: audit, custody,
warrants, cps, fines, statements, stopsearch, anpr. Leave any empty to switch it off. Searches only go
to the audit channel if `AuditSearches = true`. Messages are queued per channel to stay within
Discord's rate limits.

## vinewood-vehicleservices (insurance, MOT, tax)
Used automatically when `vinewood-vehicleservices` is running (the old name `vinewood-motinsurance`
also works). Nothing to paste in: the snippets from its INTEGRATION.md are already built in.
- **Vehicle record:** Insurance (MID) with cover, holder, policy number, expiry and named drivers;
  MOT status, expiry and last test with defects; Tax (VED) with band, expiry or SORN. MOT tests show
  in the vehicle's activity.
- **Check driver:** on a vehicle record, pick the driver from people nearby to see if they're insured
  to drive that vehicle (policyholder, named driver or any driver), plus their licence, wanted status
  and any not-to-drive bail condition.
- **Searches and lists:** No insurance, MOT fail, No MOT, Untaxed and SORN show as status badges on
  vehicle search results and a person's vehicles.
- **ANPR:** No insurance / insurance void and dangerous MOT fails are red hits; no MOT, untaxed and SORN
  on the road are amber. Each can be switched off in `Config.VehicleServices`.

## Sentencing guide
A **Sentencing guide** page (police and CPS) lists every offence with the court it's tried in, the
real statutory maximum, which out-of-court disposals can be suitable (community resolution, simple
caution, penalty notice) and the guide range for your server (fine, community order, custody).

The **calculator** (from the guide, a custody record, or the CPS charging decision) takes the
offences, the person's record (previous convictions and whether they're on bail are ticked
automatically), aggravating and mitigating factors and the plea, and suggests:
- whether an out-of-court disposal is suitable (every offence allows it, admitted, no previous
  convictions, no serious aggravation);
- fine, community order, suspended or immediate custody, with a custody range;
- the guilty plea reduction (a third at the first opportunity, a quarter later, a tenth at trial);
- driving disqualifications and notes for each offence.

Everything is in `sentencing.lua`: ranges, out-of-court options, notes, factors and their weights,
and `MinutesPerUnit` to match your prison script (1 month in the guide = 1 minute by default).
Offences without an entry still work; they just show "no guidance set".

## Incidents and evidence
Officers raise incidents (type, grade, location filled from where they stand), link people with a
role (suspect, victim, witness...) and vehicles, and record exhibits. Each exhibit gets a reference in
the officer's initials (JC/1, JC/2...) and keeps a continuity log as it moves: seized, property
store, forensics, CPS, returned or destroyed. "Book in" on a linked person opens a custody record
tied to the incident.

## Custody outcomes
New custody records start as "In custody". The Custody page lists everyone still in, and
"Record outcome" moves them on (charge, bail, RUI, NFA, caution...).

## Intelligence and warrants
Intelligence is graded 3x5x2 (source, assessment, handling) and can be about a person, vehicle or
place. Arrest warrants and FTA warrants make a person show as WANTED on searches and on the
dashboard; search warrants are recorded against an address.

## Vehicle record
Keeper, address, keeper licence, insurance marker, linked persons from incidents, intelligence,
notes and a timeline. The vehicle photo comes from docs.fivem.net for base-game models; addon
vehicles show a placeholder.

## Licences
Every enabled source that is running is checked and shown side by side.

| Source | How it is read |
|---|---|
| vinewood_licensing (or the older citydriving) | `GetLicenceData`, `GetPoints`, `IsBanned`, `GetPendingActions`. The first one running in `Config.Licences.dvla.resources` is used. |
| Qbox / QBCore | `metadata.licences` (driver, weapon, business...) |
| esx_license | `user_licenses` table |
| Anything else | `Config.Licences.custom = function(citizenid, src) ... end` |

Officers can endorse (points with DVLA codes) and disqualify. With **vinewood_licensing** this works
when the driver is offline too: the action is queued and applied at their next login, and the DVLA
panel lists what's waiting (supervisors can cancel it). With the older citydriving, the driver has to
be in the city. Totting-up bans are reported back the moment they trigger. Supervisors
(`Config.SupervisorGrade`) can also lift a disqualification, clear points (appeal or error) and revoke
a single category (driver online). Driving categories aren't repeated in the "Certificates and
permits" panel, since the licence script keeps them in the same metadata.

## Housing
Next Housing (Nextcore) is read through its server export `GetPlayerHouses(identifier, { includeKeyAccess = true })`, so owned houses and houses the person has a key to both show. The character id is tried first, then their licence (from the saved character when offline).

RX Housing is read through its `GetOwnedProperties` export (tried with citizenid, then licence).
qbx_properties, ps-housing, qb-houses and qs-housing are read from their tables; columns are checked
first, so a missing script or a different schema is skipped instead of erroring. Properties with
coordinates get a street and area resolved in game. Add others with `Config.Housing.custom`.

If an RX Housing owner shows no property, run this in the server console and check the shape:
```lua
print(json.encode(exports['RxHousing']:GetOwnedProperties('CITIZENID'), { indent = true }))
```

## Bail
Release on bail from a person or straight from a custody record. Types: pre-charge (s.37 PACE),
released under investigation, charged and bailed to court, street bail (s.30A).
Conditions are configurable; "reside at" is pre-filled from their housing.

- The released person gets an on-screen bail notice, and optionally an item (`Config.BailNoticeItem`).
- Bail shows as a banner on person and vehicle checks, and on the Briefing page when due within 48 hours.
- Overdue bail shows as "Failed to answer bail". Recording a breach adds a Wanted marker.
- `Config.OnBailGranted(target, bail)` lets you free them from your custody script.
- Server event: `vinewood-mdt:server:bailGranted (bail, target)`

## No further action
Available on a custody record and on active bail. It marks the record "No further action",
cancels any bail for it, withdraws a pending CPS file (if `Config.CPS.PoliceCanWithdraw`), and tells
the person if they are in the city. Server event: `vinewood-mdt:server:noFurtherAction (cid, recordId, reason)`

## CPS
Officers submit a custody record to the CPS with proposed charges, a case summary and an evidence list.
Players with a job in `Config.CPS.jobs` get a CPS-only view: a queue of cases, the full case file
(summary, evidence, arrest record, interviews they can play, previous custody) and a decision form
that follows the Full Code Test:

1. Evidential stage: realistic prospect of conviction?
2. Public interest stage (only once the evidential stage is met).

| Decision | Allowed when | Effect |
|---|---|---|
| Charge | Both stages met | Record set to Charged, suspect and officer told |
| No further action | Either stage not met | Record set to NFA, bail cancelled, suspect told |
| Further evidence | Any time | Action plan goes back to the officer, who adds evidence and resubmits |

Every step is kept in the case history. Server event: `vinewood-mdt:server:cpsDecision (caseId, decision, case)`

## Defence solicitors
Players with a job in `Config.Defence.jobs` get a "My clients" view and nothing else. They see only
the cases a custody officer has assigned them to, and every request is checked against that
assignment on the server.

Officers assign a solicitor from a custody record: solicitors in the city are listed, and typing a name finds any character with a job in `Config.Defence.jobs`, in the city or not
and write the pre-interview disclosure. Editing it notifies the solicitor. Removing the solicitor ends
their access immediately; assignments also lapse `ExpireDaysAfterClose` days after the case is
charged or NFA'd.

The disclosure pack shows the officer's disclosure plus whatever `Config.Defence` allows: offences,
bail, the CPS outcome and interview recordings. The full arrest narrative is hidden by default.
With `ShowHistory`, solicitors also see their client's own history: previous custody records and
outcomes (with a count of convictions and cautions), bail and fines. They never see warning markers,
intelligence, vehicles, licences or addresses.

With `Notes`, solicitors keep private notes on each client (add, edit, delete). Notes are stored
against the solicitor and client, carry over between that client's cases, and are never shown to the
police or the CPS.

Interview recordings are matched to a solicitor's case by custody reference only, so officers should
enter the custody reference (e.g. LSC/2610/00012) as the case reference when starting an interview.

## Interviews
When `vinewood-interviews` is running, an Interviews section and a person tab appear. Interviews are
matched by interviewee name or by the person's custody/bail references. Playback runs every speaker
track and the CCTV video against one clock, with per-speaker mute and failed uploads shown hatched.
Access is set by `Config.Interviews.jobs`.

With vinewood-interviews 1.7 or later, officers starting an interview search the MDT for the interviewee and pick one of their cases, so the interview is linked to the person's citizen ID and the case reference. It then shows on their record and case however the name was typed. Exports used: `SearchPeople(q, limit)` and `GetCasesForPerson(cid)`.

Linked interviews show in three places in the MDT: on the custody record they were recorded under
(play straight from the record), on the incident page (by the incident reference or any custody
reference from that incident), and in the person's Interviews tab.

## Exports
```lua
exports['vinewood-mdt']:GetActiveBail(citizenid)      -- bail table or nil
exports['vinewood-mdt']:GetMarkers('person', citizenid) -- or ('vehicle', plate)
```

## Ambulance service (vinewood-emsmdt)
Requires `vinewood-emsmdt` 1.0+ running. Configure with `Config.Ambulance`.
- **Injury statements:** an incident with linked people shows an "Injury statements" panel. "Request from ambulance" alerts on-duty clinicians. Their reply appears on the incident with the clinician's name and the ePRF reference. Police only see the statement, never the patient record.
- **In hospital:** a person's record shows a banner while they're admitted (`ShowAdmissions`).
- **System status:** the dashboard shows whether the ambulance MDT is connected.

### Injury statements in the CPS file
Injury statements the ambulance service has provided on the incident an arrest came from are added to
the CPS case file automatically, with the clinician, time and ePRF reference. Requests still waiting are
counted so the lawyer knows more evidence is coming.

## Vinewood Dispatch

When `vinewood-dispatch` is running, the MDT uses it ahead of any other dispatch script:

- **Live calls** show the call number, requesting unit, vehicle, weapon, caller, attached units and the latest call update.
- **Attach / Detach** attaches the officer to the call. The dispatch sets the waypoint, or follows the requesting unit's live blip for backup calls.
- **Updates** opens the call's update log, where officers can post updates. These appear in the dispatch log and on the other MDT for joint calls.
- **Create incident** copies the vehicle, caller and all call updates into the narrative.
- The page refreshes as soon as a call changes.

Set `Config.Dispatch.Service` if your police service key in vinewood-dispatch isn't `police`. To ignore it, set `Config.Dispatch.Sources['vinewood-dispatch'] = false`.

### Callsigns

When vinewood-dispatch is running, the MDT uses the callsign saved there (`/callsign` in game), falling back to `metadata.callsign`.

## Courts, prison and probation (vinewood-moj)

When `vinewood-moj` 1.0+ is running (configure with `Config.MoJ`):

- **Charge → court.** A CPS *charge* decision opens the court case in the MoJ and lists the first hearing, carrying over the charges, case file, statements, solicitor and bail.
- **Court and sentences tab** on a person's record: their cases, pleas and verdicts, next hearing, sentences, live probation orders and outstanding court fines.
- **Banners** show when the person is in prison (with time left) or subject to a licence, suspended sentence or community order and its requirements.
- **Court warrants** (failing to appear, fine default, breach, recall) appear in Warrants and flag the person as wanted. Marking one **Executed** sends the case straight back before the court.
- **Court bail** replaces the police bail record's conditions and return date with the court's.
- **Court results** are added to the person's activity timeline.
- **Remand release:** `Config.OnBailGranted` calls the MoJ's `ReleaseFromCustody`, so bailing someone held on remand lets them out of prison.

## Prison (remand)
Recording **Remanded in custody** as a custody outcome sends the person to your prison script on remand
(the officer can set how long, default `Config.Prison.RemandMinutes`). The outcome is only saved if the
prison took them. Releasing them on bail or NFA lets them out again (`ReleaseOnBail`).

| Script | How | Offline |
|---|---|---|
| vinewood_prison | `Imprison` as a remand prisoner (keeps time served if later sentenced), `Release` | Yes |
| rcore_prison | `Jail(id, minutes, reason, officer)`, `Unjail` / `UnjailOffline` | Release only |
| tk_jail | `jail(id, minutes)`, `unjail(id)` | No |
| qb_tk_jail | `jail(id, minutes)` | No |
| qb-prison | sets `injail` and sends them like qb-policejob does | No |
| Anything else | `Config.Prison.Custom` / `CustomRelease`, or add an adapter in `server/prison.lua` (open file) | |

`Config.Prison.resource = 'auto'` uses the first one running; name one to force it.

vinewood_prison also reports back: `exports['vinewood-mdt']:SetCustodyStatus(identifier, 'in_custody' | 'released', { prisonNo, prison, cell, releaseEstimate })`
puts an **In prison** banner (prison, prison number, cell, expected release) on the person's record.

## Evidence storage
Every exhibit can have its own **evidence bag**: a stash in your inventory script.

| Inventory | Bags | Opening |
|---|---|---|
| ox_inventory | Stash locked to police jobs | Client |
| qb-inventory 2.x | `CreateInventory` / `AddItem` / `RemoveItem` / `ClearStash` | Server `OpenInventory` |
| qs-inventory | `AddItemIntoStash` / `RemoveItemIntoStash` / `GetStashItems` | Stash open event |
| ps-inventory, lj-inventory, qb-inventory before 2.0 | `stashitems` table | Stash open event |
| Anything else | Add an adapter in `server/inventory.lua` (open file) | |

`Config.Evidence.Inventory = 'auto'` picks the one running; name one to force it. With qs, ps, lj and
old qb, any player who knows a bag's name could open it through that inventory's own stash event (those
inventories have no job lock on stashes); ox and qb 2.x don't have that problem. Bail notice and stop
and search record items also go through the same bridge.
- **Seize from suspect** (incident page): pick a person linked to the incident, *Search their pockets*
  to see what they carry, tick items and amounts. They move from the suspect's inventory into a new
  exhibit's bag, with metadata (serial numbers etc.) kept. The suspect is told what was seized.
  The officer must be within `Config.Evidence.SeizeDistance` of them.
- **Open bag** closes the MDT and opens the stash, so officers can add or take items. Set
  `RequireStore = true` and list `Stores` to only allow it at a property store.
- **Link suspect** ties any exhibit to a suspect (e.g. a weapon found in an alley), separately from
  who it was seized from.
- **Return to owner** gives everything back (owner must be next to the officer); anything they can't
  carry stays in the bag. **Destroy** (supervisors) empties the bag.
- Every action is added to the exhibit's continuity log and the audit log.

Exhibits linked to a person, either seized from them or as the suspect, show in an **Evidence** tab on
their record, and in the CPS case file for that arrest. Without a supported inventory, exhibits still
work as written records.

## Forensics
Shooting leaves **shell casings** and getting hurt leaves **blood** where it happened. Officers find them
in forensics mode (`/forensics`, or just hold a torch): casings show as small yellow markers, blood as red
splats. Press **E** to collect. Then, on the incident in the MDT:
1. **Bag forensic samples** turns the samples you collected into exhibits (one each).
2. **Send to lab** on an exhibit. Results come back after `LabMinutes` and the officer is told.

**Results**
- **Blood**: a DNA profile. If the person is on the DNA database, it names them.
- **Shell casing**: the weapon type and the serial number of the gun it was fired from (when the inventory
  gives weapons serials), other incidents where the same gun was fired, and any seized weapon with that
  serial. Some casings (`CasingDNAChance`) also carry the shooter's DNA.
- A match links the person to the incident as a **Suspect** and to the exhibit, so it shows on their
  record and in their CPS file.

**DNA database**: booking someone into custody takes their DNA (`DNAOnArrest`), or use *Take sample* on
their record. When someone is added, older samples with no match are checked again and the officer who
sent them is told about the hit.

Traces disappear after `TraceMinutes` if nobody collects them. `IgnoreJobs` stops chosen jobs leaving
casings (e.g. police on the range).

### Fingerprints
Getting into a vehicle (or trying its door) without gloves leaves that person's prints on it for
`PrintMinutes`. Gloves are worked out from the arms clothing (component 3): anything not listed in
`Config.Forensics.NoGloves` counts as gloves, so add bare-arm IDs from your clothing packs there.
In forensics mode, stand next to a vehicle and press **G** to dust it; each set of prints becomes a sample
to bag on the incident and send to the lab. A match against the **fingerprint database** links the person
as a suspect. Booking someone in takes their prints (`PrintsOnArrest`), or use *Take prints* on their
record; earlier lifts are re-checked when someone is added.

## ANPR speed
In-car ANPR measures the speed of the vehicles it reads. The strip at the bottom shows the plate and speed
in front and behind (red when over), the speed limit of the road and your own speed.
- Limits come from the street name: `Config.ANPR.Speed.Streets`, then `Patterns` (Fwy 70, Hwy 60...), then `Default`.
- A speeder over the limit + 10% + 2 (UK guidance, `Tolerance`) is recorded automatically and alerts as an
  amber ANPR hit (`AutoRecord`, `AlertOfficer`).
- Press **K** (`/anprlock`) to lock the vehicle in front: its speed, the limit, your own speed, time and
  place are saved as evidence even if it's under the limit.
- **Speed cameras**: give a roadside camera a speed limit in `/anpradmin` (or `speedLimit` in config) and it
  records anyone over it.
- The ANPR page's **Speed detections** tab lists everything with the keeper. *Ticket keeper* opens a fixed
  penalty (SP30) filled in with the speed, limit, device and time, and marks the detection as ticketed.
  Speed checks also show in the vehicle record's activity.
