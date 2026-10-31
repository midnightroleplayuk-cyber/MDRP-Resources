fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vinewood_police'
author 'Vinewood Studios'
description 'Vinewood Police Operations: British police job for Qbox, QBCore and ESX'
version '1.7.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua',
    'config/ranks.lua',
    'config/qualifications.lua',
    'config/duty.lua',
    'config/stations.lua',
    'config/equipment.lua',
    'config/restraint.lua',
    'config/arrest.lua',
    'config/roads.lua',
    'config/npc.lua',
    'config/scene.lua',
    'config/custody.lua',
    'config/evidence.lua',
    'config/callouts.lua',
    'config/incidents.lua',
    'config/standards.lua',
    'config/specialist.lua',
    'config/management.lua',
    'shared/vpo.lua',
    'shared/constants.lua',
    'shared/ranks.lua',
    'shared/locations.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/framework/init.lua',
    'bridge/framework/qb.lua',
    'bridge/framework/esx.lua',
    'bridge/inventory/init.lua',
    'bridge/inventory/ox.lua',
    'bridge/inventory/qb.lua',
    'bridge/inventory/esx.lua',
    'bridge/notify_server.lua',
    'integrations/init.lua',
    'integrations/mdt.lua',
    'integrations/dispatch.lua',
    'integrations/licensing.lua',
    'integrations/vehicleservices.lua',
    'integrations/justice.lua',
    'integrations/pending.lua',
    'server/core/defaults.lua',
    'server/core/validate.lua',
    'server/core/migrations.lua',
    'server/core/audit.lua',
    'server/core/ratelimit.lua',
    'server/core/state.lua',
    'server/core/officers.lua',
    'server/core/qualifications.lua',
    'server/core/permissions.lua',
    'server/core/net.lua',
    'server/core/commands.lua',
    'server/core/main.lua',
    'server/modules/locations.lua',
    'server/modules/admin.lua',
    'server/modules/stations.lua',
    'server/modules/duty.lua',
    'server/modules/notebook.lua',
    'server/modules/equipment.lua',
    'server/modules/armoury.lua',
    'server/modules/hub.lua',
    'server/modules/restraint.lua',
    'server/modules/arrest.lua',
    'server/modules/roads.lua',
    'server/modules/npc.lua',
    'server/modules/roads_npc.lua',
    'server/modules/roadside_kit.lua',
    'server/modules/scene.lua',
    'server/modules/custody.lua',
    'server/modules/custody_npc.lua',
    'server/modules/evidence.lua',
    'server/modules/encounters.lua',
    'server/modules/callouts.lua',
    'server/modules/callouts_scenarios.lua',
    'server/modules/incidents.lua',
    'server/modules/cid.lua',
    'server/modules/standards.lua',
    'server/modules/dogs.lua',
    'server/modules/stinger.lua',
    'server/modules/management.lua',
    'server/exports.lua',
}

client_scripts {
    'bridge/client.lua',
    'bridge/target/init.lua',
    'bridge/target/ox.lua',
    'bridge/target/qb.lua',
    'client/core/main.lua',
    'client/core/nui.lua',
    'client/core/zones.lua',
    'client/modules/duty.lua',
    'client/hooks.lua',
    'client/modules/equipment.lua',
    'client/modules/restraint.lua',
    'client/modules/restraint_props.lua',
    'client/modules/restraint_target.lua',
    'client/modules/arrest.lua',
    'client/modules/roads.lua',
    'client/modules/npc.lua',
    'client/modules/scene.lua',
    'client/modules/custody.lua',
    'client/modules/celldoors.lua',
    'client/modules/worldtools.lua',
    'client/modules/cctv.lua',
    'client/modules/encounters.lua',
    'client/modules/locations.lua',
    'client/modules/incidents.lua',
    'client/modules/standards.lua',
    'client/modules/dogs.lua',
    'client/modules/stinger.lua',
    'client/modules/radial.lua',
}

-- Vinewood props: front cuffs, police cone, road signs (vinewood_policeprops) and the forensic tent
data_file 'DLC_ITYP_REQUEST' 'stream/vinewood_policeprops.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/forensic_tent.ytyp'

ui_page 'web/index.html'

files {
    'locales/*.json',
    'web/index.html',
    'web/style.css',
    'web/app.js',
    'web/sounds/*.wav',
}

dependencies {
    '/onesync',
    'ox_lib',
    'oxmysql',
}

-- Asset Escrow: everything is encrypted except the files buyers are expected to edit.
escrow_ignore {
    'config/*.lua',
    'locales/*.json',
    'bridge/**/*.lua',
    'bridge/*.lua',
    'integrations/*.lua',
    'client/hooks.lua',
}

dependency '/assetpacks'