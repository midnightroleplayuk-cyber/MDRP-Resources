-- ox_inventory (also Qbox, which uses ox_inventory)
-- 1. Paste these entries into ox_inventory/data/items.lua, inside the main return { ... } table.
-- 2. Copy the PNGs from install/images into ox_inventory/web/images.
-- 3. Restart ox_inventory, then vinewood_gangs.

['spraycan'] = {
    label = 'Spray can',
    weight = 300,
    stack = true,
    close = true,
    description = 'For putting your name on a wall.',
},

-- Opens the informant menu when used
['burner_phone'] = {
    label = 'Burner phone',
    weight = 150,
    stack = false,
    close = true,
    description = 'One number saved. No name.',
    client = {
        export = 'vinewood_gangs.useBurner',
    },
},

-- Optional: only needed if you set Config.Tablet.item = 'gang_tablet'
['gang_tablet'] = {
    label = 'Gang tablet',
    weight = 500,
    stack = false,
    close = true,
    description = 'Keeps the business running.',
    client = {
        export = 'vinewood_gangs.openTablet',
    },
},

-- Street dealing (config/drugs.lua). Skip these if your server already has drug items: point config/drugs.lua at yours.
['weed_bag'] = { label = 'Bag of weed', weight = 10, stack = true, close = true, description = 'Ready for the street.' },
['coke_bag'] = { label = 'Bag of cocaine', weight = 10, stack = true, close = true, description = 'Ready for the street.' },
['meth_bag'] = { label = 'Bag of meth', weight = 10, stack = true, close = true, description = 'Ready for the street.' },

-- Heists: thermite for doors and armoured-truck backs (config/heists.lua > tools). Loot items (markedbills, goldbar,
-- rolex) are qb-core defaults; add them too if your inventory doesn't have them, or change the loot types in config.
['thermite'] = { label = 'Thermite', weight = 1000, stack = true, close = true, description = 'Burns through just about anything.' },
