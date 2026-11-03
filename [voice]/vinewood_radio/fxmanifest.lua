fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood_radio'
author 'Vinewood Studios'
description 'British-style TETRA emergency services radio (talkgroups, PTP individual calls, emergency button)'
version '1.1.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'bridge/client.lua',
    'client/effects.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server.lua',
    'server/db.lua',
    'server/hooks.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/civ.css',
    'html/civ.js',
    'html/img/*.png',
    'html/sounds/*.wav',
}

-- Custom radio props: put .ydr + .ytyp in stream/ and uncomment this
-- data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

dependencies {
    'ox_lib',
    'oxmysql',
    'pma-voice',
}

escrow_ignore {
    'install/**',
    'config.lua',
    'client/effects.lua',
    'server/hooks.lua',
    'bridge/*.lua',
}
