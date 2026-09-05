fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Tuff Scripts'
description 'Fivem Minimal Pause Menu'
version "0.0.2 - Release"

client_scripts {
	'client/functions.lua',
	'client/framework.lua',
	'client/main.lua',
}

server_scripts {
	'server/functions.lua',
	'server/main.lua'
}

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua',
}

ui_page 'nui/dist/index.html'

files {
	'nui/dist/**',
	'nui/dist/**/**',
	'assets/**'
}

dependency 'ox_lib'

escrow_ignore {
	-- Accessabel files for everyone, not encrypted
	-- Shared
	'shared/settings.lua',
	'shared/strings.lua',
	-- Client
	'client/framework.lua',
	-- Server
	'server/functions.lua',
	'server/main.lua',
}

dependency '/assetpacks'