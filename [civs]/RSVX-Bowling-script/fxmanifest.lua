fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'RSVX_Bowling'
author 'RSVX'
description 'Ten-pin bowling for Qbox'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/en.lua',
    'shared/physics.lua',
    'shared/scoring.lua',
}

client_scripts {
    'client/main.lua',
    'client/machine.lua',
    'client/replay.lua',
    'client/throw.lua',
    'client/screen.lua',
    'client/admin.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/framework.lua',
    'server/stats.lua',
    'server/main.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
    'web/logo.png',
}

dependencies {
    'ox_lib',
    'ox_target',
    'oxmysql',
    'qbx_core',
}
