fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LGMods'
description 'LGMods_JamestownEstate'
version '2.2.0'

this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/jamestown_estate.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/jte_interiors_3.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/jte_interiors_1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/jte_interiors_2.ytyp'

client_scripts {
    'client.lua',
    'population.lua',
    'lifts/lifts_config.lua',
    'lifts/lifts.lua'
}

escrow_ignore {
    'lifts/lifts_config.lua',
}

dependency '/assetpacks'