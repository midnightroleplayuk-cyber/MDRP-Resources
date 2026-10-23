# Changelog

## 1.0.0-rc.11

- **Crash on loading in fixed** (`GTA5_b3258.exe+13BF39D`, "november-table-ink"), introduced in rc.10: three of the
  district distance models added in rc.10 (`ss1_lod_slod3.ydr`, `ss1_lod_slod3_children.ydd`,
  `ss1_lod_emissive_slod3_children.ydd`) pointed some of their textures at copies GTA never set up, and the game crashed
  when it drew them (mostly on loading in, while it shows the distant city). They now point at their own textures like
  the game's files. Nothing else changes; rc.10's fixes stay.

Updating from an earlier 1.0.0 candidate: replace the whole `rhs_hospital` folder (keep your edited `.ytd` files; copy
your own settings into the new `config.lua`), upload the new `.fxap` with it, restart the server and clear the client
cache. `config.lua` is unchanged from rc.10.

## 1.0.0-rc.10

- **Old Los Santos Customs showing on the hospital:** from a distance (or for a moment while the area streams in) a
  blurry white block with a green glass band could stand on the hospital roof and over the garage, and the rear car park
  could turn blurry. Two of the low-detail map files the hospital ships had broken internal names, so GTA could not use
  them and kept drawing its own distant model of the block, which still has the old Customs on it. Both files are fixed
  (they now match the game's own files name for name), and the most distant city models no longer contain the old
  Customs either: three more GTA files in `stream/vanilla/` (`ss1_lod_slod3_children.ydd`,
  `ss1_lod_emissive_slod3_children.ydd`, `ss1_lod_slod3.ydr`), listed in `compatibility/README.md`.

Updating from an earlier 1.0.0 candidate: replace the whole `rhs_hospital` folder (keep your edited `.ytd` files; copy
your own settings into the new `config.lua`), upload the new `.fxap` with it, restart the server and clear the client
cache. `config.lua` is unchanged from rc.9.

## 1.0.0-rc.9

- **Main reception counter:** the low staff desk at the end of the counter now lines up with the counter (same front
  line, top overhang and kick plinth, no gap or hairline at the joint), and its top is L-shaped again so the staff chair
  sits behind the desk instead of under the worktop.
- **Same light by day and by night:** no outdoor sky light inside the building any more (it gave the corridors and rooms
  a blue cast by day); the interior is lit by its own lights at every hour, as at night. The garage is unchanged.

Updating from an earlier 1.0.0 candidate: replace the whole `rhs_hospital` folder (keep your edited `.ytd` files; copy
your own settings into the new `config.lua`), upload the new `.fxap` with it, restart the server and clear the client
cache. `config.lua` is unchanged from rc.8.

## 1.0.0-rc.8

- **Toilets:** the doors into the toilets are white again (now fitted to their frames) and the cubicle doors are white
  laminate to match the cubicles.
- **Toilet mirrors:** satin stainless-steel mirrors with a soft reflection, instead of the sharp, blocky full mirror.
- **Main reception counter:** the low staff end of the counter is rebuilt with closed front and end panels; the broken
  legs under it are gone.

Updating from an earlier 1.0.0 candidate: replace the whole `rhs_hospital` folder (keep your edited `.ytd` files; copy
your own settings into the new `config.lua`), upload the new `.fxap` with it, restart the server and clear the client
cache. In `config.lua` the five toilet doors in `RHSDoors` use the white WC door model (ids and positions unchanged).

## 1.0.0-rc.7

- **Oak British fire doors, made to fit.** Every hinged door is now the NO BS oak fire door from SAH Highways and the
  fire station (vision panel, lever handles, kick plates, closer, "Fire door keep shut" sign), each one sized to its own
  frame: no gap over the doors and no gap down the sides. X-ray, MRI and the theatres have solid doors for privacy (so do
  the WCs, offices, on-call room, staff lockers and mortuary). The garage's door to the outside is a green steel fire exit
  door with the push bar on the inside.
- **Sliding entrances no longer run into the walls.** The rear, A&E and ambulance entrances have telescopic doors (two
  leaves each side) that stack against the side glass and stop short of the piers and the side wall, and the operator box
  ends at the piers. The main entrance is unchanged.
- **Gap in the A&E brickwork closed:** the light line up the corner above the red A&E sign band.
- **Line on the corridor floor removed:** a kerb of the old building stood just above the floor inside the ambulance
  entrance.
- **Daytime lighting:** much less flat daylight in the corridors and rooms, so the building looks by day the way it
  looks at night (the night look is unchanged).

Updating from an earlier 1.0.0 candidate: replace the whole `rhs_hospital` folder (keep your edited `.ytd` files; copy
your own settings into the new `config.lua`), upload the new `.fxap` with it, restart the server and clear the client
cache. In `config.lua` the door ids and positions in `RHSDoors` are unchanged but the models are new (the oak doors), and
`RHSAutoDoors` has 14 leaves (four at the rear, A&E and ambulance entrances). If you added these doors to a doorlock
resource, re-add them with the new models.

## 1.0.0-rc.6

- **The stairs beside the A&E are finished.** Brick now runs up both walls of the covered stair to a pale lined soffit,
  with stone heads over both ends and a stone bead along the wall junctions; the bare concrete panel at the top landing
  is brick, the line in the brickwork of the low wall is gone and the stone coping runs right to the corner of the A&E
  sign band.
- **One corridor finish throughout.** Every corridor, reception and waiting area now has the same plaster walls, the same
  light floor and the same lighting, so there are no colour or brightness steps where one corridor meets the next;
  department colours stay inside their rooms. The back reception's window wall gets a navy blind box.
- **No weather fog indoors.** Fog no longer drifts through the building on foggy days (and the old corridor haze stays
  gone).
- **Sliding entrances closed up.** The automatic doors have aluminium jambs down both sides (no see-through gaps), the
  operator box no longer cuts into the window mullions at the rear, A&E and ambulance entrances, the A&E leaves stop
  short of the wall, and the floor guide no longer runs along the floor beside the doors.
- **Mirrors removed.** The reflective floors in X-ray, MRI and the theatres (the "zoomed" reflections, and the line across
  the theatre floor) are normal floors now.
- **Better clinical furniture.** Bedside cabinets, monitor and IV stands, crash trolleys, base and wall cabinets, tall
  glass cabinets and the mortuary fridge bank are now the detailed models from RHS Pillbox (with collision).
- **Outside:** the A&E forecourt bollards sit in the paving, the floodlight pole is moved off the edge of the helipad,
  and the site totem stands down into the sloping pavement with a closed cap.

Updating from an earlier 1.0.0 candidate: replace the whole `rhs_hospital` folder (keep your edited `.ytd` files; copy
your own settings into the new `config.lua`), upload the new `.fxap` with it, restart the server and clear the client
cache. The door lists in `config.lua` are unchanged except the A&E entrance's south leaf, which opens slightly less.

## 1.0.0-rc.5

- **No more falling through the floor by the stairs.** rc.3 / rc.4 lost part of the stair hall's floor collision next to
  the main staircase; the floor is whole again (every walkable surface was checked against rc.2).
- **Stair rails meet properly.** At the foot of the main staircase the sloping wall rail, panel and skirting now run down
  into the level ones in a neat mitre instead of stepping up a riser high.
- **Wall bands reach the corners.** Outside the boss office (reception) and the on-call room (first floor) the skirting,
  oak panel and blue rail now run all the way from the door frame to the window.
- **One look from the entrance to the lower floor.** The reception, the link ramp, the lower corridor and the stair hall
  now share one floor and one daylight level (the ramp walls no longer fade darker and the lower corridor floor is no
  longer a different grey), and the 10 m haze at the end of long corridors is gone.
- **Proper hospital doors.** Every inside door is now an RHS British fire door (as in RHS Pillbox): a 54 mm leaf with a
  vision panel (solid for toilets, offices, on-call and lockers), stainless kick plates, D pull handles and hinges,
  sized to each opening. The A&E, ambulance, main and rear entrances are automatic glass sliding doors under an
  operator box; they open as you walk or drive up and close behind you.
- **The A&E corner rebuilt.** The white block above the A&E entrance is now the hospital's brick plant room with a stone
  coping (no more white box on a brick strip, vents, sawtooth canopy or dead planter), and the stairs beside the A&E
  have clean stone treads with yellow nosings, brick walls both sides and steel handrails.

**Doorlock users:** the door models changed. In ox_doorlock / qb-doorlock use the new models and coordinates from
`RHSDoors` in `config.lua` (same ids as before; the coordinates are now the hinge at floor level). The automatic
entrances are not GTA doors any more (`RHSAutoDoors`, `Config.AutoDoors`), so remove the eight `rhs4_52` to `rhs4_59`
entrance doors from your doorlock config.

Updating from an earlier 1.0.0 candidate: replace the whole `rhs_hospital` folder (keep your edited `.ytd` files; copy
your own settings into the NEW `config.lua`, because its door lists changed), upload the new `.fxap` with it, restart
the server and clear the client cache.

## 1.0.0-rc.4

- **Rear car park shadow fixed.** A large shadow no longer flickers across the rear car park when you look at it from a
  distance or from above (the distant-view ground model of the block sat above the real car park surface).
- **Dark patch on the white building by the A&E stairs removed.** The neighbouring building's wall had a black wedge
  and a black duct end where it meets the hospital; its original lighting is restored.
- **The main staircase walks like a staircase.** Players now use the stairs normally instead of bumping up each step.
- **Ceiling lights sit in the ceiling grid.** Every light panel is flush and lines up with the 600 mm ceiling tiles.
- **Softer, less glaring interior.** New acoustic ceiling tile, warmer wall paint, a wider exposure range and softer
  ambient occlusion, so rooms no longer blow out to white and ceiling edges no longer go dark.
- **Rails in the theatres, X-Ray and MRI.** A blue wall rail now caps the wall panels in both theatres, X-Ray and MRI.
- **Windows look built into the brickwork.** The punched windows of the main block now sit on stone sills under a brick
  soldier-course lintel, and the glass is less mirror-like (a light reflection instead of chrome).

Updating from 1.0.0-rc.1 or rc.2: replace the whole `rhs_hospital` folder (keep your `config.lua` and any `.ytd` you edited),
upload the new `.fxap` with it, restart the server and clear the client cache.

## 1.0.0-rc.2

- **All signage and posters can now be rebranded.** The room door signs, hanging direction signs, the cafe, shop and
  help-desk signs, the cafe menu, the 60 wall posters and the equipment screens that show the hospital name used to
  have their images locked inside the protected models. They now live in six readable texture dictionaries in
  `stream/branding/` (see "Rebrand it" in `README.md` and `branding-kit/README.txt`).
- `rhs_branding.ytd` is unchanged. If you already rebranded it, keep your copy.
- Nothing else changed: same rooms, models, collisions, doors, lift and settings.

Updating from 1.0.0-rc.1: replace the whole `rhs_hospital` folder (keep your `config.lua` and any `.ytd` you edited),
upload the new `.fxap` with it, restart the server and clear the client cache.

## 1.0.0-rc.1

- First release.
