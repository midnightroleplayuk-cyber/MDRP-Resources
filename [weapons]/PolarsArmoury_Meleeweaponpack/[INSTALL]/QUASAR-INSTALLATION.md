██████╗  ██████╗ ██╗      █████╗ ██████╗     ███╗   ███╗███████╗██╗     ███████╗███████╗    ██████╗  █████╗  ██████╗██╗  ██╗
██╔══██╗██╔═══██╗██║     ██╔══██╗██╔══██╗    ████╗ ████║██╔════╝██║     ██╔════╝██╔════╝    ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝
██████╔╝██║   ██║██║     ███████║██████╔╝    ██╔████╔██║█████╗  ██║     █████╗  █████╗      ██████╔╝███████║██║     █████╔╝ 
██╔═══╝ ██║   ██║██║     ██╔══██║██╔══██╗    ██║╚██╔╝██║██╔══╝  ██║     ██╔══╝  ██╔══╝      ██╔═══╝ ██╔══██║██║     ██╔═██╗ 
██║     ╚██████╔╝███████╗██║  ██║██║  ██║    ██║ ╚═╝ ██║███████╗███████╗███████╗███████╗    ██║     ██║  ██║╚██████╗██║  ██╗
╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝



-- STEP 1: Put the Polartheplug_weaponpack folder into your resources folder and then ensure it in your server.cfg
-- STEP 3: ADD IMAGES TO INVENTORY     [qs-inventory\html\images]
-- STEP 4: ADD FIRST CODE LIST TO      [qs-inventory\shared\items.lua   AND  qb-core\shared\items.lua]  
-- STEP 5: ADD SECOND CODE LIST TO     [qs-inventory\shared\weapons.lua] 
-- STEP 6: ADD THIRD CODE LIST TO      [qs-inventory\config\weapons.lua] under the Config.DurabilityMultiplier = { 
-- STEP 7: ADD Fith CODE LIST TO       [qb-core\shared\items.lua]
-- STEP 8: ADD This CODE LIST TO       [qb-core\shared\weapons.lua]

███████╗██╗██████╗ ███████╗████████╗     ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗  █████╗ ███████╗████████╗███████╗
██╔════╝██║██╔══██╗██╔════╝╚══██╔══╝    ██╔════╝██╔═══██╗██╔══██╗╚██╗ ██╔╝    ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝
█████╗  ██║██████╔╝███████╗   ██║       ██║     ██║   ██║██████╔╝ ╚████╔╝     ██████╔╝███████║███████╗   ██║   █████╗  
██╔══╝  ██║██╔══██╗╚════██║   ██║       ██║     ██║   ██║██╔═══╝   ╚██╔╝      ██╔═══╝ ██╔══██║╚════██║   ██║   ██╔══╝  
██║     ██║██║  ██║███████║   ██║       ╚██████╗╚██████╔╝██║        ██║       ██║     ██║  ██║███████║   ██║   ███████╗
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝        ╚═════╝ ╚═════╝ ╚═╝        ╚═╝       ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝

## qs-inventory\shared\items.lua AND QB-core/shared/items.lua


    ['weapon_butcher'] =  {
        ['name'] =  'weapon_butcher',
        ['label'] =  'butcher knife',
        ['weight'] =  500,
        ['type'] =  'weapon',
        ['ammotype'] = nil,
        ['image'] =  'weapon_butcher.png',
        ['unique'] =  true,
        ['useable'] =  false,
        ['description'] =  'it does not contain a description.'
    },

    ['weapon_twohbattleaxe'] =  {
        ['name'] =  'weapon_twohbattleaxe',
        ['label'] =  'two handed battleaxe',
        ['weight'] =  500,
        ['type'] =  'weapon',
        ['ammotype'] = nil,
        ['image'] =  'weapon_twohbattleaxe.png',
        ['unique'] =  true,
        ['useable'] =  false,
        ['description'] =  'it does not contain a description.'
    },

    ['weapon_scimitar'] = {
        ['name'] = 'weapon_scimitar',
        ['label'] = 'scimitar',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_scimitar.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_fireworksingle'] = {
        ['name'] = 'weapon_fireworksingle',
        ['label'] = 'firework spray',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = 'ammo_firework',
        ['image'] = 'weapon_fireworksingle.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_baton'] = {
        ['name'] = 'weapon_baton',
        ['label'] = 'baton',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_baton.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_sledgehammer'] = {
        ['name'] = 'weapon_sledgehammer',
        ['label'] = 'sledgehammer',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_sledgehammer.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_scifisword'] = {
        ['name'] = 'weapon_scifisword',
        ['label'] = 'sci-fi sword',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_scifisword.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },
    ['weapon_scythe'] = {
        ['name'] = 'weapon_scythe',
        ['label'] = 'scythe',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_scythe.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_pepperspray'] = {
        ['name'] = 'weapon_pepperspray',
        ['label'] = 'pepper spray',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = 'ammo_pepperspray',
        ['image'] = 'weapon_pepperspray.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_acidspray'] = {
        ['name'] = 'weapon_acidspray',
        ['label'] = 'acid spray',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = 'ammo_acidspray',
        ['image'] = 'weapon_acidspray.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_barbedbat'] = {
        ['name'] = 'weapon_barbedbat',
        ['label'] = 'barbed bat',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_barbedbat.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_kitchenknife'] = {
        ['name'] = 'weapon_kitchenknife',
        ['label'] = 'kitchen knife',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_kitchenknife.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_taccleaver'] = {
        ['name'] = 'weapon_taccleaver',
        ['label'] = 'tactical cleaver',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_taccleaver.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_eguitar'] = {
        ['name'] = 'weapon_eguitar',
        ['label'] = 'electric guitar',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_eguitar.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_guitar'] = {
        ['name'] = 'weapon_guitar',
        ['label'] = 'guitar',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_guitar.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_pitchfork'] = {
        ['name'] = 'weapon_pitchfork',
        ['label'] = 'pitchfork',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_pitchfork.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_tacaxe'] = {
        ['name'] = 'weapon_tacaxe',
        ['label'] = 'tactical axe',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_tacaxe.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_wclaws'] = {
        ['name'] = 'weapon_wclaws',
        ['label'] = 'wolverine claws',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_wclaws.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_scissors'] = {
        ['name'] = 'weapon_scissors',
        ['label'] = 'scissors',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_scissors.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_pickaxe'] = {
        ['name'] = 'weapon_pickaxe',
        ['label'] = 'pickaxe',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_pickaxe.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_screwdriver'] = {
        ['name'] = 'weapon_screwdriver',
        ['label'] = 'screwdriver',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_screwdriver.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_dildo'] = {
        ['name'] = 'weapon_dildo',
        ['label'] = 'dildo',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_dildo.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_hunterknife'] = {
        ['name'] = 'weapon_hunterknife',
        ['label'] = 'hunter knife',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_hunterknife.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_iceclimber'] = {
        ['name'] = 'weapon_iceclimber',
        ['label'] = 'ice climber',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_iceclimber.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_mace'] = {
        ['name'] = 'weapon_mace',
        ['label'] = 'mace',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_mace.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_shovel'] = {
        ['name'] = 'weapon_shovel',
        ['label'] = 'shovel',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_shovel.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_spikedknuckles'] = {
        ['name'] = 'weapon_spikedknuckles',
        ['label'] = 'spiked knuckles',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_spikedknuckles.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_crutch'] = {
        ['name'] = 'weapon_crutch',
        ['label'] = 'crutch',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_crutch.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_brownmachete'] = {
        ['name'] = 'weapon_brownmachete',
        ['label'] = 'brown machete',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_brownmachete.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_blackkatana'] = {
        ['name'] = 'weapon_blackkatana',
        ['label'] = 'black katana',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_blackkatana.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_kukri'] = {
        ['name'] = 'weapon_kukri',
        ['label'] = 'kukri',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_kukri.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_stopsign'] = {
        ['name'] = 'weapon_stopsign',
        ['label'] = 'stop sign',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_stopsign.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_thorshammer'] = {
        ['name'] = 'weapon_thorshammer',
        ['label'] = 'thors hammer',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_thorshammer.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_axe'] = {
        ['name'] = 'weapon_axe',
        ['label'] = 'axe',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_axe.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_chair'] = {
        ['name'] = 'weapon_chair',
        ['label'] = 'chair',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_chair.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_zk'] = {
        ['name'] = 'weapon_zk',
        ['label'] = 'zombie knife',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_zk.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_redzk'] = {
        ['name'] = 'weapon_redzk',
        ['label'] = 'red zombie knife',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_redzk.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_bluezk'] = {
        ['name'] = 'weapon_bluezk',
        ['label'] = 'blue zombie knife',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_bluezk.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_pinkzk'] = {
        ['name'] = 'weapon_pinkzk',
        ['label'] = 'pink zombie knife',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_pinkzk.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_spikeybat'] = {
        ['name'] = 'weapon_spikeybat',
        ['label'] = 'spikey bat',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_spikeybat.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_katana'] = {
        ['name'] = 'weapon_katana',
        ['label'] = 'katana',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_katana.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_longmachete'] = {
        ['name'] = 'weapon_longmachete',
        ['label'] = 'long machete',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_longmachete.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },

    ['weapon_tacticalhatchet'] = {
        ['name'] = 'weapon_tacticalhatchet',
        ['label'] = 'tactical hatchet',
        ['weight'] = 500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_tacticalhatchet.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'it does not contain a description.'
    },




███████╗███████╗ ██████╗ ██████╗ ███╗   ██╗██████╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗  █████╗ ███████╗████████╗███████╗
██╔════╝██╔════╝██╔════╝██╔═══██╗████╗  ██║██╔══██╗    ██╔════╝██╔═══██╗██╔══██╗╚██╗ ██╔╝    ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝
███████╗█████╗  ██║     ██║   ██║██╔██╗ ██║██║  ██║    ██║     ██║   ██║██████╔╝ ╚████╔╝     ██████╔╝███████║███████╗   ██║   █████╗  
╚════██║██╔══╝  ██║     ██║   ██║██║╚██╗██║██║  ██║    ██║     ██║   ██║██╔═══╝   ╚██╔╝      ██╔═══╝ ██╔══██║╚════██║   ██║   ██╔══╝  
███████║███████╗╚██████╗╚██████╔╝██║ ╚████║██████╔╝    ╚██████╗╚██████╔╝██║        ██║       ██║     ██║  ██║███████║   ██║   ███████╗
╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═════╝ ╚═╝        ╚═╝       ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝



## qs-inventory\shared\weapons.lua


    ['weapon_butcher'] = {
        name = 'weapon_butcher',
        label = 'Butcher',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Knifed / Stabbed / Eviscerated'
    },
    ['weapon_scimitar'] = {
        name = 'weapon_scimitar',
        label = 'Scimitar',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_baton'] = {
        name = 'weapon_baton',
        label = 'Baton',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_sledgehammer'] = {
        name = 'weapon_sledgehammer',
        label = 'Sledgehammer',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_scifisword'] = {
        name = 'weapon_scifisword',
        label = 'Sci-Fi Sword',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_scythe'] = {
        name = 'weapon_scythe',
        label = 'Scythe',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_fireworksingle'] = {
        name = 'weapon_fireworksingle',
        label = 'Firework',
        weapontype = 'Melee',
        ammotype = 'AMMO_FIREWORK',
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_spraypaint'] = {
        name = 'weapon_spraypaint',
        label = 'Spray Paint',
        weapontype = 'Melee',
        ammotype = 'AMMO_SPRAYPAINT',
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_pepperspray'] = {
        name = 'weapon_pepperspray',
        label = 'Pepper Spray',
        weapontype = 'Melee',
        ammotype = 'AMMO_PEPPERSPRAY',
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_acidspray'] = {
        name = 'weapon_acidspray',
        label = 'Acid Spray',
        weapontype = 'Melee',
        ammotype = 'AMMO_ACIDSPRAY',
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_barbedbat'] = {
        name = 'weapon_barbedbat',
        label = 'Barbed Bat',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_taccleaver'] = {
        name = 'weapon_taccleaver',
        label = 'Tactical Cleaver',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_kitchenknife'] = {
        name = 'weapon_kitchenknife',
        label = 'Kitchen Knife',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_eguitar'] = {
        name = 'weapon_eguitar',
        label = 'Electric Guitar',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_guitar'] = {
        name = 'weapon_guitar',
        label = 'Guitar',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_pitchfork'] = {
        name = 'weapon_pitchfork',
        label = 'Pitchfork',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_tacaxe'] = {
        name = 'weapon_tacaxe',
        label = 'Tactical Axe',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_blackkatana'] = {
        name = 'weapon_blackkatana',
        label = 'Black Katana',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_kukri'] = {
        name = 'weapon_kukri',
        label = 'Kukri',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_stopsign'] = {
        name = 'weapon_stopsign',
        label = 'Stop Sign',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_thorshammer'] = {
        name = 'weapon_thorshammer',
        label = 'Thor’s Hammer',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_axe'] = {
        name = 'weapon_axe',
        label = 'Axe',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_chair'] = {
        name = 'weapon_chair',
        label = 'Chair',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_spikeybat'] = {
        name = 'weapon_spikeybat',
        label = 'Spikey Bat',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    },
    ['weapon_katana'] = {
        name = 'weapon_katana',
        label = 'Katana',
        weapontype = 'Melee',
        ammotype = nil,
        damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'
    }
	


████████╗██╗  ██╗██╗██████╗ ██████╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗  █████╗ ███████╗████████╗███████╗
╚══██╔══╝██║  ██║██║██╔══██╗██╔══██╗    ██╔════╝██╔═══██╗██╔══██╗╚██╗ ██╔╝    ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝
   ██║   ███████║██║██████╔╝██║  ██║    ██║     ██║   ██║██████╔╝ ╚████╔╝     ██████╔╝███████║███████╗   ██║   █████╗  
   ██║   ██╔══██║██║██╔══██╗██║  ██║    ██║     ██║   ██║██╔═══╝   ╚██╔╝      ██╔═══╝ ██╔══██║╚════██║   ██║   ██╔══╝  
   ██║   ██║  ██║██║██║  ██║██████╔╝    ╚██████╗╚██████╔╝██║        ██║       ██║     ██║  ██║███████║   ██║   ███████╗
   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝      ╚═════╝ ╚═════╝ ╚═╝        ╚═╝       ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝
    
    
    
 ##   qs-inventory\config\weapons.lua
 ##   Drop this under the Config.DurabilityMultiplier 


    weapon_butcher = 0.10,
    weapon_scimitar = 0.10,
    weapon_baton = 0.10,
    weapon_sledgehammer = 0.10,
    weapon_scifisword = 0.10,
    weapon_scythe = 0.10,
    weapon_pepperspray = 0.10,
    weapon_acidspray = 0.10,
    weapon_barbedbat = 0.10,
    weapon_kitchenknife = 0.10,
    weapon_taccleaver = 0.10,
    weapon_eguitar = 0.10,
    weapon_guitar = 0.10,
    weapon_pitchfork = 0.10,
    weapon_tacaxe = 0.10,
    weapon_wclaws = 0.10,
    weapon_scissors = 0.10,
    weapon_pickaxe = 0.10,
    weapon_screwdriver = 0.10,
    weapon_dildo = 0.10,
    weapon_hunterknife = 0.10,
    weapon_iceclimber = 0.10,
    weapon_mace = 0.10,
    weapon_shovel = 0.10,
    weapon_spikedknuckles = 0.10,
    weapon_crutch = 0.10,
    weapon_brownmachete = 0.10,
    weapon_blackkatana = 0.10,
    weapon_kukri = 0.10,
    weapon_stopsign = 0.10,
    weapon_thorshammer = 0.10,
    weapon_axe = 0.10,
    weapon_chair = 0.10,
    weapon_zk = 0.10,
    weapon_redzk = 0.10,
    weapon_bluezk = 0.10,
    weapon_pinkzk = 0.10,
    weapon_spikeybat = 0.10,
    weapon_katana = 0.10,
    weapon_longmachete = 0.10,
    weapon_tacticalhatchet = 0.10,
    weapon_twohbattleaxe = 0.10,
    
    

ADD CODE LIST TO

## QB-Core/shared/items.lua where the "piptol_ammo" is location should be around line 2677

['pepperspray_ammo'] = {
        ['name'] = 'pepperspray_ammo',
        ['label'] = 'Pepperspray ammo',
        ['weight'] = 200,
        ['type'] = 'item',
        ['image'] = 'pepperspray_ammo.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['object'] = 'prop_ld_ammo_pack_01',
        ['description'] = 'Ammo for Pepper Spray'
    },
    ['acidspray_ammo'] = {
        ['name'] = 'acidspray_ammo',
        ['label'] = 'Acid Spray ammo',
        ['weight'] = 200,
        ['type'] = 'item',
        ['image'] = 'acidspray_ammo.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['object'] = 'prop_ld_ammo_pack_01',
        ['description'] = 'Ammo for Acid Spray'
    },
    ['spraypaint_ammo'] = {
        ['name'] = 'spraypaint_ammo',
        ['label'] = 'Paint Spray ammo',
        ['weight'] = 200,
        ['type'] = 'item',
        ['image'] = 'spraypaint_ammo.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['object'] = 'prop_ld_ammo_pack_01',
        ['description'] = 'Ammo for Spray Paint'
    },
    ['firework_ammo'] = {
        ['name'] = 'firework_ammo',
        ['label'] = 'Firework ammo',
        ['weight'] = 200,
        ['type'] = 'item',
        ['image'] = 'firework_ammo.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['object'] = 'prop_ld_ammo_pack_01',
        ['description'] = 'Ammo for Firework Gun'
    },


    ADD THIS CODE TO 

## Qb-core\shared\weapons.lua

    [`weapon_butcher`]               = { name = 'weapon_butcher', label = 'Butcher', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_taccleaver`]               = { name = 'weapon_taccleaver', label = ' Tactical Cleaver', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_tacticalhatchet`]          = { name = 'weapon_tacticalhatchet', label = ' Tactical Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_thorshammer`]              = { name = 'weapon_thorshammer', label = ' Thors Hammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_spikeybat`]                = { name = 'weapon_spikeybat', label = 'Spikey Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_spikedknuckles`]           = { name = 'weapon_spikedknuckles', label = ' Spiked Knuckles', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_shovel`]                   = { name = 'weapon_shovel', label = ' Shovel', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_scissors`]                 = { name = 'weapon_scissors', label = ' Scissors', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_mace`]                     = { name = 'weapon_mace', label = ' Mace', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_longmachete`]              = { name = 'weapon_longmachete', label = ' Long Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_kukri`]                    = { name = 'weapon_kukri', label = ' Kukri', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_kitchenknife`]             = { name = 'weapon_kitchenknife', label = ' Kitchen Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_katana`]                   = { name = 'weapon_katana', label = 'Katana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_iceclimber`]               = { name = 'weapon_iceclimber', label = ' Ice Climber', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_hunterknife`]              = { name = 'weapon_hunterknife', label = ' Hunter Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_dildo`]                    = { name = 'weapon_dildo', label = ' Dildo', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_chair`]                    = { name = 'weapon_chair', label = ' Chair', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_butcher`]                  = { name = 'weapon_butcher', label = ' Butcher', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_brownmachete`]             = { name = 'weapon_brownmachete', label = ' Brown Handle Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_blackkatana`]              = { name = 'weapon_blackkatana', label = ' Black Katana', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_wclaws`]                   = { name = 'weapon_wclaws', label = ' Wolverine Claws', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_zk`]                       = { name = 'weapon_zk', label = ' Zombie Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_tacaxe`]                   = { name = 'weapon_tacaxe', label = ' Tac Axe', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_axe`]                      = { name = 'weapon_axe', label = ' Axe', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_stopsign`]                 = { name = 'weapon_stopsign', label = ' Stop Sign', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_screwdriver`]              = { name = 'weapon_screwdriver', label = ' Screwdriver', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_crutch`]                   = { name = 'weapon_crutch', label = ' Crutch', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_guitar`]                   = { name = 'weapon_guitar', label = ' Guitar', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_eguitar`]                  = { name = 'weapon_eguitar', label = ' Electric Guitar', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_barbedbat`]                = { name = 'weapon_barbedbat', label = ' Barbed Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_sledgehammer`]             = { name = 'weapon_sledgehammer', label = ' Sledgehammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_pitchfork`]                = { name = 'weapon_pitchfork', label = ' Pitchfork', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_scifisword`]               = { name = 'weapon_scifisword', label = ' Sci-Fi Sword', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_pickaxe`]                  = { name = 'weapon_pickaxe', label = ' Pickaxe', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_scythe`]                   = { name = 'weapon_scythe', label = ' Scythe', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_scimitar`]                 = { name = 'weapon_scimitar', label = ' Scimitar', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_baton`]                    = { name = 'weapon_baton', label = ' Baton', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_pinkzk`]                   = { name = 'weapon_pinkzk', label = ' Pink Zombie Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_redzk`]                    = { name = 'weapon_redzk', label = ' Red Zombie Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_bluezk`]                   = { name = 'weapon_bluezk', label = ' Blue Zombie Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_twohbattleaxe`]            = { name = 'weapon_twohbattleaxe', label = ' Two-Handed Battle Axe', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },

	[`weapon_fireworksingle`]           = { name = 'weapon_fireworksingle', label = ' Firework Single', weapontype = 'Pistol', ammotype = 'AMMO_FIREWORK', damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_spraypaint`]               = { name = 'weapon_spraypaint', label = ' Spray Paint', weapontype = 'Pistol', ammotype = 'AMMO_SPRAYPAINT', damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_acidspray`]                = { name = 'weapon_acidspray', label = ' Acid Spray', weapontype = 'Pistol', ammotype = 'AMMO_ACIDSPRAY', damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_pepperspray`]                = { name = 'weapon_pepperspray', label = 'Pepper Spray', weapontype = 'Pistol', ammotype = 'AMMO_PEPPERSPRAY', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },




##   ██████╗ ██╗   ██╗ █████╗ ███████╗ █████╗ ██████╗     ███████╗████████╗ ██████╗ ██████╗ ███████╗
##  ██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔══██╗██╔══██╗    ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝
##  ██║   ██║██║   ██║███████║███████╗███████║██████╔╝    ███████╗   ██║   ██║   ██║██████╔╝█████╗  
##  ██║▄▄ ██║██║   ██║██╔══██║╚════██║██╔══██║██╔══██╗    ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝  
##  ╚██████╔╝╚██████╔╝██║  ██║███████║██║  ██║██║  ██║    ███████║   ██║   ╚██████╔╝██║  ██║███████╗
##   ╚══▀▀═╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
                                                                                                

## ORIGINAL STORE : https://www.quasar-store.com/ 
## CREDITS TO SEERRGIIOO & AURA 