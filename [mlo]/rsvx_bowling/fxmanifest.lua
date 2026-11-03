fx_version 'cerulean'
game 'gta5'

name 'rsvx_bowling'
description 'Midnight RP bowling alley on the old Sandy Shores club plot - test build'
version '0.6.0'

this_is_a_map 'yes'

files {
    'stream/rsvx_bowling.ytyp',
    'pin_spots.json',
}

data_file 'DLC_ITYP_REQUEST' 'stream/rsvx_bowling.ytyp'

shared_script 'pin_spots.lua'
client_script 'client.lua'
