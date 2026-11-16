fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Apex Scriptz'
description 'Apex Garage — server-authoritative vehicle garage (ESX / QB / QBox) with the Apex design language'
version '1.1.10'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/utils.lua',
    'locales/en.lua',
    'locales/pt.lua',
    'locales/es.lua',
    'locales/fr.lua',
    'locales/de.lua',
    'shared/framework.lua',
    'shared/integrations.lua',
}

client_scripts {
    'client/apex_lib.lua',
    'client/main.lua',
    'client/modules/mileage.lua',
    'client/modules/locations.lua',
    'client/modules/preview.lua',
    'client/modules/spawn.lua',
    'client/modules/store.lua',
    'client/modules/impound.lua',
    'client/modules/private.lua',
    'client/modules/placer.lua',
    'client/modules/admin.lua',
    'client/modules/parking.lua',
    'client/exports.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/database.lua',
    -- Discord logging. MUST stay above theme.lua and main.lua: both run code at
    -- load and every module below them calls Webhooks.Send.
    'server/webhook_config.lua',
    'server/modules/webhooks.lua',
    'server/modules/theme.lua',
    'server/main.lua',
    'server/modules/garages.lua',
    'server/modules/impound.lua',
    'server/modules/private.lua',
    'server/modules/preview.lua',
    'server/modules/admin.lua',
    'server/modules/parking.lua',
    'server/exports.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/images/*.png',
    'html/images/*.jpg',
    'html/images/*.jpeg',
    'html/images/*.webp',
}

escrow_ignore {
    -- ESCROWED BUILD — config, framework bridge, integrations, locales, webhook
    -- config and SQL stay editable; the rest of the script is protected. Listed
    -- file by file so nothing is left open (or protected) by a glob by accident.
    'fxmanifest.lua',
    'README.md',
    'LICENSE',
    'sql/apex_garage.sql',
    'shared/config.lua',
    'shared/framework.lua',
    'shared/integrations.lua',
    'shared/utils.lua',
    'locales/de.lua',
    'locales/en.lua',
    'locales/es.lua',
    'locales/fr.lua',
    'locales/pt.lua',
    'server/webhook_config.lua',
    'html/images/README.txt',
}


dependencies {
    '/server:5104',
    'oxmysql',
    'ox_lib',
}

dependency '/assetpacks'

dependency '/assetpacks'