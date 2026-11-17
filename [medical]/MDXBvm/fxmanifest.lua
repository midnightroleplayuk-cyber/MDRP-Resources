fx_version "cerulean"

game "gta5"
lua54 "yes"

version "1.0.0"

author "Moddex - Hanssen"
description "BVM script"


shared_scripts {
    "@ox_lib/init.lua",
    "config.lua"
}

client_scripts {
    "client/client.lua"
}

server_scripts {
    "server/server.lua"
}

files {
    'stream/*.ytyp',
    'sounds/*.ogg'
}

data_file 'DLC_ITYP_REQUEST' 'stream/capital_hj_props.ytyp'

dependencies {
    "ox_lib"
}
