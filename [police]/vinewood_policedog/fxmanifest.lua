fx_version 'cerulean'
game 'gta5'

name 'vinewood_policedog'
author 'Vinewood Studios'
description 'The Vinewood police dog (add-on ped vw_policedog) for vinewood_police'
version '1.0.2'

-- Kept in its own resource on purpose: a ped's metadata must not be reloaded while players are in the
-- game (restarting a resource that carries it crashes GTA the next time the ped spawns). Restart
-- vinewood_police as often as you like; only restart this one with a full server restart.

files { 'data/peds.meta' }
data_file 'PED_METADATA_FILE' 'data/peds.meta'
