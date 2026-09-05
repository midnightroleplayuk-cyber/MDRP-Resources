fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Tuff Scripts | Kovax'
description 'Tuff Advance HUD 2.0'
version "v2.0.3"

shared_scripts {
	'@ox_lib/init.lua',
	'shared/bridge.lua',
	'init/init.lua',
	'shared/settings.lua',
	'shared/keybinds.lua',
	'shared/fuel.lua',
	'shared/electric.lua',
	'shared/stress.lua',
	'shared/strings.lua',
	'shared/nitro.lua'
}

client_scripts {
	'client/modules/minimap.lua',
	'client/modules/status.lua',
	'client/modules/speedometer.lua',
	'client/modules/stress.lua',
	'client/modules/mileage.lua',
	'client/modules/keybinds.lua',
	'client/modules/postal.lua',
	'client/main.lua',
	'client/nui.lua',
	'client/framework.lua'
}

server_script 'server/main.lua'

exports {
	'Hide',
	'Show',
	'HideSpeedometer',
	'ShowSpeedometer',
	'hideSpeedometer',
	'showSpeedometer',
	'AddStress',
	'addStress',
	'RemoveStress',
	'removeStress',
	'GetStress',
	'getStress',
	'SetSeatbeltState',
	'ClearSeatbeltState'
}

ui_page 'nui/dist/index.html'

files {
	'nui/dist/**',
	'nui/dist/**/**',
	'assets/**',
	'client/bridge/**/**/*.lua',
	'client/postals.json',
}

dependency 'ox_lib'

escrow_ignore {
	'shared/*.lua',
	'init/init.lua',
	'client/bridge/framework/**/*.lua',
	'client/framework.lua',
	'client/modules/keybinds.lua',
	'client/modules/status.lua',
	'client/modules/mileage.lua'
}

dependency '/assetpacks'