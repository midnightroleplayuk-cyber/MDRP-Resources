fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Sky-Systems'
description 'Fire Job'
version "1.20.0"

-- sky-profiler-build: Bbf94767429f2791e7ad75dbb98189278
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
    'source/dependencies.lua',
}

shared_scripts {
    "source/dependencies.lua",
    '@sky_jobs_base/source/shared/job_keybind_config.lua',
    'source/shared/fire_effects.lua',
    '@sky_jobs_base/source/shared/state_sync.lua',
	'source/shared/heli_bucket_geometry.lua',
	'source/shared/water_monitor_geometry.lua',
	'source/shared/vehicle_cannons.lua',
	'source/shared/pump_control.lua',
	'source/shared/jobs.lua',
}

client_scripts {
    'source/client/player_state.lua',
    '@sky_jobs_base/source/client/job_keybinds.lua',
    '@sky_jobs_base/source/client/tablet_radio_bridge.lua',
	'@sky_base/source/client/modules/Ped.lua',
	'@sky_base/source/client/modules/Vehicle.lua',
	'config/init.lua',
	'config/config.lua',
	'config/editor/*.lua',
	'config/locales/*.lua',
	'source/shared/locale_defaults.lua',
	'source/shared/default_config.lua',
	'source/client/main.lua',
	'source/client/sounds.lua',
	'source/client/tablet_bridge.lua',
	'source/client/files.lua',
	'source/client/reports.lua',
	'source/client/gallery.lua',
	'source/client/fire/state.lua',
	'source/client/particle_fx.lua',
	'source/client/fire/gear.lua',
	'source/client/nozzle.lua',
	'source/client/vehicle_water_transfer.lua',
	'source/client/vehicle_pump_behavior.lua',
	'source/client/water_monitor.lua',
	'source/client/dividing.lua',
	'source/client/firetruck_water_hud.lua',
	'source/client/oil_spills.lua',
	'source/client/interior_extinguishers.lua',
	'source/client/rescue_cushion.lua',
	'source/client/heli_bucket.lua',
	'source/client/player_carry.lua',
	'source/client/billing.lua',
	'source/client/radial_menu.lua',
	'source/client/fire/settings.lua',
	'source/client/fire/air_refill.lua',
	'source/client/fire/admin_menu.lua',
	'source/client/fire/environment.lua',
	'source/client/fire/molotov.lua',
	'source/client/fire/vehicle_fires.lua',
	'source/client/fire/prop_ignition.lua',
	'source/client/fire/props.lua',
	'source/client/fire/effects.lua',
	'source/client/fire/audio.lua',
	'source/client/fire/thirst.lua',
	'source/client/fire/npc_reactions.lua',
	'source/client/fire/heat_haze.lua',
	'source/client/fire/smoke_poisoning.lua',
	'source/client/fire/debug.lua',
	'source/client/vehicle_bone_debug.lua',
	'source/client/fire/sync.lua',
	'source/client/scenarios/state.lua',
	'source/client/scenarios/debug.lua',
	'source/client/scenarios/sync.lua',
	'source/client/scenarios/gizmo.lua',
	'source/client/scenarios/creator.lua',
	'source/client/vehicle_rescue/state.lua',
	'source/client/vehicle_rescue/tools.lua',
	'source/client/vehicle_rescue/minigames.lua',
	'source/client/vehicle_rescue/main.lua',
	'source/client/player_entrapment.lua',
	'source/client/trapped_patient_rescue.lua',
	'source/client/treeincident/state.lua',
	'source/client/treeincident/minigames.lua',
	'source/client/treeincident/carry.lua',
	'source/client/treeincident/main.lua',
}

server_scripts {
	'config/init.lua',
	'config/config.lua',
	'config/sv_functions.lua',
	'config/editor/*.lua',
	'config/locales/*.lua',
	'source/shared/locale_defaults.lua',
	'source/shared/default_config.lua',
	'source/server/db_migrate.lua',
	'source/shared/config_defaults.lua',
	'source/server/sounds.lua',
	'source/server/job_configurator.lua',
	'source/server/society_rewards.lua',
	'source/server/billing.lua',
	'source/server/tablet_apps.lua',
	'source/server/files.lua',
	'source/server/reports.lua',
	'source/server/nozzle.lua',
	'source/server/pump_control.lua',
	'source/server/dividing.lua',
	'source/server/vehicle_water_transfer.lua',
	'source/server/water_monitor.lua',
	'source/server/fire/state.lua',
	'source/server/fire/gear.lua',
	'source/server/fire/spawn.lua',
	'source/server/fire/spread.lua',
	'source/server/fire/molotov.lua',
	'source/server/fire/vehicle_fires.lua',
	'source/server/fire/prop_ignition.lua',
	'source/server/fire/extinguish.lua',
	'source/server/fire/thirst.lua',
	'source/server/fire/sync.lua',
	'source/server/fire/commands.lua',
	'source/server/fire/admin_menu.lua',
	'source/server/oil_spills.lua',
	'source/server/interior_extinguishers.lua',
	'source/server/rescue_cushion.lua',
	'source/server/heli_bucket.lua',
	'source/server/player_carry.lua',
	'source/server/scenarios/state.lua',
	'source/server/scenarios/objects.lua',
	'source/server/scenarios/runtime.lua',
	'source/server/vendor/sha2.lua',
	'source/server/scenarios/hub.lua',
	'source/server/scenarios/sync.lua',
	'source/server/scenarios/callbacks.lua',
	'source/server/scenarios/commands.lua',
	'source/server/vehicle_rescue/state.lua',
	'source/server/vehicle_rescue/callbacks.lua',
	'source/server/player_entrapment.lua',
	'source/server/trapped_patient_rescue.lua',
	'source/server/treeincident/state.lua',
	'source/server/treeincident/runtime.lua',
	'source/server/treeincident/callbacks.lua',
	'source/server/resource_cleanup.lua',
	'source/server/main.lua',
}

files {
	'source/assets/effects/**',
	'config/img/**',
	'config/style.css',
	'source/html/index.html',
	'source/html/assets/**',
	'source/html/audio/**',
	'source/html/images/**',
	'source/html/*.mp3',
	'source/html/audio/*.wav',

	'stream/**/*.ybn',
    'stream/**/*.ydr',
    'stream/**/*.ytd',
    'stream/**/*.ytyp',
	'meta/**/*.meta',
}

ui_page 'source/html/index.html'

data_file 'CLIP_SETS_FILE' 'meta/eu_hose_clip_sets.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/**/*.ytyp'

dependency 'sky_base'
dependency 'sky_jobs_base'

dependency '/assetpacks'