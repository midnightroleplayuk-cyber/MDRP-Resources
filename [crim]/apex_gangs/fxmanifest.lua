--[[
    Apex Scriptz — apex_gangs
    The most complete standalone Gang System on the market.

    Features at a glance:
      • Full in-game gang creation / editing / deletion (admin)
      • Member management (invite / kick / promote / demote / transfer)
      • Per-gang custom ranks + granular per-rank permissions
      • HQ + interaction points placed live with an in-world editor
      • Capturable territory (redzone-style barrier walls) with live contest
      • Standalone graffiti / tagging system (streamed scaleform fonts)
      • Gang levels + XP + unlockable upgrades
      • Shared safe/vault (society money) + shared garage
      • Scout + Raid operations against rival gangs with loot
      • Tasks system + gang medic
      • Discord webhook logs for every action
      • Live real-time sync of everything to every client
      • Multi-framework: ESX Legacy, QBCore, QBox (auto-detected at runtime)

    Compatible with ESX Legacy, QBCore, and QBox.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'The most complete standalone Gang System on the market'
version     '1.0.3'

-- Framework (ESX Legacy / QBCore / QBox) is AUTO-DETECTED at runtime.
-- You never need to edit a framework name; set Config.framework only to
-- force one when you run several cores at once.

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/framework.lua',
    'shared/utils.lua',
    'shared/locales/_loader.lua',
    'shared/locales/en.lua',
    'shared/locales/pt.lua',
    'shared/locales/es.lua',
    'shared/locales/fr.lua',
    'shared/locales/de.lua',
    'shared/integrations.lua',     -- OPEN plug-in points (edit freely)
}

client_scripts {
    'client/apex_lib.lua',
    'client/sounds.lua',
    'client/target.lua',
    'client/zones.lua',
    'client/turf.lua',
    'client/editor.lua',
    'client/graffiti.lua',
    'client/main.lua',
    'client/runtime.lua',
    'client/testmode.lua',
    'client/missions.lua',
    'client/interactions.lua',
    'client/mugshot.lua',
    'client/modules/members.lua',
    'client/modules/garage.lua',
    'client/modules/operations.lua',
    'client/modules/airdrop.lua',
    'client/exports.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/apex_lib.lua',
    'server/database.lua',
    'server/main.lua',
    'server/modules/gangs.lua',
    'server/modules/members.lua',
    'server/modules/ranks.lua',
    'server/modules/treasury.lua',
    'server/modules/zones.lua',
    'server/modules/turf.lua',
    'server/modules/graffiti.lua',
    'server/modules/progression.lua',
    'server/modules/operations.lua',
    'server/modules/airdrop.lua',
    'server/modules/tasks.lua',
    'server/modules/garage.lua',
    'server/modules/medic.lua',
    'server/modules/players.lua',
    'server/modules/interactions.lua',
    'server/modules/logs.lua',
    'server/exports.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/dui_image.html',     -- transparent DUI surface for image graffiti
    'html/css/*.css',
    'html/js/*.js',
    'html/img/*',
    -- Drop-in custom graffiti images (PNG). Add a PNG here + a catalogue
    -- entry in Config.graffiti.images and it sprays as a flat wall image.
    'html/images/*.png',
    -- TEXT-mode graffiti scaleform fonts (ported from sa_spray, streamed).
    -- IMAGE-mode sprays use DUI runtime textures + DrawSpritePoly (no .gfx) —
    -- custom scaleform .gfx crash RequestScaleformMovie on recent builds, so
    -- the MF image .gfx were dropped entirely.
    'stream/graffiti1.gfx',
    'stream/graffiti2.gfx',
    'stream/graffiti3.gfx',
    'stream/graffiti4.gfx',
    'stream/graffiti5.gfx',
    -- Gang map blip-info images (territories on the main map; optional blip_info).
    'stream/jobs.ytd',
}

dependencies {
    '/server:5181',
    'oxmysql',
}

-- ═══════════════════════════════════════════════════════════
-- ESCROWED BUILD. Only the files listed below stay readable on
-- the customer server: the whole config, the framework bridge,
-- the integration hooks, every locale, the NUI and the SQL.
-- Everything under client/ and server/ is the build itself and
-- is sealed by the Cfx portal.
-- ═══════════════════════════════════════════════════════════
escrow_ignore {
    'shared/*.lua',
    'shared/locales/*.lua',
    'html/index.html',
    'html/dui_image.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/img/*',
    'html/images/*.png',
    'stream/*.gfx',
    '[SQL]/*',
    'installation/*',
    'README.md',
    'LICENSE',
}

provide 'apex_gangs'

dependency '/assetpacks'
dependency '/assetpacks'