fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'CDev Development Team'
description ''
version '1.4.1'

client_scripts {
    -- Dependencies
    '@cdev_lib/shared/external.lua',
    '@cdev_lib/shared/keys.lua',
    --'@cdev_lib/shared/nui.lua',

    -- PolyZone
     '@ox_lib/init.lua',      -- Use this one if OX is turned on in the config
   -- '@PolyZone/client.lua',  -- Use this one if PL is turned on in the config
   -- '@PolyZone/BoxZone.lua', -- Use this one if PL is turned on in the config

    -- Public scripts
    'public/config/config.lua',
    'public/config/fields.lua',
    'public/client/api.lua',
    'data/languages/*.lua',

    -- Escrowed scripts
    'client/ui.lua',
    'client/field.lua',
    'client/main.lua',

    -- Addons
    'addons/addonLoader.lua',
}

server_scripts {
    -- Dependencies
    '@cdev_lib/shared/external.lua',

    -- Public scripts
    'public/config/config.lua',
    'public/config/fields.lua',
    'public/server/api.lua',

    -- Escrowed scripts
    'server/field.lua',
    'server/main.lua',
    'data/languages/*.lua',

    -- Addons
    'addons/addonLoader.lua',
}

escrow_ignore {
    'public/config/config.lua',
    'public/config/fields.lua',
    'public/client/api.lua',
    'public/server/api.lua',
    'data/languages/*.lua',
    'addons/rcore_stats/*.lua',
}

files {
    "nui/dist/**",
    "addons/**",
}

ui_page "nui/dist/index.html"

dependencies {
    '/server:4752',
    'cdev_lib',
}

dependency '/assetpacks'