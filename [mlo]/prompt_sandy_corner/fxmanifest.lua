fx_version 'bodacious'
game 'gta5'
this_is_a_map 'yes'
author 'Prompt Studio'
version '1.0.6'



escrow_ignore {
    -- leave map assets open (editable by the buyer) + any "unlocked" folder, at any depth
    '**/*.ytyp',
    '**/*.ymap',
    '**/*.ytd',
    '**/*.ybn',
    '**/unlocked/**',
    '**/sandy_ground/**',
}


client_scripts {
  'client.lua'
}

-- mapdata registration (MapId "prompt_sandy_corner") — same wiring as prompt_sandy_corner_construction.
-- Without this the sv_loader never runs and the map isn't registered with the mapdata system.
server_scripts {
  'sv_loader.lua'
}

dependency '/assetpacks'


-- Steak-bar door audio + all 3 corner interiors' InteriorSettings + occlusion door sounds are now
-- MERGED into prompt_audio (audio/prompt_mrpd_game.dat151.rel), which loads early in server.cfg.
-- Disabled here to avoid a 2nd AUDIO_GAMEDATA mount + duplicate door links. Uncomment both to
-- restore the standalone steak-door rel.
-- data_file 'AUDIO_GAMEDATA' 'audio/i45ptsteakbardooraudio_game.dat'
-- Arcade cabinet props moved to the prompt_arcade_games resource (its own stream/ + DLC_ITYP_REQUEST).

-- files {
--     'audio/i45ptsteakbardooraudio_game.dat151.rel',
-- }
-- (occlusion .ymt files in stream/occlusion/ auto-stream via this_is_a_map — no files{} entry needed)

dependency '/assetpacks'