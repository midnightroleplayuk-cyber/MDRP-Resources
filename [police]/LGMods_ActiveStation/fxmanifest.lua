fx_version 'cerulean'
game 'gta5'

author 'LG Liam - Lead Script Developer @ LGMods'
description 'LGMods_ActiveStation'
version '1.0.6'

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/styles.css',
    'web/script.js',
    'web/sounds/*.mp3',
    'web/sounds/*.MP3',
    'web/images/*.png',
    'stream/*.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/iip_sign.ytyp'


shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client.lua',
    'client/*.lua'
}

server_scripts {
    'server.lua',
}

dependency {
    'PolyZone',
    'oxmysql'
}

escrow_ignore {
    'config.lua'
}

lua54 'yes' 
dependency '/assetpacks'