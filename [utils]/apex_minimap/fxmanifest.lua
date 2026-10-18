--[[
    Apex Scriptz — apex_minimap
    Apex Minimap Studio: an in-game minimap designer.
    The full 4096×6144 map atlas (6 tiles of 2048px) on a
    zoomable canvas with layers — brush, text, shapes, fills,
    images, zone highlights and one-click restyle themes.
    Live in-game preview via runtime textures (radar + pause
    map update without any restart), project saving, and
    one-click export to a ready-to-drop minimap resource.

    Compatible with ESX Legacy, QBCore and QBox (standalone
    fallback included). No database required — projects and
    the live state persist to plain JSON in data/.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'In-game minimap designer (atlas canvas editor, live preview, export)'
version     '1.8.0'

shared_scripts {
    'shared/config.lua',
    'shared/utils.lua',
    'locales/en.lua',
    'locales/pt.lua',
    'locales/*.lua',
}

client_scripts {
    'client/apex_lib.lua',
    'client/main.lua',
    'client/livemap.lua',    -- runtime-texture live preview + "Live on Server"
}

server_scripts {
    'server/apex_lib.lua',
    'server/main.lua',
    'server/access.lua',     -- the five access methods + /..._access diagnostic
    'server/projects.lua',   -- zero-setup JSON file store (no oxmysql)
    'server/export.lua',
    'server/download.lua',   -- writes a real .png (CEF cannot download)
    'server/theme.lua',      -- server-wide appearance (GlobalState + disk)
    'server/ai_key.lua',     -- the assistant's key (server-only, never shipped to clients)
    'server/ai.lua',         -- the assistant proxy (the key never leaves the server)
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    -- UI typeface. Self-hosted on purpose: CEF ships neither Inter nor
    -- JetBrains Mono, so a CDN-only stack silently fell through to
    -- Segoe UI + Consolas in game (and to nothing at all offline).
    'html/fonts/*.woff2',
    -- Base map tiles the editor paints over, one folder per base map
    -- (extracted from the original .ytd files — regenerate with
    -- tools/extract_tiles.js). maps.json is the picker catalog.
    'html/tiles/maps.json',
    'html/tiles/**/*.png',
    -- Ready-made postal sets loaded on demand by the Postals tab
    -- (OCRP / New / Oulsen), keyed { code = { x, y } }.
    'html/postals/*.json',
    -- Real GTA blip sprites. Bundled (not fetched from docs.fivem.net) so the
    -- studio works offline AND a cross-origin image can never taint the
    -- export canvas. The id/name list itself ships as html/js/blipdata.js.
    'html/blips/**/*',
}

-- Projects + live tiles persist to plain JSON files (data/) — no
-- oxmysql, no SQL import, works out of the box on any server / OS.

-- Framework (es_extended / qb-core / qbx_core) is auto-detected
-- at runtime via GetResourceState() — no manual toggle needed.
-- Standalone servers work out of the box (ace permissions).

-- O que fica ABERTO num build escrowed. Tudo o resto — client/*.lua,
-- server/*.lua e a NUI (index.html, css, js) — é a BUILD do script e vai
-- encriptado. Aqui só entra o que o dono do servidor precisa mesmo de
-- ler ou editar, e os dados/ferramentas que deixariam de funcionar se
-- fossem cifrados (o Node do make_ytd corre a partir do disco).
escrow_ignore {
    'shared/*.lua',          -- config + utils: para afinar sem partir o escrow
    'locales/*.lua',         -- traduções
    'server/ai_key.lua',     -- a chave do assistente TEM de ser editável
    'tools/**/*',            -- os scripts Node que o dono corre à mão
    'templates/**/*',        -- .ytd/.gfx que o build usa como molde
    'html/tiles/**/*',       -- PNGs dos mapas base
    'html/blips/**/*',       -- sprites de blips
    'html/postals/*.json',   -- conjuntos de postais
    'html/fonts/*.woff2',    -- tipografia
    'README.md',
}

provide 'apex_minimap'

dependency '/assetpacks'