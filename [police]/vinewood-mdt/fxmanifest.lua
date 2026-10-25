fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood-mdt'
author 'Vinewood Studios'
description 'British police MDT: PNC checks, DVLA licences, custody and bail, CPS, ANPR, stop and search, fines, statements, interview playback and court results (vinewood-moj)'
version '2.16.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'sentencing.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_config.lua',
    'bridge/server.lua',
    'server/schema.lua',
    'server/licences.lua',
    'server/housing.lua',
    'server/interviews.lua',
    'server/dispatch.lua',
    'server/vehicleservices.lua',
    'server/ems.lua',
    'server/prison.lua',
    'server/inventory.lua',
    'server/moj.lua',
    'server/webhooks.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua',
    'client/anpr.lua',
    'client/forensics.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
    'web/pdlogo.png'
}

dependencies {
    '/onesync',     -- server reads player positions (ANPR, people nearby, custody photos)
    'ox_lib',
    'oxmysql'
}

-- Asset Escrow: every .lua file is encrypted except the ones below, which buyers edit.
-- Web files (HTML/CSS/JS), SQL and README are never encrypted.
escrow_ignore {
    'config.lua',              -- all settings and hooks (OnBailGranted, OnPaid, custom licence/housing)
    'sentencing.lua',          -- sentencing ranges and factors
    'server/sv_config.lua',    -- Fivemanage key and Discord webhooks (server only)
    'bridge/server.lua',       -- framework bridge, for custom frameworks
    'server/licences.lua',     -- licence script adapters
    'server/housing.lua',      -- housing script adapters
    'server/prison.lua',       -- prison script adapters (remand)
    'server/inventory.lua'     -- inventory adapters (evidence bags)
}

dependency '/assetpacks'
