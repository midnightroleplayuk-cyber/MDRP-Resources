fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'NDM_Surgery'
description 'Surgery: anaesthesia, bullet removal, internal damage repair, stitching and major surgery mini-games'
author 'Axis Hub'
version '0.11.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/fonts/*.ttf',
    'html/images/*.png',
}

data_file 'DLC_ITYP_REQUEST' 'stream/mrc_human_torso.ytyp'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/hands.lua',
    'client/bleed.lua',
    'client/surgeries/*.lua',
    'client/major.lua',
    'client/main.lua',
}

server_script 'server/main.lua'

dependencies {
    'ox_lib',
    'ox_target',
    'osp_ambulance',
}
