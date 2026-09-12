fx_version 'cerulean'
game 'gta5'

author 'Pluto Development @ https://pluto-dev.com'
description 'An advanced ambulance job system for FiveM'
version '2.1.5'

ui_page 'web/index.html'

-- Register custom models: .ytyp tells the game the model exists
data_file 'DLC_ITYP_REQUEST' 'stream/fernocot.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/as_xray_clipboard.ytyp'
data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'

files {
    'locales/*.json',
    'data/handling.meta',
    'data/vehicles.meta',
    'data/carvariations.meta',
    'stream/**/*.ydr',
    'stream/**/*.ytd',
    'stream/**/*.ytyp',
    'web/index.html',
    'web/style.css',
    'web/boss_menu.css',
    'web/inventory.css',
    'web/bag_inventory.css',
    'web/diagnosis.css',
    'web/dispatch.css',
    'web/deathscreen.css',
    'web/script.js',
    'web/boss_menu.js',
    'web/inventory.js',
    'web/bag_inventory.js',
    'web/diagnosis.js',
    'web/dispatch.js',
    'web/deathscreen.js',
    'web/pharmacy.js',
    'web/duty_swipe.js',
    'web/pharmacy.css',
    'web/img/*.png',
    'web/img/*.webp',
    'web/img/*.jpg',
    'web/fonts/*.ttf'
}
client_scripts {
    'config.lua',
    'shared/functions.lua',
    'client/bridge/framework/qbx.lua',
    'client/bridge/framework/qb.lua',
    'client/bridge/framework/esx.lua',
    'client/bridge/keys/*.lua',
    'client/bridge/inventory/*.lua',
    'client/bridge/target/*.lua',
    'client/bridge/progressbar/*.lua',
    'client/main.lua',
    'client/boss_menu.lua',
    'client/health.lua',
    'client/bodybag.lua',
    'client/medical.lua',
    'client/diagnosis.lua',
    'client/dispatch.lua',
    'client/deathscreen.lua',
    'client/medical_bag.lua',
    'client/pharmacy.lua',
    'client/compat_exports.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'shared/functions.lua',
    'server/bridge/framework/qbx.lua',
    'server/bridge/framework/qb.lua',
    'server/bridge/framework/esx.lua',
    'server/bridge/inventory/*.lua',
    'server/bridge/billing/*.lua',
    'server/changelog.lua',
    'server/init.lua',
    'server/main.lua',
    'server/boss_menu.lua',
    'server/health.lua',
    'server/diagnosis.lua',
    'server/dispatch.lua',
    'server/deathscreen.lua',
    'server/medical_bag.lua',
    'server/pharmacy.lua',
    'server/compat_exports.lua'
}

escrow_ignore {
    'config.lua',
    'locales/**/*.json',
    'client/bridge/**/*.lua',
    'server/bridge/**/*.lua',
    'server/init.lua'
}

dependency '/assetpacks'