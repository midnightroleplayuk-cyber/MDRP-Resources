-- Server side of GoodCiv's own down state: respawn timing / fee and admin heals.
local downSince = {} -- [src] = os.time()

AddStateBagChangeHandler('goodciv:down', nil, function(bagName, _, value)
    local src = GetPlayerFromStateBagName(bagName)
    if not src or src == 0 then return end
    if value then
        downSince[src] = downSince[src] or os.time()
    else
        downSince[src] = nil
    end
end)

RegisterNetEvent('goodciv:server:respawn', function()
    local src = source
    if GoodCiv.DownMode() ~= 'goodciv' then return end
    local since = downSince[src]
    local after = Config.Down.RespawnAfter
    -- 2s tolerance for client / server clock granularity.
    if not since or after <= 0 or os.time() - since < after - 2 then return end
    downSince[src] = nil

    local inc = Incidents.GetByPatient(src)
    if inc then Incidents.Close(inc, 'alert_closed') end

    -- Charged only if they can afford it; nobody gets stuck down for being broke.
    if Config.Down.RespawnFee > 0 and Bridge.Name ~= 'standalone'
        and Bridge.RemoveMoney(src, Config.Down.RespawnFee, Config.CheckIn.Account) then
        TriggerClientEvent('goodciv:client:toast', src, 'info', L('respawn_fee', Config.Down.RespawnFee))
    end

    local h = GoodCiv.NearestHospital(GetEntityCoords(GetPlayerPed(src)))
    TriggerClientEvent('goodciv:client:respawn', src, h and h.drop)
    -- Waking up in hospital counts as being treated.
    Injury.Clear(src, false)
end)

-- txAdmin "Heal" (player or everyone) also gets players up from GoodCiv's down state.
AddEventHandler('txAdmin:events:healedPlayer', function(data)
    if GoodCiv.DownMode() ~= 'goodciv' then return end
    local id = data and tonumber(data.id)
    if not id then return end
    if id == -1 then
        TriggerClientEvent('goodciv:client:revive', -1)
    elseif GetPlayerPed(id) ~= 0 then
        TriggerClientEvent('goodciv:client:revive', id)
    end
end)

AddEventHandler('playerDropped', function()
    downSince[source] = nil
end)
