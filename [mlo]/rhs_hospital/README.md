# RHS Burton Hospital

A British district general hospital for FiveM, built on the Burton plot where the Los Santos Customs used to be.
Walk-in, ambulance and rear entrances, A&E, imaging, theatres, wards, offices and a roof helipad, with a four-stop
lift, British fire doors, automatic sliding entrances and ambient peds kept out of the clinical rooms.

Version 1.0.0-rc.11. Standalone: no framework, no database, no other resource needed.

## What is inside

- **31 rooms** across the ground floor, the reception level, the first floor and the roof, joined by
  73 portals, so the interior streams and lights like a real MLO.
- **Emergency and clinical:** emergency waiting area, clinical corridor, blood test, treatment, resus, X-ray, MRI,
  post-anaesthesia room, two theatres, morgue and mortuary, back reception, hospital vehicle garage with its shutter.
- **Public and staff:** main reception, rear reception, pharmacy, ward, canteen, ICU, relatives' waiting, staff room
  and lockers, boss office, on-call room, two offices, meeting room, toilets.
- **Getting around:** stairs, a link ramp, and a four-stop lift (A&E, reception, first floor, roof).
- **145 custom props and fixtures** (scanners, desks, signage totems, cubicles, wall fittings) plus stock GTA
  medical props placed room by room: 1,496 placed pieces in the interior alone.
- **Exterior:** new facade, canopies, car park with hedges and palms, helipad roof, night lighting and uplights.
- **Doors:** oak British fire doors throughout (vision panels, lever handles, kick plates and closers; solid doors for
  X-ray, MRI and the theatres), white doors into the toilets, a green steel fire exit door from the garage, and
  automatic glass sliding doors at the A&E, ambulance, main and rear entrances (telescopic at the A&E, ambulance and
  rear).
- **Optional scripts** (all switchable in `config.lua`): door controller, automatic entrances, lift, NPC blocker, and the
  retirement of the old Burton Customs interior.

## Requirements

- FXServer artifact **5181 or newer** (needed for Cfx asset escrow).
- Game build **3258 or newer**. It is built against build 3258, so set `sv_enforceGameBuild 3258` (or higher).
- Nothing else. It does not need ox_lib, a framework or a database.

## Install

1. **Remove every older copy** of the hospital (any folder called `rhs_hospital`, including test candidates). Two
   copies will fight over the same files.
2. Upload the `rhs_hospital` folder to your resources, for example `resources/[maps]/rhs_hospital`.
   **Upload the `.fxap` file in that folder too.** Some FTP programs skip it and the escrowed files will not load.
3. Add `ensure rhs_hospital` to `server.cfg`.
4. Make sure no other resource brings back the Burton Los Santos Customs interior or builds on this plot. The hospital
   switches the old interior off itself (`Config.RetireOldCustoms`).
5. Restart the server and reconnect. A script-only restart is not enough for a map: restart the server, then
   restart the game client. If you still see the old look, clear the client cache.

## Settings (`config.lua`)

`config.lua` is the only Lua file you can read and edit; everything in `client/` is protected.

| Setting | Default | What it does |
| --- | --- | --- |
| `Config.Doors.Enabled` | `true` | Registers the hinged fire doors and the garage shutter as unlocked GTA doors. Set it to `false` if a doorlock resource controls these doors. |
| `Config.AutoDoors.Enabled` | `true` | The automatic sliding entrances (A&E, ambulance, main, rear). They are not GTA doors, so keep this on even with a doorlock resource. `/rhsdoors` in F8 lists their state for support. |
| `Config.Lift.Enabled` | `true` | Four-stop lift. Stand at a lift front: **E** up, **G** down. |
| `Config.NpcBlock.Enabled` | `true` | Stops ambient peds spawning or walking inside the hospital. Mission peds and players are never touched. |
| `Config.RetireOldCustoms` | `true` | Switches off the old Burton Los Santos Customs interior. Leave it on unless another resource does it. |
| `RHSDoors` | all doors | The hinged door list (model + world position of the hinge at floor level). Delete a line to leave that door to another resource. |
| `RHSAutoDoors` | 14 leaves | The automatic sliding leaves: four at the telescopic A&E, ambulance and rear entrances, two at the main entrance. Delete an entrance's lines (same `group`) to remove it. |

The door controller is unlocked-only: it does not implement job locks. Use a doorlock resource for that and turn
`Config.Doors.Enabled` off.

## Rebrand it (`branding-kit/`)

Every texture that shows the hospital's name or logo ("RHS, Royal Health Service, Burton Hospital") is in a readable
texture dictionary in `stream/branding/`. None of them is locked inside a model.

| Dictionary | What it holds |
| --- | --- |
| `rhs_branding.ytd` | Facade signs, reception backdrop and totems, directory totem, site totem, reception posters and notices |
| `rhs_branding_signs.ytd` | The 32 room door signs (logo + room name) |
| `rhs_branding_wayfinding.ytd` | Hanging direction signs, the cafe, shop and help-desk signs, the cafe menu board |
| `rhs_branding_posters_1.ytd` to `_3.ytd` | The 60 wall posters, in alphabetical thirds |
| `rhs_branding_screens.ytd` | The vitals monitor and X-ray screens that show the hospital name |

The `branding-kit/` folder has one sub-folder per dictionary with the original images (PNG, same names, same sizes),
and `branding-kit/README.txt` lists every texture with its size, format and the model that uses it.

1. Open the dictionary in OpenIV or CodeWalker and replace the textures you want with your own images. Keep the
   **name**, the **size** and the **format** (DXT1 for opaque images, DXT5 for anything with transparency).
2. Save, restart the server and clear the client cache.
3. The generic wayfinding signs (Main Entrance, A&E, X-Ray, ...) are in `stream/interior/rhs2_shared.ytd`, which you can
   edit the same way.

When you update the hospital, keep your edited `.ytd` files and copy them over the new ones.

## Other maps and Vertex Hub

This map overrides a small set of GTA files for its tile (the Burton block and its distance models, its lod lights,
occluders, roads and collision). They are in `stream/vanilla/` and are **not encrypted**, so Vertex Hub can merge them with other maps.
`compatibility/README.md` lists every overridden file by name. If another map on your server edits the same files
(any map near the Burton Los Santos Customs, or one that edits the district distance models `ss1_lod_slod3*`), merge
them with Vertex Hub instead of letting one overwrite the other.

## Licence

One server per purchase. No resale, no sharing, no re-upload of this resource or of edited copies. You may edit it
for your own server only. Full terms: `LICENSE.txt` and the store's purchase terms. Third-party and Rockstar
material: `THIRD_PARTY_NOTICES.md`.
