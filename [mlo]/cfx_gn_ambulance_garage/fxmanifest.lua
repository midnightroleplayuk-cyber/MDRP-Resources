fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

author 'G&N_s Studio'
description 'Ambulance Garage - DLC'
version '4.1.1'

this_is_a_map 'yes'

dependencies {
    '/gameBuild:2189',
    'cfx_gn_collection'
}

client_script {
    'gn_amb_gar_entityset.lua'
}

escrow_ignore {
    'stream/**/*.ytd',
    'gn_amb_gar_entityset.lua'
}

dependency '/assetpacks'