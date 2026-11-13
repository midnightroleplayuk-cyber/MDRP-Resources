fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LGMods'
description 'LGMods_JamestownEstate'
version '2.7.0'

this_is_a_map 'yes'

files {
    'gtxd.meta',
    'jte_interiorproxies.meta'                                                   -- data_file assets outside stream/ must be listed or the client never downloads them
}

data_file 'INTERIOR_PROXY_ORDER_FILE' 'jte_interiorproxies.meta'   -- estate interiors on their own proxy slots (8900+): stops other maps' vanilla interior overrides landing on ours
data_file 'GTXD_PARENTING_DATA' 'gtxd.meta'                       -- jte_txd_shared: parent of the exterior texture dictionaries
data_file 'DLC_ITYP_REQUEST' 'stream/jamestown_estate.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/jte_interiors_1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/jte_interiors_2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/jte_signs.ytyp'        -- estate road signs (static props, placed by jte_signs.ymap)

client_scripts {
    'config.lua',
    'client/oneway.lua',
    'client/client.lua',
    'client/population.lua',
    'client/lifts.lua',
    'client/furnish.lua',
    'client/furniture.lua'
}

escrow_ignore {
    'config.lua',
    'stream/Vanilla/*.ymap',
    'stream/Vanilla/*.ybn',
    'stream/Vanilla/*.ydr',
    'stream/Vanilla/*.ynd',
    'stream/Vanilla/*.ynv',
}

dependency '/assetpacks'