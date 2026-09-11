fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'T&N Modification'
description 'Advanced Car Rental Script'
version '1.1.1'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'locales/*.lua',   
    'config.lua'
}

client_scripts {
    'bridge/target/client.lua',
    'bridge/keys/client.lua',
    'bridge/inventory/client.lua',
    'client.lua'
}


server_scripts {
    'bridge/framework/server.lua',
    'bridge/inventory/server.lua',
    'bridge/keys/server.lua',
    'server.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/logos/*.png',
    'html/img/logos/*.jpg',
    'html/img/logos/*.webp',
    'html/img/vehicles/*.png',
    'html/img/vehicles/*.jpg',
    'html/img/vehicles/*.webp'
}

escrow_ignore {
    'config.lua',
    'locales/en.lua',
    'locales/de.lua',
    'bridge/framework/server.lua',
    'bridge/inventory/server.lua',
    'bridge/keys/server.lua',
    'bridge/keys/client.lua',
    'bridge/target/client.lua',
    'fxmanifest.lua'
}
dependency '/assetpacks'