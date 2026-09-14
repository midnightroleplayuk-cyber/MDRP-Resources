fx_version 'cerulean'
game 'gta5'

description 'PLT MDT - Unified Framework MDT'
author 'Pluto Development'
version '1.0.0'

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'web/img/*.png',
    'web/img/*.jpg'
}

shared_scripts {
    'shared/framework.lua',
    'shared/config.lua',
    'shared/access.lua',
    'shared/callbacks.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/citizen.lua',
    'server/vehicle.lua',
    'server/warrant.lua',
    'server/charge.lua',
    'server/dispatch.lua'
}

client_scripts {
    'client/main.lua',
    'client/citizen.lua',
    'client/vehicle.lua',
    'client/warrant.lua',
    'client/charge.lua',
    'client/dispatch.lua'
}

lua54 'yes'

escrow_ignore {
    'shared/config.lua',
    'shared/framework.lua',
    'shared/access.lua',
    'shared/callbacks.lua',
}

dependency 'oxmysql'

dependency '/assetpacks'