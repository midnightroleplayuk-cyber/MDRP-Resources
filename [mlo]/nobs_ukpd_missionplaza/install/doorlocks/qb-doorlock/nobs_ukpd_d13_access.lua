-- Mission Plaza access-controlled doors for qb-doorlock: copy this file into qb-doorlock/configs/ next to
-- nobs_ukpd_custody.lua. World pivots of the MLO door entities.
-- authorizedJobs are role placeholders: { ['police'] = 0 } for every door except the three armouries, which use
-- { ['firearms'] = 0 } - 'firearms' stands for your firearms-unit job; rename it (or use police with its grade).

-- Armoury / CED kit store (ARM)
Config.DoorList['nobs_ukpd_d13_armoury'] = {
    objName = 'nobs_ukpd_d22_secure_solid_n_hinge',
    objYaw = 158.38,
    objCoords = vec3(394.77200, -317.24571, 45.94298),
    doorType = 'door',
    textCoords = vec3(395.28331, -317.44834, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['firearms'] = 0 },
    doorLabel = 'Armoury / CED kit store (ARM)',
    autoLock = 15000,   -- ms
}

-- Armoury 2 / ARV kit and seized firearms (ARM2)
Config.DoorList['nobs_ukpd_d13_armoury_2'] = {
    objName = 'nobs_ukpd_d22_secure_solid_p_hinge',
    objYaw = 338.38,
    objCoords = vec3(362.84587, -345.46869, 45.94298),
    doorType = 'door',
    textCoords = vec3(362.33455, -345.26606, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['firearms'] = 0 },
    doorLabel = 'Armoury 2 / ARV kit and seized firearms (ARM2)',
    autoLock = 15000,   -- ms
}

-- Firearms unit armoury / ready room (FAU)
Config.DoorList['nobs_ukpd_d13_firearms_armoury'] = {
    objName = 'nobs_ukpd_d22_secure_solid_n_hinge',
    objYaw = 68.38,
    objCoords = vec3(365.05363, -334.67268, 50.14298),
    doorType = 'door',
    textCoords = vec3(364.85100, -335.18399, 51.34298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['firearms'] = 0 },
    doorLabel = 'Firearms unit armoury / ready room (FAU)',
    autoLock = 15000,   -- ms
}

-- Evidence / property store (EVI)
Config.DoorList['nobs_ukpd_d13_evidence'] = {
    objName = 'nobs_ukpd_d22_secure_solid_n_hinge',
    objYaw = 158.38,
    objCoords = vec3(414.55050, -325.08386, 45.94298),
    doorType = 'door',
    textCoords = vec3(415.06181, -325.28649, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Evidence / property store (EVI)',
    autoLock = 15000,   -- ms
}

-- Control room / CCTV (CTL)
Config.DoorList['nobs_ukpd_d13_control_room'] = {
    objName = 'nobs_ukpd_d22_secure_solid_n_hinge',
    objYaw = 338.38,
    objCoords = vec3(399.42667, -322.53246, 45.94298),
    doorType = 'door',
    textCoords = vec3(398.91535, -322.32983, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Control room / CCTV (CTL)',
}

-- Forensics lab (FOR)
Config.DoorList['nobs_ukpd_d13_forensics'] = {
    objName = 'nobs_ukpd_d22_secure_solid_n_hinge',
    objYaw = 158.38,
    objCoords = vec3(406.53219, -321.90623, 45.94298),
    doorType = 'door',
    textCoords = vec3(407.03890, -322.12048, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Forensics lab (FOR)',
}

-- Roof access (stair 1) (ROOF)
Config.DoorList['nobs_ukpd_d12_roof'] = {
    objName = 'nobs_ukpd_d14_roof_door_ref2',
    objYaw = 338.38,
    objCoords = vec3(398.66521, -318.86925, 54.09298),
    doorType = 'door',
    textCoords = vec3(398.15389, -318.66662, 55.29298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Roof access (stair 1) (ROOF)',
}

-- Public / staff pass door (PUB)
Config.DoorList['nobs_ukpd_d13_public_pass'] = {
    doorType = 'double',
    textCoords = vec3(415.54694, -327.02770, 47.14298),
    locked = true,
    distance = 2.0,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Public / staff pass door (PUB)',
    doors = {
        { objName = 'nobs_ukpd_d36_fire100_p_glass', objYaw = 68.38, objCoords = vec3(415.91536, -326.09804, 45.94298) },
        { objName = 'nobs_ukpd_d36_fire100_n_glass', objYaw = 248.38, objCoords = vec3(415.17852, -327.95735, 45.94298) },
    },
}

-- Stair 2 from the public corridor (ST2)
Config.DoorList['nobs_ukpd_d13_stair_2_public'] = {
    objName = 'nobs_ukpd_d36_fire110_n_hinge',
    objYaw = 158.38,
    objCoords = vec3(424.92085, -329.19359, 45.94298),
    doorType = 'door',
    textCoords = vec3(425.43216, -329.39622, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Stair 2 from the public corridor (ST2)',
}

-- Garage yard door (GAR)
Config.DoorList['nobs_ukpd_d13_garage_yard'] = {
    objName = 'nobs_ukpd_d14_exit_steel_110_ref2',
    objYaw = 68.38,
    objCoords = vec3(375.28651, -335.71607, 45.94298),
    doorType = 'door',
    textCoords = vec3(375.08388, -336.22739, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Garage yard door (GAR)',
}

-- Stair 3 external door (ST3)
Config.DoorList['nobs_ukpd_d13_stair_3_exit'] = {
    objName = 'nobs_ukpd_d14_exit_steel_110_ref2',
    objYaw = 338.38,
    objCoords = vec3(365.85630, -350.93479, 45.94298),
    doorType = 'door',
    textCoords = vec3(365.34499, -350.73215, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Stair 3 external door (ST3)',
}

-- CID office (CID)
Config.DoorList['nobs_ukpd_d13_cid'] = {
    objName = 'nobs_ukpd_d36_fire110_p_hinge',
    objYaw = 158.38,
    objCoords = vec3(369.59506, -310.71030, 50.14298),
    doorType = 'door',
    textCoords = vec3(370.10638, -310.91293, 51.34298),
    locked = false,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'CID office (CID)',
}

-- Intel office (INT)
Config.DoorList['nobs_ukpd_d13_intel'] = {
    objName = 'nobs_ukpd_d36_fire110_p_hinge',
    objYaw = 68.38,
    objCoords = vec3(360.12076, -339.65582, 50.14298),
    doorType = 'door',
    textCoords = vec3(359.91813, -340.16714, 51.34298),
    locked = false,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Intel office (INT)',
}

-- Firearms armoury weapons cage gate (FAUC)
Config.DoorList['nobs_ukpd_d13_firearms_cage'] = {
    doorType = 'double',
    textCoords = vec3(363.49052, -341.63664, 51.34298),
    locked = true,
    distance = 2.0,
    pickable = false,
    authorizedJobs = { ['firearms'] = 0 },
    doorLabel = 'Firearms armoury weapons cage gate (FAUC)',
    doors = {
        { objName = 'nobs_ukpd_d11_cage_gate_leaf_r', objYaw = 158.38, objCoords = vec3(362.56086, -341.26822, 50.14298) },
        { objName = 'nobs_ukpd_d11_cage_gate_leaf_l', objYaw = 338.38, objCoords = vec3(364.42017, -342.00506, 50.14298) },
    },
}
