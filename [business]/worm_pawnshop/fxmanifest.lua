fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'worm_pawnshop'
author 'JezzyOnDuty - wormhole-studios.tebex.io'
description 'DUI computer based pawnshop / shipment broker'
version '1.0.1'

ox_lib 'locale'

-- Escrowed modules are loaded here (not through lib.require) and register themselves in shared/modules.lua;
-- they have to be listed before the file that first calls requireModule on them.
shared_scripts {
    '@ox_lib/init.lua',
    'shared/modules.lua',
    'shared/util.lua',
    'shared/init.lua',
}

client_scripts {
    'client/modules/*.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/modules/*.lua',
    'server/main.lua',
}

ui_page 'web/build/index.html'

files {
    'config/shared.lua',
    'config/client.lua',
    'locales/*.json',
    'web/build/index.html',
    'web/build/assets/*',
}

dependencies {
    'worm_lib',
    'oxmysql',
}

escrow_ignore {
    'config/*.lua',
    'locales/*.json',
    'data/*.json',
}

dependency '/assetpacks'