fx_version 'cerulean'
game 'gta5'

author 'HF1'
description 'Qbox flat 2D surface signs'
version '1.3.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}


client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'ox_lib',
    'oxmysql',
    'qbx_core'
}

files {
    'html/index.html',
    'html/images/*.png',
    'html/images/*.jpg',
    'html/images/*.jpeg',
    'html/images/*.webp',
    'html/images/*.gif'
}
