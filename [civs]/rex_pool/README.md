# Rex Pool — Synced billiards with real physics

**Rex Studio** · https://rex-studio.com · Store: https://store.rex-studio.com

8-ball, 9-ball, straight pool (14.1) and free table, on every vanilla pool table of the map and any table
you place yourself. One deterministic physics engine runs on the server and on every client, so every
player and every spectator sees exactly the same shot.

Frameworks: **ESX** (new `getSharedObject` export) · **QBCore** · **QBox** · **standalone** (no money).
Targets: **ox_target** · **qb-target** · or the built-in **[E] prompt + marker**.

---

## QUICK-START

1. Drop the `rex_pool` folder in your `resources` folder.
2. `server.cfg` (order matters):

```cfg
set onesync on                 # OneSync is required (legacy or infinity)
ensure ox_lib
ensure oxmysql                 # optional, only for stats / leaderboard
# ensure ox_target             # optional (or qb-target)
ensure rex_pool

add_ace group.admin rexpool.admin allow
```

3. Restart the server. The SQL tables are created automatically on start (`install/rex_pool.sql` is there
   if you prefer to import by hand).
4. In game, go to a pool table, open the table menu (target or **[E]**), pick a mode, **Open the table**,
   let a second player join (or pick **Free Table** to play alone) and **Rack ’em up**.

**Updating:** replace the folder, then in the server console run `refresh` and then `ensure rex_pool` (or restart
the server). Updates can add new files to `fxmanifest.lua`; a plain `restart rex_pool` without `refresh` keeps the
old file list and you get errors such as `attempt to index a nil value (global 'LocalView')`. Keep your
`config.lua` / `data/calibration.json` if you changed them.

No oxmysql? Set `Config.Stats.enabled = false` and remove the `'@oxmysql/lib/MySQL.lua'` line from
`fxmanifest.lua`.

### Testing without walking to a bar

```
/poolspawn                      spawns a prop_pooltable_02 in front of you (admin)
/poolspawn prop_pooltable_3b    same with the other model
/pooldespawn                    removes the closest spawned table
```

### Vanilla tables to try first

| Place | Model | Coords | Notes |
|---|---|---|---|
| Yellow Jack Inn, Sandy Shores | `prop_pooltable_02` | `vec3(1992.80, 3047.31, 46.23)` heading 136.7 | community-verified prop origin |
| Vinewood Hills mansions (`ch2_06` map area) | `prop_pooltable_02` | run `/poolscan` there | the model is placed 3× in the vanilla map files of this area (exact coords not listed) |
| Casino penthouse (DLC interior) | depends on entity set | ~`vec3(976.6, 66.0, 116.2)` **(est.)** | only if your penthouse loads a pool table |

Coordinates marked **(est.)** are estimates. Stand anywhere and run **`/poolscan`**: it prints every
supported table prop around you with its exact coords and heading in the F8 console (copy/paste ready for
`Config.Zones` / `Config.SpawnTables`). Any MLO that uses `prop_pooltable_02` or `prop_pooltable_3b` works
out of the box.

---

## Controls (Config.Controls)

| Key | Action |
|---|---|
| **E** | take your shot (when it is your turn) / open the table |
| **G** | table menu while playing |
| Mouse | aim · **SHIFT** fine aim |
| **LMB** hold + pull the mouse back, push to strike (`Config.PowerMode = 'drag'`) — or hold **SPACE**, release (`'hold'`) |
| Arrows | spin: top / back / left / right english · **R** reset spin |
| **C** | top-down camera |
| **Q** | cycle the called pocket (call pocket rule) |
| **ENTER** / LMB | place the cue ball (ball in hand) |
| **BACKSPACE** | stand up / stop spectating |

Commands: `/poolstats` leaderboard · `/poolleave` leave your table · `/pooladmin` admin panel (ACE) ·
`/poolscan` list tables · `/pooldebug` draw the physics geometry (rails, jaws, pockets, spots) on the closest table.

---

### Your own ped while aiming (`Config.Aim`)

In the aim camera, while placing the cue ball and in the top view, your own ped can fade **on your screen only**
so it never hides the cue ball: `HideLocalPed = 'auto'` (only when a body part is between the camera and the
ball or too close to the camera), `'always'` or `'never'`. `LocalPedAlpha = 51` (0 = fully invisible for you).
The cue stays visible as the aiming reference and only turns semi-transparent (`CueAlpha`) when its butt is
near the camera. Only client-side natives are used (`SetEntityLocallyInvisible`, `SetEntityAlpha` /
`ResetEntityAlpha`), never networked visibility, so other players always see you normally. Everything is
restored when you shoot, cancel, leave the table or the resource stops.

## How the sync works

* The shooter sends only the shot parameters (direction, power, spin, cue ball placement, called pocket).
* The server checks the state, the turn, the distance and the parameters, then runs the shot with the
  shared engine (`shared/physics.lua`) — chunked across ticks.
* The server sends `{ start snapshot, params, end checksum, end snapshot, rules outcome }` to everyone
  within `Config.SyncDistance` (players **and** spectators).
* Every client replays the shot locally at a fixed 400 Hz step, so it looks smooth at any FPS. The shooter
  starts instantly (no input lag) and attaches the server result when it lands.
* At rest each client compares its checksum with the server one. On a mismatch the balls glide to the
  authoritative snapshot (`/pooldebug` shows the drift counter). Respots and re-racks always come from the server.
* Ball props are local (non-networked) objects: no entity spam, no network owner fights.

Determinism: fixed timestep, only `+ - * /` and `sqrt` inside the simulation, every value snapped to a
2^-20 grid each step, balls iterated in a fixed order, integer LCG for the racks.

## Physics

Balls have linear and angular velocity. Sliding friction acts on the contact-point slip and turns slide
into roll, which is where follow and draw come from after a hit. Rolling resistance, side-spin decay,
ball/ball impulses with restitution, cushions with restitution and english that bends the rebound, pocket
jaws and real mouths. All constants are in `Config.Physics` (identical on server and clients — do not
change them per client).

## Rules engine (per match, can be turned off)

* **8-ball**: open table, groups on the first legal pot, wrong ball first, no cushion after contact,
  scratch, 8 early / with a scratch / in the wrong pocket = loss, 8 on the break respotted (or win, config),
  scratch on the break = ball in hand behind the head string.
* **9-ball**: lowest ball first, any legal pot continues, 9 on a legal shot wins (combos too), 9 on a foul is respotted.
* **Straight pool**: one point per legal ball, fouls −1, optional call shot, re-rack of 14 when one ball
  remains, target 15/25/50/100.
* **Free table / rules off**: anyone at the table can shoot, drop-in up to 4, scratch = ball in hand.
* Shot clock, 2v2 rotation, inactivity timeout, reset votes when money is at stake.

## Money

* **Table rental** paid by the host at start, per zone (`Config.Zones`) or default (`Config.Rental`),
  optionally credited to a job/society account (Renewed-Banking, qb-banking, qb-management, okokBanking,
  esx_addonaccount — edit `bridge/server.lua` for anything else).
* **Wagers**: every player's stake is held by the server until the end; winners share the pot minus
  `houseCut`. Cancel / reset vote / admin close / lobby timeout = refund. Disconnect = forfeit or refund
  (`Config.Wagers.onDisconnect`).

## Admin (`/pooladmin`, ACE `rexpool.admin`)

Live tables (go to, re-rack, close with refund, disable a table), economy settings saved in KVP (rental
on/off and multiplier, wagers on/off, max wager, house cut), match history, spawned tables.

## Exports

```lua
exports.rex_pool:GetSessions() -- server: list of active tables (views)
```

## Files you can edit (not encrypted)

`config.lua`, `locales/*.lua` (en, fr, es), `bridge/*.lua`, `install/*`, `data/calibration.json`, `html/*`.

## Things marked (est.) in the config

The table models ship with values calibrated in game on the Yellow Jack table (`prop_pooltable_02`:
2.75 x 1.59 m, cloth 0.895 m, centre offset -0.06 / 0.11; `prop_pooltable_3b` is the same mesh and uses the
same values unless you recalibrate it). `data/calibration.json` ships empty so these config values apply.
The hand offset of the cue and the cue tip direction are still estimates. Use `/pooldebug` on a table: the green lines must sit on the cushion noses and
the red dots in the pockets. If they don't, use `/poolcalibrate` (below) instead of guessing numbers.

## Calibrating tables (`/poolcalibrate`)

If the balls bounce before (or after) the visible cushions, or pockets feel too tight / too loose,
calibrate the table model in game. Needs the ACE `rexpool.admin` (with `Config.Debug = true` anyone can
open the tool to preview, but saving always needs the ACE):

```
add_ace group.admin rexpool.admin allow
```

1. Stand next to a pool table and type `/poolcalibrate` (type it again or press BACKSPACE to leave).
2. The physics geometry is drawn live on the table:
   - green lines = cushion noses (where the ball touches), blue rectangle = ball-centre limit (nose inset by the radius)
   - orange lines = pocket mouths, red numbered dots = pocket centres
   - transparent green plane = cloth height, white line = head string, blue dots = head / foot spot
   - red / green / blue axes = table centre (X = long axis), yellow dot = prop origin
   - white ghost spheres = the physics ball radius around each test ball (compare with the prop)
3. Tune with the keys shown in the side panel:

| Key | Action |
|---|---|
| ↑ / ↓ | select a value: length, width, cloth height, centre offset X / Y, corner mouth, side mouth, ball radius, long axis |
| ← / → | adjust (hold to repeat; on "long axis" it swaps X / Y) |
| X | step 1 cm → 5 mm → 1 mm (radius: 1 / 0.5 / 0.1 mm, mouths: 0.1 / 0.05 / 0.01 R) |
| R | rack a full set of balls |
| G | test shot type: long (foot rail), short (side rail), corner pocket, break |
| SPACE | fire the test shot: orange dots mark every rebound point for 6 s |
| ENTER | save for every player |
| DEL (twice) | back to the `config.lua` values for this model |
| BACKSPACE | exit (unsaved values are dropped) |

Until you save, the changes are a local preview only (your physics and render). Tip: fire the long and short
shots and adjust length / width until the orange rebound dots sit exactly on the cushion rubber, then the
corner shot for the mouths.

**Saving** sends the values to the server (ACE checked again), which writes `data/calibration.json`
(per model, plus the ball radius), applies it to the server physics, refreshes running tables and syncs every
client immediately, no restart. The file is loaded at every start and overrides `Config.TableModels`;
players who join later receive it automatically. A ready-to-paste `Config.TableModels` line is printed in F8
and in the server console if you prefer to keep the values in `config.lua` (then empty the file or press DEL).

`offsetX` / `offsetY` (model axes, metres) move the cloth centre relative to the prop origin, and
`cornerMouth` / `sideMouth` (in ball radii) can be set per model; both are optional in `Config.TableModels`.
`data/calibration.json` is not encrypted by escrow and must stay writable by the server.

## Interface

The NUI (`html/`) is not encrypted: colours are CSS variables at the top of `html/style.css`. Fonts are bundled
locally (`html/fonts`, Barlow Condensed + Inter, SIL Open Font License 1.1, licences included), no internet
request is made. The UI scales with the screen height (1280x720 to 4K). The lobby window has a fixed size:
options that do not apply to the selected mode stay in place, greyed out with the reason.

## Credits

Code, sounds (synthesised at runtime with Web Audio) and UI by Rex Studio. Uses GTA V vanilla props
(`prop_pooltable_02`, `prop_pooltable_3b`, `prop_poolball_1..15`, `prop_poolball_cue`, `prop_pool_cue`)
and vanilla animations only.
