fx_version { 'cerulean' } games { 'gta5' } lua54 { 'yes' }

name { 'LGMods_Sinner_FCR_DLC' }
author { 'LGMods - https://discord.gg/lgmods' }

shared_script 'config.lua'
server_script 'server.lua'
client_script 'client.lua'

dependency 'LGMods_Sinner_UK'

escrow_ignore { 'config.lua', 'stream/*.ytd', 'stream/*.ytyp' }

this_is_a_map 'yes'
dependency '/assetpacks'