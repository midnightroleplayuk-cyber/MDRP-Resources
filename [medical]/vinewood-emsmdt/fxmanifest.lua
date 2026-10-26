fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood-emsmdt'
author 'Vinewood Studios'
description 'Ambulance service MDT: incidents, ePRFs, patient records, admissions, training and police injury reports'
version '1.5.1'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/clinical.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/bridge.lua',
    'server/db.lua',
    'server/dispatch.lua',
    'server/vitals.lua',
    'server/main.lua',
    'server/training.lua',
    'server/exports.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
    'web/img/*',
}

dependencies {
    '/assetpacks',
    'ox_lib',
    'oxmysql',
}

-- Left open so buyers can configure and adapt the script. Everything else is escrowed.
escrow_ignore {
    'config.lua',             -- all settings, branding, ranks, formulary, webhooks
    'server/bridge.lua',      -- framework and inventory bridge
    'server/dispatch.lua',    -- dispatch script adapters
    'server/vitals.lua',      -- medical script (OSP Ambulance V2) vitals mapping
    'sql/*.sql',
    'README.md',
}

dependency '/assetpacks'