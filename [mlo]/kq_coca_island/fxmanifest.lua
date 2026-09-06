fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'KuzQuality | Kuzkay'
description 'Cocaine plantation map and props by KuzQuality'
version '1.0.1'

this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/kq_cocaine.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/kq_coca_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/kq_coca_collectibles.ytyp'

files {
    'stream/*.*'
}

escrow_ignore {
    'stream/**.ymap',
    'stream/**.ytd',
}

dependency '/assetpacks'