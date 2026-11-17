fx_version "cerulean"

game "gta5"
lua54 "yes"

version "1.0.1"

author "Moddex - Hanssen"
description "Backboard script"


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


dependencies {
    "ox_lib",
    "ox_inventory",
    "ox_target"
}
