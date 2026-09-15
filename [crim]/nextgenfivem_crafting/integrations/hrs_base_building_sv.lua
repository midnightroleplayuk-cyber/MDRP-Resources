--[[
    HRS Base Building Integration (Server)

    This integration allows players to open crafting benches directly
    from props placed through hrs_base_building.

    Benches created through this integration are "headless" — they are
    fully functional for crafting but invisible to the proximity system.
    Only hrs_base_building interaction can open them.

    Setup:
    1. Enable the integration by setting HRSBaseBuilding.enabled = true in config.lua
    2. Create a bench type in the crafting editor that uses the same prop model
       as the one you want to use in hrs_base_building
    3. In hrs_base_building config.lua, add a TriggerEvent to the prop:

       ["prop_tool_bench02_ld"] = {
           item = "prop_tool_bench02_ld",
           life = 10000.0,
           type = "crafting",
           TriggerEvent = {
               type = "client",
               event = "nextgenfivem_crafting:hrs:interact",
               args = {"My Bench Type", "hrs_base_entity"},  -- Replace "My Bench Type" with your bench type name
               entityAsArg = "hrs_base_entity"
           },
           crafting = {{name = "wood", count = 20}}
       }

    Note: The bench type name must match a bench type created in the crafting editor.
]]

if not HRSBaseBuilding or not HRSBaseBuilding.enabled then return end

Log.info('[HRS Integration] Enabled, loading...')

local LocationClass = import 'handlers/benches/server/classes/location'

-- No-op proximity object: Location registers itself into this, but nothing happens.
-- This makes the bench invisible to the proximity system while still handling all
-- crafting queries and mutations via its registered event handlers.
local noopProximity = {
    add = function() end,
    remove = function() end,
    clear = function() end,
    sendMessage = function(self, source, benchId, event, ...)
        if event == 'exit' and source ~= -1 then
            TriggerClientEvent(ResourceName .. ':proximity:' .. event, source, benchId, ...)
        end
    end,
    get = function() return nil end,
    -- Headless benches are opened via direct HRS event triggers, which already
    -- validate the player's interaction with the prop. There is no proximity
    -- registration for this bench, so the standard canInteract proximity check
    -- has nothing to look at — auto-pass so HRS-driven crafting can proceed.
    playerHas = function() return true end,
}

local headlessBenches = {} -- [coordKey] = Location instance

-- Round coords to create a stable key (handles minor float differences)
local function coordKey(x, y, z)
    return string.format('hrs_%.1f_%.1f_%.1f', x, y, z)
end

RegisterNetEvent('nextgenfivem_crafting:hrs:registerAndOpen', function(benchTypeName, coords)
    local src = source

    if not benchTypeName or not coords then
        Log.error('[HRS Integration] Missing benchTypeName or coords')
        return
    end

    local key = coordKey(coords.x, coords.y, coords.z)

    -- Check if a headless bench already exists at this position
    if headlessBenches[key] then
        local bench = headlessBenches[key]

        TriggerClientEvent(ResourceName .. ':openBenchDirect', src, {
            uuid = key,
            coords = vec4(coords.x, coords.y, coords.z, coords.h),
            model = bench.benchType.model,
            title = bench.benchType.name,
            isPortable = false,
            hasServerEntity = false,
        })
        return
    end

    -- Look up bench type
    local benchType = DB.BenchTypes.FetchOne(benchTypeName)

    if not benchType then
        benchType = DB.BenchTypes.Search(benchTypeName)
    end

    if not benchType then
        Log.error('[HRS Integration] Bench type not found: "' .. tostring(benchTypeName) .. '". Make sure it matches a bench type name in the crafting editor.')
        return
    end

    -- Create headless location (no proximity, no database)
    local location = LocationClass.new({
        uuid = key,
        benchType = benchType.uuid,
        locationX = coords.x,
        locationY = coords.y,
        locationZ = coords.z,
        locationH = coords.h,
    }, benchType, noopProximity)

    if not location then
        Log.error('[HRS Integration] Failed to create headless bench for type: "' .. benchTypeName .. '"')
        return
    end

    headlessBenches[key] = location

    Log.info('[HRS Integration] Created headless bench: "' .. benchTypeName .. '" (key: ' .. key .. ')')

    -- Open bench directly for the player
    TriggerClientEvent(ResourceName .. ':openBenchDirect', src, {
        uuid = key,
        coords = vec4(coords.x, coords.y, coords.z, coords.h),
        model = benchType.model,
        title = benchType.name,
        isPortable = false,
        hasServerEntity = false,
    })
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, bench in pairs(headlessBenches) do
            bench:destroy()
        end

        headlessBenches = {}
    end
end)
