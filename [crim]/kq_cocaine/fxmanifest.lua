fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'KuzQuality | Kuzkay'
description 'Cocaine production by KuzQuality'
version '1.5.1'

files {
    "MINIMAP_LOADER.gfx"
}

shared_scripts {
    'config.lua',
    'shared/locale.lua',
    'shared/cache.lua',
    'shared/utils.lua',
    'shared/shared.lua',
}

client_scripts {
    'client/editable/debug.lua',
    'client/editable/editable.lua',

    'client/utils.lua',

    'client/client.lua',
    'client/functions.lua',

    'client/class/synchronisedObject.lua',

    'client/class/plantations/plant.lua',
    'client/class/plantations/plantation.lua',

    'client/class/pit.lua',
    'client/class/barrel.lua',
    'client/class/firepit.lua',

    'client/collections.lua',

    'client/editable/ocean-calmer.lua',
    'client/map.lua',
}

server_scripts {
    'server/editable/debug.lua',
    'server/editable/editable.lua',
    'server/class/synchronisedObject.lua',
    'server/class/pit.lua',
    'server/class/plantation.lua',
    'server/class/barrel.lua',
    'server/class/firepit.lua',
    'server/collections.lua',
}

files {
    'locales/*.json'
}

escrow_ignore {
    'config.lua',
    'client/editable/*.*',
    'server/editable/*.*',
    'locales/*.json',
}

dependencies {
    'kq_link',
    'kq_coca_island',
}

dependency '/assetpacks'