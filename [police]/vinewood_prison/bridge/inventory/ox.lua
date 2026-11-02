-- ox_inventory is the only supported inventory. Items are moved, never copied:
-- each item is added to the destination first, then removed from the source,
-- and rolled back if the removal fails, so nothing can be duplicated.
local ox = exports.ox_inventory

Bridge.inventory = {}

local function keepSet()
    local set = {}
    for _, name in ipairs(Config.Reception.KeepItems or {}) do set[name] = true end
    return set
end

function Bridge.inventory.registerStash(stashId, label)
    ox:RegisterStash(stashId, label, 100, 1000000, false)
end

-- Move everything (except KeepItems) from a player into a stash. Returns item count moved.
function Bridge.inventory.confiscate(src, stashId, label)
    Bridge.inventory.registerStash(stashId, label)
    local keep, moved = keepSet(), 0
    local items = ox:GetInventoryItems(src) or {}
    for _, item in pairs(items) do
        if item and item.name and not keep[item.name] then
            local added = ox:AddItem(stashId, item.name, item.count, item.metadata)
            if added then
                local removed = ox:RemoveItem(src, item.name, item.count, item.metadata, item.slot)
                if removed then
                    moved = moved + item.count
                else
                    ox:RemoveItem(stashId, item.name, item.count, item.metadata)
                end
            end
        end
    end
    return moved
end

-- Return a stash to a player. Returns (returnedCount, remainingCount).
function Bridge.inventory.returnAll(src, stashId, label)
    Bridge.inventory.registerStash(stashId, label)
    local returned, remaining = 0, 0
    local items = ox:GetInventoryItems(stashId) or {}
    for _, item in pairs(items) do
        if item and item.name then
            if ox:CanCarryItem(src, item.name, item.count, item.metadata) then
                local added = ox:AddItem(src, item.name, item.count, item.metadata)
                if added then
                    local removed = ox:RemoveItem(stashId, item.name, item.count, item.metadata, item.slot)
                    if removed then
                        returned = returned + item.count
                    else
                        ox:RemoveItem(src, item.name, item.count, item.metadata)
                        remaining = remaining + item.count
                    end
                else
                    remaining = remaining + item.count
                end
            else
                remaining = remaining + item.count
            end
        end
    end
    return returned, remaining
end

function Bridge.inventory.give(src, name, count, metadata)
    if ox:CanCarryItem(src, name, count, metadata) then
        return ox:AddItem(src, name, count, metadata)
    end
    return false
end

-- Highest keycard level the player carries (0 if none)
function Bridge.inventory.keycardLevel(src)
    local slots = ox:Search(src, 'slots', Config.KeycardItem) or {}
    local best = 0
    for _, slot in pairs(slots) do
        local level = slot.metadata and tonumber(slot.metadata.level) or 1
        if level > best then best = level end
    end
    return best
end
