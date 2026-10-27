if Link.inventory ~= 'ox_inventory' and Link.inventory ~= 'ox' then
    return
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(exports['ox_inventory']:GetInventory(player))
end

function GetPlayerItemData(player, item, meta)
    return exports['ox_inventory']:GetItem(player, item, meta)
end

function GetPlayerItemCount(player, item, meta)
    local data = GetPlayerItemData(player, item, meta)
    if not data then
        return 0
    end
    return data.count or data.amount or 0
end

--function AddPlayerItem(player, item, amount, meta)
    --amount = amount or 1

    --if not exports['ox_inventory']:CanCarryItem(player, item, amount, meta) then
        --return false
    --end

    --return exports['ox_inventory']:AddItem(player, item, amount, meta)
--end


-- limit cement test 

local CEMENT_COOLDOWN = 10 * 60 -- seconds between kq_cocaine cement pickups per player
local lastCement = {}

function AddPlayerItem(player, item, amount, meta)
    amount = amount or 1

    -- only kq_cocaine cement is rate-limited; every other item/resource is untouched
    if item == 'cement' and GetInvokingResource() == 'kq_cocaine' then
        local id = GetPlayerIdentifierByType(player, 'license') or player
        local left = (lastCement[id] or 0) + CEMENT_COOLDOWN - os.time()
        if left > 0 then
            TriggerClientEvent('ox_lib:notify', player, {
                type = 'error',
                description = ('You can pick up more cement in %d min'):format(math.ceil(left / 60)),
            })
            return false
        end
        if not exports['ox_inventory']:CanCarryItem(player, item, amount, meta) then
            return false
        end
        lastCement[id] = os.time()
    elseif not exports['ox_inventory']:CanCarryItem(player, item, amount, meta) then
        return false
    end

    return exports['ox_inventory']:AddItem(player, item, amount, meta)
end

-- limit cement test 

function SetItemDurability(player, slot, durability)
    local success, response = exports['ox_inventory']:SetDurability(player, slot, durability)
    return success
end

function GetItemBySlot(player, slot)
    return exports['ox_inventory']:GetSlot(player, slot)
end

function RemovePlayerItem(player, item, amount, meta)
    amount = amount or 1

    local items = exports['ox_inventory']:Search(player, 'slots', item, meta)
    if not items or #items == 0 then
        return false
    end

    local total = 0
    for _, itemData in ipairs(items) do
        total = total + itemData.count
    end

    if total < amount then
        return false
    end

    local metadata = {}
    local remaining = amount

    for _, itemData in ipairs(items) do
        if remaining <= 0 then
            break
        end

        local remove = math.min(itemData.count, remaining)
        if exports['ox_inventory']:RemoveItem(player, item, remove, itemData.metadata, itemData.slot, false, false) then
            for i = 1, remove do
                table.insert(metadata, itemData.metadata or {})
            end
            remaining = remaining - remove
        end
    end

    return remaining == 0, metadata or {}
end

-- Stashes
local stashes = {}
function OpenCustomStash(player, stashId, label, slots, weight)
    if not stashes[stashId] then
        exports.ox_inventory:RegisterStash(stashId, label, slots or 50, weight or 100000)
        stashes[stashId] = true
    end

    TriggerClientEvent('kq_link:client:ox_inventory:openStash', player, stashId)
end

function GetStashItems(stashId)
    if not stashes[stashId] then
        return {}
    end

    return exports.ox_inventory:GetInventoryItems(stashId)
end

function AddPlayerWeapon(player, weapon, ammo)
    return AddPlayerItem(player, weapon, 1, { ammo = ammo or 0 })
end

function DoesPlayerHaveWeapon(player, weapon)
    return GetPlayerItemCount(player, weapon) > 0
end

function RemovePlayerWeapon(player, weapon)
    return RemovePlayerItem(player, weapon, 1)
end

--
