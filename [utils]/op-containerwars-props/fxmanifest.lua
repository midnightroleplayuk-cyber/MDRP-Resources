fx_version 'cerulean'
game 'gta5'
description "Container Wars Props by Doaheris"
author "OTHERPLANET"
version '1.0.0'
this_is_a_map 'yes'

files {
    'stream/*.ymap',
    'stream/*.ytyp',
    'stream/*.ybn',
    'stream/*.ydr',
    'stream/*.ycd',
    'stream/*.ynd',
    'stream/*.ynv',
    'stream/*.ymt',
    'stream/*.awc',
    'stream/*.meta',
    'stream/*.dat',
    'stream/*.fxc',
    'stream/*.otd',
    'stream/*.rel',
    'stream/*.rpf',
    'stream/*.rpf2',
    'stream/_manifest.ymf',
}

data_file 'DLC_ITYP_REQUEST' 'stream/_manifest.ymf'
data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'
data_file 'NAVMESH' 'stream/*.ynd'
data_file 'NAVMESH' 'stream/*.ynv'
data_file 'AUDIO_WAVEPACK' 'stream/*.awc'
data_file 'PED_METADATA_FILE' 'stream/*.ymt'
data_file 'VEHICLE_METADATA_FILE' 'stream/*.meta'
data_file 'WEAPONINFO_FILE' 'stream/*.meta'
data_file 'CLIP_SETS_FILE' 'stream/*.dat'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'stream/*.meta'

dependency '/assetpacks'