fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'
description 'DEVHUB MULTIPLAYER POOL CLEANER JOB'
version '1.0.8'

ui_page "html/index.html"

files {
    "html/**/*",
}

client_scripts {
    'escrowed/**/sh.*.lua',
    'configs/shared.lua',
    'configs/zones.lua',
    'configs/client.lua',
    'configs/skillTree.lua',
    'escrowed/**/c.*.lua',
}
server_scripts {
    'escrowed/**/sh.*.lua',
    'configs/server.lua',
    'configs/shared.lua',
    'configs/zones.lua',
    'configs/skillTree.lua',
    'escrowed/**/s.*.lua',
}

escrow_ignore {
    'configs/*.lua',
    -- SOURCE CODE VERSION

    -- 'escrowed/jobCore/c.events.lua',
    -- 'escrowed/jobCore/c.functions.lua',
    -- 'escrowed/jobCore/c.main.lua',
    -- 'escrowed/jobCore/c.skills.lua',
    -- 'escrowed/jobCore/c.task.lua',
    -- 'escrowed/jobCore/s.main.lua',
    -- 'escrowed/jobUi/s.h.player.lua',
    -- 'escrowed/jobUi/s.leaderboard.lua',
    -- 'escrowed/jobUi/s.player.lua',
    
    -- 'escrowed/c.anims.lua',
    -- 'escrowed/c.pickUpTrash.lua',
    -- 'escrowed/c.pourMixture.lua',
    -- 'escrowed/c.robot.lua',
    -- 'escrowed/c.robotPoolCleaner.lua',
    -- 'escrowed/c.valve.lua',
    -- 'escrowed/s.main.lua',
    -- 'escrowed/sh.config.lua',
}
dependency '/assetpacks'