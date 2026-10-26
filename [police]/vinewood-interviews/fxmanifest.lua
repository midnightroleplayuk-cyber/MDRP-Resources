fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood-interviews'
author 'Vinewood Studios'
description 'Police interview recording: audio, officer-seat CCTV footage and CCTV replay on Fivemanage, interview seats and an evidence viewer'
version '1.8.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'editable/client.lua',
    'bridge/client.lua',
    'bridge/target.lua',
    'client/main.lua',
    'client/camera.lua',
    'client/recorder.lua',
    'client/tracker.lua',
    'client/replay.lua',
    'client/seats.lua',
    'client/admin.lua',
    'client/viewer.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'editable/server.lua',
    'bridge/server.lua',
    'server/storage.lua',
    'server/discord.lua',
    'server/main.lua',
}

-- Cfx Asset Escrow: everything not listed here is encrypted on upload.
-- Config, framework bridge and the editable hooks stay open so buyers can adapt them.
escrow_ignore {
    'config.lua',
    'bridge/*.lua',
    'editable/*.lua',
    'sql/*.sql',
    'README.md',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
}

dependencies {
    'ox_lib',
    'oxmysql',
}

dependency '/assetpacks'