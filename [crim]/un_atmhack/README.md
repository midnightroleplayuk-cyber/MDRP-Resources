# un_atmhack

`un_atmhack` is a standalone ATM hacking resource for FiveM with support for ESX and QBCore servers.

It focuses only on the hacking flow: target interaction, minigame, reward handling, cooldowns, police checks, dispatch alerts, locales, and Discord logs.

## Features

- ESX and QBCore support
- `ox_target` and `qb-target` support
- `ox_lib` notifications, progress bar, callbacks, and skillcheck support
- Direct support for `ps-ui` minigames
- Built-in support for:
  - `ps-ui`
  - `ps-ui-circle`
  - `ps-ui-maze`
  - `ps-ui-scrambler`
  - `utk_fingerprint`
  - `ox_lib`
- Configurable police requirement, cooldown, reward, item requirement, and ATM models
- Locales in JSON format
- Optional Discord webhook logging
- Optional dispatch integrations:
  - `default`
  - `ps-dispatch`
  - `cd_dispatch`
  - `qs-dispatch`
  - `core_dispatch`
  - `lb-tablet`
  - `custom`
  - `none`

## Requirements

Required:

- `ox_lib`
- One supported framework:
  - `es_extended`
  - `qb-core`
- One supported target resource:
  - `ox_target`
  - `qb-target`

Optional:

- `ps-ui` if you want to use the direct `ps-ui` minigame support
- `utk_fingerprint` if you want to use that minigame
- One supported inventory system:
  - framework native inventory
  - `ox_inventory`
  - `qb-inventory`
  - `lj-inventory`
  - `ps-inventory`
  - `qs-inventory`
  - `codem-inventory`
- A supported dispatch resource if you want police alerts through dispatch

## Direct ps-ui Support

This resource has direct support for `ps-ui` out of the box.

Supported `Config.Hacking.Minigame` values:

- `ps-ui`
- `ps-ui-circle`
- `ps-ui-maze`
- `ps-ui-scrambler`

If you use `Config.Hacking.Minigame = 'ps-ui'`, you can choose the actual game with:

```lua
Config.Hacking.Minigame = 'ps-ui'
Config.Hacking.PsGame = 'circle' -- circle, maze, scrambler
```

If you want to force one specific `ps-ui` game directly, use for example:

```lua
Config.Hacking.Minigame = 'ps-ui-scrambler'
```

## Installation

1. Place the `un_atmhack` folder inside your server's `resources` directory.
2. Make sure `ox_lib` is installed and started before this resource.
3. Make sure your framework is installed and running:
   - `es_extended` for ESX
   - `qb-core` for QBCore
4. Make sure one supported target resource is running:
   - `ox_target`
   - `qb-target`
5. If you want to use `ps-ui`, make sure `ps-ui` is installed and started.
6. Add this to your `server.cfg`:

```cfg
ensure ox_lib
ensure ox_target
ensure ps-ui
ensure un_atmhack
```

If you use `qb-target` instead of `ox_target`, start that resource instead.

## Basic Configuration

Edit [shared/config.lua](c:\Users\Roope\Desktop\txData\ESXLegacy_A6EF4A.base\resources\[standalone]\[Rikolliset]\un_atmhack\shared\config.lua) to match your server.

Important settings:

- `Config.Framework = 'auto'`
  Automatically detects ESX or QBCore.
- `Config.Target = 'auto'`
  Automatically detects `ox_target` or `qb-target`.
- `Config.Inventory = 'auto'`
  Automatically detects the active inventory resource or falls back to the framework inventory.
- `Config.RequiredItem`
  Item required to start the ATM hack.
- `Config.TargetItemCheck = 'auto'`
  Uses target-side item filtering only when the target and inventory combination supports it.
- `Config.RemoveItemOnUse`
  Removes the required item when the hack starts.
- `Config.MinPolice`
  Minimum number of police required online.
- `Config.AlertPolice`
  Enables police alerts.
- `Config.Dispatch.System`
  Selects the dispatch integration.
- `Config.Hacking.Minigame`
  Selects the minigame resource.
- `Config.Reward.Item`
  Reward item given after a successful hack.

Example config for `ps-ui`:

```lua
Config.Framework = 'auto'
Config.Inventory = 'auto'
Config.Target = 'auto'
Config.TargetItemCheck = 'auto'
Config.RequiredItem = 'hackingdevice'
Config.MinPolice = 2
Config.AlertPolice = true

Config.Hacking = {
    Minigame = 'ps-ui-scrambler',
    PsGame = 'circle',
    OxLibDifficulty = { 'easy', 'easy', { areaSize = 60, speedMultiplier = 1 }, 'easy' },
    OxLibKeys = { 'w', 'a', 's', 'd' },
    PsCircle = { circles = 4, time = 60 },
    PsMaze = { time = 20 },
    PsScrambler = { type = 'numeric', time = 20, mirrored = 0 }
}
```

## Reward Setup

By default, the script gives an item reward:

```lua
Config.Reward = {
    Item = 'cash',
    AmountMin = 250,
    AmountMax = 500
}
```

Make sure the reward item exists on your server.

## Discord Logs

Discord logging is optional.

Configure:

```lua
Config.Discord.Enabled = true
Config.Discord.Webhook = 'YOUR_WEBHOOK_HERE'
```

You should replace the webhook with your own private webhook before using the resource on a live server.

## Locales

Available locale files:

- [locales/en.json](c:\Users\Roope\Desktop\txData\ESXLegacy_A6EF4A.base\resources\[standalone]\[Rikolliset]\un_atmhack\locales\en.json)
- [locales/fi.json](c:\Users\Roope\Desktop\txData\ESXLegacy_A6EF4A.base\resources\[standalone]\[Rikolliset]\un_atmhack\locales\fi.json)

Set the active locale in [shared/config.lua](c:\Users\Roope\Desktop\txData\ESXLegacy_A6EF4A.base\resources\[standalone]\[Rikolliset]\un_atmhack\shared\config.lua):

```lua
Config.Locale = 'en'
```

## Notes

- The resource depends on `ox_lib` and will not work without it.
- If no supported target resource is running, ATM interaction will not register.
- If you configure a minigame resource that is not started, the script will block the hack attempt and notify the player.
- Framework detection is automatic by default, but you can force ESX or QBCore manually in the config.
