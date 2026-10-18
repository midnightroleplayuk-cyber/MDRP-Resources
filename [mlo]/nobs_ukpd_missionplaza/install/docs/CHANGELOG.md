# Changelog - Mission Plaza UK Police Station (NO BS SCRIPTS)

## 1.2.0 (2026-10-08)

New folder layout - please read before you update. The resource now has six items: `fxmanifest.lua`, `config.lua`,
`README.md`, `stream/`, `scripts/` and `install/`.

- Every setting is in ONE file, `config.lua`, in four sections: vehicle gates, automatic doors, armoury display and
  ambient radio. The gate and door positions, the frozen-prop list and the armoury layouts are generated data in
  `scripts/data/` (replaced by every update - do not edit). If `config.lua` has a mistake, the station now keeps
  running on its default settings and prints a yellow warning in the console.
- New named settings in `config.lua`: the opening distance and speed of each vehicle gate
  (`MPGateConfig.timing`) and the opening distances of the entrance sliders and the garage rollers
  (`MPManagedDoors.entrance` / `.garage`).
- Updating from 1.1.x: your old settings files are no longer read. Back up all four 1.1.x settings files (not only
  `config.lua`), delete the old folder completely (including `.fxap`), copy the new one and set your settings again
  in `config.lua`. Step by step, with the four file names: `install/docs/INSTALL.md`, "Updating".
- Room doors have see-through glass again: clear Georgian wired fire glass (clear glass with a steel wire mesh) in
  the first-floor office doors (command suite, inspectors, meeting room, RPU, CID, training and the response team
  rooms), the public interview room, the front office, press room and sergeants' office, the custody rooms (ID
  suite, medical room, both interview rooms and the property store), the custody airlock and the walk-in door from
  the staff lobby, the SCO-19 wing, the canteen and the other stairwell doors. Behind these doors GTA always draws
  the room, even with the door shut, so no empty world shows through the clear glass (the empty world was why 1.1.7
  and 1.1.8 used obscured glass on the room doors).
- The main cut-off doors keep the solid obscured glass, so GTA still skips drawing the area behind them while they
  are shut: the double doors from reception to the staff corridor, the custody entrance from the staff corridor, the
  double doors between the garage and custody, and the ground-floor stair 1 door. The observation viewers in the cell
  doors stay as they are.
- The door closer and the visible hinge knuckles of the ID suite, medical room, both interview rooms and the property
  store doors now sit on the room side (they were on the corridor / staff-lobby side). Door names, positions and pivot
  points are unchanged, so your doorlock entries keep working - nothing to re-import.
- The edited GTA files in `stream/vanilla/` did not change since 1.1.8: your Vertex Hub merged files still apply.

### Moved in this version

- `docs/` is now `install/docs/`, `doorlocks/` is now `install/doorlocks/` and `branding_kit/` is now
  `install/branding_kit/`.
- `managed_doors_config.lua`, `armoury_display_config.lua` and `site_config.lua` are gone: their settings are in
  `config.lua`, their generated data in `scripts/data/`.
- `gtxd.meta` and `roof_gtxd.meta` are in `scripts/data/`; the scripts are in `scripts/client/` and `scripts/server/`.
- `docs/VERSION.txt` is gone: the version is in `fxmanifest.lua`, `README.md` and this changelog.

The entries below describe earlier versions (1.1.x and 1.0.0) and use the old file paths.

## 1.1.8 (2026-10-08, build D51)

- Door glass is now fully solid: the obscured wired glass on the oak, fire and blue doors no longer lets a faint
  image of the outside world through (same look as before). The observation viewers in the cell doors stay
  see-through.
- Gym: the wall TV no longer has a desk stand under it and sits flat on the wall. The canteen TV (it showed a black
  screen) is now the same wall TV with the sports channel, centred between the windows.
- The duty-belt props are gone, and so is the torn hi-vis vest on the response team's kit-up bench.
- First floor: the black frame where the gallery meets the corridor is gone, and the gallery ceiling now runs to its
  edge without a black band. The same black frames at the SCO-19 link corridor entrance and the public interview
  lobby opening are gone too.
- Ceiling lights now run down the centre of the first-floor gallery (evenly spaced, in line with the corridor
  lights), the custody cell hall and the custody airlock; no light touches or sits behind a hanging exit sign.

## 1.1.7 (2026-10-08, build D50)

- Door vision panels now use obscured Georgian wired fire glass instead of clear glass, so you can no longer see
  the empty world through a closed door (GTA only draws the next room once you are in it).
- Parade room: the speaking stand now stands centred under the crest with room behind it, and the wall TV shows a
  briefing screen instead of a black panel.
- Gym: the plain white cross-trainer is gone.
- First-floor link corridor to the SCO-19 wing: the ceiling light bars now run down the centre of the corridor.
- Front counter: the kick plinth now runs the full length and no longer clips into the wall.
- The black strip across the floor at the blue double doors to the garage is gone.

## 1.1.6 (2026-10-07, build D49)

- Cell doors (cells 1 to 8) upgraded, keeping the design you know (blue steel door, observation viewer with the
  arrow sign, hatch, vent and frame): a realistic custodial lock with a D-pull handle and a deadbolt, a hatch held
  shut by tower bolts, a brushed stainless kick plate (was yellow) and brushed stainless on every metal fitting, all
  fixed with modelled security screws. The cell side stays flush, with nothing to grab.
- Custody doors (cell corridor to the staff lobby, property bay, ID suite, medical room and both interview rooms)
  now use the station's secure door set: a code lock with a lever handle, a door closer and the observation shutter
  on the staff side, a lever on the room side, and the vision panel kept.
- Door hardware remodelled on the station's oak, fire, blue security, custody and cell doors: one matching brushed
  stainless finish and real modelled screws (security screws on the custody and cell doors) instead of the old flat
  metal and screw textures, with new door closers, hinges, levers, pull handles, kick and push plates and latch
  plates.
- Oak doors have a lighter oak finish, the door closers on office doors now sit on the room side, and the wired
  door glass is now clear fire-rated glass. The blue security doors are repainted with a clean blue finish and have
  a new code-lock handle.
- Built for performance: every remodelled door, the cell doors included, switches to a simpler model from about
  12 m away, so the new hardware detail is only drawn up close.
- The door models keep their names, positions and hinges, so your existing doorlock entries (ox_doorlock,
  qb-doorlock or any other) keep working - nothing to re-import or re-place.
- Custody cells: the old blocky toilet and sink are replaced by modern white custody fittings - a seatless WC pan
  with a push-button flush on the wall and a flush white hand-wash plate on the same wall - in the seven cells that
  have a toilet and in the detainee shower / WC room (cell 2 stays a dry observation cell). Both sit flush against
  the wall, with no gap behind them.
- A rights-in-custody notice is now on the wall of every cell.
- The wall keypads beside the secure doors are rebuilt, with crisp keys and security screws.
- Brighter interior: the dark band along the top of the walls is gone, ceilings are evenly lit, there are extra
  ceiling lights in the first-floor corridor and the garage, and the cells, custody area, interview rooms, control
  room, garage, lobby and canteen use brighter lighting settings.
- Body-worn video: new multi-bay camera charging docks with brushed stainless brackets and NO-BS branding (no
  third-party logos) in the front office, sergeants' office, ground-floor armoury, SCO-19 armoury and response team
  office; the logos on the radio charging docks are gone.
- Panic alarms: the thick red board round the interview rooms, medical room, ID suite, strip-search room and public
  interview room is now a slim panic strip, with a real panic button just under each PANIC ALARM label, at about
  1.1 m like other wall controls.
- ID suite: a photo backdrop with a height chart (1.0 to 2.1 m) and a wall-mounted ID camera at eye level facing it.
- Exit signs: the fire exit sign that floated above the main entrance now sits on the door frame, and the exit signs
  that stood off the wall now sit flat on it.
- Flicker fixes: the forensics lab ceiling lights, the posters on the press-room notice board, a notice in the
  first-floor corridor and the SCO-19 armoury issue hatch.
- Smaller download: identical textures are now shared instead of stored twice (no visible change).

## 1.1.5 (2026-10-06, build D48)

- Doors locked while they are still swinging shut now close quickly: if GTA only creeps or lets the door coast, the
  resource takes over within about 0.1 s at the door's own speed (was: up to 3 s of waiting first). A door that
  swings through the closed position is caught there. The closer itself is brisker (about 1.2 s from wide open).
- Doors no longer stay open because of the officer who locked them: only someone the closing leaf could actually
  touch holds it (standing beside the door, past the end of the leaf or on the far side of the closed door no longer
  does), and it only slows down for someone right in front of the leaf.
- The perimeter walls and fences can no longer be climbed into the station: the invisible anti-climb barrier above
  the railings now blocks players (it never did), it covers the pier caps and the wall copings, and there is cover
  above the pedestrian gates and the police exit gate. Vehicles, bullets and the camera are not affected.
- Garage roller doors no longer look black from one side at night (each roller now has an outside face lit like
  the building), and walking to the garage side door no longer opens the roller beside it.
- The garage side door, the stair 3 exit and the roof door now have a light on their outer face at night, and the
  space behind the cell-corridor gate is lit better.
- Signs: the ROADS POLICING sign over the Roads Policing Unit door is now a blue station banner like the others (it
  showed as a black box); the ROADS POLICING UNIT lettering in the RPU room no longer shows a black strip; the
  hanging direction signs now point straight ahead; the exit sign over the RPU door shows properly; the large
  LOCKERS - MALE banner in the first-floor corridor is gone (the door plate stays).
- The navy wall band now continues under the windows in the custody cell corridor and the gym, and the white wall
  tiles under the public WC window.
- The traffic cones in the police garage are gone.

## 1.1.4 (2026-10-05, build D47)

- Doors locked while open now close smoothly in either direction - no more instant snap after 2 seconds. GTA closes
  these custom doors by itself in one swing direction only (so one leaf of every double door, and cell doors pushed
  the other way, used to stay open). The resource now lets GTA try first and, if the door stops, swings it shut like
  a door closer (about 1.5 s from wide open) and the lock holds it. A door left slightly ajar is finished off too.
  It stops and waits while someone (also someone lying in the doorway) or a vehicle is in the door's path, and lets
  go the moment the door is unlocked. Works with ox_doorlock, qb-doorlock and other doorlocks that use GTA's door
  system; nothing to configure (`setr nobs_mp_door_debug 1` prints each step to F8 if you need to report a door).
- Fixed a spot at the police yard exit gate where players could fall through the ground (the pavement at the foot
  of the help point / intercom post).

## 1.1.3 (2026-10-05, build D46)

- No more radio music inside the station: GTA played the background radio of the restaurant that stood on this site
  (East Los FM, all day, through the walls). The resource now switches that emitter off while it runs (setting:
  `MPDisabledEmitters` in `site_config.lua`).

## 1.1.2 (2026-10-05, build D45)

- Roof and facade lights rebuilt with GTA's own fittings, mounted on real surfaces: the helipad deck floods now stand
  on the parapet coping, the two helipad post floods sit on their post tops, the roof-door flood hangs on the
  wall, and the 20 facade floodlights are proper wall floodlights instead of grey boxes. Each has its own night light.
- Roof and facade CCTV cameras are now wall-bracket cameras fixed to their wall, post or pole (no more cameras hanging
  from loose plates and arms).

## 1.1.1 (2026-10-05, build D44)

- Vehicle gates and ox_doorlock: the entrance and police yard gates now follow ox_doorlock's lock. Locked = the
  gate closes (never onto a car or a person in its swing) and stays shut; unlocked = it opens automatically for
  nearby players as before. They used to open and stay open with an ox_doorlock entry. Keep
  `controller = 'builtin'` in `config.lua`; the updated `doorlocks/ox_doorlock/nobs_ukpd_gates.sql` is optional
  (entries imported earlier still work). Other doorlocks: a server event / export, see `doorlocks/README.md`.
- A closing gate also waits while a car or a person is in its swing when it is unlocked.
- Station doors locked while open now close every time: the doors are found from the door objects your doorlock
  registered (not by their map position, which missed some doors), a door's real angle is checked, and a door
  that does not swing shut within 2 seconds is set shut (never while someone is in its swing).

## 1.1.0 (2026-10-05, build D43)

- Automatic doors and doorlocks: the front entrance sliders and both garage roller doors now follow ox_doorlock.
  Locked = the door closes, also when it is open at that moment, and stays shut (it never closes onto someone
  standing in the doorway); unlocked = automatic as before. Any ox_doorlock door you make at them works, or import
  the ready entries `doorlocks/ox_doorlock/nobs_ukpd_autodoors.sql`. Other doorlocks: a server event / export,
  see `doorlocks/README.md`. Settings: `MPManagedDoorLocks` in `managed_doors_config.lua`.
- The garage roller doors open for a player within 6 m (was 18 m).
- Station doors and gates that a doorlock locks while they stand open now swing shut (they used to stay open
  until someone pushed them).
- The boundary walls, piers, railings and the yard fence can no longer be climbed over.
- The west boundary wall no longer bends in towards the building where the planted bed ends; it runs straight.
- The forecourt flagpole stands 3.5 m further from the building, so the flag no longer swings into the wall.
- A helipad floodlight that hung beside its post is now mounted on it.
- Direction signs in the corridors, custody and garage now point the right way for someone standing at the sign.

## 1.0.0 (2026-10-04, build D42)

First public release.

- One resource, `nobs_ukpd_missionplaza`: interior MLO, exterior shell and site works, vehicle gates, entrance and garage
  doors, armoury display and map/LOD fixes. One `ensure` line.
- New rooms fitted out: ground-floor armoury (taser and kit), second armoury / evidence store, male locker room
  with showers and WC cubicles, female locker room.
- Door and room signs re-typeset for legibility; the force crest on the navy feature walls now shows
  without a background box.
- Corridor notice boards rebuilt with real-size sheets; a misplaced corridor plant moved into its room.
- Exterior help point moved so it no longer overlaps the station sign.
- Doorlock data for ox_doorlock and qb-doorlock in `nobs_ukpd_missionplaza/doorlocks/` (see INSTALL.md).
- Vehicle gates can be handed to ox_doorlock or qb-doorlock (`controller` switch in `config.lua`, ready gate
  entries in `doorlocks/`).
- Ground-floor armoury is now a general response-kit store (stab and hi-vis vests, kit lockers, CED cabinet,
  radios on charge, first aid) with no firearms on display; evidence-store racking, wall clocks and the Gold
  command table name cards tidied.
- Flags: the forecourt flagpole flies a waving Union flag (GTA cloth flag), and the three indoor flag stands
  carry Union flags hanging still in soft folds.
- The Gold command coat stand, the SCO-19 operations console screens and the armoury gun racks now show in
  game: they used GTA models that only load inside other interiors, and are replaced by station-built copies.
- Your own badge: the crest (in colour and in white), the big lobby logo, the press-room backdrop, the POLICE
  STATION name plate and the entrance plaque are in one open texture dictionary, `stream/branding/nobs_ukpd_branding.ytd`.
  Guide: `docs/BRANDING.md`; PNG templates in `branding_kit/`.
- The white crest now loads on all seven navy feature walls; at Stair 2 / Public Interview and in the
  ground-floor armoury the game could not find its texture before.
- The edited GTA map files are grouped in `stream/vanilla/` and stay open for Vertex Hub merges
  (`docs/VANILLA_FILES.md`).
- Cfx asset escrow: the station models and core scripts are encrypted; settings, docs, doorlock data,
  textures and map data stay open.
- Sit-script chair list in `docs/CHAIRS.md`.

Upgrading from a test build: remove the older folders listed in `docs/INSTALL.md`, step 2, before adding `nobs_ukpd_missionplaza`.
