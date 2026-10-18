# BS Prop Placer — Installation & Configuration

Made by **British Scripts** · Bradadorez & SwiftlyChillin

---

## 1. Install the resource

The UK sign models are **bundled inside this resource** (in the `stream/` folder), so
there is just one folder to install — no separate sign pack.

1. Copy the `bs-propplacer` folder into your server's `resources` directory.

> ⚠️ **If you previously ran the standalone `meshy_ai_*` sign packs, remove them from
> `server.cfg`.** The models now live inside `bs-propplacer` — running both would define
> the same archetypes twice and throw duplicate-ITYP warnings.

## 2. Set up `server.cfg`

```cfg
ensure bs-propplacer
add_ace group.admin propplacer.admin allow   # lets admins use /clearprops
```

Start (or restart) the server. On boot it prints the detected framework, e.g.
`[bs-propplacer] Framework: qbox`. If a sign in the menu doesn't appear in-game, its
`model` in `config.lua` doesn't match a bundled archetype — see **Troubleshooting**.

---

## 3. Configuration (`config.lua`)

Everything is in `config.lua`. The most common things you'll touch:

| Setting | What it does |
|---|---|
| `Config.Framework` | `'auto'` detects QBCore/Qbox/ESX. Force with `'qbcore'`, `'qbox'`, `'esx'`. |
| `Config.OpenCommand` / `Config.OpenKey` | Command (`/signs`) and keybind (`F7`) to open the menu. Set the key to `false` to disable it. |
| `Config.Jobs` | Jobs allowed to place/remove signs. **Empty `{}` = everyone.** |
| `Config.RequireDuty` | Require on-duty (QBCore/Qbox only). |
| `Config.MaxPropsPerPlayer` | Anti-spam cap per player. |
| `Config.AutoDelete` | `enabled`, `minutes` — auto-remove old signs. Set `enabled = false` to keep signs until picked up. |
| `Config.Pickup` | `key` (E), `radius`, marker toggle. |
| `Config.RoadClosure` | See section 4 below. |
| `Config.Admin` | `/clearprops` command name, ACE permission, fallback admin groups. |
| `Config.Props` | The sign catalogue (section 5 below). |

### Changing allowed jobs

```lua
Config.Jobs = { 'police', 'ambulance', 'fire', 'highway' }  -- add any job
Config.Jobs = {}                                            -- allow everyone
```

---

## 4. Road closure & traffic control

Any sign with `closeRoad = true` (in `Config.Props`) will **disable the NPC vehicle path
nodes** around it, so AI traffic stops driving through. Out of the box: **No Entry**,
**No Motor Vehicles**, **Stop** and **Road Works** close the road.

```lua
Config.RoadClosure = {
    enabled          = true,
    radius           = 30.0,   -- metres around the sign (override per sign with `radius`)
    disablePeds      = false,  -- also stop pedestrians walking through
    reassertInterval = 5000,   -- ms; keeps the closure active as the area streams in/out
    despawnVehicles  = false,  -- ⚠️ actively DELETE AI cars that enter (off by default)
    despawnInterval  = 1000,
}
```

- **`despawnVehicles`** is the heavy-handed option for busy junctions — it deletes
  *driverless AI* vehicles inside the radius to stop pile-ups. It **never** touches a
  vehicle with a real player in it. Leave it `false` unless you need it.
- Closures are restored automatically when the sign is picked up, auto-deleted, or
  cleared by an admin — traffic returns to normal.
- **Performance:** the closure manager only runs while at least one closure sign exists.
  No signs out = the loop stops entirely = 0.00ms.

To make any sign close the road, add `closeRoad = true` to its line (optionally `radius = 40.0`).

---

## 5. Editing the sign catalogue

Each sign is one line in `Config.Props`:

```lua
{ model = 'no_motor_vehicles', label = 'No Motor Vehicles',
  category = 'Prohibitory', image = '16_no-motor-vehicles.png', closeRoad = true },
```

- **`model`** – exact archetype/`.ydr` name to spawn (must be streamed by your sign pack).
- **`label`** – name shown in the menu.
- **`category`** – one of `Config.Categories` (drives the tabs).
- **`image`** – thumbnail in `html/img/`. Missing/typo'd images fall back to `_placeholder.svg`.
- **`closeRoad`** *(optional)* – `true` to close the road (disables NPC path nodes nearby).
- **`speedZone`** *(optional)* – a number (mph by default — see `Config.SpeedZone.units`) that caps NPC vehicles near the sign to that speed. Already set on the 30/40/60 signs.
- **`radius`** *(optional)* – per-sign zone radius (closure **or** speed). Either can also be sized live while placing with **Arrow Up/Down** (red disc = closure, blue disc = speed zone).
- **`zOffset`** *(optional)* – nudge the sign up/down if it floats or sinks.

All models use clean archetype names (e.g. `no_overtaking`, `speed_30`, `traffic_cone`), so
labels and thumbnails line up out of the box. Prune anything you don't want to sell, or add a
new sign by dropping in one more line.

**Swap in your own thumbnails:** drop a PNG into `html/img/` and point `image` at it.

---

## 6. Troubleshooting

| Problem | Fix |
|---|---|
| **Sign doesn't spawn / invisible** | The `model` name doesn't match a bundled archetype. Confirm the `.ydr` exists in `stream/` and its name matches `model` exactly (open it in CodeWalker if unsure). |
| **Sign floats / sinks into the road** | Add `zOffset = 0.2` (up) or `-0.2` (down) to that prop, or set a global `Config.Placement.zOffset`. |
| **"Failed to load that sign model"** | The model isn't in the game files — the stream pack isn't running, or the name is wrong. |
| **Menu won't open** | Your job isn't in `Config.Jobs`, or (QBCore/Qbox) `RequireDuty` is on and you're off duty. |
| **Framework says standalone** | Auto-detect ran before your core started. Set `Config.Framework` explicitly. |
| **`/clearprops` says no permission** | Add `add_ace group.admin propplacer.admin allow` to `server.cfg`, or add your group to `Config.Admin.frameworkGroups`. |
| **NPC traffic drives into / through a sign** | Only `closeRoad` signs affect traffic (No Motor Vehicles, Stop, Barrier, Road Ahead Closed, cones). They **halt** ambient cars by default (`haltTraffic`); widen `radius`, or to remove cars entirely enable despawn (per-sign **[G]** while placing, or `despawnVehicles = true`). |
| **NPC cars don't slow at a speed sign** | Confirm the sign has a `speedZone` value and `Config.SpeedZone.enabled = true`; widen the radius. Players aren't slowed unless `affectPlayers = true`. |
| **An NPC stayed slow after leaving** | They uncap when they re-enter range of a player; `releaseSpeed` is the uncap value. |

---

## 7. How it works (for the curious)

- The **server** owns every placed sign as a networked entity, so sync is automatic and
  there's one trusted place to validate placements (job, model whitelist, caps, distance)
  and to delete them. Nothing persists across a restart — by design.
- The **client** only drives the ghost preview and reports the final position; it never
  spawns the real sign itself, so a modded client can't place arbitrary models.
- **Traffic control** is client-side (path nodes are a local AI concept), driven by the
  list of closure zones the server broadcasts.

Enjoy! — **British Scripts**
