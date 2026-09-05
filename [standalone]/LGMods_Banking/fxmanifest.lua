fx_version 'cerulean'
game 'gta5'

author 'LG Liam - Lead Script Developer @ LGMods'
description 'LGMods_Banking'
version '1.1.1'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/sounds/cashpoint-beep.mp3',
    'html/images/logos/*.png',
    'html/images/*.png',
    'html/fonts/*.ttf'
}

shared_scripts {
    'config.lua',
   --'@es_extended/imports.lua' -- remove the 2 '--' from in front of this line if you use ESX.
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua',
    'exports.lua'
}

dependencies {
    'oxmysql'
}

escrow_ignore {
    'config.lua'
}

lua54 'yes'
dependency '/assetpacks'