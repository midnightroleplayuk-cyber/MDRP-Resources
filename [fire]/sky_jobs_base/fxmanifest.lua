fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Sky-Systems'
description 'Jobs Base'
version "1.53.0"

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
    'source/shared/locale_loader.lua', -- Read as Lua text by the client's locale loader.
}

shared_script {
	'@sky_base/source/import.lua',
    'source/shared/readiness.lua',
    'source/shared/state_sync.lua',
    'source/shared/jobs_base_config_runtime.lua',
    'source/shared/bell_config.lua',
    'source/shared/exclusion_zone_map.lua',
    'source/shared/vehicle_registry_rules.lua',
	'source/enums/*.lua',
    'source/shared/management_permission_catalog.lua',
    'source/shared/job_role_defaults.lua',
}

client_scripts {
	'@sky_base/source/shared/modules/Poly.lua',
	'@sky_base/source/client/modules/Ped.lua',
	'@sky_base/source/client/modules/Vehicle.lua',
	'@sky_base/source/client/modules/Cam.lua',
	'config/init.lua',
	'config/config.lua',
	'config/item_containers.lua',
	'config/printers.lua',
	'config/player_actions.lua',
	'source/client/configurator/jobs_base_configurator.lua',
	'source/shared/diagnostics.lua',
	'source/client/modules/garage_persistence.lua',
	'source/client/modules/navmesh.lua',
	'source/client/modules/placement_freecam.lua',
    'source/client/modules/printer_prop.lua',
    'source/client/modules/online_supply_carry.lua',
    'source/client/modules/online_supply_delivery.lua',
	'source/client/utils/item_images.lua',
	'source/client/utils/vehicle_images.lua',
	'source/client/interactions/utils.lua',
	'source/client/interactions/restraints/handcuffs.lua',
	'source/client/interactions/civilian_interactions.lua',
	'source/client/interactions/restraints/leg_restraints.lua',
	'source/client/interactions/escort.lua',
	'source/client/interactions/restraints/head_bag.lua',
	'source/client/interactions/player_search.lua',
	'source/client/interactions/identity.lua',
	'source/client/*.lua',
    'source/client/compatibility/jaksam.lua',
    'source/client/compatibility/hex.lua',
}

server_scripts {
	'config/init.lua',
	'config/config.lua',
	'config/item_containers.lua',
	'config/printers.lua',
	'source/config_default.lua',
	'config/player_actions.lua',
	'config/webhooks.lua',
	'source/server/jobs.lua',
	'source/server/dispatch_configurator_schema.lua',
	'source/server/dispatch_postals.lua',
	'source/server/printer_configurator_schema.lua',
	'source/server/bell_configurator_schema.lua',
    'source/server/business_configurator_schema.lua',
    'source/server/online_shop_configurator_schema.lua',
    'source/server/farming_configurator_schema.lua',
	'source/server/job_configurator.lua',
	'source/server/framework_deletion.lua',
	'source/server/framework_catalog.lua',
    'source/server/framework_templates.lua',
    'source/server/framework_overview.lua',
	'source/server/framework_members.lua',
	'source/server/framework_lifecycle_plan.lua',
	'source/server/framework_reference_rename.lua',
	'source/server/framework_rename.lua',
	'source/server/jobs_base_configurator.lua',
	'source/shared/diagnostics.lua',
	'source/server/db_migrate.lua',
	'source/server/organization_memberships.lua',
	'source/server/sharing.lua',
    'source/server/record_access.lua',
    'source/server/registries.lua',
	'source/server/classes/*.lua',
    'source/server/raids.lua',
	'source/server/interactions/utils.lua',
	'source/server/interactions/restraints/handcuffs.lua',
	'source/server/interactions/restraints/leg_restraints.lua',
	'source/server/interactions/escort.lua',
	'source/server/interactions/restraints/head_bag.lua',
	'source/server/interactions/player_search.lua',
	'source/server/service_documents.lua',
	'source/server/interactions/identity.lua',
	'source/server/media/providers.lua',
	'source/server/calendar.lua',
	'source/server/personal_notes.lua',
	'source/server/cctv.lua',
	'source/server/chat.lua',
	'source/server/colleague_map_blips.lua',
	'source/server/creator.lua',
	'source/server/dark_chat.lua',
	'source/server/dispatch_spatial_sound.lua',
	'source/server/dispatch.lua',
	'source/server/dispatch_access.lua',
	'source/server/dispatch_pdf_export.lua',
	'source/server/dispatch_center.lua',
	'source/server/duty.lua',
	'source/server/emergencydispatch.lua',
	'source/server/employee_gps_jammer.lua',
	'source/server/drug_tests.lua',
	'source/server/gallery.lua',
	'source/server/modules/garage_persistence.lua',
	'source/server/garage.lua',
	'source/server/heli_cam.lua',
	'source/server/job_configurator_runtime.lua',
	'source/server/printers.lua',
	'source/server/printers_maintenance.lua',
	'source/server/management.lua',
    'source/server/business.lua',
    'source/server/compatibility/jaksam.lua',
    'source/server/compatibility/hex.lua',
    'source/server/billing.lua',
	'source/server/bells.lua',
    'source/server/record_documents.lua',
    'source/server/record_stationery.lua',
    'source/server/shared_documents.lua',
    'source/server/record_grants.lua',
    'source/server/bodycam_records.lua',
    'source/server/printed_documents.lua',
    'source/server/vehicle_registry.lua',
	'source/server/organization_units.lua',
	'source/server/training.lua',
	'source/server/tracking.lua',
	'source/server/map.lua',
	'source/server/multijob.lua',
	'source/server/panic.lua',
	'source/server/player_carry.lua',
	'source/server/item_containers.lua',
	'source/server/prop_items.lua',
	'source/server/prop_offset.lua',
	'source/server/public_forms.lua',
	'source/server/wholesale_orders.lua',
    'source/server/online_shop.lua',
    'source/server/farming.lua',
	'source/server/shop.lua',
	'source/server/storage.lua',
	'source/server/tablet_state.lua',
	'source/server/tablet_notifications.lua',
	'source/server/tablet_legacy_data.lua',
	'source/server/trunk_props.lua',
	'source/server/wardrobe.lua',
	'source/server/generic_jobs.lua',
	'source/server/generic_documents.lua',
	'source/server/diagnostics.lua',
	'source/server/main.lua',
}

files {
    'config/documents/**',
    'stream/sky_printers.ytyp',
    'stream/sky_job_bells.ytyp',
    'config/sounds/bells/**',
    'source/shared/locale_loader.lua',
    'source/client/job_keybinds.lua',
    'config/inventory/ox_briefcase_buttons.lua',
    'config/inventory/chezza_restraints.lua',
    'config/inventory/hex_restraints.lua',
    'source/shared/job_keybind_config.lua',
	'source/html/index.html',
	'source/html/document-preview.html',
	'source/html/*.svg',
	'source/html/assets/**',
	'source/html/img/**',
	'config/images/duty/*.webp',
	'config/images/duty/*.png',
	'config/images/duty/*.svg',
	'config/locales/*.lua',
	'config/locales/jobconfigurator/**/*.lua',
    'config/postal/**',
	'source/import.lua',
    'source/shared/state_sync.lua'
}

ui_page 'source/html/index.html'
data_file 'DLC_ITYP_REQUEST' 'stream/sky_printers.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/sky_job_bells.ytyp'

dependency 'sky_base'

dependency '/assetpacks'