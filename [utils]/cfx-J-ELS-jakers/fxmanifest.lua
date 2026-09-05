fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author 'Jakers'
description 'J-ELS Emergency Lighting System'
version '1.0.2'

ui_page 'web/build/index.html'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/driver_menu_client.lua',
    'client/non_els_client.lua',
    'client/els_client.lua',
    'client/els_debug_client.lua',
    'client/matrix_client.lua',
    'client/controller_client.lua',
}

server_scripts {
    'server/server.lua',
    'server/els_debug_server.lua',
}

files {
    'config.lua',
    'shared.lua',
    'web/build/index.html',
    'web/build/**/*',
    'web/sounds/*.ogg',
    'web/matrix_board.html',
    'dlc_wmsirens/sirenpack_one.awc',
    'data/wmsirens_sounds.dat54.nametable',
    'data/wmsirens_sounds.dat54.rel',
}

exports {
    'CanUseMatrixBoard',
    'IsMatrixPositionModeActive',
    'OpenMatrixMenu',
    'CloseMatrixMenu',
    'GetMatrixState',
    'SetMatrixText',
    'SetMatrixFlash',
    'SetMatrixEnabled',
    'SetMatrixFontColor',
}

escrow_ignore {
    "config.lua",
    'shared.lua',
    "export.lua",
    "data/**/*",
    "dlc_wmsirens/**/*",
    "web/**/*",
}

data_file "AUDIO_WAVEPACK" "dlc_wmsirens"
data_file "AUDIO_SOUNDDATA" "data/wmsirens_sounds.dat"


dependency '/assetpacks'