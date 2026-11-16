--[[
    Apex Scriptz: apex_banking
    Standalone advanced banking system: personal & business accounts,
    sub-accounts with shared permissions, IBAN transfers, debit cards,
    loans, savings, deposits/withdrawals, full transaction log, and
    a realistic ATM experience that requires an apex_atm_card item.

    Compatible with ESX Legacy, QBCore, and QBox.
    Optional integrations: ox_inventory, ox_target, ox_lib, apex_notify,
    qb-target, qb-inventory, qs-inventory, mythic_notify, okokNotify.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'Standalone advanced banking system (personal, business, ATM, loans)'
version     '2.3.4'

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
    'shared/integrations.lua',     -- OPEN-SOURCE plug-in points (edit freely)
    'atmdui/config.lua',           -- DUI ATM config (namespaced: AtmuiConfig)
}

client_scripts {
    'build/client/apex_lib.lua',
    'build/client/sounds.lua',
    'build/client/target.lua',
    'build/client/zones.lua',
    'build/client/main.lua',
    'build/client/atm.lua',        -- classic NUI ATM (only with Config.useDuiAtm = false)
    'build/client/placement.lua',
    'build/client/runtime.lua',
    'build/client/modules/banking.lua',
    'build/client/modules/cards.lua',
    'build/client/modules/transfer.lua',
    'build/client/modules/society.lua',
    'build/client/modules/vehiclefinance.lua',
    'build/client/modules/admin.lua',   -- /bankadmin panel (ATM props + server-wide colours)
    'build/client/exports.lua',
    -- ── DUI ATM (screen rendered on the ATM prop) ──
    'atmdui/client/store.lua',       -- calibration store (config + database, live)
    'atmdui/client/dui.lua',
    'atmdui/client/idle.lua',        -- welcome screen on every ATM prop in the world
    'atmdui/client/camera.lua',
    'atmdui/client/main.lua',
    'atmdui/client/calibrate.lua',   -- /apexatmcalibrate button-position editor
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'build/server/apex_lib.lua',
    'build/server/database.lua',
    'build/server/main.lua',
    'build/server/modules/accounts.lua',
    'build/server/modules/cards.lua',
    'build/server/modules/transactions.lua',
    'build/server/modules/transfer.lua',
    'build/server/modules/loans.lua',
    'build/server/modules/savings.lua',
    'build/server/modules/society.lua',
    'build/server/modules/iban.lua',
    'build/server/modules/business.lua',
    'build/server/modules/billing.lua',
    'build/server/modules/atms.lua',
    'build/server/modules/vehiclefinance.lua',
    'build/server/modules/admin.lua',   -- /bankadmin: feature toggles, accounts, stats
    'build/server/exports.lua',
    -- ── DUI ATM ──
    'atmdui/server/main.lua',
    'atmdui/server/calibrate.lua',   -- /apexatmcalibrate: saves to the database, syncs everyone
}

ui_page 'build/html/index.html'

files {
    'build/html/index.html',
    'build/html/css/*.css',
    'build/html/js/*.js',
    'build/html/img/*',
    'build/html/fonts/*.woff2',   -- Geist / Geist Mono (self-hosted, V2 UI)
    -- DUI ATM screen (rendered onto the ATM prop) + its sound
    'atmdui/html/index.html',
    'atmdui/html/*.css',
    'atmdui/html/*.js',
    'atmdui/html/*.ogg',
}

dependencies {
    '/server:5104',
    'oxmysql',
}

-- ─── ESCROWED BUILD ─────────────────────────────────────────
-- Everything listed here stays readable and editable after Keymaster
-- encryption: the config, the framework bridge and integration hooks,
-- all 5 languages, the whole bank NUI, the ATM screen and its config,
-- the SQL schema, the item image and the README. Only the client and
-- server Lua that makes up the build itself is protected.
--
-- One entry per file on purpose, never 'build/locales/*.lua': escrow
-- matches patterns literally and a globbed locale silently ships
-- ENCRYPTED. The .sql is listed twice for the same reason in reverse:
-- '[SQL]' reads as a character class in most matchers, so the literal
-- path can miss and '**/*.sql' is what actually catches it.
--
-- This block is the ONLY difference between this zip and the open source
-- one. Every other file in the two is byte for byte identical.
escrow_ignore {
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
    'build/html/css/style.css',
    'build/html/fonts/geist-latin.woff2',
    'build/html/fonts/geist-mono-latin.woff2',
    'build/html/img/README.txt',
    'build/html/index.html',
    'build/html/js/app.js',
    'atmdui/config.lua',
    'atmdui/html/app.js',
    'atmdui/html/dispenser.ogg',
    'atmdui/html/index.html',
    'atmdui/html/style.css',
    '[SQL]/apex_banking.sql',
    '**/*.sql',
    '[IMAGES]/apex_atm_receipt.png',
    '**/*.png',
    'README.md',
}

provide 'apex_banking'

dependency '/assetpacks'