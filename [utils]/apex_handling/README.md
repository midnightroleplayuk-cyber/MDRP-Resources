# Apex Handling Studio (`apex_handling`)

The most complete in-game handling editor for FiveM. Tune a car's physics
live, feel it instantly, and when you are happy **write the tune straight
into the vehicle resource's own `handling.meta`** so it is permanent,
survives restarts and travels with the car to any other server.

Works with **ESX Legacy, QBCore, QBox and standalone**. No database, no
setup, no dependencies.

---

## Install (plug and play)

1. Drop `apex_handling` into `resources/[RecordKit]` (or any folder your
   `server.cfg` starts).
2. Add to `server.cfg`, **after** your framework:
   ```cfg
   ensure apex_handling
   ```
3. Give yourself access. Any one of these is enough:
   ```cfg
   # ESX / QBox / txAdmin / manual
   add_ace group.admin apex.handling allow

   # QBCore keeps its admins under a different principal tree
   add_ace qbcore.admin apex.handling allow
   add_ace qbcore.god   apex.handling allow
   ```
   Or be in a group listed in `Config.access.fullGroups`, or set
   `Config.access.everyone = true` on a dev server.
4. To let the studio write into a vehicle's files, grant it permission for
   that resource:
   ```cfg
   add_filesystem_permission apex_handling write my_car_resource
   ```

Sit in a car and type **`/handling`**.

## The tabs

| Tab | What it does |
|-----|--------------|
| **Simple** | 10 friendly sliders (top speed, acceleration, braking, grip, drift, suspension, height, weight, downforce, cornering) with a typeable value box on each. Ideal for mechanics and for rescuing a badly made addon car. |
| **Advanced** | Every `CHandlingData` field, grouped by category, with sliders, drag-to-scrub numeric inputs, per-field reset and live search. Values are always shown exactly as they appear in `handling.meta`: degrees, km/h, bias 0-1. |
| **Flags** | `strModelFlags`, `strHandlingFlags`, `strDamageFlags` and `strAdvancedFlags` as named checkboxes with tooltips and a live hex readout. |
| **Performance** | A radar chart of the tune against the car's factory values, plus the peaks from your last drive (top speed, lateral and longitudinal G, RPM, wheel slip) with a speed graph and a per-vehicle history you can open. |
| **Timing** | 0-100 / 0-200 / quarter mile with trap speed, and 100-0 braking distance. Re-arms by itself: just come to a stop. Standalone HUD via `/handlingtiming`, job-lockable in the config. |
| **Presets** | 12 complete tunes: Street, Sport RWD, Supercar, Hypercar AWD, Drift, Rally, Drag, Track GT3, Muscle, Truck, Sport Bike, F1. |
| **Profiles** | Save and load named tunes (plain JSON store) plus share codes (`APEXH2:...`) you can paste into Discord. |
| **XML** | Live `handling.meta` preview with syntax highlighting, copy, export to `exports/<model>_handling.meta`, or write in place into the vehicle's own resource. A backup is kept as `handling.meta.apexbak`, and one click restores it. |

## How applying works (three layers)

1. **Live.** Every edit applies instantly to your vehicle and is synced to
   every other player through the entity statebag, so everyone simulates
   the same physics.
2. **Server override.** *Save on server* persists the tune per model in
   `data/overrides.json`. Every spawn of that model picks it up, even
   after a restart.
3. **File write.** *Write to vehicle file* finds the `handling.meta` that
   defines the model (including addons whose `handlingId` differs from the
   model name) and rewrites only the matching `<Item type="CHandlingData">`
   block, leaving the rest of the file byte for byte intact. Restart the
   vehicle resource and the game itself loads your tune. Zip the folder and
   whoever you send it to gets the car with your handling.

## Access levels

- **FULL** (aces, groups or jobs in `Config.access`): everything.
- **SIMPLE** (`Config.access.simpleJobs`, `mechanic` by default): the
  simplified editor, performance, timing, presets and profiles only. No
  flags, no file writes, no server overrides.

Access is re-checked on the server for every action, never trusted from
the client.

## Commands

| Command | Who | What |
|---------|-----|------|
| `/handling` | studio access | Open or close the studio (must be the driver) |
| `/handlingtiming` | configurable | Standalone timing HUD, no menu |
| `/handlingfix` | studio access | Panic button: restore factory handling on the car you are in |
| `/handlingrescan` | full access / console | Rebuild the `handling.meta` index |
| `/handlingdebug` | anyone | Print a diagnosis to F8: seat, access level, model name, the values read live off the car, and whether its `handling.meta` was located |

## Troubleshooting

**"Write to vehicle file" looks greyed out / does nothing.**
It needs the car's `handling.meta` to actually be on the server. Open the
**XML** tab: the status line says whether the file was found and, if not,
exactly what was searched. Press **Rescan files** there (or click the write
button, which rescans by itself) after starting the vehicle resource. If it
is found and the write still fails, the server needs write permission:

```cfg
add_filesystem_permission apex_handling write my_car_resource
```

Addon cars whose spawn name is not their `handlingName` (model
`vendor-mycar`, handling `MYCAR`) are resolved through `vehicles.meta`, and
failing that by ignoring case and separators.

**A slider moves but the car does not change.**
Run `/handlingdebug`. The usual causes are: you are not in the driver seat
(`Config.mustBeDriver`), the studio is still open on a car you have left, or
the value was refused as implausible, which the studio now says out loud in
a toast instead of ignoring silently. Note that a few fields (gear *ratios*,
advanced flags, `AIHandling`) genuinely cannot change on a car that is
already spawned: they need a respawn or a file write, and the field's
tooltip says so.

## Exports

```lua
exports.apex_handling:OpenHandlingStudio()
exports.apex_handling:CloseHandlingStudio()
exports.apex_handling:IsHandlingStudioOpen()
exports.apex_handling:ApplyHandlingFields(vehicle, fields)  -- handling.meta values
exports.apex_handling:ReadHandling(vehicle)                 -- handling.meta values
exports.apex_handling:ToggleTimingHud()
```

Perfect for a mechanic job: call `OpenHandlingStudio()` from your tuning
bench target.

## Languages

Ships in **English, Português, Español, Français, Deutsch and Italiano**.
One setting drives everything, the notifications, the whole interface and
the tutorial:

```lua
Config.locale = 'en'
```

To add your own, copy `locales/en.lua`, translate the values, rename the
table (`Locales.xx`) and point `Config.locale` at it. Anything you leave
untranslated falls back to English key by key, so a partial file is safe.

## Files and persistence

```
data/profiles.json    player-saved tunes
data/overrides.json   per-model server overrides (and stock snapshots)
data/stocks.json      factory values used by Reset to stock
exports/              .meta files you export
```

No database, no SQL, nothing to install. Back them up by copying the
folder.

## Config highlights (`shared/config.lua`)

- `Config.locale` language for everything
- `Config.command` / `Config.timingCommand` / `Config.keybind`
- `Config.access` aces, groups, jobs and simple-only jobs
- `Config.timing` who may use the standalone timing tool
- `Config.metaWrite` enable file writing, backups, scan on boot
- `Config.sync` statebag key and model override behaviour
