fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'
description 'DEVHUB 3D CRAFTING TABLE'
version '2.1.0'
 
ui_page "html/index.html"

files {
    "html/**/*",
}

client_scripts {
    'configs/shared.lua',
    'configs/client.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/c.*.lua',
}
server_scripts {
    'configs/server.lua',
    'configs/shared.lua',
    'configs/skillTree.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/s.*.lua',
}

escrow_ignore {
    'configs/*.lua',
    'items.lua'
}
dependency '/assetpacks'