fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LG Mods'
description 'Westbridge Crown Court'
version '2.0.0'

this_is_a_map 'yes'

files {
    'gtxd.meta',                   -- data_file assets outside stream/ must be listed or the client never downloads them
}

data_file 'GTXD_PARENTING_DATA' 'gtxd.meta'          -- wcc_branding.ytd (court name + crest) is the parent of the txds that use it
data_file 'DLC_ITYP_REQUEST' 'stream/crown_court.ytyp'

client_scripts {
    'config.lua',                    -- every option (lifts, courtroom sound-proofing)
    'client/lifts.lua',
    'client/soundproof_rooms.lua',
    'client/soundproof.lua',
}

escrow_ignore {
    'config.lua',
    'stream/wcc_branding.ytd',      -- the court's name + crest: re-brand here
    'stream/Vanilla/*.ymap',      -- vanilla files we override (left open so they can be merged with other maps' edits)
    'stream/Vanilla/*.ybn',
    'stream/Vanilla/*.ydr',
    'stream/Vanilla/*.ydd',
    'stream/Vanilla/*.ynd',
}

dependency '/assetpacks'