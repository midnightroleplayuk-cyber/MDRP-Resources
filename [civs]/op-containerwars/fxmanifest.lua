fx_version "cerulean"

description "Container Wars. Escrow Protected"
author "OTHERPLANET"
version '1.0.5'

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
	'framework/client/c_framework.lua',
	'client/**',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config/ServerConfig.lua',
	'framework/server/s_framework.lua',
	'server/**',
}

files {
	'web/build/index.html',
	'web/build/**/*',
	'dui/containerDui.html'
}

escrow_ignore {
	'client/editable/**',
	'client/library/**',
	'config/**',
	'locales/**',
	'framework/**',
	'server/editable/**'
}
dependency '/assetpacks'