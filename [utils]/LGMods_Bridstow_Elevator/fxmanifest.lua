fx_version('cerulean')
game('gta5')

authors 'LGMods + TrojanT'
description 'Bridstow Courts Elevator'
version '2.0.0'
lua54 'yes'

dependencies {
    'ox_lib',
}

shared_scripts {
    '@ox_lib/init.lua',
    'elevator_coords.lua',
    'config.lua',
}

client_scripts {
    'elevator/utils.lua',
    'elevator/client.lua',
}

server_script 'elevator/server.lua'

files {
    'indicator/*.png',
}

escrow_ignore {
  'config.lua',
}
dependency '/assetpacks'