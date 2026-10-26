fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood-dispatch'
author 'Vinewood Studios'
description 'Police, ambulance and fire dispatch with live units, backup, call updates and callsigns'
version '1.5.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'bridge/client.lua',
    'client/utils.lua',
    'client/units.lua',
    'client/main.lua',
    'client/detections.lua',
}

server_scripts {
    'bridge/server.lua',
    'server/callsigns.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
}

dependencies {
    'ox_lib',
}

-- Left open for customers: settings, framework bridge and built-in detections.
-- Everything else is encrypted by the Cfx escrow.
escrow_ignore {
    'config.lua',
    'bridge/client.lua',
    'bridge/server.lua',
    'client/detections.lua',
}

dependency '/assetpacks'