fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood-moj'
author 'Vinewood Studios'
description 'Ministry of Justice: courts, sentencing, prison, probation, unpaid work, court bail and warrants. Links with vinewood-mdt.'
version '1.2.0'

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
    'server/webhooks.lua',
    'server/licences.lua',
    'server/util.lua',
    'server/mdt.lua',
    'server/warrants.lua',
    'server/fines.lua',
    'server/prisons.lua',
    'server/prison.lua',
    'server/orders.lua',
    'server/sentence.lua',
    'server/cases.lua',
    'server/autocourt.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua',
    'client/prison.lua',
    'client/unpaidwork.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js'
}

dependencies {
    '/onesync',     -- curfew and exclusion checks read player positions on the server
    'ox_lib',
    'oxmysql'
}

-- Asset Escrow: every .lua file is encrypted except the ones below, which buyers edit.
-- Web files (HTML/CSS/JS), SQL and README are never encrypted.
escrow_ignore {
    'config.lua',              -- all settings and hooks (prison script, custom jail, notifications)
    'sentencing.lua',          -- offence ranges, factors and auto-court sentencing rules
    'server/sv_config.lua',    -- Discord webhooks (server only)
    'bridge/server.lua',       -- framework bridge, for custom frameworks
    'server/licences.lua',     -- driving licence adapters
    'server/prisons.lua'       -- prison script adapters (rcore, pickle, wasabi, your own)
}

dependency '/assetpacks'