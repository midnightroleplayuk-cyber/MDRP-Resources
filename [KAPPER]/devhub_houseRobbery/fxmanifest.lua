fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'
description 'HOUSE ROBBERY'
version '1.1.6'
ui_page "html/index.html"
 
files {
    "html/**/*",
}

client_scripts {
    'configs/shared.lua',
    'configs/client.lua',
    'configs/translation.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/c.*.lua',
}
server_scripts {
    'configs/shared.lua',
    'configs/server.lua',
    'configs/translation.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/s.*.lua',
}

escrow_ignore {
    'configs/*.lua',
    'items/*.*',
}
dependency '/assetpacks'