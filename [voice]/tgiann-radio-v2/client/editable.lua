local tgiann_inventory = GetResourceState("tgiann-inventory") ~= "missing"
local qb_inventory = GetResourceState("qb-inventory") ~= "missing"
local ox_inventory = GetResourceState("ox_inventory") ~= "missing"

function getPlayerData()
    if not config.framework then
        return {
            job = { name = "unemployed" },
        }
    end
    return PlayerData or tgiCoreExports:getPlayerData()
end

function isPlayerMuted(src)
    local success, muted = pcall(function()
        return exports["pma-voice"]:isPlayerMuted(src)
    end)
    if not success then return false end -- Return false if there is no isPlayerMuted export
    return muted
end

function isRadioEnabled()
    return radioEnabled and (LocalPlayer.state.disableRadio == 0 or not LocalPlayer.state.disableRadio)
end

function canTalk()
    if not PlayerData then PlayerData = getPlayerData() end
    return not isDead and not PlayerData.metadata?.ishandcuffed
end

function isRadioAnimEnabled()
    if not config.animations.talk.active then return false end
    if GetConvarInt('voice_enableRadioAnim', 1) == 1 and not (GetConvarInt('voice_disableVehicleRadioAnim', 0) == 1 and cache.vehicle) and not disableRadioAnim then
        return true
    end
    return false
end

function leaveAllRadio()
    activeItemName = nil
    TriggerServerEvent("tgiann-radio-v2:leaveAllRadio")
    sendNui("closeUi")
end

function playerDead()
    if config.leaveRadioWhenDie then leaveAllRadio() end
end

local function removeItemDetect(itemName)
    if not activeItemName then return end
    if activeItemName ~= itemName then return end
    leaveAllRadio()
end

if config.items.active then
    if tgiann_inventory then
        RegisterNetEvent("tgiann-inventory:dropItem")
        AddEventHandler("tgiann-inventory:dropItem", function(itemName)
            removeItemDetect(itemName)
        end)
    elseif ox_inventory then
        AddEventHandler('ox_inventory:itemCount', function(itemName, totalCount)
            if totalCount > 0 then return end
            removeItemDetect(itemName)
        end)
    elseif qb_inventory then
        function DoRadioCheck(PlayerItems)
            if not activeItemName then return end
            local hasItem = false

            for _, item in pairs(PlayerItems) do
                if item.name == activeItemName then
                    hasItem = true
                    break
                end
            end
            if not hasItem then
                removeItemDetect(itemData.name)
            end
        end

        RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
            DoRadioCheck({})
        end)

        RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
            DoRadioCheck(val.items)
        end)
    end
end

function connectRadioChannel(channel)
    --Your connect code here
    TriggerServerEvent('cd_dispatch:GetRadioChannel', channel) -- for cd_dispatch (https://docs.codesign.pro/paid-scripts/dispatch#radio-channels)
end

function leaveRadioChannel(channel)
    --Your leave code here
end

function canJoinChannel()
    if config.framework == "qb" then
        if not PlayerData then PlayerData = getPlayerData() end
        return not isDead and not PlayerData.metadata?.ishandcuffed
    else
        return true
    end
end

function getItemName(item)
    return config.framework and tgiCore.itemName(item) or "Radio"
end
