fx_version 'cerulean'
game 'gta5'

name 'ILLEGAL JOB PACK SYSTEM'
description 'PLUTO DEVELOPMENT'
version '1.0.8'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua',
    'config/progression.lua',
    'shared/init.lua',
}

files {
    'locales/*.json',
    'jobs/**/config.lua',
    'web/html/index.html',
    'web/html/assets/**',
    'web/html/engine/**',
    'web/html/audio/**',
    'web/html/banks/**',
    'web/html/blackmarket_icons/**',
    'web/html/gta-map-tiles/**',
    'web/html/wallpaper.png',
    'client/bridge/esx.lua',
    'client/bridge/qb.lua',
    'client/bridge/qbx.lua',
    'server/bridge/esx.lua',
    'server/bridge/qb.lua',
    'server/bridge/qbx.lua',
}

client_scripts {
    'client/globals.lua',
    'client/bridge/init.lua',
    -- leaves first
    'client/modules/nui.lua',
    'client/modules/ui.lua',
    'client/modules/target.lua',
    'client/modules/weather.lua',
    'client/modules/hostile.lua',
    'client/modules/dialogue.lua',
    -- depends on the leaves above
    'client/modules/utils.lua',
    'client/modules/market_pickup.lua',
    'client/modules/launder_lab.lua',
    'client/modules/illegal_delivery_factory.lua',
    'client/modules/corner_deal_factory.lua',
    'client/editable/*.lua',
    'client/bootstrap.lua',
    'client/profile.lua',
    'client/crew.lua',
    'client/jobs/*.lua',
    'client/items.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/globals.lua',
    'server/bridge/init.lua',
    -- leaves first
    'server/modules/mysql.lua',
    'server/modules/utils.lua',
    'server/modules/lockmanager.lua',
    'server/modules/mission_queue.lua',
    -- depends on the leaves above
    'server/modules/inventory.lua',
    'server/modules/progression.lua',
    'server/modules/job_run_queue.lua',
    'server/modules/launder_lab.lua',
    'server/modules/illegal_delivery_factory.lua',
    'server/modules/corner_deal_factory.lua',
    'server/editable/*.lua',
    'server/bootstrap.lua',
    'server/profile.lua',
    'server/crew.lua',
    'server/jobs/*.lua',
    'server/main.lua',
}

ui_page 'web/html/index.html'

-- Custom streamed props (boxing ring, etc.)
data_file 'DLC_ITYP_REQUEST' 'stream/legend_boxing_prop_meta.ytyp'

escrow_ignore {
    'config/**',
    'jobs/**/config.lua',
    'locales/**',
    'client/editable/**',
    'server/editable/**',
    'client/bridge/**',
    'server/bridge/**',
    'client/modules/**',
    'server/modules/**',
    'docs/**',
    'sql/**'
}

dependencies { 'ox_lib', 'oxmysql' }

dependency '/assetpacks'