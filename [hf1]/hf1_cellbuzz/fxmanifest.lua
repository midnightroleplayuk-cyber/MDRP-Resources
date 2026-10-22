fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'HF1'
description 'QBox multi-station cell buzzer system'
version '1.0.0'

shared_scripts { '@ox_lib/init.lua', 'config.lua' }
client_scripts { 'client.lua' }
server_scripts { 'server.lua' }
files { 'html/index.html', 'html/buzzer.ogg' }
ui_page 'html/index.html'
dependencies { 'ox_lib', 'ox_target', 'qbx_core' }
