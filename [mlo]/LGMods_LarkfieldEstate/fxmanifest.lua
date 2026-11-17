fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LGMods'
description 'Larkfield Estate'
version '1.0.2'

this_is_a_map 'yes'

files {
    'gtxd.meta',
    'lfe_interiorproxies.meta',
}

data_file 'INTERIOR_PROXY_ORDER_FILE' 'lfe_interiorproxies.meta'
data_file 'GTXD_PARENTING_DATA' 'gtxd.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/lfe_estate.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/lfe_interiors.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/lfe_doors.ytyp'

client_scripts {
    'config.lua',
    'client/vanilla.lua',
    'client/population.lua',
    'client/lifts.lua',
}

escrow_ignore {
    'config.lua',
    'stream/Vanilla/*.ymap',
    'stream/Vanilla/*.ybn',
    'stream/Vanilla/*.ydr',
    'stream/Vanilla/*.ydd',
    'stream/Vanilla/*.ynd',
    'stream/Vanilla/*.ynv',
}

dependency '/assetpacks'