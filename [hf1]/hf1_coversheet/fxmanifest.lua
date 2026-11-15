fx_version 'cerulean'
game 'gta5'

-- Qbox + ox_inventory only. Usable item registered in ox_inventory/data/items.lua.
shared_script '@ox_lib/init.lua'

dependencies {
    'qbx_core',
    'ox_inventory',
    'ox_lib'
}

client_script 'client.lua'

files {
    'stream/mdx_tarp.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/mdx_tarp.ytyp'
