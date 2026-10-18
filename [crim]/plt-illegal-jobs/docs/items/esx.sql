/*
  Illegal-Jobs — ESX items table
  Run in MySQL. Skip rows that already exist on your server (phone, radio, cash, etc.).

  darknet_tablet  — use item / open OS (Config.Item)
  darknet_vpn     — required to connect VPN app (Config.Vpn)
*/

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    -- Tablet / VPN
    ('darknet_tablet', 'Darknet Tablet', 2, 0, 1),
    ('darknet_vpn', 'Darknet VPN', 1, 0, 1),

    -- Fraud
    ('atm_hack_device', 'ATM Hack Device', 1, 0, 1),
    ('blank_card', 'Blank Card', 1, 0, 1),
    ('fake_credit_card', 'Fake Credit Card', 1, 0, 1),

    -- Shared tools
    ('lockpick', 'Lockpick', 1, 0, 1),
    ('digiscanner', 'Digi Scanner', 1, 0, 1),
    ('drill', 'Drill', 2, 0, 1),
    ('thermite', 'Thermite', 1, 0, 1),
    ('c4', 'C4', 1, 0, 1),

    -- Delivery / corner drugs
    ('meth', 'Meth Brick', 1, 0, 1),
    ('oxy', 'Oxy Pills', 1, 0, 1),
    ('weed', 'Weed Bags', 1, 0, 1),
    ('coke', 'Cocaine Package', 1, 0, 1),
    ('packed_meth', 'Packed Meth', 1, 0, 1),
    ('packed_weed', 'Packed Weed', 1, 0, 1),
    ('packed_coke', 'Packed Coke', 1, 0, 1),

    -- Diving
    ('anchor', 'Boat Anchor', 2, 0, 1),
    ('scrapmetal', 'Scrap Metal', 1, 0, 1),

    -- Moonshine / bootlegging
    ('moonshine_pack', 'Moonshine Pack', 2, 0, 1),
    ('moonshine_still', 'Moonshine Still', 5, 0, 1),
    ('old_corn', 'Old Corn', 1, 0, 1),
    ('old_fruit', 'Old Fruit', 1, 0, 1),
    ('tap_water', 'Tap Water', 1, 0, 1),
    ('crushed_ingredients', 'Crushed Ingredients', 1, 0, 1),
    ('blended_ingredients', 'Blended Ingredients', 1, 0, 1),
    ('moonshine', 'Moonshine', 1, 0, 1),

    -- Counterfeit / forgery
    ('money_sheet', 'Money Sheet', 1, 0, 1),
    ('uncutted_money', 'Uncutted Money', 1, 0, 1),
    ('cutted_money', 'Cutted Money', 1, 0, 1),
    ('paper', 'Blank Paper', 1, 0, 1),
    ('id_card', 'ID Card', 1, 0, 1),

    -- Currency (skip if already defined)
    ('black_money', 'Black Money', 0, 0, 1),
    ('cash', 'Cash', 0, 0, 1),

    -- Black Market extras (skip if already defined)
    ('fake_id', 'Fake ID', 1, 0, 1),
    ('blank_passport', 'Blank Passport', 1, 0, 1),
    ('gloves', 'Ghost Gloves', 1, 0, 1),
    ('armor', 'Armor Vest', 3, 0, 1),
    ('phone', 'Burner Phone', 1, 0, 1),
    ('radio', 'Signal Scanner', 1, 0, 1),

    -- Money laundering lab
    ('washer_basic', 'Basic Washer', 5, 0, 1),
    ('washer_industrial', 'Industrial Washer', 7, 0, 1),
    ('washer_heavy', 'Heavy Washer', 10, 0, 1),
    ('generator_small', 'Small Generator', 8, 0, 1),
    ('generator_large', 'Large Generator', 12, 0, 1),
    ('cooling_fan', 'Cooling Fan', 3, 0, 1),
    ('cash_press', 'Money Printing Press', 6, 0, 1),
    ('launder_chem_basic', 'Basic Solvent', 1, 0, 1),
    ('launder_chem_premium', 'Premium Solvent', 1, 0, 1),
    ('fuel_can', 'Fuel Can', 1, 0, 1),
    ('repair_kit', 'Repair Kit', 1, 0, 1)
ON DUPLICATE KEY UPDATE
    `label` = VALUES(`label`),
    `weight` = VALUES(`weight`);

/*
  Mission item map — see docs/items/ox_inventory.txt footer for full job → item list.
*/
