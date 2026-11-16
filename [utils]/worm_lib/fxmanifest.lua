fx_version 'cerulean'
game 'gta5'

name 'Wormhole Lib'
description 'Wormhole Library script for our scripts'
version '1.0.0'
author 'Wormhole Studios'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/modules.lua',
    'shared/config.lua',
}

escrow_ignore {
    'shared/modules.lua',
    'shared/config.lua',
    'shared/interaction_menu.lua'
}

client_scripts {
    'modules/bridge/client.lua',
    'modules/inventory/client.lua',
    'modules/notify/client.lua',
    'modules/dispatch/client.lua',
    'modules/progress/client.lua',
    'modules/nui_gate/client.lua',
    'shared/interaction_menu.lua',
    'modules/interaction/defaults.lua',
    'modules/interaction/qbx/*.lua',
    'modules/interaction/client.lua',
    'modules/tasklist/client.lua',
    'modules/hints/client.lua',
    'modules/outfit/client.lua',
}

server_scripts {
    'modules/bridge/server.lua',
    'modules/inventory/normalize.lua',
    'modules/inventory/adapters/*.lua',
    'modules/inventory/server.lua',
    'modules/notify/server.lua',
    'modules/dispatch/server.lua',
    'modules/nui_gate/server.lua',
    'modules/interaction/server.lua',
    'modules/interaction/qbx_server.lua',
    'modules/version/server.lua',
}

ui_page 'web/build/hud.html'

files {
    'locales/*.json',
    'assets/*.png',
    'web/build/index.html',
    'web/build/hud.html',
    'web/build/assets/*.js',
    'web/build/assets/*.css',
    'web/build/assets/*.woff2',
    'web/build/assets/*.woff',
    'web/build/assets/*.ttf',
}

dependency 'ox_lib'
dependency '/assetpacks'