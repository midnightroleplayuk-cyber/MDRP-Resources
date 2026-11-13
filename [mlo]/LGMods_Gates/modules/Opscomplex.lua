--  Module: Opscomplex
--  Loaded by ModuleLoader.lua

-- Animation type definitions for this module
local AnimTypes = {
    ["opscomplex_bifold"] = {
        dict    = "anim@lgmods_opscomplex_bifolding",
        closed  = "lgmods_opscomplex_bifolding_closed",
        opening = "lgmods_opscomplex_bifolding_opening",
        open    = "lgmods_opscomplex_bifolding_open",
        closing = "lgmods_opscomplex_bifolding_closing",
    },
}

-- Register this module's AnimTypes into the master Config.AnimTypes table
RegisterAnimTypes(AnimTypes)

-- Gate definitions
local Opscomplex_Gates = {
    [1] = {
        id           = "opscomplex_bifold",
        label        = "Open / Close Gate",
        model        = "lgmods_opscomplex_bifolding",
        animType     = "opscomplex_bifold",
        station      = "Opscomplex",
        position     = vector3(890.155, -1064.72, 31.7577),
        rotation     = vector3(0.0, 0.0, 0.0),
        useKeypad    = true,
        playSound    = true,
        autoOpenZone = { coords = vector3(890.6052, -1060.1482, 32.4157) },
        targetZones  = {
            [1] = {
                coords   = vector3(887.555359, -1066.6676, 32.0981331),
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = -90.0,
            },
        },
    },
    [2] = {
        id           = "opscomplex_bifold2",
        label        = "Open / Close Gate",
        model        = "lgmods_opscomplex_bifolding",
        animType     = "opscomplex_bifold",
        station      = "Opscomplex",
        position     = vector3(905.677, -1017.6, 33.8928),
        rotation     = vector3(0.0, 0.0, 180.0),
        useKeypad    = true,
        playSound    = true,
        autoOpenZone = { coords = vector3(905.7278, -1022.9122, 34.5546) },
        targetZones  = {
            [1] = {
                coords   = vector3(908.7681, -1015.93622, 34.9741821),
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = 90.0,
            },
        },
    },
}

-- Append this module's gates into the master Config.Gates table
for _, gate in ipairs(Opscomplex_Gates) do
    gate.pinCode = (Config.Access.stationCodes and gate.station and Config.Access.stationCodes[gate.station]) or ""
    if not Config.Access.usePinCodes then
        gate.useKeypad = false
    end
    Config.Gates[#Config.Gates + 1] = gate
    Config.GateById[gate.id] = gate
end

if Config.Debug then
    print("^5[lgmods_gate]^7 Module 'Opscomplex' loaded — " .. #Opscomplex_Gates .. " gate(s) registered.")
end