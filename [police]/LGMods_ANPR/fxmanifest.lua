fx_version 'cerulean'
game 'gta5'

author 'LG Liam - Lead Script Developer @ LGMods'
description 'LGMods_ANPR'
version '1.1.3'

shared_scripts {
    'config.lua',
    'shared/vehicle_colors.lua',
}

client_scripts {
    'client/init.lua',
    'client/state.lua',
    'client/lib/notify.lua',
    'client/lib/utils.lua',
    'client/lib/vehicle.lua',
    'client/bolo.lua',
    'client/dispatch.lua',
    'client/scan.lua',
    'client/cameras.lua',
    'client/events.lua',
    'client/nui.lua',
    'client/commands.lua',
    'client/threads.lua',
    'client/main.lua',
    'client/mdts/*.lua',
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/bolo.css',
    'html/anpr.css',
    'html/script.js',
    'html/fonts/UKNumberPlate.ttf',
    'html/sounds/alert.mp3',
    'stream/lgmods_anpr_camera.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/lgmods_anpr_camera.ytyp'

lua54 'yes'

escrow_ignore {
    'config.lua',
    'shared/vehicle_colors.lua',
}
dependency '/assetpacks'