fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ndm_goodciv'
author 'NDM Network'
description 'GoodCiv: civilian first-responder volunteers. Request one with /goodciv when you are down. Works standalone or with QBCore / QBox / ESX.'
version '2.0.0'

shared_scripts {
    'config.lua',
    'locales/en.lua',
    'shared/utils.lua',
}

client_scripts {
    'bridge/client.lua',
    'client/nui.lua',
    'client/down.lua',
    'client/patient.lua',
    'client/injury.lua',
    'client/admin.lua',
    'client/responder.lua',
    'client/treatment.lua',
}

server_scripts {
    'bridge/server.lua',
    'server/carriers.lua',
    'server/incidents.lua',
    'server/injury.lua',
    'server/hospitals.lua',
    'server/treatment.lua',
    'server/dispatch.lua',
    'server/down.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
}
