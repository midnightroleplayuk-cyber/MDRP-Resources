fx_version 'cerulean'

game 'gta5'

author 'TuKeh_'

description 'Police Job'

version '1.4.4'

lua54 'yes'

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**/*',
    'data/audioexample_sounds.dat54.rel',
    'audiodirectory/policejob_sounds.awc'
}

data_file 'AUDIO_WAVEPACK'  'audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'data/audioexample_sounds.dat'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
	'locales/*.lua',
	'config.lua',
}

client_scripts {
    'client/frameworks/*.lua',
    'client/*.lua',
    'client/main_editable.lua',
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
}
dependency '/assetpacks'