# TEBBY.md - pickle_dj

## Overview

`pickle_dj` is a FiveM resource (FX `cerulean`, GTA5) that adds a fully-featured, in-world DJ station system to a server. Players or admins can place DJ deck props, attach speakers, controllable stage lights, and smoke machines, then stream live audio to nearby players using a browser-based WebRTC controller (the NUI). Music is transmitted via Cloudflare TURN/STUN and optionally stored in a per-player library backed by FiveManage file hosting. Supported frameworks: ESX, QBCore, and a standalone fallback.

---

## Code design

### Architecture

The resource follows the standard FiveM client/server/NUI three-layer split:

1. **Shared** (`config.lua`, `core/shared.lua`, `modules/**/shared.lua`, `locales/`) — Config tables, utility functions (`lerp`, `debugPrint`, `_L`, flash/speed value converters), and locale data. Loaded on both sides.
2. **Client** (`core/client.lua`, `modules/**/client.lua`, `bridge/**/client.lua`) — Entity management, interaction system (target or proximity keypress), prop rendering, camera control for the DJ controller, light animation loops, and NUI↔Lua bridges for the WebRTC signalling and audio library.
3. **Server** (`modules/**/server.lua`, `bridge/**/server.lua`, `config_sv.lua`, `core/server.lua`) — Database persistence (MySQL), station/entity registration, WebRTC relay, Cloudflare TURN credential fetch, per-player music library (FiveManage), and all access/permission checks.
4. **NUI** (`nui/index.html` + `nui/assets/`) — A pre-built React/TypeScript SPA (source in `web/src/`) that renders the DJ controller, mixing decks, playlist manager, light controls, and personal library UI. Communicates with the client via `RegisterNUICallback` / `SendNUIMessage`.

### Main flows

**Station placement:**
1. Admin (or item holder) triggers `/createdj` command or uses item `dj_deck_advanced`.
2. Client enters prop-placement mode; player positions the deck.
3. Client fires `pickle_dj:saveStation` server event.
4. Server validates permissions, writes to `pickle_dj_stations` and `pickle_dj_entities`, calls `RegisterDJStation` which broadcasts `pickle_dj:registerDJStation` to all clients.
5. Clients call `RenderDJStationProps` to spawn props and `CreateInteraction` for the target/proximity zone.

**DJ controller open:**
1. Player interacts with a station → `lib.callback` `pickle_dj:canAccessStationInteraction` checks whitelist/admin/ownership.
2. Approved → ox_lib context menu → "Open DJ Controller" → `pickle_dj:canAccessController` callback.
3. Client calls `SetMusicController(station.streamId)`, opens NUI, creates a scripted camera.
4. NUI fires `music_rtc_announce_broadcast` → server records broadcaster on the `MusicInstances` entry → all clients' proximity loop in `modules/music/client.lua` begins negotiating WebRTC with that broadcaster.

**Audio streaming:**
- WebRTC signalling (offer, answer, ICE) flows client → server → target client via `music:rtc:*` events.
- TURN credentials are fetched from Cloudflare at player join (server event `music:rtc:requestTurnConfig`).
- Volume and stereo pan are calculated client-side per frame based on distance to speakers and camera heading.

**Light/smoke controls:**
- Light state (enable, rotation, flash rate, speed, colors) is stored server-side in `StationLightControls` (in-memory, not persisted to the DB).
- NUI posts control changes; client relays them to server which broadcasts to all nearby clients.
- Each light entity has two rendered props (`entity` + `attEnt`) for color separation.

**Music library:**
- NUI requests a presigned upload URL → server calls FiveManage → client relays URL back to NUI → NUI POSTs the file directly to FiveManage (bytes never touch FiveM events).
- NUI confirms with file id + URL → server writes to `pickle_dj_library` table.

### Conventions used throughout

- Framework detection via `GetResourceState('es_extended')` / `GetResourceState('qb-core')` at the top of each bridge file with early `return` if not active.
- Interactions are abstracted through `CreateInteraction` / `DeleteInteraction` in `core/client.lua`; target bridge files (`bridge/target/*/client.lua`) implement `AddTargetZone`, `RemoveTargetZone`, etc.
- All locale strings go through `_L(key, ...)` (returns `ERR_TRANSLATE_<key>_404` on missing keys).
- `debugPrint(...)` gates prints behind `Config.Debug`.
- DB IDs (integers) are kept separate from in-memory game IDs (random integers 1–1 000 000) via `StationDBMapping`.

---

## Important files

| Path | Why it matters |
|------|----------------|
| `fxmanifest.lua` | Resource manifest — declares load order, escrow_ignore, `lua54 'yes'` |
| `config.lua` | All shared/client settings (DJ stations, speaker props, light types, admin groups, target, render distance) |
| `config_sv.lua` | Server-only secrets — Cloudflare TURN token/API key, FiveManage API key and upload limits |
| `core/client.lua` | Entity helpers (`CreateProp`, `CreateNPC`, `CreateBlip`), the `Interactions` system, the per-frame proximity loop |
| `core/server.lua` | Player identifier helpers (`GetPlayerIdentifiersArray`, `GetFilteredPlayerIdentifiers`) |
| `core/shared.lua` | Shared utilities: `debugPrint`, `_L`, `NumberWithCommas`, `GetItemLabel`, template table |
| `modules/dj/client.lua` | Main DJ station client logic: render/unrender props, register interactions, open controller, camera, light animation |
| `modules/dj/server.lua` | Station persistence (DB tables, `RegisterDJStation`, `LoadDJStationsFromDatabase`), whitelist, entity CRUD, `CanInteractWithStation` |
| `modules/dj/shared.lua` | Flash/speed value converters (`GetFlashValue`, `GetSpeedValue`, etc.) used by both sides |
| `modules/music/client.lua` | WebRTC signalling NUI callbacks, proximity listening loop, volume/pan calculation, NUI message routing |
| `modules/music/server.lua` | `MusicInstances` registry, broadcaster tracking, TURN config fetch, WebRTC relay event handlers |
| `modules/library/client.lua` | NUI↔server bridge for per-player music library (list, upload request/confirm, delete) |
| `modules/library/server.lua` | FiveManage presigned-URL upload protocol, `pickle_dj_library` DB table, per-player cap enforcement |
| `locales/locale.lua` | `_L()` loader; adds `Language` table and `toupper` helper |
| `locales/translations/en.lua` | All English strings including full NUI (`ui_*`) and DJ management (`dj_*`) keys |
| `bridge/esx/client.lua` | ESX framework client bridge (notification, group check, player-loaded event) |
| `bridge/esx/server.lua` | ESX framework server bridge (identifier, money, inventory, admin check) |
| `bridge/qb/client.lua` | QBCore client bridge |
| `bridge/standalone/client.lua` | Standalone fallback (ox_lib notify, `playerSpawned` hook) |
| `bridge/standalone/server.lua` | Standalone server bridge (license identifier, ACE admin check, no-op inventory) |
| `bridge/target/ox_target/client.lua` | ox_target implementation of `AddTargetZone`, `AddTargetModel`, etc. |
| `__INSTALL/Items/ox_inventory.lua` | Item definitions to paste into ox_inventory |
| `__INSTALL/Items/qbcore.lua` | Item definitions for QBCore shared items |
| `nui/index.html` | NUI entry point (references pre-built assets) |
| `web/src/` | React/TypeScript source for the NUI (not loaded at runtime — compiled to `nui/assets/`) |

---

## Intended behaviors

### Escrow / partial source
`fxmanifest.lua` lists `escrow_ignore` for `config.lua`, `config_sv.lua`, `core/*`, `bridge/**`, and `locales/**`. The compiled module files (`modules/**/`) are **escrow-protected** (not in `escrow_ignore`). This means `modules/dj/client.lua`, `modules/dj/server.lua`, `modules/music/client.lua`, `modules/music/server.lua`, `modules/library/server.lua`, `modules/gizmo/client.lua` are delivered as compiled Lua bytecode in production. Tebby will see them as Lua source only in development builds. Do not report "missing logic" from these files as bugs if they appear empty in escrow form.

### Cloudflare tokens hardcoded in config_sv.lua
`config_sv.lua` ships with example Cloudflare `turnTokenId` and `apiToken` values and a FiveManage `apiKey`. These are **placeholder/demo values** left in the file intentionally so the config structure is clear. Servers are expected to replace them. The resource degrades gracefully: if TURN credentials fail, it falls back to STUN-only. If the FiveManage key is missing/empty, library uploads are disabled (NUI shows `ui_paste_choice_library_unavailable`).

### `Config.DebugListen = false`
When `false`, the broadcaster does **not** hear their own stream by default. The code that would prevent self-listening is commented out in `modules/music/client.lua` (search for `Config.DebugListen`). The current implementation does allow the broadcaster to hear themselves — this appears intentional per the inline comment "Prevent broadcaster from listening to their own stream unless DebugListen is true … [commented out]". Do not treat this as a bug without verifying intent with the author.

### Tennis ball invisible placeholder prop
When a station is created without a visible prop (player answers "No" to the prop question), the resource uses `prop_tennis_ball` as the internal entity handle. The code in `modules/dj/client.lua` (`RenderDJStationProps`) explicitly detects this hash and makes the entity invisible (`SetEntityAlpha 0`) and non-collidable. The `zOffset` is also set to 0 for that case. This is intentional, not a missing entity.

### `StationLightControls` are in-memory only
Light control state (colors, flash, rotation, speed) is stored per game-session in `StationLightControls` on the server. It is **not saved to the database** and resets to defaults on every server restart. This is documented in a comment in `modules/dj/server.lua`. Do not report as a bug unless there is an explicit feature request for persistence.

### Standalone bridge no-ops
`bridge/standalone/server.lua` stubs `AddItem`, `RemoveItem`, `AddWeapon`, etc. as no-ops and `GetItemCount` always returns `1`, `HasWeapon` always returns `true`. This is intentional for servers with no inventory resource.

### `Config.WeaponsAreItems`
Present in `config.lua` but carries a confusingly inverted comment ("If set to false, weapons will be treated as items"). This appears to be a copy-paste artifact from another Pickle resource. Treat its effect as framework/inventory bridge–specific; do not flag the comment itself as a bug in logic.

---

## Common issues & fixes

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| Music inaudible to nearby players | Cloudflare TURN tokens not configured or expired | Set valid `turnTokenId` and `apiToken` in `config_sv.lua`; check server console for "Failed to get turn config" |
| NUI shows "Library uploads are disabled" | `ConfigSV.FiveManage.enabled` is `false` or `apiKey` is empty | Enable and configure FiveManage block in `config_sv.lua` |
| DJ stations not appearing after server restart | `mysql-async` not started before `pickle_dj` | Ensure load order in `server.cfg`: ox_lib → mysql-async → framework → pickle_dj |
| `ERR_TRANSLATE_<key>_404` shown to players | Missing locale key in `locales/translations/en.lua` (or selected language file) | Add the missing key to the relevant translation file; check `Config.Language` matches a file key |
| Station interaction not working | `Config.UseTarget = true` but no target resource running | Either start ox_target/qb-target/qtarget or set `Config.UseTarget = false` |
| Items not visible in inventory | Item images not copied; or `Config.ImageDirectory` points to wrong inventory path | Copy `__INSTALL/Images/*` to inventory images folder; update `Config.ImageDirectory` in `config.lua` |
| `dj_deck_advanced` item not usable | Item not registered in inventory | Register items from `__INSTALL/Items/` matching your inventory (ox_inventory.lua, qbcore.lua, qs-inventory.lua) |
| Players cannot interact after framework loads | Framework player-loaded event not firing `pickle_dj:requestDJStations` | Confirm the correct bridge loaded (check `GetResourceState` guards in bridge files) |
| Light colors reset on server restart | Expected behavior — light controls are in-memory only | See "Intended behaviors" section above |
| `GetOptionNames` typo causes nil in ox_target | `bridge/target/ox_target/client.lua` line in `GetOptionNames` returns `optionNames` (typo: missing `s`) instead of `optionsNames` | This is a latent bug: `optionNames` is nil; fix by changing the `return optionNames` line to `return optionsNames` |

---

## Conventions

### Naming
- Lua global functions: `PascalCase` (e.g., `RegisterDJStation`, `CreateInteraction`, `ShowNotification`).
- Local variables and local functions: `camelCase` (e.g., `stationControls`, `getStationLightControls`).
- Net events: `resource:module:action` format (e.g., `pickle_dj:saveStation`, `music:rtc:announceBroadcast`).
- NUI callbacks: `snake_case` strings (e.g., `music_rtc_offer`, `library_list`).
- Config keys: `Config.PascalCase` for top-level, nested tables use camelCase keys.

### Style
- Lua 5.4 (`lua54 'yes'`); use `local function` for module-private helpers.
- `debugPrint(...)` (never bare `print`) for debug output.
- All player-facing strings via `_L("key")` — no hard-coded strings in game logic.
- Error/success notifications via `ShowNotification(text, type)` (bridge-abstracted).
- MySQL calls use `MySQL.Async.*` (non-blocking) for writes; `MySQL.Sync.*` only where a return value is needed before continuing (e.g., row reads in callbacks).
- Server permission checks always happen **server-side** before acting; client-side checks are UX-only.

### Structure rules for PRs
- New game-side features go in `modules/` with sub-files `client.lua`, `server.lua`, `shared.lua` as needed; declare them in `fxmanifest.lua` via the existing glob patterns.
- New bridge implementations go under `bridge/<frameworkname>/client.lua` and `bridge/<frameworkname>/server.lua` with the same `GetResourceState` guard pattern.
- New locale keys must be added to `locales/translations/en.lua` under the `Language["en"]` table before referencing them with `_L`.
- New config options belong in `config.lua` (client/shared) or `config_sv.lua` (server-only secrets); document them with inline comments.
- The `web/src/` directory is the NUI source; after changes the project must be rebuilt (`pnpm build` in `web/`) and the output copied to `nui/assets/`. Do not edit `nui/assets/` files directly.
