fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'apex_adminmenu'
description 'Apex Admin Menu — in-game quick menu + full admin panel (ESX / QBCore / QBox)'
author 'Apex Scripts'
version     '2.2.15'
repository 'https://apexscripts.xyz'

-- ───────────────────────────────────────────────────────────
-- Load order matters:
--   1. strings.lua  — canonical ENGLISH key list
--   2. locales/*    — Locales[code] overlays
--   3. config.lua   — names the active locale
--   4. locale.lua   — merges the chosen overlay onto Strings
--   5. compat.lua   — third-party resource auto-detection
-- ───────────────────────────────────────────────────────────
shared_scripts {
    'configs/strings.lua',
    'locales/ar.lua',
    'locales/cs.lua',
    'locales/da.lua',
    'locales/de.lua',
    'locales/el.lua',
    'locales/en.lua',
    'locales/es.lua',
    'locales/fi.lua',
    'locales/fr.lua',
    'locales/hu.lua',
    'locales/it.lua',
    'locales/ja.lua',
    'locales/ko.lua',
    'locales/nl.lua',
    'locales/no.lua',
    'locales/pl.lua',
    'locales/pt-br.lua',
    'locales/pt.lua',
    'locales/ro.lua',
    'locales/ru.lua',
    'locales/sk.lua',
    'locales/sv.lua',
    'locales/tr.lua',
    'locales/uk.lua',
    'locales/zh.lua',
    'locales/zz_panel_locales.lua',
    'configs/config.lua',
    'configs/locale.lua',
    'configs/compat.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'bridge/**/client.lua',
    'configs/peds.lua',
    'configs/modifyme.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/**/server.lua',
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js',
    'html/admin/index.html',
    'html/admin/styles.css',
    'html/admin/app.js',

    -- Custom vehicle thumbnails — see html/images/README.txt.
    -- FiveM only serves files that existed when the resource started,
    -- so restart after dropping new pictures in.
    'html/images/*.png',
    'html/images/*.jpg',
    'html/images/*.jpeg',
    'html/images/*.webp'
}

-- ───────────────────────────────────────────────────────────
-- Dependencies
--   oxmysql  — required (staff, bans, warnings, jails, logs, blips…)
--   ox_lib   — required, loaded above through @ox_lib/init.lua
--
-- ox_lib is listed here as well as being pulled in by @ox_lib/init.lua.
-- Without it the resource still "starts" and then dies inside that
-- include, which reads as "apex_adminmenu is broken" instead of "ox_lib
-- is missing". Naming it makes FiveM say which piece is actually absent.
--
-- Both must be STARTED FIRST. In server.cfg that means the ensure lines
-- for oxmysql and ox_lib have to come BEFORE apex_adminmenu — a category
-- ensure (`ensure [standalone]`) that happens to run later is the usual
-- reason a working install suddenly "won't start".
--
-- OPTIONAL (soft): screenshot-basic. Every call site checks
-- GetResourceState('screenshot-basic') first, so the resource starts
-- and runs perfectly without it — only the report screenshot and the
-- staff face shot are unavailable. Watch screen captures through our
-- own NUI and only falls back to it.
-- ───────────────────────────────────────────────────────────
dependencies { 'oxmysql', 'ox_lib' }

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