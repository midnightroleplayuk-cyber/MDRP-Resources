# PLT MDT Documentation

Welcome to the **PLT MDT** documentation. This script provides a high-performance, responsive Mobile Data Terminal for FiveM. Below are the available exports that you can use to integrate with other scripts or your own custom documentation.

---

## 🛠️ Server-Side Exports

These exports should be called from your **server scripts**.

### 1. Create a Dispatch Call
Adds a new alert to the MDT dispatch system.
```lua
exports['plt_mdt']:CreateDispatchCall({
    code = '10-31',
    title = 'Grand Theft Auto',
    location = 'Great Ocean Hwy',
    coords = vector3(-2345.1, 321.4, 12.5),
    info = 'Suspect seen fleeing in a black Buffalo'
})
```

### 2. Get All Active Calls
Returns a list of all currently active dispatch calls.
```lua
local activeCalls = exports['plt_mdt']:GetActiveDispatchCalls()
-- Returns: table { {id, code, title, location, coords, info, time, units}, ... }
```

### 3. Get Specific Call Details
Returns details for a single call by its ID.
```lua
local details = exports['plt_mdt']:GetDispatchCallDetails(123)
```

### 4. Check for Vehicle BOLO
Checks if a license plate has an active BOLO in the MDT.
```lua
local hasBolo = exports['plt_mdt']:HasActiveBolo("ABC 123")
-- Returns: true/false
```

### 5. Get Vehicle BOLO Details
Returns the full data for a vehicle BOLO.
```lua
local boloData = exports['plt_mdt']:GetVehicleBolo("ABC 123")
-- Returns: table { id, plate, title, description, image, created_at } or nil
```

---

## 📱 Client-Side Exports

These exports should be called from your **client scripts**.

### 1. Toggle MDT Visibility
Force open or close the MDT UI.
```lua
exports['plt_mdt']:ToggleMDT(true) -- Open
exports['plt_mdt']:ToggleMDT(false) -- Close
```

### 2. Check MDT Status
Check if the MDT interface is currently open on the player's screen.
```lua
local isOpen = exports['plt_mdt']:IsMdtOpen()
-- Returns: true/false
```

### 3. Create a Dispatch Call (Auto-Resolves Location)
Adds a new alert to the MDT dispatch system from the client side. If `location` is omitted, the script automatically resolves the street name from the provided `coords`.
```lua
exports['plt_mdt']:CreateDispatchCall({
    code = '10-31',
    title = 'Grand Theft Auto',
    coords = vector3(-2345.1, 321.4, 12.5),
    info = 'Suspect seen fleeing in a black Buffalo'
})
```

---

## 🔗 External Script Integration

### Linking your Dispatch Script
If you want to route all calls from your existing dispatch script (like ps-dispatch) to the MDT, add this to your dispatch's server-side notification function:

```lua
exports['plt_mdt']:CreateDispatchCall({
    code = data.code,
    title = data.title,
    location = data.location,
    coords = data.coords,
    info = data.message
})
```

### Gunshot Detection
The MDT features built-in independent gunshot detection. You can configure this in `shared/config.lua`:
- `Config.UseExternalDispatch`: Set to `false` for standalone mode.
- `Config.EnableAutomaticGunshots`: Set to `true` to enable built-in detection.
- `Config.ExcludeJobsFromGunshots`: Whitelist jobs (police, etc.) from being reported.

---

*Documentation generated on 2026-02-14*

