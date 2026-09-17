fx_version 'cerulean'
games {'gta5'}
lua54 "yes"
description 'Add-on Melee weapons'

author 'Polars Armoury'
description 'Made By Polar | https://discord.gg/PjNgP4tAv9'
version '1.2'

client_scripts {
    'client.lua',
    "cl_weaponNames.lua"
}

server_script "server.lua"
shared_script "config.lua"

files{
--	'**/weaponcomponents.meta',
	'**/weaponarchetypes.meta',
	'**/weaponanimations.meta',
	'**/pedpersonality.meta',
	'**/weapons.meta',
}

-- data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/weapons.meta'

escrow_ignore {
    "config.lua",
    "cl_weaponNames",
}
dependency '/assetpacks'