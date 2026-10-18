# Apex Restaurant — Standalone Edition

Premium standalone restaurant management for FiveM with a blueprint-style
node editor inspired by Unreal Engine Blueprints / React Flow.

## Highlights

- **No `ox_lib`, `ox_target`, or `ox_inventory` dependency.** All UI
  primitives (notify, menu, input, alert, progress, skill check, target
  wheel, stash) ship with this resource as custom NUI components.
- **Live blueprint editor** — visually wire restaurants, blips, boss
  menus, registers, prep tables, stations, NPC shops, customer peds,
  storages, trays, menu boards and delivery hubs together with curved
  bezier connections.
- **Hot reload.** Save in the editor and the new layout is broadcast to
  every connected client immediately — no `/restart` required.
- **Hybrid persistence** — `data/restaurants.json` for the editable
  *layout* (config), MySQL for *runtime state* (society funds, stash
  contents). Tables are created automatically on first boot, and any
  pre-existing JSON state is migrated once and renamed to `.imported`.
- **Apex Notify aesthetics.** Same purple-neon palette, glow and motion
  language as `apex_notify`.

## Folder layout

```
apex_restaurant/
├── fxmanifest.lua
├── shared/                  config, items, framework bridge, utils
├── build/
│   ├── client/              core, runtime, target, zones, inventory,
│   │                        Apex lib (notify/menu/input/...),
│   │                        editor, and per-zone modules/
│   ├── server/              storage, editor backend, inventory bridge,
│   │                        and per-zone modules/
│   ├── html/                index.html + css + js (node editor + NUI)
│   └── locales/             en.lua + others
└── data/
    └── restaurants.json     persisted layout (edited via the UI)
```

## Setup

1. Drop the resource into `resources/[RecordKit]/apex_restaurant`.
2. Add to `server.cfg`:
   ```
   ensure oxmysql
   ensure apex_restaurant
   add_ace group.admin apex_restaurant.admin allow
   ```
3. **Register the items in your inventory.** This resource only *uses*
   your inventory — it does not ship items into it. Two complete,
   ready-to-paste item lists ship in **`apex_restaurant/install/`**:
   - `ox_inventory_items.lua` → paste into `ox_inventory/data/items.lua`
     (also for Qbox, which uses ox_inventory).
   - `qb_inventory_items.lua` → paste into `qb-core/shared/items.lua`.

   Then copy **every** PNG from `apex_restaurant/[IMAGES]/` into your
   inventory's image folder (`ox_inventory/web/images/` or
   `qb-inventory/html/images/`) and restart the inventory. On first boot
   the script also checks ox_inventory and prints which items (if any) are
   still missing, writing the trimmed subset to
   `install/ox_inventory_items_MISSING.lua`.
4. Start the server. Run `/restaurantcreator` in-game (see **Creator
   access** below for who is allowed to open it).

## Editor controls

| Action            | Shortcut                                           |
| ----------------- | -------------------------------------------------- |
| Drag node         | Left-click drag on the node header                 |
| Connect nodes     | Drag from a node's right port to another's left    |
| Pan canvas        | Middle-mouse or left-click on empty space drag     |
| Zoom              | Mouse wheel (anchored to cursor)                   |
| Fit / 100%        | Topbar buttons                                     |
| Delete selected   | `Delete` key                                       |
| Live preview      | Pushes the current layout to **only** your client  |
| Save              | Persists to JSON & broadcasts to **every** client  |
| Pick coords       | Crosshair icon in any coords field                 |

## Creator access

Who can open `/restaurantcreator` (and create jobs / wipe data) is
controlled by `Config.creatorAccess` in `shared/config.lua`. **Any**
matching rule grants access, and every method works on ESX, QBCore and
Qbox:

1. **ACE permission** (default): `add_ace group.admin apex_restaurant.admin allow`
2. **Admin groups** — e.g. `groups = { 'admin', 'superadmin' }` (matched
   against the framework group *and* the `group.<name>` ACE principal, so
   txAdmin/vMenu admins qualify too).
3. **Job (+ min grade)** — e.g. `jobs = { ['management'] = 0 }`.
4. **Specific identifiers** — license / steam / discord / fivem.

The matching logic lives in `shared/integrations.lua` → `Integrations.Admin`
(open source) — extend it however you like.

### Creating a job from the creator

The creator's **Create Job** button registers the job at runtime for the
detected framework:

- **ESX** — inserts `jobs` / `job_grades` / society rows and calls
  `ESX.RefreshJobs()`.
- **QBCore** — `exports['qb-core']:AddJob(...)`.
- **Qbox** — `exports['qbx_core']:CreateJobs(...)`.

Runtime jobs work with `/setjob` immediately, but for QBCore/Qbox they are
lost on restart — add the job to `qb-core/shared/jobs.lua` /
`qbx_core/shared/jobs.lua` to make it permanent.

## Frameworks & inventories

ESX / QBCore / Qbox (qbx_core) are auto-detected. The bridge in
`shared/framework.lua` exposes a uniform surface used everywhere and calls
the correct native API per framework (Qbox uses `exports.qbx_core:*`, never
the removed `GetCoreObject` / deprecated `player.Functions`).

Player items auto-route through the active inventory: **ox_inventory**,
**tgiann-inventory**, **ak47_inventory**, **origen_inventory**,
**core_inventory** (via their own exports), and **qb-inventory /
ps-inventory / qs-inventory / codem-inventory / mf-inventory** plus plain
ESX/QB (via native functions). Force a specific one with
`Integrations.Inventory.forceResource` in `shared/integrations.lua`.

The shared *stash* layer (fridge / storage / tray) is always the resource's
own MySQL-backed container, so it works no matter which inventory you run.

## Theming

All colours come from `:root` in
`build/html/css/style.css`. Change `--brand`, `--bg`, `--c-success`, etc.
and the whole UI re-skins — including notifications, menus, the node
editor, and stash.
