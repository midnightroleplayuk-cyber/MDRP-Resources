fx_version 'cerulean'
author 'pinkfrog.io - froggy to Conor'
games { 'gta5' }

version '1.0.1'

shared_script {
    '@ox_lib/init.lua',
    'shared/config.lua',
}

client_script {
    'client/client.lua',
}

escrow_ignore {
    "shared/config.lua",
    "installation/ox_lib/resource/client.lua",
}

lua54 'yes'

dependency '/assetpacks'