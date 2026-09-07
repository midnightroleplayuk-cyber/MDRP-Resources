fx_version "cerulean"
lua54 "yes"
game "gta5"

author "Overflow Team"
description "of_whiteboard"
version "v1.2.0"

dependency "ox_lib"

ui_page "dist/index.html"

files {
  "dist/index.html",
  "dist/**/*",
}

escrow_ignore {
  "**/*",
}

shared_scripts {
  "@ox_lib/init.lua",

  "config/config.lua",
  "config/whiteboard.lua",
  "config/locale/en.lua",
  "config/locale/es.lua",

  "src/helpers/shared/table.lua",
  "src/helpers/shared/logging.lua",
}

client_scripts {
  "framework/resolve.lua",
  "framework/qb/init.lua",
  "framework/qbx/init.lua",
  "framework/esx/init.lua",
  "framework/notify.lua",

  "src/init.lua",

  "src/helpers/client/*.lua",

  "src/client/nui.lua",
  "src/client/poster.lua",
  "src/client/builder.lua",
}

server_scripts {
  "framework/resolve.lua",
  "framework/qb/init.lua",
  "framework/qbx/init.lua",
  "framework/esx/init.lua",
  "framework/identity.lua",
  "framework/checks.lua",
  "framework/notify.lua",
  "framework/inventory.lua",

  "src/helpers/server/*.lua",

  "src/server/depend.lua",
  "src/init.lua",
  "src/server/stream.lua",
  "src/server/images.lua",
  "src/server/db.lua",
  "src/server/logs.lua",
  "src/server/poster.lua",
}

dependency '/assetpacks'