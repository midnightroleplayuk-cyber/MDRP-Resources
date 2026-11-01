fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Sky-Systems'
description 'Base resource for all Sky-Systems Scripts'
version "1.50.0"

-- sky-profiler-build: B8db235160d00d15332116b24ee77da77
-- Sky Profiler: optional performance diagnostics for Sky support.
-- Default: disabled. Adds anonymous IDs to manually recorded FiveM profiles.
-- No automatic recordings or uploads. Private source mapping stays with Sky.
-- To enable for all Sky resources (server + clients), add to server.cfg BEFORE ensure:
--     setr sky_profiler 1
-- Restart the server, then record with the normal FiveM profiler commands.
-- To disable again: setr sky_profiler 0, then restart. Keep the shared_script line below.
-- DE: Standard: aus. Aktivieren: setr sky_profiler 1 in der server.cfg VOR ensure.
-- DE: Server neu starten, dann aufnehmen. Abschalten: setr sky_profiler 0 + Neustart.
shared_script "source/sky_callback_profiler.lua"
escrow_ignore {
    'config/**',
    'source/import.lua',
    'source/shared/modules/Callbacks.lua',
    'source/client/modules/Callbacks.lua',
    'source/server/modules/Callbacks.lua',
}

shared_scripts {
    'config/init.lua',
    'config/config.lua',
    'config/currency.lua',
    'config/qb_money.lua',
    'config/locales/*.lua',
    'config/functions.lua',
    'source/shared/init.lua',
    'source/shared/death_diagnostics.lua',
    'source/shared/utils/*.lua',
    'source/shared/modules/*.lua',
    'source/shared/main.lua',
    'source/shared/set_config.lua',
}

server_scripts {
    -- '@vrp/lib/utils.lua',
    '@mysql-async/lib/MySQL.lua',
    'config/framework/*.lua',
    'source/server/framework/jobs.lua',
    'source/server/framework/esx_jobs.lua',
    'source/server/framework/core_jobs.lua',
    'config/framework/compatibility/hex.lua',
    'source/server/inventory/helpers.lua',
    'config/integration/inventory/native/*.lua',
    'config/integration/inventory/*.lua',
    'source/server/inventory/defaults.lua',
    'config/integration/inventory/ox/usable.lua', -- Wrap the complete framework bridge after defaults.
    'source/server/inventory/usable.lua', -- Track the final provider callback's owning resource.
    'source/server/inventory/cache.lua',
    'config/integration/banking/*.lua',
    'config/sv_config.lua',
    'config/sv_functions.lua',
    'config/integration/vehiclekeys/server/_init.lua',
    'config/integration/vehiclekeys/server/qb.lua',
    'config/integration/vehiclekeys/server/vehicles_keys.lua',
    'config/vehicle_storage.lua',
    'config/integration/garage/*.lua',
    'config/integration/phone/*.lua',
    'config/integration/tablet/*.lua',
    'config/integration/voice/_init.lua',
    'config/integration/voice/pma.lua',
    'config/integration/voice/saltychat.lua',
    'config/integration/voice/yaca.lua',
    'config/integration/billing/*.lua',
    'config/integration/license/_helpers.lua',
    'config/integration/license/ak47.lua',
    'config/integration/license/bit.lua',
    'config/integration/license/codem.lua',
    'config/integration/license/cs.lua',
    'config/integration/license/custom.lua',
    'config/integration/license/esx.lua',
    'config/integration/license/papa.lua',
    'config/integration/license/qb.lua',
    'config/integration/license/qbox.lua',
    'config/integration/license/quasar.lua',
    'config/integration/license/standalone.lua',
    'config/integration/license/stg-walletv2.lua',
    'config/integration/license/vms.lua',
    'config/integration/license/main.lua', -- Normalize the selected adapter after all direct FW bindings.
    'source/server/main.lua',
    'source/server/vendor/community_hub_sha2.lua',
    'source/server/modules/*.lua',
    'source/server/creator_log_settings.lua',
    'source/server/framework/shared_definitions.lua',
    'source/server/framework/creator_catalog.lua',
    'source/server/managed_jobs.lua',
    'source/server/framework/esx_rename.lua',
    'source/server/framework/core_rename.lua',
    'source/server/framework/definition_delete.lua',
    'config/integration/housing/_init.lua',
    'config/integration/housing/custom.lua',
    'config/integration/housing/esx_property.lua',
    'config/integration/housing/qbx_properties.lua',
    'config/integration/housing/nolag.lua',
    'config/integration/housing/qs.lua',
    'config/integration/housing/rtx.lua',
    'config/integration/housing/rx.lua',
    'config/integration/housing/sn.lua',
    'config/integration/housing/vms.lua',
    'source/server/licenses.lua'
}
client_scripts {
    -- '@vrp/client/Proxy.lua',
    -- '@vrp/client/Tunnel.lua',
    'config/integration/phone/*.lua',
    'config/integration/tablet/*.lua',
    'config/integration/voice/_init.lua',
    'config/integration/voice/pma.lua',
    'config/integration/voice/saltychat.lua',
    'config/integration/voice/yaca.lua',
    'config/integration/notification/*.lua',
    'config/integration/helpnotify/*.lua',
    'config/integration/billing/lore.lua',
    'source/client/main.lua',
    'config/vehicle_functions.lua',
    'source/client/modules/*.lua',
    'config/integration/phone/client/*.lua',
    'source/client/events.lua',
    'config/integration/inventory/ox_events.lua',
    'config/integration/inventory/codemv2.lua',
    'config/framework/*.lua',
    'source/client/framework_state.lua',
    'config/integration/inventory/client/holster.lua',
    'config/integration/housing/_init.lua',
    'config/integration/housing/custom.lua',
    'config/integration/housing/nolag.lua',
    'config/integration/housing/qs.lua',
    'config/integration/housing/rtx.lua',
    'config/integration/housing/rx.lua',
    'config/integration/housing/sn.lua',
    'config/integration/housing/vms.lua',
    'config/integration/target/*.lua',
    'config/integration/vehiclekeys/*.lua',
    'config/integration/fuel/*.lua',
    'config/integration/weather/native.lua',
    'config/integration/weather/esx_weather.lua',
    'config/integration/weather/renewed.lua',
    'config/integration/weather/weathersync.lua',
    'config/integration/weather/qb-weathersync.lua',
    'config/integration/weather/cd_easytime.lua',
    'config/integration/weather/custom.lua',
    'source/client/weather.lua',
    'config/integration/medical/none.lua',
    'config/integration/medical/visn_are.lua',
    'config/integration/medical/custom.lua',
    'config/integration/progress/helpers/normalize.lua',
    'config/integration/progress/*.lua',
}

files {
    'source/import.lua',
    'source/html/index.html',
    'source/html/assets/*.*'
}

ui_page 'source/html/index.html'

dependency '/assetpacks'