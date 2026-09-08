--- Policies
-- You can customize the permissions here

POLICY = {
    -- Whether the player can perform smash n grab
    CanPlayerSteal = function(player)
        return true
    end
}

--- Money functions
function AddPlayerItemToFit(player, item, amount, metadata)
    local success = exports.kq_link:AddPlayerItemToFit(player, item, amount or 1, metadata or nil)

    if not success then
        TriggerClientEvent('kq_link:client:notify', player, L('looting.cant_carry'), 'error')
    end

    return success
end

function AddPlayerMoney(player, amount)
    exports.kq_link:AddPlayerMoney(player, amount or 50)

    TriggerClientEvent('kq_link:client:notify', player, L('looting.got_money', { amount = amount }), 'success')

    return true
end

--- Lootable items
for item, data in pairs(Config.lootableItems) do
    exports.kq_link:RegisterUsableItem(item, function(source)
        OnItemUse(source, item)
    end)
end

-- OX Inventory solution
exports('LootItem', function(event, item, inventory)
    if event == 'usingItem' then
        local player = inventory.id
        OnItemUse(player, item.name)
        return true
    end
end)
---

--- Police count
function GetPoliceCount()
    local players = exports.kq_link:GetPlayersWithJob(Config.policeAlerts.policeJobs)
    return #players
end

--- Validation
function ValidateMaxDistance(player, originCoords, maxDistance)
    local playerPed = GetPlayerPed(player)

    local distance = #(originCoords - GetEntityCoords(playerPed))

    if distance > maxDistance then
        print('^1Action executed from impossible distance. Possible lua injection. Player ID: ' .. player .. '. Distance: ' .. distance .. 'm^0')
        return false
    end

    return true
end
