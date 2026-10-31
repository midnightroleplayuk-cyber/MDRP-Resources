fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'HF1'
description 'Persistent QBox display vehicles'

shared_scripts {'@ox_lib/init.lua', 'config.lua'}

client_scripts {'client.lua'}

server_scripts {'@oxmysql/lib/MySQL.lua', 'server.lua'}
dependencies {'qbx_core', 'ox_lib', 'oxmysql'}
