-- vinewood_police (and vinewood-mdt) items for ox_inventory.
-- Paste these into ox_inventory/data/items.lua, and copy the images in install/images/ to
-- ox_inventory/web/images/. Restart ox_inventory.
--
-- Weapons, ammo (ammo-9, ammo-rifle), bandage and radio are ox_inventory's own items already.

-- vinewood_police
['handcuffs'] = {
    label = 'Handcuffs', weight = 300, stack = false, close = true,
    description = 'Rigid handcuffs. Use to take them out, then cuff the person in front.',
    server = { export = 'vinewood_police.useItem' },
},
['police_notice'] = {
    label = 'Police notice', weight = 10, stack = false, close = true,
    description = 'A notice handed to you by the police. Use to read it.',
    server = { export = 'vinewood_police.useItem' },
},
['mobile_id'] = {  -- only needed if Config.NPC.FingerprintItem = 'mobile_id'
    label = 'Mobile fingerprint scanner', weight = 250, stack = false, close = true,
    description = 'Checks fingerprints against the national database.',
},

-- vinewood-mdt (2.19.2+)
['bail_notice'] = {
    label = 'Bail notice', weight = 10, stack = false, close = true,
    description = 'Your bail notice. Use to read it.',
    server = { export = 'vinewood-mdt.useDocument' },
},
['stop_search_record'] = {
    label = 'Stop and search record', weight = 10, stack = false, close = true,
    description = 'Your record of being searched. Use to read it.',
    server = { export = 'vinewood-mdt.useDocument' },
},
['mdt_tablet'] = {  -- only needed if vinewood-mdt Config.Item = 'mdt_tablet'
    label = 'MDT tablet', weight = 600, stack = false, close = true,
},
