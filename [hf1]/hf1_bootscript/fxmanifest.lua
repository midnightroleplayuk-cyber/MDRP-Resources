fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'hf1_bootscript'
author 'HF1'

description 'Bootscript for Police Job'
version '1.4.4'

ui_page 'web/index.html'

shared_scripts {'@ox_lib/init.lua','shared/config.lua'}

client_scripts {'client/main.lua'}

server_scripts {'server/main.lua'}

files {'web/index.html','web/style.css','web/app.js','web/logo.png','web/item-fallback.svg'}

dependencies {'ox_lib','ox_target','ox_inventory','qbx_core'}
