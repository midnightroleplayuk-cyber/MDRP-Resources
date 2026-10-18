-- Mission Plaza custody doors for qb-doorlock: copy this file into qb-doorlock/configs/ (loaded by its
-- fxmanifest 'configs/*.lua'). World pivots of the MLO door entities.
-- authorizedJobs { ['police'] = 0 } is a placeholder: set your job(s)/grades (we suggest a sergeant/custody grade
-- for A1, A2, G1, S1). The interlock block at the end runs inside qb-doorlock (server side).

-- Custody garage entry (G1)
Config.DoorList['nobs_ukpd_d11_g1'] = {
    doorType = 'double',
    textCoords = vec3(366.48875, -323.24777, 47.14298),
    locked = true,
    distance = 2.0,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Custody garage entry (G1)',
    doors = {
        { objName = 'nobs_ukpd_d22_securepair_r_p_glass', objYaw = 158.38, objCoords = vec3(365.65580, -322.63531, 45.94298) },
        { objName = 'nobs_ukpd_d22_securepair_l_n_glass', objYaw = 338.38, objCoords = vec3(367.51512, -323.37215, 45.94298) },
    },
}

-- Custody staff entry (S1)
Config.DoorList['nobs_ukpd_d11_s1'] = {
    doorType = 'double',
    textCoords = vec3(388.64047, -316.85956, 47.14298),
    locked = true,
    distance = 2.0,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Custody staff entry (S1)',
    autoLock = 10000,   -- ms
    doors = {
        { objName = 'nobs_ukpd_d22_securepair_r_p_glass', objYaw = 68.38, objCoords = vec3(389.00889, -315.92990, 45.94298) },
        { objName = 'nobs_ukpd_d22_securepair_l_n_glass', objYaw = 248.38, objCoords = vec3(388.27205, -317.78922, 45.94298) },
    },
}

-- Cell hall response door (E1)
Config.DoorList['nobs_ukpd_d11_e1'] = {
    objName = 'nobs_ukpd_d36_secure_door_single',
    objYaw = 338.38,
    objCoords = vec3(387.12030, -314.75120, 45.94298),
    doorType = 'door',
    textCoords = vec3(386.60899, -314.54857, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Cell hall response door (E1)',
    autoLock = 10000,   -- ms
}

-- Custody staff side (S2)
Config.DoorList['nobs_ukpd_d11_s2'] = {
    objName = 'nobs_ukpd_d36_secure_door_single_lh',
    objYaw = 338.38,
    objCoords = vec3(386.27982, -319.04347, 45.94298),
    doorType = 'door',
    textCoords = vec3(385.76851, -318.84084, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Custody staff side (S2)',
}

-- Custody walk-in (S3)
Config.DoorList['nobs_ukpd_d11_s3'] = {
    doorType = 'double',
    textCoords = vec3(382.79360, -317.66189, 47.14298),
    locked = true,
    distance = 2.0,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Custody walk-in (S3)',
    doors = {
        { objName = 'nobs_ukpd_d36_secure_door_pair_r', objYaw = 338.38, objCoords = vec3(383.72326, -318.03031, 45.94298) },
        { objName = 'nobs_ukpd_d36_secure_door_pair_l', objYaw = 158.38, objCoords = vec3(381.86394, -317.29347, 45.94298) },
    },
}

-- Custody desk staff gate (S4)
Config.DoorList['nobs_ukpd_d11_s4'] = {
    objName = 'nobs_ukpd_d36_glazed_staff_gate',
    objYaw = 68.38,
    objCoords = vec3(372.04949, -320.07315, 45.94298),
    doorType = 'door',
    textCoords = vec3(371.84686, -320.58447, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Custody desk staff gate (S4)',
}

-- Airlock outer (A1)
Config.DoorList['nobs_ukpd_d11_a1'] = {
    doorType = 'double',
    textCoords = vec3(379.26089, -316.26190, 47.14298),
    locked = true,
    distance = 2.0,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Airlock outer (A1)',
    autoLock = 10000,   -- ms
    doors = {
        { objName = 'nobs_ukpd_d36_secure_door_pair_r', objYaw = 158.38, objCoords = vec3(378.33123, -315.89348, 45.94298) },
        { objName = 'nobs_ukpd_d36_secure_door_pair_l', objYaw = 338.38, objCoords = vec3(380.19055, -316.63032, 45.94298) },
    },
}

-- Airlock cage gate (A2)
Config.DoorList['nobs_ukpd_d11_a2'] = {
    doorType = 'double',
    textCoords = vec3(380.84510, -312.26436, 47.14298),
    locked = true,
    distance = 2.0,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Airlock cage gate (A2)',
    autoLock = 10000,   -- ms
    doors = {
        { objName = 'nobs_ukpd_d11_cage_gate_leaf_r', objYaw = 338.38, objCoords = vec3(381.77476, -312.63278, 45.94298) },
        { objName = 'nobs_ukpd_d11_cage_gate_leaf_l', objYaw = 158.38, objCoords = vec3(379.91544, -311.89594, 45.94298) },
    },
}

-- ID suite (R1)
Config.DoorList['nobs_ukpd_d11_r1'] = {
    objName = 'nobs_ukpd_d36_secure_lh_n_hinge',
    objYaw = 158.38,
    objCoords = vec3(375.07743, -314.60400, 45.94298),
    doorType = 'door',
    textCoords = vec3(375.58874, -314.80664, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'ID suite (R1)',
}

-- Medical / FME (R2)
Config.DoorList['nobs_ukpd_d11_r2'] = {
    objName = 'nobs_ukpd_d36_secure_r_p_hinge',
    objYaw = 338.38,
    objCoords = vec3(372.19548, -313.46190, 45.94298),
    doorType = 'door',
    textCoords = vec3(371.68417, -313.25927, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Medical / FME (R2)',
}

-- Interview 1 (R3)
Config.DoorList['nobs_ukpd_d11_r3'] = {
    objName = 'nobs_ukpd_d36_secure_lh_n_hinge',
    objYaw = 158.38,
    objCoords = vec3(367.08236, -311.43559, 45.94298),
    doorType = 'door',
    textCoords = vec3(367.59367, -311.63822, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Interview 1 (R3)',
}

-- Interview 2 / consult (R4)
Config.DoorList['nobs_ukpd_d11_r4'] = {
    objName = 'nobs_ukpd_d36_secure_lh_n_hinge',
    objYaw = 158.38,
    objCoords = vec3(363.36372, -309.96191, 45.94298),
    doorType = 'door',
    textCoords = vec3(363.87503, -310.16454, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Interview 2 / consult (R4)',
}

-- Holding 1 (H1)
Config.DoorList['nobs_ukpd_d11_h1'] = {
    objName = 'nobs_ukpd_d36_holding_door',
    objYaw = 68.38,
    objCoords = vec3(364.02567, -313.72014, 45.94298),
    doorType = 'door',
    textCoords = vec3(363.82304, -314.23145, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Holding 1 (H1)',
}

-- Holding 2 (H2)
Config.DoorList['nobs_ukpd_d11_h2'] = {
    objName = 'nobs_ukpd_d36_holding_door',
    objYaw = 248.38,
    objCoords = vec3(362.36778, -317.90361, 45.94298),
    doorType = 'door',
    textCoords = vec3(362.57041, -317.39229, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Holding 2 (H2)',
}

-- Strip search (X1)
Config.DoorList['nobs_ukpd_d11_x1'] = {
    objName = 'nobs_ukpd_d11_secure_door_single_solid_lh',
    objYaw = 248.38,
    objCoords = vec3(364.36465, -321.00763, 45.94298),
    doorType = 'door',
    textCoords = vec3(364.56729, -320.49632, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Strip search (X1)',
}

-- Detainee shower / WC (W1)
Config.DoorList['nobs_ukpd_d11_w1'] = {
    objName = 'nobs_ukpd_d14_w1_door_solid',
    objYaw = 338.38,
    objCoords = vec3(390.28665, -311.91849, 45.94298),
    doorType = 'door',
    textCoords = vec3(389.77534, -311.71586, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Detainee shower / WC (W1)',
}

-- Cell 1 (C1)
Config.DoorList['nobs_ukpd_d11_c1'] = {
    objName = 'nobs_ukpd_d36_cell_door',
    objYaw = 338.38,
    objCoords = vec3(387.21878, -310.70271, 45.94298),
    doorType = 'door',
    textCoords = vec3(386.70746, -310.50007, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Cell 1 (C1)',
}

-- Cell 2 (C2)
Config.DoorList['nobs_ukpd_d11_c2'] = {
    objName = 'nobs_ukpd_d36_cell_door_obs',
    objYaw = 338.38,
    objCoords = vec3(384.33683, -309.56060, 45.94298),
    doorType = 'door',
    textCoords = vec3(383.82552, -309.35797, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Cell 2 (C2)',
}

-- Cell 3 (C3)
Config.DoorList['nobs_ukpd_d11_c3'] = {
    objName = 'nobs_ukpd_d36_cell_door_obs_lh',
    objYaw = 158.38,
    objCoords = vec3(380.10688, -307.88429, 45.94298),
    doorType = 'door',
    textCoords = vec3(380.61820, -308.08692, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Cell 3 (C3)',
}

-- Cell 4 (C4)
Config.DoorList['nobs_ukpd_d11_c4'] = {
    objName = 'nobs_ukpd_d36_cell_door_lh',
    objYaw = 158.38,
    objCoords = vec3(377.22494, -306.74219, 45.94298),
    doorType = 'door',
    textCoords = vec3(377.73625, -306.94482, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Cell 4 (C4)',
}

-- Cell 5 (C5)
Config.DoorList['nobs_ukpd_d11_c5'] = {
    objName = 'nobs_ukpd_d36_cell_door_lh',
    objYaw = 158.38,
    objCoords = vec3(374.34300, -305.60008, 45.94298),
    doorType = 'door',
    textCoords = vec3(374.85431, -305.80271, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Cell 5 (C5)',
}

-- Cell 6 (C6)
Config.DoorList['nobs_ukpd_d11_c6'] = {
    objName = 'nobs_ukpd_d36_cell_door_lh',
    objYaw = 158.38,
    objCoords = vec3(371.46105, -304.45798, 45.94298),
    doorType = 'door',
    textCoords = vec3(371.97237, -304.66061, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Cell 6 (C6)',
}

-- Cell 7 (C7)
Config.DoorList['nobs_ukpd_d11_c7'] = {
    objName = 'nobs_ukpd_d36_cell_door_lh',
    objYaw = 158.38,
    objCoords = vec3(368.57911, -303.31587, 45.94298),
    doorType = 'door',
    textCoords = vec3(369.09042, -303.51851, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Cell 7 (C7)',
}

-- Cell 8 (C8)
Config.DoorList['nobs_ukpd_d11_c8'] = {
    objName = 'nobs_ukpd_d36_cell_door_lh',
    objYaw = 158.38,
    objCoords = vec3(365.69717, -302.17377, 45.94298),
    doorType = 'door',
    textCoords = vec3(366.20848, -302.37640, 47.14298),
    locked = true,
    distance = 1.5,
    pickable = false,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Cell 8 (C8)',
}

-- Interlocks (A1<->A2, E1<->S1): never both unlocked. qb-doorlock has no interlock option, so this handler runs
-- after its own qb-doorlock:server:updateState handler (SetTimeout 0) and relocks the door that was just unlocked when
-- its partner is already unlocked. It mirrors qb-doorlock's own relock (server.lua autoLock branch): DoorList.locked,
-- the DoorStates persistence table, then qb-doorlock:client:setState(serverId, doorID, state, src, sounds, anim) with
-- src = false (the client treats src as a network id for remote audio).
if IsDuplicityVersion() then
    local partner = {}
    for _, p in ipairs({ { 'nobs_ukpd_d11_a1', 'nobs_ukpd_d11_a2' }, { 'nobs_ukpd_d11_e1', 'nobs_ukpd_d11_s1' } }) do partner[p[1]] = p[2]; partner[p[2]] = p[1] end
    AddEventHandler('qb-doorlock:server:updateState', function(doorID, locked, _, _, _, _, _, sentSource)
        local other = partner[doorID]
        if not other or locked then return end
        local src = sentSource or source
        SetTimeout(0, function()
            local d, o = Config.DoorList[doorID], Config.DoorList[other]
            if d and o and not d.locked and not o.locked then
                d.locked = true
                if Config.DoorStates then   -- qb-doorlock records deviations from the config default for persistence
                    if Config.DoorStates[doorID] == nil then Config.DoorStates[doorID] = true
                    elseif Config.DoorStates[doorID] ~= true then Config.DoorStates[doorID] = nil end
                end
                TriggerClientEvent('qb-doorlock:client:setState', -1, src, doorID, true, false, true, false)
                if type(src) == 'number' and src > 0 then
                    TriggerClientEvent('QBCore:Notify', src, 'Interlock: lock the other door first', 'error')
                end
            end
        end)
    end)
end
