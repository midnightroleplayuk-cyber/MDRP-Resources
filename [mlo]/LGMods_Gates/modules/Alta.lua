--  Module: Alta
--  Loaded by ModuleLoader.lua

local AnimTypes = {
    ["alta-bifold"] = {
        dict    = "anim@lgmods_bexleyheath_gate",
        closed  = "lgmods_bexleyheath_gate_closed",
        opening = "lgmods_bexleyheath_gate_closing",
        open    = "lgmods_bexleyheath_gate_open",
        closing = "lgmods_bexleyheath_gate_opening",
    },
    ["alta-sliding"] = {
        dict    = "anim@lgmods_bexley_slidingdoor",
        closed  = "lgmods_bexley_slidingdoor_closed",
        opening = "lgmods_bexley_slidingdoor_closing",
        open    = "lgmods_bexley_slidingdoor_open",
        closing = "lgmods_bexley_slidingdoor_opening",
    },
}

-- Register this module's AnimTypes into the master Config.AnimTypes table
RegisterAnimTypes(AnimTypes)

-- Gate definitions
local Alta_Gates = {
    [1] = {
        id           = "bexleyheath_bifold",
        label        = "Open / Close Gate",
        model        = "lgmods_bexleyheath_gate",
        animType     = "alta-bifold",
        station      = "Alta",
        position     = vector3(-338.490, -1364.765, 30.297),
        rotation     = vector3(0.155, -0.007, -99.983),
        useKeypad    = true,
        autoOpenZone = nil,
        targetZones  = {
            [1] = {
                coords   = vector3(-335.15097, -1367.70813, 31.2131462), -- INSIDE
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = -170.0,
            },
            [2] = {
                coords   = vector3(-341.2291, -1362.01563, 31.2131462), -- OUTSIDE
                size     = { x = 2.0, y = 2.0, z = 2.0 },
                rotation = 10.0,
            },
        },
    },
    [2] = {
        id           = "bexleyheath_slidingdoor",
        label        = "Open / Close Door",
        model        = "lgmods_bexley_slidingdoor",
        animType     = "alta-sliding",
        station      = "Alta",
        position     = vector3(-320.24478149414, -1372.2132568359, 30.296),
        rotation     = vector3(0.000, 0.000, -90.000),
        useKeypad    = false,
        playSound    = true,
        autoOpenZone = nil,
        targetZones  = {
            [1] = { coords = vector3(-320.014, -1373.949, 31.650), size = { x=2.5, y=2.5, z=2.5 }, rotation = 90.0 },
        },
    },
    [3] = {
        id           = "bexleyheath_slidingdoor2",
        label        = "Open / Close Door",
        model        = "lgmods_bexley_slidingdoor",
        animType     = "alta-sliding",
        station      = "Alta",
        position     = vector3(-320.24478149414, -1376.0837402344, 30.296),
        rotation     = vector3(0.000, 0.000, -90.000),
        useKeypad    = false,
        playSound    = true,
        autoOpenZone = nil,
        targetZones  = {
            [1] = { coords = vector3(-320.014, -1377.790, 31.650), size = { x=2.5, y=2.5, z=2.5 }, rotation = 90.0 },
        },
    },
}

-- Append this module's gates into the master Config.Gates table
for _, gate in ipairs(Alta_Gates) do
    -- Resolve pin code from Config.StationPinCodes using the station tag
    gate.pinCode = (Config.Access.stationCodes and gate.station and Config.Access.stationCodes[gate.station]) or ""
    if not Config.Access.usePinCodes then
        gate.useKeypad = false
    end
    Config.Gates[#Config.Gates + 1] = gate
    Config.GateById[gate.id] = gate
end

if Config.Debug then
    print("^5[lgmods_gate]^7 Module 'Alta' loaded — " .. #Alta_Gates .. " gate(s) registered.")
end