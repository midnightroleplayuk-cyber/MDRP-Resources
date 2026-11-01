fx_version 'cerulean'
games { 'gta5' }

author "BKing Development"
version "1.0.0"

lua54 "yes"

client_scripts {
    "Config.lua",
    "client.lua",
    "VespucciFireStation.Client.net.dll"
}

server_scripts {
    "VespucciFireStation.Server.net.dll"
}

escrow_ignore { "*.lua" }