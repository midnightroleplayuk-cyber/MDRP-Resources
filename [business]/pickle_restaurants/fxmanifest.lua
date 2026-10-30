fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Pickle Modifications'
description 'pickle_restaurants - fully in-game configurable restaurant system'
version '1.2.2'

shared_scripts {
    '@ox_lib/init.lua',
    'core/shared.lua',
    'bridge/**/shared.lua',
    'locales/locale.lua',
    'locales/translations/*.lua',
}

client_scripts {
    'bridge/**/client.lua',
    'core/client.lua',
    'modules/**/client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/**/server.lua',
    'core/server.lua',
    'modules/**/server.lua',
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/**/*',
    'html/brand.html', -- DUI page for the render-target brand texture
    'html/screens.html', -- DUI page for the menu / orders info screens (modules/screens)
    'html/quad.html', -- DUI page for the food image drawn inside a takeout box (modules/quad)
}

dependencies {
    'ox_lib',
    'oxmysql',
}

-- __INSTALL/ is operator paperwork, not runtime code: the item definitions to paste
-- into your inventory and the icons to drop in its image folder. Escrow would
-- otherwise encrypt the .lua files in there and hand the buyer a blob they can't
-- read — which is the one thing those files exist to be. Kept open.
--
-- bridge/ is the framework/inventory/target/phone adapter layer, and it is open for
-- the same reason: it is where a server's own setup has to be met. Every server runs
-- a different fork — a renamed inventory export, a phone whose custom-app API moved,
-- a bespoke permission check — and each bridge file is written to be edited (the
-- phone bridges literally say "add yours to this list"). Encrypted, the one thing a
-- buyer needs to change to make the resource work on their server would be the one
-- thing they can't open. Nothing here is gameplay logic; that all lives in modules/.
-- locales/ is TRANSLATION, which is the buyer's own words. Encrypted, a server that
-- doesn't run in English would be stuck with ours and no way to write its own — the
-- one file every non-English server has to open. The loader and _L() live here too;
-- neither is gameplay logic.
escrow_ignore {
    '__INSTALL/**',
    'bridge/**',
    'locales/**',
}
