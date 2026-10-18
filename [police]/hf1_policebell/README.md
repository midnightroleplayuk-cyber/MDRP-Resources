# hf1_policebell

Qbox/QBX police desk bell with ox_target, ox_lib notifications, 60-second global server-enforced cooldown, and an optional in-game placement editor.

## Installation
1. Place the `hf1_policebell` folder inside your server's resources folder.
2. Ensure `ox_lib`, `ox_target`, and `qbx_core` start before `hf1_policebell`.
3. Add `ensure hf1_policebell` to `server.cfg`.
4. Give trusted admins permission to use the temporary placement tool, e.g. `(Not required: placement is restricted to fivem:1059188)` (ensure your admins belong to that group).
5. Restart/start the resource.

## Place the bell
1. In game, as an authorized admin, type `/policebellplace`.
2. Enter the model name of your bell prop. The default `prop_servicebell_01` is only a placeholder; use a model available on your server. Custom models must be streamed.
3. Move the transparent prop into position using W/A/S/D, raise/lower using E/Q, rotate using Left/Right arrow keys, and hold Shift for faster movement. Enter saves; Backspace cancels.
4. The server writes `placement.json` to the resource folder and synchronizes the prop for all players. The placement survives restarts.
5. When happy, set `Config.EnablePlacementEditor = false` in `config.lua` and restart the resource. **Do not delete `placement.json`**.

## Behavior
- A bell prop is spawned locally for each player at the saved position; ox_target shows `Press for Attention.`.
- The pressing player receives **Police: Someone will be with you shortly. Please take a seat.**
- On-duty members of jobs listed in `Config.AlertJobs` receive **Police Station: Someone is at the Front Counter.**
- Global 60-second cooldown is validated server-side. Requests are also checked for player proximity.

## Settings
- `DefaultModel` / `DefaultCoords`: initial position until saved.
- `EnablePlacementEditor`: disable editor after setup.
- `PlacementAce`: ACE permission required for placing.
- `TargetRadius`, `InteractDistance`, `CooldownSeconds`, `AlertJobs`, `NotificationDuration`: bell interaction settings.

Note: This resource spawns its own bell. If your MLO already has a bell prop, avoid doubling it; either use a different model or adapt it to target the existing prop.

## Custom bell sound (v1.2.0)
1. Put your own `.ogg` audio file inside `html/sounds/` (e.g. `bell.ogg`). No sound is bundled.
2. In `config.lua`, set `Config.SoundFile = 'bell.ogg'` (or your actual filename).
3. Set `Config.SoundVolume` (0 to 1) and `Config.SoundDistance` (metres) as desired.
4. Restart `hf1_policebell` after adding/replacing the file.

Every **successful** press plays the sound for nearby players with distance-based volume. Cooldown presses do not play sound. Existing police alerts, player confirmation, placement editor and 60-second global cooldown are unchanged.

## Dedicated prop targeting

The only supported model is `prop_door_bell_01`. The placement editor no longer asks for a model. The target is registered as a **coordinate-scoped sphere zone** around the bell placed by this resource, not as a global model target; identical props elsewhere do not get the option. The server checks player distance to the saved location and enforces the global 60-second cooldown.

Run `/policebellplace` to position the button, then press Enter to save. Add your own `html/sounds/bell.ogg` later. If the model is part of a custom map, ensure that map resource starts before this resource.

## Placement access (identifier locked)
Only the player whose FiveM identifier is `fivem:1059188` can use `/policebellplace` or save placement changes. The server checks the identifier on both requests. No ACE permission is needed for placement. Other players can still press the bell normally. Set `Config.EnablePlacementEditor = false` when finished.

## Full 3-axis rotation (new)
Use NUMPAD 8/2 to tilt the bell forward/backward (X rotation), NUMPAD 4/6 to tilt it sideways (Y rotation), and left/right arrows for yaw (Z rotation). Use SHIFT for faster movement/rotation. To lay a vertical bell flat, tilt around X or Y approximately 90 degrees. All three angles are saved in placement.json and restored after restarts. Existing placements without rx/ry remain supported.

### Placement visibility fix
The editor now always spawns its preview one metre in front of the player instead of at a previously saved location, which could be far away. It also checks object creation, keeps the preview fully visible, and displays a green placement marker. Use W/A/S/D and Q/E to move it to the desk. Saved placement is not changed until Enter is pressed.
