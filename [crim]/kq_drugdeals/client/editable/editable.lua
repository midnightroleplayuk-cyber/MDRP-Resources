-- Whether the player is able to perform any dealing actions. This includes dead drops, deliveries etc.
function CanPlayerDeal()
    return true
end

-- Define your own requirements to prevent/allow street dealing here
function CanInteractToDeal(ped)
    return true
end

-- Whether the player can interact with the organization
-- Role is 'contact' or 'fixer'
function CanInteractWithOrg(orgId, role)
    return true
end

local ready = false

function IsPlayerReady()
    return ready
end

function PlayerReady()
    ready = true

    TriggerServerEvent('kq_drugdeals:server:playerReady')
    TriggerEvent('kq_drugdeals:client:playerReady')
end

local loadedEvents = {
    'kq_link:playerLoaded',
    'esx:playerLoaded',
    'QBCore:Client:OnPlayerLoaded',
}

for _, event in ipairs(loadedEvents) do
    AddEventHandler(event, function()
        PlayerReady()
    end)
end

Citizen.CreateThread(function()
    while not DoesEntityExist(PlayerPedId()) do
        Citizen.Wait(100)
    end

    Citizen.Wait(4000)

    while true do
        Citizen.Wait(500)

        local ped = PlayerPedId()

        if IsPedOnFoot(ped) and not IsPedStill(ped) then
            PlayerReady()
            return
        end
    end
end)
