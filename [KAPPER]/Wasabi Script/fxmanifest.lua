-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
nui_callback_strict_mode 'true'
lua54 'yes'
game 'gta5'

description 'Wasabi Mobile Data Terminal (MDT) v2'
author 'Wasabi Scripts'
version '2.0.5'

ui_page 'ui/build/index.html'

files {
    'ui/build/index.html',
    'ui/build/**/*',
    'locales/*.json',
}

shared_scripts {
    '@ox_lib/init.lua',
    'escrow/module_system.lua',
    'config/shared/*.lua',
    'config/shared/departments/*.lua',
    'locales/init.lua',
}

client_scripts {
    'config/client/*.lua',
    'bridge/**/client.lua',
    'bridge/dispatch/*.lua',
    '**/client/modules/**/*.lua',
    '**/client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/server/*.lua',
    'bridge/voice/adapter.lua',
    'bridge/voice/custom.lua',
    'bridge/**/server.lua',
    'bridge/dispatch/*.lua',
    'escrow/common/server/*.lua',
    '**/server/modules/**/*.lua',
    '**/server/main.lua',
}

escrow_ignore {
    '_INSTALL_INVENTORY_ITEM/data.lua',
    'bridge/**/*.lua',
    'config/**/*.lua'
}

provides { 'wasabi_mdt' }

dependencies {
    'ox_lib',
    'oxmysql',
}

dependency '/assetpacks'