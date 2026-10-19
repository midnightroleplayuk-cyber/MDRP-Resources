local ServerSlots = 48
local Freezed, Noclip, Spectating, SpectatingTarget

-- Get server slots
CreateThread(function()
    local slotCount = lib.callback.await('apex_adminmenu:slotCount', 100)
    if slotCount then
        ServerSlots = slotCount
    end
end)

-- Function to get players (local implementation to avoid nil error)
local function GetPlayers()
    local players = {}
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end
    return players
end

-- ── Spectate ───────────────────────────────────────────────
-- This used to look the target up locally, which only works for players
-- already inside our OneSync scope (a few hundred metres). Anyone further
-- away came back as "player not found", and a target who drove off
-- mid-spectate fell out of scope and ended it. Now:
--   1. the server says where the target is (and moves us into their
--      dimension if they are in another one);
--   2. our hidden, frozen ped is parked under them, which pulls them
--      into scope;
--   3. the game's own spectator camera follows their ped, and the parked
--      ped keeps following it so they never leave scope.
local SPECTATE_DEPTH = 15.0 -- how far under the target our ped waits
local SpectateHome          -- { coords, heading, visible } to restore on stop
local spectateSession = 0   -- bumped on every start/stop; stale loops exit

local function spectateTargetPed(serverId)
    local ply = GetPlayerFromServerId(serverId)
    if ply == -1 then return 0 end
    local ped = GetPlayerPed(ply)
    if ped == 0 or not DoesEntityExist(ped) then return 0 end
    return ped
end

local function parkUnder(x, y, z)
    RequestCollisionAtCoord(x, y, z)
    SetEntityCoords(PlayerPedId(), x, y, z - SPECTATE_DEPTH, false, false, false, false)
end

-- Asks the server where the target is, parks under them and waits for
-- them to stream in. Returns their ped (0 if they left or never showed
-- up) and their name.
local function reachSpectateTarget(target)
    local pos = lib.callback.await('apex_adminmenu:spectateTarget', false, target)
    if not pos then return 0 end
    parkUnder(pos.x, pos.y, pos.z)
    local deadline = GetGameTimer() + 5000
    while GetGameTimer() < deadline do
        local ped = spectateTargetPed(target)
        if ped ~= 0 then return ped, pos.name end
        Wait(100)
    end
    return 0
end

-- Global: the admin panel (client/adminpanel.lua) and the keybinds call it too.
SpectatePlayer = function(target)
    target = tonumber(target)
    if not target then return end
    if target == GetPlayerServerId(PlayerId()) then
        TriggerEvent('apex_adminmenu:notify', Strings.spectate_error, Strings.spectate_error_desc, 'error', 'fa-xmark')
        return
    end

    -- The quick menu's Spectate entry keeps the menu open, and with it the
    -- NUI focus: the X to stop never reached the game, and the menu sat
    -- over the view.
    if IsAdminMenuOpen and IsAdminMenuOpen() and CloseAdminMenuFull then
        CloseAdminMenuFull()
    end

    spectateSession = spectateSession + 1
    local session = spectateSession

    CreateThread(function()
        -- Switching straight from one target to another keeps the home
        -- position of the first one.
        if not Spectating then
            -- Noclip drives our ped every frame and would fight the parking.
            if IsNoClipping and ToggleNoClip then
                ToggleNoClip(false)
                Wait(250)
            end
            local ped = PlayerPedId()
            -- Parking a ped that sits in a car drags the car along.
            if IsPedInAnyVehicle(ped, false) then ClearPedTasksImmediately(ped) end
            SpectateHome = {
                coords  = GetEntityCoords(ped),
                heading = GetEntityHeading(ped),
                visible = IsEntityVisible(ped)
            }
            SetEntityVisible(ped, false, false)
            SetEntityInvincible(ped, true)
            SetEntityCollision(ped, false, false)
            FreezeEntityPosition(ped, true)
        end
        Spectating, SpectatingTarget = true, target

        local targetPed, targetName = reachSpectateTarget(target)
        if session ~= spectateSession then return end -- superseded while we waited
        if targetPed == 0 then
            TriggerEvent('apex_adminmenu:notify', Strings.spectate_error, Strings.spectate_error_desc, 'error', 'fa-xmark')
            StopSpectatePlayer(true)
            return
        end

        targetName = targetName or GetPlayerName(GetPlayerFromServerId(target)) or ('#' .. target)
        NetworkSetInSpectatorMode(true, targetPed)
        TriggerEvent('apex_adminmenu:notify', Strings.spectate_started, Strings.spectate_started_desc:format(targetName), 'info', 'fa-eye')

        local lastPed, nextPark = targetPed, 0
        while Spectating and session == spectateSession do
            Wait(0)

            targetPed = spectateTargetPed(target)
            if targetPed == 0 then
                -- Out of scope: they teleported away, or left. Ask again.
                targetPed = reachSpectateTarget(target)
                if session ~= spectateSession then return end
                if targetPed == 0 then
                    TriggerEvent('apex_adminmenu:notify', Strings.spectate_error, Strings.spectate_error_desc, 'error', 'fa-xmark')
                    StopSpectatePlayer(true)
                    return
                end
            end

            -- Respawns and model changes hand the player a new ped.
            if targetPed ~= lastPed then
                NetworkSetInSpectatorMode(true, targetPed)
                lastPed = targetPed
            end

            local now = GetGameTimer()
            if now >= nextPark then
                local c = GetEntityCoords(targetPed)
                parkUnder(c.x, c.y, c.z)
                nextPark = now + 500
            end

            DrawTextOnScreen('Spectating: ' .. targetName .. ' (ID: ' .. target .. ')', 0.5, 0.05, 0.5, {r = 255, g = 255, b = 255, a = 200})
            DrawTextOnScreen('Press X to stop spectating', 0.5, 0.08, 0.4, {r = 255, g = 255, b = 255, a = 150})

            if IsControlJustPressed(0, 73) then -- X
                StopSpectatePlayer()
                return
            end
        end
    end)
end

-- `silent` skips the "spectate ended" notification (used when an error
-- was already shown). `immediate` restores everything in this call,
-- for resource stop, where no thread gets to run afterwards.
function StopSpectatePlayer(silent, immediate)
    if not Spectating then return end
    local target = SpectatingTarget
    Spectating, SpectatingTarget = false, nil
    spectateSession = spectateSession + 1
    local session = spectateSession

    local ped = PlayerPedId()
    NetworkSetInSpectatorMode(false, ped)

    -- Back to our own dimension before we reappear in it.
    TriggerServerEvent('apex_adminmenu:stopSpectating', target)

    local home = SpectateHome
    SpectateHome = nil
    if home then
        RequestCollisionAtCoord(home.coords.x, home.coords.y, home.coords.z)
        SetEntityCoords(ped, home.coords.x, home.coords.y, home.coords.z, false, false, false, false)
        SetEntityHeading(ped, home.heading)
    end
    SetEntityCollision(ped, true, true)
    SetEntityVisible(ped, not home or home.visible ~= false, false)
    SetEntityInvincible(ped, IsGodModeOn ~= nil and IsGodModeOn() or false)

    if immediate then
        FreezeEntityPosition(ped, false)
    else
        -- Stay frozen until the ground has loaded, or we fall through the
        -- map on the way back from a far-away target.
        CreateThread(function()
            local deadline = GetGameTimer() + 3000
            while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() < deadline do
                Wait(0)
            end
            -- A new spectate started meanwhile: it owns the ped now.
            if session ~= spectateSession then return end
            FreezeEntityPosition(ped, false)
        end)
    end

    if not silent then
        TriggerEvent('apex_adminmenu:notify', Strings.spectate_ended, Strings.spectate_ended_desc, 'info', 'fa-eye-slash')
    end
end

-- Helper function to draw text on screen
function DrawTextOnScreen(text, x, y, scale, color)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextScale(scale, scale)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Function to give money to a player
local givePlayerMoney = function(target, name)
    local dialogOptions = {
        { value = 'money', label = Strings.givemoney_select_option1 },
        { value = 'bank', label = Strings.givemoney_select_option2 }
    }
    
    if Framework == 'esx' then
        dialogOptions[#dialogOptions + 1] = {
            value = 'black_money', label = Strings.givemoney_select_option3
        }
    end
    
    SetSelectedPlayer(target, name)
    
    ShowInputDialog(Strings.dialog_givemoney, {
        { type = 'input', label = Strings.givemoney_input_label, placeholder = Strings.givemoney_input_placeholder },
        { type = 'select', label = Strings.givemoney_select, options = dialogOptions }
    }, 'givePlayerMoney')
end

-- Function to give an item to a player
local givePlayerItem = function(target, name)
    SetSelectedPlayer(target, name)
    
    ShowInputDialog(Strings.dialog_giveitem, {
        { type = 'input', label = Strings.giveitem_input_label, placeholder = Strings.giveitem_input_placeholder },
        { type = 'input', label = Strings.giveitem_amount_input_label, placeholder = Strings.giveitem_amount_input_placeholder }
    }, 'givePlayerItem')
end

-- Function to kick a player
local kickPlayer = function(target, name)
    SetSelectedPlayer(target, name)
    
    ShowInputDialog(Strings.dialog_kick:format(name), {
        { type = 'input', label = Strings.dialog_kick_reason, placeholder = Strings.dialog_kick_placeholder }
    }, 'kickPlayer')
end

-- Function to ban a player.
-- Global so main.lua's valueSelected handler (ban duration picker) can
-- reach it. `currentBanTime` is likewise a shared global read back in
-- main.lua's dialogResponse handler.
banPlayer = function(target, time, name)
    SetSelectedPlayer(target, name)
    currentBanTime = time
    
    ShowInputDialog(Strings.dialog_ban:format(name), {
        { type = 'input', label = Strings.dialog_ban_reason, placeholder = Strings.dialog_ban_placeholder }
    }, 'banPlayer')
end

-- Function to open player data
local openPlayerData = function(target)
    local targetData = lib.callback.await('apex_adminmenu:playerdata', 100, target)
    local options = {}
    
    if Framework == 'esx' then
        options[#options + 1] = {
            icon = 'fas fa-id-card',
            label = Strings.playerdata_license_esx:format(string.sub(targetData.identifier, 0, -20)),
            description = Strings.playerdata_license_desc
        }
    elseif Framework == 'qb' then
        options[#options + 1] = {
            icon = 'fas fa-id-card',
            label = Strings.playerdata_license_qbcore:format(targetData.identifier),
            description = Strings.playerdata_license_desc
        }
    end
    
    options[#options + 1] = {
        icon = 'fas fa-signature',
        label = Strings.playerdata_igname:format(targetData.igname),
        description = Strings.playerdata_igname_desc,
        close = false
    }
    
    options[#options + 1] = {
        icon = 'fas fa-steam',
        label = Strings.playerdata_steam:format(targetData.steamname),
        description = Strings.playerdata_steam_desc,
        close = false
    }
    
    options[#options + 1] = {
        icon = 'fas fa-money-bill',
        label = Strings.playerdata_cash:format(targetData.cash),
        description = Strings.playerdata_cash_desc,
        close = false
    }
    
    options[#options + 1] = {
        icon = 'fas fa-credit-card',
        label = Strings.playerdata_bank:format(targetData.bank),
        description = Strings.playerdata_bank_desc,
        close = false
    }
    
    if Framework == 'esx' then
        options[#options + 1] = {
            icon = 'fas fa-money-bill',
            label = Strings.playerdata_blackmoney:format(targetData.black_money),
            description = Strings.playerdata_blackmoney_desc,
            close = false
        }
    end
    
    SendNUIMessage({
        action = 'openSubMenu',
        title = Strings.playerdata_menu,
        items = options,
        parent = Strings.player_options:format(GetSelectedPlayerName())
    })
    
    -- Register NUI callback for this menu
    RegisterNUICallback('menuSelected', function(data, cb)
        if data.menu == Strings.playerdata_menu then
            if data.index == 0 then
                lib.setClipboard(targetData.identifier)
            end
        end
        cb('ok')
    end)
end

-- Function to handle player options
local plyOptionsMenu = function(target, name)
    local GetPlayerServerId = GetPlayerFromServerId(target)
    local GetPlayerPed = GetPlayerPed(GetPlayerServerId)
    local health = GetEntityHealth((GetPlayerPed)) / 2
    
    SetSelectedPlayer(target, name)
    
    local options = {
        {
            icon = 'fas fa-heart-pulse',
            label = Strings.player_health:format(math.floor(health)),
            close = false,
            progress = health
        },
        {
            icon = 'fas fa-street-view',
            label = Strings.player_freeze,
            description = Strings.player_freeze_desc,
            checked = Freezed or false
        },
        {
            icon = 'fas fa-person-walking-dashed-line-arrow-right',
            label = Strings.player_noclip,
            description = Strings.player_noclip_desc,
            checked = Noclip or false
        },
        {
            icon = 'fas fa-eye',
            label = Strings.player_spectate,
            description = Strings.player_spectate_desc,
            close = false
        },
        {
            icon = 'fas fa-database',
            label = Strings.player_playerdata,
            description = Strings.player_playerdata_desc
        },
        {
            icon = 'fas fa-bed-pulse',
            close = false,
            label = Strings.player_revive,
            description = Strings.player_revive_desc
        },
        {
            icon = 'fas fa-bandage',
            close = false,
            label = Strings.player_heal,
            description = Strings.player_heal_desc
        },
        {
            icon = 'fas fa-shirt',
            label = Strings.player_skinmenu,
            description = Strings.player_skinmenu_desc
        },
        {
            icon = 'fas fa-money-bill',
            label = Strings.player_money,
            description = Strings.player_money_desc
        },
        {
            icon = 'fas fa-hand-holding-medical',
            label = Strings.player_item,
            description = Strings.player_item_desc
        },
        {
            icon = 'fas fa-box-open',
            label = Strings.player_openinv,
            description = Strings.player_openinv_desc
        }, 
        {
            icon = 'fas fa-boxes-packing',
            close = false,
            label = Strings.player_clearinv,
            description = Strings.player_clearinv_desc
        },
        {
            icon = 'fas fa-person-arrow-up-from-line',
            close = false,
            label = Strings.player_teleport_to,
            description = Strings.player_teleport_to_desc
        },
        {
            icon = 'fas fa-person-arrow-down-to-line',
            close = false,
            label = Strings.player_bring,
            description = Strings.player_bring_desc
        },
        {
            icon = 'fas fa-arrow-right-from-bracket',
            label = Strings.player_kick,
            description = Strings.player_kick_desc
        },
        {
            icon = 'fas fa-trash',
            label = Strings.player_ban,
            values = Config.Ban,
            defaultIndex = 0
        },
        { -- index 16
            icon = 'fas fa-money-bill-wave',
            label = Strings.player_removemoney,
            description = Strings.player_removemoney_desc
        },
        { -- index 17
            icon = 'fas fa-layer-group',
            label = Strings.player_dimension,
            description = Strings.player_dimension_desc
        },
        { -- index 18
            icon = 'fas fa-people-pulling',
            close = false,
            label = Strings.player_dimension_bring,
            description = Strings.player_dimension_bring_desc
        },
        { -- index 19
            icon = 'fas fa-right-to-bracket',
            close = false,
            label = Strings.player_dimension_goto,
            description = Strings.player_dimension_goto_desc
        },
        { -- index 20
            icon = 'fas fa-car-rear',
            close = false,
            label = Strings.player_tp_vehicle,
            description = Strings.player_tp_vehicle_desc
        },
        { -- index 21
            icon = 'fas fa-warehouse',
            label = Strings.player_owned_vehicles,
            description = Strings.player_owned_vehicles_desc
        },
        { -- index 22
            icon = 'fas fa-people-arrows',
            close = false,
            label = Strings.player_pedmenu,
            description = Strings.player_pedmenu_desc
        }
    }

    SendNUIMessage({
        action = 'openSubMenu',
        title = Strings.player_options:format(name),
        items = options,
        parent = Strings.player_options_menu:format(#GetPlayers(), ServerSlots)
    })
    
    -- Register NUI callback for this menu
    RegisterNUICallback('menuSelected', function(data, cb)
        if data.menu == Strings.player_options:format(name) then
            if data.index == 3 then
                SpectatePlayer(target)
            elseif data.index == 4 then
                openPlayerData(target)
            elseif data.index == 5 then
                TriggerServerEvent('apex_adminmenu:revive', target)
            elseif data.index == 6 then
                TriggerServerEvent('apex_adminmenu:heal', target)
            elseif data.index == 7 then
                TriggerServerEvent('apex_adminmenu:skinmenu', target)
            elseif data.index == 8 then
                givePlayerMoney(target, name)
            elseif data.index == 9 then
                givePlayerItem(target, name)
            elseif data.index == 10 then
                OpenPlyInv(target)
            elseif data.index == 11 then
                local Clear = lib.callback.await('apex_adminmenu:clearinv', 100, target)
                if Clear then
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_clearedinv,
                        (Strings.notify_clearedinv_desc:format(name)), 'success', 'fa-check')
                end
            elseif data.index == 12 then
                TriggerServerEvent('apex_adminmenu:playerteleport', target, 'tpto')
                TriggerEvent('apex_adminmenu:notify', Strings.teleport_success, Strings.teleport_success_desc, 'success')
            elseif data.index == 13 then
                TriggerServerEvent('apex_adminmenu:playerteleport', target, 'bring')
                TriggerEvent('apex_adminmenu:notify', Strings.teleport_success, Strings.teleport_success_desc, 'success')
            elseif data.index == 14 then
                kickPlayer(target, name)
            elseif data.index == 16 then -- Remove Money
                ApexRemovePlayerMoneyDialog(target, name)
            elseif data.index == 17 then -- Set Dimension
                ApexSetPlayerDimensionDialog(target, name)
            elseif data.index == 18 then -- Bring To My Dimension
                TriggerServerEvent('apex_adminmenu:dimensionAction', target, 'bring')
            elseif data.index == 19 then -- Join Player Dimension
                TriggerServerEvent('apex_adminmenu:dimensionAction', target, 'goto')
            elseif data.index == 20 then -- Teleport Into Vehicle
                ApexTeleportIntoVehicle(target, name)
            elseif data.index == 21 then -- Owned Vehicles
                ApexOpenOwnedVehicles(target, name)
            elseif data.index == 22 then -- Give Ped Menu
                ApexGivePedMenu(target)
            end
        end
        cb('ok')
    end)
end

-- Main player options menu
PlayerOptions = function()
    -- No timeout (false): always wait for the server's player list so it
    -- never comes back empty on a momentarily busy server. Guard against a
    -- nil response so the menu can't error out.
    local data = lib.callback.await('apex_adminmenu:players', false)
    if not data then data = { SentPlayers = {}, PlayerCount = 0 } end
    local SentPlayers, PlayerCount = data.SentPlayers or {}, data.PlayerCount or 0

    -- Create player list for UI
    local playerList = {}
    for i = 1, #SentPlayers do
        playerList[#playerList + 1] = {
            icon = 'fas fa-user',
            label = '['..SentPlayers[i].Id..']' .. ' ' .. SentPlayers[i].Name,
            description = 'ID: ' .. SentPlayers[i].Id,
            value = SentPlayers[i].Id,
            name = SentPlayers[i].Name
        }
    end
    
    SendNUIMessage({
        action = 'openSubMenu',
        title = Strings.player_options_menu:format(PlayerCount, ServerSlots),
        items = playerList,
        parent = 'main'
    })
    
    -- Register NUI callback for this menu
    RegisterNUICallback('menuSelected', function(data, cb)
        if data.menu == Strings.player_options_menu:format(PlayerCount, ServerSlots) then
            for i = 1, #playerList do
                if data.index == i - 1 then
                    plyOptionsMenu(playerList[i].value, playerList[i].label)
                    break
                end
            end
        end
        cb('ok')
    end)
end

-- Function to update toggle states for player options
RegisterNUICallback('toggleOption', function(data, cb)
    if data.menu:find(Strings.player_options) then
        if data.index == 1 then -- Freeze
            Freezed = data.checked
        elseif data.index == 2 then -- NoClip
            Noclip = data.checked
        end
    end
    cb('ok')
end)

-- Register event to handle player freeze from server
RegisterNetEvent('apex_adminmenu:setPlayerFrozen', function(playerId, state)
    -- Only apply freeze if this is the target player
    if GetPlayerServerId(PlayerId()) == playerId then
        FreezeEntityPosition(PlayerPedId(), state)
        if state then
            TriggerEvent('apex_adminmenu:notify', Strings.player_frozen, Strings.player_frozen_desc:format(GetPlayerName(PlayerId())), 'info')
        else
            TriggerEvent('apex_adminmenu:notify', Strings.player_unfrozen, Strings.player_unfrozen_desc:format(GetPlayerName(PlayerId())), 'info')
        end
    end
end)

-- Open another player's inventory. The actual force-open has to happen on
-- the server for every modern inventory (ox, qs, qb, origen, codem, …), so
-- we just ask for it — configs/compat.lua picks the provider and re-checks
-- our admin permission there.
OpenPlyInv = function(target)
    return Apex.Compat.OpenPlayerInventory(target)
end

-- Clean up spectate when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    if Spectating then
        StopSpectatePlayer(true, true)
    end
end)
