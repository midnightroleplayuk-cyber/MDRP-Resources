fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood_multichar'
author 'Vinewood Studios'
version '1.0.0'
description 'Cinematic multicharacter with in-game scene editor, slot management and Discord role slots'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/utils.lua',
    'shared/poses.lua',
}

client_scripts {
    'client/bridge.lua',
    'client/camera.lua',
    'client/appearance.lua',
    'client/scene.lua',
    'client/open.lua',
    'client/freecam.lua',
    'client/editor.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/config_server.lua',
    'server/db.lua',
    'server/bridge.lua',
    'server/gangs.lua',
    'server/clothing.lua',
    'server/discord.lua',
    'server/slots.lua',
    'server/scenes.lua',
    'server/main.lua',
    'server/admin.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
    'web/img/*',
}

dependencies {
    'ox_lib',
    'oxmysql',
}
