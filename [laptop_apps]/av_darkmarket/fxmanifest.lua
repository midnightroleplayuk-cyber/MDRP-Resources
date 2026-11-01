fx_version 'cerulean'
description 'AV Dark Market'
author 'Avilchiis'
version '2.0.0'
lua54 'yes'
games {
    'gta5'
}

ui_page 'ui/dist/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config/*.lua'
}

client_scripts {
    'client/**/*',
}

server_scripts {
    'server/**/*'
}

files {
    'ui/dist/index.html',
    'ui/dist/**/*',
    'icon.png'
}

escrow_ignore {
    'config/*.lua',
    'client/editable/*.lua',
    'server/editable/*.lua',
}

dependencies {
    "ox_lib",
    "av_laptop"
}

dependency '/assetpacks'