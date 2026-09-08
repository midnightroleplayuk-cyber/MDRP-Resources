PlayerStatus = {}
PlayerStatus.__index = PlayerStatus

local QBCore = nil
local function getQBCore()
    if not QBCore and GetResourceState('qb-core') == 'started' then
        pcall(function()
            QBCore = exports['qb-core']:GetCoreObject()
        end)
    end
    return QBCore
end


function PlayerStatus.new()
    local self = setmetatable({}, PlayerStatus)
    self.running = false
    return self
end

function PlayerStatus:Start()
    if self.running then return end
    self.running = true

    CreateThread(function()
        local lastPlayerData = {}
        while self.running do
            local playerId = PlayerId()
            local ped = PlayerPedId()

            if ped and ped ~= 0 then
                local health = math.floor(GetEntityHealth(ped) - 100)
                Client.PlayerData.Health = health >= 0 and health or 0

                local armor = GetPedArmour(ped)
                Client.PlayerData.Armor = armor

                local oxygen = math.floor(GetPlayerUnderwaterTimeRemaining(playerId) * 10)
                Client.PlayerData.Oxygen = oxygen >= 0 and (oxygen > 100 and 100 or oxygen) or 0

                local stamina = math.floor(100 - (GetPlayerSprintStaminaRemaining(playerId)))
                Client.PlayerData.Stamina = stamina >= 0 and stamina or 0

                local speaking = NetworkIsPlayerTalking(playerId)
                Client.PlayerData.Speaking = speaking

                -- pma-voice stores its current proximity mode in the local player state bag.
                -- Tuff HUD expects a mode index (1 = whisper, 2 = normal, 3 = shout),
                -- not PMA's actual distance value (for example 3.0 / 7.0 / 15.0).
                local proximity = 2
                if GetResourceState('pma-voice') == 'started' then
                    local pmaProximity = LocalPlayer.state.proximity
                    if type(pmaProximity) == 'table' and pmaProximity.index then
                        proximity = tonumber(pmaProximity.index) or 2
                    end
                elseif Voice and Voice.GetProximityRange then
                    proximity = Voice.GetProximityRange() or 2
                end

                -- Keep the value inside the range the NUI is designed for.
                proximity = math.max(1, math.min(3, math.floor(proximity + 0.5)))
                Client.PlayerData.Proximity = proximity
                
                local PlayerData = Client.PlayerData
                if PlayerData then
                    local changed = false
                    for k, v in pairs(PlayerData) do
                        if lastPlayerData[k] ~= v then
                            changed = true
                            break
                        end
                    end
                    if not changed then
                        for k, v in pairs(lastPlayerData) do
                            if PlayerData[k] ~= v then
                                changed = true
                                break
                            end
                        end
                    end

                    if changed then
                        for k in pairs(lastPlayerData) do
                            lastPlayerData[k] = nil
                        end
                        for k, v in pairs(PlayerData) do
                            lastPlayerData[k] = v
                        end
                        SendNUIMessage({
                            type = "updatePlayerData",
                            data = PlayerData
                        })
                    end
                end
            end
            Wait(200)
        end
    end)

    CreateThread(function()
        local hasAmmoHud = false
        local lastWeapon = nil
        local lastAmmoInClip = -1
        local lastReserve = 0
        local lastInventoryCheckTime = 0
        local hasOxInventory = GetResourceState('ox_inventory') == 'started'

        while self.running do
            local ped = PlayerPedId()
            local _, weapon = GetCurrentPedWeapon(ped, true)
            
            if weapon and weapon ~= `WEAPON_UNARMED` then
                local hasClip, ammoInClip = GetAmmoInClip(ped, weapon)
                if hasClip then
                    local ammoTotal = GetAmmoInPedWeapon(ped, weapon)
                    local reserve = math.max(0, ammoTotal - ammoInClip)
                    
                    if reserve == 0 then
                        local currentTime = GetGameTimer()
                        if weapon ~= lastWeapon or ammoInClip ~= lastAmmoInClip or (currentTime - lastInventoryCheckTime) > 1000 then
                            lastInventoryCheckTime = currentTime
                            
                            local invReserve = 0
                            if hasOxInventory then
                                pcall(function()
                                    local currentWeapon = exports.ox_inventory:getCurrentWeapon()
                                    if currentWeapon and currentWeapon.name then
                                        local itemData = exports.ox_inventory:Items(currentWeapon.name)
                                        if itemData and itemData.ammoname then
                                            invReserve = exports.ox_inventory:Search('count', itemData.ammoname) or 0
                                        end
                                    end
                                end)
                            else
                                local qb = getQBCore()
                                if qb then
                                    pcall(function()
                                        if qb.Shared and qb.Shared.Weapons then
                                            local weaponData = qb.Shared.Weapons[weapon]
                                            if weaponData and weaponData.ammotype then
                                                local PlayerData = qb.Functions.GetPlayerData()
                                                if PlayerData and PlayerData.items then
                                                    for _, item in pairs(PlayerData.items) do
                                                        if item and item.name == weaponData.ammotype then
                                                            invReserve = invReserve + (item.amount or 0)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end)
                                end
                            end
                            reserve = invReserve
                        else
                            reserve = lastReserve
                        end
                    end

                    if not hasAmmoHud or weapon ~= lastWeapon or lastAmmoInClip ~= ammoInClip or lastReserve ~= reserve then
                        SendNUIMessage({
                            type = "updateAmmo",
                            ammoInClip = ammoInClip,
                            ammoTotal = reserve
                        })
                        hasAmmoHud = true
                        lastWeapon = weapon
                        lastAmmoInClip = ammoInClip
                        lastReserve = reserve
                    end
                else
                    if hasAmmoHud then
                        SendNUIMessage({ type = "hideAmmo" })
                        hasAmmoHud = false
                        lastWeapon = nil
                        lastAmmoInClip = -1
                        lastReserve = -1
                    end
                end
                Wait(100)
            else
                if hasAmmoHud then
                    SendNUIMessage({ type = "hideAmmo" })
                    hasAmmoHud = false
                    lastWeapon = nil
                    lastAmmoInClip = -1
                    lastReserve = -1
                end
                Wait(500)
            end
        end
    end)

    if Bridge.loaded then
        Bridge:StartStatusListener(Client, Settings)
    end
end

function PlayerStatus:Stop()
    self.running = false
end
