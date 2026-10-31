# hf1_display_veh
Persistent, client-side decorative display vehicles for QBox / FiveM.

## Install
1. Import `hf1_display_veh.sql` into your server database.
2. Put the `hf1_display_veh` folder in `resources/[local]/`.
3. The allowed FiveM identifiers are configured in `config.lua` (Kapper and Hardy). Update them if needed.
4. Ensure `oxmysql`, `ox_lib`, `qbx_core` are running before this resource; add `ensure hf1_display_veh` to server.cfg.
5. Use `/displayveh` in game. Create a display, fill out the details, position it, then press Enter to save.

## Editor
Aim at the floor/platform and LEFT CLICK to place the vehicle there (auto ground snap enabled by default). G: snap to ground at current location. Arrow keys: fine movement relative to vehicle heading. Page Up/Down: height. Q/E: heading. Shift: faster movement. Z/X: previous/next LIVE paint colour. C: switch primary/secondary paint. Enter: save. Backspace: cancel. Ground snap uses the GTA vehicle placement native; test on custom MLO platforms, which may have unusual collision.

## Notes
- Display vehicles are local decorative entities, not networked vehicles. They are invincible, frozen, non-colliding and undriveable.
- Rotation is client-side and may not be perfectly phase-synchronized between clients.
- Display spawn is replicated by database-backed server events. Vehicles reload on reconnect/resource restart.
- Vehicle model must be available on the client (including custom add-on models).
- Colours are GTA paint colour IDs 0–160; not RGB custom colours.
- The resource does not create a physical turntable prop; position the vehicle on your casino's turntable.
- The resource is intended for trusted admins. Permissions are checked server-side for every write.
- This is an initial implementation and should be tested on your specific QBox/ox_lib build.

## Performance / streaming
Displays now spawn client-side only when within `Config.StreamDistance` (default 100 m), and despawn beyond `Config.DespawnDistance` (120 m). Checks run every `Config.DistanceCheckInterval` (1500 ms); rotating vehicles update every rendered frame only while locally spawned, eliminating 30 FPS stepping at high rotation speeds. The rotation thread sleeps when no rotating display is streamed. These values are configurable. Keep despawn distance larger than spawn distance to avoid edge flicker. All display records are still synced as small metadata entries, not networked vehicle entities. No SQL migration is needed when upgrading.

## Named paint colours
Primary and secondary vehicle paint now use searchable named GTA colour dropdowns instead of numeric inputs. The corresponding GTA IDs are shown in each option for reference. Existing database values and SQL schema are unchanged.

## Live colour preview
Choose starting primary and secondary colours by name in the searchable dropdowns. During vehicle placement, press **Z / X** to cycle through the GTA paint colours on the actual preview vehicle, and **C** to switch between primary and secondary paint. The current colour names and IDs appear on-screen and the vehicle updates immediately. Press **Enter** to save the currently previewed colours along with the placement, or **Backspace** to cancel without saving. This uses existing SQL fields; no migration is required.

## Click-to-place and ground snapping
Aim at a solid surface and left-click during placement. The preview moves to the raycast hit and auto-snaps using the vehicle ground-placement native. Press G to snap again after adjusting the height. If snapping fails, manually adjust height with Page Up/Down. For a raised casino turntable, aim at the turntable surface and verify the collision; custom props without collision cannot be snapped to. Camera raycast range and automatic snap behaviour are configurable. No database migration required.
