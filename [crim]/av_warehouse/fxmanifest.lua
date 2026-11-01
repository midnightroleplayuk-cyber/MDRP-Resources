fx_version 'cerulean'
description 'AV Warehouse'
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

client_scripts {
    'client/**/*',
}

server_scripts {
    'server/**/*'
}

escrow_ignore {
    'config/*.lua',
    'client/editable/*.lua',
    'server/editable/*.lua',
}

dependencies {
    "ox_lib",
}
dependency '/assetpacks'