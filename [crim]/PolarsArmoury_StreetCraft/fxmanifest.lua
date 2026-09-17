fx_version "cerulean"
game "gta5"
lua54 "yes"
author "discord.gg/zykeresources"
version "1.0.5"

ui_page "nui/index.html"

files {
    "nui/**/*",
    "locales/*.lua"
}

shared_script "@zyke_lib/imports.lua"

shared_scripts {
    "@ox_lib/init.lua",
    "shared/unlocked/config.lua",
    "shared/locked/config.lua",
    "shared/locked/main.lua",
}

client_scripts {
    "client/locked/main.lua",
}

server_scripts {
    "server/locked/main.lua",
}

dependency "zyke_lib"
dependency "ox_lib"

escrow_ignore {
    "locales/*",
    "client/unlocked/**/*",
    "server/unlocked/**/*",
    "shared/unlocked/**/*",
    "extras/**/*",
}
dependency '/assetpacks'