-- NO BS SCRIPTS - Mission Plaza UK police station: interior, exterior, site works and scripts in one resource.
-- server.cfg: ensure nobs_ukpd_missionplaza. Every setting is in config.lua; guides in install/docs/.
fx_version 'cerulean'
game 'gta5'
this_is_a_map 'yes'
author 'NO BS SCRIPTS'
description 'Mission Plaza UK police station MLO (NO BS SCRIPTS)'
version '1.2.2'
lua54 'yes'
dependency '/gameBuild:3258'
dependency '/assetpacks'

-- Map data (exterior and roof, then the interior) and the texture dictionary parents
data_file 'DLC_ITYP_REQUEST' 'stream/exterior/nobs_ukpd_mp_ext.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/exterior/nobs_ukpd_mp_roof.ytyp'
data_file 'GTXD_PARENTING_DATA' 'scripts/data/roof_gtxd.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/mlo/nobs_ukpd_mp.ytyp'
data_file 'GTXD_PARENTING_DATA' 'scripts/data/gtxd.meta'

files {
    'scripts/data/roof_gtxd.meta',
    'scripts/data/gtxd.meta',
}

-- config.lua first, then the generated data, then the scripts (explicit lists: the order matters)
shared_scripts {
    'config.lua',
    'scripts/data/gates_data.lua',
    'scripts/data/doors_data.lua',
}

client_scripts {
    'scripts/data/site_data.lua',
    'scripts/data/armoury_data.lua',
    'scripts/client/gates.lua',
    'scripts/client/site_controls.lua',
    'scripts/client/ambient_audio.lua',
    'scripts/client/armoury_display.lua',
    'scripts/client/managed_doors.lua',
    'scripts/client/door_closer.lua',
    'scripts/client/exterior_brick.lua',
}

server_scripts {
    'scripts/server/gates_server.lua',
    'scripts/server/managed_doors_server.lua',
}

-- Cfx escrow encrypts only Lua, .ydr, .yft and .ydd. Plain (listed here): config.lua, the generated data and
-- texture parents in scripts/data, install/ (guides, doorlock data, branding kit), the edited GTA files in
-- stream/vanilla (merge clashes with Vertex Hub) and the map data Cfx never encrypts. Protected: the station
-- models in stream/mlo and stream/exterior and the scripts in scripts/client and scripts/server.
escrow_ignore {
    'fxmanifest.lua',
    'README.md',
    'config.lua',
    'scripts/data/*',
    'scripts/data/**/*',
    'install/**/*',
    'install/doorlocks/**/*',
    'stream/vanilla/*',
    'stream/vanilla/**/*',
    'stream/branding/*',
    'stream/**/*.ytd',
    'stream/**/*.ymap',
    'stream/**/*.ybn',
    'stream/**/*.ytyp',
    'stream/**/*.ymf',
}

dependency '/assetpacks'