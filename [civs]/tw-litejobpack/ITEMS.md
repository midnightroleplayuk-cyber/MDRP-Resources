# tw-litejobpack — Required Inventory Items

Add the following items to your inventory system.

- **QBCore**: Paste into `qb-core/shared/items.lua` (inside the `QBShared.Items = { }` table)
- **ox_inventory**: Paste into `ox_inventory/data/items.lua` (inside the `return { }` table)

Copy the item images from `tw-litejobpack/img/items/` into your inventory's image folder
(e.g. `qb-inventory/html/images/` or `ox_inventory/web/images/`).

> **Note:** Lumberjack, Miner, Farmer, Fruitpicker and all other jobs pay cash directly — they do NOT give inventory items.
> Only Diving and Fishing use actual inventory items.
> Metal Detector items are **optional** — only needed if you enable `lootAsItem` in `shared/jobs/metaldetector.lua`.

---

## Diving (2 items)

| Item | Label | Weight | Description |
|------|-------|--------|-------------|
| `dendrogyra_coral` | Dendrogyra Coral | 1000 | Also known as pillar coral |
| `antipatharia_coral` | Antipatharia Coral | 1000 | Also known as black coral or thorn coral |

---

## Fishing — Fish (9 items)

| Item | Label | Weight | Description |
|------|-------|--------|-------------|
| `fish_anchovy` | Anchovy | 100 | Fresh anchovy |
| `fish_trout` | Trout | 200 | Fresh trout |
| `fish_mackerel` | Mackerel | 150 | Fresh mackerel |
| `fish_salmon` | Salmon | 300 | Fresh salmon |
| `fish_snapper` | Snapper | 250 | Fresh snapper |
| `fish_tuna` | Tuna | 500 | Fresh tuna |
| `fish_grouper` | Grouper | 400 | Fresh grouper |
| `fish_swordfish` | Swordfish | 600 | Fresh swordfish |
| `fish_shark` | Shark | 1000 | Shark meat |

---

## Fishing — Rods (3 items)

| Item | Label | Weight | Useable | Description |
|------|-------|--------|---------|-------------|
| `standartrod` | Standard Rod | 100 | Yes | A basic fishing rod |
| `carbonrod` | Carbon Rod | 200 | Yes | A carbon fiber fishing rod |
| `prorod` | Pro Rod | 300 | Yes | A professional fishing rod |

---

## Fishing — Baits (6 items)

| Item | Label | Weight | Description |
|------|-------|--------|-------------|
| `basicbait` | Worm Bait | 50 | Basic fishing bait |
| `spoonlure` | Spoon Lure | 100 | A spoon-shaped fishing lure |
| `threesided` | Three-Sided Lure | 100 | A three-sided fishing lure |
| `tailfish` | Tail Fish Lure | 100 | A tail fish fishing lure |
| `doublehook` | Double Hook Lure | 100 | A double hook fishing lure |
| `triplehook` | Triple Hook Lure | 100 | A triple hook fishing lure |

---

## Metal Detector — Loot (5 items, OPTIONAL)

Only needed when `runtime.lootAsItem.enabled = true` in `shared/jobs/metaldetector.lua`.
By default the job pays cash and these items are **not** required. Item names are configurable
per loot entry via the `item` field in `runtime.lootTable`.

> No item images are bundled for these — add your own PNGs to your inventory's image folder
> or adjust/remove the `image` field.

| Item | Label | Weight | Description |
|------|-------|--------|-------------|
| `md_scrap` | Scrap Metal | 500 | A chunk of rusty scrap metal dug from the sand |
| `md_coin` | Old Coin | 50 | A weathered old coin |
| `md_silver` | Silver Piece | 100 | A tarnished piece of silver |
| `md_gold` | Gold Nugget | 200 | A small gold nugget |
| `md_relic` | Rare Relic | 300 | A rare relic of unknown origin |

---

## QBCore Items — Copy & Paste

Paste the following into `qb-core/shared/items.lua` inside `QBShared.Items = { }`:

```lua
-- ══════════════════════════════════════════════════════════════
-- tw-litejobpack Items (20 items)
-- ══════════════════════════════════════════════════════════════

-- Diving
dendrogyra_coral          = { name = 'dendrogyra_coral',   label = 'Dendrogyra Coral',   weight = 1000, type = 'item', image = 'dendrogyra_coral.png',   unique = false, useable = false, shouldClose = true,  description = 'Also known as pillar coral' },
antipatharia_coral        = { name = 'antipatharia_coral', label = 'Antipatharia Coral', weight = 1000, type = 'item', image = 'antipatharia_coral.png', unique = false, useable = false, shouldClose = true,  description = 'Also known as black coral or thorn coral' },

-- Fishing — Fish
fish_anchovy              = { name = 'fish_anchovy',   label = 'Anchovy',   weight = 100,  type = 'item', image = 'fish_anchovy.png',   unique = false, useable = false, shouldClose = false, description = 'Fresh anchovy' },
fish_trout                = { name = 'fish_trout',     label = 'Trout',     weight = 200,  type = 'item', image = 'fish_trout.png',     unique = false, useable = false, shouldClose = false, description = 'Fresh trout' },
fish_mackerel             = { name = 'fish_mackerel',  label = 'Mackerel',  weight = 150,  type = 'item', image = 'fish_mackerel.png',  unique = false, useable = false, shouldClose = false, description = 'Fresh mackerel' },
fish_salmon               = { name = 'fish_salmon',    label = 'Salmon',    weight = 300,  type = 'item', image = 'fish_salmon.png',    unique = false, useable = false, shouldClose = false, description = 'Fresh salmon' },
fish_snapper              = { name = 'fish_snapper',   label = 'Snapper',   weight = 250,  type = 'item', image = 'fish_snapper.png',   unique = false, useable = false, shouldClose = false, description = 'Fresh snapper' },
fish_tuna                 = { name = 'fish_tuna',      label = 'Tuna',      weight = 500,  type = 'item', image = 'fish_tuna.png',      unique = false, useable = false, shouldClose = false, description = 'Fresh tuna' },
fish_grouper              = { name = 'fish_grouper',   label = 'Grouper',   weight = 400,  type = 'item', image = 'fish_grouper.png',   unique = false, useable = false, shouldClose = false, description = 'Fresh grouper' },
fish_swordfish            = { name = 'fish_swordfish', label = 'Swordfish', weight = 600,  type = 'item', image = 'fish_swordfish.png', unique = false, useable = false, shouldClose = false, description = 'Fresh swordfish' },
fish_shark                = { name = 'fish_shark',     label = 'Shark',     weight = 1000, type = 'item', image = 'fish_shark.png',     unique = false, useable = false, shouldClose = false, description = 'Shark meat' },

-- Fishing — Rods
standartrod               = { name = 'standartrod', label = 'Standard Rod', weight = 100, type = 'item', image = 'standartrod.png', unique = false, useable = true, shouldClose = true, description = 'A basic fishing rod' },
carbonrod                 = { name = 'carbonrod',   label = 'Carbon Rod',   weight = 200, type = 'item', image = 'carbonrod.png',   unique = false, useable = true, shouldClose = true, description = 'A carbon fiber fishing rod' },
prorod                    = { name = 'prorod',      label = 'Pro Rod',      weight = 300, type = 'item', image = 'prorod.png',      unique = false, useable = true, shouldClose = true, description = 'A professional fishing rod' },

-- Fishing — Baits
basicbait                 = { name = 'basicbait',   label = 'Worm Bait',        weight = 50,  type = 'item', image = 'basicbait.png',   unique = false, useable = false, shouldClose = false, description = 'Basic fishing bait' },
spoonlure                 = { name = 'spoonlure',   label = 'Spoon Lure',       weight = 100, type = 'item', image = 'spoonlure.png',   unique = false, useable = false, shouldClose = false, description = 'A spoon-shaped fishing lure' },
threesided                = { name = 'threesided',  label = 'Three-Sided Lure', weight = 100, type = 'item', image = 'threesided.png',  unique = false, useable = false, shouldClose = false, description = 'A three-sided fishing lure' },
tailfish                  = { name = 'tailfish',    label = 'Tail Fish Lure',   weight = 100, type = 'item', image = 'tailfish.png',    unique = false, useable = false, shouldClose = false, description = 'A tail fish fishing lure' },
doublehook                = { name = 'doublehook',  label = 'Double Hook Lure', weight = 100, type = 'item', image = 'doublehook.png',  unique = false, useable = false, shouldClose = false, description = 'A double hook fishing lure' },
triplehook                = { name = 'triplehook',  label = 'Triple Hook Lure', weight = 100, type = 'item', image = 'triplehook.png',  unique = false, useable = false, shouldClose = false, description = 'A triple hook fishing lure' },

-- Metal Detector — OPTIONAL, only when lootAsItem.enabled = true in shared/jobs/metaldetector.lua
md_scrap                  = { name = 'md_scrap',  label = 'Scrap Metal',  weight = 500, type = 'item', image = 'md_scrap.png',  unique = false, useable = false, shouldClose = false, description = 'A chunk of rusty scrap metal dug from the sand' },
md_coin                   = { name = 'md_coin',   label = 'Old Coin',     weight = 50,  type = 'item', image = 'md_coin.png',   unique = false, useable = false, shouldClose = false, description = 'A weathered old coin' },
md_silver                 = { name = 'md_silver', label = 'Silver Piece', weight = 100, type = 'item', image = 'md_silver.png', unique = false, useable = false, shouldClose = false, description = 'A tarnished piece of silver' },
md_gold                   = { name = 'md_gold',   label = 'Gold Nugget',  weight = 200, type = 'item', image = 'md_gold.png',   unique = false, useable = false, shouldClose = false, description = 'A small gold nugget' },
md_relic                  = { name = 'md_relic',  label = 'Rare Relic',   weight = 300, type = 'item', image = 'md_relic.png',  unique = false, useable = false, shouldClose = false, description = 'A rare relic of unknown origin' },
```

---

## ox_inventory Items — Copy & Paste

Paste the following into `ox_inventory/data/items.lua` inside `return { }`:

> **Rod usage on ox_inventory:** ox_inventory does not read QBCore's `CreateUseableItem`
> registry — it dispatches use actions via its own item definitions. tw-litejobpack
> listens to the `ox_inventory:usedItem` server event and runs the guarded fishing
> callback automatically, so you do **not** need to add `server.export` or
> `client.export` to the rod definitions. Just paste the items below as-is. The
> `consume = 0` field on rods keeps them in the inventory after use (rods are
> reusable tools, not consumables).

```lua
-- ══════════════════════════════════════════════════════════════
-- tw-litejobpack Items (20 items)
-- ══════════════════════════════════════════════════════════════

-- Diving
['dendrogyra_coral'] = {
    label = 'Dendrogyra Coral',
    weight = 1000,
    stack = true,
    close = true,
    description = 'Also known as pillar coral',
},
['antipatharia_coral'] = {
    label = 'Antipatharia Coral',
    weight = 1000,
    stack = true,
    close = true,
    description = 'Also known as black coral or thorn coral',
},

-- Fishing — Fish
['fish_anchovy'] = {
    label = 'Anchovy',
    weight = 100,
    stack = true,
    description = 'Fresh anchovy',
},
['fish_trout'] = {
    label = 'Trout',
    weight = 200,
    stack = true,
    description = 'Fresh trout',
},
['fish_mackerel'] = {
    label = 'Mackerel',
    weight = 150,
    stack = true,
    description = 'Fresh mackerel',
},
['fish_salmon'] = {
    label = 'Salmon',
    weight = 300,
    stack = true,
    description = 'Fresh salmon',
},
['fish_snapper'] = {
    label = 'Snapper',
    weight = 250,
    stack = true,
    description = 'Fresh snapper',
},
['fish_tuna'] = {
    label = 'Tuna',
    weight = 500,
    stack = true,
    description = 'Fresh tuna',
},
['fish_grouper'] = {
    label = 'Grouper',
    weight = 400,
    stack = true,
    description = 'Fresh grouper',
},
['fish_swordfish'] = {
    label = 'Swordfish',
    weight = 600,
    stack = true,
    description = 'Fresh swordfish',
},
['fish_shark'] = {
    label = 'Shark',
    weight = 1000,
    stack = true,
    description = 'Shark meat',
},

-- Fishing — Rods
-- consume = 0 keeps the rod in the inventory after use (rods are reusable tools).
-- Do NOT add server.export / client.export — tw-litejobpack listens to
-- `ox_inventory:usedItem` globally and runs the guarded fishing callback
-- (free-cast lock, active-job check, bait check) automatically.
['standartrod'] = {
    label = 'Standard Rod',
    weight = 100,
    stack = false,
    close = true,
    consume = 0,
    description = 'A basic fishing rod',
},
['carbonrod'] = {
    label = 'Carbon Rod',
    weight = 200,
    stack = false,
    close = true,
    consume = 0,
    description = 'A carbon fiber fishing rod',
},
['prorod'] = {
    label = 'Pro Rod',
    weight = 300,
    stack = false,
    close = true,
    consume = 0,
    description = 'A professional fishing rod',
},

-- Fishing — Baits
['basicbait'] = {
    label = 'Worm Bait',
    weight = 50,
    stack = true,
    description = 'Basic fishing bait',
},
['spoonlure'] = {
    label = 'Spoon Lure',
    weight = 100,
    stack = true,
    description = 'A spoon-shaped fishing lure',
},
['threesided'] = {
    label = 'Three-Sided Lure',
    weight = 100,
    stack = true,
    description = 'A three-sided fishing lure',
},
['tailfish'] = {
    label = 'Tail Fish Lure',
    weight = 100,
    stack = true,
    description = 'A tail fish fishing lure',
},
['doublehook'] = {
    label = 'Double Hook Lure',
    weight = 100,
    stack = true,
    description = 'A double hook fishing lure',
},
['triplehook'] = {
    label = 'Triple Hook Lure',
    weight = 100,
    stack = true,
    description = 'A triple hook fishing lure',
},

-- Metal Detector — OPTIONAL, only when lootAsItem.enabled = true in shared/jobs/metaldetector.lua
['md_scrap'] = {
    label = 'Scrap Metal',
    weight = 500,
    stack = true,
    description = 'A chunk of rusty scrap metal dug from the sand',
},
['md_coin'] = {
    label = 'Old Coin',
    weight = 50,
    stack = true,
    description = 'A weathered old coin',
},
['md_silver'] = {
    label = 'Silver Piece',
    weight = 100,
    stack = true,
    description = 'A tarnished piece of silver',
},
['md_gold'] = {
    label = 'Gold Nugget',
    weight = 200,
    stack = true,
    description = 'A small gold nugget',
},
['md_relic'] = {
    label = 'Rare Relic',
    weight = 300,
    stack = true,
    description = 'A rare relic of unknown origin',
},
```

---

---
