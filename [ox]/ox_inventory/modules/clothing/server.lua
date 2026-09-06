if not lib then return end

--[[
    Persistence for the wardrobe's "taken off" pieces.

    The wardrobe reads what the player is *wearing* straight off the ped, but the
    drawable/texture of anything they took OFF only exists in a client-side table
    (`clothingLast` in client.lua). That table used to be wiped every time the
    wardrobe opened, and it never survived a resource restart — so a removed shirt
    became unrecoverable.

    Keyed by the inventory owner (the character identifier), so it follows the
    character across relogs and machines rather than living in client KVP.
]]

local Inventory = require 'modules.inventory.server'

local ClothingState = {}

local KVP_PREFIX = 'ox_inventory:clothing:'

-- Bounds: 12 wardrobe slots, each saving at most itself + its `extra` components.
local MAX_KEYS = 16
local MAX_PARTS = 6

---@return string?
local function ownerKey(source)
    local inv = Inventory(source)
    local owner = inv and inv.owner

    if not owner or owner == true then return end

    return KVP_PREFIX .. tostring(owner)
end

-- The payload is written back onto a ped with SetPedComponentVariation /
-- SetPedPropIndex, so reject anything that isn't a plain numeric part list.
local function sanitisePart(part)
    if type(part) ~= 'table' then return end

    local id = tonumber(part.id)
    local drawable = tonumber(part.drawable)
    local texture = tonumber(part.texture)

    if not id or not drawable or not texture then return end
    if id < 0 or id > 20 then return end
    if drawable < -1 or drawable > 1000 then return end
    if texture < -1 or texture > 1000 then return end

    return {
        id = math.floor(id),
        prop = part.prop == true,
        drawable = math.floor(drawable),
        texture = math.floor(texture),
    }
end

---@return table?
local function sanitise(state)
    if type(state) ~= 'table' then return end

    local clean = {}
    local keys = 0

    for key, parts in pairs(state) do
        if type(key) ~= 'string' or type(parts) ~= 'table' then return end

        keys += 1
        if keys > MAX_KEYS or #parts == 0 or #parts > MAX_PARTS then return end

        local list = {}

        for i = 1, #parts do
            local part = sanitisePart(parts[i])
            if not part then return end
            list[i] = part
        end

        clean[key] = list
    end

    return clean
end

lib.callback.register('ox_inventory:getClothingState', function(source)
    local key = ownerKey(source)
    if not key then return false end

    local raw = GetResourceKvpString(key)
    if not raw then return false end

    local ok, stored = pcall(json.decode, raw)
    local state = ok and sanitise(stored) or nil

    if not state then
        DeleteResourceKvp(key)
        return false
    end

    return state
end)

RegisterNetEvent('ox_inventory:setClothingState', function(state)
    local key = ownerKey(source)
    if not key then return end

    local clean = sanitise(state)

    if not clean then
        return DeleteResourceKvp(key)
    end

    if not next(clean) then
        return DeleteResourceKvp(key)
    end

    SetResourceKvp(key, json.encode(clean))
end)

return ClothingState
