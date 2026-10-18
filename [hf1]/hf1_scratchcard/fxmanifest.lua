fx_version 'cerulean'
game 'gta5'

name 'hf1_scratchcard'
author 'HF1'
description 'OX Supported Scratchcard System'
version '2.3.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/fingers-crossed.png'
}

dependencies {
    'qbx_core',
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'oxmysql'
}
