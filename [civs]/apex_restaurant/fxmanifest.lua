--[[
    Apex Scriptz — apex_restaurant
    Standalone advanced restaurant management system with a blueprint-style
    node editor. No ox_lib / ox_target / ox_inventory dependency.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'Standalone restaurant management with node-based editor'
version     '2.1.1'

shared_scripts {
    'shared/config.lua',
    'shared/items.lua',
    'shared/framework.lua',
    'shared/utils.lua',
    'build/locales/en.lua',        -- base locale (always loaded first as the fallback)
    'build/locales/*.lua',         -- any extra locales the buyer drops in load automatically
    'shared/integrations.lua',     -- OPEN-SOURCE plug-in points (edit freely)
}

client_scripts {
    'build/client/apex_lib.lua',
    'build/client/target.lua',
    'build/client/zones.lua',
    'build/client/inventory.lua',
    'build/client/main.lua',
    'build/client/runtime.lua',
    'build/client/editor.lua',
    'build/client/modules/boss.lua',
    'build/client/modules/duty.lua',
    'build/client/modules/wardrobe.lua',
    'build/client/modules/register.lua',
    'build/client/modules/preparation.lua',
    'build/client/modules/station.lua',
    'build/client/modules/delivery.lua',
    'build/client/modules/menu_display.lua',
    'build/client/modules/npc_shop.lua',
    'build/client/modules/customer_shop.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'build/server/apex_lib.lua',
    'build/server/storage.lua',
    'build/server/database.lua',
    'build/server/main.lua',
    'build/server/inventory.lua',
    'build/server/editor.lua',
    'build/server/modules/boss.lua',
    'build/server/modules/duty.lua',
    'build/server/modules/register.lua',
    'build/server/modules/delivery.lua',
    'build/server/modules/preparation.lua',
    'build/server/modules/npc_shop.lua',
    'build/server/modules/menu_display.lua',
    'build/server/modules/wardrobe.lua',
    'build/server/modules/shop_stock.lua',
}

ui_page 'build/html/index.html'

files {
    'build/html/index.html',
    'build/html/css/*.css',
    'build/html/js/*.js',
    'build/html/img/*',
    -- Embedded apex_bossmenu command center (boss menu iframe)
    'build/html/boss/index.html',
    'build/html/boss/css/*.css',
    'build/html/boss/js/*.js',
    'data/restaurants.json',
}

dependencies {
    '/server:5104',
    'oxmysql',
}

-- ox_inventory is OPTIONAL — we auto-detect it at runtime via
-- GetResourceState() in build/server/inventory.lua.  If present we
-- route player-inventory calls through its exports; otherwise we
-- fall back to ESX / QB native APIs.

-- ═══════════════════════════════════════════════════════════
-- OPEN-SOURCE BUILD
-- EVERY file is listed in escrow_ignore, so the ENTIRE resource
-- stays open and editable. Nothing is protected by escrow.
-- ═══════════════════════════════════════════════════════════
escrow_ignore {
    -- Readable on purpose â€” everything a buyer legitimately needs to edit
    -- or install. The rest (build/client, build/server, build/html) is the
    -- product itself and stays protected.
    'shared/*.lua',           -- config, items, framework, utils, integrations
    'build/locales/*.lua',    -- translations (drop in your own)
    'install/*.lua',          -- item lists to paste into your inventory
    'data/*.json',            -- layout + theme, written at runtime
    '[IMAGES]/*',             -- item icons for your inventory resource
    '[SQL]/*',                -- database schema
    'README.MD',
}

dependency '/assetpacks'
dependency '/assetpacks'