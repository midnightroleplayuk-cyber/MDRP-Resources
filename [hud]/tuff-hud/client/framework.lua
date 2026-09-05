Settings = Settings or {}

local hudInitialized = false
local lastHour, lastMinute, lastDay
local cachedDateStr = ""

local function getFormattedLocalDate(year, month, day)
    if day == lastDay and cachedDateStr ~= "" then
        return cachedDateStr
    end

    local format = Settings.DateFormat or "%d/%m/%Y"
    local dayStr = string.format("%02d", day)
    local monthStr = string.format("%02d", month)
    local yearStr = string.format("%04d", year)
    local shortYearStr = string.format("%02d", year % 100)
    
    cachedDateStr = format:gsub("%%d", dayStr):gsub("%%m", monthStr):gsub("%%Y", yearStr):gsub("%%y", shortYearStr)
    lastDay = day
    return cachedDateStr
end

local function waitForFrameworkPlayerData(timeoutMs)
    local timeout = GetGameTimer() + (timeoutMs or 5000)
    local PlayerData = Bridge:GetPlayerData()
    if Bridge:IsPlayerLoggedIn(PlayerData) and Bridge:HasRequiredPlayerData(PlayerData) then
        return PlayerData
    end

    while GetGameTimer() < timeout do
        PlayerData = Bridge:GetPlayerData()
        if Bridge:IsPlayerLoggedIn(PlayerData) and Bridge:HasRequiredPlayerData(PlayerData) then
            return PlayerData
        end
        Wait(250)
    end

    return nil
end

local function initializeHud()
    if hudInitialized then return true end
    if Client and Client.Functions and Client.Functions.SendDataToNUI and Client.Functions.SendDataToNUI() == false then return false end

    if Client and Client.Functions and Client.Functions.UpdateKeyBinds then
        Client.Functions.UpdateKeyBinds()
    end
    
    if Client then
        Client.PlayerData.ID = GetPlayerServerId(PlayerId())
    end

    if HUD and HUD.PlayerStatus then
        HUD.PlayerStatus:Start()
    end

    Bridge:StartDataThread()

    SendNUIMessage({
        action = "playerLoaded"
    })

    -- Re-send init data after a short delay to handle race condition
    -- where NUI iframe hasn't mounted its React listener yet
    CreateThread(function()
        Wait(500)
        if Client and Client.Functions and Client.Functions.SendDataToNUI then
            Client.Functions.SendDataToNUI()
        end
    end)

    hudInitialized = true
    return true
end

local function onPlayerLoaded()
    if not Settings.FrameworkSystems or not Bridge.loaded then
        initializeHud()
        return
    end

    local PlayerData = waitForFrameworkPlayerData(1500)
    if not PlayerData then
        -- Player is in multicharacter / not yet logged in
        DisplayRadar(false)
        return
    end

    initializeHud()
    Bridge:RefreshPlayerData(PlayerData)
end

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        onPlayerLoaded()
    end
end)

---@param isHudInitialized function Returns true if HUD is initialized
---@param refreshPlayerData function Callback to refresh player data in HUD
---@param onPlayerLoaded function Callback executed when player is loaded
if Settings.FrameworkSystems and Bridge.RegisterEvents then
    Bridge:RegisterEvents(function() return hudInitialized end, function(data) Bridge:RefreshPlayerData(data) end, onPlayerLoaded )
end

function Bridge:StartDataThread()
    CreateThread(function()
        local isFramework = Settings.FrameworkSystems == true

        while true do
            Wait(2000)

            local hour, minute
            local year, month, day

            if not Settings.RealTime then
                hour = GetClockHours()
                minute = GetClockMinutes()
                year, month, day = GetLocalTime()
            else
                year, month, day, hour, minute = GetLocalTime()
            end

            if minute ~= lastMinute or hour ~= lastHour then
                lastMinute = minute
                lastHour = hour
                Client.PlayerData.Time = string.format("%02d : %02d", hour, minute)
                Client.PlayerData.Date = getFormattedLocalDate(year, month, day)
            end

            if isFramework then
                local PlayerData = self:GetPlayerData()
                if type(PlayerData) == "table" then
                    self:RefreshPlayerData(PlayerData)
                end
            end
        end
    end)
end