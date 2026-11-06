fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood_gangs'
author 'Vinewood Studios'
description 'Advanced gang, territory and organised crime system'
version '3.0.0'

ox_lib 'locale'

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua',
    'config/zones.lua',
    'config/hexes.lua',
    'config/ranks.lua',
    'config/activities.lua',
    'config/graffiti.lua',
    'config/contracts.lua',
    'config/rackets.lua',
    'config/safehouses.lua',
    'config/enterprises.lua',
    'config/diplomacy.lua',
    'config/director.lua',
    'config/drugs.lua',
    'config/heists.lua',
    'config/airdrops.lua',
    'config/informants.lua',
    'config/auctions.lua',
    'config/progression.lua',
    'config/shop.lua',
    'config/laundering.lua',
    'shared/utils.lua',
    'shared/zones.lua',
    'shared/hexes.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server/framework.lua',
    'bridge/server/integrations.lua',
    'server/core/logger.lua',
    'server/core/security.lua',
    'server/core/migrations.lua',
    'server/core/vehicles.lua',
    'server/systems/zones_db.lua',
    'server/systems/gangs.lua',
    'server/systems/progression.lua',
    'server/systems/ledger.lua',
    'server/systems/intel.lua',
    'server/systems/heat.lua',
    'server/systems/influence.lua',
    'server/systems/hexes.lua',
    'server/systems/relations.lua',
    'server/systems/activity.lua',
    'server/systems/director.lua',
    'server/modules/graffiti.lua',
    'server/modules/contracts.lua',
    'server/modules/contract_spots.lua',
    'server/modules/rackets.lua',
    'server/modules/safehouses.lua',
    'server/modules/enterprises.lua',
    'server/modules/supply.lua',
    'server/modules/informants.lua',
    'server/modules/auctions.lua',
    'server/modules/shop.lua',
    'server/modules/drugs.lua',
    'server/modules/heists.lua',
    'server/modules/airdrops.lua',
    'server/modules/laundering.lua',
    'server/api/exports.lua',
    'server/api/callbacks.lua',
    'server/admin/panel.lua',
    'server/main.lua',
}

client_scripts {
    'client/bridge.lua',
    'client/main.lua',
    'client/hexes.lua',
    'client/zones.lua',
    'client/map_areas.lua',
    'client/tablet.lua',
    'client/graffiti.lua',
    'client/contracts.lua',
    'client/rackets.lua',
    'client/safehouses.lua',
    'client/supply.lua',
    'client/director.lua',
    'client/informants.lua',
    'client/auctions.lua',
    'client/drugs.lua',
    'client/heists.lua',
    'client/airdrops.lua',
    'client/admin_safehouses.lua',
    'client/admin_zones.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/icons.js',
    'web/minigames.js',
    'web/app.js',
    'web/admin.js',
    'web/tag-render.js',
    'web/tag.html',
    'web/images/*.png',
    'web/images/*.jpg',
    'locales/*.json',
    'sql/install.sql',
    'sql/update_*.sql',
}

dependencies {
    'ox_lib',
    'oxmysql',
}
