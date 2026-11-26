fx_version 'adamant'
game 'gta5'

name 'rsvx_bowling_mlo'
description 'Midnight RP bowling alley'
version '0.8.2'

this_is_a_map 'yes'

-- exterior shell + rsvx_empty only; the interior ytyp is loaded by stream/_manifestrsvx_bowling.ymf (INTERIOR_DATA)
data_file 'DLC_ITYP_REQUEST' 'stream/rsvx_bowling.ytyp'

client_scripts {
    'seats.lua',
    'client.lua',
}