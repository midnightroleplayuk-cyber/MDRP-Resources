fx_version "cerulean"

description "Fivem Best MDT & Dispatch for Ambulance Jobs!"
author "OTHERPLANET"
version '1.0.1'
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
	'integrations/client/**',
	'client/**',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config/ServerConfig.lua',
	'integrations/server/**',
	'framework/server/shared.lua',
	'framework/server/esx.lua',
	'framework/server/qb.lua',
	'framework/server/qbox.lua',
	'server/globalVars.lua',
	'server/**',
}

files {
	'web/build/**/*',
}

escrow_ignore {
	'config/**',
	'locales/**',
	'framework/**',
	'integrations/**',
	'sql/**'
}
dependency '/assetpacks'