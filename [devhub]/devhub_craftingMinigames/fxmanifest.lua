fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'
description 'DEVHUB CRAFTING MINIGAMES 1'
version '1.0.0'
ui_page "html/index.html"

files {
    "html/**/*",
}

client_scripts {
    'configs/client.lua',
    'configs/translation.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/c.*.lua',
}
server_scripts {
    'configs/translation.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/s.*.lua',
}

escrow_ignore {
    'configs/*.lua',
}
dependency '/assetpacks'