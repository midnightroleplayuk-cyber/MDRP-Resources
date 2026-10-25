# vinewood-dispatch

Dispatch alerts for police, ambulance and fire. Works with Qbox, QBCore, ESX or standalone (ace permissions). Requires ox_lib.

## Install

1. Drop `vinewood-dispatch` into your resources folder.
2. Ensure it **after** ox_lib and your framework:
   ```
   ensure ox_lib
   ensure qbx_core
   ensure vinewood-dispatch
   ```
3. Set your job names in `Config.Services` (config.lua).
4. Standalone only: `add_ace group.police vinewood.dispatch.police allow` (same for `ambulance` / `fire`).

## Controls (rebindable in GTA settings > Key Bindings > FiveM)

| Action | Default | Command |
|---|---|---|
| Attach / detach latest alert (sets waypoint) | Y | `/dispatchrespond` |
| Open dispatch log | F9 | `/dispatch` |
| Clear newest alert from screen | Delete | `/dispatchdismiss` |
| Panic button (on duty) | unbound | `/panic` |
| Emergency call | – | `/999 [police\|ambulance\|fire] message` |
| Non-emergency call | – | `/101 message` |

| Request backup (on duty) | unbound | `/backup [routine\|urgent\|firearms]` |
| Post a call update | – | `/callupdate [call number] text` or `/cu` |
| Set your callsign | – | `/callsign 1A-12`, `/callsign` (dialog), `/callsign clear` |

`/999` with no service named goes to all three.

## Backup requests

- **Routine** goes to your own service.
- **Urgent** goes to your own service and police.
- **Firearms** goes to police only, and only police can send it.

Each type also has its own bindable key (`backup_routine`, `backup_urgent`, `backup_firearms`). Backup, panic and "down" alerts show the requesting unit's callsign. When `Config.Backup.trackUnit` is on, attaching routes your GPS to that unit's live blip instead of a fixed point, so you follow them if they move.

## Live unit blips

On-duty units see each other on the map, coloured by service, with a sprite for on foot, car, bike, helicopter, boat or plane. Blips flash while a unit's blue lights are on, and turn red and flash for 60 seconds after their panic button. `Config.LiveBlips.visibility` controls which services can see which. Requires OneSync.

## Call updates

Each call has a number (#12) shown on the card. Units post updates with `/callupdate text` (goes to the call you're attached to) or `/callupdate 12 text`, or type into the box on a call in the F9 log. Everyone on that service sees the updates in the log, the latest one shows on the pop-up, and attached units get a notification.

## Alerts on screen

Alerts stay up for 30 seconds (`Config.UI.duration`). Immediate alerts stay until you attach, clear them or open the log (`Config.UI.stickyPriorities`). Any alert that times out before you attach counts as missed, and a reminder with the number of missed calls stays on screen until you open the F9 log.

## Built-in detections

Shots fired (witness check, silencers and ranges ignored), fights, carjacking, road traffic collisions, vehicle fires, and officer/paramedic/firefighter down.

**Vehicle fires** go to fire and police. Any burning vehicle near a player is reported, but each plate only raises one alert every 5 minutes. If the plate matches a recent stolen-vehicle call (carjacking, or a lockpick script using `VehicleTheft`), the fire alert says so and the stolen-vehicle call gets an update pointing to it.

**Civilian casualties:** when any player who isn't on duty with an emergency service dies or goes into last stand, the ambulance service gets an alert after a short delay. If they're revived within the delay, no alert is sent. The alert says what happened: shot, stabbed, assaulted, struck by a vehicle, explosion, burns, fall, drowning, electrocution, or unresponsive if the cause is unknown. Violent causes go to police as well. Titles, grades and which causes include police are in `Config.Detections.civilianDown`. Toggle each in `Config.Detections`. On-duty emergency services do not trigger crime alerts.

Death and last stand are detected from the game, QB/Qbox metadata (`isdead`, `inlaststand`), ESX's death event, osp_ambulance and wasabi_ambulance (v1 and v2). The cause is only named when the player took damage just before going down, so admin /kill and bleed-outs show as "Person unresponsive". If your death script uses something else, add its state bag key to `Config.Detections.down.stateBagKeys`, or call `exports['vinewood-dispatch']:PersonDown()` from it.

---

## Client exports

```lua
-- Any preset, location filled in automatically from the player
exports['vinewood-dispatch']:SendPreset('store_robbery')

-- Every preset also has its own export (PascalCase of the preset name)
exports['vinewood-dispatch']:StoreRobbery()
exports['vinewood-dispatch']:BankRobbery({ description = 'Fleeca, Legion Square. Vault breached.' })
exports['vinewood-dispatch']:HouseBurglary({ coords = houseCoords })
exports['vinewood-dispatch']:VehicleTheft({ vehicle = vehicleEntity })  -- lockpick / hotwire scripts
exports['vinewood-dispatch']:StructureFire({ coords = fireCoords })
exports['vinewood-dispatch']:OfficerDown()
exports['vinewood-dispatch']:InjuredPerson()

-- Fully custom alert
exports['vinewood-dispatch']:SendAlert({
    title = 'ATM tampering',
    description = 'Card skimmer reported on an ATM.',
    code = 'FRAUD',              -- optional, shown on the card
    priority = 2,                -- 1 Immediate, 2 Priority, 3 Routine
    services = { 'police' },
    coords = vec3(x, y, z),      -- optional, defaults to the player
    vehicle = true,              -- true = player's vehicle, or pass an entity
    weapon = true,               -- attach the weapon type being held
    blip = { sprite = 108, colour = 1, scale = 1.0, radius = 50.0, approximate = true, flash = false },
})

-- Event alternative
TriggerEvent('vinewood-dispatch:client:sendAlert', { preset = 'suspicious' })

-- Helpers
exports['vinewood-dispatch']:GetLocationInfo(coords)  -- { street, cross, zone, postal }
exports['vinewood-dispatch']:GetVehicleInfo(vehicle)  -- { model, make, plate, colour }
exports['vinewood-dispatch']:GetService()             -- 'police' | 'ambulance' | 'fire' | nil
exports['vinewood-dispatch']:IsOnDuty()
exports['vinewood-dispatch']:SetMuted(true)
exports['vinewood-dispatch']:Respond(12, { coords = coords })  -- attach/detach as this player
exports['vinewood-dispatch']:RequestBackup('urgent')         -- 'routine' | 'urgent' | 'firearms'
exports['vinewood-dispatch']:AddNote(12, 'Suspect detained')  -- nil id = call you're attached to
```

## Server exports

```lua
-- Preset at coords, or about a player (pass their source to use their position and street names)
exports['vinewood-dispatch']:SendPreset('bank_robbery', vec3(x, y, z))
exports['vinewood-dispatch']:SendPreset('injured_person', source, { description = 'Fell from height' })
exports['vinewood-dispatch']:BankRobbery(vec3(x, y, z), { description = 'Pacific Standard' })

-- Custom (coords required). Returns the alert id.
local id = exports['vinewood-dispatch']:CreateAlert({
    title = 'Prison break',
    priority = 1,
    services = { 'police' },
    coords = vec3(1845.0, 2585.0, 45.6),
})

exports['vinewood-dispatch']:GetAlert(id)
exports['vinewood-dispatch']:GetActiveAlerts('police')   -- service optional
exports['vinewood-dispatch']:CloseAlert(id)
exports['vinewood-dispatch']:ToggleResponder(id, source)
exports['vinewood-dispatch']:GetOnDutyCount('police')    -- for robbery minimum-cop checks
exports['vinewood-dispatch']:GetPlayerService(source)    -- service, onDuty
exports['vinewood-dispatch']:AddNote(id, 'Air support overhead', 'Control')
exports['vinewood-dispatch']:AddUnitNote(id, source, 'On scene')  -- as a player, with duty/service checks
```

## Server events (for MDTs, logs, CAD)

```lua
AddEventHandler('vinewood-dispatch:server:alertCreated', function(alert) end)
AddEventHandler('vinewood-dispatch:server:alertUpdated', function(alert) end)
AddEventHandler('vinewood-dispatch:server:alertClosed', function(id) end)
AddEventHandler('vinewood-dispatch:server:responderAttached', function(id, src) end)
AddEventHandler('vinewood-dispatch:server:responderDetached', function(id, src) end)
AddEventHandler('vinewood-dispatch:server:noteAdded', function(id, note, src) end) -- note: { author, text, time }
```

Alert shape: `id, preset, code, title, description, priority, services, coords, blipCoords, location{street,cross,zone,postal}, vehicle{model,make,plate,colour}, heading, weapon, caller{name,phone}, unit{name,callsign}, unitSrc, time, responders[{src,name,callsign,service}], notes[{author,text,time}]`.

If your duty system doesn't fire the framework job events, trigger `vinewood-dispatch:client:refreshService` on the client after toggling duty.

## Callsigns

Emergency services set their callsign with `/callsign`, or from the **Callsign** button in the F9 log. It's saved per character, so it's remembered across relogs and server restarts. It shows on alerts you attach to, call updates and live blips.

- Two players online can't use the same callsign (`Config.Callsigns.unique`).
- On QB/Qbox it's also written to `metadata.callsign`, so other scripts such as qb-policejob see it.
- vinewood-mdt and vinewood-emsmdt use the same saved callsign. Changing it in the EMS MDT changes it everywhere.
- Players who haven't set one here fall back to `Config.CallsignExports`, then `metadata.callsign`.

```lua
exports['vinewood-dispatch']:GetCallsign(source)               -- what the dispatch shows
exports['vinewood-dispatch']:GetStoredCallsign(source)         -- only the saved one
exports['vinewood-dispatch']:SetCallsign(source, '1A-12')      -- ok, errOrCallsign ('' clears)
exports['vinewood-dispatch']:OpenCallsignDialog()              -- client
AddEventHandler('vinewood-dispatch:server:callsignChanged', function(src, callsign) end)
```

## MDTs

vinewood-mdt and vinewood-emsmdt read calls from this resource automatically, with attach and call updates built in.

## Security

Alerts sent from client exports are checked server-side: coords must be within `Config.Security.maxClientDistance` of the sender, there is a per-player cooldown, text is length-limited and escaped in the UI, and panic/officer-down presets can only be sent by on-duty members of that service. Set `allowCustomFromClient = false` to only accept presets from clients (custom alerts then need the server export).
