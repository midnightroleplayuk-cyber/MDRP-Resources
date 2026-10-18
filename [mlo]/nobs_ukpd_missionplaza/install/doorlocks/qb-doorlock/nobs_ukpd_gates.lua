-- Mission Plaza vehicle gates for qb-doorlock: copy into qb-doorlock/configs/.
-- FIRST set MPGateConfig.controller = 'qb-doorlock' in config.lua. authorizedJobs is a placeholder.

-- Public entrance vehicle gate
Config.DoorList['nobs_mp_gate_entrance'] = {
    doorType = 'double',
    textCoords = vec3(421.40557, -358.65017, 47.40468),
    locked = false,
    distance = 10.0,
    doorRate = 1.0,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Public entrance vehicle gate',
    doors = {
        { objName = 'nobs_ukpd_mp_swing_leaf', objYaw = 229.12, objCoords = vec3(418.96422, -361.47023, 46.17608) },
        { objName = 'nobs_ukpd_mp_swing_leaf', objYaw = 49.12, objCoords = vec3(423.84692, -355.83011, 46.23329) },
    },
}

-- Police yard vehicle exit gate
Config.DoorList['nobs_mp_gate_exit'] = {
    doorType = 'double',
    textCoords = vec3(374.95019, -381.44708, 46.94862),
    locked = true,
    distance = 10.0,
    doorRate = 1.0,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Police yard vehicle exit gate',
    autoLock = 15000,   -- ms
    doors = {
        { objName = 'nobs_ukpd_mp_swing_leaf', objYaw = 175.19, objCoords = vec3(371.23333, -381.13431, 45.73028) },
        { objName = 'nobs_ukpd_mp_swing_leaf', objYaw = 355.19, objCoords = vec3(378.66706, -381.75984, 45.76696) },
    },
}
