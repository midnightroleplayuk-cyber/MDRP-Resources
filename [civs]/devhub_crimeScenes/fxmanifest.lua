fx_version 'cerulean'
games { 'gta5' }
author 'DEVHUB (store.devhub.gg)'
description 'DEVHUB CRIME SCENES'
version '1.1.5'
lua54 'yes'

shared_scripts {
    'escrowed/shared/*.lua',
    'configs/config_shared.lua',
    'configs/config.lua',
    'configs/config_translations.lua',
}

client_scripts {
    'data/names.lua',
    'escrowed/client/skills.lua',
    'escrowed/client/main.lua',
    'escrowed/client/vehicle.lua',
    'escrowed/client/spawners/pedsSpawner.lua',
    'escrowed/client/spawners/cratesSpawner.lua',
    'escrowed/client/spawners/lootableObjectsSpawner.lua',
    'escrowed/client/spawners/bodyPartsSpawner.lua',
    'escrowed/client/spawners/bloodSpawner.lua',
    'escrowed/client/spawners/main.lua',
    'escrowed/client/vehicleDisposal/burn.lua',
    'escrowed/client/vehicleDisposal/pushOffCliff.lua',
    'escrowed/client/vehicleDisposal/drown.lua',
    'escrowed/client/vehicleDisposal/main.lua',
    'escrowed/client/c.laptop.lua',
}

server_scripts {
    'escrowed/server/s.queue.lua',
    'escrowed/server/main.lua',
    'escrowed/server/skills.lua',
    'escrowed/server/vehicle.lua',
    'escrowed/server/scene.lua',
    'configs/server.lua',
}

files {
    'data/dlctext.meta',
    'data/pickups.meta',
    'data/contentunlocks.meta',
    'data/shop_weapon.meta',
    'data/pedpersonality.meta',
    'data/weaponarchetypes.meta',
    'data/weaponanimations.meta',
	'data/weaponcomponents.meta',
	'data/weapon_pocketlight.meta',
}

data_file 'TEXTFILE_METAFILE' 'data/dlctext.meta'
data_file 'DLC_WEAPON_PICKUPS' 'data/pickups.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' 'data/contentunlocks.meta'
data_file 'WEAPON_SHOP_INFO_METADATA_FILE' 'data/shop_weapon.meta'
data_file 'PED_PERSONALITY_FILE' 'data/pedpersonality.meta'
data_file 'WEAPON_METADATA_FILE' 'data/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'data/weaponanimations.meta'
data_file 'WEAPONCOMPONENTSINFO_FILE' 'data/weaponcomponents.meta'
data_file 'WEAPONINFO_FILE' 'data/weapon_pocketlight.meta'

escrow_ignore {
    'configs/*.lua',
    -- 'escrowed/shared/*.lua',
    -- 'escrowed/client/main.lua',
    -- 'escrowed/client/skills.lua',
    -- 'escrowed/client/vehicle.lua',
    -- 'escrowed/client/c.laptop.lua',
    -- 'escrowed/client/spawners/*.lua',
    -- 'escrowed/client/vehicleDisposal/*.lua',
    -- 'escrowed/server/main.lua',
    -- 'escrowed/server/skills.lua',
    -- 'escrowed/server/vehicle.lua',
    -- 'escrowed/server/scene.lua',
}

dependency '/assetpacks'