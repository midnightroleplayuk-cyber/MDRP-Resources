fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood_mdt_mobile'
author 'Vinewood Studios'
description 'Mobile bridge for the Vinewood MDT – lets officers use the MDT from the Android app'
version '1.0.0'

shared_script 'config.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/util.lua',
    'server/framework.lua',
    'server/adapter.lua',
    'server/auth.lua',
    'server/api.lua',
    'server/main.lua',
}

dependencies { 'oxmysql' }

escrow_ignore {
    'config.lua',
    'server/adapter.lua',
}
