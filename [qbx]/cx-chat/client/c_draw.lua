local meMessages = {}
local showIDs = false

local function DrawText3D(coords, text, cfg, zOffset)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z + zOffset)
    if not onScreen then return end

    SetTextScale(cfg.scale, cfg.scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(cfg.color.r, cfg.color.g, cfg.color.b, cfg.color.a)
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(x, y)
end

RegisterNetEvent("cx-chat:meAboveHead")
AddEventHandler("cx-chat:meAboveHead", function(data)
    if not Config.MeAboveHead.enabled then return end

    local player = GetPlayerFromServerId(data.serverId)
    if player == -1 and data.serverId ~= GetPlayerServerId(PlayerId()) then return end

    table.insert(meMessages, {
        player = player,
        text   = data.text,
        time   = GetGameTimer() + Config.MeAboveHead.duration,
    })
end)

local visibleIDs = {}

CreateThread(function()
    while true do
        if Config.IDDisplay.enabled and showIDs then
            local ped      = PlayerPedId()
            local myCoords = GetEntityCoords(ped)
            local myId     = PlayerId()
            local next     = {}

            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                if DoesEntityExist(targetPed) then
                    local coords = GetEntityCoords(targetPed)
                    if #(myCoords - coords) < Config.IDDisplay.distance then
                        local isSelf = player == myId
                        if isSelf then
                            if Config.IDDisplay.showOwnID then
                                next[#next + 1] = { ped = targetPed, label = "[" .. GetPlayerServerId(player) .. "]" }
                            end
                        elseif HasEntityClearLosToEntity(ped, targetPed, 17) then
                            next[#next + 1] = { ped = targetPed, label = "[" .. GetPlayerServerId(player) .. "]" }
                        end
                    end
                end
            end

            visibleIDs = next
            Wait(250)
        else
            visibleIDs = {}
            Wait(500)
        end
    end
end)

CreateThread(function()
    local idCfg = Config.IDDisplay

    while true do
        local sleep    = 1000
        local ped      = PlayerPedId()
        local myCoords = GetEntityCoords(ped)
        local now      = GetGameTimer()

        if #meMessages > 0 then
            sleep = 0
            for i = #meMessages, 1, -1 do
                local msg = meMessages[i]
                if now > msg.time then
                    table.remove(meMessages, i)
                else
                    local targetPed = GetPlayerPed(msg.player)
                    if DoesEntityExist(targetPed) then
                        local coords = GetEntityCoords(targetPed)
                        if #(myCoords - coords) < 20.0 then
                            DrawText3D(coords, msg.text, Config.MeAboveHead, 1.0)
                        end
                    end
                end
            end
        end

        if idCfg.enabled and showIDs and #visibleIDs > 0 then
            sleep = 0
            SetTextScale(idCfg.scale, idCfg.scale)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(idCfg.color.r, idCfg.color.g, idCfg.color.b, idCfg.color.a)
            SetTextOutline()
            SetTextCentre(1)

            for i = 1, #visibleIDs do
                local entry = visibleIDs[i]
                if DoesEntityExist(entry.ped) then
                    local coords = GetEntityCoords(entry.ped)
                    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z + 1.15)
                    if onScreen then
                        SetTextEntry("STRING")
                        AddTextComponentString(entry.label)
                        DrawText(x, y)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterCommand("ids", function()
    if not Config.IDDisplay.enabled then return end
    showIDs = not showIDs
    local msg = showIDs and "Player IDs enabled." or "Player IDs disabled."
    SendNUIMessage({
        type = "addMessage",
        data = {
            message  = msg,
            color    = "#3dd68c",
            tag      = "SYSTEM",
            tagColor = "#3dd68c",
            isSystem = true,
        }
    })
end, false)
