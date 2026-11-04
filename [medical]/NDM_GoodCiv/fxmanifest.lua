fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ndm_goodciv'
author 'NDM Network'
description 'GoodCiv: civilian first-responder volunteers who answer life-threatening medical calls when no medics are on duty'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/en.lua',
    'shared/utils.lua',
}

client_scripts {
    'bridge/client.lua',
    'client/nui.lua',
    'client/patient.lua',
    'client/responder.lua',
    'client/treatment.lua',
    'client/signup.lua',
    'client/training.lua',
}

dependencies {
    'ox_lib',
}

server_scripts {
    'bridge/server.lua',
    'server/carriers.lua',
    'server/incidents.lua',
    'server/treatment.lua',
    'server/dispatch.lua',
    'server/vinewood.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
}
