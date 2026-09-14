fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (devhub.gg)'
description 'DEVHUB Petty Crimes'
version '1.0.4'

client_scripts {
    'configs/sh.*.lua',
    'configs/c.*.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/c.*.lua',
}
server_scripts {
    'configs/sh.*.lua',
    'configs/s.*.lua',
    'escrowed/**/sh.*.lua',
    'escrowed/**/s.*.lua',
}

ui_page "html/index.html"

dependencies { 
    'devhub_lib', 
}

files {
    'html/**/*',
}

escrow_ignore {
    'configs/*.lua',
    'json/*.json',

    -- 'escrowed/sh.config.lua',
    -- 'escrowed/sh.skillTree.lua',
    -- 'escrowed/client/c.activitiesConfig.lua',
    -- 'escrowed/client/c.functions.lua',
    -- 'escrowed/client/c.main.lua',
    -- 'escrowed/client/c.nui.lua',
    -- 'escrowed/client/c.shop.lua',
    -- 'escrowed/client/activities/c.carRadioTheft.lua',
    -- 'escrowed/client/activities/c.npcMugging.lua',
    -- 'escrowed/client/activities/c.npcPickpocket.lua',
    -- 'escrowed/client/activities/c.parkingMeterTheft.lua',
    -- 'escrowed/client/activities/c.phoneBoothTheft.lua',
    -- 'escrowed/client/activities/c.porchTheft.lua',
    -- 'escrowed/client/activities/c.postalBoxTheft.lua',
    -- 'escrowed/client/activities/c.smashAndGrab.lua',
    -- 'escrowed/server/s.activities.lua',
    -- 'escrowed/server/s.activitiesConfig.lua',
    -- 'escrowed/server/s.dispatch.lua',
    -- 'escrowed/server/s.main.lua',
    -- 'escrowed/server/s.shop.lua',
    -- 'escrowed/server/activities/s.carRadioTheft.lua',
    -- 'escrowed/server/activities/s.porchTheft.lua',
    -- 'escrowed/server/activities/s.smashAndGrab.lua',
}

dependency '/assetpacks'