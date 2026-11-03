fx_version("cerulean")
description("AV Dealership")
author("Avilchiis")
version("3.1.0")
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
	"server/main/_debug.lua",
	"server/**/*.lua",
})

files({
	"ui/dist/index.html",
	"ui/dist/**/*",
	"ui-phone/dist/index.html",
	"ui-phone/dist/**/*",
	"dealership.png",
	"motors.png",
})

escrow_ignore({
	"config/*.lua",
	"client/editable/*.lua",
	"server/editable/*.lua",
})

dependencies({
	"ox_lib",
	"av_laptop",
})

dependency '/assetpacks'