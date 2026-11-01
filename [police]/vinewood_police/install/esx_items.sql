-- vinewood_police (and vinewood-mdt) items for ESX's default inventory. ox_inventory users: use
-- ox_inventory_items.lua instead. They're registered as usable automatically.
INSERT IGNORE INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    ('handcuffs', 'Handcuffs', 1, 0, 1),
    ('police_notice', 'Police notice', 1, 0, 1),
    ('mobile_id', 'Mobile fingerprint scanner', 1, 0, 1),
    ('bail_notice', 'Bail notice', 1, 0, 1),
    ('stop_search_record', 'Stop and search record', 1, 0, 1),
    ('mdt_tablet', 'MDT tablet', 1, 0, 1);
