local function try(fn)
    local ok, result = pcall(fn)
    if ok then return result end
    return nil
end

local Qbox = try(function()
    return exports.qbx_core:GetCoreObject()
end)

Framework = Qbox

-- =========================================================================
--  QboxBridge OOP Class Definition
-- =========================================================================

local QboxBridge = {}
QboxBridge.__index = QboxBridge

function QboxBridge:GetPlayerData()
    return try(function()
        return exports.qbx_core:GetPlayerData()
    end) or (Qbox and Qbox.Functions and Qbox.Functions.GetPlayerData and Qbox.Functions.GetPlayerData()) or nil
end

function QboxBridge:getFrameworkPlayerData()
    return self:GetPlayerData()
end

function QboxBridge:HasRequiredPlayerData(PlayerData)
    return type(PlayerData) == "table" and PlayerData.job ~= nil and PlayerData.metadata ~= nil
end

function QboxBridge:_getBlackMoney(PlayerData)
    PlayerData = PlayerData or self:GetPlayerData()
    local money = PlayerData and PlayerData.money or {}
    local metadata = PlayerData and PlayerData.metadata or {}

    return money.black_money or money.blackmoney or money.dirty or metadata.black_money or metadata.blackmoney or
        metadata.dirtymoney or 0
end

function QboxBridge:_formatJob(job)
    if type(job) ~= "table" then return nil end

    local label = job.label or job.name
    if not label then return nil end

    local gradeName = type(job.grade) == "table" and (job.grade.name or job.grade.label) or job.grade

    if gradeName and gradeName ~= "" then
        return ("%s ( %s )"):format(label, gradeName)
    end

    return label
end

function QboxBridge:GetBlackMoney(PlayerData)
    return self:_getBlackMoney(PlayerData)
end

function QboxBridge:RefreshPlayerData(PlayerData)
    return self:ApplyPlayerData(PlayerData or self:GetPlayerData(), Client, Settings)
end

function QboxBridge:ApplyPlayerData(PlayerData, Client, Settings)
    if not Client or not Client.PlayerData then return false end
    PlayerData = PlayerData or self:GetPlayerData()
    if not PlayerData then return false end

    if PlayerData.money then
        Client.PlayerData.Bank = PlayerData.money.bank or 0
        Client.PlayerData.Money = PlayerData.money.cash or 0
    end

    if Settings and Settings.OxInventoryBlackMoney and GetResourceState('ox_inventory') == 'started' then
        local ox_black_money = exports.ox_inventory:Search('count', 'black_money')
        if type(ox_black_money) == 'number' then
            Client.PlayerData.BlackMoney = ox_black_money
        else
            Client.PlayerData.BlackMoney = self:_getBlackMoney(PlayerData)
        end
    else
        Client.PlayerData.BlackMoney = self:_getBlackMoney(PlayerData)
    end
    
    local job = self:_formatJob(PlayerData.job)
    if job then Client.PlayerData.Job = job end

    if PlayerData.metadata then
        if PlayerData.metadata.hunger ~= nil then
            Client.PlayerData.Hunger = math.floor(PlayerData.metadata.hunger)
        end

        if PlayerData.metadata.thirst ~= nil then
            Client.PlayerData.Thrist = math.floor(PlayerData.metadata.thirst)
        end

        if not Settings.DisableStress and Settings.FrameworkSystems and PlayerData.metadata.stress ~= nil then
            Client.PlayerData.Stress = math.floor(PlayerData.metadata.stress)
        end
    end

    return true
end

function QboxBridge:RegisterEvents(isHudInitialized, refreshPlayerData, onPlayerLoaded)
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

    RegisterNetEvent('qbx_core:client:playerLoggedIn', function()
        if onPlayerLoaded then onPlayerLoaded() end
        if isHudInitialized and not isHudInitialized() then return end
        if refreshPlayerData then
            refreshPlayerData(self:GetPlayerData())
        else
            self:RefreshPlayerData(self:GetPlayerData())
        end
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        if onPlayerLoaded then onPlayerLoaded() end
    end)

    RegisterNetEvent('qbx_core:client:playerLoggedOut', function()
        DisplayRadar(false)
        SendNUIMessage({
            type = "setHudVisibility",
            visible = false
        })
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        DisplayRadar(false)
        SendNUIMessage({
            type = "setHudVisibility",
            visible = false
        })
    end)
end

function QboxBridge:StartStatusListener(Client, Settings, refreshPlayerData)
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

-- Fixed signature matching ESX/QBCore bridges
function QboxBridge:GetJob()
    local PlayerData = self:GetPlayerData()
    return PlayerData and PlayerData.job and PlayerData.job.name or false
end

function QboxBridge:UpdateStress()
    TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
end

function QboxBridge:IsPlayerLoggedIn(PlayerData)
    if LocalPlayer and LocalPlayer.state and LocalPlayer.state.isLoggedIn == true then
        return true
    end
    if GetResourceState('qbx_core') == 'started' and exports.qbx_core and exports.qbx_core.isPlayerLoaded then
        local ok, loaded = pcall(function() return exports.qbx_core:isPlayerLoaded() end)
        if ok and loaded then return true end
    end
    PlayerData = PlayerData or self:GetPlayerData()
    return type(PlayerData) == "table" and (PlayerData.citizenid ~= nil or PlayerData.citizenId ~= nil)
end

-- =========================================================================
--  OOP Instance Instantiation & Export
-- =========================================================================

local instance = setmetatable({
    Name = "Qbox",
    Resource = "qbx_core",
    Core = Qbox,
    Framework = Qbox
}, QboxBridge)

return instance
