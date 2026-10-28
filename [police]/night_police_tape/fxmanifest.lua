fx_version 'cerulean'
games { 'gta5' }

author 'Nights Software'
description 'Hang police tape between two anchor points'
version '1.1.0'
lua54 'yes'

shared_scripts {
    'config/config.lua',
    'locales/*.lua',
    'shared/locale.lua',
}

client_scripts {
    'client/c_functions.lua',
    'client/tape.lua',
    'client/stretch.lua',
    'client/binds.lua',
    'client/ui.lua',
    'client/restyle.lua',
    'client/placement.lua',
    'client/client.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/kit/*.css',
    'html/kit/*.js',
    'html/fonts/*.woff2',
    'html/fonts/Manrope-OFL.txt',
    'html/fonts/Tektur-OFL.txt',
    'html/tapes/*.jpg',
}

server_scripts {
    'server/s_functions.lua',
    'server/server.lua',
}

data_file 'DLC_ITYP_REQUEST' 'stream/ns_police_tape.ytyp'

escrow_ignore {
    'config/*.lua',
    'locales/*.lua',
    'client/c_functions.lua',
    'server/s_functions.lua',
}

dependency '/assetpacks'