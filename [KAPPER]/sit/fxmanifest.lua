fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Mads'
description 'Sit Anywhere!'
version '1.2.0'

client_scripts {
    -- '@ox_lib/init.lua', -- Uncomment this if you want to use ox lib notifications etc.!
    'config.lua',
    'list.lua',
    'client.lua'
}

escrow_ignore {
    'config.lua',
    'list.lua',
    'client.lua'
}

dependencies {
    '/server:5181'
}

dependency '/assetpacks'