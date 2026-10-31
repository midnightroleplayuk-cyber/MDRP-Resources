# Test checklist (1.0.0)

Run these on a test server with two players: A (police, grade 2 = sergeant) and B (police, grade 1 = constable). C is a civilian.

## Start-up
- [ ] Console shows `Applied database migration 001_core` on first start only. After a restart the line doesn't appear and `vpo_schema_migrations` has one row.
- [ ] `vpo status` shows the right framework and inventory, and lists each integration as running or not running.
- [ ] Qbox renamed to `qb-core`: still detected as `qbox`.
- [ ] Break the config on purpose (e.g. a permission with `rank = 'nope'`): an error names the problem and the resource doesn't go ready. Then fix it.

## Qualifications and collars
- [ ] B runs `/qualgrant <A> taser`: refused because of rank.
- [ ] A runs `/qualgrant <A> taser`: refused, you can't sign off your own.
- [ ] A runs `/qualgrant <B> advanced_driver`: refused, because it needs response_driver first (and Inspector).
- [ ] A runs `/qualgrant <B> basic_driver`, then `/qualgrant <B> taser 365`: both work and B is notified.
- [ ] B runs `/quals`: shows both, with the Taser valid until a date a year away.
- [ ] Set `Config.QualificationDayLength = 1` and grant `taser 30`: after 30 seconds `/quals` shows it EXPIRED.
- [ ] A runs `/qualrevoke <B> taser` with no reason: refused. With a reason: revoked, and B is told why.
- [ ] `independent_patrol`: A can't sign it off without holding `tutor`.
- [ ] A runs `/collar <B> 4521`, then `/collar <A> 4521`: the second is refused because the number is in use.
- [ ] C runs any of these commands: refused (not police).
- [ ] `vpo_audit` has a row for every grant, revoke and collar, with actor, target and previous/new values.

## State (set `Config.Debug = true`)
- [ ] `vpo state <B> cuffed true`: B's `/vpostate` shows `cuffed true`.
- [ ] B relogs: still `cuffed true`, and `vinewood_police:server:stateRestored` fires.
- [ ] `restart vinewood_police`: B is still `cuffed true` afterwards.
- [ ] B runs `LocalPlayer.state:set('vpo_cuffed', false, true)` from a client executor: it's reverted, and the console warns `Reverted client change`.
- [ ] `vpo state <B> cuffed nil`: cleared, and stays cleared after a relog.
- [ ] `vpo state <B> escort 5` then relog: escort is NOT restored (it isn't a persisted key).

## Integrations
- [ ] With vinewood-mdt 2.18.0: `vpo status` shows `mdt vinewood-mdt 2.18.0`.
- [ ] `stop vinewood-mdt`: the console warns it stopped. `start vinewood-mdt`: it's picked up again within a second.
- [ ] With vinewood-mdt 2.17: shown as `(limited)`, with a one-time warning.
- [ ] ESX + MDT 2.18: before drop 2, the MDT still opens for police (duty unknown counts as on duty).

## Exports
From any server script: `print(json.encode(exports.vinewood_police:GetOfficer(1)))`. This should show the officer's rank, collar number and callsign, and `nil` for a civilian.

## Drop 2: duty
- [ ] Away from a station, `/police` shows "Go to a sign-on point" and the Sign on button is disabled.
- [ ] At Mission Row sign-on: sign on as Response with callsign `1a-12`. It's saved as `1A-12`, shows in the header and dispatch, and `vpo_duty_sessions` has an open row.
- [ ] A second officer tries `1A-12`: refused (in use). This comes from vinewood-dispatch when it's running, otherwise from vinewood_police.
- [ ] Armed response is greyed out "(needs ...)" without firearms and advanced driver.
- [ ] An officer with no collar number picks one at sign-on. Picking one that's already in use is refused.
- [ ] QB/Qbox: trigger qb-core's duty toggle while signed off. You're put back off duty, with "Sign on at a station".
- [ ] The MDT won't open until you've signed on (`Config.RequireOnDuty` in the MDT), on QB/Qbox and on ESX with MDT 2.18.
- [ ] Change status: the header updates, and the other officer sees it on the On duty tab.
- [ ] `restart vinewood_police` while on duty: still on duty afterwards with the same callsign, and the console shows "Resumed shift".
- [ ] Disconnect while on duty: the session closes with `end_reason = disconnected`.
- [ ] Change job away from police while on duty: the shift ends with "job_changed".
- [ ] Sign off with a report: the row has `report`, `stats` and `end_reason = signed_off`.

## Drop 2: notebook
- [ ] Add an entry with a reference. It's listed with the date and time in UK format.
- [ ] Correct it: the new entry shows "corrects #n". The original is unchanged.
- [ ] Ctrl+Enter adds an entry.
- [ ] With 30+ entries, "Show older entries" pages back.

## Drop 2: equipment
- [ ] Locker away from a station: "Go to an equipment locker".
- [ ] Draw handcuffs: issued. Draw again: the button shows "Drawn" (at max).
- [ ] Taser without the qualification: "Needs Taser (CED)". With it, issued with a serial shown, and in ox_inventory the weapon's metadata has the same serial.
- [ ] Glock while signed on as Response: "Not issued to your unit".
- [ ] Return the Taser: removed from the inventory and the row gets `returned_at`.
- [ ] Draw cuffs and Taser, drop the Taser on the floor, sign off: the cuffs are taken back, and the Taser is recorded as missing (notification plus an `equipment.missing` audit row).
- [ ] Put on a uniform, then "Own clothes": your own clothes come back. Uniform on, then sign off: your own clothes come back.
- [ ] Try to draw kit via a client executor while away from a locker: refused server-side.

## Drop 3: restraint
Players: A (officer, on duty, has handcuffs), B (officer), C (civilian).
- [ ] A rear-cuffs C: the paired animation plays, C ends in the arrest pose with cuffs on the left wrist, and B sees the same.
- [ ] A front-cuffs C: C faces A, then holds the Vinewood front pose with the `ukpolice_cuffs` prop on the right hand. B sees the prop too.
- [ ] Without handcuffs in the inventory: "You need handcuffs".
- [ ] Off duty: none of the options show. Forcing the callback from a client executor is refused.
- [ ] From 5 m away via executor: "Get closer".
- [ ] A and B both cuff C at the same moment: one works, the other gets "Someone is already dealing with them".
- [ ] C runs away during the animation: "That didn't work", and C isn't cuffed.
- [ ] While cuffed, C can't sprint, jump, punch, draw a weapon, or open the inventory or phone.
- [ ] Double-lock, then Check handcuffs: it says double-locked, by A, and the time.
- [ ] A escorts C: C follows attached. B tries to escort C: refused.
- [ ] A gets in a car while escorting: the escort ends. A walks more than 10 m away (e.g. noclip): the escort ends.
- [ ] Put in vehicle: C is placed in the rear left seat. A second prisoner goes to the rear right. A third goes to the front passenger seat or gets "No free seat".
- [ ] C can't get out of the car or drive it.
- [ ] Take out of vehicle: C comes out and is escorted by A.
- [ ] C relogs while cuffed: still cuffed, pose and prop back. `restart vinewood_police`: still cuffed.
- [ ] A disconnects while escorting C: C is let go and stays cuffed.
- [ ] Remove handcuffs: the uncuff animation plays, C is free, the pose and prop are gone, and inventory and phone work again.
- [ ] `vpo uncuff <C>` from the console releases C. Audit rows exist for cuff, uncuff and release.
- [ ] Rate limit: spam the cuff option. After 6 in 5 seconds, it's refused.

## Drop 4: arrest
- [ ] Arrest option is hidden until the person is handcuffed. Forcing it via executor: "Handcuff them before arresting them".
- [ ] Submit with no offence, short grounds, no necessity, or the caution not confirmed: each gives its own error and nothing is saved.
- [ ] "Show the caution to them": the suspect sees the caution card top-left.
- [ ] With MDT 2.18:
  - Arrest linked to "Start a new incident": a new incident is linked with the person as Suspect.
  - A custody record is created with your name, the offences, and the grounds plus necessity in the narrative. The returned reference matches the MDT.
  - The MDT audit log shows it as your action, with the purpose "Arrest / custody".
- [ ] Without the MDT: the reference looks like `LSP/2610/00001` and there's a row in `vpo_arrests`.
- [ ] The suspect sees "You're under arrest" with the offences and the caution.
- [ ] Relog or restart: still under arrest (`/vpostate` shows custody).
- [ ] Release from arrest with a reason: custody is cleared, the cuffs stay on, and the row has `released_at`.

## Drop 4: search
- [ ] Search someone who isn't cuffed: they get the consent prompt. "Refuse", or 20 s with no answer: the officer is told they refused.
- [ ] Allow: the search panel opens marked "With their consent". Re-opening within 5 minutes doesn't ask again.
- [ ] Cuffed or arrested person: no prompt.
- [ ] Open their pockets: the panel closes and their inventory opens beside yours (ox_inventory).
- [ ] With the MDT: tick two items, choose Drugs and an incident, then seize. They leave the person's inventory, the exhibit reference shows (e.g. `JS/3`), the MDT evidence bag holds them, and the list refreshes.
- [ ] Seize with no incident chosen: "Choose an incident".

## Drop 4: stop and search
- [ ] From the search panel: "Record stop and search".
- [ ] s.1 PACE with grounds under 20 characters: refused. s.60 with no authorisation: refused. GOWISELY not ticked: refused.
- [ ] With the MDT: saved as `SS/LSP/...`, and the person gets the MDT's stop and search notice.
- [ ] Without the MDT: a local record, and the person sees their copy.
- [ ] `/stopsearch` with nobody near: the description is required.

## Phase 2, drop 1: vehicle stops
Officer A in a police car; player D driving a registered car.
- [ ] `/stopvehicle` on foot: "You need to be driving". In a civilian car: "You need to be in a police vehicle". Lights off: "Put your blue lights on first".
- [ ] Behind D with lights on: the stop starts, D sees the notice and the "pull over" reminder, and D's car flashes on A's map.
- [ ] `/stopvehicle` on the same car again: "already stopped (VS/...)".
- [ ] Roadside checks at D's car show the keeper, licence, points and MID/MOT/VED, matching what the MDT shows for that plate.
- [ ] A car with no insurance policy: insurance red. An expired MOT: amber. SORN: shown as SORN.
- [ ] Officer B opens Roadside checks on the same car and joins stop VS/... (no second record).
- [ ] Check driver with D in the seat: licence status, categories, points and "Insured to drive" (No if D isn't on the policy).
- [ ] A disqualified driver (BanDriver in licensing) shows Disqualified with the reason.
- [ ] Ticket before checking the driver: "Check the driver first".
- [ ] FPN SP30: with MDT 2.18.1, the MDT issues `FPN/LSP/...`, D gets the MDT fine notice, and 3 points are endorsed. In licensing, `GetPoints` shows them.
- [ ] TOR with "other offence" text: issued, no amount, no points.
- [ ] Without the MDT: ticket ref `FPN/LSP/2610/00004-1`, D sees the notice, and points are endorsed through licensing.
- [ ] End stop without a reason or outcome: refused. With them: recorded, `ended_at` set, checks and tickets saved.
- [ ] Leave a stop open, then delete the vehicle: it closes itself within a minute as "Not recorded".

## Phase 2, drop 2: NPC stops
Tip: to test one behaviour, temporarily set it to 100 in `Config.NPC.Behaviour.weights` and the others to 0.
- [ ] compliant: the NPC indicates, pulls in ahead and stops with hazards on. Roadside checks show the generated keeper and MID/MOT/VED, with no player candidates.
- [ ] Ask for details, then PNC: licence, points, insured to drive, wanted. Restart the server, stop the same car again: the same keeper and driver.
- [ ] Step out: they get out and face you. Ticket SP30: issued to their name.
- [ ] End the stop: they get back in, turn the hazards off and drive off. The ped is released (not a mission entity).
- [ ] False details (`FalseDetails.base = 100`): PNC gives "No trace". Fingerprint: "Identified" with a mismatch flag if they have a record, otherwise "No match".
- [ ] uncooperative: refuses details and refuses to get out. After "Warn them", gives details and gets out.
- [ ] nervous with `NervousBolt = 100`: runs when asked to step out. Stay within 2 m for 1.5 s: they give up, the panel says Detained, and Arrest becomes available.
- [ ] Taser a runner: they give up after the ragdoll.
- [ ] aggressive in the countryside: squares up unarmed and surrenders when hurt. Inside Legion Square: argues and refuses, but never fights.
- [ ] flee_vehicle: drives off as soon as the stop starts. Lose them (400 m+ for 40 s): "Failed to stop", the stop closes, and the plate appears on MDT ANPR for 24 h.
- [ ] Pursuit give-up (`GiveUpChance = 100`): within 15 s they pull over, then either stay or bail out and run.
- [ ] Arrest an NPC: rear cuffs drawn (seen by a second player too), arrest ref `LSP/2610/...` in `vpo_arrests` with identifier `npc:<id>`. Hand over to transport: they fade out, and the stop closes as Arrest.
- [ ] A second NPC stop while one is open: "Finish your current NPC stop first". Set `MaxActive = 1` with two officers: the second gets "Too many NPC stops".
- [ ] The officer controlling the NPC disconnects: another officer on the stop takes over instructions.

## Phase 2, drop 3: roadside kit
- [ ] Player car, unlocked: "Open the boot" closes the panel and opens the boot beside your inventory. Glovebox from the passenger seat.
- [ ] Locked: "It's locked". The force entry box appears. With no reason: refused. With a reason: unlocked, with an audit row `roads.force_entry`.
- [ ] NPC with `DrugChance = 100`: Search them finds drugs. Search again: the same list. Seize: shows "Exhibit XX/1".
- [ ] NPC `DrinkChance = 100`: breath test fails with a reading over 35. Normal NPC: pass.
- [ ] Uncooperative NPC: test "Refused" until warned.
- [ ] Player driver: breath test shows them the prompt. Each choice gives the matching result. No answer in 30 s: Refused.
- [ ] Seize under s.165A: `VSZ/...` reference, the driver gets the notice, and after 30 s the car is removed (not while someone sits in it). QB/Qbox: `player_vehicles.state = 2` with depotprice 150.
- [ ] A stop whose car has been seized stays open until you end it.
- [ ] `/scenekit`: place 5 cones. A second player sees them. Turn with Q/E. Placing more than 10 m away: refused.
- [ ] "Road closed": NPC traffic stops at the cones. "Slow past the scene": it crawls. "Normal": back to normal.
- [ ] Another officer picks up a cone with the target. Sign off: all your cones disappear.
- [ ] `restart vinewood_police`: props are removed and traffic is back to normal.

## Phase 3, drop 1: custody
Sergeant S (with the custody qualification), officer A, detainee D (arrested in drop 4 style).
- [ ] A at the desk with D: Book in isn't offered to A (no qualification). S books D in with grounds, medium risk, Level 2. D gets the rights notice, and the log has the booking line.
- [ ] Book in without ticking rights: refused. "Not authorised": D is released at the release point, cuffs off.
- [ ] Take property: D's inventory empties into the bag (except `PropertyKeep`). Open property bag shows it.
- [ ] Place in Cell 1: cuffs come off and D is moved into the cell. D walks out (noclip or glitch): put back.
- [ ] D relogs, and `restart vinewood_police`: D is back in Cell 1.
- [ ] Put another detainee in Cell 1: "Cell 1 is occupied".
- [ ] Wait past the Level 2 interval (15 min, or lower it): every on-duty officer in the suite gets "Welfare check overdue", repeated every 5 min. The card turns red.
- [ ] Welfare check: due time resets. Tick off "Roused": everyone in the suite gets the NOT ROUSABLE alert. A can't change the observation level; S can.
- [ ] Take out of cell (Interview): D can walk, and the card shows Out. Return to cell: D is back inside.
- [ ] With interviews 1.8.1: start an interview with D picked from the MDT. The log shows start and end, and D is marked out for interview.
- [ ] MDT 2.19: record "Released on bail" (or NFA, caution) on D's custody record. D gets their property back, is put at the release point, and the custody card is gone.
- [ ] MDT "Remanded in custody" with vinewood_prison: the prison takes D, police custody ends ("Remanded: received by prison"), and the property stays. When D is released later, at the desk: "Property to return" returns it.
- [ ] Release from the panel by hand: property back, release point, `vpo_custody.outcome` set.
- [ ] "Release from arrest" on someone booked in: "Release them from the custody panel".

## Phase 3, drop 2: NPC detainees and evidence
- [ ] Arrest an NPC at a stop and hand them to transport. Officers in the nearest suite get "Prisoner transport has brought..." The custody panel shows them as NPC, awaiting booking in.
- [ ] Book in at the desk, place in Cell 2: an NPC ped stands in the cell. A second player sees it. `restart vinewood_police`: it's back. Delete it with an admin tool: back within a minute.
- [ ] Put a player in the NPC's cell: "Cell 2 is occupied".
- [ ] Welfare due and overdue alerts work for the NPC as for players.
- [ ] Interview: only after "Take out of cell" with reason Interview. The result shows on the card and in the log. Pressing it again gives the same answer.
- [ ] An NPC who failed a breath test with a seized exhibit usually admits. One with a record and no evidence usually goes no comment.
- [ ] Outcome "Simple caution" with no admission: refused. "Charged and remanded to court": the ped is removed, the card is gone, and `vpo_npc_custody.status = charged`.
- [ ] NPC search finds, seized at the stop: they appear in `/evidence` linked to the stop, then to the custody ref after arrest.
- [ ] Without vinewood-mdt: search a cuffed player and seize two ticked items (type Drugs). They leave the player's inventory, the player is told the exhibit ref, and the exhibit has a bag. Open bag shows the items.
- [ ] Property store, then Send to forensics: the continuity log grows. A PC can't Return or Destroy. A sergeant returns it with the owner beside them: the items go back.
- [ ] `/evidence` away from a desk or locker: refused.

## Phase 4, drop 1: callouts
Tip: `vpo callout shoplifting` (or disturbance, welfare, burglary, collision) makes one near you. To force a behaviour, change the weights in `callouts_scenarios.lua`'s plan for that scenario.
- [ ] One officer signed on: within a few minutes a call arrives on dispatch with title, description and location. Sign off: no new calls.
- [ ] Nothing spawns at the location until you're within 120 m. Then the peds (and cars, for collisions) appear, and a second player sees them.
- [ ] Shoplifting: the shop worker's account matches the dispatch description. A suspect that runs when you get within 14 m: catch them (2 m for 1.5 s, or taser) and they're detained. Search: the stolen goods. Seize: exhibit refs.
- [ ] Arrest with Theft pre-ticked, then hand over: the person shows as an NPC detainee in the nearest custody suite, with the exhibits listed.
- [ ] Disturbance "Fight in progress": the two are fighting on arrival. An uncooperative aggressor refuses details until warned.
- [ ] Welfare (drunk): sitting down, breath test fails. Let them go: they wander off.
- [ ] Burglary false alarm: the keyholder's PNC address is the house. Real: a suspect in the garden with tools.
- [ ] Collision: two damaged cars, hazards on. An injured driver lies on the ground. A drunk at-fault driver fails the breath test.
- [ ] Close the call with an outcome: it disappears from dispatch. With the MDT, an incident is created (shown in the message). `vpo_callouts` has the outcome, officers and log.
- [ ] Ignore a call for 20 min: it closes as "No police attendance". Drive away from an active scene for 10 min: cleared, and peds and cars are released.
- [ ] `restart vinewood_police` with scenes active: peds and cars are removed and the dispatch alerts close.

## Phase 4, drop 2: callouts
- [ ] No officer signed on as Armed response: `vpo callout shop_robbery` gives knife robberies only. With an ARV officer on duty, about 1 in 3 have a handgun ("Armed robbery: firearm seen").
- [ ] Robbery in progress: the robber aims at the shop worker, who has their hands up. Approach with an ARV officer: usually "drop the weapon and put their hands up". Approach with only unarmed officers: usually runs or attacks. An attack sends out "Officer needs urgent assistance" once.
- [ ] Search the robber: weapon and till cash. Arrest with Robbery and the weapon offence pre-ticked.
- [ ] Street robbery: the victim's description matches. The suspect nearby has the victim's phone or wallet.
- [ ] Stolen vehicle: the car is driving near the location with a UK plate. `/stopvehicle` on it: the roadside panel shows REPORTED STOLEN. The driver usually runs. When the stop ends, the call closes with the matching outcome.
- [ ] Missing person: nothing at the reported location. After 5 min a sighting note names another street. Go there: the person is there. Speak to them, close as "Found safe and well".
- [ ] Call panel: Request backup and Urgent assistance appear only when attached, and go out on dispatch at your position. A second press within 30 s is refused.

## Phase 4, drop 3: major incidents
- [ ] A PC opens `/incident`: no declare form. A sergeant declares a Crime scene (inner 25, outer 80): everyone on duty is told, and the map shows both rings. Rings on the ground near the scene.
- [ ] A second officer books on. The sergeant makes them Scene guard: they're told, and it's in the log. Making a PC Silver commander: refused (Inspector+).
- [ ] The officer on the incident walks into the inner cordon: "entered" logged. A civilian walks in: "NOT ON THE INCIDENT" in red, and everyone on the incident is told. Walking out is logged.
- [ ] Centre on me moves the rings. Set changes the sizes.
- [ ] `restart vinewood_police`: the incident is still on the map with its log. Officers book back on.
- [ ] Stand down: gone from the map, `vpo_incidents.status = closed`.

## Phase 4, drop 3: CID
- [ ] Close a robbery call with an arrest and tick Refer to CID: a case CID/LSP/... opens, linked to the CAD ref, the arrest ref and the MDT incident. The seized knife shows under Exhibits.
- [ ] Give an action to a PC: they're told, and it shows under "Actions for you" in `/cases`. They mark it done: logged.
- [ ] A PC who isn't the OIC can't change status or people. A sergeant can. Hand over the OIC: the new OIC is told.
- [ ] Search by a person's name or a custody ref finds the case.

## Management
Officers: an Inspector (I), a Sergeant (S), a PC (P), a Chief Inspector (C), and a civilian (X) standing next to I.
- [ ] P runs `/management`: no permission. I opens it: everyone in the police job, offline included, highest rank first.
- [ ] I hires X: X becomes Student Officer and can sign on.
- [ ] I can't change ranks (Chief Inspector+ by default). C promotes P to PS: done, and P is told. C trying to make anyone Chief Inspector or above: refused.
- [ ] I suspends P with a reason: P comes off duty and can't sign on ("You're suspended from duty: ..."). Lift: P can sign on.
- [ ] I can't act on C (higher rank) or on themselves.
- [ ] A Superintendent dismisses S while S is offline: S's job is unemployed next login (QBCore/ESX through the database, Qbox through its job exports).
- [ ] Collar: set a number already in use: refused.
- [ ] Audit rows for hire, promote, demote, suspend, unsuspend and dismiss.

## Radial menu
- [ ] Off duty: no Police section in the radial (Z). Sign on: it appears. Sign off: it goes.
- [ ] Status: each status changes your header and the roster.
- [ ] Restrain, with a player next to you: cuff rear, front, remove, double-lock, escort and let go, put in and take out of the nearest car. Nobody near: "Nobody close enough".
- [ ] Search & arrest: search (consent prompt if they're not cuffed), arrest, release, stop and search all open the right panels.
- [ ] Roads: stop vehicle in front (from your car), roadside checks on the nearest car, Stinger.
- [ ] Calls & backup: Request backup and Urgent assistance go to dispatch at your street. A second press within 30 s: refused.
- [ ] Station: custody, evidence, CID, forms and notebook open.
- [ ] Dog appears only when signed on as Dog section.
- [ ] Get cuffed: the whole radial is disabled. Uncuffed: back.

## Callouts on and off in game
- [ ] `vpo callouts`: shows ON (or the config default), with open and active counts.
- [ ] `vpo callouts off`: no new calls arrive while officers are signed on. Calls already open carry on.
- [ ] `vpo callouts off clear`: calls nobody has reached are cancelled and leave dispatch. Running scenes are left alone.
- [ ] `restart vinewood_police`: still off (the console says "set in game"). `vpo callouts on`: calls come again.
- [ ] While off, `vpo callout shoplifting` still makes one.
- [ ] A non-admin running `vpo callouts off`: no permission. Audit rows for on and off.

## Phase 5, drop 1: professional standards
- [ ] Cuff someone: "Use of force form started (Handcuffing)". `/police`, Forms shows it to complete, with Handcuffing pre-ticked and the subject's name filled in. Cuff the same person again within 10 min: no second form.
- [ ] Fire the Taser: a "Taser fired" form, with Taser drawn and fired pre-ticked. Firing a gun you weren't issued doesn't start one.
- [ ] Submit with no tactic, no reason, or a short account: each refused. Complete: moves to Submitted.
- [ ] Sign off with a form outstanding: reminder.
- [ ] A civilian runs `/complaint` naming collar 4521: reference given, and an Inspector on duty is told. A second complaint within 10 min: refused.
- [ ] An Inspector runs `/standards` (works off duty too): the discharge from the armoury test is under Reviews. Record "Justified": it leaves the list and the review is added to the discharge record. Mark a use of force form reviewed: the officer sees "Reviewed by".
- [ ] Complaints: set to Under investigation with a note, then Not upheld: the notes keep a dated history.
- [ ] Officer: search 4521: qualifications, forms, discharges, complaints and shifts.
- [ ] Audit log: search "restraint": cuff entries. An `audit.view` entry is written for the search itself.
- [ ] A PC runs `/standards`: no permission.

## Phase 5, drop 2: dogs and Stinger
- [ ] Signed on as Response: `/dog` refused. As Dog section with the qualification: the dog appears and follows. Heel, sit and van from the dog's target.
- [ ] Get in a car: the dog goes. `/dog` again: back out.
- [ ] Put a drug item in a car's boot (ox_inventory), then Dog: search vehicle: it walks over, sniffs and indicates. An empty car: no indication.
- [ ] NPC stop with `DrugChance = 100`: indicates on the car and the driver. The stop's checks record the dog result.
- [ ] Callout suspect running: Dog: detain them. The dog chases and brings them down, and they give up. A "Police dog deployed" use of force form is started.
- [ ] `BitePlayers = false`: the detain option doesn't show on players. It never works on an on-duty officer.
- [ ] Kill the dog: "out of action". `/dog` within 5 min: refused.
- [ ] `/stinger` without the qualification: refused. With it, on foot: laid across the road. An NPC driving over it gets four flat tyres, and you're told the plate. Your police car drives over: nothing. After 3 min, or `/stinger` again: gone.

## Custom props
- [ ] `/scenekit` shows groups: Cones and lights, Signs, Barriers, Crime scene. A student officer doesn't see the forensic tent.
- [ ] Place the police cone and each sign: the ghost preview shows the Vinewood model, it sits on the ground, and a second player sees it.
- [ ] With traffic on Normal, place a road closed sign: "Road closed: traffic now stops", and NPC traffic stops. On a fresh scene, an accident sign switches it to Slow.
- [ ] Forensic tent: placed and frozen. Pick up works on it.

## Armouries
Officer F: firearms + Taser qualified, signed on as Armed response.
- [ ] The equipment locker no longer offers Taser, Glock, carbine or ammo, and can't take them back ("handed back at the armoury").
- [ ] `vpo locations`, Stations: add an armoury at Mission Row and Save. The Armoury target appears.
- [ ] F signs out Glock (serial shown) and 2x 9mm (34 rounds). A PC signed on as Response sees firearms as not issued to their unit.
- [ ] F loads 12 into the Glock, keeps 22 in hand, and fires 12. The armoury shows "34 issued: 10 on you, 12 loaded", 12 short.
- [ ] Hand everything in: asked for an account. Too short: refused. With an account: Glock and 10 rounds taken back, and a `vpo_discharges` row has 12 rounds with the account. An Inspector on duty is told.
- [ ] Fire nothing, hand in: "all accounted for", no discharge row.
- [ ] Sign off with the Glock and rounds out: taken back automatically. Any short rounds are recorded as unaccounted (`unaccounted = 1`).
- [ ] Drop the Glock, then hand in: "Not handed in: Glock 17 (serial)" and an `equipment.missing` audit row.

## Cell doors
- [ ] `/vpo`, Locations editor, Custody: Place cells in the world. The menu closes. E adds a cell where you stand (marker and label appear), Z removes the last, Enter saves and reopens the editor on Custody.
- [ ] Set cell doors in the world: walking up to a cell door outlines it yellow with a line to the nearest cell without a door. E sets it. A door frame or prop says "not a working door". Q switches cell, scroll switches object. Enter saves.
- [ ] The door is locked for everyone (it won't open). Target it: "Cell 1: lock / unlock" unlocks it, and it opens. Again: it swings shut and locks.
- [ ] Place a detainee in the cell: the door locks. Take out of cell: it unlocks. Return to cell: it locks.
- [ ] Unlock the door of an occupied cell: the detainee can walk out, and the log says "door opened". Lock it with them inside: they're back in the cell. Lock it with them outside: warning, and the log says OUTSIDE.
- [ ] Release a detainee: their cell door unlocks.
- [ ] Walk away and back, or restart: doors keep their state and never show open while locked.
- [ ] A cell with no door set: held as before (put back if they leave).

## Custody computer
- [ ] At the custody desk the panel opens as a monitor in the middle of the screen, with a title bar and clock, the cells board on the left and detainees on the right. Closing it and opening /police: back to the normal side panel.
- [ ] The cells board shows occupants (NPCs marked), risk, "Out: ..." and a red border when welfare is overdue. The counts are right.
- [ ] Door release: click "Locked · release" on an occupied cell: the door opens in the world and the detainee shows as out. "Open · lock" with them inside: back in the cell. From outside the desk area: refused.
- [ ] /evidence at the desk also opens as the computer.

## Custody CCTV and buzzers
- [ ] Editor, Custody: Place cameras in the world. The camera flies (WASD, Space/Ctrl, mouse, scroll). Inside a cell the help says "saves as: Cell 1". E saves, F toggles the CCTV look, Z undoes, Enter saves.
- [ ] Custody computer: Watch CCTV. Fades into the camera with an overlay (camera, cell occupant, time, REC). WASD pans within limits, scroll zooms, arrows change camera, Backspace goes back to the computer.
- [ ] The camera button on a cell tile opens that cell's camera first.
- [ ] Detainee in a cell: help text shows the call button. Press it: the suite (near the desk) hears the buzzer, the cell flashes on the computer, and there's a "1 cell call waiting" banner. Answer call clears it. Pressing again within 20 s does nothing.
- [ ] Mute a cell (the bell button): pressing the button there makes no sound and no call. Release that detainee: the cell is unmuted.
- [ ] Out of the cell (interview): the call button does nothing.

## Uniforms and changing rooms
- [ ] `vpo locations`, Uniforms: dress in a uniform, then "New uniform from my clothes". It shows the item and prop counts. Name it, set PC and above, tick Roads policing, and Save.
- [ ] Try on, then Own clothes: the uniform goes on and your clothes come back.
- [ ] A uniform with no male or female version: Save refused.
- [ ] Stations: Add changing room here, Save. The Changing room target appears. A PC signed on as Roads sees the new uniform; signed on as Response, they don't. A student never sees it.
- [ ] Change at the changing room, then sign off: your own clothes come back (RestoreOnSignOff).
- [ ] Restart: the uniforms are still there. Reset to config: back to the config uniforms.

## Location editor
- [ ] A non-admin runs `vpo locations`: no permission. A forced `loc:save` via executor: refused.
- [ ] Stations: add a station with the sign-on point here, add a locker, Save. The target appears at once for you and a second player, and the sign-on works there. The old station's point is gone if you removed it.
- [ ] Custody: add a suite (desk here), move the release point, add two cells, Save. `/custody` works there. A detainee placed in the new cell is held there. A detainee already in a moved cell is put at the new spot.
- [ ] Two stations with the same name: "used twice". A suite with no release point: refused.
- [ ] Callout places: add a shop here, then `vpo callout shoplifting` near it: the call uses it.
- [ ] No-hostile zone: add one around you (150 m), then an aggressive NPC here argues but never fights.
- [ ] `restart vinewood_police`: everything you saved is still there. Reset to config: back to the file's places.
- [ ] Walk around: you can move with the panel visible, and F7 gives the mouse back. The markers follow what's on screen and go when you close the panel.

## Known limitations
- Integrations other than the MDT and dispatch are detected only. The radio is a normal inventory item until the radio integration is wired.
- Without vinewood-mdt there's no evidence storage yet. Searches still work (open their pockets), but seizing into evidence bags comes with phase 3.
- Kit held by an officer who disconnects on duty can't be taken back (they're offline). It stays listed under "Issued to you" until they return it.
- Uniforms are set straight on the ped. A clothing script that reapplies the saved skin (e.g. on respawn) will undo them.
- Roadside driver checks show the character's real details. Treat it as the PNC check after they've given their name.
- Without vinewood-mdt, roadside fixed penalties are recorded and points applied, but nothing collects the money.
- NPC plates keep GTA's format. NPC records aren't in the MDT, so look them up through the roadside panel.
- Cells hold people by putting them back if they leave; cell doors aren't locked or animated.
- Property bags need ox_inventory.
- Exhibits seized from NPCs are records with a description, not inventory items.
- NPC detainees stand frozen in their cell (no idle animation).
- Opening boots and gloveboxes from the panel needs ox_inventory. With qb-inventory, use its own vehicle search.
- Recovery removes the vehicle rather than sending a tow truck.
- Traffic speed zones affect NPC traffic only.
- NPCs are moved by the controlling officer's game, so very laggy connections can make pull-overs untidy.
- Callout peds are moved by the controlling officer's game; very laggy connections can make them stutter.
- Callout people and cars aren't restored after a restart (the calls close).
- Cordons are logical (map, rings, log). Tape and barriers are placed with the scene kit.
- The dog's searches of players' vehicles read the boot and glovebox through ox_inventory. Vehicles nobody has opened since a restart may not be loaded, and show no indication.
- Escorted players are attached to the officer, so they slide rather than walk.
- The hub uses Google Fonts (Barlow). Offline, it falls back to system fonts.
- The audit log is append-only in code but not enforced in the database: anyone with database access can still edit it.
