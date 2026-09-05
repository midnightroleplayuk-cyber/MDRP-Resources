local isInitialized = false
local uiReady = false

CxChatSpawned = false

local function GetOwnCharName()
    if Config.Framework == "qbcore" or Config.Framework == "qbox" then
        local QBCore = exports['qb-core']:GetCoreObject()
        local pd = QBCore and QBCore.Functions.GetPlayerData()
        if pd and pd.charinfo then
            return pd.charinfo.firstname .. " " .. pd.charinfo.lastname
        end
    elseif Config.Framework == "esx" then
        local ESX = exports['es_extended']:getSharedObject()
        local pd = ESX and ESX.GetPlayerData()
        if pd and pd.firstName then return pd.firstName .. " " .. pd.lastName end
    end
    return GetPlayerName(PlayerId()) or "Unknown"
end

local function BootChat()
    if isInitialized then return end
    isInitialized = true

    SendNUIMessage({
        type = "init",
        config = {
            serverName       = Config.ServerName,
            maxMessages      = Config.MaxMessages,
            channels         = Config.Channels,
            tabChannels      = Config.TabChannels,
            timestamps       = Config.Timestamps,
            formatting       = Config.MessageFormatting,
            defaultChannel   = Config.DefaultChannel,
            chatWidth        = Config.ChatWidth,
            chatHeight       = Config.ChatHeight,
            reportEnabled    = Config.ReportSystem.enabled,
            reportCats       = Config.ReportSystem.categories,
            theme            = Config.Theme,
            customTheme      = Config.CustomTheme,
            reactions        = Config.Reactions,
            mentions         = Config.Mentions,
            pinning          = Config.Pinning,
            typingIndicators = Config.TypingIndicators,
            messageEditing   = Config.MessageEditing,
            copyMessage      = Config.CopyMessage,
            minigames        = Config.Minigames,
            quickActions     = Config.QuickActions,
            disableChatMessages = Config.DisableChatMessages,
            canMute          = IsAceAllowed(Config.MessageEditing.mutePermission or "cx-chat.mute"),
            canDelete        = IsAceAllowed(Config.MessageEditing.deletePermission or "cx-chat.delete"),
            ownServerId      = GetPlayerServerId(PlayerId()),
            ownName          = GetOwnCharName(),
            ownCommands      = (function()
                local list = {}
                for _, cmd in ipairs(Config.Commands) do
                    table.insert(list, { command = cmd.command, help = cmd.help or "", params = cmd.params or {} })
                end
                return list
            end)(),
        }
    })

    TriggerServerEvent("cx-chat:getCommands")
end

RegisterNUICallback("uiReady", function(data, cb)
    uiReady = true
    cb("ok")
end)

local function OnPlayerSpawned()
    if CxChatSpawned then return end

    CreateThread(function()
        while not uiReady do
            Wait(100)
        end

        CxChatSpawned = true
        BootChat()

        Wait(Config.JoinLeave.joinDelay or 3000)

        if Config.MOTD.enabled then
            for _, line in ipairs(Config.MOTD.lines) do
                SendNUIMessage({
                    type = "addMessage",
                    data = {
                        message  = line,
                        color    = Config.MOTD.color,
                        tag      = Config.MOTD.prefix,
                        tagColor = Config.MOTD.prefixColor,
                        channel  = Config.DefaultChannel,
                        isSystem = true,
                    }
                })
            end
        end

        SendNUIMessage({ type = "close" })
    end)
end

AddEventHandler("playerSpawned", OnPlayerSpawned)
if Config.Framework == "qbcore" or Config.Framework == "qbox" then
    AddEventHandler("QBCore:Client:OnPlayerLoaded", OnPlayerSpawned)
end
if Config.Framework == "esx" then
    AddEventHandler("esx:playerLoaded", OnPlayerSpawned)
end

AddEventHandler("onResourceStart", function(res)
    if res ~= GetCurrentResourceName() then return end
    if NetworkIsPlayerActive(PlayerId()) and DoesEntityExist(PlayerPedId()) then
        OnPlayerSpawned()
    end
end)

CreateThread(function()
    while not CxChatSpawned do
        Wait(2000)
        if NetworkIsPlayerActive(PlayerId()) and DoesEntityExist(PlayerPedId()) then
            OnPlayerSpawned()
        end
    end
end)
