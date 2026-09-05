fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'G&N_s Studio'
description 'Von Crastenburg Hotel - Rockford Hills Casino'
version '4.1.0'

this_is_a_map 'yes'

client_script 'rockfordhills_unload_blocker.lua'

dependencies {
    '/gameBuild:2189',
    'cfx_gn_von_hotel_rockford'
}

escrow_ignore {
    'rockfordhills_unload_blocker.lua',
    'stream/base/**/*',
    'stream/**/*.ytd'
}
dependency '/assetpacks'