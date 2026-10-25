fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'helm'
description 'Helm panel connector for QBCore / QBox'
version '0.7.0'

shared_script 'config.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server_config.lua', -- secrets: server-only, editable
    'bridge.lua',        -- framework / inventory adapter, editable
    'server/main.lua',
    'server/queue.lua',
    'server/menu.lua',
    'server/logs.lua',
    'server/anticheat.lua',
}

client_script 'client/main.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/helm-mark.png',
}

-- Cfx.re Asset Escrow: everything not listed here is encrypted. Server owners keep full control of
-- these files (settings, framework adapter, menu look) and can edit them without touching the core.
escrow_ignore {
    'config.lua',
    'server_config.lua',
    'bridge.lua',
    'html/index.html',
}

dependencies {
    'oxmysql',
}
