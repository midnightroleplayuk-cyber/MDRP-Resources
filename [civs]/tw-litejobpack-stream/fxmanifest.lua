fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'tw-litejobpack-stream'
author 'Tworst'
description 'Stream assets for tw-litejobpack (separate resource to prevent crash on script restart)'
version '2.2.0'

-- Auto-loads all .ymap / .ytyp / .ybn in stream/ (baskul map)
this_is_a_map 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

client_script 'utillitruck_client.lua'
server_script 'utillitruck_server.lua'

files {
    -- Powerwash weapon meta files
    'metas/powerwash/weaponarchetypes.meta',
    'metas/powerwash/weaponanimations.meta',
    'metas/powerwash/weaponpressurewand.meta',

    -- Utillitruck vehicle meta files
    'metas/utillitruck/vehicles.meta',
    'metas/utillitruck/carcols.meta',
    'metas/utillitruck/carvariations.meta',

    'metas/forklift/vehicles.meta',
    'metas/forklift/carcols.meta',
    'metas/forklift/carvariations.meta',

    -- Baskul
    'stream/baskul/tw_baskul.ytyp',

    -- Cuttree
    'stream/cuttree/tw_cuttree.ytyp',

    -- Plumber
    'stream/plumber/pipe/pipes.ytyp',
    'stream/plumber/toilet/portillo.ytyp',
    'stream/plumber/toilet/tw_plunger.ytyp',

    -- Mining tool
    'stream/tool/tw_mining_bazq.ytyp',
}

-- Baskul archetype
data_file 'DLC_ITYP_REQUEST' 'stream/baskul/tw_baskul.ytyp'

-- Cuttree archetype
data_file 'DLC_ITYP_REQUEST' 'stream/cuttree/tw_cuttree.ytyp'

-- Plumber archetypes
data_file 'DLC_ITYP_REQUEST' 'stream/plumber/pipe/pipes.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/plumber/toilet/portillo.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/plumber/toilet/tw_plunger.ytyp'

-- Mining tool archetype
data_file 'DLC_ITYP_REQUEST' 'stream/tool/tw_mining_bazq.ytyp'

-- Powerwash weapon model meta data
data_file 'WEAPON_METADATA_FILE' 'metas/powerwash/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'metas/powerwash/weaponanimations.meta'
data_file 'WEAPONINFO_FILE' 'metas/powerwash/weaponpressurewand.meta'

-- Utillitruck vehicle data
data_file 'VEHICLE_METADATA_FILE' 'metas/utillitruck/vehicles.meta'
data_file 'CARCOLS_FILE' 'metas/utillitruck/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'metas/utillitruck/carvariations.meta'


data_file 'HANDLING_FILE' 'metas/forklift/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'metas/forklift/vehicles.meta'
data_file 'CARCOLS_FILE' 'metas/forklift/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'metas/forklift/carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'metas/forklift/vehiclelayouts.meta'

dependency '/assetpacks'