local QBCore = exports['qb-core']:GetCoreObject()
Framework = QBCore

-- =========================================================================
--  QBCoreBridge OOP Class Definition
-- =========================================================================

local QBCoreBridge = {}
QBCoreBridge.__index = QBCoreBridge

function QBCoreBridge:GetPlayerData()
    if not QBCore or not QBCore.Functions or not QBCore.Functions.GetPlayerData then return nil end
    return QBCore.Functions.GetPlayerData()
end

function QBCoreBridge:getFrameworkPlayerData()
    return self:GetPlayerData()
end

function QBCoreBridge:HasRequiredPlayerData(PlayerData)
    return type(PlayerData) == "table" and PlayerData.citizenid ~= nil and PlayerData.job ~= nil and
        PlayerData.metadata ~= nil and PlayerData.money ~= nil
end

function QBCoreBridge:_getBlackMoney(PlayerData)
    PlayerData = PlayerData or self:GetPlayerData()
    local money = PlayerData and PlayerData.money or {}
    local metadata = PlayerData and PlayerData.metadata or {}

    return money.black_money or money.blackmoney or money.dirty or metadata.black_money or metadata.blackmoney or
        metadata.dirtymoney or 0
end

function QBCoreBridge:_formatJob(job)
    if type(job) ~= "table" then return nil end

    local label = job.label or job.name
    if not label then return nil end

    local gradeName = type(job.grade) == "table" and (job.grade.name or job.grade.label) or job.grade

    if gradeName and gradeName ~= "" then
        return ("%s ( %s )"):format(label, gradeName)
    end

    return label
end

function QBCoreBridge:GetBlackMoney(PlayerData)
    return self:_getBlackMoney(PlayerData)
end

function QBCoreBridge:RefreshPlayerData(PlayerData)
    return self:ApplyPlayerData(PlayerData or self:GetPlayerData(), Client, Settings)
end

function QBCoreBridge:ApplyPlayerData(PlayerData, Client, Settings)
    if not Client or not Client.PlayerData then return false end
    PlayerData = PlayerData or self:GetPlayerData()
    if not PlayerData then return false end
    
    if PlayerData.money then
        Client.PlayerData.Bank = PlayerData.money.bank or 0
        Client.PlayerData.Money = PlayerData.money.cash or 0
    end
    
    Client.PlayerData.BlackMoney = self:_getBlackMoney(PlayerData)
    local job = self:_formatJob(PlayerData.job)
    if job then Client.PlayerData.Job = job end

    if PlayerData.gang then
        Client.PlayerData.HasGangSystem = true
        local gangLabel = PlayerData.gang.label or PlayerData.gang.name
        if gangLabel and gangLabel ~= "" then
            local gradeName = type(PlayerData.gang.grade) == "table" and (PlayerData.gang.grade.name or PlayerData.gang.grade.label) or PlayerData.gang.grade
            if gradeName and gradeName ~= "" then
                Client.PlayerData.Gang = ("%s ( %s )"):format(gangLabel, gradeName)
            else
                Client.PlayerData.Gang = gangLabel
            end
        else
            Client.PlayerData.Gang = ""
        end
    else
        Client.PlayerData.HasGangSystem = false
        Client.PlayerData.Gang = nil
    end
    
    if PlayerData.metadata then
        if PlayerData.metadata.hunger ~= nil then Client.PlayerData.Hunger = math.floor(PlayerData.metadata.hunger) end
        if PlayerData.metadata.thirst ~= nil then Client.PlayerData.Thrist = math.floor(PlayerData.metadata.thirst) end
        if not Settings.DisableStress and Settings.FrameworkSystems and PlayerData.metadata.stress ~= nil then
            Client.PlayerData.Stress = math.floor(PlayerData.metadata.stress)
        end
    end
    
    return true
end

function QBCoreBridge:RegisterEvents(isHudInitialized, refreshPlayerData, onPlayerLoaded)
    RegisterNetEvent('QBCore:Player:SetPlayerData', function(PlayerData)
        if not self:IsPlayerLoggedIn(PlayerData) then return end
        if isHudInitialized and not isHudInitialized() then
            if onPlayerLoaded then onPlayerLoaded() end
            return
        end
        if refreshPlayerData then
            refreshPlayerData(PlayerData)
        else
            self:RefreshPlayerData(PlayerData)
        end
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        if onPlayerLoaded then onPlayerLoaded() end
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        DisplayRadar(false)
        SendNUIMessage({
            type = "setHudVisibility",
            visible = false
        })
    end)
end

function QBCoreBridge:StartStatusListener(Client, Settings, refreshPlayerData)
    CreateThread(function()
        while true do
            if refreshPlayerData then
                refreshPlayerData(self:GetPlayerData())
            elseif self.RefreshPlayerData then
                self:RefreshPlayerData(self:GetPlayerData())
            end
            Wait(1000)
        end
    end)
end

function QBCoreBridge:GetJob()
    local PlayerData = self:GetPlayerData()
    return PlayerData and PlayerData.job and PlayerData.job.name or false
end

function QBCoreBridge:UpdateStress()
    TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
end

function QBCoreBridge:IsPlayerLoggedIn(PlayerData)
    if LocalPlayer and LocalPlayer.state and LocalPlayer.state.isLoggedIn == true then
        return true
    end
    PlayerData = PlayerData or self:GetPlayerData()
    return type(PlayerData) == "table" and PlayerData.citizenid ~= nil and PlayerData.citizenid ~= ""
end

-- =========================================================================
--  OOP Instance Instantiation & Export
-- =========================================================================

local instance = setmetatable({
    Name = "QBCore",
    Resource = "qb-core",
    Core = QBCore,
    Framework = QBCore
}, QBCoreBridge)

return instance
