fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood_firemdt'
author 'Vinewood Studios'
description 'UK Fire & Rescue Mobile Data Terminal'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/hazmat.lua',
    'shared/rescue.lua',
    'shared/sops.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/bridge.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/map.jpg',
}

dependencies {
    'ox_lib',
    'oxmysql',
}

escrow_ignore {
    'config.lua',
    'shared/hazmat.lua',
    'shared/rescue.lua',
    'shared/sops.lua',
    'server/bridge.lua',
}
