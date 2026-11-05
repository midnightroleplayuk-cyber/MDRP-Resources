fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood_firealarm'
author 'Vinewood Studios'
description 'British-style addressable fire alarm systems for businesses'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/placement.lua',
    'client/main.lua',
    'client/admin.lua',
    'client/screen.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/bridge.lua',
    'server/dispatch.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/screen.html',
    'html/sounds/*.ogg',
}

data_file 'DLC_ITYP_REQUEST' 'stream/firealarm_props.ytyp'

dependencies {
    'ox_lib',
    'ox_target',
    'oxmysql',
}
