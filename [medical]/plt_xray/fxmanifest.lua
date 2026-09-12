fx_version 'cerulean'
game 'gta5'

description 'EMS X-Ray'
author 'Pluto Dev'
version '2.0.3'

shared_script 'config.lua'

client_scripts {
    'client/lib_3dnui.lua',
    'client/main.lua'
}

server_scripts {
    'server/main.lua',
    'server/init.lua'
}

dependencies {
    'plt_ambulance_job'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/app.js',
    'assets/cursor.png',
    'assets/head-healthy.png',
    'assets/head-broken.png',
    'assets/chest-healthy.png',
    'assets/chest-broken.png',
    'assets/left-hand-healthy.png',
    'assets/left-hand-broken.png',
    'assets/right-hand-healthy.png',
    'assets/right-hand-broken.png',
    'assets/left-leg-healthy.png',
    'assets/left-leg-broken.png',
    'assets/right-leg-healthy.png',
    'assets/right-leg-broken.png'
}

lua54 'yes'

escrow_ignore {
    'config.lua'
}

dependency '/assetpacks'