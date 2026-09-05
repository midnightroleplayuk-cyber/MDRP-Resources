local ESX = exports['es_extended']:getSharedObject()
Framework = ESX

-- =========================================================================
--  ESXBridge OOP Class Definition
-- =========================================================================

local ESXBridge = {}
ESXBridge.__index = ESXBridge

function ESXBridge:GetPlayerData()
    if not ESX or not ESX.GetPlayerData then return nil end
    return ESX.GetPlayerData()
end

function ESXBridge:getFrameworkPlayerData()
    return self:GetPlayerData()
end

function ESXBridge:HasRequiredPlayerData(PlayerData)
    return type(PlayerData) == "table" and PlayerData.job ~= nil
end

function ESXBridge:_getAccountMoney(name, PlayerData)
    PlayerData = PlayerData or self:GetPlayerData()
    local accounts = PlayerData and PlayerData.accounts or {}

    if type(accounts[name]) == "table" then
        return accounts[name].money or accounts[name].amount or accounts[name].value or 0
    end

    if type(accounts[name]) == "number" then
        return accounts[name]
    end

    for i = 1, #accounts do
        local account = accounts[i]
        if account and account.name == name then
            return account.money or account.amount or account.value or 0
        end
    end

    return 0
end

function ESXBridge:_formatJob(job)
    if type(job) ~= "table" then return nil end

    local label = job.label or job.name
    if not label then return nil end

    local gradeLabel = job.grade_label or job.grade_name or
        (type(job.grade) == "table" and (job.grade.label or job.grade.name)) or ""

    if gradeLabel ~= "" then
        return ("%s ( %s )"):format(label, gradeLabel)
    end

    return label
end

function ESXBridge:_updateAccount(PlayerData, account)
    if type(account) ~= "table" or not account.name then return PlayerData end
    local accounts = PlayerData?.accounts
    if not accounts then return PlayerData end

    if accounts[account.name] ~= nil then
        accounts[account.name] = account
        return PlayerData
    end

    for i = 1, #accounts do
        if accounts[i].name == account.name then
            accounts[i] = account
            break
        end
    end

    return PlayerData
end


function ESXBridge:GetBlackMoney(PlayerData)
    return self:_getAccountMoney("black_money", PlayerData)
end

function ESXBridge:RefreshPlayerData(PlayerData)
    return self:ApplyPlayerData(PlayerData or self:GetPlayerData(), Client, Settings)
end

function ESXBridge:ApplyPlayerData(PlayerData, Client)
    if not Client or not Client.PlayerData then return false end
    PlayerData = PlayerData or self:GetPlayerData()
    if not PlayerData then return false end
    
    Client.PlayerData.Bank = self:_getAccountMoney("bank", PlayerData)
    Client.PlayerData.Money = self:_getAccountMoney("money", PlayerData)
    
    if Settings and Settings.OxInventoryBlackMoney and GetResourceState('ox_inventory') == 'started' then
        local ox_black_money = exports.ox_inventory:Search('count', 'black_money')
        if type(ox_black_money) == 'number' then
            Client.PlayerData.BlackMoney = ox_black_money
        else
            Client.PlayerData.BlackMoney = self:_getAccountMoney("black_money", PlayerData)
        end
    else
        Client.PlayerData.BlackMoney = self:_getAccountMoney("black_money", PlayerData)
    end
    
    local job = self:_formatJob(PlayerData.job)
    if job then Client.PlayerData.Job = job end

    if PlayerData.gang then
        Client.PlayerData.HasGangSystem = true
        local gangLabel = type(PlayerData.gang) == "table" and (PlayerData.gang.label or PlayerData.gang.name) or nil
        if gangLabel and gangLabel ~= "" then
            local gradeLabel = type(PlayerData.gang) == "table" and (PlayerData.gang.grade_label or PlayerData.gang.grade_name or (type(PlayerData.gang.grade) == "table" and (PlayerData.gang.grade.label or PlayerData.gang.grade.name))) or ""
            if gradeLabel ~= "" then
                Client.PlayerData.Gang = ("%s ( %s )"):format(gangLabel, gradeLabel)
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
    
    return true
end

function ESXBridge:RegisterEvents(isHudInitialized, refreshPlayerData, onPlayerLoaded)
    if Settings and not Settings.DisableStress and Settings.FrameworkSystems then
        RegisterNetEvent('esx_status:loaded')
        AddEventHandler('esx_status:loaded', function(status)
            TriggerEvent('esx_status:registerStatus', 'stress', 0, '#B672FF', false, function() end)
        end)
    end

    RegisterNetEvent('esx:playerLoaded', function(PlayerData)
        if onPlayerLoaded then onPlayerLoaded() end
        if isHudInitialized and not isHudInitialized() then return end
        refreshPlayerData(PlayerData or self:GetPlayerData())
    end)

    RegisterNetEvent('esx:onPlayerSpawn', function()
        if onPlayerLoaded then onPlayerLoaded() end
    end)

    RegisterNetEvent('esx:setJob', function(job)
        if isHudInitialized and not isHudInitialized() then
            if onPlayerLoaded then onPlayerLoaded() end
            return
        end

        local PlayerData = self:GetPlayerData() or {}
        PlayerData.job = job
        refreshPlayerData(PlayerData)
    end)

    RegisterNetEvent('esx:setGang', function(gang)
        if isHudInitialized and not isHudInitialized() then
            if onPlayerLoaded then onPlayerLoaded() end
            return
        end

        local PlayerData = self:GetPlayerData() or {}
        PlayerData.gang = gang
        refreshPlayerData(PlayerData)
    end)

    RegisterNetEvent('esx:setAccountMoney', function(account)
        if isHudInitialized and not isHudInitialized() then
            if onPlayerLoaded then onPlayerLoaded() end
            return
        end

        refreshPlayerData(self:_updateAccount(self:GetPlayerData() or {}, account))
    end)

    RegisterNetEvent('esx:onPlayerLogout', function()
        DisplayRadar(false)
        SendNUIMessage({
            type = "setHudVisibility",
            visible = false
        })
    end)
end

function ESXBridge:StartStatusListener(Client, Settings, refreshPlayerData)
    AddEventHandler("esx_status:onTick", function(data)
        if not Client or not Client.PlayerData or type(data) ~= "table" then return end

        for i = 1, #data do
            local status = data[i]
            local percent = tonumber(status.percent)
            if not percent and tonumber(status.val) then
                percent = (tonumber(status.val) / 1000000) * 100
            end
            local value = math.floor(percent or 0)
            if status.name == "thirst" then
                Client.PlayerData.Thrist = value
            elseif status.name == "hunger" then
                Client.PlayerData.Hunger = value
            elseif not Settings.DisableStress and Settings.FrameworkSystems and status.name == "stress" then
                Client.PlayerData.Stress = value
            end
        end
    end)
end

function ESXBridge:GetJob()
    local PlayerData = self:GetPlayerData()
    return PlayerData and PlayerData.job and PlayerData.job.name or false
end

function ESXBridge:UpdateStress()
    TriggerEvent('esx_status:add', 'stress', 60000)
end

function ESXBridge:IsPlayerLoggedIn(PlayerData)
    return type(PlayerData) == "table" and PlayerData.job ~= nil
end

-- =========================================================================
--  OOP Instance Instantiation & Export
-- =========================================================================

local instance = setmetatable({
    Name = "ESX",
    Resource = "es_extended",
    Core = ESX,
    Framework = ESX
}, ESXBridge)

return instance
