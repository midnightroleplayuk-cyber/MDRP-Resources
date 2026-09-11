# TN Car Rental

A Car Rental Script with NUI, rental contract, HUD timers, return stations, out-of-vehicle enforcement, and a rental paper item.

## Features

- Rental stations with custom NPCs, configurable per-station brand style (colours, logo, name) and E-key or target system interaction
- Full-screen NUI for vehicle selection showing category, seats, deposit and price — supports cash and card payment
- Rental cost = base price × duration multiplier + deposit, all calculated and shown before confirming
- Digital rental contract with typed signature — stored on the rental paper item and viewable at any time
- Vehicle spawns at the station with a clean plate, full fuel, no dirt; player is automatically seated and receives keys
- HUD timer on screen showing vehicle, plate and remaining rental time — turns red when overdue
- Overdue charge per minute after the rental expires, deducted from cash
- Deposit partially refunded on return based on vehicle engine and body health — worse condition means less back
- Out-of-vehicle timer: if the player leaves the rental vehicle too long it gets repossessed
- Return stations with markers and blips — only visible during an active rental to keep the map clean
- Rental paper item stored in inventory with all contract details as metadata; use the item to open a read-only document viewer

## Installation

1. Place the `tn_carrental` folder inside your `resources` directory
2. Optionally start `qb-target`, `ox_target` or `qtarget` 
3  Start `ox_inventory` or `qb_inventory`
4. Install the Item
5. Add `ensure tn_carrental` to your `server.cfg`

## Configuration

All stations, vehicles, prices, durations and system bridges are configured in `config.lua`.

### Framework & Bridges

```lua
Config.Framework   = 'auto'      -- auto, esx, qb, standalone
Config.Inventory   = 'auto'      -- auto, ox_inventory, qb, none
Config.Target      = 'none'      -- ox_target, qb-target, qtarget, none
Config.VehicleKeys = 'auto'      -- auto, none, qb-vehiclekeys, qbx_vehiclekeys,
                                 --   qs-vehiclekeys, cd_garage, wasabi_carlock,
                                 --   Renewed-Vehiclekeys, t1ger_keys, mk_vehiclekeys,
                                 --   xd_locksystem, VehicleKeyChain
```

### General Settings

```lua
Config.Locale                 = 'en'            -- Locale file to load: de or en
Config.Currency               = '$'             -- Currency symbol shown in the UI
Config.RentalPaperItem        = 'rental_paper'  -- Inventory item name for the rental paper
Config.ReturnRefundPercent    = 0.25            -- Fraction of deposit refunded on return (based on vehicle condition)
Config.OverdueChargePerMinute = 50              -- Amount charged per minute after rental time expires
Config.OutOfVehicleTimeout    = 300             -- Seconds outside the rental vehicle before it is repossessed (0 = disabled)
Config.MinReturnDistance      = 8.0             -- Distance in metres to trigger the return zone
Config.ShowBlips              = true            -- Show rental station blips on the map
```

### UI Styles

Each rental station can use its own brand style. Styles control colours, logo text and logo image. They are defined in `Config.UIStyles` and assigned per station via `uiStyle`:

```lua
{
    id       = 'airport',
    label    = 'Airport Rental',
    uiStyle  = 'touchdown',   -- escalera | touchdown | jiff | olymp
    coords   = vec4(...),
    spawn    = vec4(...)
}
```

Available built-in styles: `escalera`, `touchdown`, `jiff`, `olymp`.

### Vehicles

Each vehicle entry supports a custom image placed in `html/img/vehicles/`. PNG, JPG and WEBP are supported.

```lua
{
    label     = 'Blista Compact',
    model     = 'blista',
    image     = 'img/vehicles/blista.png',
    category  = 'Compact',
    seats     = 4,
    deposit   = 150,
    basePrice = 250,
    accent    = '#35d0ff'   -- Accent colour used on the vehicle card in the UI
}
```

### Rental Durations

```lua
Config.RentalDurations = {
    { label = '15 Minutes', minutes = 15,  priceMultiplier = 1.0 },
    { label = '30 Minutes', minutes = 30,  priceMultiplier = 1.8 },
    { label = '1 Hour',     minutes = 60,  priceMultiplier = 3.2 },
    { label = '2 Hours',    minutes = 120, priceMultiplier = 5.7 },
}
```

`priceMultiplier` is applied to `basePrice` to calculate the rental rate. The deposit is always added on top.
