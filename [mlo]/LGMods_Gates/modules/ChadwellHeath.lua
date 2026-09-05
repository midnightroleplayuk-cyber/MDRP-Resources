--  Module: Chadwell Heath
--  Loaded by ModuleLoader.lua

local AnimTypes = {
    ["chadwellheath-bifolding"] = {
        dict    = "anim@lgmods_chadwellheath_bifolding",
        closed  = "lgmods_chadwellheath_bifolding_closed",
        opening = "lgmods_chadwellheath_bifolding_closing",
        open    = "lgmods_chadwellheath_bifolding_open",
        closing = "lgmods_chadwellheath_bifolding_opening",
    },
}

-- Register this module's AnimTypes into the master Config.AnimTypes table
RegisterAnimTypes(AnimTypes)

-- Gate definitions
local ChadwellHeath_Gates = {
    [1] = {
        id           = "chadwellheath_bifolding",
        label        = "Open / Close Gate",
        model        = "lgmods_chadwellheath_bifolding",
        animType     = "chadwellheath-bifolding",
        station      = "ChadwellHeath",
        position     = vector3(117.874878, -1700.286, 28.29138),
        rotation     = vector3(0.0, 0.0, -40.0),
        useKeypad    = true,
        playSound    = true,
        autoOpenZone = nil, 
        targetZones  = {
            [1] = {
                coords   = vector3(117.874878, -1700.286, 29.70138),
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = -40.0,
            },
        },
    },
}

-- Append this module's gates into the master Config.Gates table
for _, gate in ipairs(ChadwellHeath_Gates) do
    -- Resolve pin code from Config.StationPinCodes using the station tag
    gate.pinCode = (Config.Access.stationCodes and gate.station and Config.Access.stationCodes[gate.station]) or ""
    if not Config.Access.usePinCodes then
        gate.useKeypad = false
    end
    Config.Gates[#Config.Gates + 1] = gate
    Config.GateById[gate.id] = gate
end

if Config.Debug then
    print("^5[lgmods_gate]^7 Module 'Chadwell Heath' loaded — " .. #ChadwellHeath_Gates .. " gate(s) registered.")
end