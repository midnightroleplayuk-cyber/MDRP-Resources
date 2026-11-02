RegisterNetEvent("av_business:pawnTray", function(data)
    local name = data['zoneName']
    local label = data['label']
    local job = data['zoneJob']
    dbug("pawnTray(name,label,job)", name, label, job)
    if name and label then
        exports['av_laptop']:openStash(name, Config.Pawnshops['stash']['label'], Config.Pawnshops['stash']['weight'], Config.Pawnshops['stash']['slots'])
    end
end)

RegisterNetEvent("av_business:pawnCashier", function(data)
    local name = data['zoneName']
    local job = data['zoneJob']
    dbug("pawnCashier(name,job)", name, job)
    local funds = lib.callback.await("av_business:getPawnshopFunds", false, job)
    local state = GlobalState['stash_'..name] or false
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openPawnCashier",
        data = {
            id = name,
            funds = funds,
            locked = state
        }
    })
end)

lib.callback.register("av_business:handlePawnOffer", function(offer)
    local text = string.format(Lang['pawn_offer'], offer)
    local result = exports['av_laptop']:alertDialog({
        header = Lang['app_title'],
        content = text,
        centered = true,
        cancel = true
    })
    return result == "confirm" and true or false
end)

lib.callback.register("av_business:handlePawnSale", function(price, amount)
    local text = string.format(Lang['pawn_sale_offer'], price, amount)
    local result = exports['av_laptop']:alertDialog({
        header = Lang['app_title'],
        content = text,
        centered = true,
        cancel = true
    })
    return result == "confirm" and true or false
end)