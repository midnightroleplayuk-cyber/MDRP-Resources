# vinewood_firemdt — UK Fire & Rescue MDT

## Install
1. Drop `vinewood_firemdt` into your resources.
2. `ensure ox_lib`, `ensure oxmysql`, your framework, then `ensure vinewood_firemdt`.
3. Tables create themselves on first start (`sql/install.sql` is there if you prefer to run it manually).
4. Set your fire job name in `Config.Jobs` and grade thresholds in `Config.Grades`.

Open with `/firemdt` or **F6** (rebindable). Set `Config.RequireVehicle = true` to lock it to appliances.

## What's in it
- **Incident** – live mobilising details, risk warning banner, acknowledge + route, assistance / informative / stop messages to Fire Control, live incident log, nearest water.
- **Map** – tactical map with live appliance tracking, auto-scaling as you approach, measuring tool with hose-length calculation, hydrants and risk sites drawn.
- **Hydrants** – register with ID, type, status and defects. Scan nearby GTA hydrant props and add them in one tap. Show hydrants on GPS.
- **Risk info (SSRI)** – site records with level 1–3, hazards, access, water, contacts. Incidents inside a site's radius are flagged automatically.
- **HazMat** – UN number / EAC lookup with orange-plate display (`shared/hazmat.lua`, roleplay data – add your own).
- **Vehicle rescue** – scan the nearest vehicle for fuel/HV, battery, airbags and cut zones (`shared/rescue.lua`).
- **Procedures** – SOPs, policies and aide-mémoires, editable in game. Seeded from `shared/sops.lua`.
- **Fire Control** – create incidents from waypoint or position, mobilise appliances, close incidents, appliance board, messaging.
- **Status keys** – 0–7 along the bottom, configurable. Status 0 alerts every signed-on unit. Status 4 is set automatically on arrival.

## Permissions (`Config.Grades`)
| Key | Allows |
|---|---|
| control | Fire Control tab: create, mobilise, close |
| editHydrants | Add / edit hydrants |
| editRisks | Risk records and deleting hydrants |
| editSops | Edit procedures |

Jobs in `Config.ControlJobs` get everything.

## Exports (server)
```lua
-- From a fire alarm, dispatch or fire script
local id, ref = exports.vinewood_firemdt:CreateIncident({
    type = 'Automatic Fire Alarm',
    priority = 'Category 2',
    location = 'Pillbox Hill Medical Centre',
    coords = vector3(x, y, z),
    details = 'Zone 3 smoke detector actuated',
    source = 'vinewood_firealarm',
    -- mobilise = { serverId1, serverId2 },   -- optional
})

exports.vinewood_firemdt:AddIncidentMessage(id, 'Second detector actuated, zone 4')
exports.vinewood_firemdt:MobiliseUnit(id, serverId)
exports.vinewood_firemdt:CloseIncident(id)
exports.vinewood_firemdt:GetOpenIncidents()
exports.vinewood_firemdt:GetUnits()   -- signed-on appliances with status + position
```

## Escrow
`config.lua`, `shared/*.lua` and `server/bridge.lua` are in `escrow_ignore` so buyers can edit them.
