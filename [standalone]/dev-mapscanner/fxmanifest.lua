fx_version 'cerulean'
game 'gta5'

name 'dev-mapscanner'
description 'Developer tool to scan for duplicate YMAPs, collisions, occlusions and trace their source resources'
author 'Anthony'
version '2.0.0'

server_scripts {
    'server/scanner.js',
}

client_scripts {
    'client/scanner.lua',
    'client/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
}
