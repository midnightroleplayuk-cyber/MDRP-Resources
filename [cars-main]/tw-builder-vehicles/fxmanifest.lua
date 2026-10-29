fx_version 'cerulean'
games { 'gta5' }

author 'Tworst'
description 'Tworst Construction'
version '1.0.4'

files {
	'carvariations.meta',
	'handling.meta',
	'vehicles.meta',
}

data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'


client_script 'vehicle_names.lua'

escrow_ignore {
	'vehicle_names.lua',
}

lua54 'yes'

dependency '/assetpacks'