# vinewood-emsmdt

Ambulance service MDT for FiveM (Qbox, QBCore or ESX). It is a separate resource from `vinewood-mdt`, with its own branding.

## Install
1. Drop `vinewood-emsmdt` into your resources folder.
2. Add `ensure vinewood-emsmdt` after `ox_lib`, `oxmysql` and your framework.
3. Tables are created automatically on start. `sql/install.sql` is there if you prefer to run it yourself.
4. Open with `/emsmdt` or F7 (change in `config.lua`).

## Branding
Everything is in `Config.Branding`: service name, short name, logo (a file in `web/img/` or an https URL) and the Battenburg colours. Replace `web/img/logo.svg` with your own logo.

## OSP Ambulance V2 items
The formulary and interventions in `config.lua` use OSP Ambulance V2's own item names (`epinephrine`, `morphine`, `narcan`, `paracetamol`, `tramadol`, `vicodin`, `blood500ml_ominus` and so on). On start, any configured item missing from your inventory is printed in the console, and it's greyed out in the prescribe list.

Recording a drug or intervention in an ePRF does not take the item. OSP removes it when you actually use it from its treatment menu, so nothing is taken twice.

## Prescriptions
Advanced Paramedics and above can prescribe Paracetamol, Tramadol, Vicodin, Xanax, Melatonin and Cough Syrup. These are the OSP items that treat its conditions (pain, anxiety, insomnia, respiratory infection).
- If the patient is within `Config.Prescriptions.handoverDistance` (5 m), they're handed the item straight away with the instructions on it.
- If they're not, it's saved as "not collected". Press **Hand over** on their record when you're with them.
- Uncollected prescriptions can be cancelled by the prescriber or a supervisor.
- Items are given through ox_inventory, qs-inventory, qb-inventory or ESX, whichever is running.

## Jobs and ranks
- **Jobs:** the MDT opens for any job in `Config.Jobs`, plus every job your framework marks as EMS (`type = 'ems'` in QBCore / Qbox) when `Config.AutoEmsJobs` is on.
- **Rank names:** these come from your framework's job grades (`Config.UseFrameworkRanks`), so the MDT shows exactly what your jobs file says.
- **Scope:** `Config.Ranks` only decides clinical scope. Key it by grade number (`[2] = {...}`) or by grade name (`['paramedic'] = {...}`). A name match wins. Otherwise a grade uses the nearest numbered entry at or below it.
- **Checking it:** on start, the server console lists every EMS job grade and the scope it gets, for example:
```
[vinewood-emsmdt] ambulance grades:
    0  Recruit                      -> Paramedic (limited formulary)
    1  Paramedic                    -> Advanced Paramedic (full formulary, prescribe)
```
If a grade gets the wrong scope, add or change its entry in `Config.Ranks`.

## Clinical scope
`Config.Ranks` maps job grades to scope. The defaults are:
- Paramedic: Epinephrine, Morphine, Naloxone and Paracetamol only. No prescribing or blood.
- Advanced Paramedic: full formulary and prescribing. No blood.
- Critical Care Paramedic (HEMS): full formulary, prescribing and blood transfusion. Receives HEMS alerts.
- Clinical Team Leader (example grade 3): as CCP, plus the audit log, amending any ePRF and reopening incidents.

Scope is enforced on the server. Each medication or intervention is stamped with the clinician who added it.

## Flatline protocol
If an arrest rhythm is recorded, or the "flatlined" box is ticked, the ePRF can only be finalised as "Conveyed to hospital" or "Deceased (ROLE)". Set `Config.Protocol.flatlineRequiresConveyance = false` to turn this off.

## Features
- Dashboard with open incidents (Cat 1 to 4), on-duty crews, callsigns and unit status.
- Incidents: raise, attach units, set a waypoint, request HEMS, close.
- Patients: search by name or ID (case-insensitive), with a logged reason for every record opened. The record holds allergies, conditions, regular medication, next of kin, alerts and prescriptions.
- ePRFs: incident times, ABCDE assessment, observations with automatic NEWS2, ECG/arrest, medication and interventions, outcome and ATMIST handover. Records can be saved as drafts, finalised and locked, then amended.
- Admissions: finalising an ePRF as "Conveyed" admits the patient automatically. Patients can then be discharged with notes.
- Police requests: officers request an injury statement and clinicians reply. Police only ever see the statement, not the full ePRF.
- Revive kit log: an OOC log of Emergency Revive Kit uses, kept separate from clinical records.
- Audit log (supervisors) and Discord webhooks per category (`Config.Webhooks`).

## Editing ePRFs
- **Drafts:** every entry (observations, medication, interventions) has an edit button. The original clinician stays the author, and the editor's name and time are added.
- **Finalised ePRFs:** press **Edit ePRF** and give a reason. The ePRF is checked against the same rules as finalising (flatline conveyance, receiving hospital and scope of practice) before it saves.
- **History:** each edit keeps the previous version. It shows under **Edit history** with who, when, why and which sections changed, and **Previous version** shows the ePRF as it was. Edits also go to the audit log and the `eprf` webhook.
- **Admissions:** if the outcome changes to or from "Conveyed", or the hospital changes, admissions are updated to match.
- **Who can edit:** the attending crew and supervisors. `Config.Editing.crewWindowHours` can limit crew to a set time after finalising, and supervisors can always edit. Set `Config.Editing.enabled = false` to allow amendments only.

## Training and qualifications
The **Training** page holds a record for every clinician. Records are created automatically the first time someone opens the MDT, or added by a trainer for new starters.
- **Rank history:** the rank comes from the job grade. Promotions and other rank changes are logged automatically when the person next opens the MDT.
- **Competencies:** signed off by trainers or supervisors (`trainer = true` on a rank, or supervisors), with expiry set from `expiryMonths`. They show as Valid, Expiring (within `warnDays`), Expired or Revoked. Clinicians can't sign off their own.
- **Courses:** recorded with a date, result and optional score. A pass signs off the competencies listed in the course's `grants`, for example the CCP course signs off HEMS and Blood transfusion.
- **Certificates:** issued with an automatic `CERT-` reference and an optional expiry.
- **Probation:** start and review dates, with a status of active, extended, passed or not passed, plus notes. The roster flags reviews that are overdue.
- **Revoking:** supervisors can revoke a competency or certificate with a reason. The record is kept, and revoking a competency revokes every live sign-off for it.
- **Alerts and logging:** clinicians see a dashboard banner when anything is expiring within `warnDays` or has expired. Everything is logged in the person's history and the `training` webhook.

**Scope depends on competencies** (`Config.Training.ScopeRequires`). Blood transfusion needs a valid Blood transfusion competency, prescribing needs Independent prescribing, and HEMS taskings need HEMS, on top of rank. If one expires or is revoked, that scope is removed straight away: the formulary greys out, the clinician's MDT refreshes and HEMS alerts skip them.

**When you first install:** a supervisor should press **Sign off existing rank holders** on the Training page. It signs off the scope competencies for everyone whose rank already has them, so current CCPs and prescribers don't lose scope. Alternatively, set `enforceScope = false` to keep records without changing scope.

Exports: `exports['vinewood-emsmdt']:HasCompetency(citizenid, 'hems')` and `GetStaffRecord(citizenid)`.

## Live 999 calls
The dashboard lists live ambulance calls from the same dispatch scripts as the police MDT: cd_dispatch3d, cd_dispatch, ps-dispatch, qs-dispatch and rcore_dispatch. Only calls for `Config.Dispatch.Jobs` are shown (`ambulance` and `ems` by default). "Raise incident" turns a call into an MDT incident with its category, location and waypoint. Raising the same call twice opens the existing incident. Other scripts can push calls with `exports['vinewood-emsmdt']:AddCall({ title, code, message, location, coords, priority, jobs })`.

### Vinewood Dispatch link
Raising an incident from a Vinewood Dispatch call links the two. Attaching or detaching on either the MDT incident or the dispatch call updates the other. Clinicians already attached to the call join the incident when it's raised. The link is stored on the incident (`dispatch_id`), so it survives restarts.

## Police MDT link
With vinewood-mdt 2.10+, officers can request injury statements from an incident. They see your reply there, and the person's record shows "In hospital" while they're admitted.

## Exports (server)
```lua
-- Dispatch / 999 calls
exports['vinewood-emsmdt']:CreateIncident({ title = 'Cardiac arrest', details = '...', location = 'Legion Square', coords = vec3(...), category = 1, source = 'ps-dispatch' })
TriggerEvent('vinewood-emsmdt:createIncident', { ... })  -- same, as a server event

-- Police MDT
local id = exports['vinewood-emsmdt']:RequestInjuryReport({ caseRef = 'NB-0042', citizenid = 'ABC123', patientName = 'John Smith', officerName = 'PC Jones', notes = 'Assault, facial injuries' })
local list = exports['vinewood-emsmdt']:GetInjuryReports('NB-0042')   -- { status, statement, clinician, ePRFRef, ... }
local admitted, info = exports['vinewood-emsmdt']:IsAdmitted('ABC123') -- e.g. block custody while in hospital
AddEventHandler('vinewood-emsmdt:injuryReportAnswered', function(requestId, caseRef) end)

-- Medical script: log Emergency Revive Kit uses
exports['vinewood-emsmdt']:LogERK(medicSrc, targetSrc, 'Killed by a modder', 'notes')
```

## Exports (client)
`exports['vinewood-emsmdt']:openMDT()` and `closeMDT()`. To require a tablet item, set `Config.Item` and call `openMDT` from the item (for example an ox_inventory `client.export = 'vinewood-emsmdt.openMDT'`).

## Live vitals
"Pull vitals from patient" on the Observations tab reads the nearest patient (within 5 m) from OSP Ambulance V2 using `exports.osp_ambulance:GetAmbulanceData`.
- **Observations:** pulse, blood pressure, SpO2, temperature, pain, and AVPU (U if the patient is down or unconscious). OSP doesn't track respiratory rate, GCS or blood glucose, so enter those yourself.
- **ECG:** OSP's cardiac state fills the rhythm, and an arrest rhythm ticks the flatline box.
- **Exposure:** fractures, bleeding, blood volume and overdose signs are added to the Exposure field.
- **Blood type:** filled on the patient record if it's empty.
Change `Config.Vitals.resource` if your OSP folder isn't called `osp_ambulance`. For another medical script, set `Config.GetVitals`.

## Vinewood Dispatch

When `vinewood-dispatch` is running, the MDT uses it ahead of any other dispatch script:

- **Live 999 calls** on the dashboard show the call number, requesting unit, vehicle, weapon, caller, attached units and the latest call update.
- **Attach / Detach** attaches the clinician to the call. The dispatch sets the waypoint, or follows the requesting unit's live blip for backup calls.
- **Updates** opens the call's update log, where clinicians can post updates. These appear in the dispatch log and on the other MDT for joint calls.
- **Raise incident** copies the unit, vehicle, caller and all call updates into the incident details.
- Attaching sets the unit to **En route** on the On duty list; detaching puts them back to **Available** (unless they're on an incident).
- Callsigns are shared with the dispatch (see Callsigns below).
- The page refreshes as soon as a call changes.

Set `Config.Dispatch.Service` if your ambulance service key in vinewood-dispatch isn't `ambulance`. To ignore it, set `Config.Dispatch.Sources['vinewood-dispatch'] = false`.

### Callsigns

When vinewood-dispatch is running, callsigns are shared with it: setting one in the MDT's callsign box or with `/callsign` in game updates both, and it's remembered per character.
