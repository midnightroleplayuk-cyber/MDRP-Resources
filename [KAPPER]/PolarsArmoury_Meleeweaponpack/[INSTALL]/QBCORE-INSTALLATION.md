██████╗  ██████╗ ██╗      █████╗ ██████╗     ███╗   ███╗███████╗██╗     ███████╗███████╗    ██████╗  █████╗  ██████╗██╗  ██╗
██╔══██╗██╔═══██╗██║     ██╔══██╗██╔══██╗    ████╗ ████║██╔════╝██║     ██╔════╝██╔════╝    ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝
██████╔╝██║   ██║██║     ███████║██████╔╝    ██╔████╔██║█████╗  ██║     █████╗  █████╗      ██████╔╝███████║██║     █████╔╝ 
██╔═══╝ ██║   ██║██║     ██╔══██║██╔══██╗    ██║╚██╔╝██║██╔══╝  ██║     ██╔══╝  ██╔══╝      ██╔═══╝ ██╔══██║██║     ██╔═██╗ 
██║     ╚██████╔╝███████╗██║  ██║██║  ██║    ██║ ╚═╝ ██║███████╗███████╗███████╗███████╗    ██║     ██║  ██║╚██████╗██║  ██╗
╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝


	
    MAKE SURE TO ADD THE IMAGES IN QB-INVENTORY - HTML - IMAGES 



-- STEP 1: Put Polartheplug_meleeweaponpack folder into your resources then ensure it in your server.cfg

-- STEP 2: ADD FIRST CODE LIST TO    ■   [qb-core/shared/items.lua]                                    ■  under the | QBShared.Items = 

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


-- STEP 3: ADD SECOND CODE LIST TO   ■   [qb-core/shared/weapons.lua]                                  ■  under the | QBShared.Weapons =

{
    ['weapon_butcher'] = { name = 'weapon_butcher', label = 'Butcher Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut / Eviscerated' },
    ['weapon_scimitar'] = { name = 'weapon_scimitar', label = 'Scimitar', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut' },
    ['weapon_baton'] = { name = 'weapon_baton', label = 'Baton', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Struck' },
    ['weapon_sledgehammer'] = { name = 'weapon_sledgehammer', label = 'Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Crushed / Bludgeoned' },
    ['weapon_scifisword'] = { name = 'weapon_scifisword', label = 'Sci-Fi Sword', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut' },
    ['weapon_scythe'] = { name = 'weapon_scythe', label = 'Scythe', weapontype = 'Melee', ammotype = nil, damagereason = 'Chopped / Swept' },
   	[`weapon_fireworksingle`]        = { name = 'weapon_fireworksingle', label = 'Firework', weapontype = 'Pistol', ammotype = 'AMMO_FIREWORK', damagereason = 'Blasted' },
	[`weapon_spraypaint`]            = { name = 'weapon_spraypaint', label = 'Spray Paint', weapontype = 'Pistol', ammotype = 'AMMO_SPRAYPAINT', damagereason = 'Blasted' },
	[`weapon_pepperspray`]           = { name = 'weapon_pepperspray', label = 'Pepper Spray', weapontype = 'Pistol', ammotype = 'AMMO_PEPPERSPRAY', damagereason = 'Blasted' },
	[`weapon_acidspray`]             = { name = 'weapon_acidspray', label = 'Acid Spray', weapontype = 'Pistol', ammotype = 'AMMO_ACIDSPRAY', damagereason = 'Blasted' },
    ['weapon_barbedbat'] = { name = 'weapon_barbedbat', label = 'Barbed Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Lacerated' },
    ['weapon_taccleaver'] = { name = 'weapon_taccleaver', label = 'Tactical Cleaver', weapontype = 'Melee', ammotype = nil, damagereason = 'Chopped / Severed' },
    ['weapon_kitchenknife'] = { name = 'weapon_kitchenknife', label = 'Kitchen Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut' },
    ['weapon_eguitar'] = { name = 'weapon_eguitar', label = 'Electric Guitar', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Struck' },
    ['weapon_guitar'] = { name = 'weapon_guitar', label = 'Guitar', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Struck' },
    ['weapon_pitchfork'] = { name = 'weapon_pitchfork', label = 'Pitchfork', weapontype = 'Melee', ammotype = nil, damagereason = 'Gored / Pierced' },
    ['weapon_tacaxe'] = { name = 'weapon_tacaxe', label = 'Tactical Axe', weapontype = 'Melee', ammotype = nil, damagereason = 'Chopped / Severed' },
    ['weapon_wclaws'] = { name = 'weapon_wclaws', label = 'Weaponized Claws', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Raked' },
    ['weapon_scissors'] = { name = 'weapon_scissors', label = 'Scissors', weapontype = 'Melee', ammotype = nil, damagereason = 'Cut / Stabbed' },
    ['weapon_pickaxe'] = { name = 'weapon_pickaxe', label = 'Pickaxe', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Pierced' },
    ['weapon_screwdriver'] = { name = 'weapon_screwdriver', label = 'Screwdriver', weapontype = 'Melee', ammotype = nil, damagereason = 'Stabbed / Pierced' },
    ['weapon_dildo'] = { name = 'weapon_dildo', label = 'Dildo', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Struck' },
    ['weapon_hunterknife'] = { name = 'weapon_hunterknife', label = 'Hunter Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut' },
    ['weapon_iceclimber'] = { name = 'weapon_iceclimber', label = 'Ice Climber Pick', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Pierced' },
    ['weapon_mace'] = { name = 'weapon_mace', label = 'Mace', weapontype = 'Melee', ammotype = nil, damagereason = 'Crushed / Bludgeoned' },
    ['weapon_shovel'] = { name = 'weapon_shovel', label = 'Shovel', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Struck' },
    ['weapon_spikedknuckles'] = { name = 'weapon_spikedknuckles', label = 'Spiked Knuckles', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Raked' },
    ['weapon_crutch'] = { name = 'weapon_crutch', label = 'Crutch', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Struck' },
    ['weapon_brownmachete'] = { name = 'weapon_brownmachete', label = 'Brown Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Chopped / Slashed' },
    ['weapon_blackkatana'] = { name = 'weapon_blackkatana', label = 'Black Katana', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut' },
    ['weapon_kukri'] = { name = 'weapon_kukri', label = 'Kukri', weapontype = 'Melee', ammotype = nil, damagereason = 'Chopped / Slashed' },
    ['weapon_stopsign'] = { name = 'weapon_stopsign', label = 'Stop Sign', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Struck' },
    ['weapon_thorshammer'] = { name = 'weapon_thorshammer', label = 'Thor’s Hammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Crushed / Bludgeoned' },
    ['weapon_axe'] = { name = 'weapon_axe', label = 'Axe', weapontype = 'Melee', ammotype = nil, damagereason = 'Chopped / Severed' },
    ['weapon_chair'] = { name = 'weapon_chair', label = 'Chair', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Struck' },
    ['weapon_zk'] = { name = 'weapon_zk', label = 'Zombie Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut' },
    ['weapon_redzk'] = { name = 'weapon_redzk', label = 'Red Zombie Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut' },
    ['weapon_bluezk'] = { name = 'weapon_bluezk', label = 'Blue Zombie Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut' },
    ['weapon_pinkzk'] = { name = 'weapon_pinkzk', label = 'Pink Zombie Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut' },
    ['weapon_spikeybat'] = { name = 'weapon_spikeybat', label = 'Spikey Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Bludgeoned / Lacerated' },
    ['weapon_katana'] = { name = 'weapon_katana', label = 'Katana', weapontype = 'Melee', ammotype = nil, damagereason = 'Slashed / Cut' },
    ['weapon_longmachete'] = { name = 'weapon_longmachete', label = 'Long Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Chopped / Slashed' },
    ['weapon_tacticalhatchet'] = { name = 'weapon_tacticalhatchet', label = 'Tactical Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Chopped / Bludgeoned' },
    ['weapon_twohbattleaxe'] = { name = 'weapon_twohbattleaxe', label = 'Two Handed Battleaxe', weapontype = 'Melee', ammotype = nil, damagereason = 'Chopped / Bludgeoned' },
    ['weapon_spraypaint'] = { name = 'weapon_spraypaint', label = 'Spray Paint', weapontype = 'Chemical', ammotype = 'ammo-spraypaint', damagereason = 'Burned / Corroded' },
}


# STEP 4: ADD THIRD CODE LIST TO    ■   MAY DIFFER [qb-weapons/client/weapdraw] or [qb-smallresources/client/weapdraw.lua]       ■  under the | local weapons = {


'WEAPON_BUTCHER',
'WEAPON_SCIMITAR',
'WEAPON_BATON',
'WEAPON_SLEDGEHAMMER',
'WEAPON_SCIFISWORD',
'WEAPON_SCYTHE',
'WEAPON_PEPPERSPRAY',
'WEAPON_ACIDSPRAY',
'WEAPON_BARBEDBAT',
'WEAPON_TACCLEAVER',
'WEAPON_KITCHENKNIFE',
'WEAPON_EGUITAR',
'WEAPON_GUITAR',
'WEAPON_PITCHFORK',
'WEAPON_TACAXE',
'WEAPON_WCLAWS',
'WEAPON_SCISSORS',
'WEAPON_PICKAXE',
'WEAPON_SCREWDRIVER',
'WEAPON_DILDO',
'WEAPON_HUNTERKNIFE',
'WEAPON_ICECLIMBER',
'WEAPON_MACE',
'WEAPON_SHOVEL',
'WEAPON_SPIKEDKNUCKLES',
'WEAPON_CRUTCH',
'WEAPON_BROWNMACHETE',
'WEAPON_BLACKKATANA',
'WEAPON_KUKRI',
'WEAPON_STOPSIGN',
'WEAPON_THORSHAMMER',
'WEAPON_AXE',
'WEAPON_CHAIR',
'WEAPON_ZK',
'WEAPON_REDZK',
'WEAPON_BLUEZK',
'WEAPON_PINKZK',
'WEAPON_SPIKEYBAT',
'WEAPON_KATANA',
'WEAPON_LONGMACHETE',
'WEAPON_TACTICALHATCHET',
'WEAPON_TWOHBATTLEAXE',
'WEAPON_SPRAYPAINT',
'WEAPON_FIREWORKSINGLE',


-- STEP 5: ADD AMMO COPY PASTE TO        ■   [qb-core/shared/items.lua]      should be at line 284 under "ammo items " 


    acidspray_ammo               = { name = 'acidspray_ammo', label = 'Acid Ammo', weight = 200, type = 'item', image = 'acidspray_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for acid sprayer' },
    pepperspray_ammo               = { name = 'pepperspray_ammo', label = 'Pepper Ammo', weight = 200, type = 'item', image = 'pepperspray_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for pepper sprayer' },
    spraypaint_ammo               = { name = 'spraypaint_ammo', label = 'Spray Ammo', weight = 200, type = 'item', image = 'spraypaint_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for spraypaint' },
    firework_ammo               = { name = 'firework_ammo', label = 'Firework Ammo', weight = 200, type = 'item', image = 'firework_ammo.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Ammo for firework' },



-- STEP 6: ADD FOURTH CODE LIST TO   ■   [qb-weapons/config.lua]                                ■  under the | Config.DurabilityMultiplier = 

weapon_butcher          = 0.15,
weapon_scimitar         = 0.15,
weapon_baton            = 0.15,
weapon_sledgehammer     = 0.15,
weapon_scifisword       = 0.15,
weapon_scythe           = 0.15,
weapon_pepperspray      = 0.15,
weapon_acidspray        = 0.15,
weapon_barbedbat        = 0.15,
weapon_taccleaver       = 0.15,
weapon_kitchenknife     = 0.15,
weapon_eguitar          = 0.15,
weapon_guitar           = 0.15,
weapon_pitchfork        = 0.15,
weapon_tacaxe           = 0.15,
weapon_wclaws           = 0.15,
weapon_scissors         = 0.15,
weapon_pickaxe          = 0.15,
weapon_screwdriver      = 0.15,
weapon_dildo            = 0.15,
weapon_hunterknife      = 0.15,
weapon_iceclimber       = 0.15,
weapon_mace             = 0.15,
weapon_shovel           = 0.15,
weapon_spikedknuckles   = 0.15,
weapon_crutch           = 0.15,
weapon_brownmachete     = 0.15,
weapon_blackkatana      = 0.15,
weapon_kukri            = 0.15,
weapon_stopsign         = 0.15,
weapon_thorshammer      = 0.15,
weapon_axe              = 0.15,
weapon_chair            = 0.15,
weapon_zk               = 0.15,
weapon_redzk            = 0.15,
weapon_bluezk           = 0.15,
weapon_pinkzk           = 0.15,
weapon_spikeybat        = 0.15,
weapon_katana           = 0.15,
weapon_longmachete      = 0.15,
weapon_tacticalhatchet  = 0.15,
WEAPON_TWOHBATTLEAXE    = 0.15,
weapon_SPRAYPAINT       = 0.15,
weapon_fireworksingle   = 0.15,

-- STEP 7: add this code in  ■   [qb-weapons/server/main.lua]  should be added  roughly after line 229

QBCore.Functions.CreateUseableItem('acidspray_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_ACIDSPRAY', 200, item)
end)
QBCore.Functions.CreateUseableItem('pepperspray_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_PEPPERSPRAY', 200, item)
end)
QBCore.Functions.CreateUseableItem('spraypaint_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_SPRAYPAINT', 200, item)
end)
QBCore.Functions.CreateUseableItem('firework_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_FIREWORK', 10, item)
end)


-- STEP 8: add this code in  ■   [qb-smallresources/client/recoil.lua]  under the -- handguns 

    [`weapon_acidspray`] = 0.4,
    [`weapon_pepperspray`] = 0.4,
    [`weapon_spraypaint`] = 0.4,
    [`weapon_fireworksingle`] = 0.4,