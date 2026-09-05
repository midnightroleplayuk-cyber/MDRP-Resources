fx_version 'cerulean'
game 'gta5'

name 'LG_Dispatch'
description 'LG_Dispatch'
author 'LG Liam - Lead Script Developer @ LGMods'
version '1.0.2'

shared_scripts {
    'config.lua',
}

client_scripts {
    'bridge/client.lua',
    'client/main.lua',
}

server_scripts {
    'bridge/server.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/*.png',
    'html/*.jpg',
}

escrow_ignore {
    'config.lua'
}

lua54 'yes'

dependency '/assetpacks'