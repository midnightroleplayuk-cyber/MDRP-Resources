# tr_core

The shared library behind every [TR Scripts](https://tr-scripts.com) FiveM resource. It finds your framework, inventory, target, vehicle keys, fuel and dispatch scripts by itself, so TR scripts run on ESX, QBCore and Qbox without any setup.

It's free and open source, and you install it once: every TR script you add after it uses the same copy.

## Install

Download `tr_core.zip` from the [latest release](https://github.com/TR-Scripts67/tr_core/releases/latest) or from [tr-scripts.com](https://tr-scripts.com/download/tr_core), and put the `tr_core` folder in your resources. [Installation](https://docs.tr-scripts.com/tr_core/installation) in the docs has the rest.

## What it does for you

- **No framework setup.** TR scripts don't have a "framework" option to set. tr_core sees what your server runs when it starts.
- **One place for settings that every TR script shares**, like the language and the Discord logs, in `config.lua` and `server_config.lua`. See [Configuration](https://docs.tr-scripts.com/tr_core/configuration).
- **Version checks.** When a TR script needs a newer tr_core than yours, the server console tells you when it starts, instead of the script failing later with an unclear error.

## Supported resources

tr_core picks these up automatically. Where a kind has several, the first one that's running is used.

| Kind | Supported | Needed |
|---|---|---|
| Framework | qbx_core, es_extended, qb-core | Yes |
| Inventory | ox_inventory, qb-inventory | Yes |
| Target | ox_target, qb-target | No |
| Vehicle keys | zyke_vehiclekeys, qbx_vehiclekeys, wasabi_carlock, MrNewbVehicleKeys, Renewed-Vehiclekeys, qb-vehiclekeys | No |
| Fuel | ox_fuel, lc_fuel, cdn-fuel, ps-fuel, LegacyFuel | No |
| Police dispatch | tk_dispatch, cd_dispatch3d, rcore_dispatch, core_dispatch, qs-dispatch, cd_dispatch, ps-dispatch, origen_police, lb-tablet | No |

Without a keys script, every player can start every car. Without a fuel script, fuel is kept on the car itself. Without a dispatch script, on-duty police get a notification and a map blip. Without a target script, tr_core uses its own: a dot on what can be used, and E to pick.

Dirty money is ESX's `black_money` account, QBCore's `markedbills` bags (by their `worth`) and Qbox's `black_money` item. To use a money type of your own instead, set `accounts.dirty` in `config.lua`.

## Help

The [docs](https://docs.tr-scripts.com/tr_core) cover settings and the developer API. Questions and bug reports go in the [Discord](https://discord.gg/uBMM7RAfng).

## Licence

GPL-3.0, see [LICENSE](LICENSE).
