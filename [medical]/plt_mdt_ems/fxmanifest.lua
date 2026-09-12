fx_version 'cerulean'
game 'gta5'

author 'Pluto Development'
version '2.0.1'

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'web/img/*.png',
    'web/img/*.jpg'
}

shared_scripts {
    'shared/framework.lua',
    'shared/config.lua',
    'shared/callbacks.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

escrow_ignore {
    'shared/config.lua'
}

lua54 'yes'

dependency 'oxmysql'

dependency '/assetpacks'