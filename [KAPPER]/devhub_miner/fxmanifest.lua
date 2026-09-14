fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'
description 'DH MULTIPLAYER MINER JOB'
version '1.1.1'

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

provide 'dh_miner'
dependency '/assetpacks'