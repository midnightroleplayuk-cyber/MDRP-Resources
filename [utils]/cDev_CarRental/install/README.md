# cDev Car Rental - Installation Guide

## Rental papers item (choose your inventory)

Use **either** ox_inventory **or** qb-inventory. Match `Config.InventorySystem` and `Config.Framework` in `config.lua`. Default item name is `rental_papers` (same as `Config.RentalPapersItem`).

---

### ox_inventory

**Reference file:** `install/ox_inventory/items.lua`

1. Merge the `rental_papers` entry from `install/ox_inventory/items.lua` into `ox_inventory/data/items.lua`.
2. Copy `install/ox_inventory/rental_papers.png` to `ox_inventory/web/images/rental_papers.png`.
3. In `cDev_CarRental/config.lua`, set `Config.InventorySystem = 'ox_inventory'`.
4. Restart `ox_inventory`, then start `cDev_CarRental`.

Using the item calls the client export `cDev_CarRental.useRentalPapers` (opens the papers UI).

---

### qb-inventory (QBCore / Qbox)

**Reference file:** `install/qb-inventory/items.lua`

1. Add the `rental_papers` block from `install/qb-inventory/items.lua` to `qb-core/shared/items.lua` (or your framework’s `shared/items.lua` on Qbox).
2. Copy `install/ox_inventory/rental_papers.png` to `qb-inventory/html/images/rental_papers.png` (adjust if your fork uses a different images path).
3. In `cDev_CarRental/config.lua`, set `Config.Framework = 'qb'` or `'qbox'`, and `Config.InventorySystem = 'qb-inventory'`.
4. Restart core/inventory as needed, then start `cDev_CarRental`.

The resource registers a server **useable item** for `Config.RentalPapersItem`; no extra register script is required.

---

## Vehicle Keys Setup

The script supports the following key systems:

| Key System | Config Value |
|------------|--------------|
| QB-VehicleKeys | `'qb-vehiclekeys'` |
| QS-VehicleKeys | `'qs-vehiclekeys'` |
| Wasabi Carlock | `'wasabi_carlock'` |
| MrNewb Vehicle Keys | `'mrnewbvehiclekeys'` |
| CD Garage | `'cd_garage'` |
| OKOK Garage | `'okokGarage'` |
| Jaksam Keys | `'jaksam'` |
| MK VehicleKeys | `'mk_vehiclekeys'` |
| Vehicles Keys | `'vehicles_keys'` |
| F_RealCarKeysSystem | `'F_RealCarKeysSystem'` |
| None | `'none'` |

### Example Configuration
```lua
Config.GiveKeys = true
Config.KeysScript = 'wasabi_carlock'  -- Change to your key system
```

### No Keys
```lua
Config.GiveKeys = false
```

**Note:** The vehicle will always start for the player regardless of key system. The script automatically sets the vehicle as owned and starts the engine.

## Locales

Set `Config.Locale` in `config.lua` to match a file in `locales/` (without `.lua`). Examples: `en`, `es`, `de`, `fr`, `it`, `pt`, `nl`, `pl`, `ru`, `ja`, `zh-cn`, `ko`, `tr`, `sv`, `no`, `da`, `hi`, `uk`.

## Rental agreement & test drive

- With `Config.RequireSignatureBeforeRental = true`, players must sign in the NUI before the server charges and the vehicle spawns.
- Test drive length is `Config.TestDriveDuration` (seconds). Leaving the vehicle ends the session when `Config.TestDriveEndOnExit` is true (teleport back + delete vehicle if `Config.TestDriveTeleportToPed` is true).

## Escrow (Tebex Asset Escrow)

`config.lua`, `locales/**`, and `install/**` are listed under `escrow_ignore` in `fxmanifest.lua` so they stay editable for buyers.

## Configuration

All settings can be found in `config.lua`:

- `Config.RequireSignatureBeforeRental` — Require NUI signature before payment/spawn
- `Config.TestDriveDuration` — Test drive length in seconds
- `Config.TestDriveEndOnExit` — End test drive when player leaves the vehicle
- `Config.TestDriveTeleportToPed` — Teleport back to rental NPC when test drive ends
- `Config.EnableRentalLimit` — Limit how many rentals per player
- `Config.MaxRentalsPerPlayer` — Max concurrent rentals
- `Config.GiveKeys` — Give vehicle keys on rental
- `Config.KeysScript` — Keys script (see table above)
- `Config.Framework` — `'esx'`, `'qb'`, or `'qbox'`
- `Config.TargetSystem` — `'ox_target'` or `'qb-target'`
- `Config.InventorySystem` — `'ox_inventory'` or `'qb-inventory'`
- `Config.GiveRentalPapers` — Give rental papers item on rental
- `Config.RentalPapersItem` — Item name (must match shared/items or ox items)

## Dependencies

- **Target:** Run `ox_target` or `qb-target` depending on `Config.TargetSystem`.
- **Inventory:** Register the rental papers item for ox_inventory or qb-inventory (see above).
- **Keys (optional):** qb-vehiclekeys, qs-vehiclekeys, wasabi_carlock, MrNewbVehicleKeys (`mrnewbvehiclekeys`), etc.
