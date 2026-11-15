fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'NDM_MRI'
description 'MRI scanner add-on for osp_ambulance: scan noise, progress bar and an injury report read from OSP'
author 'NDM'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_script 'client/main.lua'
server_script 'server/main.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/sounds/*.ogg',
    'html/img/*.jpg',
}

dependencies {
    'ox_lib',
    'osp_ambulance',
}
