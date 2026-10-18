fx_version 'cerulean'
games { 'gta5' }
version '1.1'

replace_level_meta 'gta5'

files {
    'doortuning.ymt',
    'water.xml',
    'traintracks.xml',
    'trains1.dat',
    'sp_manifest.ymt',
    'gta5.meta'

}

data_file 'LEVEL_META' 'gta5.meta'
data_file 'TRAINTRACK_FILE' 'traintracks.xml'
data_file 'TEXTFILE_METAFILE' 'trains1.dat'
data_file 'SCENARIO_POINTS_OVERRIDE_PSO_FILE' 'sp_manifest.ymt'

dependency '/assetpacks'