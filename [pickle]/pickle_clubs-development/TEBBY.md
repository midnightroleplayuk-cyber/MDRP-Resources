# TEBBY.md - pickle_clubs

## Overview

`pickle_clubs` is a FiveM resource (GTA V multiplayer) for managing player-owned nightclubs and bars.
Server owners create clubs in-game via `/managebar`; each club can have bartender stations (drink mixing minigame), bouncer NPCs (access control with escort/search), club entry points (pass/VIP system), and a society management ATM. The UI is a React/TypeScript NUI built with Vite and compiled to `nui/`. The resource supports **ESX**, **QBCore**, and a `bridge/standalone/` stub (which currently just prints an error). It depends on `ox_lib` and `mysql-async`.

---

## Code design

### Script loading order (`fxmanifest.lua`)

1. **Shared**: `@ox_lib/init.lua` → `config.lua` → `locales/**` → `modules/**/shared.lua` → `core/shared.lua`
2. **Client**: `bridge/**/**/client.lua` → `modules/**/client.lua` → `core/client.lua`
3. **Server**: `@mysql-async/lib/MySQL.lua` → `bridge/**/**/server.lua` → `modules/**/server.lua` → `core/server.lua` → `config_sv.lua`

Bridge files guard themselves with early-returns (`if GetResourceState('es_extended') ~= 'started' then return end`), so only the matching framework's bridge actually runs.

### Framework bridge (`bridge/`)

Each subdirectory (`qb/`, `esx/`, `standalone/`, `target/`, `xp/`, `events/`) exposes the same API surface. Core modules **never** call QBCore or ESX directly — they call generic functions like `ShowNotification`, `CanAccessGroup`, `AddMoney`, `GetIdentifier`, `AddSocietyMoney`, `RegisterCallback`, `Inventory.RemoveItem`, etc., which are provided by whichever bridge loaded. Switching frameworks requires loading different bridge files in `fxmanifest.lua`.

### Club data model (`modules/main/`)

**Server** holds an in-memory `Clubs` table (keyed by integer DB id). On startup, `LoadAllClubs()` fetches `pickle_clubs` and `pickle_club_entities` from MySQL, rebuilds the table, then calls `SyncAllClubs(-1)` to broadcast to all clients. On player join, `SyncAllClubs(source)` sends the current state to the new client.

Every club has:
- `label`, `description`, `coords` (vector3), `jobs` (array of `{name, primary}`), `drink_menu` (key-value drink map), `blip`, `entry_settings`
- `entities` map: `entityKey → {type, …type-specific fields…}`

Entity types: `"bartender"`, `"bouncer"`, `"club_entry"`, `"society"`.

**Client** mirrors the same `Clubs` table received via `pickle_clubs:syncClubs`. A proximity loop in `core/client.lua` and each module's render thread compare `#(pcoords - coords) < Config.RenderDistance` to decide whether to spawn NPCs and interactions.

### Entity lifecycle

- **`RegisterEntityType(name, {onStart, onRender, onUnrender, onStop})`** — modules call this inside a `CreateThread`. The `main/` module dispatches all four hooks.
- **Render path**: client enters range → fires `pickle_clubs:renderEntity` to server → server calls `onRender` callback and records the player in `EntityPlayers[id][entityId]` → client's local `onRender` (in the module) spawns NPCs and interactions.
- **Unrender path**: client exits range → `pickle_clubs:unrenderEntity` → server removes player from `EntityPlayers`, calls `onUnrender`.
- **`onStart` / `onStop`**: server-side only — called when the club is loaded/unloaded or entity created/deleted.

### Bartender system (`modules/bartender/`)

Station id = `"<clubId>:<entityId>"` string. Server manages `StationData`, `StationRegistry`, `StationControllers`. Bartender pours bottles into a glass tracked by `flavorWeights` (flavor key → 0-1 weight). `ValidateDrink()` checks alcohol %, flavor presence, dominance threshold (0.85 single-flavor, 0.70 multi), and a 0.15 balance tolerance. On success the bartender earns `orderPayment` minus `societyCut` (paid to the primary job society account). NPC orders time out via `Config.Bartender.orderTimerDuration`; player orders do not time out. Drink item consumption uses `RegisterUsableItem` and fires `pickle_clubs:addAlcohol` to the client, which drives the drunkenness system implemented in `bridge/qb/client.lua`.

### Bouncer / Club Entry systems (`modules/bouncer/`, `modules/club_entry/`)

Bouncers run a proximity + LOS detection thread per client (`BouncerThread`). Progress builds from 0→100; at 100 the server fires `pickle_clubs:throwOutPlayer`. `PlayerPassesBouncerPatrol` and `BouncerPatrolAllowsBypass` check `Config.BypassJobs` (e.g. police always bypass) and club job access. Club entry enforces vector math to detect a player crossing behind the bouncer NPC and yeets them (`SetEntityVelocity` + ragdoll). `ClubPasses` table on client tracks pass state (`nil`, `true`, or `"vip"`).

### NUI ↔ Lua communication

- **Lua → NUI**: `SendNUIMessage({ type = "…", … })`
- **NUI → Lua**: `fetchNui(eventName, data)` in TypeScript; Lua registers `RegisterNUICallback(eventName, function(data, cb))`
- Config and locale are pushed to NUI on open via `setConfig` message. The NUI reads `Config.ImageDirectory` / `Config.ImageExtension` for inventory item images.

### Database schema (auto-created at startup)

| Table | Key columns |
|---|---|
| `pickle_clubs` | `id` (auto), `label`, `description`, `coords` (JSON), `jobs` (JSON), `drink_menu` (JSON), `blip` (JSON), `entry_settings` (JSON) |
| `pickle_club_entities` | `id` (auto), `club_id`, `entity_key` (string UUID), `entity_type`, `entity_data` (JSON); unique on `(club_id, entity_key)` |

All vector3 values are stored as plain `{x,y,z}` JSON objects. `NormalizeFromDb` / `NormalizeForDb` convert between Lua `vector3` and plain tables on every read/write.

---

## Important files

| Path | Why it matters |
|---|---|
| `fxmanifest.lua` | Resource manifest — script load order, escrow ignores, NUI page, streamed assets |
| `config.lua` | All tunable values: render/interact distances, drunk thresholds, bartender timings, drink flavors, admin groups, NPC models, UI image path, BypassJobs, ClubEntry prices, society settings |
| `config_sv.lua` | Server-only config (currently minimal — `ConfigSV = {}` shell) |
| `core/shared.lua` | `lerp`, `v3`, `debugPrint`, `NumberWithCommas`, `GetItemLabel`, `GetCurrencyString`, `Templates` |
| `core/client.lua` | `CreateNPC`, `CreateProp`, `CreateBlip`, `ShowInteractText`, `CreateInteraction`, `DeleteInteraction`, `EnsureInteractionModel`, proximity interaction loop |
| `core/server.lua` | `GetPlayerIdentifiersArray`, `GetFilteredPlayerIdentifiers`, `GetPlayerPrefixIdentifier` |
| `modules/main/client.lua` | Club registry, NUI club management panel, `RegisterClub`, `RenderClub`, `RegisterEntityType`, gizmo-based entity placement, camera helpers |
| `modules/main/server.lua` | `LoadAllClubs`, `CreateClub`, `UpdateClub`, `DeleteClub`, `CreateClubEntity`, `UpdateClubEntity`, `DeleteClubEntity`, `SyncAllClubs`, `CanManageClub`, `RegisterEntityType`, event handlers for all club CRUD |
| `modules/bartender/client.lua` | Drink mixing logic, `MatchDrinkToMenuName`, color mixing (`MixColors`, HSL helpers), NPC queue/walk animations, `CreateStationInteraction` |
| `modules/bartender/server.lua` | Station data, order generation (`GenerateDrinkOrder`), `ValidateDrink`, `StartBartenderService`, `StopBartenderService`, society cut payment, drink item registration |
| `modules/bouncer/client.lua` | `BouncerThread`, `RenderBouncer`, escort/search/F6 menu, `PlayerHasClubJobAccess`, `IsBouncerImmune`, `ThrowOutPlayerScene` |
| `modules/club_entry/client.lua` | `RenderClubEntry`, `ClubEntryThread` (yeet logic), `PromptCEL`, `CanEnterClub`, `HasVipClubPass`, NUI entry dialog callbacks |
| `modules/society/client.lua` | `OpenSocietyPanel`, society deposit/withdraw callbacks, employee management NUI callbacks |
| `bridge/esx/client.lua` | ESX-side `ShowNotification`, `CanAccessGroup`, player loaded hook, inventory fallback |
| `bridge/qb/client.lua` | QBCore-side bridge + **complete drunkenness effects system** (walk cycles, camera shake, timecycle modifier, alcohol decay thread) |
| `bridge/standalone/client.lua` | Prints error and exits; standalone is not implemented |
| `bridge/events/server.lua` | `TriggerTargetedEvent` utility |
| `locales/locale.lua` | `_L(key, …)` helper; returns `ERR_TRANSLATE_<key>_404` on missing key |
| `locales/translations/en.lua` | All English player-facing strings |
| `nui/index.html` | NUI entry point (compiled Vite output) |
| `web/src/App.tsx` | React root; mounts all NUI panels |
| `web/src/components/club/ClubManagement.tsx` | Admin club management panel |
| `web/src/components/DrinkOrder.tsx` | Order display overlay |
| `web/src/components/ClubEntryDialog.tsx` | Club entry/pass purchase dialog |
| `web/src/components/SocietyPanel.tsx` | Society banking panel |
| `__INSTALL/Items/` | SQL / Lua snippets to register drink items in supported inventories |

---

## Intended behaviors

### Standalone "not supported" error
`bridge/standalone/client.lua` deliberately prints `"STANDALONE IS NOT SUPPORTED, PLEASE CODE YOUR OWN BRIDGE."` and does nothing else. This is **not** a bug — the resource requires ESX or QBCore. A server on neither framework must implement `bridge/custom/` (stub pattern from CLAUDE.md) and adjust `fxmanifest.lua`.

### `Config.Debug = true` in default `config.lua`
The default config ships with `Config.Debug = true`. This enables `debugPrint()` console noise. It is not a bug but a developer-friendly default — server owners should set it to `false` in production.

### Single primary job constraint (`UpdateClub`)
`UpdateClub` server-side enforces exactly one `primary = true` entry among the jobs array (when jobs are non-empty). Attempting to update with zero or two primary jobs returns `"Exactly one job must be marked primary"` and aborts. This is intentional — the primary job is the society account name for tax payouts and bartender cuts.

### `provides` declarations in `fxmanifest.lua`
The manifest lists `qb-policejob` and `esx_policejob` as provided resources. This is deliberate — it allows `pickle_clubs` to satisfy dependency checks from other resources that require those police job resources.

### Entity data stored without `type` field in DB
`UpdateClubEntity` sets `payload.type = nil` before writing to `entity_data` JSON. The `entity_type` column carries the type string instead. When reading back, `NormalizeFromDb` merges them (`entityData.type = row.entity_type`). This split is intentional — it avoids redundant data and keeps the DB column queryable.

### `MergeEntityUpdate` / `MergeNestedEntity` — partial update semantics
When an entity's position is updated via gizmo (e.g. move bouncer), only changed sub-fields are sent. The server merges over the existing record so that flags like `bouncer.vipMode` are not lost. Sending a partial payload that overwrites only `bouncer.coords` is intended and correct.

### Drunkenness system lives in `bridge/qb/client.lua`
The `AddAlcohol` network event handler and the entire walk-cycle / camera-shake / timecycle drunk system is implemented inside the QBCore bridge file, not in a shared module. This is deliberate — only QBCore servers use this path. ESX servers receive the event but the ESX bridge does not implement the drunk effects; the evidence system triggers (`evidence:client:SetStatus`) are also QBCore-specific. This is a known asymmetry, not a bug.

### Bouncer yeet is client-authoritative
`ClubEntryThread` runs on the player's own client and applies the velocity + ragdoll locally without a server event. This is intentional for responsiveness. The server does record and validate the throw-out via `pickle_clubs:throwOutPlayer` for the cinematic scene on all other clients.

### `Config.WeaponsAreItems = true` (unused in visible source)
This config key exists but is not referenced in any of the escrow-exposed source files. It is likely consumed by an escrowed module or reserved for future use. Do not treat its presence as dead code.

### `NumberWithCommas` prepends `"$"` unless `noCurrency = true`
The function hardcodes a `$` prefix regardless of `Config.Currency`. `GetCurrencyString` wraps it without passing `noCurrency`, so all in-game currency display uses `$`. Servers using non-dollar currency should be aware the symbol is hardcoded and not driven by `Config.Currency.currency`.

---

## Common issues & fixes

| Symptom | Likely cause | Fix |
|---|---|---|
| Resource fails to start / `nil` errors at boot | `ox_lib` or `mysql-async` not started before `pickle_clubs` | Ensure `ensure ox_lib` and `ensure mysql-async` appear above `ensure pickle_clubs` in `server.cfg` |
| `STANDALONE IS NOT SUPPORTED` in console | Neither `es_extended` nor `qb-core` is started | Start your framework resource before `pickle_clubs`, or implement `bridge/custom/` and adjust `fxmanifest.lua` |
| Drink items not appearing in inventory | Item not registered in inventory resource | Run the correct SQL / Lua from `__INSTALL/Items/` for your inventory (esx.sql, ox_inventory.lua, qbcore.lua, qs-inventory.lua) |
| `Config.ImageDirectory` wrong (items show broken images) | Path still points to `ox_inventory` but server uses QB inventory | Change `Config.ImageDirectory` to `"nui://qb-inventory/html/images/"` |
| `ERR_TRANSLATE_<key>_404` visible to players | Locale key missing from active translation file | Add the missing key to `locales/translations/en.lua` (or the active language file) |
| Bartender service fails to start with "No eligible drinks on the menu" | Drink entries reference flavors not in `Config.Bartender.flavors`, or drink menu is empty | Add valid flavor keys to `Config.Bartender.flavors` or fix the drink menu via the management panel |
| Society money not received | `Config.FrameworkSettings.society` set to wrong resource name, or society resource not started | Set to `"qb-management"` or `"qb-banking"` for QBCore; ESX uses `esx_addonaccount` automatically via the ESX bridge |
| Bouncer NPC falls through ground / floats | Spawn coords z offset — `CreateNPC` spawns at `coords.z - 1.0` intentionally to correct for GTA's ped spawn height | If the ground level is unusual, adjust entity `bouncer.coords.z` when placing with the gizmo |
| `CountPrimaryJobs` error when updating club | Updating jobs with 0 or 2+ primary entries | Ensure exactly one job has `primary = true` in the club editor |
| `display` nil error in interactive entities | `CreateInteractiveEntity` called without a `display` table in params but the `entityThread` calls `UpdateInteractiveEntityDisplay` | Always pass `params.display = { title = "…" }` when creating interactive entities whose thread updates the display |
| NUI blank / not loading | `nui/` folder missing or stale | Run `cd web && npm run build` to rebuild; compiled output goes to `../nui/` |
| `Config.Debug = true` flooding console | Default config left unchanged | Set `Config.Debug = false` in `config.lua` for production |

---

## Conventions

### Naming
- Lua globals use **PascalCase** for tables (`Clubs`, `StationData`, `OrderNPCs`) and **PascalCase** for exported functions (`RegisterClub`, `CreateInteraction`, `ShowNotification`).
- Local helpers use **camelCase** (`buildStationId`, `normalizeForDb`) or **PascalCase** when they are module-level.
- Event names: `"pickle_clubs:<action>"` (snake_case after the colon).
- NUI callback names: camelCase (`"closeClubManagement"`, `"societyDeposit"`).
- Station ids are formatted as `"<clubId>:<entityId>"` strings — always use `BuildStationId(clubId, entityId)` to construct them; never concatenate manually.

### Style
- Lua 5.4 (`lua54 'yes'` in manifest) — use `table.move`, integer division `//`, etc.
- Framework-specific code goes **only** in `bridge/`. Core modules must call bridge functions, never framework globals directly.
- All vector3 values traveling over the network or through MySQL must pass through `NormalizeForDb` (Lua → DB) and `NormalizeFromDb` (DB → Lua) to survive JSON round-trips. Never assume a coordinate is a `vector3` after a network event — use a local `ToVector3(value, fallback)` guard.
- Debug output uses `debugPrint(...)` (checks `Config.Debug`), not bare `print()`.
- New entity types must implement all four hooks: `onStart`, `onRender`, `onUnrender`, `onStop`. Omitting one will print an error at runtime but not crash (server-side `RegisterEntityType` provides a default that prints an error).
- NUI panels follow the pattern: `SendNUIMessage({ type = "open…", data = {…} })` to open, `SendNUIMessage({ type = "close…" })` to close, with matching `RegisterNUICallback("close…")` that clears focus.
- Locale strings use `_L("key")` in Lua and the `Translate` component / locale context in React. Any new player-facing string must have a corresponding entry in `locales/translations/en.lua`.
- PR changes to the web UI require a rebuild (`cd web && npm run build`) before the `nui/` assets are updated. Never edit files under `nui/` directly — they are generated output.
