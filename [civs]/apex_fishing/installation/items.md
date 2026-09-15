# Apex Fishing — ox_inventory items

Add the entries below to your `ox_inventory/data/items.lua`. Item names match
`shared/config.lua` exactly — change them in both places if you rename anything.

```lua
-- ── Bait ───────────────────────────────────────────────
['fishing_bait'] = { label = 'Fishing Bait', stack = true, weight = 30 },

-- ── Rods (4 tiers, model swaps on the player as the tier rises) ──
['fishing_rod_basic']  = { label = 'Basic Rod',     stack = false, weight = 250 },
['fishing_rod_pro']    = { label = 'Pro Rod',       stack = false, weight = 280 },
['fishing_rod_carbon'] = { label = 'Carbon Rod',    stack = false, weight = 300 },
['fishing_rod_master'] = { label = 'Master Rod',    stack = false, weight = 320 },

-- ── Fish ───────────────────────────────────────────────
['fish_sardine']    = { label = 'Sardine',      stack = true, weight =  150 },
['fish_anchovy']    = { label = 'Anchovy',      stack = true, weight =  120 },
['fish_mackerel']   = { label = 'Mackerel',     stack = true, weight =  400 },
['fish_herring']    = { label = 'Herring',      stack = true, weight =  350 },
['fish_bass']       = { label = 'Sea Bass',     stack = true, weight = 1400 },
['fish_trout']      = { label = 'Trout',        stack = true, weight = 1200 },
['fish_salmon']     = { label = 'Salmon',       stack = true, weight = 2200 },
['fish_tuna']       = { label = 'Bluefin Tuna', stack = true, weight = 6500 },
['fish_grouper']    = { label = 'Grouper',      stack = true, weight = 5500 },
['fish_swordfish']  = { label = 'Swordfish',    stack = true, weight = 9000 },
['fish_marlin']     = { label = 'Blue Marlin',  stack = true, weight =11000 },
['fish_mahi']       = { label = 'Mahi-Mahi',    stack = true, weight = 7500 },
['fish_shark']      = { label = 'Tiger Shark',  stack = true, weight =25000 },
['fish_giantsquid'] = { label = 'Giant Squid',  stack = true, weight =18000 },
['fish_leviathan']  = { label = 'Leviathan',    stack = true, weight =75000 },
['fish_kraken']     = { label = 'Young Kraken', stack = true, weight =95000 },

-- ── Junk ───────────────────────────────────────────────
['old_shoe']        = { label = 'Old Shoe',         stack = true, weight =  200 },
['tin_can']         = { label = 'Rusty Tin Can',    stack = true, weight =  150 },
['plastic_bottle']  = { label = 'Plastic Bottle',   stack = true, weight =   80 },
['seaweed']         = { label = 'Tangled Seaweed',  stack = true, weight =  100 },
['money_briefcase'] = { label = 'Sunken Briefcase', stack = false, weight = 3500 },
['rolex_watch']     = { label = 'Antique Watch',    stack = true, weight =  100 },
-- weapon_pistol is a default GTA weapon; ox_inventory already ships with it.
```

For QBCore, copy the same labels into `qb-core/shared/items.lua` (drop the
`client.export` field — QBCore registers usables via `CreateUseableItem`,
which the server already does for every rod automatically).

## SQL

The ranking table is created automatically by the server on first boot.
No manual SQL needed.
