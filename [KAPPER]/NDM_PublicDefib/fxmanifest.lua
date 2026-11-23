fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'NDM_PublicDefib'
description 'Public access defibrillators around the city, usable by civilians when no medics are on duty'
author 'NDM Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_script 'client/main.lua'

server_scripts {
    'server/webhooks.lua',
    'server/main.lua',
}

dependencies {
    'ox_lib',
    'ox_target',
    'qbx_core',
}
