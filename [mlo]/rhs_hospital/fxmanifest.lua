fx_version 'cerulean'
game 'gta5'
lua54 'yes' -- Cfx asset escrow only encrypts Lua 5.4

this_is_a_map 'yes'

name 'rhs_hospital'
author 'NO BS SCRIPTS'
description 'RHS Burton Hospital - a British district general hospital MLO on the Burton plot (replaces the Burton Los Santos Customs)'
version '1.0.0-rc.11'

files {
    'stream/interior/rhs_hospital.ytyp',
    'stream/interior/rhs_night_lights.ytyp',
    'stream/interior/rhs_doors.ytyp',
    'data/rhs_timecycle.xml',
    'meta/gtxd.meta',
}

data_file 'DLC_ITYP_REQUEST' 'stream/interior/rhs_hospital.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/interior/rhs_night_lights.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/interior/rhs_doors.ytyp'
data_file 'GTXD_PARENTING_DATA' 'meta/gtxd.meta'
data_file 'TIMECYCLEMOD_FILE' 'data/rhs_timecycle.xml'

shared_script 'config.lua'
client_scripts { 'client/*.lua' }

escrow_ignore {
    -- what buyers may read and change
    'config.lua',
    'README.md',
    'CHANGELOG.md',
    'LICENSE.txt',
    'THIRD_PARTY_NOTICES.md',
    -- edited GTA files: open so Vertex Hub can merge them
    'stream/vanilla/**',
    -- the textures buyers rebrand (a .ytd is never encrypted anyway)
    'stream/branding/**',
    -- never encrypted anyway; listing them avoids streaming trouble
    'stream/**/*.ymap',
    'stream/**/*.ybn',
    'stream/**/*.ytyp',
    'stream/**/*.ytd',
    'stream/**/*.ymf',
    'meta/**',
    'data/**',
    'compatibility/**',
    'branding-kit/**',
}

dependency '/assetpacks'