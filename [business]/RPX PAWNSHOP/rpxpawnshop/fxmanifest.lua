fx_version 'cerulean'
game 'gta5'

author 'RPX.TEBEX.IO'
description 'Pawnshop with Qbox/QBCore/ESX'
version '1.0.0'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/app.js',
}

shared_scripts {
  'config.lua',
}

client_scripts {
  'client/main.lua',
}

server_scripts {
  'server/main.lua',
}

escrow_ignore {
  'config.lua',
}

lua54 'yes'

dependency '/assetpacks'