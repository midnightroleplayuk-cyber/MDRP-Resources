--[[
    Apex Scriptz - apex_mdt
    Dual-mode Mobile Data Terminal: a single in-game tablet that loads
    a POLICE MDT or an EMS/Hospital MDT automatically from the player's
    job. Live CAD dispatch, citizen/patient records, vehicle registry,
    reports, warrants, BOLOs, penal code + sentence calculator, citations,
    evidence, booking, triage/vitals, beds, surgery, pharmacy, billing,
    morgue, roster, comms, live Leaflet map, audit logging, Discord push.

    Every feature is a Config.features on/off toggle.

    Compatible with ESX Legacy, QBCore, and QBox.
    Required: oxmysql. Optional: ox_lib / apex_notify (notifications).
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'Dual-mode Police + EMS MDT tablet - CAD, records, warrants, triage, live map, ESX/QB/QBX'
version     '1.2.4'

-- ⚠⚠ ox_lib is NOT loaded here on purpose.
--
-- It used to be the first shared_script, which makes it a HARD requirement:
-- a server without ox_lib fails to start this resource at all, and the whole
-- MDT is dead before a single line of its own code runs. The description two
-- paragraphs up has always called ox_lib optional, and the code agrees with
-- the description: client/apex_lib.lua uses it for notifications behind
-- `if lib and lib.notify`, and falls back to the native notification when it
-- is absent. Two calls are not worth a dependency that can stop the resource
-- from loading.
--
-- A server that HAS ox_lib still gets ox_lib notifications. ox_lib registers
-- `ox_lib:notify` as a net event (resource/interface/client/notify.lua), and
-- client/apex_lib.lua triggers that event when ox_lib is running, which is
-- the same toast without the hard load.
shared_scripts {
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
    'client/ui.lua',
    'client/dispatch.lua',
    'client/cctv.lua',
    'client/bodycam.lua',
    'client/main.lua',
    'client/exports.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/aa_sqlnull.lua',   -- nil query parameters -> NULL (must load right after MySQL.lua)
    'server/server.lua',
    'server/exports.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/app.js',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/img/*.webp',
}

dependencies {
    'oxmysql',
}

provide 'apex_mdt'

-- ===========================================================================
-- OPEN SOURCE BUILD
-- Every single file is listed as ignored, so NOTHING is encrypted even when
-- this resource is uploaded through Keymaster: every Lua file, the whole NUI
-- and all the tooling stay readable and editable.
--
-- This escrow_ignore block is the ONLY difference between this zip and the
-- escrowed one. Every other file in the two is byte for byte identical.
-- ===========================================================================
escrow_ignore {
    '*',
    '**/*',
}

dependency '/assetpacks'

dependency '/assetpacks'