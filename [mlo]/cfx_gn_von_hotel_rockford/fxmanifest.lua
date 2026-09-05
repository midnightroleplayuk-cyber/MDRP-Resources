fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'G&N_s Studio'
description 'Von Crastenburg Hotel - Rockford Hills Pack'
version '4.2.1'

this_is_a_map 'yes'

dependencies {
    '/gameBuild:2189',
    'NativeUI'
}

client_scripts {
    'remove_ipl.lua',
    '@NativeUI/NativeUI.lua',
    'script_loader/client.lua',
    'script_loader/config.lua',
    'script_loader/locales.lua'
}

escrow_ignore {
    'stream/base/**/*',
    'stream/**/*.ytd',
    'remove_ipl.lua',
    'script_loader/*.lua'
}

dependency '/assetpacks'