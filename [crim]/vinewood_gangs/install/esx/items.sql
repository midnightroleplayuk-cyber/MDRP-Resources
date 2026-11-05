-- ESX Legacy (default ESX inventory). If you use ox_inventory with ESX, use install/ox_inventory instead.
-- Import into your ESX database, then copy the PNGs from install/images to your inventory's image folder.
-- vinewood_gangs registers the "use" action for the phone and tablet itself.

INSERT IGNORE INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    ('spraycan', 'Spray can', 1, 0, 1),
    ('burner_phone', 'Burner phone', 1, 0, 1),
    ('gang_tablet', 'Gang tablet', 1, 0, 1), -- optional: only if Config.Tablet.item = 'gang_tablet'
    ('weed_bag', 'Bag of weed', 1, 0, 1),     -- street dealing: skip if you already have drug items
    ('coke_bag', 'Bag of cocaine', 1, 0, 1),
    ('meth_bag', 'Bag of meth', 1, 0, 1),
    ('thermite', 'Thermite', 1, 0, 1);       -- heists
