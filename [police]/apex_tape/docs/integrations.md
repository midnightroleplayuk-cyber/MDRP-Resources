# Framework permissions and optional inventory

Edit config.lua and restart APEX_Tape. Settings merge with vendor defaults. Defaults are standalone public placement, ACE-protected scene administration and no inventory requirement. These checks run on the server for player actions; trusted server exports remain trusted integrations.

## Permission modes

Permissions.Framework: standalone, qb, esx, auto, custom. Auto chooses a started qb-core, then es_extended, otherwise standalone. Select an explicit framework if both run. Qbox and other frameworks can use custom hooks; no untested native integration is claimed for them.

Permissions.Mode:

| Mode | Placement access |
| --- | --- |
| public | Everyone |
| jobs | Jobs mapped to minimum grades in Permissions.Jobs |
| staff | Configured staff groups or staff ACE |
| jobs_or_staff | Either an allowed job/grade or staff |
| ace | Permissions.UseAce |
| custom | TapeBridgeHooks.CanUse returns exactly true |

StaffBypass=true allows recognized staff through the placement job/ACE/department admission gate. Department style/category restrictions still apply to design filtering and placement. Set false to require the selected placement mode even for staff. Staff can administer other owners' scenes/tape; placement/edit gates still apply when StaffBypass is false. Staff recognition uses StaffAce/AdminAce, QBCore HasPermission, ESX getGroup, or the custom Staff hook. Permissions.Jobs and Permissions.StaffGroups replace their complete default lists when supplied in config.lua; omitted jobs/groups are removed. An empty list denies all jobs/groups in that list. ACE grants remain independent.

For a typical QBCore server:

```lua
UserConfig={Version=2,Settings={
    Permissions={Framework='qb',Mode='jobs_or_staff',RequireOnDuty=true,
        Jobs={police=0,ambulance=0,fire=0},StaffBypass=true},
    Inventory={Enabled=false},
}}
```

For ESX change Framework to esx. Set RequireOnDuty=false unless your job adapter supplies onduty=true. Grade numbers and QBCore grade.level are supported. Configure actual job names. Only jobs listed in your explicit Permissions.Jobs override are allowed.

Standalone ACE setup:

```lua
UserConfig={Version=2,Settings={
    Permissions={Framework='standalone',Mode='ace',StaffBypass=true},
    Inventory={Enabled=false},
}}
```

```text
add_ace group.police apex.policetape allow
add_ace group.admin apex.policetape.admin allow
```

Use Permissions for general access. Departments optionally restricts design categories and quotas.

## Inventory independently enabled or disabled

```lua
Inventory={Enabled=true,System='ox',TapeItem='police_tape',
    ConsumeOnPlace=true,RefundOnRemove=true,
    CutItem='scissors',ConsumeCutItem=false,
    RepairItem='police_tape',ConsumeRepairItem=true}
```

System accepts ox, qb, esx or custom. Permission framework and inventory system are independent: ESX permissions can use ox_inventory, for example. qb uses QBCore player Functions; esx uses xPlayer inventory methods. Empty item names disable individual requirements. Set Inventory.Enabled=false to disable item requirements. Optional APEX_Inventory hotbar activation uses the Item setting; set Item='' to disable it.

## Custom framework and inventory hooks

Use Permissions.Framework='custom' and a suitable mode, and/or Inventory.System='custom'. Implement server/custom.lua. This file stays server-only; retain it when replacing resource files. Hook errors deny actions. Missing required hooks block startup. Return plain values synchronously; do not trust client-provided job, staff or item claims.

```lua
TapeBridgeHooks={
    Job=function(source)
        -- Map YOUR server API to: {name='police',grade=2,onduty=true}
        return exports['my-framework']:GetTapeJob(source)
    end,
    Staff=function(source)
        return exports['my-framework']:IsTapeStaff(source)==true
    end,
    CanUse=function(source)
        return exports['my-framework']:CanUseTape(source)==true
    end,
    CountItem=function(source,item)
        return exports['my-inventory']:CountItem(source,item)
    end,
    RemoveItem=function(source,item,count)
        return exports['my-inventory']:RemoveItem(source,item,count)==true
    end,
    AddItem=function(source,item,count)
        return exports['my-inventory']:AddItem(source,item,count)==true
    end,
}
```

The example export names are placeholders to replace with your framework's real API. Job is required for custom job/department gates; Staff for custom staff checks/bypass; CanUse for custom permission mode. Custom inventory requires CountItem, RemoveItem and AddItem. Item counts must be finite, non-negative numbers; mutations return true only when the full requested operation succeeded, and false must leave inventory unchanged. Preserve transaction semantics in your adapter. This is the compatibility path for other frameworks/inventories, rather than a promise that every third-party API works unchanged.

## Target adapters and commands

commands.md documents ox_target defaults, public/job-restricted lifting and removal, custom target callbacks and all configurable command names. The target backend uses the same server permission bridge described here. client/custom_target.lua is a separate client-only adapter and should be retained alongside server/custom.lua.


## Integration API

Server exports are trusted calls from other resources; they bypass player permissions, inventory and player distance checks, while retaining coordinate, geometry, style and capacity validation. Secure the calling resource. Use plain `{x=..., y=..., z=...}` coordinate tables.

```lua
local id, errorMessage = exports['APEX_Tape']:PlaceTape({
    a = { x = 100.0, y = 200.0, z = 31.0 },
    b = { x = 105.0, y = 200.0, z = 31.0 },
    coneAId = 'my_scene:1:a', coneBId = 'my_scene:1:b',
    style = 'caution', postA = true, postB = true, bucket = 0,
})
local list = exports['APEX_Tape']:GetTapes() -- public records; excludes owner license
local removed = exports['APEX_Tape']:RemoveTape(id)
```

`GetTapes` returns all buckets for trusted server integrations; records contain the public geometry and style, without license identifiers. `PlaceTape` returns nil plus an error on rejection. `RemoveTape` returns a boolean.

Server events: `apex_policetape:placed(id, source)`, `apex_policetape:removed(id)` and `apex_policetape:torn(id, driverSource, speedKmh)`. Listen with AddEventHandler from another server resource. Client exports: `StartPlacement()` and `RemoveTape(id)`; removal uses normal server checks. Public tape records now include `sceneId`, `revision`, `brokenAt` and `breakFraction`; scene assignment through exports is optional using `sceneId` in PlaceTape.
