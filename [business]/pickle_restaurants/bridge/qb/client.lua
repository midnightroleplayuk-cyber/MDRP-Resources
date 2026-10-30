-- QB **and QBox** — see bridge/qb/server.lua for the whole story: QBox runs as
-- `qbx_core` with no `qb-core` resource, but registers the `qb-core` EXPORTS, so the
-- core object below is reachable on either framework. The client half must load
-- wherever the server half did, or a QBox server would get server-side money and
-- inventory with no notifications.
if GetResourceState('qb-core') ~= 'started' and GetResourceState('qbx_core') ~= 'started' then return end

local okCore, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
if not okCore or type(core) ~= "table" then return end -- compat bridge off; custom takes over
QBCore = core

function ServerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb,  ...)
end

function ShowNotification(text)
	QBCore.Functions.Notify(text)
end

function CanAccessGroup(data)
    if not data then return true end
    local pdata = QBCore.Functions.GetPlayerData()
    for k,v in pairs(data) do 
        if (pdata.job.name == k and pdata.job.grade.level >= v) then return true end
    end
    return false
end 

function GetPlayersInArea(coords, radius)
    local coords = coords or GetEntityCoords(PlayerPedId())
    local radius = radius or 3.0
    local list = QBCore.Functions.GetPlayersFromCoords(coords, radius)
    local players = {}
    for _, player in pairs(list) do 
        if player ~= PlayerId() then
            players[#players + 1] = player
        end
    end
    return players
end


function ToggleOutfit(onduty)
    if onduty then 
        local outfits = Config.BountyHunters.outfits
        local gender = QBCore.Functions.GetPlayerData().charinfo.gender
        local outfit = gender == 1 and outfits.female or outfits.male
        if not outfit then return end 
        TriggerEvent('qb-clothing:client:loadOutfit', {outfitData = outfit})
    else
        TriggerServerEvent("qb-clothes:loadPlayerSkin")
    end
end

function ResetClothes()
    TriggerServerEvent("qb-clothes:loadPlayerSkin")
end

function Revive()
    TriggerEvent("hospital:client:Revive")
    TriggerServerEvent("hospital:server:resetHungerThirst")
end

function Kill()
    SetEntityHealth(PlayerPedId(), 0)
end

RegisterNetEvent(GetCurrentResourceName()..":showNotification", function(text)
    ShowNotification(text)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("pickle_restaurants:initializePlayer")
end)

-- ─── inventory ───────────────────────────────────────────────────────────────
-- The client half is only the item catalogue mirror; bridge/inventory/client.lua
-- is the one copy of it.
CreateThread(function()
    Wait(100)
    InitializeInventory()
end)
