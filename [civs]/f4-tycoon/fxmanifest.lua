fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'f4-tycoon'
author 'F4 Studio'
description 'F4 Tycoon: F4 City - a 3D city building board game for 2-4 players, AI opponents, optional stakes'
version '2.0.0'

shared_scripts {
    'config.lua',
    'locales/*.lua',
    'shared/locale.lua',
    'shared/hooks.lua',
    'shared/settings.lua',
    'shared/board.lua',
    'shared/cards.lua',
}

server_scripts {
    'server/open.lua',
    'server/game.lua',
    'server/bot.lua',
    'server/tables.lua',
}

client_scripts {
    'shared/dicesim.lua',
    'client/open.lua',
    'client/layout.lua',
    'client/nui.lua',
    'client/camera.lua',
    'client/dice.lua',
    'client/pieces.lua',
    'client/seat.lua',
    'client/main.lua',
}

ui_page 'web/dist/index.html'

files {
    'data/board.json',
    'data/layout.json',
    'web/dist/index.html',
    'web/dist/**/*',
}

-- Props made with blender/ (see blender/README.md): table, chairs, board, dice, tokens,
-- flags, houses and hotels in every token colour, the headline cards.
data_file 'DLC_ITYP_REQUEST' 'stream/tycoon/f4t_tycoon.ytyp'

--[[
    Escrow: everything is encrypted except the integration surface (the two open files),
    the server's own setup (config) and the translations.
]]
escrow_ignore {
    'config.lua',
    'locales/*.lua',
    'client/open.lua',
    'server/open.lua',
}

dependency '/assetpacks'

dependency '/assetpacks'