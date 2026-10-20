fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LG Mods'
description 'Westbridge Crown Court'
version '1.0.0'

this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/crown_court.ytyp'

client_scripts {
    'lifts/config.lua',   
    'lifts/client.lua',   
    'roads.lua',        
}

escrow_ignore {
    'lifts/config.lua',
}

dependency '/assetpacks'