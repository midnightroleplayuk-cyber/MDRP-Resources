-- vinewood_police (and vinewood-mdt) items for QBCore / Qbox with qb-inventory (or ps-inventory, lj-inventory).
-- Paste into qb-core/shared/items.lua (QBCore.Shared.Items), copy install/images/ into your inventory's
-- images folder, and restart. They're registered as usable automatically.
--
-- qb-inventory ammo is named differently: in vinewood_police/config/equipment.lua change 'ammo-9' to
-- 'pistol_ammo' and 'ammo-rifle' to 'rifle_ammo' (and the ammo = '...' on the firearms to match).

handcuffs          = { name = 'handcuffs',          label = 'Handcuffs',                  weight = 300, type = 'item', image = 'handcuffs.png',          unique = true, useable = true,  shouldClose = true, description = 'Rigid handcuffs. Use to take them out, then cuff the person in front.' },
police_notice      = { name = 'police_notice',      label = 'Police notice',              weight = 10,  type = 'item', image = 'police_notice.png',      unique = true, useable = true,  shouldClose = true, description = 'A notice handed to you by the police. Use to read it.' },
mobile_id          = { name = 'mobile_id',          label = 'Mobile fingerprint scanner', weight = 250, type = 'item', image = 'mobile_id.png',          unique = true, useable = false, shouldClose = true, description = 'Checks fingerprints against the national database.' },
bail_notice        = { name = 'bail_notice',        label = 'Bail notice',                weight = 10,  type = 'item', image = 'bail_notice.png',        unique = true, useable = true,  shouldClose = true, description = 'Your bail notice. Use to read it.' },
stop_search_record = { name = 'stop_search_record', label = 'Stop and search record',     weight = 10,  type = 'item', image = 'stop_search_record.png', unique = true, useable = true,  shouldClose = true, description = 'Your record of being searched. Use to read it.' },
mdt_tablet         = { name = 'mdt_tablet',         label = 'MDT tablet',                 weight = 600, type = 'item', image = 'mdt_tablet.png',         unique = true, useable = true,  shouldClose = true, description = 'Mobile data terminal.' },
