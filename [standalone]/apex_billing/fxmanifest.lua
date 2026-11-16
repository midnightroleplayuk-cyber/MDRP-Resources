--[[
    Apex Scriptz — apex_billing
    Advanced billing / invoicing system for FiveM.
    Personal and society invoices, itemised line items, VAT,
    printer item required to issue, paper invoice item to view,
    inline animation, fully theme-able UI matching apex_banking.

    Compatible with ESX Legacy, QBCore, and QBox.
    Optional integrations: ox_inventory, ox_target, ox_lib,
    apex_notify, apex_banking, qb-target, qb-inventory.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'Advanced billing / invoicing system (personal + society)'
version     '1.2.1'

shared_scripts {
    'shared/config.lua',
    'shared/items.lua',
    'shared/framework.lua',
    'shared/utils.lua',
    'build/locales/en.lua',
    'build/locales/pt.lua',
    'build/locales/es.lua',
    'build/locales/fr.lua',
    'build/locales/de.lua',
    'build/locales/*.lua',
    'shared/integrations.lua',
}

client_scripts {
    'build/client/apex_lib.lua',
    'build/client/main.lua',
    'build/client/billing.lua',
    'build/client/printer.lua',
    'build/client/admin.lua',
    'build/client/invoice_item.lua',
    'build/client/exports.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'build/server/apex_lib.lua',
    'build/server/database.lua',
    'build/server/main.lua',
    'build/server/modules/invoices.lua',
    'build/server/modules/societies.lua',
    'build/server/modules/admin.lua',
    'build/server/exports.lua',
}

ui_page 'build/html/index.html'

files {
    'build/html/index.html',
    'build/html/css/*.css',
    'build/html/js/*.js',
    'build/html/img/*',
}

dependencies {
    '/server:5104',
    'oxmysql',
}

-- ═══════════════════════════════════════════════════════════
-- ESCROWED build.
-- Everything a server owner customises stays readable: the config,
-- the framework / integration bridges (notify, inventory, banking,
-- access rules), the locales, the NUI, the SQL and the README.
-- The billing engine (build/client, build/server) is protected.
-- ═══════════════════════════════════════════════════════════
escrow_ignore {
    'fxmanifest.lua',
    'README.md',
    'shared/config.lua',
    'shared/framework.lua',
    'shared/integrations.lua',
    'shared/items.lua',
    'shared/utils.lua',
    'build/locales/de.lua',
    'build/locales/en.lua',
    'build/locales/es.lua',
    'build/locales/fr.lua',
    'build/locales/pt.lua',
    'build/html/index.html',
    'build/html/css/style.css',
    'build/html/js/app.js',
    'sql/apex_billing.sql',
}

provide 'apex_billing'

dependency '/assetpacks'