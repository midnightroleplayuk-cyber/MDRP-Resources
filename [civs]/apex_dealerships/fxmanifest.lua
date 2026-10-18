fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'Premium vehicle dealership suite — live 3D showroom, amortized finance, owned dealerships, direct sales, coupons'
version     '1.1.3'

shared_scripts {
    '@ox_lib/init.lua',            -- notifications + vehicle properties (QBox uses ox_lib for these)
    'shared/config.lua',
    'shared/vehicles.lua',
    'shared/framework.lua',
    'shared/utils.lua',
    'build/locales/*.lua',         -- drop a new language file in and it loads itself
    'shared/integrations.lua',     -- OPEN-SOURCE plug-in points (edit freely)
}

client_scripts {
    'build/client/apex_lib.lua',
    'build/client/main.lua',
    'build/client/zones.lua',
    'build/client/modules/showroom.lua',
    'build/client/modules/purchase.lua',
    'build/client/modules/testdrive.lua',
    'build/client/modules/management.lua',
    'build/client/modules/sell.lua',
    'build/client/modules/display.lua',
    'build/client/modules/finance.lua',
    'build/client/modules/stockrun.lua',
    'build/client/modules/admin.lua',
    'build/client/exports.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'build/server/apex_lib.lua',
    'build/server/database.lua',
    'build/server/main.lua',
    'build/server/modules/webhooks.lua',
    'build/server/modules/theme.lua',
    'build/server/modules/categories.lua',
    'build/server/modules/stands.lua',
    'build/server/modules/catalog.lua',
    'build/server/modules/coupons.lua',
    'build/server/modules/purchase.lua',
    'build/server/modules/finance.lua',
    'build/server/modules/testdrive.lua',
    'build/server/modules/employees.lua',
    'build/server/modules/management.lua',
    'build/server/modules/stockrun.lua',
    'build/server/modules/sell.lua',
    'build/server/modules/display.lua',
    'build/server/exports.lua',
}

ui_page 'build/html/index.html'

files {
    'build/html/index.html',
    'build/html/css/*.css',
    'build/html/js/*.js',
    -- your own vehicle pictures: build/html/images/<spawncode>.png
    'build/html/images/*.png',
    'build/html/images/*.jpg',
    'build/html/images/*.jpeg',
    'build/html/images/*.webp',
}

dependencies {
    '/server:5104',
    'oxmysql',
    'ox_lib',
}

escrow_ignore {
    -- ESCROWED BUILD — config, framework bridge, integrations, catalog,
    -- locales, SQL and the importer tools stay editable; the rest of the
    -- script is protected. Listed file by file: a glob that does not match
    -- the way it appears to leaves a file open (or protected) in silence.
    'fxmanifest.lua',
    'README.md',
    'LICENSE',
    'CHANGELOG.md',
    '[SQL]/apex_dealerships.sql',
    'shared/config.lua',
    'shared/framework.lua',
    'shared/integrations.lua',
    'shared/utils.lua',
    'shared/vehicles.lua',
    'build/locales/de.lua',
    'build/locales/en.lua',
    'build/locales/es.lua',
    'build/locales/fr.lua',
    'build/locales/pt.lua',
    'build/html/images/README.txt',
    'tools/apex_vehicle_import.bat',
    'tools/apex_vehicle_import.sh',
}

dependency '/assetpacks'

dependency '/assetpacks'