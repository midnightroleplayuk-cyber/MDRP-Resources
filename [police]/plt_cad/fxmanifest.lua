fx_version 'cerulean'
game 'gta5'

description 'Police CAD using 3D NUI'
author 'Pluto Development'
version '1.0.0'

shared_script 'config.lua'


client_scripts {
    'client/lib_3dnui.lua',
    'client/main.lua',
    'client/light.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/light.lua'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/app.js',
    'assets/cursor.png',
    'stream/police_laptop.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/police_laptop.ytyp'

lua54 'yes'

escrow_ignore {
    'config.lua'
}


dependency '/assetpacks'