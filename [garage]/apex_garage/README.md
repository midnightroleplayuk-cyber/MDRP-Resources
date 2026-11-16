# Apex Garage

Server-authoritative vehicle garage for **ESX Legacy / QBCore / QBox**, built in the
Apex design language (the same flat blue `#1F5EFF` system as `apex_dealerships`
and `apex_bossmenu`).

Original, clean-room implementation — no third-party garage code is used.

## Features

- **Garages that work out of the box.** Twelve locations ship in
  `shared/config.lua` — Legion Square (five bays), San Andreas Ave, the beach,
  the airport, The Motor Hotel, Sandy Shores, Paleto Bay, the LSIA hangar, the
  LSYMC boathouse, a police garage, an EMS spawner garage and the city impound
  lot — on the classic public parking lots, so every spawn slot is a real
  parking space. Live on first boot.
- **In-game garage creator** (`/apexgarage`, admins): build garages in the world
  with a **laser placer** — you walk freely and a ray from the camera picks the
  point. The interaction **zone** can be drawn two ways:
  - **Polygon** — walk the perimeter and drop 3+ corners (`E` adds, `ENTER`
    finishes, `BACKSPACE` undoes); the enclosed area becomes the zone.
  - **Circle** — a single point with a scroll-adjustable radius.

  Then place one or more **spawn points** with a ghost vehicle (scroll rotates).
  Public, job, gang, impound or private — no config editing required. Garages
  built in-game live in the database and are layered on top of the config ones.
- **Garage types**: public/personal, **job** (society-owned vehicles from the DB,
  or a fixed spawner list), **gang**, **impound**, and **private garages** —
  including one **for a single specific player**.
- **Job / company garages**: pick specific vehicles, infinite take-out or limited
  by stock, and the **job boss** manages the vehicle list + stock in-game
  (`/jobgarage`).
- **Persistent world parking** (`/park`) — see its own section below.
- **Impound** — see its own section below.
- **Vehicle preview**: selecting a car spawns a local-only copy at the garage's
  spawn slot, seats you in it and orbits a turntable camera around it. The player
  is moved into a private routing bucket so nobody else sees them floating.
- **Store / take out** with full persistence: mods/props, fuel, engine & body
  health, and door/window/tyre damage.
- **Anti-dupe**: a vehicle already out in the world can't be pulled again
  (`Config.allowInfiniteSpawns` and its job/gang variants lift the lock).
- **Left-out recovery**: a car abandoned in the world (or lost on restart) is
  reclaimed from the garage for a configurable towing fee.
- **Transfers**: move a car between your garages (fee) or hand it to a nearby
  online player.
- **Instant sell** straight from the garage, at a percentage of the
  `apex_dealerships` catalog price (inert without that resource — there is no
  price to quote otherwise).
- **Financing badge**: if `apex_dealerships` is installed, a vehicle still being
  paid off shows "being financed" plus the remaining balance.
- **Mileage (km)** tracked per vehicle and shown in the list and detail views.
- **Nicknames**, class filtering (car / air / sea), search, live money balance.
- **In-game theme editor** — `/apexgarage` → **Appearance**. Two colours drive
  the whole palette, previewed live on the running interface as you drag; on save
  it is stored server-side and pushed to every connected player. Presets and
  swatches included. `Config.theme` is only the starting default.
- **Discord webhooks** — see its own section below.
- **Blips** and an in-script **TextUI prompt** (no dependency), or **ox_target**.
  `Config.textui` can hand the prompt to ox_lib / qb-core / okokTextUI /
  esx_textui instead, or disable it entirely, and sets the built-in one's
  position (right / left / top / bottom). Interaction is hold-to-open by default.
- **Five languages** shipped in `locales/`: `en`, `pt`, `es`, `fr`, `de`.
  Set `Config.locale`. Every file is plain Lua and open source — edit or add one.
- **Multi-framework**: ESX Legacy, QBCore and QBox, auto-detected, along with
  money / fuel / vehicle-key integrations.

## Install

1. Drop `apex_garage` into your `resources` folder.
2. Ensure it **after** `oxmysql`, `ox_lib` and your framework:
   ```
   ensure oxmysql
   ensure ox_lib
   ensure es_extended       # or qb-core / qbx_core
   ensure apex_garage
   ```
   Since 1.1.3 a resource started before the framework waits for it instead of
   guessing ESX. If `garagediag` in the server console prints `GUESS`, fix the
   ensure order or set `Config.framework`. It should also print
   `identity fn : OK`; before 1.1.4 the bridge could not read the player from
   ESX or QBCore, and every garage answered "Invalid.". 1.1.3 and 1.1.4 also
   failed every take-out with `integrations.lua:207: attempt to index a nil
   value (global 'os')` in the F8 console and **left the player invisible**
   (the ped is hidden for the hand-over and the crash skipped the reveal);
   the crash was fixed in 1.1.5, and since 1.1.8 an error anywhere in a
   take-out shows the ped again, deletes an unconfirmed car and hands the
   claim back, so no failure can strand a player any more. If you are on an
   older build and a player is stuck invisible, `restart apex_garage` or a
   relog restores them.
3. Grant the admin ace in your `server.cfg`, or nobody will be able to open the
   garage creator, the theme editor or the staff commands:
   ```
   add_ace group.admin apex_garage.admin allow
   ```
   The ace name is `Config.adminAce` — change it there if you use a different
   permission scheme.
4. The schema is created automatically on first boot. To install it by hand
   instead, run `sql/apex_garage.sql` against your database.
5. **Disable any other garage resource** (`esx_garage`, `qb-garages`,
   `jg-advancedgarages`, …) — two garages both managing
   `owned_vehicles.in_garage` will conflict.

> All existing owned vehicles are filed under `Config.defaultGarage` on first
> boot and appear immediately in every personal garage.

## Editing the shipped garages

The twelve default garages are plain Lua tables at the bottom of
`shared/config.lua` (`Config.garages`). Change the `access`, `store` and
`spawns` vectors there, then **restart the resource**:

```
restart apex_garage
```

That is the whole procedure. The file is read once, when the resource starts,
so `refresh` on its own changes nothing, and players do not need to reconnect —
the restart sends them the new file.

**"I changed the vectors and the points did not move."** Two things cause
that, and 1.1.7 lets you tell them apart in one look:

1. **The garage you are looking at was created in-game**, with `/apexgarage`.
   Those live in the database (`apex_garage_garages`), not in the config, and
   are moved by editing them in `/apexgarage` — never by a config change. The
   `/apexgarage` list now shows **both** kinds: a garage from the file carries a
   `config.lua` tag and has no edit/delete buttons (teleport still works); one
   created in-game has the editor as before.
2. **The server is loading a different copy of the resource** than the one you
   edited — typically a second `apex_garage` folder elsewhere under
   `resources/` (txAdmin warns about duplicates at boot), or an old `cache/`
   build on some Linux hosts. On every start the server console prints
   `[apex_garage] garages loaded: N from shared/config.lua, M created in-game —
   resource folder: <path>`: that path is the folder being read.

Two commands show what the **running** build actually holds, straight from
memory rather than from the file:

- `garagediag` in the **server console** (or `/garagediag` in F8 in-game) lists
  every garage with its source, its access point and its first spawn slot.
- `/garagewhere` in-game names the nearest garage, where it comes from and its
  coordinates on screen, and prints the full list to F8.

If `garagediag` prints the **old** coordinates after a real restart, the file
the server read is not the one you edited. If it prints the **new** ones and
the point on the map has not moved, the point belongs to a created garage.

## Persistent parking

A player parks the car they are driving **anywhere in the world** and it stays
there through restarts: the row is stored in `apex_garage_parked` and the vehicle
is re-created server-side on boot, so every player sees the same car in the same
place. While parked, the `owned_vehicles` row is flagged `in_garage = 0`, so the
car can never be pulled from a garage at the same time.

`/park` is one command with two meanings: **driving** → park the car;
**on foot** next to your own parked car → take it back into your garage.
`/unpark` takes the nearest parked car out of the parked state and hands you the
keys, leaving it exactly where it stands.

Configured under `Config.parking`:

- `mode` — `'public'` (everyone), `'job'` (only `Config.parking.jobs`), or
  `'permission'` (only identifiers granted in the admin panel). Admins always
  may, in every mode.
- `maxPerPlayer`, `overlapRadius`, `allowJobVehicles`, `blockInGarageZones`,
  `noCollision`, `exitDelay`.

Admins manage it live in `/apexgarage` → **Parking**: flip every setting above,
grant or revoke per-player permissions, and draw **no-parking zones** (circle or
polygon, same placer as the garages). Those overrides are stored in
`apex_garage_settings` and win over the config at boot.

### "I parked the car and after the restart it was gone" (fixed in 1.1.10)

Before 1.1.10 the cars re-created on boot could be deleted again by the server
itself: a vehicle created server-side with nobody near it is an *orphan*, and
the server's default is to delete orphans that are not relevant to any player.
At park time the owner is standing next to the car, so parking looked fine; on
a restart nobody is near any of them, so the whole lot vanished within a tick,
silently. Add-on bikes, boats and aircraft had a second problem: the server
guessed their vehicle type from a list of vanilla models and built the wrong
kind of entity.

Since 1.1.10 every parked car is created with `SetEntityOrphanMode(KeepEntity)`
and with the vehicle type the server recorded at park time (new column
`apex_garage_parked.vtype`, added on boot or by `sql/apex_garage.sql`), and a
**watchdog** checks every 30 s that each parked row still has its car in the
world, re-creating whatever is missing — an admin `/dv`, a cleanup script or an
old server build can no longer make a parked car disappear for good. The boot
prints one line you can check after a restart:

```
[apex_garage] parking: restored 3 of 3 parked vehicle(s) (typed spawn: yes, keep-alive: yes)
```

`keep-alive: NO` means the FXServer artifact is too old to have
`SetEntityOrphanMode`; the watchdog still brings the cars back every 30 s, but
update the artifact so they never leave in the first place. The watchdog logs
`re-created N parked vehicle(s) that had vanished from the world` whenever it
has to act, so a server that keeps deleting them is visible in the console.

## Impound

Officers run `/iv` to impound the nearest vehicle and fill in a reason, a
**retrievable** toggle, a **time** (from `Config.impoundTimeOptions`, `0` meaning
officer discretion) and a **fee**. Owners see their impounded vehicles and
recover them by paying the fee — `Config.impoundAccount` decides whether that
comes from `bank`, `cash` or `any`. A non-retrievable impound cannot be bought
back at all. Officers of the lot's job can **release** a vehicle straight back to
the owner's garage, or drive it out themselves; they are never charged. Fees can
be paid into a society account via `Config.impoundFeeSociety`.

## Discord webhooks

Configured in **`server/webhook_config.lua`**, not in `shared/config.lua` — a
shared script is downloaded by every connecting player, and a webhook URL is
effectively a password. Everything is off by default: set no URL and nothing is
ever sent.

Set `Config.webhooks.url` alone to send everything to one channel, or give any
category its own URL to split it out. Categories: `garage`, `security`,
`economy`, `impound`, `parking`, `admin`, `garage-admin`, `private`. Each has an
`enabled` switch so a category can be silenced even while the global URL is set.
Giving `security`, `economy` and `admin` their own webhook is recommended —
`garage` and `parking` are high volume and can otherwise crowd them out of
Discord's rate limit.

## Configuration

Everything an owner is expected to touch lives in `shared/config.lua`, heavily
commented (plus `server/webhook_config.lua` for the Discord URLs):

- `Config.garages` — the static locations. `type` is the access model
  (`public` / `job` / `gang` / `impound`), `class` is the vehicle class it
  accepts (`car` / `air` / `sea`), `radius` (optional) widens the prompt zone
  for that one garage. See "Editing the shipped garages" above.
- `Config.useConfigGarages` — `true` (default) uses `Config.garages` alongside
  the garages you create in-game. Set it to `false` only once you have built your
  own in the panel, **including an impound lot**; with it off `Config.garages` is
  ignored everywhere.
- `Config.adminAce` — the ace that gates the admin panel and staff commands.
- Job/gang garages: `vehiclesType = 'personal'` (the default, "Personal" in the
  editor: a garage only members of the job can open, holding their **own**
  vehicles — a police helipad for officers' helicopters, for example),
  `'owned'` ("Company": society vehicles in the DB flagged `job_vehicle` /
  `gang_vehicle` and filed under the job name, filtered by rank) or `'spawner'`
  ("List": a fixed `vehicles` list, not persisted). Before 1.1.9 a "Personal"
  job garage stored a member's vehicle but never listed it back.
- Economy: `returnCost`, `transferGarageCost`, `enablePlayerTransfer`,
  `instantSell`, …
- `Config.uniqueGarages` — `false` (default) shows all your vehicles at every
  personal garage; `true` ties a vehicle to the garage it was stored in.
- `Config.useTarget` — swap the keypress prompt for ox_target zones.
- `Config.theme` — three brand colours the UI derives the rest from (the in-game
  theme editor overrides this once used).
- `Config.occupantGuard` — see below.

### Nobody vanishes with the car

Storing a vehicle, recovering one that was left out in the world, impounding one
and `/park` all destroy a vehicle entity. `Config.occupantGuard` (on by default)
refuses any of them while another **player** is sitting in the car, instead of
deleting them along with it:

| Action | Blocked when | The player is told |
|---|---|---|
| Store at a garage | a passenger is aboard | `n_occupied` |
| `/park` | a passenger is aboard | `e_occupied` |
| Recover & drive | anyone is aboard, anywhere on the map | `e_occupied`, on the button as well as the toast |
| `/iv` impound | anyone is aboard, the officer included | `n_occupied_impound` |

NPC passengers never block anything — a pedestrian who wandered into a seat
would otherwise make a car permanently unstorable. Each action can be switched
off on its own (`store` / `recover` / `impound`), or the whole guard with
`enabled = false`, which restores the pre-1.1.0 delete-anyway behaviour.

## Commands

| Command | Who | Purpose |
|---|---|---|
| `/park` | everyone (see `Config.parking.mode`) | driving: park where you stand, permanently. On foot: store your parked car back in the garage |
| `/unpark` | owner | take your nearest parked car out of the parked state and drive it away |
| `/iv` | officers of the impound lot's job / admins | impound the nearest vehicle |
| `/privategarages` | `realestate` job / admins | quick private garage menu |
| `/apexgarage` | admins | garage creator, parking settings, no-parking zones, theme editor |
| `/jobgarage` | job boss | manage the company garage vehicles + stock |
| `/vreturn <plate>` | admins | force a vehicle back into its garage |
| `/vplate <old> <new>` | admins | change a vehicle's plate |
| `/dvdb <plate>` | admins | delete a vehicle from the database |
| `/garagewhere` | everyone | nearest garage, where it comes from (config file / `/apexgarage`) and its coordinates; full list in F8 |
| `garagediag` | server console (also `/garagediag` in F8) | framework bridge diagnostic plus every loaded garage with its source and coordinates |

Every command name is configurable in `Config.commands`. Admin commands are
gated on `Config.adminAce`.

## Exports

**Server**
```lua
exports.apex_garage:IsVehicleOut(plate)                 -- bool
exports.apex_garage:GetVehicleGarage(plate)             -- garage id
exports.apex_garage:ReturnVehicleToGarage(plate, id?)   -- bool
exports.apex_garage:ImpoundVehicle(plate, reason, fee, retrievable, hours, owner?, garageId?)
exports.apex_garage:GetOpenImpounds(identifier)         -- rows
exports.apex_garage:IsPrivateGarage(id)                 -- bool
exports.apex_garage:RegisterVehicleOutside(plate, netId)
exports.apex_garage:MarkVehicleStored(plate)
exports.apex_garage:GetConfiguredGarages()
exports.apex_garage:GetParkedVehicles(identifier)       -- rows
exports.apex_garage:IsPlateParked(plate)                -- bool
exports.apex_garage:GetTheme()
```

**Client**
```lua
exports.apex_garage:OpenGarage(id)
exports.apex_garage:StoreVehicle(id)
exports.apex_garage:IsGarageOpen()
exports.apex_garage:ParkVehicle()
exports.apex_garage:UnparkVehicle(plate?)
exports.apex_garage:ReleaseVehicle(plate?)
exports.apex_garage:GetTheme()
```

**Integration events** (housing, jobs, …)
```lua
TriggerEvent('apex_garage:client:open',  garageId)
TriggerEvent('apex_garage:client:store', garageId)
TriggerEvent('apex_garage:client:impound')
```

Post-action server hooks live in `shared/integrations.lua`
(`OnVehicleStored`, `OnVehicleTakenOut`, `OnVehicleImpounded`, and a
`GetGang` resolver to enable gang garages on ESX).

## Licence

See `LICENSE`. `shared/`, `locales/`, `html/`, `sql/` and
`server/webhook_config.lua` stay open source in the escrowed build so you can
configure, restyle and translate the resource.

---
© Apex Scriptz — v1.0.0
