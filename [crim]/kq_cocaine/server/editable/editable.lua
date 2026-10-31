
local function OnCementUse(player, item)
    TriggerClientEvent('kq_cocaine:client:cementUsed', player)
end

local function OnLeafUse(player, item)
    TriggerClientEvent('kq_cocaine:client:leafUsed', player)
end


-- Pickup cooldowns (seconds) per player, per item
local PICKUP_COOLDOWNS = {
    [Config.items.cement] = 10 * 60,
    [Config.items.gasoline] = 10 * 60,
    [Config.items.hydrochloricAcid] = 10 * 60,
}
local lastPickup = {}

-- true if this player may take the item now; also starts their cooldown
local function PickupAllowed(player, item)
    local cooldown = PICKUP_COOLDOWNS[item]
    if not cooldown then return true end

    local key = (GetPlayerIdentifierByType(player, 'license') or player) .. ':' .. item
    local now = os.time()
    local left = (lastPickup[key] or 0) + cooldown - now

    if left > 0 then
        TriggerClientEvent('ox_lib:notify', player, {
            type = 'error',
            description = ('You can pick up more %s in %d min'):format(item:gsub('_', ' '), math.ceil(left / 60)),
        })
        return false
    end

    lastPickup[key] = now
    return true
end

--
function AddPlayerItem(player, item, amount)
    if not PickupAllowed(player, item) then return false end
    return exports.kq_link:AddPlayerItem(player, item, amount or 1)
end

function AddPlayerItemToFit(player, item, amount)
    if not PickupAllowed(player, item) then return false end
    return exports.kq_link:AddPlayerItemToFit(player, item, amount or 1)
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
