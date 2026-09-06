if not lib then return end

--[[
    Client side of dynamic crafting benches:
      • builds interaction zones / markers for each DB bench
      • spawns the optional prop (prop_tool_bench02 by default)
      • opens the crafting bench on interact
]]

local createBlip = require 'modules.utils.client'.CreateBlip
local Appearance = require 'modules.customappearance.client'
-- Same cached table the core uses; client.openInventory('crafting') reads recipes/slots from here.
local CraftingBenches = require 'modules.crafting.client'
local ClientItems = require 'modules.items.client'

local CustomCraft = {}

---@type table<string, table> id -> { bench, entries = { { zone/zoneId, prop, blip } } }
local active = {}

local DEFAULT_PROP = 'prop_tool_bench02'

-- Returns an array of { x, y, z, heading } from a bench's coords (single, array,
-- or legacy target/prop coords).
local function getLocations(bench)
    local out = {}
    local c = bench.coords

    if c then
        if c[1] then
            for i = 1, #c do out[#out + 1] = c[i] end
        else
            out[#out + 1] = c
        end
    elseif bench.target and bench.target.coords then
        local t = bench.target.coords
        out[#out + 1] = { x = t.x, y = t.y, z = t.z, heading = bench.target.heading or 0.0 }
    end

    return out
end

local function destroyBench(id)
    local entry = active[id]
    if not entry then return end

    for i = 1, #(entry.entries or {}) do
        local e = entry.entries[i]
        if e.zoneId then exports.ox_target:removeZone(e.zoneId) end
        if e.zone then e.zone:remove() end
        if e.prop and DoesEntityExist(e.prop) then DeleteEntity(e.prop) end
        if e.blip then RemoveBlip(e.blip) end
    end

    CraftingBenches[id] = nil
    active[id] = nil
end

local function spawnProp(bench, loc)
    local p = bench.prop
    if not (p and p.enabled) then return nil end

    local model = joaat(p.model or DEFAULT_PROP)
    lib.requestModel(model, 5000)

    local obj = CreateObject(model, loc.x + 0.0, loc.y + 0.0, loc.z + 0.0, false, false, false)
    SetEntityCoordsNoOffset(obj, loc.x + 0.0, loc.y + 0.0, loc.z + 0.0, false, false, false)
    SetEntityHeading(obj, loc.heading or 0.0)
    FreezeEntityPosition(obj, true)
    SetEntityInvincible(obj, true)
    SetModelAsNoLongerNeeded(model)

    return obj
end

-- Registers the bench in the core CraftingBenches table so client.openInventory
-- ('crafting') can read its recipes/slots/coords (the static data.crafting loader
-- no longer provides these — everything is DB-driven now). Supports many points.
local function registerClientBench(bench, locations)
    local recipes = {}
    for i = 1, #(bench.recipes or {}) do
        local r = bench.recipes[i]
        local ingredients = {}
        for _, ing in ipairs(r.ingredients or {}) do
            if ing.name and ing.name ~= '' then ingredients[ing.name] = ing.count or 1 end
        end
        local item = ClientItems[r.name]
        recipes[#recipes + 1] = {
            name = r.name,
            ingredients = ingredients,
            duration = r.duration or 3000,
            count = r.count or 1,
            metadata = r.metadata,
            slot = i,
            weight = item and item.weight or 0,
        }
    end

    local points, zones = {}, {}
    for i = 1, #locations do
        local l = locations[i]
        local v = vec3(l.x + 0.0, l.y + 0.0, l.z + 0.0)
        points[i] = v
        zones[i] = { coords = v, distance = 2.5 }
    end

    CraftingBenches[bench.id] = {
        id = bench.id,
        label = bench.label,
        groups = bench.groups,
        items = recipes,
        slots = #recipes,
        points = #points > 0 and points or nil,
        zones = #zones > 0 and zones or nil,
    }
end

local function buildBench(bench)
    destroyBench(bench.id)

    if bench.groups and not client.hasGroup(bench.groups) then
        active[bench.id] = { bench = bench, entries = {} }
        return
    end

    local locations = getLocations(bench)
    if #locations == 0 then
        active[bench.id] = { bench = bench, entries = {} }
        return
    end

    registerClientBench(bench, locations)

    local entry = { bench = bench, entries = {} }
    local label = (bench.target and bench.target.label) or ('Use ' .. (bench.label or bench.id))
    local markerEnabled = bench.showMarker ~= false
    local hasProp = bench.prop and bench.prop.enabled
    -- A physical prop takes up space, so widen the interaction zone slightly.
    local zoneSize = hasProp and vec3(2.6, 2.6, 2.4) or vec3(2.0, 2.0, 2.0)

    for i = 1, #locations do
        local loc = locations[i]
        local coords = vec3(loc.x + 0.0, loc.y + 0.0, loc.z + 0.0)
        -- Raise the marker only when there's a prop (so it isn't hidden inside
        -- it); a plain zone marker stays at ground level.
        local markerZ = coords.z + (hasProp and 1.05 or 0.0)
        local e = {}

        e.prop = spawnProp(bench, loc)

        if bench.blip then
            e.blip = createBlip(Appearance.BlipSettings('craft', bench.label or bench.id), coords)
        end

        if shared.target then
            e.zoneId = exports.ox_target:addBoxZone({
                coords = coords,
                size = zoneSize,
                rotation = loc.heading or 0.0,
                debug = false,
                options = {
                    {
                        icon = 'fas fa-screwdriver-wrench',
                        label = label,
                        groups = bench.groups,
                        onSelect = function()
                            client.openInventory('crafting', { id = bench.id, index = i })
                        end,
                    },
                },
            })
        else
            e.zone = lib.zones.box({
                coords = coords,
                size = zoneSize,
                rotation = loc.heading or 0.0,
                debug = false,
                inside = function()
                    if markerEnabled then
                        Appearance.DrawMarker('craft', coords.x, coords.y, markerZ)
                    end

                    if IsControlJustReleased(0, 38) then -- E
                        client.openInventory('crafting', { id = bench.id, index = i })
                    end
                end,
                onEnter = function()
                    lib.showTextUI('[E] ' .. label)
                end,
                onExit = function()
                    lib.hideTextUI()
                end,
            })
        end

        entry.entries[#entry.entries + 1] = e
    end

    active[bench.id] = entry
end

RegisterNetEvent('ox_inventory:setCustomCraft', function(list)
    for i = 1, #list do buildBench(list[i]) end
end)

-- Blip appearance changed: rebuild benches so their blips pick up the new
-- sprite/colour/scale (markers redraw on their own each frame).
AddEventHandler('ox_inventory:appearanceChanged', function()
    for _, entry in pairs(active) do
        if entry.bench then buildBench(entry.bench) end
    end
end)

RegisterNetEvent('ox_inventory:registerCustomCraft', function(bench)
    buildBench(bench)
end)

RegisterNetEvent('ox_inventory:removeCustomCraft', function(id)
    destroyBench(id)
end)

-- Hide the spawned prop(s) while repositioning one (rebuilt at final position).
function CustomCraft.HideProp(id)
    local entry = active[id]
    if not entry then return end
    for i = 1, #(entry.entries or {}) do
        local e = entry.entries[i]
        if e.prop and DoesEntityExist(e.prop) then
            DeleteEntity(e.prop)
            e.prop = nil
        end
    end
end

exports('hideCustomCraftProp', CustomCraft.HideProp)

CreateThread(function()
    while not LocalPlayer.state.loaded and not PlayerData?.loaded do Wait(250) end
    Wait(600)
    TriggerServerEvent('ox_inventory:requestCustomCraft')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for id in pairs(active) do destroyBench(id) end
end)

return CustomCraft
