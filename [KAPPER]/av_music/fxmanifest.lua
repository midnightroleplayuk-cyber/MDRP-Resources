fx_version("cerulean")
description("AV Music")
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
	"client/main/audio_dui.lua",
	"client/**/*",
})

server_scripts({
	"server/**/*",
})

files({
	"ui/dist/index.html",
	"ui/dist/**/*",
	"html/**/*",
	"server/api/youtube.js",
	"icon.png",
})

escrow_ignore({
	"config/*.lua",
	"client/editable/*.lua",
	"server/editable/*.lua",
})

dependencies({
	"yarn",
	"ox_lib",
	"av_laptop",
})

dependency '/assetpacks'