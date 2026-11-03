fx_version 'cerulean'
description 'AV Groups'
author 'Avilchiis'
version '1.0.0'
lua54 'yes'
games {
    'gta5'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config/*.lua'
}

server_scripts {
    'server/**/*'
}

escrow_ignore {
    'config/*.lua',
}

dependencies {
    "ox_lib",
    "av_laptop"
}

dependency '/assetpacks'