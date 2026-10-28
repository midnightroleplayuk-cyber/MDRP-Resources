fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'tr_core'
author 'TR Scripts'
description 'Shared core library for TR Scripts'
version '1.6.0'

shared_script 'init.lua'
server_scripts {
    'server/main.lua',
    'server/versions.lua',
}
client_scripts {
    'client/main.lua',
    'client/interact.lua',
}

-- Everything consumers load through '@tr_core/init.lua' must be listed here so clients can read it.
files {
    'init.lua',
    'modules/**/shared.lua',
    'modules/**/client.lua',
    'bridge/**/client.lua',
    'bridge/**/shared.lua',
    -- the option panel of tr_core's own interaction (client/interact.lua)
    'web/interact/**',
}

dependencies {
    '/onesync',
}
