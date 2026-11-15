fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood_mdt_mobile'
author 'Vinewood Studios'
description 'Runs the full Vinewood MDT on phones (Android app) and in any web browser'
version '2.1.0'

shared_script 'config.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/util.lua',
    'server/framework.lua',
    'server/auth.lua',
    'server/api.lua',
    'server/main.lua',
}

dependencies { 'oxmysql', 'vinewood-mdt' }

escrow_ignore {
    'config.lua',
}
