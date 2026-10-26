fx_version 'cerulean'
game 'gta5'

name 'vinewood_licensing'
author 'Vinewood Studios'
version '2.0.3'
description 'Vinewood Licensing - UK DVLA style licensing for Qbox: theory, practical, provisional, photocard, points and bans'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

dependencies {
    'ox_lib',
    'oxmysql'
    -- frameworks: qbx_core, qb-core or es_extended (auto-detected)
    -- inventories: ox_inventory, qb-inventory, qs-inventory, core_inventory, codem-inventory
    -- optional: screenshot-basic (licence photos), ox_target or qb-target
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/locale.lua'
}

client_scripts {
    'bridge/client.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/framework.lua',
    'bridge/inventory.lua',
    'bridge/store.lua',
    'server/config.lua',
    'server/main.lua',
    'server/migrate.lua',
    'server/version.lua'
}

-- ---------------------------------------------------------------
--  Cfx asset escrow
--  Everything listed below stays readable and editable after the
--  asset is escrowed. Everything else is encrypted.
-- ---------------------------------------------------------------
escrow_ignore {
    'shared/config.lua',
    'bridge/*.lua',               -- framework/inventory adapters
    'shared/config.lua',          -- all settings, theory questions, test routes
    'server/config.lua',          -- Fivemanage API key
    'locales/*.json',             -- translations
    'web/css/config.css',         -- UI colours
    'EXPORTS.md',
    'MIGRATION.md',
    'INSTALL-driving_licence-item.txt'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/css/config.css',
    'web/css/style.css',
    'web/js/app.js',
    'web/assets/signs/*.png',
    'web/assets/signs/*.jpg',
    'web/assets/signs/*.jpeg',
    'web/assets/signs/*.svg',
    'web/assets/licence/*.png',
    'web/assets/licence/*.jpg',
    'web/assets/licence/*.jpeg',
    'web/assets/licence/*.svg',
    'locales/*.json'
}

dependency '/assetpacks'