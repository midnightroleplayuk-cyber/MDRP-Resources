fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'
description 'TRUCK ROBBERY'
version '1.1.3'
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
    'escrowed/**/e.*.lua',
}

escrow_ignore {
    'configs/*.lua',
}
dependency '/assetpacks'