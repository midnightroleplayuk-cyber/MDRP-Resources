fx_version "cerulean"

description "Complete Gangs System."
author "OTHERPLANET"
version '3.0.9'

lua54 'yes'

game 'gta5'

ui_page 'web/build/index.html'

shared_scripts {
	'@ox_lib/init.lua',
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'config/MainConfig.lua',
	'locales/en.lua',
	'framework/shared.lua',
	'config/GraffitiForbidden.lua',
	'config/TurfConfig.lua',
	'config/ClothingConfig.lua',
	'config/Missions/missionsList/shared.lua',
	'config/Missions/**',
	'config/ClothingConfig.lua',
	'config/RaidsConfig.lua',
	'config/FurnituresConfig.lua',
	'config/MarketConfig.lua',
	'config/SpySystem.lua',
	'framework/client/shared.lua',
	'framework/client/esx.lua',
	'framework/client/qb.lua',
	'framework/client/qbox.lua',
	'integrations/client/**',
	'client/**',
}

server_script 'server.js'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config/MainConfig.lua',
	'locales/en.lua',
	'framework/shared.lua',
	'config/ServerConfig.lua',
	'config/TurfConfig.lua',
	'config/Missions/MissionsConfig.lua',
	'config/RaidsConfig.lua',
	'config/FurnituresConfig.lua',
	'config/MarketConfig.lua',
	'config/SpySystem.lua',
	'framework/server/shared.lua',
	'framework/server/esx.lua',
	'framework/server/qb.lua',
	'framework/server/qbox.lua',
	'integrations/server/**',
	'server/*.lua',
}

files {
	'web/build/index.html',
	'web/build/**/*',
	'dui/**',
	'locales/en.lua',
	'locales/*.lua',
}

escrow_ignore {
	'client/library/**',
	'config/**',
	'locales/**',
	'framework/**',
	'integrations/**',
	'server/turfZonesFunctions.lua'
}

dependencies {
	'PolyZone',
	'fivem-freecam',
	'ox_lib',
}
dependency '/assetpacks'