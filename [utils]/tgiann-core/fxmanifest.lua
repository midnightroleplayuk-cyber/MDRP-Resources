fx_version "cerulean"
game "gta5"
version "4.75.0"
lua54 "yes"
nui_callback_strict_mode 'true'

dependencies { "ox_lib" }

ui_page "ui/build/index.html"

files {
	"ui/build/**.*",
	"ui/flags/*.webp",
	"client/animHook.lua"
}

escrow_ignore {
	"configs/*.lua",
	"client/animHook.lua",
	"client/functions/progressbar.lua",
	"client/functions/skillCheck.lua",
	"client/functions/setVehicleProperties.lua",
	"client/functions/getVehicleProperties.lua",
	"client/functions/duty.lua",
	"client/functions/boss.lua",
	"client/functions/mechanic.lua",
	"client/functions/clothing.lua",
	"client/functions/vehicleKey.lua",
	"client/functions/vehicleFuel.lua",
	"client/functions/inventory.lua",
	"server/functions/inventory.lua",
	"server/functions/screenshot.lua",
	"client/inventory/custom/main.lua",
	"client/main.lua",
	"server/functions/screenshot.lua",
	"server/functions/vehicleKey.lua",
	"server/functions/vehicleFuel.lua",
	"server/functions/sendChatMessage.lua",
	"server/inventory/custom/main.lua",
	"languages/*.lua"
}

shared_scripts {
	'@ox_lib/init.lua',
	"import.lua",
	"configs/config.lua",
	"configs/playerOwnableConfig.lua",
	"languages/*.lua",
	"shared/functions/*.lua",
	"shared/other/*.lua",
}

client_scripts {
	"client/**.lua",
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"configs/discordConfig.lua",
	"configs/screenshotConfig.lua",
	"configs/webhookConfig.lua",
	"server/databaseCreator/*.lua",
	"server/functions/*.lua",
	"server/framework/**.lua",
	"server/inventory/**.lua",
	"server/playerOwnable/**.lua",
}

dependency '/assetpacks'