lua54 'yes' fx_version 'cerulean' game 'gta5' 
version '1.3.3'



author 'GG Studio'
description 'GG studio | Discord: https://discord.gg/DqMXJzATph'



shared_scripts {
    '@ox_lib/init.lua',
    'utility.lua',
    -- 'core/lib/**/shared.lua',
    'config/lang.lua',
    'config/shared/*.lua',
}

-- Production build
 ui_page "web/dist/index.html"
-- Hot reloading Live Server
-- ui_page "http://localhost:5173/"

files {
    'utility.lua',
    'core/shared.lua',
    'core/bridge/**/**/*.lua',
    'base/build/init_vehicles.json',

    'web/dist/index.html',
    'web/dist/**/*'
}
server_scripts {   
    '@oxmysql/lib/MySQL.lua',
    'core/init/server.lua',
    'core/lib/**/server.lua',
    'base/build/server/*.lua',
    'base/core/**/server/**/*.lua',
    'base/vehicle_screenshot/server.lua',
}

client_scripts { 
    'core/init/client.lua',
    'core/lib/**/client.lua',
    'base/build/client/*.lua',
    'base/core/**/client/**/*.lua',
    'base/vehicle_screenshot/client.lua',
}

escrow_ignore {
    'core/shared.lua',
    'core/lib/**/client.lua',
    'core/lib/**/server.lua',
    'core/bridge/**/**/*.lua',
    'base/build/init_vehicles.json',
    'base/core/open/server/**.lua',
    'base/core/open/client/**.lua',

    'utility.lua',
    'config/lang.lua',
    'config/shared/*.lua',
}

dependencies {
	'ox_lib',
}
dependency '/assetpacks'