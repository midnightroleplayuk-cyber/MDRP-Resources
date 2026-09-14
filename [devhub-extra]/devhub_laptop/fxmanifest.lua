fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'
description 'DEVHUB LAPTOP'
version '1.0.8'
 
ui_page 'html/index.html'

files {
    "html/**/*",
}

client_scripts {
    'configs/sh.*.lua',
    'escrowed/sh.*.lua',
    'escrowed/c.*.lua',
    'escrowed/apps/**/c.*.lua',
}
server_scripts {
    'configs/sh.*.lua',
    'escrowed/sh.*.lua',
    'configs/s.*.lua',
    'escrowed/s.*.lua',
    'escrowed/apps/**/s.*.lua',
}

escrow_ignore {
    'configs/*.lua',
}
dependency '/assetpacks'