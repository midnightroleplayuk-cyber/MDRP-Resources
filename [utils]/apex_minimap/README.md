# Apex Minimap Studio — `apex_minimap`

Design the GTA V minimap **in-game**: paint over the real map atlas, drop zone
highlights, text and logos, restyle everything with one-click themes, preview
it **live on your own radar while you edit**, push it to **every player with no
restart**, and export a **ready-to-ensure minimap resource**.

Built on the **Apex UI design system**: unhued neutrals with a single blue
accent that only ever means *state*, solid surfaces with inner light and
two-layer shadows, elevated buttons over recessed inputs, self-hosted Geist +
Geist Mono, and not one `backdrop-filter` anywhere (CEF composites it as
opaque black over a transparent NUI page). Latent-event transport, zero
database.

---

## Install

1. Drop `apex_minimap` into `resources/`.
2. `server.cfg`:
   ```cfg
   ensure apex_minimap
   add_ace group.admin apex.minimap allow
   add_principal identifier.license:YOUR_LICENSE group.admin
   ```
3. In game: `/minimapstudio` (configurable in `shared/config.lua`).

No database. Projects and the live minimap persist to JSON files in `data/`.

## Access — five methods, and they add up

Everything lives in `shared/config.lua` → `Config.access`, and is checked
**server-side every time** — opening the studio, saving, exporting, going
live, every blob transfer. The client is never trusted.

| # | Method | Gives access to | Default |
|---|---|---|---|
| 1 | `everyone` | anyone at all | off |
| 2 | `ace` | whoever holds the ace permission | **on** |
| 3 | `groups` | a framework role (admin, god, owner…) | off |
| 4 | `jobs` | a job, from a minimum grade | off |
| 5 | `identifiers` | a hand-picked list | off |

Each has its own switch and you can turn on as many as you like: someone
gets in as soon as the **first enabled method** says yes, so enabling one
never takes access away from anyone who already had it. All five work the
same on ESX Legacy, QBCore, QBox and standalone — the framework is only
consulted by `groups` and `jobs`, and `groups` also falls back to plain
aces, so it works with no framework at all.

> ⚠ An `add_ace` in `server.cfg` only takes effect when the cfg is read,
> i.e. at server **startup** — restarting the resource is not enough. This
> is by far the most common cause of "I'm admin and it says no access".
> To apply it right now, paste the two lines into the server console.

> ⚠ The `license:` prefix is not written twice.
> `add_principal identifier.license:c14af5… group.admin` is the correct
> line; `identifier.license:license:c14af5…` matches nobody.

**Locked out?** Run `/minimapstudio_access` in game. The server console
then prints every method with its verdict for you (`PASS` / `no`) and why,
plus all of your identifiers ready to paste into `identifiers.list`. Any
player can run it — it only reports about themselves. From the server
console: `minimapstudio_access <server id>`.

Configs written for the old `mode = 'ace' | 'jobs' | 'everyone'` format
keep working: they are **translated**, not ignored (`frameworkAdmin` turns
on `groups`, `aceOnly` turns off `acceptOwnerAces`, and so on). 35
automated cases cover the five methods across the three frameworks,
standalone, and every legacy form.

## What's in the studio

| Area | What it does |
| --- | --- |
| **Base maps** | Pick the starting map from the left rail — **Original, Color, Past Gen, Realistic, Realistic Dawn, Satellite** — each with its style-matched Cayo Perico island. Switching keeps your edits on top |
| **Atlas canvas** | The full map (6 tiles) with pan/zoom, tile boundaries, pixel grid and world-coordinate readout |
| **Tools** | Brush (normal/marker), eraser, flood fill, eyedropper, zone highlights (with labels), text (10 fonts), shapes (rect/ellipse/line/arrow), image/logo import (file, drag-drop or Ctrl+V) |
| **Themes** | One-click restyles — Noir, Midnight, Blueprint, Vintage, Emerald, Inferno, Toner — plus hue/saturation/brightness/contrast/tint fine-tuning |
| **Postals** | Draw postal codes on the map (import OCRP/Oulsen JSON/CSV, or auto-generate a grid), full text styling (font, size, outline, shadow, opacity) with per-code overrides, and an optional in-game `/gps` script bundled into the export |
| **Layers** | Every text/shape/zone/image is a movable, editable layer with visibility, lock, duplicate and reorder |
| **Live preview** | Your radar + pause map update while you paint (runtime textures, this client only) |
| **Live on Server** | Broadcasts the design to every player instantly, persists across restarts (`data/live.json`), auto-applies to late joiners |
| **Projects** | Save/load/rename/delete named projects (each remembers its base map), per player |
| **Export** | Stages the tiles; `tools/make_ytd.bat` builds a complete standalone minimap resource (with the Cayo `.gfx`, road-hiding `.ydd` files, and the `/gps` postals script if enabled) |
| **Appearance** | `/minimapstudiosettings` (or the sliders icon in the rail) — presets, accent/canvas/text with a live WCAG contrast readout, corner radius, glow, edge veil, animations, dock side, import/export theme codes, and an admin push to every player |

## Base maps

Six base maps ship under `templates/<id>/` (tiles) with their Cayo Perico
`.gfx` matched to each style. The picker is built from
`html/tiles/maps.json`. The realistic/satellite maps are native **4096px**
uncompressed (A8R8G8B8); the studio works at 2048 and the export rebuilds
each tile at its native size automatically. To add or rename maps, drop a
`templates/<id>/` folder and run `node tools/extract_tiles.js` (edit
`MAP_META` there for labels/order). Default map: `Config.defaultMap`.

## The assistant

An in-studio helper: how do I do X, why is nothing happening, what does
Live actually change. It answers about **this** studio and refuses
everything else, and it is handed a snapshot of what you have open right
now (tool, layers, base map, postals, zoom, unsaved state) — which is the
difference between "you have no layer selected" and a generic paragraph.
Its suggestions become buttons that switch tool or open a tab; nothing it
returns can touch your map.

**The key goes in `server/ai_key.lua`.** That file only runs on the
server. `shared/config.lua` is a `shared_script`, i.e. it is downloaded by
every client that joins — a key written there travels inside every copy of
the resource and anyone can read and spend it. `Config.ai.apiKey` and the
`apex_minimap_ai_key` convar are both still accepted (as are the
apex_mapbuilder / apex_clothing keys), but the server-only file is the one
to use. A free Gemini key: https://aistudio.google.com/apikey

Everything else lives in `Config.ai`: provider (gemini / openai / custom),
model, timeout and the per-player rate limits. Test the whole chain from
the server console with `apexmm_ai_test how do I add text`.

## Sharpness

The editor works at 1024 px per tile so the whole atlas plus paint layers
fit in what CEF can hold. The tiles on disk are 2048, so past ~85% zoom
the studio loads the full-resolution tile for whatever is on screen (with
the theme applied) and drops it again when you zoom out — capped at four
tiles, which is why memory stays flat. The package export does the same,
one tile at a time, so an exported map is no longer a 4× upscale of the
working atlas.

## World bounds (why postals used to be off)

`Config.worldBounds` is what turns a world coordinate into a map pixel, so
it decides where postal codes land, where a blip you place ends up in game,
and which area a map extension covers. It used to hold a guess
(8440 × 12440 world units) that squeezed the map ~6% in X and ~8% in Y —
postals ended up roughly 125 px off.

The values shipped now were **measured**: a minimap generated by
fivem-tools bakes the postal numbers into its tiles, so the numbers are
ground truth. Reading 11 codes spread across the atlas and least-squares
fitting an isotropic (square-pixel) mapping gives a maximum residual of
**1.1 px** in edit space. Only change them if you have a better measurement.

## Postals & the /gps script

Open the **Postals** tab, then **Import** a postal set (JSON `[{code,x,y}]`
or CSV `code,x,y` — OCRP / Oulsen exports work) or hit **Grid** to generate
one. Toggle **Show postal codes** to draw them on the map (they bake into the
export), and keep **Bundle /gps script** on to ship a `postals.lua` in the
exported resource: it shows the nearest postal on the HUD and adds `/gps`
(no args = nearest; `/gps <code>` = waypoint). Style everything (font, size,
outline, shadow, opacity) and override a single postal by its code.

## Working on the canvas

The canvas behaves like an image editor, not like a form:

- **Text is typed where it lands.** Pick the text tool, click the map and
  type — the caret blinks on the map, the letters appear in the final font
  and size, and the live radar preview follows as you type. `Enter` finishes,
  `Esc` throws it away, an empty label is discarded instead of leaving a dead
  layer behind. Double-click any label (on the map or in the layer list) to
  edit it again; `Enter`/`F2` edits the selected one.
- **A real transform box:** 8 handles plus a rotation handle, all rotation
  aware. `Shift` keeps the proportions, `Alt` scales from the centre,
  `Shift` while rotating snaps to 15°. Scaling a label scales its font size
  and keeps the opposite corner nailed down.
- **Snapping with guides** to the atlas edges, the centre, the tile seams and
  the other layers' edges/centres — hold `Ctrl` to ignore it. `Shift` while
  moving keeps a straight line, `Alt` while moving duplicates.
- **Selection you can predict:** the hit test follows the actual shape (a
  polygon zone ignores clicks inside its box but outside the shape; a line
  only answers near the stroke), what is under the cursor lights up before
  you click, the cursor tells you what the next click does, and `Alt`+click
  reaches whatever is underneath. `Esc` drops the selection (and only closes
  the studio when nothing is selected).
- **Everything is live:** inspector fields write on every keystroke (one undo
  entry per pause, not per letter), sliders redraw as they move, and the
  layer list stops rebuilding itself every time you select something.

## Map extensions (add-on maps like Roxwood)

GTA fences the player inside a fixed square. An add-on map built outside it
shows up on the minimap but the player walks into an invisible wall on the
way there — `ExtendWorldBoundaryForPlayer` is the native that moves the fence.

Open the **Extensions** tab, hit **Draw the area on the map** and drag over
the region the add-on covers (or type the world coordinates). The area is
kept in world coordinates, drawn over the atlas while you design so you can
paint the add-on exactly where it sits, and saved with the project.

The package export then ships an **`extensions.lua`** inside the generated
resource: one `ExtendWorldBoundaryForPlayer` call per corner of each area,
re-applied on `playerSpawned` (a fresh spawn resets the fence) and undone
with `ResetWorldBoundaryForPlayer` when the resource stops. "Live on Server"
only swaps the raster tiles, so it cannot extend the world.

## Appearance (theme engine)

The studio derives its **whole palette from three colours** — accent, canvas
and text. The accent ramp is generated in HSL (mixing with white/black muddies
the hue), the ink on top of the accent is picked by real WCAG contrast (a made
up luminance threshold puts black text on Apex blue, which is unreadable), and
the surface/line/text stack is interpolated from the canvas at fixed
fractions. Any accent therefore works, not just blue.

- Open it with **`/minimapstudiosettings`** or the sliders icon in the left rail.
- Tabs: **Themes** (presets + your saved looks + import/export theme codes),
  **Colors** (accent/canvas/text with a live AAA/AA/LOW readout and the derived
  ramp), **Interface** (radius, glow, edge veil, animations), **Layout** (dock
  side), **Server** (push one look to everyone).
- Per-player themes persist in a **KVP**; the server-wide theme lives in
  `GlobalState` + `data/theme.json` and **wins until it is cleared**.
- Pushing a server theme needs the ace `apex_minimap.themeadmin`:
  ```cfg
  add_ace group.admin apex_minimap.themeadmin allow
  ```
- The starting point is `Config.theme` in `shared/config.lua`, which is also
  what the **Defaults** button restores.

## Export quality (resource size)

The **Quality** control in the Export tab decides which template each tile is
rebuilt into — and that is what dictates the size of the finished resource:

| | Tiles | Per tile | Six tiles + sea copies |
| --- | --- | --- | --- |
| **Full** | native composite: the base map's own template, at that map's native size and format | 0.5–34 MB | ~6–400 MB |
| **Light** | 2048, DXT5 compressed (`templates/_light/`) | ~0.5 MB | **~6 MB** |

**Full quality is a NATIVE COMPOSITE — zero upscale.** The studio exports two
things per tile: the composed design (the fallback) and an *overlay* — only
what you drew (paint, text, zones, postals, images) on a transparent
background, rendered straight at the map's native resolution. `make_ytd` then
takes the base pixels **directly from the template `.ytd` itself**, applies
your theme to them pixel-for-pixel, and composites the overlay on top. Nothing
is ever resampled: where the overlay is transparent and the theme is neutral,
the output is byte-identical to the original map, and your design is rendered
at full native sharpness. The build prints `Quality: NATIVE COMPOSITE` when
this path is active.

**The classic path never stretches a design to fill a bigger template.** Plain
PNGs dropped into `tools/png_in/` by hand (or exports from older versions)
still go through the classic path: `make_ytd` resizes the design into whatever
template it is given and encodes in that template's exact format. Where the
base map's own template is larger than the design, pouring one into the other
would be a plain upscale — soft in game and 16× the VRAM — so the build picks
a template the size of the design instead, and prints why.
`node tools/make_ytd.js --stretch` forces the base map's own template back.

## Export pipeline (ready-to-use resource)

1. In the studio: **Export → Ready-to-use resource → Run Export**.
   The six full-res tile PNGs land in `tools/png_in/` — and, on Full quality,
   a native-resolution overlay per tile plus your theme in `export.json`.
2. On the server machine, double-click **`tools/make_ytd.bat`** (needs Node.js).
3. Grab `tools/out/<name>/` — a complete resource (`.ytd` tiles + `sea`
   variants, blank `.ydd` road-hiders, Cayo `.gfx`, `config.lua`, `map.lua`,
   `fxmanifest.lua`) — copy to `resources/`, `ensure <name>`, done.

The `.ytd` files are built by swapping pixels inside the ORIGINAL tile
templates (`templates/`), so they are valid by construction — no OpenIV, no
CodeWalker.

> The live modes replace only the raster tiles, so the vanilla vector road
> overlay still draws on the pause map until the exported resource (with its
> blank `.ydd` files) — or any custom minimap pack — is running. With one
> installed, live updates look clean immediately.

## Import a minimap you already have

Any custom minimap — one you bought, downloaded or drew yourself — can become
a base map you paint on inside the studio.

**Windows** — drag the folder (or the `.zip`) onto **`tools/import_map.bat`**.
Or copy the files into `tools/map_in/` and double-click it.

**Linux / macOS** — works headless over SSH:

```bash
bash tools/import_map.sh /path/to/the/minimap      # folder, .zip or .png
bash tools/import_map.sh                           # or use tools/map_in/
```

Then `restart apex_minimap` and it is in the Maps rail, badged **MINE**.
The studio's *Use my own map* button at the foot of that rail spells out the
same three steps in game.

It works out what you gave it — you never have to name or convert anything:

| What you drop in | What happens |
| --- | --- |
| A whole resource folder | It digs through `stream/` for the tiles |
| `minimap_<r>_<c>.ytd` (or `minimap_sea_*`) | Decoded straight from the `.ytd` |
| `.dds` tiles | DXT1 / DXT3 / DXT5 or 32-bit |
| `.png` tiles | Used as-is |
| A `.zip` of any of the above | Unpacked in memory |
| ONE big PNG of the whole map | Sliced into the six tiles (the atlas is 2:3, so 4096×6144 is ideal) |

Missing tiles are filled from the stock GTA map rather than left blank, and
the tool tells you which ones. `.rar`/`.7z` need extracting first, and `.jpg`
needs re-saving as `.png`.

If the pack brought real `.ytd` tiles, those become the export template for
that map, so a full-quality export keeps its native size and format.

```bash
node tools/import_map.js --label "Roxwood" --desc "Roxwood County"
node tools/import_map.js --list
node tools/import_map.js --remove roxwood      # only maps you imported
```

## Adding / swapping base maps by hand

1. Drop a new `templates/<id>/` folder holding the `minimap_<r>_<c>.ytd`
   tiles (plus optional `ydd/`, `gfx/`, `minimap_lod_128.ytd`).
2. Run `node tools/extract_tiles.js` — regenerates `html/tiles/<id>/*.png`
   and rewrites `html/tiles/maps.json`. Add a label in `MAP_META` at the top
   of that script. Folders starting with `_` (like `templates/_light`) are
   build assets and are skipped; imported maps are left untouched.
3. Restart the resource. The new map appears in the left rail.

## Config quick reference (`shared/config.lua`)

- `Config.command` / `Config.keybind` — `/minimapstudio`, optional key.
  (`/<command>settings` opens straight into the appearance window.)
- `Config.access` — `ace` (default `apex.minimap`), `jobs` or `everyone`.
- `Config.theme` — starting palette and UI feel (accent, canvas, text, radius,
  glow, veil, animations, dock side). Players can override it per-account.
- `Config.live.persist` — keep the server-wide minimap across restarts.
- `Config.worldBounds` — world↔pixel mapping for the statusbar readout only.
- `Config.export.seaVariants` — also emit `minimap_sea_*.ytd` (keep on).

## Files

```
apex_minimap/
├─ shared/ locales/          config + utils + en/pt (open source, escrow_ignore)
├─ client/                   apex_lib (bus) · main (UI lifecycle) · livemap (runtime textures)
├─ server/                   apex_lib · main (live set) · projects (JSON store) · export (staging) · theme (server look)
├─ html/                     the NUI studio (Apex UI design system)
│  ├─ css/style.css          every token, component recipe and CEF workaround
│  ├─ js/theme.js            the theme engine (3 colours → whole palette) + settings window
│  ├─ fonts/                 Geist + Geist Mono (self-hosted; CEF has neither)
│  └─ tiles/                 base atlas PNGs (from tools/extract_tiles.js)
├─ templates/                original .ytd/.ydd/.gfx used as export templates
├─ tools/                    extract_tiles.js · make_ytd.js/.bat · png_in/ · out/
└─ data/                     projects + live.json (created at runtime)
```
