fx_version 'cerulean'
game 'gta5'

author 'HF1'
version '7.0.0'
description 'A beautiful Radio Resource for Midnight Roleplay.'


lua54 'yes'

ui_page 'build/index.html'
-- ui_page 'http://localhost:3000/' --for dev

shared_script {
    '@ox_lib/init.lua',
    'shared/**'
}

client_script {
    '@qbx_core/modules/playerdata.lua',
    'client/interface.lua',
    'client/function.lua',
    'client/secondary.lua',
    'client/event.lua',
    'client/nui.lua'
}

server_script {
    'server/main.lua',
}

files {
    'build/**',
    'locales/*.json'
}

dependencies {
    'pma-voice',
    'ox_lib',
    '/onesync'
}
