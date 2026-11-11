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
5. Optional: Discord webhooks in `server/sv_config.lua` (see **Discord webhooks** below).

## Commands

| Command | Who | What |
|---|---|---|
| `/moj` | Judges, clerks, CPS, defence, probation, prison, police | The staff system. What you see depends on your role. |
| `/mycase` | Anyone | Your court dates, fines (pay here), orders, unpaid work and appointments. |
| `/unpaidwork` | Anyone with hours to do | Start or stop unpaid work at the nearest work site. |
| `/courtrooms` | Server admins | Build courtrooms: place laptops, microphones, screens and the court custody desk. |

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

## Tablet and laptop

The system opens on a device (`Config.UI.Device`):

- **Tablet** for `/moj`, `/mycase` and the tablet item. It has a rounded bezel, front camera and status bar with the time, and your character holds a tablet prop with an animation while it's open (`TabletAnim`, `TabletProp`).
- **Laptop** for courtroom laptops. It has a screen bezel with webcam, an aluminium keyboard base, and the courtroom's name in the status bar.
- **None** gives a plain window. The courtroom editor always uses this.

### Tablet item (optional)

Add this to `ox_inventory/data/items.lua`:

```lua
['moj_tablet'] = {
    label = 'Justice tablet', weight = 600, stack = false, close = true,
    client = { export = 'vinewood-moj.useTablet' },
},
```

Using it opens the court system for staff (judges, clerks, CPS, defence, probation, prison, police) and the person's own justice account for everyone else. With `RequireTabletItem = true`, `/moj` only works while carrying it. Courtroom laptops always work. The item check runs on the server.

## Courtrooms

Build real courtrooms in game, then run hearings in them.

1. Stand in the middle of the room and type **`/courtrooms`** (admins: any ace in `Config.Courtrooms.AdminAces`, which includes `command` by default). Choose **New courtroom here**, give it a name, pick the court it belongs to, and set its size (metres from the centre).
2. **Place a laptop** on each desk: the judge's bench, clerk, prosecution and defence. Tick which roles can use each one (none ticked means all court staff). Laptops are ox_target points that open the court system. Optionally spawn a laptop prop if your MLO doesn't have one.
3. **Place a microphone** at the bench, witness box, dock and advocates' seats. Anyone standing or sitting within `MicReach` (1.6 m) of a live microphone is heard across the whole room, using pma-voice's `overrideProximityRange`. When they step away, their voice goes back to normal. Microphones can spawn a desk microphone (`prop_table_mic_01`) for the bench, dock, witness box and advocates' tables. Aim the laser at the table top and it sits on the surface. A "Microphone live" badge shows while it's picking you up, and anyone can switch a microphone off for themselves through its ox_target option. Each microphone can have its own range; otherwise it uses the room's size.

Every point (laptop, microphone, custody desk, screen) can be placed three ways:

| Option | What it does |
|---|---|
| **Use one already in the room** | Aim at the laptop, microphone or TV that's part of your MLO. It's outlined in yellow and the hint shows its model. Press **E** to use it. Nothing is spawned. |
| **Spawn a prop** | We spawn the prop (`LaptopProp`, `MicProp`, or a TV from `ScreenModels`). Aim, scroll to turn, **↑/↓** to raise or lower, **E** to place. |
| **Just mark the spot** | Laptops, microphones and desks only. A position with no prop, for furniture that's baked into the building and can't be selected. |

**Backspace** cancels any of them. The editor list shows which option each point uses (Map object, Spawned or Marked spot). To change it, remove the point and place it again.

**TVs picked from your MLO:** to show footage, a TV model needs its render target name. Known models (those in `ScreenModels`) are filled in automatically. For a custom TV, type its render target when you place it. Most GTA TVs use `tvscreen`. If a custom TV stays blank, its screen texture isn't set up as a render target, so spawn a TV prop there instead.

During a hearing:

- When a judge opens a hearing from a courtroom laptop, the defendant and their solicitor are told which room and given a waypoint to it, and the room is written to the case log.
- Court-date notices and reminders point at the court's courtroom rather than `Config.Courts` coordinates, once one exists.
- `CourtRolesNeedLaptop = true` ties the roles in `LaptopOnlyRoles` (judges and clerks by default) to courtroom laptops. `/moj` then refuses them, and requests are rejected unless they opened a laptop and are still in that room. Everyone else (defence solicitors, CPS, police, probation and prison) keeps `/moj` anywhere, and can still use a courtroom laptop when they're in court.

Notes:

- Microphones need **pma-voice**. Without ox_target, laptops and microphones fall back to an E prompt.
- If you use pma-voice native audio, test the range. pma-voice has a known issue where an overridden range can cut out at the speaker's old range instead of fading. If you hit it, add a long-range mode to pma-voice's `Cfg.voiceModes`.

## Courtroom screens and video evidence

Put TVs in a courtroom and play footage on them for everyone in the room.

**Setup:** in `/courtrooms`, open the room and choose **Place a screen**. Pick the TV model (`Config.Courtrooms.ScreenModels`), aim the laser at the wall and press E. The TV prop is spawned for you. When nothing is playing, screens show a court slate with the room's name.

**Playing footage:** at a courtroom laptop, the judge, clerk, CPS or defence (`ScreenRoles`) get a **Screens** button in the header. From there they can:

- show a video exhibit saved on the case or claim, or paste a link
- play it again from the start
- stop, which puts the screens back to the slate.

Every screen in the room shows the same thing. Each showing of a saved exhibit is written to the case or claim log.

**Video exhibits:** cases and civil claims have a **Video exhibits** section. The judge, clerk, CPS or defence add a name and a link (for example "PH/1: bodycam" or "D/1: dashcam"), and then show it from any courtroom laptop.

**Links that work:**

| Link | How it plays |
|---|---|
| Medal clip (`medal.tv/games/.../clips/...`, `medal.tv/clips/...`, share links with a key) | Medal's own embedded player, with sound. |
| YouTube (`youtube.com/watch?v=`, `youtu.be/`, shorts) | YouTube's embedded player. Joins at the right point for late arrivals, and gets quieter with distance. |
| Direct video file (`.mp4`, `.webm`, `.mov`) from a host in `VideoHosts` (Fivemanage and Discord's CDN by default) | Best option: synced for everyone (people who walk in join at the right point), and gets quieter with distance from the screens. |

**Notes:**

- The picture and sound only exist for people inside that courtroom. They start when you walk in and stop when you leave.
- **Medal plays in Medal's own player**, so it can't be synced for latecomers (they start from the beginning) and plays at one volume inside the room. If you need exact sync, download the clip and use a direct file link.
- Screens go back to the slate after `MaxPlayMinutes`.
- Screens using the same render target (`tvscreen` for the flat TVs) all show the same picture. That's how one exhibit appears on every TV in the room.
- In-game browsers sometimes block sound until a page has been interacted with. If a clip plays silently on your server, use direct video files, which fall back to playing muted rather than not at all.

## Court custody desk

Defendants brought in by police, held on remand, or facing serious charges are booked in at a custody desk before their hearing.

**Setup:** in `/courtrooms`, open the courtroom and choose **Place a custody desk** (in the court cells or custody suite). A court only enforces booking in once it has a desk, so nothing changes until you place one.

**Who has to be booked in** (`Config.CustodyDesk`):

| Defendant | What happens |
|---|---|
| In police custody or remanded (`RequireFor`) | Must be **produced from custody**. Police or prison officers bring them to the desk. |
| Serious case on bail: Crown Court, or any indictable-only charge (`Serious`) | Must **surrender to the custody of the court** at the desk. |
| Anyone else | No change: they just attend. |

**Booking in:** police, prison officers or court clerks (`Roles`) use the desk through ox_target. It opens on the laptop screen with today's list for that court, showing who needs booking in, why, and whether they're at the desk. The defendant must be within `BookInRange` (12 m). Booking in records the time, who did it and notes (escort, risk, property), and tells the judge.

**Until they're booked in:**

- The judge can't mark them present. The hearing panel says why, and for prisoners suggests adjourning instead of issuing a warrant.
- The auto court waits. Police and prison staff get a "not produced" reminder every `NotProducedAlertMinutes`.
- A bailed defendant in a serious case who hasn't surrendered `SurrenderMinutes` after their hearing time is treated as failing to surrender, and a warrant is issued. People in custody never get a warrant for not being produced.

## Civil claims (County Court)

One person takes another to court for money owed, damages, a broken agreement, property or an injunction.

1. **Issue.** A defence solicitor (`Config.Civil.OpenRoles`) opens **Civil claims → Issue a claim**. They pick the claimant (their client) and the defendant, the type, the amount, any order wanted, and the particulars of claim. The court fee (`Fees`, banded on the amount) comes out of the solicitor's account. With `AllowLitigantInPerson = true`, people can also issue their own claims from `/mycase`.
2. **Serve.** The defendant is told straight away and has `ResponseDays` to respond, from `/mycase` or through a solicitor.
3. **Respond.**
   - **Admit:** judgment for the claimant.
   - **Defend:** the claim goes to the court to list a hearing, and clerks are told.
   - **No response:** judgment in default, entered automatically (`AutoDefaultJudgment`) or asked for by the claimant's solicitor.
4. **Hearing.** A clerk or judge lists it at the County Court. The judge opens it, from a courtroom laptop if they're in one, which sends both parties and their solicitors a waypoint to the room. The judge then gives judgment: for the claimant (amount plus costs, and/or an order), or for the defendant (claim dismissed, and the claimant can be made to pay costs). Orders such as injunctions are written to the defendant's MDT record so police can enforce them.
5. **Pay.** The losing side pays through `/mycase`, in full or in parts. Payments go straight to the other party: into their bank if they're in the city, otherwise on their next login. Unpaid after `PayDays`, a **County Court Judgment (CCJ)** is registered and noted on the MDT. Paying in full marks it satisfied.

### People and businesses

Either side of a claim can be **a person or a business**, so you can have person v person, person v business, business v person, or business v business.

- **A business is a job** on your framework (for example `mechanic`, `paddys`). Change which jobs count with `ExcludeBusinesses`, and add non-job company accounts with `ExtraBusinesses`.
- **Its bosses act for it.** Anyone on a boss grade (`isboss` on qb/qbx, `boss` on ESX) sees the business's claims in `/mycase`. They can take a person or another business to court for the business (`BusinessesCanIssue`), and respond, pay or settle on its behalf. Solicitors can still act for a business as well: pick "A business" on the claim form.
- **Its money is the business (society) account.** Court fees for claims a boss brings, judgments the business pays, and judgments paid to the business all go through it. Payments into a business work even when none of its staff are online. `BusinessBank = 'auto'` finds Renewed-Banking (what qbx_management uses), okokBanking, wasabi_banking, qb-banking, qb-management or esx_addonaccount. Add others in `server/business.lua`, which is left unencrypted.
- **Notices go to the business's bosses** who are in the city. CCJs and injunctions against a business are logged on the claim and sent to its bosses; MDT notes are only written for people.

Bosses are taken from a character's main job, so with multi-job setups the boss has to be on that business's job at the time.

The claimant (or their solicitor) can withdraw or record a settlement at any point before judgment. Judges can strike a claim out. Solicitors only see claims where they act for one side, and can be assigned to either side by a clerk or judge.

Add a County Court to `Config.Courts` (`kind = 'county'`; one is included) and set `Config.Civil.Court` to its id. It can share a courtroom with the criminal courts, since you pick the court when you list the hearing.

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

## Discord webhooks

Set them in `server/sv_config.lua`. That file is server-only, so the URLs are never sent to players. Paste a Discord webhook URL against each channel you want (Channel settings → Integrations → Webhooks). Leave a channel empty to switch it off. Several channels can share one URL.

| Channel | What's posted |
|---|---|
| `cases` | Cases opened, hearings listed, opened, adjourned or vacated, pleas, verdicts, bail and remand decisions, charges withdrawn, cases discontinued or acquitted, solicitors assigned |
| `sentences` | Every sentence, with who passed it (a judge or the auto court) |
| `warrants` | Warrants issued (failing to appear, fine default, breach, recall, escape), executed and cancelled |
| `custody` | Defendants booked in at a court custody desk: who, which hearing, why, the desk and the officer |
| `prison` | Received into custody, released (including early releases and why), recalled, escapes |
| `probation` | Orders made and completed, appointments booked, attended or missed, warnings, breaches, curfew and exclusion zone alerts, unpaid work completed |
| `fines` | Court fines issued, paid, in default and written off |
| `civil` | Claims issued, defended, listed, heard and adjourned, judgments, payments, CCJs registered, withdrawn, settled or struck out, solicitors assigned |
| `evidence` | Video exhibits added or removed, and footage shown on (or stopped from) courtroom screens, with the link |
| `courtrooms` | Admins creating, editing or deleting courtrooms, and placing, editing or removing laptops, microphones, desks and screens |
| `all` | Optional: a copy of every message from every channel above |

**Pings:** `Mentions` adds a role or user ping to a channel's messages, for example `warrants = '<@&ROLE_ID>'` to ping police when a warrant is issued.

**Testing:** run **`/mojwebhooks`** (server console, or an admin in game) to send a test message to every channel that has a URL. It also lists which channels aren't set.

Messages are queued per webhook and sent in batches, so busy courts won't hit Discord's rate limits.

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

`config.lua`, `sentencing.lua`, `server/sv_config.lua`, `bridge/server.lua`, `server/licences.lua`, `server/prisons.lua` and `server/business.lua` stay open. Use `Licences.Custom` in `server/licences.lua` to connect a different licence script.

## Notes

- Hearing times shown in the system use the viewer's clock. Court sitting hours (`SittingFrom` / `SittingTo`) use the server's clock.
- Charges with no entry in `sentencing.lua` still go through court, but the guide will say there's no guideline for them. Add your own offences to both the MDT's `Config.Offences` and `sentencing.lua`.
