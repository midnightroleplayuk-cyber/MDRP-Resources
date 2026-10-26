fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'lation_laundering'
author 'iamlation'
description 'The most powerful & high quality money laundering script for FiveM!'
version '2.2.5'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server.lua',
    'server/*.lua',
    'logs.lua'
}

client_scripts {
    'bridge/client.lua',
    'client/*.lua',
}

shared_scripts {
    'config.lua',
    'strings.lua',
    '@ox_lib/init.lua'
}

dependencies {
	'oxmysql',
	'ox_lib'
}

escrow_ignore {
    'config.lua',
    'strings.lua',
    'logs.lua',
    'bridge/*.lua',
    'client/functions.lua',
    'server/functions.lua'
}
dependency '/assetpacks'