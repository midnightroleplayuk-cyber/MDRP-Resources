-- Created by OSP-Development
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'OSP-Development Medical System'
author 'OSP Development'
version '2.0.5'

shared_script {
    '@ox_lib/init.lua',
    'lang/**/*.lua',
    'data/controls.lua',
    'data/location_vectors.lua',
    'data/config_loader.lua',
    'data/registry.lua',
}

client_script {
    'client/dui/helpers.lua',
    'client/dui/main.lua',
    'client/framework/**/*.lua',
    'integrations/**/**/client.lua',
    'client/client_prefs.lua',
    'client/addictions.lua',
    'client/client_open.lua',
    'client/conditions.lua',
    'client/configurator.lua',
    'client/dead.lua',
    'client/ecg.lua',
    'client/fractures.lua',
    'client/incoming.lua',
    'client/insurance.lua',
    'client/job.lua',
    'client/laststand.lua',
    'client/main.lua',
    'client/medical_bag.lua',
    'client/prescriptions.lua',
    'client/stationary.lua',
    'client/stretcher.lua',
    'client/wheelchair.lua',
    'client/wound_editor.lua',
    'client/loops.lua',
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'data/config_writer.lua',
    'server/framework/**/*.lua',
    'integrations/**/**/server.lua',
    'server/diseases.lua',
    'server/addictions.lua',
    'server/insurance.lua',
    'server/prescriptions.lua',
    'server/medical_bag.lua',
    'server/logging.lua',
    'server/server_open.lua',
    'server/server.lua',
}

files {
    'web/build/index.html',
    'web/build/**/*',
    'sound/data/ambulance_sounds.dat54.rel',
	'sound/audiodirectory/ambulance_sounds.awc',
	'vehicledata/*.meta',
    'stream/physicstasks.ymt',
    'config/controls.lua',
    'config/general.lua',
    'config/jobs.lua',
    'config/weapons.lua',
    'config/wounds.lua',
    'config/fractures.lua',
    'config/locations.lua',
    'config/shop.lua',
    'config/prescriptions.lua',
    'config/insurance.lua',
    'config/addiction.lua',
    'config/medication.lua',
    'config/medical_bag.lua',
    'config/casts_splints.lua',
    'config/vehicles.lua',
    'config/blood.lua',
    'client/dui/*',
}

data_file 'HANDLING_FILE'			'vehicledata/handling.meta'
data_file 'VEHICLE_METADATA_FILE'	'vehicledata/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE'	'vehicledata/carvariations.meta'

data_file 'DLC_ITYP_REQUEST' 'stream/v_med_crutch01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ems_props.ytyp'

data_file 'AUDIO_WAVEPACK' 'sound/audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'sound/data/ambulance_sounds.dat'

data_file 'PED_TASK_DATA_FILE'	'stream/physicstasks.ymt'

ui_page {
    'web/build/index.html'
}

escrow_ignore {
    'config/*.lua',
    'client/framework/**/*.lua',
    'client/client_open.lua',
    'client/loops.lua',
    'server/framework/**/*.lua',
    'server/logging.lua',
    'server/server_open.lua',
    'lang/**/*.lua',
    'stream/**/*',
    'integrations/**/**/*',
}

dependencies {
    '/onesync',
    '/server:25770',
    '/gameBuild:mp2024_01',
    'oxmysql',
    'ox_lib'
}

dependency '/assetpacks'