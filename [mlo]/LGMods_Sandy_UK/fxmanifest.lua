fx_version { 'cerulean' } games { 'gta5' } lua54 { 'yes' }

name { 'LGMods_Sandy_UK' }
author { 'LGMods - https://discord.gg/lgmods' }
version ( 'v1.0.0' )

this_is_a_map 'yes'

ui_page "html/index.html"

client_script { 'client.lua' }

shared_scripts { 'config.lua' }

server_scripts { 'server.lua' }

files {
    "sandy_shores.ymt",
    "html/index.html",
    "html/sounds/*.ogg"
}

escrow_ignore { 'config.lua', 'stream/*.ytd', 'stream/*.ytyp' }

data_file "SCENARIO_POINTS_OVERRIDE_PSO_FILE" "sandy_shores.ymt"
data_file 'DLC_ITYP_REQUEST' 'stream/lgmods_sandy_main.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/lgmods_sandy_ext.ytyp'
dependency '/assetpacks'