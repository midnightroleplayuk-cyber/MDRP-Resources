fx_version "cerulean"
game "gta5"
lua54 "yes"

description "For support or other queries: discord.gg/jgscripts"
version 'v1.2.1'
author "JG Scripts"

dependencies {
  "oxmysql",
  "ox_lib",
  "/server:7290",
  "/onesync",
}

shared_scripts {
  "@ox_lib/init.lua",
  "config/config*.lua",
  "locales/*.lua",
  "shared/*.lua",
  "framework/main.lua"
}

client_scripts {
  "framework/**/cl-*.lua",
  "client/cl-*.lua"
}

server_scripts {
  "@oxmysql/lib/MySQL.lua",
  "framework/**/sv-*.lua",
  "server/sv-*.lua"
}

ui_page "web/dist/index.html"

files {
  "web/dist/index.html",
  "web/dist/**/*"
}

escrow_ignore {
  "config/*.lua",
  "framework/**/*",
  "install/**/*",
  "locales/*.lua"
}
dependency '/assetpacks'