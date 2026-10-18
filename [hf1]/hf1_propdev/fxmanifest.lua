fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'HF1'
description 'QBOX Dev Tool for Props Etc..'
version '1.4.3'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

dependency 'ox_lib'
