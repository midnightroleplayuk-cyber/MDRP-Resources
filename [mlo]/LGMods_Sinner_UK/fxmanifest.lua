fx_version { 'cerulean' } games { 'gta5' } lua54 { 'yes' }

name { 'LGMods_SinnerStreet' }
author { 'LGMods - https://discord.gg/lgmods' }
version ( '4.0.0' )

client_scripts { 'client/*.lua'}

files {
    'stream/*.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

data_file 'EXPRESSION_DICTIONARIES_FILE' 'stream/lgmods_sinner_rear_gate.yed'
data_file 'EXPRESSION_DICTIONARIES_FILE' 'stream/lgmods_sinner_ped_gate.yed'
data_file 'EXPRESSION_DICTIONARIES_FILE' 'stream/lgmods_sinner_bifold.yed'

escrow_ignore { 'stream/*.ytd', 'stream/*.ytyp' }

this_is_a_map 'yes'
dependency '/assetpacks'