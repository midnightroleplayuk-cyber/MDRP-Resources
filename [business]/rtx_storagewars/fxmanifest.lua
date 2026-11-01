fx_version 'cerulean'

game 'gta5'

description 'RTX STORAGE WARS'

version '10.0'

server_scripts {
	'config.lua',
	'language/main.lua',
	'server/main.lua',
	'server/other.lua'
}

client_scripts {
	'config.lua',
	'language/main.lua',
	'client/main.lua'
}

files {
	'html/ui.html',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/BebasNeueBold.ttf',
	'html/img/*.png'
}

ui_page 'html/ui.html'

escrow_ignore {
  'config.lua',
  'language/main.lua',
  'server/other.lua'
}

lua54 'yes'
dependency '/assetpacks'