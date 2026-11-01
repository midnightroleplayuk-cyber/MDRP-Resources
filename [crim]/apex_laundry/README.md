# Apex Laundry

Standalone money-laundering machines for FiveM. Walk up to a
laundromat dryer, load it with cleaning supplies, feed in dirty
money, wait out the wash cycle, then collect the laundered cash
minus a configurable tax. Each machine can be upgraded for more
capacity and faster washes.

**Compatible with ESX Legacy, QBCore and QBox** — the framework is
auto-detected at runtime, no config change required.

This resource replaces the original VRP version: same gameplay,
rebuilt on the Apex architecture (framework bridge, Apex callback
bus, oxmysql persistence) with a fully redesigned premium NUI that
shares the `apex_banking` design system (Apex blue `#1F5EFF`).

---

## Features

- **Cleaner fuel system** — deposit a consumable item to power washes.
- **Wash cycles** — convert dirty money → clean money, time scales
  with the amount; a tax is skimmed off the top.
- **Two upgrade tracks** (5 levels each):
  - **Efficiency** — raises the maximum amount per wash.
  - **Potency** — cuts the wash time.
- **Per-machine permissions** — public, or gated by framework
  groups / jobs / ACE.
- **Restart-safe** — running washes persist in the database and
  resume exactly where they left off.
- **5 languages** out of the box (EN, PT, ES, FR, DE).
- **In-game machine creator** — `/laundrycreator` places dryers with a
  ghost prop (rotate, height, push/pull, **invisible-prop mode**),
  persisted in the database and synced to every player. `/removelaundry`
  deletes the closest one.
- **Per-player Settings** — an in-menu panel to change the brand colour,
  background, position, opacity and size. Saved per-player (KVP);
  `Config.theme` is the default applied to everyone on boot.
- **Premium NUI** — animated progress ring, live capacity gauge,
  count-ups, segmented upgrade meters; re-skins from one hex
  (default palette = apex_bossmenu pink `#ff5be4`, flat / no gradients).
- **Plug-and-play integrations** — auto-detects ox_inventory /
  qb-inventory, ox_target / qb-target, and notify resources
  (apex_notify, ox_lib, okok, mythic, …). All editable in
  `shared/integrations.lua`.

---

## Installation

1. Drop `apex_laundry` into your `resources` folder.
2. Ensure **oxmysql** is started before it. The SQL table is created
   automatically on first boot (or import `[SQL]/apex_laundry.sql`).
3. Create the items — see [`installation/items.md`](installation/items.md).
4. Add to your `server.cfg`:
   ```
   ensure apex_laundry
   ```
5. Grant admins the ACE perm for `/laundryadmin`:
   ```
   add_ace group.admin apex_laundry.admin allow
   ```
6. Edit `shared/config.lua` — set your **machine locations**, items,
   economy values and theme. Restart, or run `apex_laundry_reload`
   on the server console to broadcast new locations without a
   full restart.

---

## Configuration highlights (`shared/config.lua`)

| Setting | What it does |
|---|---|
| `Config.locale` | UI language: `en` / `pt` / `es` / `fr` / `de` |
| `Config.framework` | `auto` (default) or force `esx` / `qb` / `qbx` |
| `Config.features` | Toggle whole subsystems (cleaners, washing, cancel, upgrades, blips, …) |
| `Config.items` | Item names for dirty money / clean money / cleaner |
| `Config.economy` | Base value, wash time, cleaner cost, tax %, payout & upgrade-payment accounts, caps |
| `Config.upgrades` | Efficiency / potency level tables (limits, time reduction, prices) |
| `Config.machines` | Static laundromats: id, label, coords, prop, blip, permission |
| `Config.creatorDefaultPermission` | Access rule applied to machines created with `/laundrycreator` |
| `Config.markerZOffset` | Vertical offset of the floating 3D marker (negative = lower) |
| `Config.theme` | Default palette for everyone (brand `#ff5be4`, flat). Players override via in-menu Settings |

---

## Commands

| Command | Who | Description |
|---|---|---|
| `/laundrycreator` | admin | Place a new laundromat (ghost prop: scroll = rotate, shift+scroll = push/pull, ↑/↓ = height, **G = invisible**, E = place, X = cancel) |
| `/removelaundry` | admin | Delete the closest placed laundromat |
| `/laundrywhoami` | anyone | Print how the script sees your group / ACE / job (permission debug) |
| `/laundryadmin reset <machineId>` | admin | Wipe a machine's saved state |
| `/laundryadmin info <machineId>` | admin | Print a machine's state to console |
| `apex_laundry_reload` | console / admin | Rebuild machine list + broadcast to clients |

---

## Exports

**Client**
```lua
exports.apex_laundry:OpenMachine(machineId)
exports.apex_laundry:CloseMachine()
exports.apex_laundry:IsOpen()            --> boolean
exports.apex_laundry:CurrentMachine()    --> machineId | nil
```

**Server**
```lua
exports.apex_laundry:GetMachineState(machineId)     --> { cleaners, upgrades, progress }
exports.apex_laundry:GetMachineSnapshot(machineId)  --> NUI-shaped snapshot
exports.apex_laundry:ResetMachine(machineId)
exports.apex_laundry:CanUseMachine(src, machineId)  --> boolean
```

---

## Integration hooks (`shared/integrations.lua`)

Open-source, escrow-safe. Override any of:
`ClientNotify`, `RegisterTargetEntity`, `Prompt`, `DrawWorldMarker`,
`CanUseMachine`, `OnWashStarted`, `OnWashCollected`, `OnLog`.

---

_Apex Scriptz · v1.0.0_
