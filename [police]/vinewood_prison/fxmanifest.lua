fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood_prison'
author 'Vinewood Studios'
description 'Vinewood Prison - British prison system'
version '2.4.1'

dependencies {
    'ox_lib',
    'oxmysql',
    'ox_inventory',
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/init.lua',
    'config/main.lua',
    'config/modules.lua',
    'config/permissions.lua',
    'config/sentence.lua',
    'config/reception.lua',
    'config/ui.lua',
    'config/regime.lua',
    'config/iep.lua',
    'config/discipline.lua',
    'config/accounts.lua',
    'config/canteen.lua',
    'config/industries.lua',
    'config/activities.lua',
    'config/security.lua',
    'config/social.lua',
    'config/operations.lua',
    'bridge/init.lua',
    'shared/module.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/integrations.lua',
    'config/logs.lua',
    'bridge/framework/*.lua',
    'bridge/inventory/*.lua',
    'server/cache.lua',
    'server/db.lua',
    'server/hooks.lua',
    'server/audit.lua',
    'server/permissions.lua',
    'server/callbacks.lua',
    'integrations/phone/_helpers.lua',
    'integrations/**/*.lua',
    'modules/estate/server.lua',
    'modules/doors/server.lua',
    'modules/custody/server.lua',
    'modules/sentence/server.lua',
    'modules/release/server.lua',
    'modules/reception/server.lua',
    'modules/tablet/server.lua',
    'modules/editor/server.lua',
    'modules/regime/server.lua',
    'modules/iep/server.lua',
    'modules/discipline/server.lua',
    'modules/accounts/server.lua',
    'modules/canteen/server.lua',
    'modules/tasks/server.lua',
    'modules/industries/server.lua',
    'modules/education/server.lua',
    'modules/activities/server.lua',
    'modules/intel/server.lua',
    'modules/security/server.lua',
    'modules/incidents/server.lua',
    'modules/cctv/server.lua',
    'modules/visits/server.lua',
    'modules/phone/server.lua',
    'modules/gangs/server.lua',
    'modules/healthcare/server.lua',
    'modules/escape/server.lua',
    'modules/transport/server.lua',
    'modules/parole/server.lua',
    'modules/ai/server.lua',
    'modules/setupcheck/server.lua',
    'modules/kiosk/server.lua',
    'server/api.lua',
    'server/main.lua',
}

client_scripts {
    'client/nui.lua',
    'client/main.lua',
    'client/clothing.lua',
    'modules/estate/client.lua',
    'modules/doors/client.lua',
    'modules/custody/client.lua',
    'modules/reception/client.lua',
    'modules/release/client.lua',
    'modules/tablet/client.lua',
    'modules/editor/client.lua',
    'modules/editor/boundary.lua',
    'modules/editor/world.lua',
    'modules/kiosk/client.lua',
    'modules/tasks/client.lua',
    'modules/security/client.lua',
    'modules/incidents/client.lua',
    'modules/cctv/client.lua',
    'modules/visits/client.lua',
    'modules/phone/client.lua',
    'modules/gangs/client.lua',
    'modules/healthcare/client.lua',
    'modules/escape/client.lua',
    'modules/ai/client.lua',
}

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/assets/*',
    'web/build/sounds/*',
    'web/build/tablet/*',
    'locales/*.json',
}

escrow_ignore {
    'config/*.lua',
    'bridge/*.lua',
    'bridge/**/*.lua',
    'integrations/**/*.lua',
    'locales/*.json',
    'sql/**/*.sql',
}

dependency '/assetpacks'