-- NO BS SCRIPTS - Mission Plaza UK police station: armoury display data (clients).
-- Generated data, replaced by every update - do not edit. Every setting is in config.lua, section 3.
-- Positions and rotations are station-local (+x = true WNW, +y = true SSW, z up; ground floor z = 0) and become
-- world positions at runtime (mlo position + Rz(heading) * local). rot = {pitch, roll, yaw} in degrees, GTA
-- rotation order 2 (M = Rz(yaw) Rx(pitch) Ry(roll)); quat = the same rotation as {x, y, z, w}.
if type(ArmouryDisplay) ~= 'table' then
    print(("^3[%s] config.lua has no ArmouryDisplay (a mistake in config.lua, or a 1.1.x config.lua): the armoury display uses its default settings^7"):format(GetCurrentResourceName()))
    ArmouryDisplay = {}
elseif type(ArmouryDisplay.sets) == 'table' or type(ArmouryDisplay.mlo) == 'table' then
    print(("^3[%s] config.lua: ArmouryDisplay.sets / .mlo are 1.1.x generated data and are ignored (scripts/data/armoury_data.lua)^7"):format(GetCurrentResourceName()))
end
local A = ArmouryDisplay
for k, v in pairs({
    convar = 'nobs_ukpd_armoury_display',
    command = 'ukpd_armoury',
    pollInsideMs = 750,
    pollOutsideMs = 1000,
    convarEveryPolls = 5,
    exitMargin = 1.5,
    loadTimeoutMs = 8000,
    spawnBatch = 8,
    maxObjects = 70,
    releaseAssets = true,
    defaultComponents = false,
    lodDist = nil,
    rotationMode = 'auto',
    debugHosts = false,
}) do
    if A[k] == nil then A[k] = v end   -- the default of a setting config.lua does not set
end
A.mlo = { archetype = 'nobs_ukpd_mp', pos = { 418.302107, -318.718263, 45.942982 }, heading = 158.38175948, matchRadius = 3.0 }
A.sets = {
    {
        id = 'armoury_2', label = 'ARMOURY 2 / EVIDENCE STORE (ARV vehicle kit)', room = 'armoury_2', roomHash = -383841806,
        zones = {
            { room = 'armoury_2', min = { 40.975, 45.4, -0.5 }, max = { 55.7, 48.7, 3.7 } },  -- the armoury room itself
            { room = 'garage', min = { 36.25, 39.3, -0.5 }, max = { 48.25, 45.2, 4.45 } },  -- garage within 6 m of door_g_24
        },
        hosts = {  -- MLO entities in the product; spawned by the script only in debugHosts mode
            { id = 'rack', archetype = 'hei_int_heist_gunrack', pos = { 45.6, 48.404, 0.3757 }, heading = 90 },
            { id = 'issue_table', archetype = 'xm_prop_lab_desk_02', pos = { 47.4, 45.947, 0 }, heading = 180 },
        },
        anchors = {
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = { 'COMPONENT_AT_AR_FLSH' }, tint = 0, room = 'armoury_2',
              pos = { 45.9967, 48.4116, 0.4042 }, rot = { 0, -74.988, 90 }, quat = { 0.430402, -0.430402, 0.56103, 0.56103 }, host = 'rack', item = 'carbine_rack' },
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = { 'COMPONENT_AT_AR_FLSH' }, tint = 0, room = 'armoury_2',
              pos = { 45.8832, 48.4116, 0.4042 }, rot = { 0, -74.988, 90 }, quat = { 0.430402, -0.430402, 0.56103, 0.56103 }, host = 'rack', item = 'carbine_rack' },
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = { 'COMPONENT_AT_AR_FLSH' }, tint = 0, room = 'armoury_2',
              pos = { 45.7706, 48.4116, 0.4042 }, rot = { 0, -74.988, 90 }, quat = { 0.430402, -0.430402, 0.56103, 0.56103 }, host = 'rack', item = 'carbine_rack' },
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = { 'COMPONENT_AT_AR_FLSH' }, tint = 0, room = 'armoury_2',
              pos = { 45.657, 48.4116, 0.4042 }, rot = { 0, -74.988, 90 }, quat = { 0.430402, -0.430402, 0.56103, 0.56103 }, host = 'rack', item = 'carbine_rack' },
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = { 'COMPONENT_AT_AR_FLSH' }, tint = 0, room = 'armoury_2',
              pos = { 45.5434, 48.4116, 0.4042 }, rot = { 0, -74.988, 90 }, quat = { 0.430402, -0.430402, 0.56103, 0.56103 }, host = 'rack', item = 'carbine_rack' },
            { archetype = 'w_sg_pumpshotgun', weapon = 'WEAPON_PUMPSHOTGUN', components = {}, tint = 0, room = 'armoury_2',
              pos = { 45.3158, 48.4057, 0.382 }, rot = { 0, -74.988, 90 }, quat = { 0.430402, -0.430402, 0.56103, 0.56103 }, host = 'rack', item = 'breacher' },
            { archetype = 'w_pi_combatpistol', weapon = 'WEAPON_COMBATPISTOL', components = {}, tint = 0, room = 'armoury_2',
              pos = { 48.3161, 45.9867, 0.918 }, rot = { -90, 0, 270 }, quat = { -0.5, 0.5, -0.5, 0.5 }, host = 'issue_table', item = 'pistol' },
            { archetype = 'w_pi_combatpistol', weapon = 'WEAPON_COMBATPISTOL', components = {}, tint = 0, room = 'armoury_2',
              pos = { 48.0161, 45.9867, 0.918 }, rot = { -90, 0, 270 }, quat = { -0.5, 0.5, -0.5, 0.5 }, host = 'issue_table', item = 'pistol' },
            { archetype = 'w_pi_combatpistol_mag1', weapon = nil, components = {}, tint = nil, room = 'armoury_2',
              pos = { 47.6349, 46.0028, 0.9171 }, rot = { -90, 0, 180 }, quat = { 0, -0.707107, 0.707107, 0 }, host = 'issue_table', item = 'mag_pistol' },
            { archetype = 'w_pi_combatpistol_mag1', weapon = nil, components = {}, tint = nil, room = 'armoury_2',
              pos = { 47.5549, 46.0028, 0.9171 }, rot = { -90, 0, 180 }, quat = { 0, -0.707107, 0.707107, 0 }, host = 'issue_table', item = 'mag_pistol' },
            { archetype = 'w_pi_combatpistol_mag1', weapon = nil, components = {}, tint = nil, room = 'armoury_2',
              pos = { 47.4749, 46.0028, 0.9171 }, rot = { -90, 0, 180 }, quat = { 0, -0.707107, 0.707107, 0 }, host = 'issue_table', item = 'mag_pistol' },
            { archetype = 'w_ar_carbinerifle_mag1', weapon = nil, components = {}, tint = nil, room = 'armoury_2',
              pos = { 47.2105, 45.9716, 0.9141 }, rot = { -90, 0, 180 }, quat = { 0, -0.707107, 0.707107, 0 }, host = 'issue_table', item = 'mag_carbine' },
            { archetype = 'w_ar_carbinerifle_mag1', weapon = nil, components = {}, tint = nil, room = 'armoury_2',
              pos = { 47.0905, 45.9716, 0.9141 }, rot = { -90, 0, 180 }, quat = { 0, -0.707107, 0.707107, 0 }, host = 'issue_table', item = 'mag_carbine' },
        },
    },
    {
        id = 'sco19', label = 'FIREARMS UNIT ARMOURY / KIT / READY ROOM (first floor)', room = 'sco19', roomHash = -418976182,
        zones = {
            { room = 'sco19', min = { 34.3, 34.1, 3.7 }, max = { 43.525, 45.2, 7.7 } },  -- the armoury room itself
            { room = 'wing_corridor', min = { 43.725, 29, 3.7 }, max = { 46.3, 41, 7.7 } },  -- wing_corridor within 6 m of door_f_17
        },
        hosts = {  -- MLO entities in the product; spawned by the script only in debugHosts mode
            { id = 'e975', archetype = 'nobs_ukpd_d37_arm_rack_c', pos = { 39.2, 44.904, 4.5756 }, heading = 90 },
            { id = 'e976', archetype = 'nobs_ukpd_d37_arm_rack_c', pos = { 40.9, 44.904, 4.5756 }, heading = 90 },
            { id = 'arm_rack_c', archetype = 'nobs_ukpd_d37_arm_rack_c', pos = { 34.451, 43.9, 4.5757 }, heading = 180 },
            { id = 'e980', archetype = 'bkr_prop_gunlocker_01a', pos = { 34.664, 42.44, 4.1995 }, heading = 90 },
            { id = 'e979', archetype = 'xm_prop_lab_desk_02', pos = { 37.4, 42.07, 4.2 }, heading = 180 },
            { id = 'arm_clean_bench', archetype = 'xm_prop_lab_desk_02', pos = { 40.1, 42.07, 4.2 }, heading = 180 },
        },
        anchors = {
            { archetype = 'w_ar_carbineriflemk2', weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 'COMPONENT_AT_CR_BARREL_01', 'COMPONENT_AT_SIGHTS', 'COMPONENT_AT_AR_FLSH' }, tint = 0, room = 'sco19',
              pos = { 39.825, 44.8968, 4.5489 }, rot = { 0, -74.988, 90 }, quat = { 0.430401, -0.4304, 0.561031, 0.56103 }, host = 'e975', item = 'carbine_hero' },
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = { 'COMPONENT_AT_AR_FLSH' }, tint = 0, room = 'sco19',
              pos = { 39.5967, 44.9116, 4.6041 }, rot = { 0, -74.988, 90 }, quat = { 0.430401, -0.4304, 0.561031, 0.56103 }, host = 'e975', item = 'carbine_rack' },
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = { 'COMPONENT_AT_AR_FLSH' }, tint = 0, room = 'sco19',
              pos = { 39.1434, 44.9116, 4.6041 }, rot = { 0, -74.988, 90 }, quat = { 0.430401, -0.4304, 0.561031, 0.56103 }, host = 'e975', item = 'carbine_rack' },
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = { 'COMPONENT_AT_AR_FLSH' }, tint = 0, room = 'sco19',
              pos = { 38.6886, 44.9116, 4.6041 }, rot = { 0, -74.988, 90 }, quat = { 0.430401, -0.4304, 0.561031, 0.56103 }, host = 'e975', item = 'carbine_rack' },
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = {}, tint = 0, room = 'sco19',
              pos = { 41.4115, 44.9116, 4.6041 }, rot = { 0, -74.988, 90 }, quat = { 0.430401, -0.4304, 0.561031, 0.56103 }, host = 'e976', item = 'carbine_plain' },
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = {}, tint = 0, room = 'sco19',
              pos = { 41.1832, 44.9116, 4.6041 }, rot = { 0, -74.988, 90 }, quat = { 0.430401, -0.4304, 0.561031, 0.56103 }, host = 'e976', item = 'carbine_plain' },
            { archetype = 'w_sg_pumpshotgun', weapon = 'WEAPON_PUMPSHOTGUN', components = {}, tint = 0, room = 'sco19',
              pos = { 40.957, 44.9057, 4.5819 }, rot = { 0, -74.988, 90 }, quat = { 0.430401, -0.4304, 0.561031, 0.56103 }, host = 'e976', item = 'breacher' },
            { archetype = 'w_sg_pumpshotgun', weapon = 'WEAPON_PUMPSHOTGUN', components = {}, tint = 0, room = 'sco19',
              pos = { 40.7296, 44.9057, 4.5819 }, rot = { 0, -74.988, 90 }, quat = { 0.430401, -0.4304, 0.561031, 0.56103 }, host = 'e976', item = 'breacher' },
            { archetype = 'w_sg_pumpshotgun', weapon = 'WEAPON_PUMPSHOTGUN', components = {}, tint = 0, room = 'sco19',
              pos = { 40.5022, 44.9057, 4.5819 }, rot = { 0, -74.988, 90 }, quat = { 0.430401, -0.4304, 0.561031, 0.56103 }, host = 'e976', item = 'breacher' },
            { archetype = 'w_sb_smg', weapon = 'WEAPON_SMG', components = {}, tint = 0, room = 'sco19',
              pos = { 34.4504, 44.2967, 4.5782 }, rot = { 0, -74.988, 180 }, quat = { 0.608678, 0, 0.793417, 0 }, host = 'arm_rack_c', item = 'legacy_smg' },
            { archetype = 'w_sb_smg', weapon = 'WEAPON_SMG', components = {}, tint = 0, room = 'sco19',
              pos = { 34.4504, 43.957, 4.5782 }, rot = { 0, -74.988, 180 }, quat = { 0.608678, 0, 0.793417, 0 }, host = 'arm_rack_c', item = 'legacy_smg' },
            { archetype = 'w_sb_smg', weapon = 'WEAPON_SMG', components = {}, tint = 0, room = 'sco19',
              pos = { 34.4504, 43.6158, 4.5782 }, rot = { 0, -74.988, 180 }, quat = { 0.608678, 0, 0.793417, 0 }, host = 'arm_rack_c', item = 'legacy_smg' },
            { archetype = 'w_ar_carbinerifle', weapon = 'WEAPON_CARBINERIFLE', components = {}, tint = 0, room = 'sco19',
              pos = { 34.5831, 42.3262, 5.0031 }, rot = { 0, -75, 180 }, quat = { -0.608761, 0, -0.793353, 0 }, host = 'e980', item = 'carbine_plain' },
            { archetype = 'w_pi_combatpistol', weapon = 'WEAPON_COMBATPISTOL', components = {}, tint = 0, room = 'sco19',
              pos = { 38.4161, 42.2997, 5.118 }, rot = { -90, 0, 270 }, quat = { -0.5, 0.5, -0.5, 0.5 }, host = 'e979', item = 'pistol' },
            { archetype = 'w_pi_combatpistol', weapon = 'WEAPON_COMBATPISTOL', components = {}, tint = 0, room = 'sco19',
              pos = { 38.1661, 42.2997, 5.118 }, rot = { -90, 0, 270 }, quat = { -0.5, 0.5, -0.5, 0.5 }, host = 'e979', item = 'pistol' },
            { archetype = 'w_pi_combatpistol', weapon = 'WEAPON_COMBATPISTOL', components = {}, tint = 0, room = 'sco19',
              pos = { 37.9161, 42.2997, 5.118 }, rot = { -90, 0, 270 }, quat = { -0.5, 0.5, -0.5, 0.5 }, host = 'e979', item = 'pistol' },
            { archetype = 'w_pi_combatpistol_mag1', weapon = nil, components = {}, tint = nil, room = 'sco19',
              pos = { 37.6049, 42.3258, 5.1171 }, rot = { -90, 0, 180 }, quat = { 0, -0.707107, 0.707107, 0 }, host = 'e979', item = 'mag_pistol' },
            { archetype = 'w_pi_combatpistol_mag1', weapon = nil, components = {}, tint = nil, room = 'sco19',
              pos = { 37.5049, 42.3258, 5.1171 }, rot = { -90, 0, 180 }, quat = { 0, -0.707107, 0.707107, 0 }, host = 'e979', item = 'mag_pistol' },
            { archetype = 'w_ar_carbinerifle_mag1', weapon = nil, components = {}, tint = nil, room = 'sco19',
              pos = { 37.1105, 42.2946, 5.1141 }, rot = { -90, 0, 180 }, quat = { 0, -0.707107, 0.707107, 0 }, host = 'e979', item = 'mag_carbine' },
            { archetype = 'w_sr_sniperrifle', weapon = 'WEAPON_SNIPERRIFLE', components = { 'COMPONENT_AT_SCOPE_LARGE' }, tint = 0, room = 'sco19',
              pos = { 39.9998, 42.3188, 5.1366 }, rot = { -90, 0, 360 }, quat = { -0.707107, 0, 0, 0.707107 }, host = 'arm_clean_bench', item = 'precision_rifle' },
            { archetype = 'w_pi_combatpistol', weapon = 'WEAPON_COMBATPISTOL', components = {}, tint = 0, room = 'sco19',
              pos = { 41.0161, 42.3097, 5.118 }, rot = { -90, 0, 270 }, quat = { -0.5, 0.5, -0.5, 0.5 }, host = 'arm_clean_bench', item = 'pistol' },
            { archetype = 'w_pi_combatpistol_mag1', weapon = nil, components = {}, tint = nil, room = 'sco19',
              pos = { 41.1849, 42.2758, 5.1171 }, rot = { -90, 0, 180 }, quat = { 0, -0.707107, 0.707107, 0 }, host = 'arm_clean_bench', item = 'mag_pistol' },
        },
    },
}
