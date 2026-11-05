fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'hf1_tv'
description 'Custom TV Script for Midnight RP.'
version '0.5.0'

shared_script 'config.lua'

client_scripts {'client.lua','placement_client.lua'}

server_scripts {'server.lua','placement_server.lua'}

ui_page 'html/controller.html'

files {'html/*.html','html/*.js','html/*.css'}

dependencies {'ox_lib','ox_target','ox_inventory','oxmysql'}

shared_script '@ox_lib/init.lua'
server_script '@oxmysql/lib/MySQL.lua'
