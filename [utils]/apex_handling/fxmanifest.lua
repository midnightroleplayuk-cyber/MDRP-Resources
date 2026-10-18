--[[
    Apex Scriptz: apex_handling
    Apex Handling Studio: the most complete in-game handling
    editor for FiveM.

      · Advanced editor: every CHandlingData field, categorised,
        with sliders, scrub inputs, live apply and per-field reset
      · Simplified editor: 10 friendly sliders for fixing broken
        addon cars without knowing what fTractionCurveMax means
      · Visual flags editor: model/handling/damage/advanced flag
        bits as named checkboxes
      · Live telemetry: speed, RPM, gear, G-circle, per-wheel
        slip/traction while you drive
      · Timing tool: 0-100 / 0-200 / ¼-mile / 100-0 braking,
        also standalone via /handlingtiming (job-lockable)
      · Presets, profiles (file store, no DB), share codes
      · Live XML viewer + export to exports/<model>_handling.meta
      · WRITES straight into the vehicle resource's handling.meta
        (backup kept): tunes survive restarts and can be shipped
      · Statebag sync + persisted per-model server overrides

    Compatible with ESX Legacy, QBCore and QBox (standalone
    fallback included). Zero database. Plug and play.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'Apex Handling Studio: advanced in-game handling editor (live apply, flags, telemetry, timing, meta writer)'
version     '1.0.2'

-- Load order matters: utils.lua defines Utils.Log, which framework.lua
-- calls while detecting; validate.lua needs HandlingFieldByName from
-- fields.lua.
shared_scripts {
    'shared/config.lua',
    'shared/utils.lua',
    'shared/framework.lua',
    'shared/fields.lua',
    'shared/validate.lua',
    'shared/flags.lua',
    'shared/presets.lua',
    'locales/*.lua',
}

client_scripts {
    'client/apex_lib.lua',
    'client/editor.lua',
    'client/sync.lua',
    'client/telemetry.lua',
    'client/timing.lua',
    'client/main.lua',
}

server_scripts {
    'server/apex_lib.lua',
    'server/store.lua',
    'server/metawriter.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
}

-- Profiles/overrides/stocks persist to plain JSON files (data/),
-- XML exports land in exports/, no database, no setup.

-- --- ESCROW IGNORE ----------------------------------------
-- ESCROWED build. Sealed: client/ and server/ (the script build).
-- Left readable so the buyer can configure and translate:
-- shared/ (config, framework, fields, flags, presets, validate),
-- locales/, the whole NUI in html/, the data/ and exports/ folders
-- and the README.
escrow_ignore {
    'shared/*.lua',
    'locales/*.lua',
    'html/**/*',
    'data/**/*',
    'exports/**/*',
    'README.md',
    'LICENSE',
}

provide 'apex_handling'

dependency '/assetpacks'
dependency '/assetpacks'