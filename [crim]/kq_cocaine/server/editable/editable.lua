
local function OnCementUse(player, item)
    TriggerClientEvent('kq_cocaine:client:cementUsed', player)
end

local function OnLeafUse(player, item)
    TriggerClientEvent('kq_cocaine:client:leafUsed', player)
end


--
function AddPlayerItem(player, item, amount)
    local success = exports.kq_link:AddPlayerItem(player, item, amount or 1)
    
    return success
end

function AddPlayerItemToFit(player, item, amount)
    local success = exports.kq_link:AddPlayerItemToFit(player, item, amount or 1)
    
    return success
end

--
-- Could be used to modify the duration for players. For example: based on their XP/Skill level
function GetBarrelProcessDuration(player)
    return (Config.basic.barrel.duration or 45) * 1000
end

function GetFirepitProcessDuration(player)
    return (Config.basic.firepit.duration or 60) * 1000
end
--

exports.kq_link:RegisterUsableItem(Config.items.cocaLeaf, function(source)
    OnLeafUse(source)
end)
exports.kq_link:RegisterUsableItem(Config.items.cement, function(source)
    OnCementUse(source)
end)

--
---- OX Inventory solution
exports('UseCement', function(event, item, inventory)
    if event == 'usingItem' then
        local player = inventory.id
        OnCementUse(player)
        return true
    end
end)
exports('UseLeaf', function(event, item, inventory)
    if event == 'usingItem' then
        local player = inventory.id
        OnLeafUse(player)
        return true
    end
end)
---

function ValidateMaxDistance(player, originCoords, maxDistance)
    local playerPed = GetPlayerPed(player)
    
    local distance = #(originCoords - GetEntityCoords(playerPed))
    
    if distance > maxDistance then
        print('^1Action executed from impossible distance. Possible lua injection. Player ID: ' .. player .. '. Distance: '.. distance .. 'm^0')
        return false
    end
    
    return true
end

function OnAbuseDetected(message, player)
    -- This function gets triggered when a player is suspected of cheating (sending fake events or using glitches)
end
