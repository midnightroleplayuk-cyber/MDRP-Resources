# GTA V map tile assets



The Dispatch archetype's map strip (`web/src/archetypes/DispatchMapStrip.jsx`) renders

the `gta-v-map` npm package pointed at this folder. **This folder must live under

`web/public/`, not `web/src/assets/`** — Vite only serves `public/` contents as

static, runtime-addressable URLs; anything under `src/` gets bundled/hashed by

import, which the map component's dynamic `{z}/{x}/{y}` tile URL template can't

use. `web/public/gta-map-tiles/` is copied as-is into the build output next to

`index.html`, matching the relative URLs the map strip requests.



## Current layout (what we use)



```

public/gta-map-tiles/

  mapStyles/

    {z}/{x}/{y}.webp          zoom 0–5 (complete pyramid)

    empty.webp                optional placeholder

  blips/

    1.png                     objective pin (required for markers)

```



Tile counts are verified square pyramids:



| Zoom | Files |

|------|-------|

| 0    | 1     |

| 1    | 4     |

| 2    | 16    |

| 3    | 64    |

| 4    | 256   |

| 5    | 1024  |



`DispatchMapStrip` swaps the package’s default TileLayer for

`gta-map-tiles/mapStyles/{z}/{x}/{y}.webp` on `map-ready` (the stock

`gta-v-map` pack expects `styleAtlas/*.jpg` instead).



## Stock gta-v-map pack (not used here)



If you ever drop the official MEGA asset pack instead, it looks like:



```

mapStyles/

  styleAtlas/{z}/{x}/{y}.jpg      (zoom 0-5)

  styleSatelite/{z}/{x}/{y}.jpg   (zoom 0-8)

  styleGrid/{z}/{x}/{y}.png       (zoom 0-5)

```



## Blips



Markers need `blips/1.png` (or change `OBJECTIVE_ICON` in `DispatchMapStrip.jsx`).

Without it, the map still pans/zooms but the objective pin may be missing.



## Live GPS



The current NUI message contract doesn’t send real-time job coordinates —

`worldJob.steps` only carries `{label, done, progress}`, and job contracts only

carry a text `zone` (e.g. `"Vespucci"`), never x/y. The map strip resolves that

zone name to an approximate GTA coordinate (`web/src/data/gtaZones.js`) and

re-centers when the active contract/zone changes.


