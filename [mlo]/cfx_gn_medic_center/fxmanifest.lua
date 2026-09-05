lua54 'yes'
fx_version 'cerulean'
game 'gta5'

author 'G&N_s Studio'
description 'Medic_Center'
version '4.1.0'

this_is_a_map 'yes'

dependencies {
    '/gameBuild:2189',
    'cfx_gn_collection',
    'cfx_gn_ambulance_garage'
}

client_script 'main.lua'

escrow_ignore {
    'stream/**/*.ytd',
    'stream/lsmc/*.ydr',
    'stream/lsmc/*.ymap',
    'stream/pillbox/*.ydr',
    'stream/pillbox/*.ymap',
    'main.lua'
}
dependency '/assetpacks'