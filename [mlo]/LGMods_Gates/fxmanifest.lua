fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LGMods'
version '1.0.1'

ui_page "html/index.html"

files {
    "modules/*.lua",
    "html/index.html",
    "html/sounds/*.ogg"
}

shared_scripts {
    'config.lua',
    'moduleloader.lua',
    'modules/*.lua',
}

client_script 'client.lua'
server_script 'server.lua'

escrow_ignore {
    'config.lua',
    'modules/*.lua'
}

dependency '/assetpacks'