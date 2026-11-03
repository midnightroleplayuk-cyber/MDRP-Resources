-- ESX (default inventory): run this on your database.
-- If you use ox_inventory with ESX, use ../ox_inventory/items.txt instead.
INSERT IGNORE INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    ('radio', 'Septra Radio', 1, 0, 1),
    ('walkie', 'Handheld Radio', 1, 0, 1),
    ('earpiece', 'Radio Earpiece', 1, 0, 1);
