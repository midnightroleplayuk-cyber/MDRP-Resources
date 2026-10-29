fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Midnight Constabulary'
author 'Keith Pinch'
description 'Midnight Constabulary complaints form'
version '1.1.0'

dependencies {
    'ox_lib',
    'ox_target',
    'oxmysql',
    'qbx_core'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/mpd-logo.png'
}
