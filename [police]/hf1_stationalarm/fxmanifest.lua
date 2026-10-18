fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'HF1'
description 'Police Station Alarm System for QBox'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts { 'client.lua' }
server_scripts { 'server.lua' }

ui_page 'html/index.html'
files {
    'html/index.html',
    'sounds/*.ogg'
}

dependencies { 'ox_lib', 'ox_target', 'qbx_core' }
