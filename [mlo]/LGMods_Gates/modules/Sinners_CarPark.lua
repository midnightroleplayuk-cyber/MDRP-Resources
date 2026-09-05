--  Module: Sinners Car Park
--  Loaded by ModuleLoader.lua

-- Animation type definitions for this module
local AnimTypes = {
    ["sinner_carpark_bifold"] = {
        dict    = "anim@lgmods_sinner_carpark_bifold",
        closed  = "lgmods_sinner_carpark_bifold_closed",
        opening = "lgmods_sinner_carpark_bifold_closing",
        open    = "lgmods_sinner_carpark_bifold_open",
        closing = "lgmods_sinner_carpark_bifold_opening",
    },
}

-- Register this module's AnimTypes into the master Config.AnimTypes table
RegisterAnimTypes(AnimTypes)

-- Gate definitions
local Sinners_CarPark_Gates = {
    [1] = {
        id           = "sinners_carpark_bifold",
        label        = "Open / Close Gate",
        model        = "lgmods_sinner_carpark_bifold",
        animType     = "sinner_carpark_bifold",
        station      = "Sinners_CarPark",
        position     = vector3(478.409, -978.940, 27.150),
        rotation     = vector3(0.0, 0.0, -90.0),
        useKeypad    = true,
        playSound    = true,
        autoOpenZone = { coords = vector3(478.1961, -983.6265, 27.9163) },
        targetZones  = {
            [1] = {
                coords   = vector3(481.742316, -974.945862, 28.1),
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = 0.0,
            },
            [2] = {
                coords   = vector3(474.616, -983.108, 28.5),
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = 0.0,
            },
        },
    },
}

-- Append this module's gates into the master Config.Gates table
for _, gate in ipairs(Sinners_CarPark_Gates) do
    gate.pinCode = (Config.Access.stationCodes and gate.station and Config.Access.stationCodes[gate.station]) or ""
    if not Config.Access.usePinCodes then
        gate.useKeypad = false
    end
    Config.Gates[#Config.Gates + 1] = gate
    Config.GateById[gate.id] = gate
end

if Config.Debug then
    print("^5[lgmods_gate]^7 Module 'Sinners Carpark' loaded — " .. #Sinners_CarPark_Gates .. " gate(s) registered.")
end