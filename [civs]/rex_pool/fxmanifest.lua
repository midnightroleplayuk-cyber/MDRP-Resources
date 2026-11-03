fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rex_pool'
author 'Rex Studio - rex-studio.com'
description 'Rex Pool: synced billiards with a deterministic physics engine (8-ball, 9-ball, straight pool, free table)'
version '1.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/locale.lua',
    'locales/*.lua',
    'shared/physics.lua',
    'shared/tables.lua',
    'shared/rack.lua',
    'shared/rules.lua',
    'shared/calibration.lua',
}

client_scripts {
    'bridge/client.lua',
    'client/state.lua',
    'client/nui.lua',
    'client/localview.lua',
    'client/camera.lua',
    'client/hud.lua',
    'client/render.lua',
    'client/playback.lua',
    'client/aim.lua',
    'client/session.lua',
    'client/admin.lua',
    'client/calibrate.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server.lua',
    'server/logs.lua',
    'server/runtime.lua',
    'server/economy.lua',
    'server/db.lua',
    'server/sessions.lua',
    'server/admin.lua',
    'server/calibration.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/audio.js',
    'html/fonts/*.woff2',
}

-- Readable after Cfx escrow encryption (html/ is never encrypted).
escrow_ignore {
    'config.lua',
    'locales/*.lua',
    'bridge/*.lua',
    'install/*',
    'data/calibration.json', -- written in game by /poolcalibrate (SaveResourceFile)
}

dependencies {
    '/onesync',
    'ox_lib',
}

dependency '/assetpacks'