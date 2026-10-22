fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rsvx_safe'
description 'Player-owned safes: buy, place, PIN-protect, store, pick up'
version '1.0.0'

dependencies {
    'ox_lib',
    'ox_inventory',
    'ox_target',
    'oxmysql',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

files { 'ui/rsvx_safe.png' }

client_script 'client/main.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}
