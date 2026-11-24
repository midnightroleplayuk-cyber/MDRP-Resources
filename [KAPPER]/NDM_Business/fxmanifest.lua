fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'NDM_Business'
author 'NDM Network (modified from Pickle Mods resources, see NOTICE.md)'
description 'Unified restaurants, clubs and player-owned businesses'
version '0.1.0'

shared_scripts {
    '@ox_lib/init.lua',
    'core/shared.lua',
    'config/supply.lua',
    'config/business.lua',
    'config/crafting.lua',
    'config/club.lua',
    'config/props.lua',
}

client_scripts {
    'modules/management/client.lua',
    'modules/points/client.lua',
    'modules/supply/client.lua',
    'modules/register/client.lua',
    'modules/ownership/client.lua',
    'modules/crafting/client.lua',
    'modules/club/client.lua',
    'modules/dining/client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server.lua',
    'core/db.lua',
    'core/venues.lua',
    'core/money.lua',
    'core/commands.lua',
    'modules/points/server.lua',
    'modules/supply/server.lua',
    'modules/register/server.lua',
    'modules/ownership/server.lua',
    'modules/crafting/server.lua',
    'modules/club/server.lua',
    'modules/dining/server.lua',
    'modules/management/server.lua',
    'core/server.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/register.js',
}

dependencies {
    'ox_lib',
    'oxmysql',
    'qbx_core',
    'ox_inventory',
    'ox_target',
    'apex_banking',
    'NDM_Business_assets',
}
