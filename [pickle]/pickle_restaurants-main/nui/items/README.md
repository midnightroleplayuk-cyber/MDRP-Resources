# Non-inventory item images

Drop PNG icons here for the cooking cards that are kitchen **equipment**, not
installed inventory items — so they have no inventory image to draw and otherwise
show a plain vector icon. Anything you supply here replaces that icon on its card;
anything you leave out just keeps the icon. The whole folder is optional.

Vite copies `web/public/` into the build output (`../nui`) on `npm run build`, so
these files survive the `emptyOutDir` rebuild and ship to the game as
`nui/items/<name>.png` (served by `fxmanifest.lua`'s `nui/**/*`). After adding or
changing an image you must `npm run build` for it to appear in game.

### Equipment (fixed set)

| File                 | Card               | Station       |
| -------------------- | ------------------ | ------------- |
| `serving_tray.png`   | Serving Tray       | Kitchen Prep  |
| `pizza_box.png`      | Pizza Box          | Kitchen Prep  |
| `cake_tin.png`       | Cake Tin           | Kitchen Prep  |
| `cookie_tray.png`    | Cookie Tray        | Kitchen Prep  |
| `restaurant_bag.png` | Restaurant Bag     | Kitchen Prep  |
| `cup_lid.png`        | Cup Lid            | Soda Machine  |

### Drinks (per flavor)

Every poured drink collapses into the one generic drink item, so each **flavor**
is a non-inventory variation with no image of its own. Name the file after the
drink's `output` key (configured per soda-fountain flavor in the admin panel).
The shipped defaults:

| File               | Flavor         |
| ------------------ | -------------- |
| `water.png`        | Pure Aqua      |
| `lemonade.png`     | Lemonade Bliss |
| `soda.png`         | Classic Cola   |
| `diet_cola.png`    | Diet Cola      |
| `grape_soda.png`   | Grape Zap      |
| `coffee.png`       | Coffee         |

A server can rename/add/remove drinks in-game — whatever the `output` key is,
the file is `items/<output>.png`. These images show on the flavor picker, the
kitchen ticket lines, and the cooking tray card. A flavor with no supplied image
keeps its coloured swatch (picker) or generic drink image (tray/ticket).

The **generic "Restaurant Drink"** card/dialog header (the drink item before a
flavor is chosen) shows the selected flavor's art once you open it; for the
unopened catalog card, supply `items/<drink_item>.png` — `items/drink.png` by
default (the `drink_item` setting). More generally, ANY POS menu item falls back
to `items/<item>.png` when its inventory has no image, so you can art other items
the same way.

Square, transparent-background PNGs (roughly 128×128 or larger) look best — the
cards render them small, `object-contain`.

The canonical equipment list lives in code at `web/src/lib/localImages.ts`
(`EQUIP_IMAGE`); keep this table in sync with it.
