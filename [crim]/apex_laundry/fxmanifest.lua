--[[
    Apex Scriptz — apex_laundry
    Standalone money-laundering machines: deposit cleaning supplies,
    feed in dirty money, wait out the wash cycle, then collect the
    laundered cash minus a configurable tax. Machines can be upgraded
    for more capacity and faster washes. Persisted in oxmysql — every
    in-progress wash survives a restart.

    Compatible with ESX Legacy, QBCore, and QBox (auto-detected at
    runtime — no config change needed).
    Optional integrations: ox_inventory, ox_target, ox_lib, apex_notify,
    qb-target, qb-inventory, qs-inventory, mythic_notify, okokNotify.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'Standalone money-laundering machines (cleaners, washes, upgrades)'
version     '1.0.0'

shared_scripts {
    'shared/config.lua',
    'shared/framework.lua',
    'shared/utils.lua',
    'build/locales/en.lua',
    'build/locales/pt.lua',
    'build/locales/es.lua',
    'build/locales/fr.lua',
    'build/locales/de.lua',
    'build/locales/*.lua',
    'shared/integrations.lua',     -- OPEN-SOURCE plug-in points (edit freely)
}

client_scripts {
    'build/client/apex_lib.lua',
    'build/client/target.lua',
    'build/client/zones.lua',
    'build/client/ui.lua',
    'build/client/main.lua',
    'build/client/creator.lua',
    'build/client/exports.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'build/server/apex_lib.lua',
    'build/server/database.lua',
    'build/server/main.lua',
    'build/server/modules/laundry.lua',
    'build/server/modules/creator.lua',
    'build/server/exports.lua',
}

ui_page 'build/html/index.html'

files {
    'build/html/index.html',
    'build/html/css/*.css',
    'build/html/js/*.js',
}

dependencies {
    'oxmysql',
}

-- All framework + integration providers (ESX / QBCore / QBox,
-- ox_inventory / qb-inventory, ox_target / qb-target, notify
-- resources) are auto-detected at runtime via GetResourceState().
-- Force a specific one in shared/config.lua if you run several.

-- Everything below stays OPEN SOURCE even in an escrowed build.
-- Edit shared/* + locales + the NUI freely without breaking escrow.
escrow_ignore {
    'shared/config.lua',
    'shared/framework.lua',
    'shared/integrations.lua',
    'shared/utils.lua',
    'build/locales/*.lua',
    'build/html/**/*',
    'README.md',
    'installation/items.md',
}

provide 'apex_laundry'

dependency '/assetpacks'