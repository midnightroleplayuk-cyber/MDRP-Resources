DiscordLogConfig = {
    enabled = true,
    botName = "tw-litejobpack",
    botLogo = Config.ExampleProfilePicture,
    botToken = "",
    webhooks = {
        jobFinish   = "",
        jobLog      = "",
        achievement = "",
    },
    footerText = "tw-litejobpack",
}

local Caches = {
    Avatars = {}
}

DisconnectedPlayers = {}
ReconnectionTracking = {}

function StoreDisconnectedPlayerState(identifier, lobbyId, playerData)
    if not Config.Reconnection.enabled then
        return
    end

    if not ReconnectionTracking[identifier] then
        ReconnectionTracking[identifier] = {
            attempts = 0,
            lastStableConnection = os.time(),
            totalDisconnects = 0
        }
    end

    ReconnectionTracking[identifier].totalDisconnects = ReconnectionTracking[identifier].totalDisconnects + 1

    DisconnectedPlayers[identifier] = {
        lobbyId = lobbyId,
        playerData = playerData,
        disconnectTime = os.time(),
        reconnectAttempts = ReconnectionTracking[identifier].attempts
    }
end

function HasActiveGracePeriod(identifier)
    if not Config.Reconnection.enabled then
        return false
    end

    local state = DisconnectedPlayers[identifier]
    if not state then return false end

    if not coopData[state.lobbyId] then
        DisconnectedPlayers[identifier] = nil
        return false
    end

    if Config.Reconnection.gracePeriodSeconds > 0 then
        local elapsed = os.time() - state.disconnectTime
        if elapsed > Config.Reconnection.gracePeriodSeconds then
            DisconnectedPlayers[identifier] = nil
            return false
        end
    end

    if Config.Reconnection.maxReconnectAttempts > 0 then
        local tracking = ReconnectionTracking[identifier]
        if tracking and tracking.attempts >= Config.Reconnection.maxReconnectAttempts then
            DisconnectedPlayers[identifier] = nil
            return false
        end
    end

    return true
end

function UpdateStableConnection(identifier)
    if not Config.Reconnection.enabled then return end

    local tracking = ReconnectionTracking[identifier]
    if not tracking then return end

    local now = os.time()
    local timeSinceReconnect = now - tracking.lastStableConnection

    if timeSinceReconnect >= Config.Reconnection.resetAttemptsAfterSeconds then
        tracking.attempts = 0
        tracking.lastStableConnection = now
    end
end

function RestorePlayerToLobby(src, identifier)
    local state = DisconnectedPlayers[identifier]
    if not state then
        return false
    end

    local lobby = coopData[state.lobbyId]
    if not lobby then
        DisconnectedPlayers[identifier] = nil
        TriggerClientEvent(_event('client:sendNotification'), src,
            _('server.lobbyNoLongerExists'),
            "error")
        return false
    end

    for _i, player in ipairs(lobby.players) do
        if player.playerIdentifier == identifier then
            player.source = src
            local reconnectedName = player.playerName

            if not ReconnectionTracking[identifier] then
                ReconnectionTracking[identifier] = {
                    attempts = 0,
                    lastStableConnection = os.time(),
                    totalDisconnects = 0
                }
            end
            ReconnectionTracking[identifier].attempts = ReconnectionTracking[identifier].attempts + 1
            ReconnectionTracking[identifier].lastStableConnection = os.time()

            if Config.Reconnection.notifications.notifyAttemptsRemaining and Config.Reconnection.maxReconnectAttempts > 0 then
                local remaining = Config.Reconnection.maxReconnectAttempts - ReconnectionTracking[identifier].attempts
                if remaining > 0 then
                    TriggerClientEvent(_event('client:sendNotification'), src,
                        string.format("Reconnection successful! Attempts remaining: %d/%d", remaining,
                            Config.Reconnection.maxReconnectAttempts),
                        "success")
                end
            end

            DisconnectedPlayers[identifier] = nil

            local jobId = lobby.roomSetting.jobId
            local isActiveJob = lobby.roomSetting.startJob and not lobby.roomSetting.finishJob

            if isActiveJob and jobId then
                local lobbyData = {
                    jobId = jobId,
                    ownerIdentifier = lobby.roomSetting.owneridentifier,
                    players = {},
                    isReconnect = true,
                }

                for _i, p in ipairs(lobby.players) do
                    table.insert(lobbyData.players, {
                        source = p.source,
                        playerName = p.playerName,
                        playerIdentifier = p.playerIdentifier,
                        playerOwner = p.playerOwner,
                        playerLevel = p.playerLevel,
                        playerImage = p.playerImage,
                    })
                end

                TriggerClientEvent(_event('client:reconnectToJob'), src, lobbyData)

                Wait(1500)

                TriggerEvent('tw-litejobpack:server:job:playerJoined:' .. jobId, state.lobbyId, src)
            end

            for _i, otherPlayer in ipairs(lobby.players) do
                if otherPlayer.source > 0 then
                    TriggerClientEvent(_event('client:RefreshPlayers'), otherPlayer.source, lobby.players)
                end
            end

            if Config.Reconnection.notifications.notifyOnReconnect then
                for _pi, otherPlayer in ipairs(lobby.players) do
                    if otherPlayer.source > 0 and otherPlayer.source ~= src then
                        TriggerClientEvent(_event('client:sendNotification'), otherPlayer.source,
                            _('server.lobbyPlayerReconnected', { name = reconnectedName }),
                            "success")
                    end
                end
            end

            return true
        end
    end

    DisconnectedPlayers[identifier] = nil

    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)

        for identifier, state in pairs(DisconnectedPlayers) do
            if not coopData[state.lobbyId] then
                DisconnectedPlayers[identifier] = nil
            end
        end

        if Config.Reconnection and Config.Reconnection.enabled then
            local gracePeriod = Config.Reconnection.gracePeriodSeconds or 300
            local now = os.time()

            for lobbyKey, lobby in pairs(coopData) do
                if lobby.roomSetting and lobby.roomSetting.startJob and not lobby.roomSetting.finishJob then
                    local allOffline = true
                    local anyGracePeriodActive = false

                    for _i, player in ipairs(lobby.players) do
                        if player.source and player.source > 0 then
                            allOffline = false
                            break
                        end

                        local dcState = DisconnectedPlayers[player.playerIdentifier]
                        if dcState and (gracePeriod <= 0 or (now - dcState.disconnectTime) < gracePeriod) then
                            anyGracePeriodActive = true
                        end
                    end

                    if allOffline and not anyGracePeriodActive then
                        local jobId = lobby.roomSetting.jobId
                        if jobId and GenericSessionManager and GenericSessionManager.HasSession(jobId, lobbyKey) then
                            pcall(function()
                                GenericSessionManager.CleanupSession(jobId, lobbyKey)
                            end)
                        end
                        coopData[lobbyKey] = nil

                        for identifier, state in pairs(DisconnectedPlayers) do
                            if state.lobbyId == lobbyKey then
                                DisconnectedPlayers[identifier] = nil
                                ReconnectionTracking[identifier] = nil
                            end
                        end
                    end
                end
            end

            if _G.ReconnectingPlayerSources then
                for src, _ in pairs(_G.ReconnectingPlayerSources) do
                    if not GetPlayerName(src) then
                        _G.ReconnectingPlayerSources[src] = nil
                    end
                end
            end

            local staleThreshold = math.max(gracePeriod, 600)
            for identifier, tracking in pairs(ReconnectionTracking) do
                if not DisconnectedPlayers[identifier] then
                    local timeSinceStable = now - (tracking.lastStableConnection or 0)
                    if timeSinceStable > staleThreshold then
                        ReconnectionTracking[identifier] = nil
                    end
                end
            end
        end
    end
end)

local function DiscordRequest(method, endpoint, jsondata, callback)
    local token = DiscordLogConfig and DiscordLogConfig.botToken or ""
    local formattedToken = "Bot " .. token
    PerformHttpRequest(
        "https://discordapp.com/api/" .. endpoint,
        function(errorCode, resultData, resultHeaders)
            if callback then
                callback({ data = resultData, code = errorCode, headers = resultHeaders })
            end
        end,
        method,
        #jsondata > 0 and json.encode(jsondata) or "",
        { ["Content-Type"] = "application/json", ["Authorization"] = formattedToken }
    )
end

function GetDiscordAvatar(user, cb)
    local discordId = nil
    for _i, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end

    local token = DiscordLogConfig and DiscordLogConfig.botToken or ""

    if not discordId or token == "" then
        if cb then cb(nil) end
        return nil
    end

    local cached = Caches.Avatars[discordId]
    if cached ~= nil then
        local url = (cached ~= "" and cached) or nil
        if cb then cb(url) end
        return url
    end

    local endpoint = ("users/%s"):format(discordId)
    DiscordRequest("GET", endpoint, {}, function(member)
        local url = nil
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil and data.avatar ~= nil then
                local ext = (data.avatar:sub(1, 2) == "a_") and ".gif" or ".png"
                url = "https://media.discordapp.net/avatars/" .. discordId .. "/" .. data.avatar .. ext
            end
        end
        Caches.Avatars[discordId] = url or ""
        if cb then cb(url) end
    end)

    return nil
end

function sendDiscordLogHistory(data)
    if not DiscordLogConfig or not DiscordLogConfig.enabled then return end

    local webhookUrl = DiscordLogConfig.webhooks and DiscordLogConfig.webhooks.jobFinish or ""
    if webhookUrl == "" then return end

    Citizen.CreateThread(function()
        local players = data.players or {}
        local playerCount = #players
        local isCoop = playerCount > 1

        local playerLines = {}
        for _i, p in ipairs(players) do
            table.insert(playerLines, string.format(
                "**%s** \u{2014} `ID: %s` \u{2014} `%s`",
                p.name or "Unknown",
                tostring(p.src or "?"),
                p.identifier or "N/A"
            ))
        end

        local paymentStr = string.format("%s%d", Config.CurrencySymbol, tonumber(data.payment) or 0)
        local xpStr = tostring(tonumber(data.xp) or 0)
        if isCoop then
            paymentStr = paymentStr .. " /player"
            xpStr = xpStr .. " /player"
        end

        local botLogo = DiscordLogConfig.botLogo or ""
        local thumbnail = isCoop
            and botLogo
            or (players[1] and players[1].avatar ~= "" and players[1].avatar or botLogo)

        local message = {
            username = DiscordLogConfig.botName or "tw-litejobpack",
            avatar_url = DiscordLogConfig.botLogo or "",
            embeds = {
                {
                    author = {
                        name = isCoop
                            and string.format("Job Completed \u{2014} %d Players", playerCount)
                            or "Job Completed",
                        icon_url = DiscordLogConfig.botLogo or "",
                    },
                    color = 0x2ECC71,
                    thumbnail = { url = thumbnail },
                    fields = {
                        { name = "Job",               value = tostring(data.jobName or data.jobId or "Unknown"), inline = true },
                        { name = "Region",            value = tostring(data.regionName or "N/A"),                inline = true },
                        { name = "\u{200B}",          value = "\u{200B}",                                        inline = true },
                        { name = "\u{1F4B0} Payment", value = paymentStr,                                        inline = true },
                        { name = "\u{2B50} XP",       value = xpStr,                                             inline = true },
                        { name = "\u{200B}",          value = "\u{200B}",                                        inline = true },
                        {
                            name = isCoop and "\u{1F465} Team" or "\u{1F464} Player",
                            value = table.concat(playerLines, "\n"),
                            inline = false,
                        },
                    },
                    footer = {
                        text = DiscordLogConfig.footerText or "tw-litejobpack",
                        icon_url = DiscordLogConfig.botLogo or "",
                    },
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                }
            },
        }

        PerformHttpRequest(webhookUrl, function(err, text, headers)
            if err and err ~= 204 and err ~= 200 then
                print(("[DiscordLog] Webhook error: %s"):format(tostring(err)))
            end
        end, "POST", json.encode(message), { ["Content-Type"] = "application/json" })
    end)
end

function sendDiscordLog(data)
    if not DiscordLogConfig or not DiscordLogConfig.enabled then return end

    local webhookUrl = DiscordLogConfig.webhooks and DiscordLogConfig.webhooks.jobLog or ""
    if webhookUrl == "" then return end

    Citizen.CreateThread(function()
        local botLogo = DiscordLogConfig.botLogo or ""

        local message = {
            username = DiscordLogConfig.botName or "tw-litejobpack",
            avatar_url = botLogo,
            embeds = {
                {
                    author = {
                        name = data.title or "Log",
                        icon_url = botLogo,
                    },
                    color = data.color or 0x3498DB,
                    description = data.description or nil,
                    thumbnail = data.thumbnail and { url = data.thumbnail } or nil,
                    fields = data.fields or {},
                    footer = {
                        text = DiscordLogConfig.footerText or "tw-litejobpack",
                        icon_url = botLogo,
                    },
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                }
            },
        }

        PerformHttpRequest(webhookUrl, function(err, text, headers)
            if err and err ~= 204 and err ~= 200 then
                print(("[DiscordLog] jobLog webhook error: %s"):format(tostring(err)))
            end
        end, "POST", json.encode(message), { ["Content-Type"] = "application/json" })
    end)
end

AddEventHandler('playerDropped', function(reason)
    local src = source
    local playerIdentifier = GetIdentifier(src)
    if not playerIdentifier then return end

    if Lobby then
        if Lobby.ClearPendingInviteFor then
            Lobby.ClearPendingInviteFor(playerIdentifier)
        end

        if Lobby.ClearPendingInvitesForLobby and coopData[playerIdentifier] then
            Lobby.ClearPendingInvitesForLobby(playerIdentifier)
        end

        if Lobby.ClearInviteCooldownsForPlayer then
            Lobby.ClearInviteCooldownsForPlayer(playerIdentifier)
        end
    end

    local lobbyInfo = Lobby.GetPlayerLobbyByIdentifier(playerIdentifier)
    if lobbyInfo then
        local lobby = lobbyInfo.lobbyData
        local isActiveJob = lobby.roomSetting.startJob and not lobby.roomSetting.finishJob
        local lobbyKey = lobbyInfo.lobbyId

        if isActiveJob then
            if not Config.Reconnection or not Config.Reconnection.enabled then
                if lobbyInfo.isOwner then
                    Lobby.HandleActiveJobOwnerLeave(playerIdentifier, src, lobby, lobbyKey, 'disconnect')
                else
                    Lobby.HandleActiveJobMemberLeave(playerIdentifier, src, lobby, lobbyKey)
                end
                return
            end

            local playerData = nil
            for _i, player in ipairs(lobby.players) do
                if player.playerIdentifier == playerIdentifier then
                    playerData = player
                    break
                end
            end

            if not playerData then return end

            if lobby.activePressOperations then
                for pressId, ops in pairs(lobby.activePressOperations) do
                    if ops.placing == src then ops.placing = nil end
                    if ops.picking == src then ops.picking = nil end
                end
            end
            if lobby.activeShreddingOps then
                for shredId, ops in pairs(lobby.activeShreddingOps) do
                    if ops.placing == src then ops.placing = nil end
                end
            end
            if lobby.carryingItems and lobby.carryingItems[src] then
                lobby.carryingItems[src] = nil
            end
            if lobby.pickupLocks then
                for lockKey, lockedBySrc in pairs(lobby.pickupLocks) do
                    if lockedBySrc == src then
                        lobby.pickupLocks[lockKey] = nil
                    end
                end
            end

            if lobbyInfo.isOwner then
                local hasOtherPlayers = false
                for _i, player in ipairs(lobby.players) do
                    if player.playerIdentifier ~= playerIdentifier and player.source > 0 then
                        hasOtherPlayers = true
                        break
                    end
                end

                if hasOtherPlayers then
                    local newOwner = Lobby.SelectNewOwner(lobby, playerIdentifier)
                    if newOwner then
                        Lobby.TransferOwnershipInPlace(lobby, newOwner)
                    end
                end

                playerData.source = 0

                StoreDisconnectedPlayerState(playerIdentifier, lobbyKey, playerData)

                if Config.Reconnection.notifications.notifyOnDisconnect then
                    for _pi, otherPlayer in ipairs(lobby.players) do
                        if otherPlayer.source > 0 and otherPlayer.playerIdentifier ~= playerIdentifier then
                            TriggerClientEvent(_event('client:sendNotification'), otherPlayer.source,
                                _('server.lobbyPlayerDisconnected', { name = playerData.playerName }),
                                "error")
                            TriggerClientEvent(_event('client:RefreshPlayers'), otherPlayer.source, lobby.players)
                        end
                    end
                end
            else
                playerData.source = 0

                StoreDisconnectedPlayerState(playerIdentifier, lobbyKey, playerData)

                if Config.Reconnection.notifications.notifyOnDisconnect then
                    for _pi, otherPlayer in ipairs(lobby.players) do
                        if otherPlayer.source > 0 and otherPlayer.playerIdentifier ~= playerIdentifier then
                            TriggerClientEvent(_event('client:sendNotification'), otherPlayer.source,
                                _('server.lobbyPlayerDisconnected', { name = playerData.playerName }),
                                "error")
                            TriggerClientEvent(_event('client:RefreshPlayers'), otherPlayer.source, lobby.players)
                        end
                    end
                end
            end

            _G.ReconnectingPlayerSources = _G.ReconnectingPlayerSources or {}
            _G.ReconnectingPlayerSources[src] = true

            return
        end
    end

    local isOwner = coopData[playerIdentifier] ~= nil

    if isOwner then
        if not Config.Reconnection.ownerTransfer.enabled then
            local lobby = coopData[playerIdentifier]
            if lobby then
                for _pi, player in ipairs(lobby.players) do
                    if player.source > 0 and player.source ~= src then
                        TriggerClientEvent(_event('client:resetjob'), player.source)
                        TriggerClientEvent(_event('client:sendNotification'), player.source,
                            _('server.lobbyClosedDisconnect'),
                            "error")
                    end
                end

                coopData[playerIdentifier] = nil
                JobTask[playerIdentifier] = nil
            end
            return
        end

        local transferred, newOwner = Lobby.HandleOwnerDisconnect(playerIdentifier, src)

        if transferred then
            local lobby = coopData[newOwner.playerIdentifier]

            for _pi, player in ipairs(lobby.players) do
                if player.source > 0 then
                    TriggerClientEvent(_event('client:sendNotification'), player.source,
                        _('server.lobbyOwnerDisconnectedNewOwner', { name = newOwner.playerName }),
                        "info")
                end
            end
        else
            local lobby = coopData[playerIdentifier]
            if lobby and lobby.roomSetting then
                if lobby.roomSetting.VehicleNetId then
                    for _i, netId in pairs(lobby.roomSetting.VehicleNetId) do
                        for plate, rental in pairs(rentalByPlate) do
                            if rental.netID == netId then
                                local vehicleKey = rental.vehicleKey
                                local info = spawnedByKey[vehicleKey]

                                if info and info.entity and DoesEntityExist(info.entity) then
                                    DeleteEntity(info.entity)
                                end

                                if info then
                                    info.rented = false
                                    info.rentedBy = nil
                                    info.rentedTime = nil
                                    info.lobbyId = nil
                                end

                                rentalByPlate[plate] = nil

                                if info and info.netID and vehicleGridStates[info.netID] then
                                    vehicleGridStates[info.netID] = nil
                                end
                                break
                            end
                        end
                    end
                end

                if Lobby.ClearPressedObjects then
                    Lobby.ClearPressedObjects(playerIdentifier)
                    Lobby.ClearAllPressAreaItems(playerIdentifier)
                end

                for _pi, player in ipairs(lobby.players) do
                    if player.source ~= src and player.source > 0 then
                        TriggerClientEvent(_event('client:resetjob'), player.source)
                        TriggerClientEvent(_event('client:sendNotification'), player.source,
                            _('server.lobbyClosedNoReplacement'),
                            "error")
                        TriggerClientEvent(_event('client:clearLobbyPressedObjects'), player.source, playerIdentifier)
                    end
                end

                coopData[playerIdentifier] = nil
                JobTask[playerIdentifier] = nil
            end
        end
    else
        local lobbyInfo = Lobby.GetPlayerLobbyByIdentifier(playerIdentifier)

        if lobbyInfo then
            local lobby = lobbyInfo.lobbyData
            local ownerIdentifier = lobbyInfo.lobbyId

            local playerData = nil
            for _i, player in ipairs(lobby.players) do
                if player.playerIdentifier == playerIdentifier then
                    playerData = player
                    break
                end
            end

            if playerData then
                if lobby.activePressOperations then
                    for pressId, ops in pairs(lobby.activePressOperations) do
                        if ops.placing == src then
                            ops.placing = nil
                        end
                        if ops.cycling == src then

                        end
                        if ops.picking == src then
                            ops.picking = nil
                        end
                    end
                end

                if lobby.activeShreddingOps then
                    for shredId, ops in pairs(lobby.activeShreddingOps) do
                        if ops.placing == src then
                            ops.placing = nil
                        end
                        if ops.starting == src then

                        end
                    end
                end

                if lobby.carryingItems and lobby.carryingItems[src] then
                    lobby.carryingItems[src] = nil
                end

                if lobby.pickupLocks then
                    for lockKey, lockedBySrc in pairs(lobby.pickupLocks) do
                        if lockedBySrc == src then
                            lobby.pickupLocks[lockKey] = nil
                        end
                    end
                end

                StoreDisconnectedPlayerState(playerIdentifier, ownerIdentifier, playerData)

                playerData.source = 0

                if Config.Reconnection.notifications.notifyOnDisconnect then
                    for _pi, otherPlayer in ipairs(lobby.players) do
                        if otherPlayer.source > 0 and otherPlayer.source ~= src then
                            TriggerClientEvent(_event('client:sendNotification'), otherPlayer.source,
                                _('server.lobbyPlayerDisconnected', { name = playerData.playerName }),
                                "error")
                        end
                    end
                end
            end
        end
    end
end)
