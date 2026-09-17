Codem Inventory Install

-- STEP 1: Put Polartheplug_meleeweaponpack folder into your resources then ensure it in your server.cfg

-- STEP 2: ADD CODE TO    ■   [qb-core/shared/items.lua]  ■  under the | QBShared.Items = 

    weapon_butcher = { name = 'weapon_butcher', label = 'Butcher Knife', weight = 1500, type = 'weapon', ammotype = nil, image = 'weapon_butcher.png', unique = false, useable = true, description = 'A large knife used for cutting meat, effective in close combat' },
    weapon_scimitar = { name = 'weapon_scimitar', label = 'Scimitar', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_scimitar.png', unique = false, useable = true, description = 'A curved sword used for slashing attacks, with a distinctive curve' },
    weapon_baton = { name = 'weapon_baton', label = 'Baton', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_baton.png', unique = false, useable = true, description = 'A lightweight, blunt weapon used for striking or control' },
    weapon_sledgehammer = { name = 'weapon_sledgehammer', label = 'Sledgehammer', weight = 3500, type = 'weapon', ammotype = nil, image = 'weapon_sledgehammer.png', unique = false, useable = true, description = 'A heavy tool used for demolition, effective for crushing attacks' },
    weapon_scifisword = { name = 'weapon_scifisword', label = 'Sci-Fi Sword', weight = 1800, type = 'weapon', ammotype = nil, image = 'weapon_scifisword.png', unique = true, useable = true, description = 'A futuristic sword with advanced technology for cutting through targets' },
    weapon_scythe = { name = 'weapon_scythe', label = 'Scythe', weight = 2500, type = 'weapon', ammotype = nil, image = 'weapon_scythe.png', unique = false, useable = true, description = 'A large farming tool repurposed for combat, with a curved blade for sweeping attacks' },
    weapon_barbedbat = { name = 'weapon_barbedbat', label = 'Barbed Bat', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_barbedbat.png', unique = false, useable = true, description = 'A bat wrapped with barbed wire for enhanced damage' },
    weapon_taccleaver = { name = 'weapon_taccleaver', label = 'Tactical Cleaver', weight = 1600, type = 'weapon', ammotype = nil, image = 'weapon_taccleaver.png', unique = false, useable = true, description = 'A heavy cleaver designed for tactical use, ideal for chopping' },
    weapon_kitchenknife = { name = 'weapon_kitchenknife', label = 'Kitchen Knife', weight = 800, type = 'weapon', ammotype = nil, image = 'weapon_kitchenknife.png', unique = false, useable = true, description = 'A standard kitchen knife with a sharp blade for cutting' },
    weapon_eguitar = { name = 'weapon_eguitar', label = 'Electric Guitar', weight = 2500, type = 'weapon', ammotype = nil, image = 'weapon_eguitar.png', unique = false, useable = true, description = 'An electric guitar used for bludgeoning opponents' },
    weapon_guitar = { name = 'weapon_guitar', label = 'Guitar', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_guitar.png', unique = false, useable = true, description = 'A standard guitar used as a makeshift weapon for striking' },
    weapon_pitchfork = { name = 'weapon_pitchfork', label = 'Pitchfork', weight = 3000, type = 'weapon', ammotype = nil, image = 'weapon_pitchfork.png', unique = false, useable = true, description = 'A farming tool with prongs for goring and piercing attacks' },
    weapon_tacaxe = { name = 'weapon_tacaxe', label = 'Tactical Axe', weight = 2500, type = 'weapon', ammotype = nil, image = 'weapon_tacaxe.png', unique = false, useable = true, description = 'A versatile tactical axe for chopping and throwing' },
    weapon_wclaws = { name = 'weapon_wclaws', label = 'Weaponized Claws', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_wclaws.png', unique = false, useable = true, description = 'Claws designed for combat, ideal for slashing' },
    weapon_scissors = { name = 'weapon_scissors', label = 'Scissors', weight = 500, type = 'weapon', ammotype = nil, image = 'weapon_scissors.png', unique = false, useable = true, description = 'A pair of sharp scissors used for cutting and stabbing' },
    weapon_pickaxe = { name = 'weapon_pickaxe', label = 'Pickaxe', weight = 3000, type = 'weapon', ammotype = nil, image = 'weapon_pickaxe.png', unique = false, useable = true, description = 'A mining tool repurposed for bludgeoning and piercing attacks' },
    weapon_screwdriver = { name = 'weapon_screwdriver', label = 'Screwdriver', weight = 600, type = 'weapon', ammotype = nil, image = 'weapon_screwdriver.png', unique = false, useable = true, description = 'A tool used for driving screws, also effective for stabbing' },
    weapon_dildo = { name = 'weapon_dildo', label = 'Dildo', weight = 800, type = 'weapon', ammotype = nil, image = 'weapon_dildo.png', unique = false, useable = true, description = 'A novelty item used for bludgeoning opponents' },
    weapon_hunterknife = { name = 'weapon_hunterknife', label = 'Hunter Knife', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_hunterknife.png', unique = false, useable = true, description = 'A sturdy knife used for hunting, ideal for cutting and stabbing' },
    weapon_iceclimber = { name = 'weapon_iceclimber', label = 'Ice Climber Pick', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_iceclimber.png', unique = false, useable = true, description = 'A pickaxe used for climbing ice, effective for bludgeoning and piercing' },
    weapon_mace = { name = 'weapon_mace', label = 'Mace', weight = 3000, type = 'weapon', ammotype = nil, image = 'weapon_mace.png', unique = false, useable = true, description = 'A medieval weapon with a heavy head, used for crushing opponents' },
    weapon_shovel = { name = 'weapon_shovel', label = 'Shovel', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_shovel.png', unique = false, useable = true, description = 'A common tool used for digging, also effective for bludgeoning' },
    weapon_spikedknuckles = { name = 'weapon_spikedknuckles', label = 'Spiked Knuckles', weight = 800, type = 'weapon', ammotype = nil, image = 'weapon_spikedknuckles.png', unique = false, useable = true, description = 'Knuckle dusters with spikes for enhanced damage in hand-to-hand combat' },
    weapon_crutch = { name = 'weapon_crutch', label = 'Crutch', weight = 1500, type = 'weapon', ammotype = nil, image = 'weapon_crutch.png', unique = false, useable = true, description = 'A crutch repurposed as a weapon, useful for bludgeoning' },
    weapon_brownmachete = { name = 'weapon_brownmachete', label = 'Brown Machete', weight = 1800, type = 'weapon', ammotype = nil, image = 'weapon_brownmachete.png', unique = false, useable = true, description = 'A machete with a brown handle, effective for chopping and slashing' },
    weapon_blackkatana = { name = 'weapon_blackkatana', label = 'Black Katana', weight = 1500, type = 'weapon', ammotype = nil, image = 'weapon_blackkatana.png', unique = false, useable = true, description = 'A sleek black katana, designed for precise and deadly cuts' },
    weapon_kukri = { name = 'weapon_kukri', label = 'Kukri', weight = 1600, type = 'weapon', ammotype = nil, image = 'weapon_kukri.png', unique = false, useable = true, description = 'A curved knife used for chopping and slashing' },
    weapon_stopsign = { name = 'weapon_stopsign', label = 'Stop Sign', weight = 3000, type = 'weapon', ammotype = nil, image = 'weapon_stopsign.png', unique = false, useable = true, description = 'A metal stop sign used as a blunt instrument for striking' },
    weapon_thorshammer = { name = 'weapon_thorshammer', label = 'Thors Hammer', weight = 4000, type = 'weapon', ammotype = nil, image = 'weapon_thorshammer.png', unique = true, useable = true, description = 'A legendary hammer with immense crushing power' },
    weapon_axe = { name = 'weapon_axe', label = 'Axe', weight = 2500, type = 'weapon', ammotype = nil, image = 'weapon_axe.png', unique = false, useable = true, description = 'A heavy axe used for chopping and severing' },
    weapon_chair = { name = 'weapon_chair', label = 'Chair', weight = 3000, type = 'weapon', ammotype = nil, image = 'weapon_chair.png', unique = false, useable = true, description = 'A sturdy chair used as a makeshift weapon for bludgeoning' },
    weapon_zk = { name = 'weapon_zk', label = 'Zombie Knife', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_zk.png', unique = false, useable = true, description = 'A knife with a sinister design, used for cutting and slashing' },
    weapon_redzk = { name = 'weapon_redzk', label = 'Red Zombie Knife', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_redzk.png', unique = false, useable = true, description = 'A red variant of the zombie knife, designed for cutting and slashing' },
    weapon_bluezk = { name = 'weapon_bluezk', label = 'Blue Zombie Knife', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_bluezk.png', unique = false, useable = true, description = 'A blue variant of the zombie knife, used for cutting and slashing' },
    weapon_pinkzk = { name = 'weapon_pinkzk', label = 'Pink Zombie Knife', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_pinkzk.png', unique = false, useable = true, description = 'A pink variant of the zombie knife, effective for cutting and slashing' },
    weapon_spikeybat = { name = 'weapon_spikeybat', label = 'Spikey Bat', weight = 2500, type = 'weapon', ammotype = nil, image = 'weapon_spikeybat.png', unique = false, useable = true, description = 'A bat fitted with spikes for increased damage in combat' },
    weapon_katana = { name = 'weapon_katana', label = 'Katana', weight = 1500, type = 'weapon', ammotype = nil, image = 'weapon_katana.png', unique = false, useable = true, description = 'A traditional Japanese sword, renowned for its sharpness and cutting ability' },
    weapon_longmachete = { name = 'weapon_longmachete', label = 'Long Machete', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_longmachete.png', unique = false, useable = true, description = 'An extended version of the machete, designed for longer reach and chopping' },
    weapon_tacticalhatchet = { name = 'weapon_tacticalhatchet', label = 'Tactical Hatchet', weight = 1800, type = 'weapon', ammotype = nil, image = 'weapon_tacticalhatchet.png', unique = false, useable = true, description = 'A compact hatchet designed for tactical use, effective for chopping and throwing' },
    weapon_twohbattleaxe = { name = 'weapon_twohbattleaxe', label = 'two handed battleaxe', weight = 1800, type = 'weapon', ammotype = nil, image = 'weapon_twohbattleaxe.png', unique = false, useable = true, description = 'A compact hatchet designed for tactical use, effective for chopping and throwing' },    
    weapon_fireworksingle        = { name = 'weapon_fireworksingle', label = 'Firework', weight = 1000, type = 'weapon', ammotype = 'AMMO_FIREWORK', image = 'weapon_fireworksingle.png', unique = true, useable = false, description = 'A defense weapon' },
    weapon_spraypaint            = { name = 'weapon_spraypaint', label = 'Spray Paint', weight = 1000, type = 'weapon', ammotype = 'AMMO_SPRAYPAINT', image = 'weapon_spraypaint.png', unique = true, useable = false, description = 'A defense weapon' },
    weapon_pepperspray           = { name = 'weapon_pepperspray', label = 'Pepper Spray', weight = 1000, type = 'weapon', ammotype = 'AMMO_PEPPERSPRAY', image = 'weapon_pepperspray.png', unique = true, useable = false, description = 'A defense weapon' },
    weapon_acidspray             = { name = 'weapon_acidspray', label = 'Acid Spray', weight = 1000, type = 'weapon', ammotype = 'AMMO_ACIDSPRAY', image = 'weapon_acidspray.png', unique = true, useable = false, description = 'A burning chemical' },
    acidspray_ammo               = { name = 'acidspray_ammo', label = 'Acid Ammo', weight = 200, type = 'item', image = 'acidspray_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for acid sprayer' },
    pepperspray_ammo               = { name = 'pepperspray_ammo', label = 'Pepper Ammo', weight = 200, type = 'item', image = 'pepperspray_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for pepper sprayer' },
    spraypaint_ammo               = { name = 'spraypaint_ammo', label = 'Spray Ammo', weight = 200, type = 'item', image = 'spraypaint_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for spraypaint' },
    firework_ammo               = { name = 'firework_ammo', label = 'Firework Ammo', weight = 200, type = 'item', image = 'firework_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for firework' },

    -- STEP 3: ADD CODE TO    ■   [codem-inventory/config/itemlist.lua]  ■  under the | Config.Itemlist = {

    weapon_butcher = { name = 'weapon_butcher', label = 'Butcher Knife', weight = 1500, type = 'weapon', ammotype = nil, image = 'weapon_butcher.png', unique = false, useable = true, description = 'A large knife used for cutting meat, effective in close combat' },
    weapon_scimitar = { name = 'weapon_scimitar', label = 'Scimitar', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_scimitar.png', unique = false, useable = true, description = 'A curved sword used for slashing attacks, with a distinctive curve' },
    weapon_baton = { name = 'weapon_baton', label = 'Baton', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_baton.png', unique = false, useable = true, description = 'A lightweight, blunt weapon used for striking or control' },
    weapon_sledgehammer = { name = 'weapon_sledgehammer', label = 'Sledgehammer', weight = 3500, type = 'weapon', ammotype = nil, image = 'weapon_sledgehammer.png', unique = false, useable = true, description = 'A heavy tool used for demolition, effective for crushing attacks' },
    weapon_scifisword = { name = 'weapon_scifisword', label = 'Sci-Fi Sword', weight = 1800, type = 'weapon', ammotype = nil, image = 'weapon_scifisword.png', unique = true, useable = true, description = 'A futuristic sword with advanced technology for cutting through targets' },
    weapon_scythe = { name = 'weapon_scythe', label = 'Scythe', weight = 2500, type = 'weapon', ammotype = nil, image = 'weapon_scythe.png', unique = false, useable = true, description = 'A large farming tool repurposed for combat, with a curved blade for sweeping attacks' },
    weapon_barbedbat = { name = 'weapon_barbedbat', label = 'Barbed Bat', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_barbedbat.png', unique = false, useable = true, description = 'A bat wrapped with barbed wire for enhanced damage' },
    weapon_taccleaver = { name = 'weapon_taccleaver', label = 'Tactical Cleaver', weight = 1600, type = 'weapon', ammotype = nil, image = 'weapon_taccleaver.png', unique = false, useable = true, description = 'A heavy cleaver designed for tactical use, ideal for chopping' },
    weapon_kitchenknife = { name = 'weapon_kitchenknife', label = 'Kitchen Knife', weight = 800, type = 'weapon', ammotype = nil, image = 'weapon_kitchenknife.png', unique = false, useable = true, description = 'A standard kitchen knife with a sharp blade for cutting' },
    weapon_eguitar = { name = 'weapon_eguitar', label = 'Electric Guitar', weight = 2500, type = 'weapon', ammotype = nil, image = 'weapon_eguitar.png', unique = false, useable = true, description = 'An electric guitar used for bludgeoning opponents' },
    weapon_guitar = { name = 'weapon_guitar', label = 'Guitar', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_guitar.png', unique = false, useable = true, description = 'A standard guitar used as a makeshift weapon for striking' },
    weapon_pitchfork = { name = 'weapon_pitchfork', label = 'Pitchfork', weight = 3000, type = 'weapon', ammotype = nil, image = 'weapon_pitchfork.png', unique = false, useable = true, description = 'A farming tool with prongs for goring and piercing attacks' },
    weapon_tacaxe = { name = 'weapon_tacaxe', label = 'Tactical Axe', weight = 2500, type = 'weapon', ammotype = nil, image = 'weapon_tacaxe.png', unique = false, useable = true, description = 'A versatile tactical axe for chopping and throwing' },
    weapon_wclaws = { name = 'weapon_wclaws', label = 'Weaponized Claws', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_wclaws.png', unique = false, useable = true, description = 'Claws designed for combat, ideal for slashing' },
    weapon_scissors = { name = 'weapon_scissors', label = 'Scissors', weight = 500, type = 'weapon', ammotype = nil, image = 'weapon_scissors.png', unique = false, useable = true, description = 'A pair of sharp scissors used for cutting and stabbing' },
    weapon_pickaxe = { name = 'weapon_pickaxe', label = 'Pickaxe', weight = 3000, type = 'weapon', ammotype = nil, image = 'weapon_pickaxe.png', unique = false, useable = true, description = 'A mining tool repurposed for bludgeoning and piercing attacks' },
    weapon_screwdriver = { name = 'weapon_screwdriver', label = 'Screwdriver', weight = 600, type = 'weapon', ammotype = nil, image = 'weapon_screwdriver.png', unique = false, useable = true, description = 'A tool used for driving screws, also effective for stabbing' },
    weapon_dildo = { name = 'weapon_dildo', label = 'Dildo', weight = 800, type = 'weapon', ammotype = nil, image = 'weapon_dildo.png', unique = false, useable = true, description = 'A novelty item used for bludgeoning opponents' },
    weapon_hunterknife = { name = 'weapon_hunterknife', label = 'Hunter Knife', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_hunterknife.png', unique = false, useable = true, description = 'A sturdy knife used for hunting, ideal for cutting and stabbing' },
    weapon_iceclimber = { name = 'weapon_iceclimber', label = 'Ice Climber Pick', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_iceclimber.png', unique = false, useable = true, description = 'A pickaxe used for climbing ice, effective for bludgeoning and piercing' },
    weapon_mace = { name = 'weapon_mace', label = 'Mace', weight = 3000, type = 'weapon', ammotype = nil, image = 'weapon_mace.png', unique = false, useable = true, description = 'A medieval weapon with a heavy head, used for crushing opponents' },
    weapon_shovel = { name = 'weapon_shovel', label = 'Shovel', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_shovel.png', unique = false, useable = true, description = 'A common tool used for digging, also effective for bludgeoning' },
    weapon_spikedknuckles = { name = 'weapon_spikedknuckles', label = 'Spiked Knuckles', weight = 800, type = 'weapon', ammotype = nil, image = 'weapon_spikedknuckles.png', unique = false, useable = true, description = 'Knuckle dusters with spikes for enhanced damage in hand-to-hand combat' },
    weapon_crutch = { name = 'weapon_crutch', label = 'Crutch', weight = 1500, type = 'weapon', ammotype = nil, image = 'weapon_crutch.png', unique = false, useable = true, description = 'A crutch repurposed as a weapon, useful for bludgeoning' },
    weapon_brownmachete = { name = 'weapon_brownmachete', label = 'Brown Machete', weight = 1800, type = 'weapon', ammotype = nil, image = 'weapon_brownmachete.png', unique = false, useable = true, description = 'A machete with a brown handle, effective for chopping and slashing' },
    weapon_blackkatana = { name = 'weapon_blackkatana', label = 'Black Katana', weight = 1500, type = 'weapon', ammotype = nil, image = 'weapon_blackkatana.png', unique = false, useable = true, description = 'A sleek black katana, designed for precise and deadly cuts' },
    weapon_kukri = { name = 'weapon_kukri', label = 'Kukri', weight = 1600, type = 'weapon', ammotype = nil, image = 'weapon_kukri.png', unique = false, useable = true, description = 'A curved knife used for chopping and slashing' },
    weapon_stopsign = { name = 'weapon_stopsign', label = 'Stop Sign', weight = 3000, type = 'weapon', ammotype = nil, image = 'weapon_stopsign.png', unique = false, useable = true, description = 'A metal stop sign used as a blunt instrument for striking' },
    weapon_thorshammer = { name = 'weapon_thorshammer', label = 'Thors Hammer', weight = 4000, type = 'weapon', ammotype = nil, image = 'weapon_thorshammer.png', unique = true, useable = true, description = 'A legendary hammer with immense crushing power' },
    weapon_axe = { name = 'weapon_axe', label = 'Axe', weight = 2500, type = 'weapon', ammotype = nil, image = 'weapon_axe.png', unique = false, useable = true, description = 'A heavy axe used for chopping and severing' },
    weapon_chair = { name = 'weapon_chair', label = 'Chair', weight = 3000, type = 'weapon', ammotype = nil, image = 'weapon_chair.png', unique = false, useable = true, description = 'A sturdy chair used as a makeshift weapon for bludgeoning' },
    weapon_zk = { name = 'weapon_zk', label = 'Zombie Knife', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_zk.png', unique = false, useable = true, description = 'A knife with a sinister design, used for cutting and slashing' },
    weapon_redzk = { name = 'weapon_redzk', label = 'Red Zombie Knife', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_redzk.png', unique = false, useable = true, description = 'A red variant of the zombie knife, designed for cutting and slashing' },
    weapon_bluezk = { name = 'weapon_bluezk', label = 'Blue Zombie Knife', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_bluezk.png', unique = false, useable = true, description = 'A blue variant of the zombie knife, used for cutting and slashing' },
    weapon_pinkzk = { name = 'weapon_pinkzk', label = 'Pink Zombie Knife', weight = 1200, type = 'weapon', ammotype = nil, image = 'weapon_pinkzk.png', unique = false, useable = true, description = 'A pink variant of the zombie knife, effective for cutting and slashing' },
    weapon_spikeybat = { name = 'weapon_spikeybat', label = 'Spikey Bat', weight = 2500, type = 'weapon', ammotype = nil, image = 'weapon_spikeybat.png', unique = false, useable = true, description = 'A bat fitted with spikes for increased damage in combat' },
    weapon_katana = { name = 'weapon_katana', label = 'Katana', weight = 1500, type = 'weapon', ammotype = nil, image = 'weapon_katana.png', unique = false, useable = true, description = 'A traditional Japanese sword, renowned for its sharpness and cutting ability' },
    weapon_longmachete = { name = 'weapon_longmachete', label = 'Long Machete', weight = 2000, type = 'weapon', ammotype = nil, image = 'weapon_longmachete.png', unique = false, useable = true, description = 'An extended version of the machete, designed for longer reach and chopping' },
    weapon_tacticalhatchet = { name = 'weapon_tacticalhatchet', label = 'Tactical Hatchet', weight = 1800, type = 'weapon', ammotype = nil, image = 'weapon_tacticalhatchet.png', unique = false, useable = true, description = 'A compact hatchet designed for tactical use, effective for chopping and throwing' },
    weapon_twohbattleaxe = { name = 'weapon_twohbattleaxe', label = 'two handed battleaxe', weight = 1800, type = 'weapon', ammotype = nil, image = 'weapon_twohbattleaxe.png', unique = false, useable = true, description = 'A compact hatchet designed for tactical use, effective for chopping and throwing' },    
    weapon_fireworksingle        = { name = 'weapon_fireworksingle', label = 'Firework', weight = 1000, type = 'weapon', ammotype = 'AMMO_FIREWORK', image = 'weapon_fireworksingle.png', unique = true, useable = false, description = 'A defense weapon' },
    weapon_spraypaint            = { name = 'weapon_spraypaint', label = 'Spray Paint', weight = 1000, type = 'weapon', ammotype = 'AMMO_SPRAYPAINT', image = 'weapon_spraypaint.png', unique = true, useable = false, description = 'A defense weapon' },
    weapon_pepperspray           = { name = 'weapon_pepperspray', label = 'Pepper Spray', weight = 1000, type = 'weapon', ammotype = 'AMMO_PEPPERSPRAY', image = 'weapon_pepperspray.png', unique = true, useable = false, description = 'A defense weapon' },
    weapon_acidspray             = { name = 'weapon_acidspray', label = 'Acid Spray', weight = 1000, type = 'weapon', ammotype = 'AMMO_ACIDSPRAY', image = 'weapon_acidspray.png', unique = true, useable = false, description = 'A burning chemical' },
    acidspray_ammo               = { name = 'acidspray_ammo', label = 'Acid Ammo', weight = 200, type = 'item', image = 'acidspray_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for acid sprayer' },
    pepperspray_ammo               = { name = 'pepperspray_ammo', label = 'Pepper Ammo', weight = 200, type = 'item', image = 'pepperspray_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for pepper sprayer' },
    spraypaint_ammo               = { name = 'spraypaint_ammo', label = 'Spray Ammo', weight = 200, type = 'item', image = 'spraypaint_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for spraypaint' },
    firework_ammo               = { name = 'firework_ammo', label = 'Firework Ammo', weight = 200, type = 'item', image = 'firework_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for firework' },

 -- STEP 4: ADD CODE TO    ■   [codem-inventory/config/throwweapon.lua]  ■  under the | Config.WeaponsThrow = {  ***IF YOU WOULD LIKE TO BE ABLE TO THROW THE WEAPONS!!!****

    "WEAPON_BUTCHER",
    "WEAPON_SCIMITAR",
    "WEAPON_BATON",
    "WEAPON_SLEDGEHAMMER",
    "WEAPON_SCIFISWORD",
    "WEAPON_SCYTHE",
    "WEAPON_PEPPERSPRAY",
    "WEAPON_ACIDSPRAY",
    "WEAPON_BARBEDBAT",
    "WEAPON_TACCLEAVER",
    "WEAPON_KITCHENKNIFE",
    "WEAPON_EGUITAR",
    "WEAPON_GUITAR",
    "WEAPON_PITCHFORK",
    "WEAPON_TACAXE",
    "WEAPON_WCLAWS",
    "WEAPON_SCISSORS",
    "WEAPON_PICKAXE",
    "WEAPON_SCREWDRIVER",
    "WEAPON_DILDO",
    "WEAPON_HUNTERKNIFE",
    "WEAPON_ICECLIMBER",
    "WEAPON_MACE",
    "WEAPON_SHOVEL",
    "WEAPON_SPIKEDKNUCKLES",
    "WEAPON_CRUTCH",
    "WEAPON_BROWNMACHETE",
    "WEAPON_BLACKKATANA",
    "WEAPON_KUKRI",
    "WEAPON_STOPSIGN",
    "WEAPON_THORSHAMMER",
    "WEAPON_AXE",
    "WEAPON_CHAIR",
    "WEAPON_ZK",
    "WEAPON_REDZK",
    "WEAPON_BLUEZK",
    "WEAPON_PINKZK",
    "WEAPON_SPIKEYBAT",
    "WEAPON_KATANA",
    "WEAPON_LONGMACHETE",
    "WEAPON_TACTICALHATCHET",
    "WEAPON_TWOHBATTLEAXE",
    "WEAPON_SPRAYPAINT",
    "WEAPON_FIREWORKSINGLE",

    -- STEP 5: ADD AMMO COPY CODE TO       ■   [codem-inventory/server/weapon_server.lua]
    --  should be at line 88 under - local AmmoTypes = {

    { item = 'acidspray_ammo',     ammoType = 'AMMO_ACIDSPRAY', amount = 200 },
    { item = 'pepperspray_ammo',     ammoType = 'AMMO_PEPPERSPRAY', amount = 200 },
    { item = 'firework_ammo',     ammoType = 'AMMO_FIREWORK', amount = 10 },

   -- STEP 6: ADD Code to    ■   [codem-inventory/config/durability.lua]   ■  under the | Config.DurabilityItems = {  ***IF YOU WANT THEM TO DEGRADE CHANGE decay =  to your preference of time or usage***
   
   
    ['weapon_butcher'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_scimitar'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_baton'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_sledgehammer'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },    
    ['weapon_scifisword'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_scythe'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_pepperspray'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_acidspray'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_barbedbat'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_taccleaver'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_kitchenknife'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_eguitar'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_guitar'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_pitchfork'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },    
    ['weapon_tacaxe'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_wclaws'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_scissors'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_pickaxe'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_screwdriver'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_dildo'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },  
    ['weapon_hunterknife'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_iceclimber'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_mace'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_shovel'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },    
    ['weapon_spikedknuckles'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_crutch'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_brownmachete'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_blackkatana'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_kukri'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_stopsign'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },  
    ['weapon_thorshammer'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_axe'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_chair'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_zk'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },    
    ['weapon_redzk'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_bluezk'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_pinkzk'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_spikeybat'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_katana'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_longmachete'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },  
    ['weapon_tacticalhatchet'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['WEAPON_TWOHBATTLEAXE'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_SPRAYPAINT'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    ['weapon_fireworksingle'] = {
        durability = 0.3,
        maxrepair = 5,
        decay = 'time' -- time or use
    },
    
    
   -- STEP 7: ADD Images to    ■   [codem-inventory/html/itemimages]   ■ 

