# hf1_cellbuzz

QBox / qbx_core cell buzzers using ox_target and ox_lib.

## Installation
1. Copy `hf1_cellbuzz` to your server's resources directory.
2. Replace `html/buzzer.ogg` with your own valid OGG sound file. The included file is an empty placeholder, so sound will not play until replaced. Alternatively set `Config.SoundEnabled = false`.
3. Ensure `qbx_core`, `ox_lib`, and `ox_target` start before this resource.
4. Add `ensure hf1_cellbuzz` to server.cfg.

## Features
- Ten Vinewood buzzers, with individual shared 60-second cooldowns.
- Successful presses notify all on-duty police and play the supplied OGG sound for them.
- Only on-duty `police` of any grade can open/control the panel.
- Control menu shows all buzzers, enabled/disabled status, and pending requests.
- Officers can disable/re-enable each buzzer or clear a pending assistance request.
- Cooldown remains in effect after a buzzer is re-enabled.
- State is held in server memory and resets when the resource/server restarts.

## Adding stations
In `config.lua`, add another entry to `Config.Stations`:
```lua
newstation = {
    label = 'NEW STATION',
    control = vec3(0.0, 0.0, 0.0),
    buzzers = {
        { name = 'Cell 1', coords = vec3(1.0, 1.0, 1.0) },
    }
}
```
Every station has its own control panel and buzzer states.

## Notes
- Server validates police permissions and player proximity; client target visibility alone is not trusted.
- `Config.ServerDistance` allows a small margin for server/client position differences.
- The notification and sound go to on-duty police anywhere on the server.
- The menu displays all buzzers (including disabled ones), so they can be re-enabled.
- Pending requests remain visible until cleared or the buzzer is disabled.

## Wall-mounted buzzer interaction distances

Buzzers use `Config.BuzzerInteractDistance = 0.5` metres in ox_target and `Config.BuzzerServerDistance = 0.85` metres for server-side validation. The police control uses separate distances (1.5 m client, 2.0 m server). Adjust in config.lua. **Distance alone does not detect walls**: if two sides of a wall are within range, players may still target the zone. For guaranteed side-specific access, use side-specific positions or a wall/line-of-sight check tailored to your MLO.
