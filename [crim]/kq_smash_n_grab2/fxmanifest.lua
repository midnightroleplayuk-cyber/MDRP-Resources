fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'KuzQuality | Kuzkay'
description 'Smash \'n grab by KuzQuality'
version '2.0.2'

shared_scripts {
    'config.lua',
    'settings.lua',
    'shared/locale.lua',
    'shared/cache.lua',
    'shared/utils.lua',
    'shared/shared.lua',
}

client_scripts {
    'client/utils.lua',
    'client/editable/editable.lua',

    'client/functions.lua',

    'client/class/loot.lua',
    'client/main.lua',
    'client/alerting.lua',
}

server_scripts {
    'server/editable/editable.lua',
    'server/server.lua',
}


escrow_ignore {
    'config.lua',
    'settings.lua',
    'client/editable/*.*',
    'server/editable/*.*',
    'shared/shared.lua',
}

files {
    'locales/*.json'
}

dependencies {
    'kq_link',
    '/onesync'
}

dependency '/assetpacks'