# Changelog

## 1.16.0
- Fixed: Heel did nothing. It now stops whatever the dog is doing (sitting, barking, running somewhere), brings it to your left side and walks it with you, and says "Heel."
- Send the dog somewhere: "Send to a spot" (target the dog, or the radial, Dog) lets you aim at the ground or anything else up to 80 m away; E sends it. Or target any car or object for "Dog: go here". The dog runs there and sits waiting until you call it to heel. On the lead, the lead is slipped first.
- Searches find drugs, firearms and ammunition, and criminal cash, in players' pockets, vehicle boots and gloveboxes, and on NPCs. The dog says what it's indicating on (e.g. "indicating (drugs, cash)"). Choose what it finds with Config.Dogs.Detects. Everyday items (torch, baton, Taser, fuel can...) are ignored. It won't search on-duty officers.

## 1.15.4
- Fixed: the police dog spawned invisible. Its body parts and textures (vinewood_policedog 1.0.3) are now named vw_policedog^part, which is how FiveM attaches streamed parts to a ped.

## 1.15.3
- /dogtest: shows the dog model and the game's own shepherd side by side, in your game only, for 20 seconds, with their size and parts in F8. It tells a model problem apart from a spawning problem.

## 1.15.0
- The police dog model is now its own resource, vinewood_policedog (included). Restarting a resource that carries a ped's metadata while players are connected crashes their game the next time that ped spawns. That's what happened when vinewood_police was restarted for a config change and then /dog was used. Now vinewood_police can be restarted freely. Ensure vinewood_policedog before vinewood_police, and only restart it with a full server restart.

## 1.14.5
- Config.Dogs.Model is always used as written. 1.14.0 quietly switched 'a_c_shepherd' to 'vw_policedog' for older configs, which meant choosing the normal shepherd had no effect. (KeepStockShepherd is no longer needed.)

## 1.14.4
- Fixed: crash on /dog. 1.14.2 set the dog's IsStreamedGfx to false, which doesn't match how the model is built; it's back to the game's own value (true).
- The dog's head, coat and harness are only set if the model really has that part and texture (checked first), so a different model can't crash it. Config.Dogs.Look.enabled = false leaves the model exactly as it is.
- Config.Dogs.Debug = true prints each step of /dog to F8 as it happens, so the log shows how far it got even if the game crashes.

## 1.14.3
- Fixed: game crash on /dog. The police dog's skeleton (vw_policedog.yft) still had its old internal name (pack:/a_c_shepherd) from before it became an add-on ped, so GTA crashed building it. The name inside the file is now vw_policedog. Nothing else in the model changed.

## 1.14.2
- Police dog: peds.meta now marks it as a streamed add-on ped (IsStreamedGfx false), which a resource-streamed ped needs for its body to show.
- When deployed, the dog is made visible and solid, and moved next to you if it appeared under the floor or far away (server-created peds can drop through MLO floors before collision loads).
- /dogcheck writes every step of the last deploy (model found, loaded, server spawn, dog reached your game, position, visibility, body parts) to the F8 console.

## 1.14.1
- Fixed: the dog lead didn't show. GTA's physics rope can fail to appear when tied between two moving peds, so the lead is now drawn: a black strap from the handler's hand to the dog's collar, redrawn every frame from both bones. It sags when slack and tightens when the dog pulls, and everyone within 60 m sees it. Config.Dogs.Lead: Colour and Thickness. Style = 'rope' brings back the physics rope.

## 1.14.0
- The police dog is now an add-on ped, vw_policedog, instead of replacing the game's shepherd (which didn't stream reliably: another script streaming a_c_shepherd, or the stock dog already being loaded, won). data/policedog_peds.meta uses the game's own German shepherd settings (movement, capsule, get-ups, navigation, personality), so it behaves exactly like a dog. Pets and ambient shepherds from other scripts are no longer changed.
- Config.Dogs.Model is now 'vw_policedog'. An older config that still says 'a_c_shepherd' is switched over automatically.

## 1.13.1
- Fixed: "Your dog couldn't be deployed". The dog was created by the handler's game, and servers that block or delay player-made entities (sv_entityLockdown, anti-cheat entity protection, slow OneSync sync) removed it before the server could see it. The server now creates the dog and the handler's game takes control of it, keeping control so the dog doesn't stop following when it streams to another player.
- The dog model gets up to 20 s to load the first time (with a "Loading your dog..." message), for big custom dogs.
- Clearer messages: model not on the server, model too slow to load, server couldn't create it (with the reason in the server console), or it didn't arrive.

## 1.13.0
- Custom police dog: stream/policedog/ replaces the game's shepherd (a_c_shepherd) with the Vinewood police dog. Its head and coat textures and harness are set when it's deployed (Config.Dogs.Look; random = true mixes them).
- Custom bark: web/sounds/policedogbark.mp3, heard by everyone within 40 m and quieter with distance. Barks close together overlap rather than cut each other off. Config.Dogs.Bark.Sound = false goes back to the game's bark.
- The supplied peds.meta isn't used: it gave the shepherd human settings (walk, capsule, getups), which would break dog animations. A replaced model keeps the game's own dog settings.

## 1.12.1
- Admin panel (/vpo): Qualifications (testing). Pick yourself or any online player and click a qualification to grant or remove it (green = held), or Give all / Remove all. Admin grants skip rank and sign-off rules (prerequisites are granted in order), are audited as admin, and can be switched off with Config.AllowAdminQualifications = false.

## 1.12.0
- Dog lead: "Lead on / off" (target the dog, or the radial, Dog). A real rope runs from the handler's hand to the dog's collar, seen by everyone nearby. On the lead the dog stays tight at heel and can't wander off.
- "Dog: bark at them" (target anyone within 25 m). On the lead the dog holds its ground at your side, faces them and barks. Off the lead it goes up to them and stops a few metres away to bark, without biting. Heel stops it. NPC suspects who are running or fighting within 10 m often give up (60%), noted on the call. "Detain them" slips the lead first. Settings: Config.Dogs.Lead and Config.Dogs.Bark.

## 1.11.1
- Lighter front-cuff model: ukpolice_cuffs.ydr is now 1.1 MB instead of 6.3 MB, so players download about 5 MB less.

## 1.11.0
- Numbered evidence markers (vw_evidence_01 to 30, sharing the evidencemarkers texture dictionary). /scenekit, Place evidence markers (or the radial, Scene): a preview of the next number follows your aim, Enter puts it down, and the next number is ready straight away. Q/E turn, Backspace stops. Numbers are shared across officers: each marker takes the lowest number not already used within 60 m, so two officers at one scene never double up. Inside a major incident's outer cordon, placing and picking up markers is written to the scene log. Markers come down with the rest of your scene kit and don't count towards its limit.
- stream/vinewood_policeprops.ytyp replaced with the new one (cuffs, cone, signs and all 30 markers).

## 1.10.1
- Custody is only at the custody desk: removed from the radial, and the /custody command is off by default (Config.Custody.Command = 'custody' turns it back on).
- Fixed: Vinewood resources in a folder named a little differently (vinewood_interviews, Vinewood-MDT...) showed as "not running". Names are now matched without case, hyphens or underscores. The admin panel shows which names were looked for when one isn't found.

## 1.10.0
- Police radial menu of its own, on L (rebindable in GTA settings). Dark see-through wedges with icons, blue highlight on hover, back arrow in the centre, submenus. Same sections and actions as before. ox_lib's radial is still available: Config.Radial.Style = 'ox'.
- Font Awesome (solid icons) is bundled with the resource, so icons show even if a player's game can't reach the internet. Licence in web/fa/LICENSE.txt.

## 1.9.1
- Fixed: the Police section of the radial menu could disappear until the script was restarted. It now checks itself every 5 seconds and puts itself back if anything removed it (ox_lib restarting, another script clearing radial items, a missed duty update). A brief "off duty" reading during a relog or restore no longer removes it. Coming out of handcuffs re-adds it, and /policeradial rebuilds it on the spot.

## 1.9.0
- Police tape, drawn with web/textures/policeline.png. /scenekit, Put up tape (or the radial, Scene): aim at a lamp post, cone or fence and press E to tie it there. Aim at the ground and it's tied at waist height. Keep adding points to run it round a scene; Enter finishes. It has a slight sag and a flutter, every player sees it, and the print reads the right way from the front. "Take down tape near me" removes it (your own, or anyone's for sergeants and above). It clears with "Pick everything up", on sign-off and after the scene lifetime. Settings: Config.Scene.Tape (width, sag, flutter, limits). Swap the PNG to change the design.

## 1.8.0
- Quick keys: Up arrow handcuffs, Left arrow escorts / lets go, Down arrow removes handcuffs (on duty, on foot, the person in front). Rebindable; switch off with Config.Restraint.Keybinds.
- Handcuffs item: using it takes the cuffs out, in your hand (prop), then E or the cuff key cuffs the person in front. Backspace puts them away.
- Paper notices: fixed penalties, traffic offence reports, vehicle seizure notices and (without the MDT) stop and search records now come with a police_notice item. Using it shows the notice again.
- Ready-made items: install/ has definitions for ox_inventory, qb-inventory and ESX, with icons. See docs/ITEMS.md.
- Companion: vinewood-mdt 2.19.2. The bail notice and stop and search record items are on by default, and using them shows the notice again.

## 1.7.0
- Full UK offence list for arrests: 100 offences across 28 groups, from s.4(3) being concerned in the supply of a controlled drug, s.5(3) possession with intent to supply and money laundering, to affray, violent disorder, threats to kill, firearms offences, stalking, fraud, failing to stop for police, warrants and recall to prison. The arrest form's filter box finds them quickly.
- One merged list: the job's offences and the MDT's are combined (same groups joined, duplicates dropped), so an offence in either always shows. Used by player arrests, callout suspects and NPC vehicle stops alike.
- Companion: vinewood-mdt 2.19.1 has the same list, with sentencing guidance for every offence.

## 1.6.1
- Custody computer: Book in always shows on people not yet booked in. If you can't book in, it's greyed out and a line at the top says why (e.g. a qualification your config still asks for).
- People brought into the suite handcuffed but never arrested now show as "Not under arrest", with Arrest them, instead of not showing at all.

## 1.6.0
- Custody CCTV. Place cameras in the world (vpo locations, Custody, "Place cameras in the world"): fly the camera into the corner, line it up, E saves the view. One placed in a cell becomes that cell's camera. Watch from the custody computer ("Watch CCTV", or the camera button on a cell): WASD pans and tilts, scroll zooms, arrows change camera, Backspace returns to the computer. The overlay shows the camera, who's in the cell, the time and a recording light.
- Cell buzzers. Detainees press the call button in their cell (E by default, rebindable). The suite hears the buzzer (custody_buzzer.wav) and the computer shows the call (flashing cell, banner, Answer call). Each cell's buzzer can be muted from the computer, and unmutes automatically when the cell is emptied. NPC detainees press theirs now and then. Settings: Config.Custody.Buzzer.
- Fixed: the desk door release from 1.5.0 was refused because its action wasn't on the panel's allowed list.

## 1.5.0
- The custody desk (and the evidence store) now open as a desk computer: a monitor with a title bar and clock, the cells board on the left and detainees on the right.
- Cells board: every cell shows who's in it (NPCs marked), their risk, whether they're out of the cell, and a red border when their welfare check is overdue. Counts for in custody, cells free and welfare overdue.
- Door release from the desk: each cell with a door shows Locked or Open, and one click unlocks or locks it from the computer. It's logged on the detainee's record as usual.

## 1.4.0
- `/vpo` on its own opens an admin panel: locations editor, management, standards, callouts on/off, start a callout near you, uncuff a player, admin check, integrations.
- Custody cells and doors are placed in the world, the vinewood_prison way. "Place cells in the world": walk the suite, E adds a cell where you stand. "Set cell doors in the world": doors near you light up (yellow outline, line to their cell), E sets one, Q picks another cell, scroll another object. Real doors are checked so frames and props can't be chosen. Z undoes, Enter saves and returns to the editor, Backspace leaves without saving.
- Removed the old "Set door (look at it)" button, which could miss doors set into walls.

## 1.3.1
- Custody: sergeants and above can book in, set observation levels and release without the Custody qualification. Signing on as the Custody unit needs Sergeant+ instead of the qualification.

## 1.3.0
- Lockable cell doors, like vinewood_prison. Set each cell's door in game (vpo locations, Custody, "Set door (look at it)"). Officers lock and unlock it at the door. Placing someone in a cell or returning them locks it; taking them out or releasing them unlocks it. Opening an occupied cell lets the detainee walk out, and it's logged. Doors are kept in step for every player and re-attached when their object reloads. Cells without a door work as before.

## 1.2.3
- Fixed: Enter had to be pressed twice to place scene kit. Place and stop are now key mappings (Enter and Backspace by default), rebindable in GTA settings under FiveM.

## 1.2.2
- Scene kit: place with **Enter** instead of left click (which also threw a punch). Q/E turn, Backspace stops. Attacking, punching and aiming are blocked while placing.

## 1.2.1
- Fixed: "d.statuses is not iterable" in the F8 console. A duty status update arriving while another panel was open (management, locations, a complaint...) redrew the duty screen with that panel's data. The duty screen is now only redrawn when it's the one showing.
- Lists from the server that arrive empty or with gaps are turned back into proper lists before the page uses them, so an empty list can no longer break a panel. All panels were checked with empty lists.

## 1.2.0
- Management: Qualifications on each officer. See what they hold and when it expires, sign off new ones (with days and notes), and revoke with a reason. The normal rules apply: rank per qualification, prerequisites, no signing off your own. Admins can grant anything, as with /qualgrant.
- Fixed: rear cuffing and escort tilted the prisoner sideways. They're now attached to the officer's root bone with fixed rotation instead of the pelvis. Older configs that still say bone 11816 are corrected automatically.
- Letting go of an escort: press G (rebindable in GTA settings), shown on screen while escorting. "Stop escorting" now also shows when targeting anyone or any vehicle while you're escorting, as the escorted person is hard to aim at. /escort and the radial still work.

## 1.1.3
- Fixed: admins refused admin tools on server builds where IsPlayerAceAllowed returns 1 instead of true. `vpo acecheck` now also prints what the native returned.

## 1.1.2
- Admin tools accept several aces (`Config.AdminAce` is now a list: `vinewood_police.admin` and `command` by default) and framework admins (ESX admin/superadmin, QBCore admin/god).
- `vpo acecheck <server id>` in the server console shows why someone does or doesn't count as an admin.

## 1.1.1
- If your config/ranks.lua or config/qualifications.lua is from an older version, the missing permissions and qualifications are filled in from the defaults (the console lists them), instead of actions being refused.
- Clearer refusals: an action missing from the config names the permission, and admin tools name the ace they need. The console logs both.

## 1.1.0
- Management (`/management`, also in the radial): hire, promote and demote, suspend from duty, dismiss (online or offline) and set collar numbers. Rank limits: nobody acts on their own rank or above, or promotes anyone to it. Everything is audited.
- Suspended officers can't sign on.

## 1.0.3
- Police radial menu (ox_lib): status, restrain, search and arrest, roads, scene, calls and backup, station, dog. Shown only while signed on, and disabled while handcuffed.
- "Backup at my position": request backup or urgent assistance from the radial, not tied to a call.

## 1.0.2
- `vpo callouts on|off|off clear` (admins): switch automatic NPC callouts on and off in game. The choice survives restarts; `clear` also cancels calls nobody has reached yet.

## 1.0.1
- Uniforms can be made in game: `vpo locations`, Uniforms. Save what you're wearing as the male or female version, set the rank and units, try it on.
- Changing rooms: a station point (set in the editor) where officers change into uniform. Lockers still offer uniforms too.

## 1.0.0
First release.
- **Duty:** sign-on, statuses, roster, shift reports, pocket notebook; ranks, qualifications and collar numbers.
- **Kit:** equipment lockers, armouries with ammunition accounting, uniforms.
- **Restraint:** handcuffs (Vinewood front cuffs and pose), escort, vehicles.
- **Arrest and search:** arrest with caution and necessity, person search, stop and search.
- **Roads:** vehicle stops, roadside checks, tickets, breath and drug tests, seizure and impound, Stinger; NPC drivers with persistent records and behaviour.
- **Custody:** custody suites, property, cells, welfare, NPC detainees and interviews; evidence store.
- **Calls and scenes:** dynamic NPC callouts (9 scenarios), backup and urgent assistance, major incidents with cordons and a scene log, CID case files.
- **Specialists and standards:** dog section; use of force forms, complaints, professional standards panel and audit viewer.
- **Locations:** in-game editor for every place the job uses.
- **Integrations:** vinewood-mdt 2.19, vinewood-dispatch 1.6, vinewood_licensing, vinewood-vehicleservices, vinewood-interviews 1.8.1, vinewood_prison and vinewood-moj.
