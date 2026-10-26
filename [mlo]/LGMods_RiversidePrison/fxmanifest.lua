fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LGMods'
description 'LGMods_RiversidePrison - HMP Riverside (UK Victorian / modern prison, El Burro Heights)'
version '1.0.2'

this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/lgmods_riversideprison.ytyp'

shared_script 'config.lua'

client_scripts {
    'client/noai.lua',
    'intercom/client.lua'
}

server_scripts {
    'intercom/server.lua'
}

escrow_ignore {
    'config.lua'
}

dependency '/assetpacks'