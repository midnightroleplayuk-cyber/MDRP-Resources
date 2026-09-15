fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Jaxwhite'
description '24/7 store robbery with clerk reactions, six built-in minigames, crew support and prep system'
version '1.0.1'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
    'shared/locale.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'locales/*.json',
}

escrow_ignore {
    'config.lua',
    'locales/*.json',
    'sql/*.sql',
}

dependency '/assetpacks'