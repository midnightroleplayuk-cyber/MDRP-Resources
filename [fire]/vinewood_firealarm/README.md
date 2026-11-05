# vinewood_firealarm

British-style fire alarm systems that admins set up for businesses in game. Each system has a control panel, manual call points (break glass), sounders and detectors, split across up to 8 zones.

## Install

1. Drop `vinewood_firealarm` into your resources and `ensure` it after `ox_lib`, `ox_target` and `oxmysql`.
2. Give admins access in `server.cfg`:
   ```
   add_ace group.admin vinewood.firealarm.admin allow
   ```
3. The database table creates itself on first start (`sql/install.sql` is there if you'd rather run it yourself).
4. Point `Config.Dispatch.Send` in `config.lua` at your dispatch export.

Frameworks: Qbox, QBCore and ESX are detected automatically. Standalone works too (no job-based access).

## Setting up a business

1. `/firealarm` opens the commissioning menu.
2. **New system** → business name, owner job and grade, user code (level 2), optional engineer code (level 3), tone, sound range and ARC delay. Name the zones (Kitchen, Stores, etc).
3. Under **Devices**, pick a device and zone, then **Place in world**:
   - Aim at a surface. Scroll rotates (Shift for fine), **G** toggles wall snap, **E** places, **Backspace** cancels.
   - **Prop** spawns your model; **Target point** is an invisible ox_target zone (for MLOs that already have a call point baked in).
4. Start with the control panel, then call points, then sounders. If a system has no sounders, every device acts as a sound source.

Devices can be relabelled, re-zoned, moved, teleported to or removed from the device table.

## How it plays

| Who | Access | Can do |
|---|---|---|
| Anyone | Level 1 | View panel, mute the panel buzzer, break glass |
| Owner job (grade ≥ min) / fire service jobs / user code | Level 2 | Silence / resound, reset, evacuate, disable zones, reset call points |
| Engineer code / admin | Level 3 | Test mode, test detectors, see who triggered events in the log |

- **Break glass** latches the call point. With `Config.RequireCallPointReset`, the panel won't reset until someone with level 2 resets the call point at the device (like using the MCP test key).
- A **new zone** going into alarm resounds silenced sounders.
- If the alarm isn't reset within the ARC delay, `Config.Dispatch.Send` fires once.
- **Disabled zones** persist through restarts and light the fault LED.
- **Test mode** (level 3): devices sound for a few seconds and auto-clear; no dispatch.
- Access drops back to level 1 after `Config.AccessTimeout` of inactivity. Wrong codes lock the keypad after `Config.MaxCodeAttempts`.

Panel keys: digits enter a code, ✓ opens the menu (Evacuate, Zones, Event log, Lamp test, Test mode, Exit access level), arrows navigate, ← goes back. The key switch drops your access level. Keyboard works too (digits, Enter, Backspace, arrows, Esc).

The default sounder is a recorded BS two-tone (800/970Hz alternating at 2Hz) in `html/sounds/bs_sounder_alternating.ogg`, a 2-second seamless loop. Generated alternatives are also available: two-tone, continuous 970Hz, pulsed alert and sweep. To add another recording, drop an `.ogg` loop in `html/sounds` and add it to `SAMPLES` in `html/app.js` and the tone list in `server/main.lua`. Volume falls off with distance and is dampened when you're in a different interior.

## Props

The panel (`prop_vw_firepanel`) and call point (`prop_vw_firealert`) are streamed from `/stream`, with textures in `firealarm_txd.ytd` linked through `firealarm_props.ytyp`. Sounders and detectors don't have models yet, so they place as target points until you add them to `Config.Props`. Any model that isn't streamed falls back to a target point automatically.

- Each model's wall anchor and facing are set in `Config.PropAnchors` (the back-centre of the model and a heading offset), so the pivot can be anywhere. The included props face -Y, hence `heading = 180`.
- Model the **detector as already ceiling-mounted** (base at the origin, body hanging down).
- `mcp_active` is optional: a broken-glass version swapped in while the call point is latched.
- Use `Config.WallOffset` if the pivot sits proud of the wall.

## Live panel screen

The panel prop's screen shows the live status to everyone nearby: system normal with the time, FIRE with the zone and device (cycling through zones in alarm), EVACUATE, TEST MODE, or FAULT for disabled zones. It updates the moment anything changes.

Setting up the model in Blender (Sollumz):

1. Give the screen face its **own material** with its own texture, e.g. `vinewood_fap_screen`. Any placeholder image works, as it's replaced at runtime; a 512×288 black PNG is fine.
2. **UV unwrap the screen face to fill the whole 0–1 UV space**, the right way up. The live page is stretched over the full texture.
3. Use an emissive shader (e.g. `emissive.sps`) on the screen material so it glows in the dark.
4. Set `Config.Screen.txd` and `Config.Screen.texture` to match (already set to `firealarm_txd` / `firealarmscreen` for the included panel). Set `width`/`height` to the shape of the screen face so text isn't stretched.

Texture replacement applies to every copy of the model, so the screen always shows the panel **nearest** to you (within `Config.Screen.distance`). Two panels in sight of each other will show the same screen. Target-point panels don't have a screen.

## Exports (server)

```lua
exports.vinewood_firealarm:TriggerAtCoords(coords, reason, range) -- nearest detector, for fire scripts
exports.vinewood_firealarm:TriggerZone(systemId, zone, reason)
exports.vinewood_firealarm:ResetSystem(systemId, force)
exports.vinewood_firealarm:SilenceSystem(systemId)
exports.vinewood_firealarm:GetSystemState(systemId)
exports.vinewood_firealarm:GetSystems()
```

Client: `exports.vinewood_firealarm:IsSounding(systemId)`.

Example from a fire script, when a fire spreads:

```lua
exports.vinewood_firealarm:TriggerAtCoords(fireCoords, 'Smoke detector')
```

## Credits

The recorded sounder is "BS Fire Alarm Alternating 2Hz" by adamweeden (freesound.org/s/255180), licensed under CC BY 3.0 and modified for looping. See `CREDITS.md`.
