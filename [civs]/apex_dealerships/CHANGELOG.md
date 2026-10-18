# Changelog

All notable changes to **apex_dealerships**.

## [1.1.3]

### Fixed
- **Buying failed on ESX and QBCore with "Character not loaded yet"** (and the
  showroom showed $0), with no error in any console. The framework bridge
  refused the core's own `GetPlayerFromId` / `Functions.GetPlayer` because a
  function that comes from another resource arrives as a callable table, not a
  Lua `function`. Only QBox worked. The bridge now accepts both. The same check
  also skipped job lookups on the client and ESX's vehicle-properties
  serializer.
- `dealerdiag` now prints `identity fn : OK` (or `MISSING`), so this can be
  checked in one command.

## [1.1.2]

### Fixed
- **Buying failed on QBCore/QBox when the resource was ensured before the
  framework.** The framework was detected once at start, and a core that had
  not started yet made it fall back to ESX: every purchase answered "Character
  not loaded yet" and the showroom showed $0. An installed core now wins over
  that guess, and the server waits for it before touching the database.
  `dealerdiag` prints `GUESS` if no core was running.
- **Test drives had no keys**, so key scripts (qb-vehiclekeys and others) made
  the driver hotwire the car. The test car now gets keys for the plate it is
  wearing, starts with the engine on, and the key is revoked when the drive ends
  (for key scripts that support revoking).
- Plates sent to key scripts kept their inner spaces stripped (`APEX TD` became
  `APEXTD`). They are now only trimmed, like the key scripts read them.

## [1.0.0] — Initial release

### Dealerships
- Dealerships are created **in-game** from `/dealerships` (admin panel with a live
  Leaflet map) — no config-file editing, no restart.
- **Three domains per stand**: land, air and sea, each with its own showroom,
  3D preview spot, delivery bay and test-drive rules.
- Self-service stands and **owned** (job-run) stands with employees, roles,
  treasury, commission and per-stand pricing.
- **Showcase vehicles**: place cars on the showroom floor from the admin panel
  with an in-world ghost placer.
- Custom **categories** and reusable **listings** (a hand-picked vehicle set a
  stand can sell instead of whole categories).
- Server-wide **theme** (brand + background colour) applied to every player's UI.

### Buying
- Live 3D showroom with an orbit camera, paint picker and full vehicle stats.
- Cash / bank / society payment, **amortized financing** (interest on the
  outstanding balance, early payoff on principal), coupons, and employee-driven
  **direct sales** with customer consent.
- Test drives in a private routing bucket, with an optional deposit.
- Vehicle buy-back at stands that enable it.

### Stock
- Unlimited or **stocked** stands.
- **Trucking missions**: ordered stock arrives at the docks and must be fetched
  with a truck and trailer, then unloaded at the stand.
- Bulk stock tools in the admin panel: set / add / remove / randomise across
  every vehicle a stand sells.

### Tooling
- Vehicle **importer** for Windows (`tools/apex_vehicle_import.bat`) and Linux
  (`tools/apex_vehicle_import.sh`): scans an addon vehicle resource and produces
  an import file the admin panel reads. Optional free AI pass fills in names,
  brands, categories and prices.
- Bulk catalog import from QBCore / QBox / ESX vehicle data.

### Compatibility
- ESX Legacy, QBCore and QBox, auto-detected (pin it with `Config.framework`).
- Vehicles are saved with the correct type per domain, so aircraft and boats
  show up in hangars and marinas rather than in the car garage.
- Society funds via qb-banking, qb-management, okokBanking, Renewed-Banking or
  esx_addonaccount; falls back to an internal wallet and warns at boot.

### Performance
- Showcase vehicles and dealership peds are **streamed by distance** — nothing
  exists on the map until a player is near it.
- The proximity loop sleeps at a rate that scales with the distance to the
  nearest stand, and the world prompt only sends a UI message when it actually
  moves. Idle cost is effectively zero.
