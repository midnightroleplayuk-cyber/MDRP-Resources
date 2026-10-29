# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`pickle_clubs` is a FiveM resource (GTA V multiplayer) for managing nightclubs and bars. It supports **QBCore**, **ESX**, and standalone frameworks via a bridge abstraction layer. The UI is built with React/TypeScript and communicates with Lua via FiveM's NUI system.

## Build Commands

All web/UI work is done inside the `web/` directory. The compiled output goes to `../nui/` (i.e., `nui/` at the repo root).

```bash
cd web/
npm run dev      # Vite watch mode — rebuilds on file changes
npm run build    # One-time production build (also watches)
npm run lint     # ESLint check
```

After any UI change, the `nui/` folder must be rebuilt before the change takes effect in-game. There are no automated tests.

## Architecture

### Script Loading Order (fxmanifest.lua)

1. **Shared**: `@ox_lib/init.lua` → `config.lua` → `locales/**`
2. **Client**: Bridge client scripts → Module client scripts → `core/client.lua`
3. **Server**: `@mysql-async` → Bridge server scripts → Module server scripts → `core/server.lua`

### Key Directories

- **`config.lua`** — Single source of truth for all tunable values (render distances, drunk thresholds, flavors, NPC models, payment amounts, admin groups, etc.). Read this before changing behavior.
- **`bridge/`** — Framework abstraction. Each subdirectory (`qb/`, `esx/`, `standalone/`, `target/`, `xp/`, `events/`) provides the same API surface for different frameworks. When adding framework-specific behavior, add it here — never in modules.
- **`modules/`** — Feature modules, each with `client.lua` and `server.lua`:
  - `main/` — Club CRUD, entity registry, NUI management, admin command `/managebar`
  - `bartender/` — Drink menu system, NPC ordering, drunkenness system
  - `bouncer/` — Door security, NPC bouncer, access control
  - `club_entry/` — Entry queue system, access pass validation
  - `interaction/` — Target system integration (ox_target / qb-target / qtarget), interactive entity framework (`RegisterInteractiveEntity`, `CreateInteractiveEntity`, `UpdateInteractiveEntityDisplay`)
  - `society/` — Society banking UI (deposit/withdraw)
  - `gizmo/` — In-world entity placement tool
- **`core/`** — Shared helpers (`lerp`, `v3`, `debugPrint`, `NumberWithCommas`, `GetCurrencyString`, `GetItemLabel`)
- **`locales/`** — `_L(key, ...)` translation function + `translations/en.lua`
- **`web/src/`** — React UI source. Main components: `ClubManagement.tsx` (admin panel), `OrderDisplay.tsx` (bartender orders), `InteractiveEntityDisplay.tsx` (entity interactions), `InteractText.tsx` (help text)

### Data Flow

**Server startup**: MySQL tables are created if missing → `LoadAllClubs()` fetches all clubs into the `Clubs` in-memory table → `SyncAllClubs(-1)` broadcasts to all clients.

**Player joins**: Server sends `pickle_clubs:syncClubs` to the new client → client populates its local `Clubs` table.

**Entity rendering (proximity-based)**: Client detects player entering range → fires `pickle_clubs:renderEntity` to server → server calls the entity type's `onRender` callback → client spawns NPC / sets up targets / shows UI. Reversed on exit.

**NUI ↔ Lua communication**: `fetchNui(eventName, data)` (TypeScript → Lua), `RegisterNUICallback` / `SendNUIMessage` (Lua → TypeScript). Config and locale strings are passed to the NUI on open via `SendNUIMessage`.

### Database Schema

Two auto-created MySQL tables:
- `pickle_clubs` — Club records: `id`, `label`, `description`, `coords` (JSON), `jobs` (JSON array of `{name, primary}`), `drink_menu` (JSON)
- `pickle_club_entities` — Entities per club: `id`, `club_id`, `entity_key`, `entity_type`, `entity_data` (JSON), unique on `(club_id, entity_key)`

### Entity Type Plugin System

New entity types are registered via `RegisterEntityType(entityType, { onStart, onRender, onUnrender, onStop })`. Each module registers its own type(s) during initialization. The `main/server.lua` dispatches lifecycle callbacks.

### Interactive Entity System (modules/interaction/)

The interaction module provides a framework for bartender-style minigames with physical objects the player can pick up and manipulate.

- `RegisterInteractiveEntity(typeName, { init, entityThread, selectedThread, unSelected })` — Registers a type (e.g. "bottle", "drink", "coaster", "register"). `init` returns an entity handle + data table. `entityThread` runs every frame for rendering/display. `selectedThread` runs when the player is holding the entity.
- `CreateInteractiveEntity(typeName, coords, heading, params)` — Spawns an instance. The `params` table must include a `display` field (`{ title, secondaryTitle?, rows? }`) if the entity's `entityThread` calls `UpdateInteractiveEntityDisplay`.
- `UpdateInteractiveEntityDisplay(entity, { title, secondaryTitle?, rows? })` — Updates the floating text above an entity. Row types: `{type = "text", label = "..."}`, `{type = "progress", label = "...", value = 0-100}`.
- Entity data is stored in the global `INT_ENTITIES[entityHandle]` table, keyed by GTA entity handle.

### Bartender System (modules/bartender/)

The bartender module uses menu-based drink bottles. Each bottle on the bar corresponds to a drink from the club's `drink_menu`. The bartender pours the correct bottle into a glass to fill orders.

- **Station setup**: `CreateStationInteraction(station, drinkMenu)` fetches the menu via `pickle_clubs:getClubDrinkMenu` callback, spawns one bottle per menu drink plus a glass, coaster, and register.
- **Drink data on entities**: Bottles and glasses track `menuDrinkKey`, `menuDrinkData` (name, flavors, alcoholPct, item), and `drinkColor`. The glass also tracks `progress` (0.0–1.0 fill level).
- **Pouring**: Bottle `selectedThread` detects a drink entity below and fills it. Pouring a different drink resets the glass. Glass must reach progress >= 1.0 before submission.
- **Submission**: `CheckDrinkOnCoaster` fires when a full glass is on the coaster. With an active order, sends `pickle_clubs:submitDrink` with the `drinkKey` for server validation. Without an order, sends `pickle_clubs:giveDrinkItem` with `stationId` + `drinkKey`.
- **Server validation**: `ValidateDrink(stationId, orderId, drinkKey)` compares the submitted key to `order.drinkKey`.
- **Order generation**: `GenerateDrinkOrder(stationId)` picks a random drink from the club menu and returns `drinkKey, name, flavors, alcohol, item`.

### Drunkenness System

Configured in `config.lua`. Alcohol accumulates per drink (value from item config). Decay runs client-side at `Config.DrunkEffects.decayRate` per second. Thresholds trigger walk cycle overrides, screen effects, and camera shake. Values: light (0.05), moderate (0.25), heavy (0.50), extreme (0.75).

### Localization

Use `_L("key")` in Lua. In React, use the `Translate` component or the locale context. Add new keys to `locales/translations/en.lua` (and any other language files).

## Development Notes

- **Debug logging**: `Config.Debug = true` in `config.lua` enables `debugPrint()` output to the server/client console.
- **Framework detection**: The active framework is determined at startup in `bridge/` — switching frameworks requires changing which bridge files are loaded in `fxmanifest.lua`.
- **Target system**: Configured via `bridge/target/`. Supports `ox_target`, `qb-target`, and `qtarget` — swap by adjusting which target bridge is loaded.
- **Admin access**: Controlled by `Config.AdminGroups` in `config.lua`. The `/managebar` command checks this list.
- **Escrow**: Config files, bridge, core, and locales are escrow-excluded (editable by server owners). Module source is protected — you can read/edit `modules/*/client.lua` and `modules/*/server.lua` but `modules/interaction/` contains the core interactive entity framework which may not be fully visible.
- **Interactive entity `display` field**: When creating an interactive entity whose `entityThread` calls `UpdateInteractiveEntityDisplay`, the `params` passed to `CreateInteractiveEntity` **must** include a `display` table — the interaction framework will error on nil `display`.
