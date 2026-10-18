fx_version 'cerulean'
game 'gta5'

author      'British Scripts - Bradadorez & SwiftlyChillin'
description  'BS Prop Placer - UK road sign placement, persistence & traffic control'
version     '1.2.1'
lua54       'yes'

-- Shared first: config -> locales -> bridge (order matters; bridge reads Config)
shared_scripts {
    'config.lua',
    'locales/*.lua',
    'bridge.lua',
}

client_script 'client.lua'
server_script 'server.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/*.png',
    'html/img/*.svg',
    'html/img/*.jpg',
    'html/img/*.webp',
}

-- ==========================================================================
-- UK SIGN MODELS (bundled with this resource - no separate sign pack needed)
-- 'stream/' auto-streams the .ydr/.ytyp; each .ytyp archetype is registered below.
-- ==========================================================================
data_file 'DLC_ITYP_REQUEST' 'stream/ahead_only.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/barrier.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/cycle_route.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/diversion_left.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/diversion_right.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/keep_left.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/lane_arrow_left.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/lane_arrow_right.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/mini_roundabout.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/national_speed_limit.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/no_cycling.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/no_left_turn.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/no_motor_vehicles.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/no_overtaking.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/no_pedestrians.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/no_right_turn.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/no_stopping_clearway.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/no_through_road.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/no_u_turn.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/no_waiting.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/one_way_right.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/parking.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/pass_either_side.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/priority_over_oncoming.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/road_ahead_closed.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/speed_20.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/speed_30.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/speed_40.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/speed_50.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/speed_60.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/speed_70.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/speed_minimum_30.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/stop.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/traffic_cone.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/traffic_cone_no_waiting.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/turn_left_ahead.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/turn_right_ahead.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/two_way_arrows.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_bend.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_blank_triangle.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_crossroads.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_cyclists.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_double_bend.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_falling_rocks.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_pedestrian_crossing.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_pedestrians.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_road_narrows.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_roadworks.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_roundabout_ahead.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_slippery_road.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_t_junction.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_traffic_signals.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_two_way_traffic.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_uneven_road.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/warning_wild_animals.ytyp'

escrow_ignore {
    'config.lua',
}

dependency '/assetpacks'