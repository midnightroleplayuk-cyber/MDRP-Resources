fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'

description 'TRAIN HEIST'
version '1.0.0'


ui_page 'html/index.html'

files {
    'html/**'
}

client_scripts {
    'configs/shared.lua',
    'configs/client.lua',
    'configs/translation.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/c.*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'configs/shared.lua',
    'configs/server.lua',
    'configs/translation.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/s.*.lua',
}

dependencies {
    'oxmysql',
    'devhub_lib',
    'devhub_grid'
}

escrow_ignore {
    'configs/*.lua'
}

dependency '/assetpacks'