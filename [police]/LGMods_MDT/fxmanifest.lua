fx_version 'cerulean'
game 'gta5'

author 'LG Liam - Lead Script Developer @ LGMods'
description 'LGMods_MDT'
version '1.1.2'

dependencies {
    'qbx_core',
    'ox_lib',
    'oxmysql',
}

ui_page 'web/index.html'

shared_scripts {
    '@qbx_core/shared/locale.lua',
    'config.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client/main.lua',
    'client/vehicle_services.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    'web/index.html',
    'web/js/rich-text-editor.js',
    'web/js/app.js',
    'web/js/vehicle_services.js',
    'web/css/styles.css',
    'web/js/fingerprint.js',
    'web/css/fingerprint.css',
    'web/css/v5c.css',
    'web/js/v5c.js',
    'web/images/*.png',
    'web/js/evidence.js',
}

lua54 'yes'

escrow_ignore {'config.lua'}
dependency '/assetpacks'