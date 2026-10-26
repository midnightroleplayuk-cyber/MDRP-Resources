fx_version 'cerulean'
game 'gta5'
author 'Prompt Studio & Infames Dev' 
version '1.1.5'
this_is_a_map 'yes'
description 'Sandy Shores City Hall'


-- audio (awc+dat54+dat151) merged into shared prompt_audio 2026-06-10; zip backup in
-- C:\Scripts\_backups\prompt_audio\cityhall_audio_2026-06-10_night_pre-merge.zip
files {
	'd1n_shc_timecycle.xml',
	'stream/interior/unlocked/ytyp/d1n_sch_props.ytyp',
    'stream/interior/unlocked/ytyp/d1n_sch_ytyp.ytyp'
}


data_file 'TIMECYCLEMOD_FILE' 'd1n_shc_timecycle.xml'
data_file 'DLC_ITYP_REQUEST' 'stream/interior/unlocked/ytyp/d1n_sch_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/interior/unlocked/ytyp/d1n_sch_ytyp.ytyp'


escrow_ignore {
    'stream/exterior/unlocked/**',
    'stream/interior/unlocked/**',
    'public_config.lua',
    'client/open.lua',
    'ipls_command.lua',
    'ipls_server.lua',
}

-- scripts --
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'public_config.lua',
    'internal_config.lua'
}

client_scripts {
    'client/utils.lua',
    'client/open.lua',
    'client/client.lua',
    'ipls_command.lua'
}

server_scripts {
	'sv_loader.lua',
	'server/*.lua',
	'ipls_server.lua'
}
dependency '/assetpacks'