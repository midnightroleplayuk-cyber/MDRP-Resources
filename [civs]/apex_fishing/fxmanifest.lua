--[[
    Apex Scriptz — apex_fishing
    Advanced standalone fishing system for FiveM with custom NUI,
    progression, leaderboards, upgrades, boat rental and full
    localisation support.

    Compatible with ESX Legacy, QBCore, and QBox.
    Required: oxmysql, ox_lib (optional but recommended for notify).
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'Advanced fishing — progression, upgrades, leaderboard, boats, localised, ESX/QB/QBX'
version     '2.0.2'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/locales/_loader.lua',
    'shared/locales/en.lua',
    'shared/locales/pt.lua',
    'shared/locales/es.lua',
    'shared/locales/fr.lua',
    'shared/locales/de.lua',
}

client_scripts {
    'client/apex_lib.lua',
    'client/sounds.lua',
    'client/zones.lua',
    'client/conditions.lua',
    'client/ui.lua',
    'client/fishing.lua',
    'client/main.lua',
    'client/exports.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'server/exports.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/app.js',
}

dependencies {
    'oxmysql',
}

-- Auto-detects ESX Legacy / QBCore / QBX at runtime — no config
-- changes needed when switching frameworks.

-- ─── ESCROW IGNORE ──────────────────────────────────────
-- Files listed here STAY open-source on the escrowed build, so
-- buyers can keep editing config, locales and the entire NUI.
escrow_ignore {
    'shared/config.lua',
    'shared/locales/_loader.lua',
    'shared/locales/en.lua',
    'shared/locales/pt.lua',
    'shared/locales/es.lua',
    'shared/locales/fr.lua',
    'shared/locales/de.lua',
    'shared/locales/*.lua',
    'html/index.html',
    'html/css/style.css',
    'html/js/app.js',
    'html/**/*',
    'README.md',
    'installation/items.md',
    --     'client/apex_lib.lua',
    -- 'client/sounds.lua',
    -- 'client/zones.lua',
    -- 'client/conditions.lua',
    -- 'client/ui.lua',
    -- 'client/fishing.lua',
    -- 'client/main.lua',
    -- 'client/exports.lua',
    --     'server/server.lua',
    -- 'server/exports.lua',
}

provide 'apex_fishing'

dependency '/assetpacks'