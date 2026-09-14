fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'
description 'DEVHUB GRID SYSTEM'
version '1.0.3'

client_scripts {
    'configs/sh.*.lua',
    'configs/c.*.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/c.*.lua',
}
server_scripts {
    'configs/sh.*.lua',
    'configs/s.*.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/s.*.lua',
}

escrow_ignore {
    'configs/sh.config.lua',
    'configs/c.config.lua',
}
dependency '/assetpacks'