fx_version 'cerulean'
game 'gta5'

name 'fa_shoprobbery'
author 'FA Scripts | fa-scripts.tebex.io'
description 'Configurable multi-stage store robbery.'
version '1.0.6'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua',
    'config/rewards.lua',
    'shared/*.lua'
}

files {
    'locales/*.json',
}

client_scripts {
    'bridge/client/utils.lua',
    'bridge/client/clerk.lua',
    'bridge/client/interface.lua',
    'bridge/client/dispatch.lua',
    'bridge/client/target.lua',
    'bridge/client/minigames.lua',
    'client/safe.lua',
    'client/main.lua'
}

server_scripts {
    'config/server_config.lua',
    'bridge/server/*.lua',
    'bridge/server/framework/*.lua',
    'server/*.lua'
}

dependencies {
    'ox_lib'
}

escrow_ignore {
    'bridge/**',
    'config/**',
    'locales/**',
    'integrations/**',
}
dependency '/assetpacks'