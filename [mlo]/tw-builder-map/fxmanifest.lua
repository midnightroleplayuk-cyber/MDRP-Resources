fx_version 'cerulean'
game 'gta5'

author 'TW'
description 'TW Builder - Map Builder for FiveM'
version '1.0.0'

client_script 'client.lua'

this_is_a_map 'yes'

files {
    'stream/**/*'
}

-- Archetype YTYPs — her birinin DLC_ITYP_REQUEST ile register edilmesi şart
-- (yoksa ymap'lerdeki entity'ler spawn olmaz, CodeWalker görür ama oyun göremez)
data_file 'DLC_ITYP_REQUEST' 'stream/int_corporate.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/m25_2_prop_m25_2_interiors.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw_dress_ext.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw_dress_int.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw_dress_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw_tv.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw_const.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw_garage.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw_grg_int.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw_grg_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tw_billboard.ytyp'

dependency '/assetpacks'