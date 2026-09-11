--[[
    cDev Car Rental — resource manifest
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'cDev'
description 'Vehicle rental with test drive, rental agreement signature, and multi-framework support.'
version '1.1.0'

-- Asset Escrow: keep these paths editable for buyers (config, languages, install notes).
escrow_ignore {
    'config.lua',
    'locales/**',
    'install/**',
}

shared_scripts {
    'config.lua',
    'locales/*.lua',
}

client_scripts {
    'client/framework.lua',
    'client/ped.lua',
    'client/main.lua',
}

server_scripts {
    'server/framework.lua',
    'server/main.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'web/papers.html',
    'web/images/*.png',
    'web/images/image_map.json',
}

dependency '/assetpacks'