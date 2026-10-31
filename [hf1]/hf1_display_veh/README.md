# hf1_display_veh
Persistent, client-side decorative display vehicles for QBox / FiveM.

## Install
1. Import `hf1_display_veh.sql` into your server database.
2. Put the `hf1_display_veh` folder in `resources/[local]/`.
3. Add your **real** FiveM `license:` (or other identifier) to `Config.AllowedIdentifiers` in `config.lua`. Remove the placeholder.
4. Ensure `oxmysql`, `ox_lib`, `qbx_core` are running before this resource; add `ensure hf1_display_veh` to server.cfg.
5. Use `/displayveh` in game. Create a display, fill out the details, position it, then press Enter to save.

## Editor
Arrow keys: move relative to vehicle heading. Page Up/Down: change height. Q/E: rotate. Shift: faster movement. Enter: save. Backspace: cancel.

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
Displays now spawn client-side only when within `Config.StreamDistance` (default 100 m), and despawn beyond `Config.DespawnDistance` (120 m). Checks run every `Config.DistanceCheckInterval` (1500 ms); rotating vehicles update every `Config.RotationTick` (33 ms) only while locally spawned. These values are configurable. Keep despawn distance larger than spawn distance to avoid edge flicker. All display records are still synced as small metadata entries, not networked vehicle entities. No SQL migration is needed when upgrading.
