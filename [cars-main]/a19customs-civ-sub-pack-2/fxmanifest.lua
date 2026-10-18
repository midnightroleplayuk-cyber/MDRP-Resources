fx_version 'cerulean'

game 'gta5'
lua54 'yes'

author 'A19Customs'
description 'A19Custom-Civ-Sub Pack-2'
version '1.7.0'

files {
  'data/**/carcols.meta',
  'data/**/handling.meta',
  'data/**/vehicles.meta',
  'data/**/carvariations.meta',
  'data/**/vehiclelayouts.meta',
}

data_file 'CARCOLS_FILE'             'data/**/carcols.meta'
data_file 'HANDLING_FILE'            'data/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE'    'data/**/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE'   'data/**/carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE'     'data/**/vehiclelayouts.meta'

escrow_ignore {
  'vehiclenames.lua'
}

dependency '/assetpacks'
dependency '/assetpacks'