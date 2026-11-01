# vinewood-moj

**Ministry of Justice for FiveM by Vinewood Studios.** Courts, sentencing, prison, probation, unpaid work, court bail, court fines and warrants. It works on its own, and links straight into **vinewood-mdt** when that's running.

Multiframework: Qbox, QBCore and ESX (auto-detected). Requires **ox_lib**, **oxmysql** and **OneSync**.

---

## Install

1. Drop `vinewood-moj` into your resources folder.
2. Start it after your framework, ox_lib and oxmysql, and after vinewood-mdt if you use it:
   ```
   ensure ox_lib
   ensure oxmysql
   ensure qbx_core
   ensure vinewood-mdt
   ensure vinewood-moj
   ```
3. Tables are created on first start (`sql/install.sql` is there if you'd rather run it yourself).
4. Set your job names in `Config.Roles` (config.lua) and your courthouse coordinates in `Config.Courts`.
5. Optional: Discord webhooks in `server/sv_config.lua`.

## Commands

| Command | Who | What |
|---|---|---|
| `/moj` | Judges, clerks, CPS, defence, probation, prison, police | The staff system. What you see depends on your role. |
| `/mycase` | Anyone | Your court dates, fines (pay here), orders, unpaid work and appointments. |
| `/unpaidwork` | Anyone with hours to do | Start or stop unpaid work at the nearest work site. |

## Roles

| Role | Can |
|---|---|
| Judiciary | Open hearings, take pleas, record verdicts, bail or remand, sentence, deal with breaches, adjourn, cancel warrants, release prisoners. |
| Court clerk | Open cases, list and vacate hearings, assign solicitors, see fines. Senior clerks can cancel warrants. |
| CPS | Open cases, withdraw charges, discontinue, add notes, see the sentencing guide. |
| Defence | Only their own clients' cases and hearings. |
| Probation | Caseload, appointments, curfew and exclusion zones, warnings, breach and recall. |
| Prison | Prison roll. Senior officers can release early. |
| Police | Read only: court lists, cases, warrants, prison roll. |

---

## How a case runs

1. **Charge.** A CPS *charge* decision in vinewood-mdt opens the court case automatically, carrying over the charges, case summary, evidence list, signed MG11 statements, the officer, the solicitor and any police bail. Without the MDT, clerks, judges or the CPS open cases from the system (a summons).
2. **Venue.** Indictable-only charges go to the Crown Court, everything else to the magistrates'.
3. **Listing.** Bailed defendants are listed at least `FirstHearingHours` ahead, people in custody within `RemandHearingMinutes`. Hearings go into the next free slot in court sitting hours. Defendants get a notification, a waypoint, and reminders (`ReminderMinutes`).
4. **Hearing.** A judge opens it and works through the steps: attendance, pleas, trial verdicts, bail, sentence (or breach), then adjourn or conclude.
5. **Sentence.** Custody, a suspended sentence, a community order, a fine or a discharge, with compensation, costs, a driving ban and penalty points. The result goes back to the MDT and to the driver's licence.

### Failing to appear

The judge records it, or the auto court does it (with `AutoCourt.Offline = 'warrant'`). A warrant is issued and mirrored into the MDT, so the person flags as wanted. When police mark it **executed** in the MDT, the case is listed straight back before the court.

### Auto court

If no judge opens a hearing within `GraceMinutes`, the system deals with it. If a judge is online, they're reminded first and the auto court waits `JudgeTakeoverMinutes`.

- **First appearance:** the defendant gets a plea prompt for each charge. No answer within `PleaTimeoutSeconds` means the court enters not guilty pleas for them.
- **Guilty:** sentenced on the spot to the guidelines, with plea credit, previous convictions and totality applied.
- **Not guilty:** a trial is listed. If no judge holds it `TrialWaitHours` after it was due, `AutoCourt.NotGuilty` decides what happens: `'convict'` (tried on the papers, the default), `'acquit'` or `'wait'`.
- **Breach:** `BreachAction` decides: extra hours, or revoke and resentence.
- **Offline defendants:** with `Offline = 'wait'` (the default) the hearing is held until they next log in.

---

## Sentencing

`sentencing.lua` holds the offence ranges, using the same offence names as vinewood-mdt so CPS charges match up. It also holds the aggravating and mitigating factors, plea credit, and the rules the auto court follows (custody threshold, suspension limit, community hours per month, totality). Judges see the same guide, can adjust factors and the plea, and then set the sentence themselves.

The `auto` field on driving offences gives the ban (months) and points the auto court adds. `BanRealDaysPerYear` converts court ban lengths into real days on the licence system.

## Prison

Sentenced and remanded people really are sent to prison. The court always keeps the official record: the sentence, time served, the release point and licence. **Who physically holds the prisoner** is set by `Config.Prison.Script`:

| Script | Value | Notes |
|---|---|---|
| Vinewood HMP | `'vinewood_prison'` | Takes the whole sentence and runs it: time served (its own online, realtime or hybrid mode), release point, remand credit, relogs, escapes, parole. It reports releases back, and the court then starts licence. Works for people who aren't in the city. Escapes become an "unlawfully at large" warrant in the MDT, and executing it calls the prison's `Recapture`. |
| Built-in | `'builtin'` | Teleport to Bolingbroke, perimeter (anyone who leaves is put back and prison staff are told), time left on screen, ox_inventory confiscation and return. |
| rcore_prison | `'rcore_prison'` | Jail, unjail, offline unjail and changing the time. rcore reports releases and breakouts straight away, so a breakout is recorded as an escape. |
| Pickle Prisons | `'pickle_prisons'` | Jail and unjail. Set which prison in `Scripts.pickle_prisons.prison`. |
| Wasabi Police V2 jail | `'wasabi_police_v2'` | Jail, release and jail-time check. Only used when you choose it. |
| Your own | `'custom'` | Fill in `Config.Prison.Custom.Jail`, `Release` and (optionally) `IsJailed`. |

`'auto'` (the default) uses Vinewood HMP, rcore_prison or pickle_prisons if one is running, otherwise the built-in prison. The server console prints which one is in use on start, and the Prison page in `/moj` shows it.

How it works with another script:

- The prisoner is handed over with the minutes left to serve (remand uses `RemandMinutes`). `timeScale` converts the time if your script doesn't use minutes.
- The court counts time served and calls release at its own release point, even if the prison script's timer says longer. Sentenced prisoners then go onto licence as normal.
- If the prison script lets someone out early, `EarlyExit` decides whether that's a release or an escape. rcore_prison tells the two apart itself. For scripts with no "is jailed" check (Pickle), breakouts can't be detected.
- An escape issues an "unlawfully at large" warrant into the MDT. When police execute it, the person goes straight back to prison with the time they still owe.
- Released while offline: rcore is told straight away. Other scripts are told when the person next logs in.
- To add another prison script, add an entry to `server/prisons.lua` (left unencrypted). It needs `jail` and `release`, and optionally `isJailed`, `setTime` and `releaseOffline`.

Common settings: `MinutesPerMonth`, `MinimumMinutes`, `ReleasePoint` (halfway by default) and `RemandCounts` (remand time comes off the sentence).

## Probation

| Order | Runs |
|---|---|
| Community order | Until the unpaid work hours are done (and `RequirementDays` if it has a curfew or exclusion zone) |
| Suspended sentence order | `SuspendOperationalDays` (set per sentence) |
| Licence | `LicenceDays` after release |
| Conditional discharge | `DischargeDays` |

- **Curfew tag:** the probation officer sets the curfew address at their own position or at the offender's. During curfew hours, being more than `CurfewRadius` away is a violation.
- **Exclusion zones:** named zones in `Config.Probation.ExclusionZones`, or set on the spot by the officer. Entering one is a violation.
- **Violations:** each one alerts probation and police (through vinewood-dispatch if it's running, otherwise the MDT call list) and counts as a warning.
- **Appointments:** booked by the officer. A missed appointment is a warning.
- **Warnings:** at `WarningsBeforeBreach`, breach action happens automatically. A licence breach means recall to prison for `RecallMinutes` (with a warrant if the person is offline). A community or suspended order breach is listed as a breach hearing on the original case.

## Unpaid work

Each site in `Config.UnpaidWork.Sites` hands out one task at a time. The server picks the spot, checks the player is there, enforces the task time and a cooldown, then credits `HoursPerTask` hours.

## Court fines

Fines, compensation, costs and the victim surcharge are paid through `/mycase`. Unpaid after `DueDays`, they go into default (plus `DefaultIncrease`%). After `WarrantAfterDays`, a fine-default warrant is issued, and it's cancelled automatically once everything is paid. `OnPaid` lets you pay the money into a society account.

---

## vinewood-mdt link

Nothing to set up beyond `Config.MDT`. With vinewood-mdt 2.12.0 or later:

- CPS charge → court case.
- Court warrants show in the MDT and flag the person as wanted. Executed in the MDT → back to court.
- Court bail conditions and the next court date replace the police bail record.
- Results are added to the person's MDT timeline as notes.
- The person record gets a **Court and sentences** tab, plus banners when they're in prison or on an order.
- Police bail granted in the MDT releases someone held on remand here (through the MDT's `OnBailGranted`).

---

## Exports (server)

```lua
exports['vinewood-moj']:GetPersonSummary(cid)       -- cases, next hearings, sentences, custody, orders, warrants, fines owed
exports['vinewood-moj']:IsInPrison(cid)             -- boolean
exports['vinewood-moj']:GetActiveOrders(cid)
exports['vinewood-moj']:GetActiveWarrants(cid)
exports['vinewood-moj']:CreateCase({ cid = 'ABC123', charges = { 's.1 Theft' }, summary = '...', by = 'My script' })
exports['vinewood-moj']:SendToPrison(cid, months, reason)
exports['vinewood-moj']:ReleasePrisoner(cid, reason)
exports['vinewood-moj']:ReleaseFromCustody(source)  -- ends remand (used by vinewood-mdt)
```

## Server events

```lua
AddEventHandler('vinewood-moj:server:sentenced', function(caseId, cid, components, summary) end)
```

## Editable files (escrow)

`config.lua`, `sentencing.lua`, `server/sv_config.lua`, `bridge/server.lua`, `server/licences.lua` and `server/prisons.lua` stay open. Use `Licences.Custom` in `server/licences.lua` to connect a different licence script.

## Notes

- Hearing times shown in the system use the viewer's clock. Court sitting hours (`SittingFrom` / `SittingTo`) use the server's clock.
- Charges with no entry in `sentencing.lua` still go through court, but the guide will say there's no guideline for them. Add your own offences to both the MDT's `Config.Offences` and `sentencing.lua`.
