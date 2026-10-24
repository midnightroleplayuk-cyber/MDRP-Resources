fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'npc_blocker'
description 'Block NPC peds/vehicles from areas (e.g. MLO interiors) with an in-game zone editor'
version '1.0.0'

ui_page 'index.html'

files {
    'index.html',
    'style.css',
    'script.js',
}

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'
