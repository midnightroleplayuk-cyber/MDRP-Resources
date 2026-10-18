fx_version 'adamant'
game 'gta5'
description 'RTX Paleto Project'
version '1.9'

this_is_a_map 'yes'

dependencies {
    'rtx_paleto_project_data'
}

data_file 'GTXD_PARENTING_DATA' 'data/gtxd.meta'
data_file 'TIMECYCLEMOD_FILE' 'timecycles/djn_timecycle_paleto.xml'
data_file 'TIMECYCLEMOD_FILE' 'timecycles/sempre_paletomedical_int.xml'
data_file 'DLC_ITYP_REQUEST' 'int_corporate.ytyp'
data_file 'DLC_ITYP_REQUEST' 'ex_int_office_02_dlc.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sf_dlc_int_01_sec.ytyp'
data_file 'DLC_ITYP_REQUEST' 'int_services.ytyp'
data_file 'DLC_ITYP_REQUEST' 'int_industrial.ytyp'
data_file 'DLC_ITYP_REQUEST' 'v_int_24.ytyp'
data_file 'DLC_ITYP_REQUEST' 'ch_dlc_int_02_ch.ytyp'
data_file 'DLC_ITYP_REQUEST' 'v_int_20.ytyp'
data_file 'DLC_ITYP_REQUEST' 'ba_int_02_ba.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sf_dlc_int_03_sec.ytyp'
data_file 'DLC_ITYP_REQUEST' 'ex_int_office_02b_dlc.ytyp'
data_file 'DLC_ITYP_REQUEST' 'apa_int_mp_h_03.ytyp'
data_file 'DLC_ITYP_REQUEST' 'apa_int_mp_h_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'v_int_9.ytyp'
data_file 'DLC_ITYP_REQUEST' 'mp_residential.ytyp'

files {
    'timecycles/sempre_paletomedical_int.xml',
	'timecycles/djn_timecycle_paleto.xml',
	'data/gtxd.meta'
}

client_scripts {
    'client/main.lua'
}

shared_script {
    'config.lua'
}

escrow_ignore {
    'config.lua'
}
dependency '/assetpacks'