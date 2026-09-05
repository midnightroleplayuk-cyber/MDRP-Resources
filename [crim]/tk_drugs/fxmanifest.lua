fx_version 'cerulean'

game 'gta5'

author 'TuKeh_'

description 'Drug System'

version '2.0.9'

lua54 'yes'

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**/*',
    'stream/*',
}

data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

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
	'@mysql-async/lib/MySQL.lua',
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
    'stream/*'
}
dependency '/assetpacks'