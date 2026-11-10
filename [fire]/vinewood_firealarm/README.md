# vinewood_firealarm

British-style fire alarm systems that admins set up for businesses in game. Each system has a control panel, manual call points (break glass), sounders and detectors, split across up to 8 zones.

## Install

1. Drop `vinewood_firealarm` into your resources and `ensure` it after `ox_lib`, `ox_target` and `oxmysql`.
2. Give admins access in `server.cfg`:
   ```
   add_ace group.admin vinewood.firealarm.admin allow
   ```
3. The database table creates itself on first start (`sql/install.sql` is there if you'd rather run it yourself).
4. Dispatch is detected automatically (see **Dispatch** below).

Frameworks: Qbox, QBCore and ESX are detected automatically. Standalone works too (no job-based access).

## Setting up a business

1. `/firealarm` opens the commissioning menu.
2. **New system** → business name, owner job and grade, user code (level 2), optional engineer code (level 3), tone, sound range and ARC delay. Name the zones (Kitchen, Stores, etc).
3. Under **Devices**, pick a device and zone, then **Place in world**:
   - Aim at a surface. Scroll rotates (Shift for fine), **G** toggles wall snap, **E** or **Enter** places, **Backspace** cancels.
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
- If the alarm isn't reset within the ARC delay, the fire service is called through your dispatch (see **Dispatch**).
- **Disabled zones** persist through restarts and light the fault LED.
- **Test mode** (level 3): it's a walk test, so nothing sounds until you activate a device. Each call point or detector you activate sounds the sounders for `Config.TestSoundDuration` and clears itself; no dispatch, no break-glass cooldown.
- **Test sounders** (level 2, panel menu or admin menu): runs every sounder on the system for `Config.SounderTestDuration` without needing a device.
- Access drops back to level 1 after `Config.AccessTimeout` of inactivity. Wrong codes lock the keypad after `Config.MaxCodeAttempts`.

Panel keys: digits enter a code, ✓ opens the menu (Evacuate, Zones, Event log, Lamp test, Test mode, Exit access level), arrows navigate, ← goes back. The key switch drops your access level. Keyboard works too (digits, Enter, Backspace, arrows, Esc).

The default sounder is a recorded BS two-tone (800/970Hz alternating at 2Hz) in `html/sounds/bs_sounder_alternating.ogg`, a 2-second seamless loop. Generated alternatives are also available: two-tone, continuous 970Hz, pulsed alert and sweep. To add another recording, drop an `.ogg` loop in `html/sounds` and add it to `SAMPLES` in `html/app.js` and the tone list in `server/main.lua`. Volume falls off with distance and is dampened when you're in a different interior.

## Props

All five devices have models, streamed from `/stream`: panel (`prop_vw_firepanel`), call point (`prop_vw_firealert`), sounder (`prop_vw_sounder`), smoke detector (`prop_vw_smokedetector`) and sprinkler (`prop_vw_sprinkler`); the last two go on ceilings. Textures are in `firealarm_txd.ytd`, linked through `firealarm_props.ytyp`. Any model that isn't streamed falls back to a target point automatically.

- Each model's wall anchor and facing are set in `Config.PropAnchors` (the back-centre of the model and a heading offset), so the pivot can be anywhere. The included props face -Y, hence `heading = 180`.
- Model the **detector as already ceiling-mounted** (base at the origin, body hanging down).
- `mcp_active` is optional: a broken-glass version swapped in while the call point is latched.
- Use `Config.WallOffset` if the pivot sits proud of the wall.

## Dispatch

If the alarm isn't reset within the ARC delay, an **Automatic fire alarm** call goes to the fire service. `Config.Dispatch.system = 'auto'` uses the first of these that's running:

| Dispatch | How it's sent | Notes |
|---|---|---|
| vinewood-dispatch | `CreateAlert` export | Further zones, silencing and reset are added to the call. `closeOnReset` closes it on reset. |
| ps-dispatch | `ps-dispatch:server:notify` | Add a blip entry for `psCodeName` (below). Uses job types: set `psJobs` if yours differ. |
| cd_dispatch | `cd_dispatch:AddNotification` | Sent through the player nearest the premises, as cd_dispatch expects alerts from a client. |
| qs-dispatch | `qs-dispatch:server:CreateDispatchCall` | |
| rcore_dispatch | `rcore_dispatch:server:sendAlert` | |
| core_dispatch | `sendAlert` export | |
| lb-tablet | `AddDispatch` export | Goes to the MDT named in `lbMdt` (default `Fire`). |

Set `system` to one of those names to force it, `'none'` to disable, or fill in `Config.Dispatch.Send` for anything else. Jobs, priority, code, title and blip are shared settings in `Config.Dispatch`.

ps-dispatch blip entry, in `ps-dispatch/shared/config.lua` under `Config.Blips`:

```lua
['firealarm'] = {
    radius = 0, sprite = 436, color = 1, scale = 1.2, length = 3,
    sound = 'Lose_1st', sound2 = 'GTAO_FM_Events_Soundset', offset = false, flash = true,
},
```

Devices store their street and area when placed, so calls show a proper location. Devices placed before this update get one when you move them.

## Live panel screen

The panel prop's screen shows the live status to everyone nearby: system normal with the time, FIRE with the zone and device (cycling through zones in alarm), EVACUATE, TEST MODE, or FAULT for disabled zones. It updates the moment anything changes.

Setting up the model in Blender (Sollumz):

1. Give the screen face its **own material** with its own texture, e.g. `vinewood_fap_screen`. Any placeholder image works, as it's replaced at runtime; a 512×288 black PNG is fine.
2. **UV unwrap the screen face to fill the whole 0–1 UV space**, the right way up. The live page is stretched over the full texture.
3. Use an emissive shader (e.g. `emissive.sps`) on the screen material so it glows in the dark.
4. Set `Config.Screen.txd` and `Config.Screen.texture` to match (already set to `firealarm_txd` / `firealarmscreen` for the included panel). Set `width`/`height` to the shape of the screen face so text isn't stretched.

Texture replacement applies to every copy of the model, so the screen always shows the panel **nearest** to you (within `Config.Screen.distance`). Two panels in sight of each other will show the same screen. Target-point panels don't have a screen.

## Servicing

Gives the fire job (or any jobs in `Config.Servicing.jobs`) regular RP work.

1. Every `interval` real days (default 14) a system comes due. Service jobs on duty get a notification, and a low-priority **Fire alarm service due** job goes to your dispatch.
2. `/fireservice` shows the schedule: every premises, when it's due, faults, and a waypoint button.
3. At the panel, an engineer picks **Start service visit**. This puts the system into test mode, so nothing calls the fire service.
4. They visit each device and use **Service device** (ox_target), with a progress bar and animation. Detectors are tested with a smoke pole, call points with the key, and so on. Sounders briefly sound on each test.
5. Back at the panel, **Sign off service** marks it done, records it in the log and pays the engineer (`payment`).

Overdue systems slowly develop faults (`faults.chancePerDay`). Faulty detectors don't detect, faulty sounders stay silent, faulty call points do nothing and faulty sprinklers don't operate. The panel shows FAULT with the device, the fault LED lights, and servicing that device repairs it. Admins can **Mark serviced** in the admin menu.

Service jobs get level 2 at every panel, and level 3 during their own visit.

## Sprinklers

Place sprinklers on the ceiling like any other device (`prop_vw_sprinkler`, streamed in `/stream`). They **only operate when a smoke detector in the same zone detects fire or smoke**: never from call points, admin triggers, detector tests or test mode.

- `Config.Sprinklers.mode = 'zone'` runs every sprinkler in the zone; `'radius'` only those within `radius` of the detector.
- Heads spray, soak players underneath, put out GTA fires and apply water to vinewood_fire cells within `coverage`. Water on petrol or chip-pan fires flares them up, as vinewood_fire models it.
- They run until the panel is reset, someone with level 2 picks **Shut off sprinklers** on the panel, or `maxDuration` runs out.
- The panel, in-world screen, event log and vinewood-dispatch call all show when sprinklers are operating.

## Automatic detection

Smoke detectors go off on their own (settings in `Config.Detection`):

- **vinewood_fire** fires, checked on the server with its `IsFireNear` export, so fire spreading under a detector sets it off.
- **GTA fires**: molotovs, burning vehicles and other script fires.
- **Explosions** near a detector (instant).
- **Smoke grenades and BZ gas**.

A detection has to be seen on `confirm` checks in a row (default 2, about 4 seconds) before the alarm goes off, so a quick flash doesn't trigger it. Detectors in disabled zones ignore everything, and test mode treats detections as tests. Other fire scripts can still use the `TriggerAtCoords` export.

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
