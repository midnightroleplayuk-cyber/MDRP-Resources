fx_version 'cerulean'
game 'gta5'

author 'LGMods'
version '2.0.0'

this_is_a_map 'yes'

client_script 'client.lua'

files {
    'stream/**/*.ymap',
    'stream/**/*.ytyp',
    'stream/**/*.ydr',
    'stream/**/*.ytd',
    'stream/**/*.ybn'
}

escrow_ignore {
    'stream/base/*'
}
dependency '/assetpacks'