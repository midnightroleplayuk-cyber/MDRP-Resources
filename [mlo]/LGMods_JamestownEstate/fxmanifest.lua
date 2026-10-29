fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LGMods'
description 'LGMods_JamestownEstate'
version '2.4.0'

this_is_a_map 'yes'

files {
    'gtxd.meta'                                                   -- data_file assets outside stream/ must be listed or the client never downloads them
}

data_file 'GTXD_PARENTING_DATA' 'gtxd.meta'                       -- jte_txd_shared: parent of the exterior texture dictionaries
data_file 'DLC_ITYP_REQUEST' 'stream/jamestown_estate.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/jte_interiors_3.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/jte_interiors_1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/jte_interiors_2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/lgmods_signs.ytyp'      -- estate road signs (prop pack, placed by lgmods_signs.ymap)

client_scripts {
    'config.lua',
    'client.lua',
    'population.lua',
    'lifts.lua'
}

escrow_ignore {
    'config.lua',
}

dependency '/assetpacks'