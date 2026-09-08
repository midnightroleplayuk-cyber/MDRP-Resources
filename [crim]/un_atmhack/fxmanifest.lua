fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name 'un_atmhack'
author 'RoopeTv'
description 'Standalone ATM hacking resource with config, locales and Discord logs'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'locales/locale.lua'
}

client_scripts {
    'client/utils.lua',
    'client/main.lua'
}

server_scripts {
    'server/inventory.lua',
    'server/bridge/*.lua',
    'server/dispatch.lua',
    'server/main.lua'
}

files {
    'locales/*.json'
}

escrow_ignore {
    'shared/config.lua',
    'server/dispatch.lua',
    'locales/locale.lua',
    'client/utils.lua'
}

dependencies {
    'ox_lib'
}

dependency '/assetpacks'