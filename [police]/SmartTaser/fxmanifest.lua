fx_version 'bodacious'
games { 'gta5' }

author 'London Studios'
description 'An updated and realistic taser framework experience'
version '1.0.6'
lua54 'yes'

client_scripts {
    'config.lua',
    'cl_utils.lua',
    'cl_smarttaser.lua',
}

server_scripts {
    'config.lua',
    'sv_utils.lua',
    'sv_smarttaser.lua', 
}

files {
    'data/taseraudio.dat54.rel',
    'taserdirectory/taser_sounds.awc',
}

escrow_ignore {
    'stream/*.ytd',
    'cl_utils.lua',
    'sv_utils.lua',
    'config.lua',
    'sounds/**',
    '*.meta',
}

export 'enableSafety'
export 'enableLaser'
export 'enableFlash'

data_file 'AUDIO_WAVEPACK' 'taserdirectory'
data_file 'AUDIO_SOUNDDATA' 'data/taseraudio.dat'
dependency '/assetpacks'