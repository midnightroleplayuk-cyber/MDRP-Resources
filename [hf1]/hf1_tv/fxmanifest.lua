fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'hf1_tv'
description 'QBCore/Qbox compatible TV with ox_target, ox_lib, DUI and synced playback'
version '0.3.0'
shared_script 'config.lua'
client_scripts {'client.lua'}
server_scripts {'server.lua'}
ui_page 'html/controller.html'
files {'html/*.html','html/*.js','html/*.css'}
dependencies {'ox_lib','ox_target'}
shared_script '@ox_lib/init.lua'
