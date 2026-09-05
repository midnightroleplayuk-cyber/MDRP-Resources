local Strings = require 'shared.strings'
local KeyBindsConfig = require 'shared.keybinds'

local SET_INDICATOR_RIGHT = 0
local SET_INDICATOR_LEFT = 1
local GET_INDICATOR_LEFT = 0
local GET_INDICATOR_RIGHT = 1
local INDICATOR_STATE_LEFT = 1
local INDICATOR_STATE_RIGHT = 2
local INDICATOR_STATE_BOTH = 3

local function GetIndicatorState(vehicle)
    return GetVehicleIndicatorLights(vehicle)
end

local function IsIndicatorEnabled(vehicle, isLeft)
    local state = GetIndicatorState(vehicle)

    if isLeft then
        return state == INDICATOR_STATE_LEFT or state == INDICATOR_STATE_BOTH
    else
        return state == INDICATOR_STATE_RIGHT or state == INDICATOR_STATE_BOTH
    end
end

local function TableGet(root, ...)
    local value = root

    for i = 1, select("#", ...) do
        if type(value) ~= "table" then return nil end
        value = value[select(i, ...)]
    end

    return value
end

local function IsPedEnteringVehicle(ped)
    return GetVehiclePedIsEntering(ped) ~= 0 or GetVehiclePedIsTryingToEnter(ped) ~= 0
end

local function GetCurrentVehicle()
    local ped = PlayerPedId()
    if not ped or ped == 0 then return false, ped end

    local vehicle = Client and Client.Vehicle
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) or GetVehiclePedIsIn(ped, false) ~= vehicle then
        vehicle = GetVehiclePedIsIn(ped, false)
    end

    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return false, ped
    end

    Client.Vehicle = vehicle
    if HUD and HUD.Speedometer then
        HUD.Speedometer:CacheVehicleData(vehicle)
    end

    return vehicle, ped
end

Keybinds = {}
Keybinds.__index = Keybinds

function Keybinds.new()
    local self = setmetatable({}, Keybinds)
    return self
end

function Keybinds:Start()
    RegisterCommand("seatbelt", function()
        if Settings.DisableSeatbelt or (Client.Data and (Client.Data.DISABLESEATBELT == 1 or Client.Data.DISABLESEATBELT == true)) then
            return
        end

        if HUD and HUD.Speedometer then
            HUD.Speedometer:ToggleSeatbelt()
        end
    end, false)
    local seatbeltKey = TableGet(KeyBindsConfig, "seatbelt")
    if seatbeltKey and seatbeltKey ~= "" and seatbeltKey ~= "none" then
        RegisterKeyMapping("seatbelt", TableGet(Strings, "CommandDesc", "seatbelt") or "Toggle Seatbelt", "keyboard", seatbeltKey)
    end

    RegisterCommand("toggleengine", function()
        if Settings.DisableEngine or (Client.Data and (Client.Data.DISABLEENGINE == 1 or Client.Data.DISABLEENGINE == true)) then return end
        if not Client or not Client.Vehicle then return end

        local veh = Client.Vehicle
        local isRunning = GetIsVehicleEngineRunning(veh)
        local newState = not isRunning

        SetVehicleEngineOn(veh, newState, 1, 1)

        SendNUIMessage({
            type          = "updateSpeedometer",
            engineRunning = newState and 1 or 0,
        })
    end, false)
    RegisterKeyMapping("toggleengine", TableGet(Strings, "CommandDesc", "engine") or "Toggle Engine", "keyboard", TableGet(KeyBindsConfig, "engine") or "G")

    RegisterCommand("togglelock", function()
        if Settings.DisableDoorLock or (Client.Data and (Client.Data.DISABLEDOORLOCK == 1 or Client.Data.DISABLEDOORLOCK == true)) then return end
        if not Client or not Client.Vehicle then return end

        local ped = PlayerPedId()
        if IsPedEnteringVehicle(ped) then
            return
        end

        local veh = Client.Vehicle
        local lockStatus = GetVehicleDoorLockStatus(veh)
        local locked

        if lockStatus == 2 then
            SetVehicleDoorsLocked(veh, 1)
            PlayVehicleDoorOpenSound(veh, 0)
            locked = false
        else
            SetVehicleDoorsLocked(veh, 2)
            PlayVehicleDoorCloseSound(veh, 0)
            locked = true
        end

        SendNUIMessage({
            type       = "updateSpeedometer",
            doorLocked = locked and 1 or 0,
        })
    end, false)
    RegisterKeyMapping("togglelock", TableGet(Strings, "CommandDesc", "doorLock") or "Toggle Door Lock", "keyboard", TableGet(KeyBindsConfig, "doorLock") or "L")

    RegisterCommand("togglelights", function()
        if Settings.DisableLights or (Client.Data and (Client.Data.DISABLELIGHTS == 1 or Client.Data.DISABLELIGHTS == true)) then return end
        if not Client or not Client.Vehicle then return end

        local veh = Client.Vehicle
        local _, lightsOn, highbeamsOn = GetVehicleLightsState(veh)
        local newLightsOn

        if lightsOn == 1 or highbeamsOn == 1 then
            SetVehicleLights(veh, 1)
            newLightsOn = false
        else
            SetVehicleLights(veh, 3)
            newLightsOn = true
        end

        SendNUIMessage({
            type     = "updateSpeedometer",
            lightsOn = newLightsOn and 1 or 0,
        })
    end, false)
    RegisterKeyMapping("togglelights", TableGet(Strings, "CommandDesc", "lights") or "Toggle Lights", "keyboard", TableGet(KeyBindsConfig, "lights") or "H")

    RegisterCommand("toggleindicatorleft", function()
        if Settings.DisableIndicators or (Client.Data and (Client.Data.DISABLEINDICATORS == 1 or Client.Data.DISABLEINDICATORS == true)) then return end
        if not Client or not Client.Vehicle then return end

        local veh = Client.Vehicle
        local newState = not IsIndicatorEnabled(veh, true)
        SetVehicleIndicatorLights(veh, SET_INDICATOR_LEFT, newState)

        Client.Hazard = false
        SetVehicleIndicatorLights(veh, SET_INDICATOR_RIGHT, false)

        SendNUIMessage({
            type          = "updateSpeedometer",
            leftIndicator  = newState and 1 or 0,
            rightIndicator = 0,
        })
    end, false)
    RegisterKeyMapping("toggleindicatorleft", TableGet(Strings, "CommandDesc", "indicatorLeft") or "Toggle Left Blinker", "keyboard", TableGet(KeyBindsConfig, "indicatorLeft") or "LEFT")

    RegisterCommand("toggleindicatorright", function()
        if Settings.DisableIndicators or (Client.Data and (Client.Data.DISABLEINDICATORS == 1 or Client.Data.DISABLEINDICATORS == true)) then return end
        if not Client or not Client.Vehicle then return end

        local veh = Client.Vehicle
        local newState = not IsIndicatorEnabled(veh, false)
        SetVehicleIndicatorLights(veh, SET_INDICATOR_RIGHT, newState)

        Client.Hazard = false
        SetVehicleIndicatorLights(veh, SET_INDICATOR_LEFT, false)

        SendNUIMessage({
            type           = "updateSpeedometer",
            leftIndicator  = 0,
            rightIndicator = newState and 1 or 0,
        })
    end, false)
    RegisterKeyMapping("toggleindicatorright", TableGet(Strings, "CommandDesc", "indicatorRight") or "Toggle Right Blinker", "keyboard", TableGet(KeyBindsConfig, "indicatorRight") or "RIGHT")

    RegisterCommand("togglehazard", function()
        if Settings.DisableIndicators or (Client.Data and (Client.Data.DISABLEINDICATORS == 1 or Client.Data.DISABLEINDICATORS == true)) then return end
        if not Client or not Client.Vehicle then return end

        local now = GetGameTimer()
        if Client.HazardLastToggle and (now - Client.HazardLastToggle) < 350 then
            return
        end
        Client.HazardLastToggle = now

        local veh = Client.Vehicle
        Client.Hazard = GetIndicatorState(veh) ~= INDICATOR_STATE_BOTH
        local on = Client.Hazard

        SetVehicleIndicatorLights(veh, SET_INDICATOR_RIGHT, on)
        SetVehicleIndicatorLights(veh, SET_INDICATOR_LEFT, on)

        SendNUIMessage({
            type           = "updateSpeedometer",
            leftIndicator  = on and 1 or 0,
            rightIndicator = on and 1 or 0,
        })
    end, false)
    RegisterKeyMapping("togglehazard", TableGet(Strings, "CommandDesc", "hazard") or "Hazard Lights", "keyboard", TableGet(KeyBindsConfig, "hazard") or "UP")

    local playerInfoCmd = Settings.TogglePlayerInfoCommand or "toggleplayerinfo"
    local playerInfoCfg = Settings.TogglePlayerInfoKeybind or { enabled = true, key = "o", description = "Toggle Player Info HUD" }

    RegisterCommand(playerInfoCmd, function()
        if not Client or not Client.Data then return end

        if not Client.Data.PLAYERINFO then
            Client.Data.PLAYERINFO = {}
        end

        local currentShow = Client.Data.PLAYERINFO.SHOW
        if currentShow == nil then
            currentShow = true
        end

        local newShow = not currentShow
        Client.Data.PLAYERINFO.SHOW = newShow

        if Client.Functions and Client.Functions.SetData then
            Client.Functions.SetData(Client.Data)
        end

        SendNUIMessage({
            type = "updateSettings",
            data = Client.Data
        })
    end, false)

    if playerInfoCfg.enabled ~= false and playerInfoCfg.key and playerInfoCfg.key ~= "" and playerInfoCfg.key ~= "none" then
        RegisterKeyMapping(
            playerInfoCmd,
            playerInfoCfg.description or TableGet(Strings, "CommandDesc", "togglePlayerInfo") or "Toggle Player Info HUD",
            "keyboard",
            playerInfoCfg.key
        )
    end
end

function Keybinds:Update()
    SendNUIMessage({
        type     = "updateKeybinds",
        keybinds = KeyBindsConfig
    })
end
