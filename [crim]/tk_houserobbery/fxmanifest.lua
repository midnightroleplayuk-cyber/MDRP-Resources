fx_version 'cerulean'

game 'gta5'

author 'TK Scripts'

description 'House Robbery'

version '2.1.9'

lua54 'yes'

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**/*',
}

shared_scripts {
    --'@ox_lib/init.lua',
    'shared/*.lua',
	'locales/*.lua',
	'config.lua',
}

client_scripts {
    'client/frameworks/*.lua',
    'client/*.lua',
}

server_scripts {
    'server/frameworks/*.lua',
    'server/*.lua',
}

escrow_ignore {
    'locales/*.lua',
    'config.lua',
    'client/frameworks/*.lua',
    'server/frameworks/*.lua',
    'client/main_editable.lua',
    'server/main_editable.lua',
}
dependency '/assetpacks'