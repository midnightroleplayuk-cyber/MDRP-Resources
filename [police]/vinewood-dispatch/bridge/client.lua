-- Shared client state, filled from the server so all frameworks behave the same
State = {
    service = nil,
    onDuty = false,
}

function State.IsEmergency()
    return State.service ~= nil and State.onDuty
end

function State.Refresh()
    local data = lib.callback.await('vinewood-dispatch:server:getService', false)
    State.service = data and data.service or nil
    State.onDuty = data and data.onDuty or false
end

local function delayedRefresh()
    SetTimeout(750, State.Refresh)
end

-- QBCore / Qbox (Qbox fires the QBCore compatibility events)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', delayedRefresh)
RegisterNetEvent('QBCore:Client:OnJobUpdate', delayedRefresh)
RegisterNetEvent('QBCore:Client:SetDuty', delayedRefresh)
RegisterNetEvent('qbx_core:client:playerLoaded', delayedRefresh)

-- ESX
RegisterNetEvent('esx:playerLoaded', delayedRefresh)
RegisterNetEvent('esx:setJob', delayedRefresh)

-- Any script can force a refresh after changing duty
RegisterNetEvent('vinewood-dispatch:client:refreshService', delayedRefresh)

CreateThread(function()
    while true do
        if NetworkIsPlayerActive(PlayerId()) then
            State.Refresh()
        end
        Wait(60000)
    end
end)
