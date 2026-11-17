fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'RSVX_Garage'
author 'RSVX'
description 'Emergency services garage'
version '1.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@qbx_core/modules/lib.lua',
    'server.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
}

dependencies {
    'oxmysql',
    'ox_lib',
    'ox_target',
    'qbx_core',
}
