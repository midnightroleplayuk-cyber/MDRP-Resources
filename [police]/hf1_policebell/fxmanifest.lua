fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'HF1'
description 'Qbox police front counter bell with temporary in-game placement editor'
version '1.2.0'

shared_scripts { '@ox_lib/init.lua', 'config.lua' }
client_script 'client.lua'
server_script 'server.lua'

dependencies { 'ox_lib', 'ox_target', 'qbx_core' }

ui_page 'html/index.html'
files { 'html/index.html', 'html/sounds/*.ogg' }
