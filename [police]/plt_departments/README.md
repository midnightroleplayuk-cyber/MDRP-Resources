# PLT Departments - API Documentation

This document lists all available exports and events for `plt_departments` that you can use to integrate with other resources like custom MDTs, robbery scripts, or UI overlays.

---

## 🚔 Dispatch System

### Server-Side Exports

#### `CreateDispatchCall`
Creates a new dispatch call that will appear for all on-duty officers.

```lua
exports['plt_departments']:CreateDispatchCall({
    code = '10-90',          -- String: The dispatch code (e.g. 10-71, 10-90)
    title = 'Store Robbery', -- String: The title of the call
    location = 'Mission Row',-- String: Text description of location
    coords = vector3(x,y,z), -- Vector3: Coordinates for GPS
    info = 'Description here'-- String: Extra details (optional)
})
```

#### `GetActiveCalls`
Returns a table containing all currently active dispatch calls.

```lua
local activeCalls = exports['plt_departments']:GetActiveCalls()
```

### Server-Side Events

#### `plt_departments:server:createDispatchCall`
Trigger this event to create a call from client or server.

```lua
TriggerServerEvent('plt_departments:server:createDispatchCall', callData)
```

---

## 📝 BOLO System (Vehicle & Person)

### Server-Side Exports

#### `AddBolo`
Adds a new BOLO to the system. Returns the new BOLO ID.

```lua
local boloId = exports['plt_departments']:AddBolo({
    type = 'Vehicle',      -- 'Vehicle' or 'Person'
    title = 'White Sultan',
    plate = 'ABC 123',     -- Optional
    owner = 'John Doe',    -- Optional
    description = 'Aggressive driving',
    issuedBy = 'Officer Name',
    lastSeen = 'Legion Square'
})
```

#### `UpdateBolo`
Updates an existing BOLO by its ID.

```lua
exports['plt_departments']:UpdateBolo(id, {
    description = 'Updated description',
    lastSeen = 'Sandy Shores'
})
```

#### `DeleteBolo`
Removes a BOLO from the system.

```lua
exports['plt_departments']:DeleteBolo(id)
```

---

## ⚖️ Warrants System

### Server-Side Exports

#### `AddWarrant`
Adds a new arrest warrant. Returns the warrant ID.

```lua
local warrantId = exports['plt_departments']:AddWarrant({
    subject = 'Jane Doe',
    charges = 'Grand Theft Auto',
    priority = 'High', -- 'Standard', 'High', 'Critical'
    description = 'Seen driving a stolen vehicle',
    issuedBy = 'Judge Judy'
})
```

#### `UpdateWarrant`
Updates an existing warrant.

```lua
exports['plt_departments']:UpdateWarrant(id, {
    charges = 'Murder, GTA',
    priority = 'Critical'
})
```

#### `DeleteWarrant`
Removes a warrant.

```lua
exports['plt_departments']:DeleteWarrant(id)
```

---

## 👤 Member & Job Data

### Server-Side Exports

#### `GetMemberData`
Returns the department data for a specific player source.

```lua
local data = exports['plt_departments']:GetMemberData(source)
-- Returns: { dept = 'LSPD', grade = 2, onDuty = true, cid = '...', name = '...' }
```

#### `IsOnDuty`
Returns whether a player is currently on duty.

```lua
local onDuty = exports['plt_departments']:IsOnDuty(source)
```

#### `GetDepartment`
Returns the department name/ID for a player.

```lua
local dept = exports['plt_departments']:GetDepartment(source)
```

---

### Client-Side Exports

#### `GetPlayerJob`
Returns the local player's job data.

```lua
local job = exports['plt_departments']:GetPlayerJob()
-- { dept = 'LSPD', grade = 5, onDuty = true }
```

#### `IsOnDuty`
Checks if the local player is on duty.

```lua
local onDuty = exports['plt_departments']:IsOnDuty()
```

#### `GetDepartment`
Returns the local player's department.

```lua
local dept = exports['plt_departments']:GetDepartment()
```

#### `isOfficerMenuOpen`
Checks if the F6/Officer menu is currently visible.

```lua
local isOpen = exports['plt_departments']:isOfficerMenuOpen()
```

---

## 🎒 Inventory Bridge

The script features a universal inventory bridge in `shared/inventory.lua`. This allows it to support various inventory systems with minimal configuration.

### Supported Inventories
By default, the following values are supported in `Config.Inventory`:
- `ox`: [ox_inventory](https://github.com/overextended/ox_inventory)
- `qb`: [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
- `qs`: [qs-inventory](https://github.com/quasar-codes/qs-inventory)
- `codem`: [codem-inventory](https://codem.tebex.io/package/5123164)
- `core`: [core_inventory](https://core-scripts.com/package/5144185)
- `lj`: [lj-inventory](https://github.com/lolitshalo/lj-inventory)
- `chezza`: [chezza-inventory](https://chezzas-scripts.tebex.io/package/4435905)
- `tgiann`: [tgiann-inventory](https://tgiann.gitbook.io/tgiann/scripts/tgiann-inventory)

### Custom Integration
If you use a custom inventory, you can easily add support by modifying the functions in `shared/inventory.lua`. Each function handles a specific action like adding/removing items or opening stashes.

---

## 🎭 Animations & Poses

### Client-Side Exports

#### `PlayPose`
Plays a specific animation or pose from `Config.AnimPoses` or `Config.Animations`.

```lua
exports['plt_departments']:PlayPose('cop_lean')
```

#### `StopAnimation`
Stops any active pose/animation and removes props.

```lua
exports['plt_departments']:StopAnimation()
```

---

## 📡 Radar & ALPR Events

### Server-Side Events

#### `plt_departments:server:processRadarViolation`
Triggered automatically when a radar detects a speeder.

```lua
-- Listening for violations in your own script:
AddEventHandler('plt_departments:server:processRadarViolation', function(radarId, vehicleNetId, speed)
    print("Vehicle " .. vehicleNetId .. " was speeding: " .. speed)
end)
```

#### `plt_departments:server:checkBolo` (Callback)
Internal callback to check if a plate is wanted.

```lua
-- Server side
Framework.TriggerCallback('plt_departments:server:checkBolo', function(isWanted, boloData)
    -- ...
end, plate)
```

