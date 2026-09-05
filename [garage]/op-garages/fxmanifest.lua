fx_version "cerulean"

description "Best Garage System for fivem servers. V3"
author "OTHERPLANET"
version '3.0.3'

lua54 'yes'

game 'gta5'

ui_page 'web/build/index.html'

shared_scripts {
	'@ox_lib/init.lua',
	'framework/shared.lua',
	'config/MainConfig.lua',
	'locales/*.lua',
}

client_scripts {
	'config/MainConfig.lua',
	'framework/client/shared.lua',
	'framework/client/esx.lua',
	'framework/client/qb.lua',
	'framework/client/qbox.lua',
	'client/library/lib.lua',
	'client/library/blips.lua',
	'integrations/client/*.lua',
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config/ServerConfig.lua',
	'framework/server/esx.lua',
	'framework/server/qb.lua',
	'framework/server/qbox.lua',
	'integrations/server/*.lua',
	'server/*.lua',
}

files {
	'web/build/index.html',
	'web/build/**/*',
	'dui/dui.html',
	'config/vehiclesList.json'
}

escrow_ignore {
	'config/**',
	'locales/**',
	'framework/**',
	'integrations/**',
	'client/library/blips.lua',
}
dependency '/assetpacks'