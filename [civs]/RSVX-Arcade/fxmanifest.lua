fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'RSVX_Arcade'
author 'RSVX'
description 'Placeable, playable arcade machines'
version '1.4.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/physical.lua',
    'client/main.lua',
    'client/placement.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
    'web/games/*.js',
    'web/board.html',
    'stream/rsvx_arcade_props.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'stream/rsvx_arcade_props.ytyp'

dependencies {
    'qbx_core',
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'oxmysql',
}
