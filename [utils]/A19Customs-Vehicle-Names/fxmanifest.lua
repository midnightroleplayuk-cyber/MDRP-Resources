fx_version 'cerulean'
game 'gta5'

author 'A19Customs'
description 'Vehicle display names for the A19Customs Civilian Subscription Packs'
version '1.2.0'

client_scripts {
    'client/pack1_names.lua',
    'client/pack2_names.lua',
    'client/register_names.lua'
}

-- Keep every vehicle-name file readable when uploaded through Asset Escrow.
escrow_ignore {
    'client/*.lua',
    'OPTIONAL-Copy-Paste/*.lua',
    'README.txt'
}

dependency '/assetpacks'