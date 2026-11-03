fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rex_darts'
author 'Rex Studio - rex-studio.com'
description 'Rex Darts: synced darts on vanilla boards (301, 501, Around the Clock, Cricket) with bets, scoreboard and stats'
version '1.0.3'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/locale.lua',
    'locales/*.lua',
    'shared/board.lua',
    'shared/checkout.lua',
    'shared/rules.lua',
}

client_scripts {
    'bridge/client.lua',
    'client/nui.lua',
    'client/boards.lua',
    'client/camera.lua',
    'client/handdart.lua',
    'client/render.lua',
    'client/throw.lua',
    'client/game.lua',
    'client/placement.lua',
    'client/calibrate.lua',
    'client/handtune.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server.lua',
    'server/db.lua',
    'server/boards.lua',
    'server/match.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/img/logo.png',
    'html/fonts/*.woff2',
}

-- Readable after Cfx escrow encryption (html/ is never encrypted).
escrow_ignore {
    'config.lua',
    'locales/*.lua',
    'bridge/*.lua',
    'install/*',
    'data/calibration.json',
}

dependencies {
    '/onesync',
    'ox_lib',
    'oxmysql',
}

dependency '/assetpacks'