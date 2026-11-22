fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'NDM_Surgery'
description 'Surgery add-on for osp_ambulance: anaesthesia, bullet removal, internal damage repair and stitching'
author 'NDM Development'
version '0.10.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_script 'client/main.lua'
server_script 'server/main.lua'

dependencies {
    'ox_lib',
    'ox_target',
    'osp_ambulance',
}
