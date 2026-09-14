fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Department Creator made by Pluto Dev'
version '1.6.0'
author 'PLUTO'

shared_scripts {
    'shared/config.lua',
    'shared/framework.lua',
    'shared/inventory.lua'
}

client_scripts {
    'lib/client/lib.lua',
    'client/main.lua',
    'client/officer_menu.lua',
    'client/dispatch.lua',
    'client/poses.lua',
    'client/k9_menu.lua',
    'client/ai_dispatcher.lua',
    'client/radar.lua',
    'client/alpr.lua',
    'client/breathalyzer.lua',
    'client/megaphone.lua',
    'client/cameras.lua',
    'client/evidence.lua',
    'client/tracker.lua',
    'client/ankle_monitor.lua',
    'client/comms.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'lib/server/lib.lua',
    'server/main.lua',
    'server/boss_menu.lua',
    'server/officer_menu.lua',
    'server/dispatch.lua',
    'server/radar.lua',
    'server/k9_menu.lua',
    'server/ai_dispatcher.lua',
    'server/ai_police_npc.lua',
    'server/breathalyzer.lua',
    'server/megaphone.lua',
    'server/evidence.lua',
    'server/tracker.lua',
    'server/ankle_monitor.lua',
    'server/comms.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'web/boss_menu.css',
    'web/boss_menu.js',
    'web/form_computer.css',
    'web/form_computer.js',
    'web/ai_police_npc.css',
    'web/ai_police_npc.js',
    'web/vintage_boss_menu.css',
    'web/vintage_boss_menu.js',
    'web/officer_menu.css',
    'web/officer_menu.js',
    'web/ankle_monitor.css',
    'web/ankle_monitor.js',
    'web/ankle_monitor_map.js',
    'web/dispatch.css',
    'web/dispatch.js',
    'web/poses.css',
    'web/poses.js',
    'web/k9_menu.js',
    'web/k9_voice.js',
    'web/ai_dispatcher_voice.js',
    'web/radar_setup.css',
    'web/alpr.css',
    'web/armory.css',
    'web/alpr.js',
    'web/armory.js',
    'web/breathalyzer.js',
    'web/breathalyzer.css',
    'web/cameras.css',
    'web/evidence.js',
    'web/evidence.css',
    'web/swipe_card.js',
    'web/img/*.jpg',
    'web/img/*.png',
    'web/img/*.webp',
    'web/audio/*.mp3',
    'stream/as_wheel_clamp.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/as_wheel_clamp.ytyp'

escrow_ignore {
    'shared/**',
}

exports {
    'AddBolo',
    'UpdateBolo',
    'DeleteBolo',
    'AddWarrant',
    'UpdateWarrant',
    'DeleteWarrant',
    'GetPlayerDepartment',
    'AddMoneyToDept',
    'SendDepartmentMail',
    'IsDepartmentsReady',
    'GetDepartmentsData',
    'GetDepartmentCatalog',
    'ResolveDepartmentFromJob',
    'CuffPlayer',
    'UncuffPlayer',
    'ToggleCuffPlayer',
    'IsPlayerCuffed',
    'BreakCuffs',
    'SeizeVehicle',
    'RequestSeizeVehicle'
}

dependency '/assetpacks'