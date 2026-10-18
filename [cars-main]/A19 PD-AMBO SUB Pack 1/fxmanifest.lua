fx_version 'cerulean'

game 'gta5'
lua54 'yes'

author 'A19Customs'
description 'Vehicles'
version '1.2.0'

client_script 'vehiclenames.lua'

files {
  'data/**/carcols.meta',
  'data/**/handling.meta',
  'data/**/vehicles.meta',
  'data/**/carvariations.meta'
}

data_file 'CARCOLS_FILE'             'data/**/carcols.meta'
data_file 'HANDLING_FILE'            'data/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE'    'data/**/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE'   'data/**/carvariations.meta'

escrow_ignore {
  'vehiclenames.lua'
}

dependency '/assetpacks'
dependency '/assetpacks'