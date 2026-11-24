local isOpen = false
local offerToken = 0
local OFFER_TIMEOUT = 30000

local ACTIONS = {
    getData = true,
    nearbyPlayers = true,
    hire = true,
    setGrade = true,
    fire = true,
    setRank = true,
    deposit = true,
    withdraw = true,
    deletePoint = true,
    stockOrder = true,
    stockCancel = true,
    stockReset = true,
    stockMove = true,
    setPrice = true,
    ownerSell = true,
    ownerTransfer = true,
    clubSettings = true,
    clubUnban = true,
}

local function setOpen(open)
    isOpen = open
    SetNuiFocus(open, open)
end

function NDM.IsPanelOpen()
    return isOpen
end

function NDM.SetPanelOpen(open)
    setOpen(open)
end

local function closePanel()
    if not isOpen then return end
    setOpen(false)
    SendNUIMessage({ action = 'close' })
end

function NDM.OpenPanel(venueId, tab)
    if isOpen then return end
    CreateThread(function()
        local ok, result = pcall(lib.callback.await, 'ndm_business:mgmt:open', false, { venue = venueId })
        if not ok or not result or not result.ok then
            lib.notify({ type = 'error', description = result and result.error or 'The server did not respond.' })
            return
        end
        setOpen(true)
        SendNUIMessage({ action = 'open', venues = result.venues, data = result.data, tab = tab })
    end)
end

RegisterCommand('business', function()
    NDM.OpenPanel()
end, false)

TriggerEvent('chat:addSuggestion', '/business', 'Open business management')

RegisterNUICallback('request', function(body, cb)
    local action = body and body.action
    if not ACTIONS[action] then
        cb({ ok = false, error = 'Unknown action.' })
        return
    end

    local ok, result = pcall(lib.callback.await, 'ndm_business:mgmt:' .. action, false, body.payload)
    if not ok or result == nil then
        cb({ ok = false, error = 'The server did not respond.' })
        return
    end
    if action == 'nearbyPlayers' then
        cb({ ok = true, players = result })
        return
    end
    cb(result)
end)

RegisterNUICallback('place', function(body, cb)
    cb({})
    if type(body) ~= 'table' or not tonumber(body.venue) then return end
    setOpen(false)
    NDM.StartPlacement({
        venue = tonumber(body.venue),
        pointId = tonumber(body.pointId),
        type = body.type,
        label = body.label,
        model = body.model,
    })
end)

RegisterNUICallback('close', function(_, cb)
    setOpen(false)
    cb({})
end)

lib.callback.register('ndm_business:mgmt:confirmHire', function(offer)
    if isOpen or type(offer) ~= 'table' then return false end

    offerToken = offerToken + 1
    local token = offerToken
    SetTimeout(OFFER_TIMEOUT, function()
        if offerToken == token then lib.closeAlertDialog() end
    end)

    local answer = lib.alertDialog({
        header = 'Job offer',
        content = ('Work at **%s** as **%s**? This becomes your main job.'):format(offer.venue, offer.grade),
        centered = true,
        cancel = true,
        labels = { confirm = 'Accept', cancel = 'Decline' },
    })
    offerToken = offerToken + 1
    return answer == 'confirm'
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then closePanel() end
end)
