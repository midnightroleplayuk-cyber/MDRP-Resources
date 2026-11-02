fx_version("cerulean")
description("AV Mail")
author("Avilchiis")
version("1.1.0")
lua54("yes")
games({
	"gta5",
})

ui_page("ui/dist/index.html")

shared_scripts({
	"@ox_lib/init.lua",
	"config/*.lua",
})

client_scripts({
	"client/**/*.lua",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"server/**/*.lua",
})

files({
	"ui/dist/index.html",
	"ui/dist/**/*",
	"icon.png",
})

escrow_ignore({
	"config/*.lua",
	"client/editable/*.lua",
	"server/editable/*.lua",
})

dependencies({
	"ox_lib",
	"oxmysql",
	"av_laptop",
})

dependency '/assetpacks'