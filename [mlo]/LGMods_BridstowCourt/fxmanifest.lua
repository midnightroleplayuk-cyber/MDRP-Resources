fx_version 'cerulean'
game 'gta5'
lua54 'yes'
this_is_a_map 'yes'

authors 'LGMods'
description 'Bridstow Courts Int + Exterior'
version '2.0.0'

ui_page 'ui/index.html'

data_file 'SCALEFORM_DLC_FILE' 'stream/minimap/int915664316.gfx'
data_file 'SCALEFORM_DLC_FILE' 'stream/minimap/int2118847047.gfx'
data_file 'SCALEFORM_DLC_FILE' 'stream/minimap/int2688410579.gfx'

client_scripts {
    'config.lua',
    'ipl.lua',
    'elevator.lua'
}

files {
    'ui/index.html',
    '*.lua',
    'stream/*.ytyp',
    'stream/*.ymap',
    'stream/floors/*.ymap'
}

escrow_ignore {
    'config.lua',
    'stream/vinilla/**'
}
dependency '/assetpacks'