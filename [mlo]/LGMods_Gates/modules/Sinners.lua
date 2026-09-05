--  Module: Sinners
--  Loaded by ModuleLoader.lua

-- Animation type definitions for this module
local AnimTypes = {
    ["sinner_bifold"] = {
        dict    = "anim@lgmods_sinner_bifold",
        closed  = "lgmods_sinner_bifold_closed",
        opening = "lgmods_sinner_bifold_closing",
        open    = "lgmods_sinner_bifold_open",
        closing = "lgmods_sinner_bifold_opening",
    },
    ["sinner_rear_gate"] = {
        dict    = "anim@lgmods_sinner_rear_gate",
        closed  = "lgmods_sinner_rear_gate_closed",
        opening = "lgmods_sinner_rear_gate_closing",
        open    = "lgmods_sinner_rear_gate_open",
        closing = "lgmods_sinner_rear_gate_opening",
    },
    ["sinners_ped_gate"] = {
        dict    = "anim@lgmods_sinner_ped_gate",
        closed  = "lgmods_sinner_ped_gate_closed",
        opening = "lgmods_sinner_ped_gate_closing",
        open    = "lgmods_sinner_ped_gate_open",
        closing = "lgmods_sinner_ped_gate_opening",
    },
}

-- Register this module's AnimTypes into the master Config.AnimTypes table
RegisterAnimTypes(AnimTypes)

-- Gate definitions
local Sinners_Gates = {
    [1] = {
        id           = "sinners_bifold",
        label        = "Open / Close Gate",
        model        = "lgmods_sinner_bifold",
        animType     = "sinner_bifold",
        station      = "Sinners",
        position     = vector3(410.445, -1023.486, 28.394),
        rotation     = vector3(0.0, 0.0, -90.0),
        useKeypad    = true,
        playSound    = true,
        autoOpenZone = { coords = vector3(416.7078, -1023.6515, 28.6850) },
        targetZones  = {
            [1] = {
                coords   = vector3(407.63, -1019.81, 29.48),
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = 0.0,
            },
            [2] = {
                coords   = vector3(419.54, -1028.05, 29.46),
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = 0.0,
            },
        },
    },
    [2] = {
        id           = "sinners_rear_gate",
        label        = "Open / Close Gate",
        model        = "lgmods_sinner_rear_gate",
        animType     = "sinner_rear_gate",
        station      = "Sinners",
        position     = vector3(488.894775, -1017.21228, 26.5493454),
        rotation     = vector3(0.0, 0.0, 90.0),
        useKeypad    = true,
        playSound    = true,
        autoOpenZone = { coords = vector3(484.1309, -1020.2823, 27.4901) },
        targetZones  = {
            [1] = {
                coords       = vector3(482.92504882812, -1016.8933105469, 28.240131378174),
                size         = { x = 2.0, y = 2.0, z = 2.0 },
                rotation     = 0.0,
                bypassKeypad = true,
                label        = "Emergency Open",
            },
            [2] = {
                coords   = vector3(491.61, -1022.58, 28.11),
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = 0.0,
            },
        },
    },
    [3] = {
        id           = "sinners_ped_gate",
        label        = "Open / Close Gate",
        model        = "lgmods_sinner_ped_gate",
        animType     = "sinners_ped_gate",
        station      = "Sinners",
        position     = vector3(424.5580, -992.4437, 29.8),
        rotation     = vector3(0.0, 0.0, 0.0),
        useKeypad    = true,
        playSound    = false,
        autoOpenZone = nil,
        targetZones  = {
            [1] = {
                coords   = vector3(424.84069824219, -992.10467529297, 31.126039505005),
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = 0.0,
            },
        },
    },
}

-- Append this module's gates into the master Config.Gates table
for _, gate in ipairs(Sinners_Gates) do
    gate.pinCode = (Config.Access.stationCodes and gate.station and Config.Access.stationCodes[gate.station]) or ""
    if not Config.Access.usePinCodes then
        gate.useKeypad = false
    end
    Config.Gates[#Config.Gates + 1] = gate
    Config.GateById[gate.id] = gate
end

if Config.Debug then
    print("^5[lgmods_gate]^7 Module 'Sinners' loaded — " .. #Sinners_Gates .. " gate(s) registered.")
end