# Apex Dealerships

Premium vehicle dealership suite for **FiveM** — live 3D showroom with an
orbit camera and instant paint preview, **truly amortized financing** with
early-payoff discounts, player-owned dealerships with treasury / employees /
stock ordering / coupons / analytics, employee direct sales with consent
prompts, test drives in private routing buckets, and a server-authoritative
purchase pipeline from end to end.

Compatible out of the box with **ESX Legacy**, **QBCore**, and **QBox** — the
framework is auto-detected (pin it with `Config.framework` if you renamed your
core). Optional integrations (vehicle keys, fuel, society banking) are
auto-detected at runtime.

## Requirements

| Resource | Required | Notes |
|---|---|---|
| ESX Legacy / QBCore / QBox | yes | any one of them |
| `oxmysql` | yes | database access |
| `ox_lib` | yes | notifications + vehicle properties (QBox uses ox_lib for these) |
| Vehicle keys / fuel / society banking | no | auto-detected, see `shared/integrations.lua` |

The NUI loads its font and icon set from the internet. A server whose players
have no internet access will render the UI without icons.

## Features

- **Live 3D showroom** — the real vehicle rendered in the world; drag to
  rotate, scroll to zoom, swap paint colours live, handling stats computed
  from the actual game data.
- **Amortized finance** — configurable down payment, terms and APR;
  interest scales with the term; early payoff charges only remaining
  principal; repossession only after N missed installments (with grace);
  offline players are charged from their DB bank balance.
- **Player-owned dealerships** — funds-guarded treasury (can never go
  negative), employee roles with granular permissions, wholesale stock
  ordering with timed delivery, per-vehicle repricing within limits,
  7-day revenue chart, paginated searchable sales ledger.
- **Direct sales** — an employee proposes, the customer confirms on their
  own screen and pays with their own money; commission is funds-guarded.
- **Coupons** — percent/fixed, max uses, per-player limits, expiry,
  race-safe redemption.
- **Test drives** — private routing bucket per drive, per-dealership
  concurrency cap, optional refundable deposit, server-side hard timeout.
- **Sell-back** — drive in, get a quote at a configurable percentage,
  owned dealerships buy with their own treasury and gain the stock.
- **Showcase vehicles** — place display cars on the floor from the
  management panel.
- **In-game admin panel** (`/dealerships`) — create/edit/duplicate/disable
  dealerships on a live Leaflet map, pick every zone in the world (ground
  markers with adjustable radius, ghost vehicles for spawn points and
  multiple delivery bays), full blip customization, per-stand job +
  grade→role permissions, job whitelists and society buyers, unlimited or
  stocked inventory per stand. No config-file editing — stands live in the
  database.
- **Curated vehicle listings** — build named vehicle lists, duplicate them,
  and assign a listing to a stand instead of whole categories.
- **Stand ownership & sale** — hand a dealership to a player, list it for
  sale so anyone can buy it at the marker, or sell it directly to a nearby
  player with a consent prompt; the previous owner is paid even offline.
- **Catalog importer** — one click imports from the built-in 470+ GTA
  catalog, QBCore/QBox shared vehicles, the ESX `vehicles` table, or any
  started resource that ships a readable vehicle data file.
- **Admin catalog** — add/update/remove vehicles in-game (ace-gated),
  seeded with 470+ base-game + DLC land vehicles on first boot.
- **Discord webhooks** — purchases, finance events, business activity.
- **5 languages included** — English, Portuguese, Spanish, French, German. Set
  `Config.locale`; any key missing from a language falls back to English, so you
  can drop a new `build/locales/xx.lua` in and it loads itself.

## Installation

1. Drop the `apex_dealerships` folder into your `resources/` directory (any
   subfolder works, e.g. `resources/[standalone]/`).
2. SQL is auto-created on first start (the `[SQL]` file is optional — import it
   only if your database user cannot create tables).
3. Add `ensure apex_dealerships` to `server.cfg` AFTER your framework,
   `oxmysql` and `ox_lib`. Since 1.1.2 a wrong order no longer breaks buying
   (the resource waits for the framework instead of guessing ESX); if
   `dealerdiag` in the server console prints `GUESS`, fix the order or set
   `Config.framework`. It should also print `identity fn : OK`; versions
   1.1.1 and 1.1.2 answered "Character not loaded yet" to every purchase on ESX
   and QBCore, which is fixed since 1.1.3.
4. Edit `shared/config.lua` (framework, garage, theme, finance, business rules)
   — it stays open source in the escrowed build.
5. Dealerships are managed IN-GAME with `/dealerships` (server admins). Example
   stands are seeded on first boot and can be edited or deleted from the panel.
6. Optional: adjust the default catalog in `shared/vehicles.lua` before the
   first boot, or manage/import it in-game from the admin panel.

## Importing your addon vehicles

`tools/` ships a scanner you can drop **inside a vehicle stream resource**:

- Windows: run `apex_vehicle_import.bat`
- Linux: run `apex_vehicle_import.sh` (requires Python 3)

It reads `vehicles.meta` / `handling.meta`, works out which vehicles are addons
and which replace base-game models, guesses category and price, and writes a
`vehicles.lua` next to itself. The admin panel (`/dealerships` → Import) detects
that file and imports it with one click. An optional AI pass (free Groq API key)
can fill in proper display names, brands, categories and realistic prices.

## Commands

- `/myfinance` — personal financing overview, pay installments or pay off.
- `/directsale` — employees: open the direct-sale showroom near their stand.
- `/dealerships` — server admins: stands, listings, catalog and import panel.
- Admins (ace `command` by default, see `Config.adminAce`) also get the
  Catalog tab plus stock/self-hire powers inside any management panel.

## Public exports

Server (`exports['apex_dealerships']`):
```lua
:GetDealershipBalance(dealershipId)
:AddDealershipMoney(dealershipId, amount)
:RemoveDealershipMoney(dealershipId, amount)   -- funds-guarded, returns false if it cannot cover
:IsEmployee(src, dealershipId, permission)
:GetVehiclePrice(dealershipId, model)
:GetCatalog()
:CountFinancedVehicles(identifier)
```

Client (`exports['apex_dealerships']`):
```lua
:OpenShowroom(dealershipId)
:OpenManagement(dealershipId)
:IsShowroomOpen()
:IsTestDriving()
```

## Integration hooks (`shared/integrations.lua`, open source)

- `Integrations.PurchasePreCheck(src, data)` — return `false` to block.
- `Integrations.OnVehiclePurchased(data)` — garage script integration point.
- `Integrations.OnVehicleRepossessed(data)`.
- `Integrations.Notify / GiveKeys / SetFuel` — swap in your own providers.
