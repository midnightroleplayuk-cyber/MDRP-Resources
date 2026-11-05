-- qb-core with qb-inventory (or another inventory that reads qb-core's shared items)
-- 1. Paste these entries into qb-core/shared/items.lua, inside the QBShared.Items = { ... } table.
-- 2. Copy the PNGs from install/images into qb-inventory/html/images.
-- 3. Restart the server. vinewood_gangs registers the "use" action for the phone and tablet itself.

spraycan     = { name = 'spraycan',     label = 'Spray can',    weight = 300, type = 'item', image = 'spraycan.png',     unique = false, useable = false, shouldClose = true, description = 'For putting your name on a wall.' },
burner_phone = { name = 'burner_phone', label = 'Burner phone', weight = 150, type = 'item', image = 'burner_phone.png', unique = true,  useable = true,  shouldClose = true, description = 'One number saved. No name.' },

-- Optional: only needed if you set Config.Tablet.item = 'gang_tablet'
gang_tablet  = { name = 'gang_tablet',  label = 'Gang tablet',  weight = 500, type = 'item', image = 'gang_tablet.png',  unique = true,  useable = true,  shouldClose = true, description = 'Keeps the business running.' },

-- Street dealing (config/drugs.lua). Skip these if your server already has drug items: point config/drugs.lua at yours.
weed_bag = { name = 'weed_bag', label = 'Bag of weed',    weight = 10, type = 'item', image = 'weed_bag.png', unique = false, useable = false, shouldClose = true, description = 'Ready for the street.' },
coke_bag = { name = 'coke_bag', label = 'Bag of cocaine', weight = 10, type = 'item', image = 'coke_bag.png', unique = false, useable = false, shouldClose = true, description = 'Ready for the street.' },
meth_bag = { name = 'meth_bag', label = 'Bag of meth',    weight = 10, type = 'item', image = 'meth_bag.png', unique = false, useable = false, shouldClose = true, description = 'Ready for the street.' },

-- Heists: thermite for doors and armoured-truck backs (config/heists.lua > tools). qb-core already has markedbills, goldbar and rolex.
thermite = { name = 'thermite', label = 'Thermite', weight = 1000, type = 'item', image = 'thermite.png', unique = false, useable = false, shouldClose = true, description = 'Burns through just about anything.' },
