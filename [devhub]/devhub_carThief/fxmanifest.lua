fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'

description 'CAR THIEF HEIST'
version '1.0.1'

shared_scripts {
    'configs/sh.config.lua',
    'configs/sh.config_translations.lua',
    'escrowed/shared/sh.debugPrint.lua',
    'escrowed/shared/*.*',
}

client_scripts {
    'configs/client.lua',
    'escrowed/client/*.*',
}

server_scripts {
    'configs/server.lua',
    'escrowed/server/*.*',
}

ui_page "html/index.html"

files {
    'html/index.html',
    'html/colors.css',
    'html/assets/**',
    'html/fonts/**',
    'html/images/**',
    'html/sounds/**',
}

escrow_ignore {
    'configs/sh.config.lua',
    'configs/sh.config_translations.lua',
    'configs/client.lua',
    'configs/server.lua',
    -- OPEN SOURCE
    -- 'escrowed/client/*.*',
    -- 'escrowed/server/*.*',
}
dependency '/assetpacks'