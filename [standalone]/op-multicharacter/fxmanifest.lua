fx_version "cerulean"

description "Version 2.0.1 of the best fivem multicharacter system!"
author "OTHERPLANET"
version '2.0.1'
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
--	'framework/client/esx.lua',
	'framework/client/qb.lua',
	'framework/client/qbox.lua',
	'integrations/client/**',
	'client/**',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config/ServerConfig.lua',
	'framework/server/shared.lua',
--	'framework/server/esx.lua',
	'framework/server/qb.lua',
	'framework/server/qbox.lua',
	'integrations/server/**',
	'server/*.lua',
}

files {
	'web/build/**/*',
	'data/scenes_store.json',
	'sounds/**/*',
}

escrow_ignore {
	'config/**',
	'locales/**',
	'framework/**',
	'integrations/**',
	'client/startup.lua'
}
dependency '/assetpacks'