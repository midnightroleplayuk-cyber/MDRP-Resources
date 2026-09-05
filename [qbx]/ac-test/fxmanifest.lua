fx_version 'cerulean'
game 'gta5'

name 'ac-test'
author 'CoreFx'
description 'Multi-Framework Support Server Development Admin Menu'
version '1.2.0'
escrow_ignore {
    'bridge/client.lua',
    'bridge/server.lua',
    'bridge/shared.lua'
}
shared_scripts {
    '@ox_lib/init.lua', -- Optional: ox_lib for enhanced features
    'bridge/shared.lua'
}

-- Client scripts
client_scripts {
    'bridge/client.lua',
    'client.lua'
}

-- Server scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Optional: for database operations
    'bridge/server.lua',
    'server.lua'
}

-- NUI (User Interface)
ui_page 'html/index.html?v=10'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/images/**/*'
}

-- Lua language version
lua54 'yes'
dependency '/assetpacks'