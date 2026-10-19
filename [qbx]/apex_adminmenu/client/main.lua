local isMenuOpen = false
local notificationCooldown = {}
local currentDialog = nil
-- Global (not local): playeroptions.lua's banPlayer() writes this and we
-- read it back in dialogResponse — they must share the same variable.
currentBanTime = nil

-- Movable-menu state (see Config.MovableMenu). moveMode = true means the
-- menu is visible but the player has full game control; false = cursor mode.
local moveMode = false
local moveModeThread = false
-- Forward declaration: AdminMenu() (below) starts the toggle watcher, but
-- the watcher itself is defined further down. Without this the reference
-- inside AdminMenu would compile to a nil global.
local startToggleWatch

-- Function to open the main admin menu
AdminMenu = function()
    if isMenuOpen then return end

    -- Not on top of the F6 panel. The quick menu lives in the page that
    -- hosts the panel's iframe: opened underneath it, it is invisible but
    -- takes the keyboard (typing in the panel stops working), and its
    -- close drops the NUI focus the panel was using.
    if IsPanelOpen and IsPanelOpen() then
        TriggerEvent('apex_adminmenu:notify', Strings.main_title or 'Admin Menu',
            'Close the Admin Panel (Esc) before opening the Quick Menu.', 'info')
        return
    end

    local menuItems = {
        {
            icon = 'fa-solid fa-person',
            label = Strings.self_options,
            description = Strings.self_options_desc
        },
        {
            icon = 'fa-solid fa-people-arrows',
            label = Strings.player_options_title,
            description = Strings.player_options_desc
        },
        {
            icon = 'fa-solid fa-car',
            label = Strings.vehicle_options,
            description = Strings.vehicle_options_desc
        },
        {
            icon = 'fa-solid fa-globe',
            label = Strings.server_options,
            description = Strings.server_options_desc
        },
        {
            icon = 'fa-solid fa-screwdriver-wrench',
            label = Strings.developer_options,
            description = Strings.developer_options_desc
        },
        {
            icon = 'fa-solid fa-headset',
            label = 'Reports Center',
            description = 'Manage reports, chat with players & screenshots'
        }
    }

    isMenuOpen = true
    moveMode   = false
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openMenu',
        items = menuItems
    })

    -- Tell the NUI whether the movable-menu hint should be shown, and with
    -- which key. Starts in cursor mode (or movement mode if configured).
    if Config.MovableMenu and Config.MovableMenu.enabled then
        SendNUIMessage({
            action = 'moveModeHint',
            mode = 'cursor',
            code = Config.MovableMenu.toggleKey or 'AltLeft',
            label = Config.MovableMenu.toggleKeyLabel or 'Alt'
        })
        -- Start the toggle watcher immediately, not only once the admin
        -- reaches movement mode — that is what makes the key respond from
        -- the very first frame, in the main menu and in every sub-menu.
        startToggleWatch()
        if Config.MovableMenu.startInCursorMode == false then
            SetAdminMenuMode('move')
        end
    end

    -- Log admin menu usage
    TriggerServerEvent('apex_adminmenu:logAdminActivity', 'opened')
end

-- Other modules need to know if the quick menu is currently open.
function IsAdminMenuOpen()
    return isMenuOpen
end

-- ============================================================
-- MOVABLE MENU — alternate between cursor mode and movement mode
-- ------------------------------------------------------------
-- Cursor mode   : SetNuiFocus(true,true) — interact with the menu.
-- Movement mode : SetNuiFocus(false,false) — walk/look freely, the
--                 menu stays visible. A watch thread reads the toggle
--                 key (and Esc) since the NUI no longer has focus.
-- ============================================================
-- ── Toggle-key reading ──────────────────────────────────────
-- The toggle has to fire in three situations the old code couldn't all
-- cover at once:
--   1. cursor mode, main menu       — NUI has focus, game controls dead
--   2. cursor mode, any SUB-menu    — same, and the NUI key handler was
--                                     the only path (easy to lose)
--   3. movement mode DURING NOCLIP  — noclip calls DisableAllControlActions
--                                     every frame, so control 19 never
--                                     reports a "just pressed" edge
-- IsRawKeyDown reads the physical key straight from the OS: it ignores
-- NUI focus and it ignores DisableAllControlActions, so one watcher
-- handles all three. We do our own edge detection rather than relying on
-- IsRawKeyPressed's semantics, and fall back to the old control-based
-- read on builds where the raw-key natives are missing.
local rawKeyWasDown = false

local function rawKeyDown(vk)
    if type(IsRawKeyDown) ~= 'function' then return nil end
    local ok, down = pcall(IsRawKeyDown, vk)
    if not ok then return nil end
    return down and true or false
end

-- Shared debounce: the NUI also posts `setMoveMode` when it sees the key,
-- so without this a single press could toggle twice.
local lastToggleAt = 0
local function toggleDebounced(mode)
    local now = GetGameTimer()
    if now - lastToggleAt < 250 then return end
    lastToggleAt = now
    SetAdminMenuMode(mode)
end
ApexToggleMenuModeDebounced = toggleDebounced

-- Single watcher, alive for as long as the menu is open — in ANY mode and
-- in ANY sub-menu.
function startToggleWatch()
    if moveModeThread then return end
    moveModeThread = true

    CreateThread(function()
        local cfg         = Config.MovableMenu or {}
        local toggle      = cfg.toggleControl or 19
        local vk          = cfg.rawToggleKey  or 0xA4 -- VK_LMENU (Left Alt)
        local blockCombat = not (cfg.blockCombat == false)

        -- Require one release before accepting a press, so the key still
        -- held from the previous switch doesn't bounce us straight back.
        local armed = false
        rawKeyWasDown = rawKeyDown(vk) or false

        while isMenuOpen do
            Wait(0)

            -- ── Controls we only touch in movement mode ──────────
            if moveMode then
                DisableControlAction(0, toggle, true)
                DisableControlAction(0, 200, true) -- ESC
                DisableControlAction(0, 322, true) -- ESC (alt)

                -- Avoid shooting / aiming by accident while the menu is
                -- visible. Skipped during noclip, where every control is
                -- already disabled and the ped can't shoot anyway.
                if blockCombat and not (IsNoClipping == true) then
                    DisableControlAction(0, 24, true)  -- attack
                    DisableControlAction(0, 25, true)  -- aim
                    DisableControlAction(0, 257, true) -- attack 2
                    DisableControlAction(0, 263, true) -- melee attack 1
                    DisableControlAction(0, 264, true) -- melee attack 2
                    DisableControlAction(0, 69, true)  -- vehicle attack
                    DisableControlAction(0, 70, true)  -- vehicle attack 2
                    DisableControlAction(0, 92, true)  -- vehicle passenger attack
                end

                if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 322) then
                    CloseAdminMenuFull()
                end
            end

            -- ── The toggle key itself ────────────────────────────
            -- Never steal the key while the admin is typing in a dialog.
            if currentDialog then
                armed = false
                rawKeyWasDown = rawKeyDown(vk) or false
                goto continue
            end

            local isDown = rawKeyDown(vk)

            if isDown == nil then
                -- No raw-key natives on this build. Control-based read
                -- still works in movement mode (cursor mode is covered by
                -- the NUI key handler in html/script.js).
                if moveMode then
                    if not IsDisabledControlPressed(0, toggle) then armed = true end
                    if armed and IsDisabledControlJustPressed(0, toggle) then
                        armed = false
                        toggleDebounced('cursor')
                    end
                end
            else
                if not isDown then armed = true end
                if armed and isDown and not rawKeyWasDown then
                    armed = false
                    toggleDebounced(moveMode and 'cursor' or 'move')
                end
                rawKeyWasDown = isDown
            end

            ::continue::
        end

        moveModeThread = false
    end)
end

function SetAdminMenuMode(mode)
    if not (Config.MovableMenu and Config.MovableMenu.enabled) then return end
    if not isMenuOpen then return end

    local label = (Config.MovableMenu.toggleKeyLabel) or 'Alt'
    local code  = (Config.MovableMenu.toggleKey) or 'AltLeft'

    if mode == 'move' then
        moveMode = true
        SetNuiFocus(false, false)
        SendNUIMessage({ action = 'moveModeHint', mode = 'move', code = code, label = label })
    else
        moveMode = false
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'moveModeHint', mode = 'cursor', code = code, label = label })
    end

    -- The watcher spans both modes now, so it is safe (and necessary) to
    -- (re)start it here as well as on open.
    startToggleWatch()
end

-- Fully close the menu (used by Esc while in movement mode, where the
-- NUI can't catch the keypress itself).
function CloseAdminMenuFull()
    isMenuOpen = false
    moveMode   = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeMenu' })
    SendNUIMessage({ action = 'moveModeHint', mode = 'off' })
    TriggerServerEvent('apex_adminmenu:logAdminActivity', 'closed')
end

-- NUI Callbacks
RegisterNUICallback('closeMenu', function(data, cb)
    isMenuOpen = false
    moveMode   = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'moveModeHint', mode = 'off' })

    -- Log admin menu usage
    TriggerServerEvent('apex_adminmenu:logAdminActivity', 'closed')
   -- TriggerEvent('apex_adminmenu:notify', Strings.admin_menu_closed, Strings.admin_menu_closed, 'info')
    cb('ok')
end)

-- Cursor-mode → movement-mode switch requested from the NUI (JS catches
-- the toggle key while it still has focus).
RegisterNUICallback('setMoveMode', function(data, cb)
    -- Fallback path for builds without the raw-key natives. Debounced,
    -- because the Lua watcher may well have caught the same press.
    ApexToggleMenuModeDebounced((data and data.enabled) and 'move' or 'cursor')
    cb('ok')
end)

RegisterNUICallback('toggleOption', function(data, cb)
    -- Handle toggle options based on menu and index
    if data.menu == Strings.self_options_menu then
        if data.index == 1 then -- NoClip
            ToggleNoClip(data.checked)
        elseif data.index == 2 then -- Invisible
            InvisibleMode(data.checked)
        elseif data.index == 3 then -- GodMode
            GodModeMode(data.checked)
        elseif data.index == 4 then -- Wallhack
            WallhackMode(data.checked)
        elseif data.index == 9 then -- Staff Tag
            StaffTagMode(data.checked)
        end
    -- The player-options sub-menu titles are formatted strings such as
    -- "Player: <name>", so we can't compare with `==`. We need a literal
    -- prefix check — Lua's :find with patterns trips on the `%s` in
    -- Strings.player_options ("Player: %s"), so we strip the placeholder
    -- and use a plain-text search instead.
    elseif data.menu and data.menu:find((Strings.player_options:gsub('%%s', '')), 1, true) then
        local target = GetSelectedPlayer()
        if data.index == 1 then -- Freeze
            TriggerServerEvent('apex_adminmenu:freezePlayer', target, data.checked)
        elseif data.index == 2 then -- NoClip
            lib.callback.await('apex_adminmenu:noclip', 100, target, data.checked)
        end
    elseif data.menu == Strings.developer_options then
        if data.index == 0 then -- Debug Mode
            toggleDebugMode(data.checked)
        end
    end
    cb('ok')
end)

RegisterNUICallback('valueSelected', function(data, cb)
    -- Handle value selection based on menu, option index and value index
    if data.menu == Strings.vehicle_menu then
        if data.optionIndex == 6 then -- Door status
            DoorStatus(data.valueIndex + 1)
        elseif data.optionIndex == 7 then -- Torque
            local torqueValue = Config.TorqueMultiplier[data.valueIndex + 1].value
            SetTorque(torqueValue)
        elseif data.optionIndex == 8 then -- Vehicle color
            local colorValue = Config.VehicleColors[data.valueIndex + 1].value
            ChangeVehColor(colorValue)
        end
    elseif data.menu == Strings.server_management then
        if data.optionIndex == 3 then -- Weather
            local weatherValue = Config.Weathers[data.valueIndex + 1].value
            TriggerServerEvent('apex_adminmenu:weathersync', weatherValue)
        end
    elseif data.menu == Strings.self_options_menu then
        if data.optionIndex == 8 then -- Set Ped
            local pedValue = Peds[data.valueIndex + 1].value
            SetPed(pedValue)
        end
    elseif data.menu and data.menu:find((Strings.player_options:gsub('%%s', '')), 1, true) then
        if data.optionIndex == 15 then -- Ban player (item index 15 in plyOptionsMenu)
            local selectedPlayer = GetSelectedPlayer()
            local playerName = GetSelectedPlayerName()
            local banValue = Config.Ban[data.valueIndex + 1].value
            banPlayer(selectedPlayer, banValue, playerName)
        end
    end
    cb('ok')
end)

RegisterNUICallback('menuSelected', function(data, cb)
    if data.menu == 'main' then
        if data.index == 0 then
            SelfOptions()
        elseif data.index == 1 then
            PlayerOptions()
        elseif data.index == 2 then
            VehicleOptions()
        elseif data.index == 3 then
            ServerOptions()
        elseif data.index == 4 then
            DeveloperOptions()
        elseif data.index == 5 then
            -- Reports Center handled by client/reports.lua.
            isMenuOpen = false
            SetNuiFocus(false, false)
            SendNUIMessage({ action = 'closeMenu' })
            CreateThread(function()
                Wait(50)
                if OpenReportsCenter then OpenReportsCenter() end
            end)
        end
    end
    cb('ok')
end)

RegisterNUICallback('dialogResponse', function(data, cb)
    if data.response then
        if currentDialog == 'givePlayerMoney' then
            local target = GetSelectedPlayer()
            local name = GetSelectedPlayerName()
            local amount = tonumber(data.values[1])
            local account = data.values[2]
            
            if amount and account then
                local success = lib.callback.await('apex_adminmenu:giveMoney', 100, target, account, amount)
                if success then
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_givemoney_success, (Strings.notify_givemoney_success_desc):format(name, amount, account), 'success', 'fa-check')
                    TriggerServerEvent('apex_adminmenu:logMoneyAction', target, account, amount)
                else
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_givemoney_fail, (Strings.notify_givemoney_fail_desc):format(name), 'error', 'fa-xmark')
                end
            end
        elseif currentDialog == 'givePlayerItem' then
            local target = GetSelectedPlayer()
            local name = GetSelectedPlayerName()
            local item = data.values[1]
            local amount = tonumber(data.values[2])
            
            if item and amount then
                local success = lib.callback.await('apex_adminmenu:giveitem', 100, target, item, amount)
                if success == 'success' then
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_giveitem_success, (Strings.notify_giveitem_success_desc):format(name, item, amount), 'success', 'fa-check')
                    TriggerServerEvent('apex_adminmenu:logItemAction', target, item, amount)
                else
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_giveitem_fail, (Strings.notify_giveitem_fail_desc):format(name), 'error', 'fa-xmark')
                end
            end
        elseif currentDialog == 'kickPlayer' then
            local target = GetSelectedPlayer()
            local name = GetSelectedPlayerName()
            local reason = data.values[1] or Strings.kicked_reason_replace
            
            local success = lib.callback.await('apex_adminmenu:dropPlayer', 100, target, reason)
            if success then
                TriggerEvent('apex_adminmenu:notify', Strings.notify_kicked_success, (Strings.notify_kicked_success_desc):format(name), 'success', 'fa-check')
                TriggerServerEvent('apex_adminmenu:logPlayerAction', target, 'kick', reason)
            end
        elseif currentDialog == 'banPlayer' then
            local target = GetSelectedPlayer()
            local name = GetSelectedPlayerName()
            local reason = data.values[1] or Strings.ban_reason_replace
            
            local success = lib.callback.await('apex_adminmenu:banPlayer', 100, target, currentBanTime, reason)
            if success then
                TriggerEvent('apex_adminmenu:notify', Strings.notify_banned_success, (Strings.notify_banned_success_desc):format(name), 'success', 'fa-check')
                TriggerServerEvent('apex_adminmenu:logPlayerAction', target, 'ban', reason, currentBanTime)
            end
        elseif currentDialog == 'announcement' then
            local message = data.values[1]
            local job = data.values[2]
            
            if message and message ~= '' then
                TriggerServerEvent('apex_adminmenu:announcement', message, job)
                TriggerServerEvent('apex_adminmenu:logUtilityAction', 'announcement', message, job)
            end
        elseif currentDialog == 'entityDelete' then
            local option = data.values[1]
            
            if option == 'objects' then
                delObjects()
                TriggerServerEvent('apex_adminmenu:logUtilityAction', 'deleteEntities', 'objects')
            elseif option == 'cars' then
                delCars()
                TriggerServerEvent('apex_adminmenu:logUtilityAction', 'deleteEntities', 'vehicles')
            elseif option == 'peds' then
                delPeds()
                TriggerServerEvent('apex_adminmenu:logUtilityAction', 'deleteEntities', 'peds')
            end
        elseif currentDialog == 'changePlate' then
            local plate = data.values[1]
            ChangePlateText(plate)
            TriggerServerEvent('apex_adminmenu:logVehicleAction', 'changePlate', plate)
        elseif currentDialog == 'customVehicle' then
            local model = data.values[1]
            local plate = data.values[2]
            local color = data.values[3]
            local maxed = data.values[4]

            DirectSpawnVehicle(model, plate, color, color, maxed)
            TriggerServerEvent('apex_adminmenu:logVehicleAction', 'spawnVehicle', model, plate, maxed)
        elseif currentDialog == 'removePlayerMoney' then
            local target = GetSelectedPlayer()
            local name = GetSelectedPlayerName()
            local amount = tonumber(data.values[1])
            local account = data.values[2]

            if amount and account then
                local removed = lib.callback.await('apex_adminmenu:removeMoney', false, target, account, amount)
                if removed and removed ~= false then
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_removemoney_success,
                        (Strings.notify_removemoney_success_desc):format(removed, name, account), 'success', 'fa-check')
                else
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_removemoney_fail,
                        (Strings.notify_removemoney_fail_desc):format(name), 'error', 'fa-xmark')
                end
            end
        elseif currentDialog == 'setSelfDimension' then
            local bucket = tonumber(data.values[1]) or 0
            TriggerServerEvent('apex_adminmenu:setSelfDimension', bucket)
        elseif currentDialog == 'setPlayerDimension' then
            local target = GetSelectedPlayer()
            local bucket = tonumber(data.values[1]) or 0
            TriggerServerEvent('apex_adminmenu:setPlayerDimension', target, bucket)
        elseif currentDialog == 'addOwnedVehicle' then
            local target = GetSelectedPlayer()
            local name = GetSelectedPlayerName()
            local model = data.values[1]
            local plate = data.values[2]

            if model and model ~= '' then
                local res = lib.callback.await('apex_adminmenu:addOwnedVehicle', false, target, model, plate)
                if res then
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_owned_added,
                        (Strings.notify_owned_added_desc):format(res.model or model, res.plate or '', name), 'success', 'fa-check')
                else
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_owned_fail, Strings.notify_owned_fail_desc, 'error', 'fa-xmark')
                end
            end
        elseif currentDialog == 'removeOwnedVehicle' then
            local target = GetSelectedPlayer()
            local name = GetSelectedPlayerName()
            local plate = ApexPendingPlate
            ApexPendingPlate = nil

            if plate then
                local ok = lib.callback.await('apex_adminmenu:removeOwnedVehicle', false, target, plate)
                if ok then
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_owned_removed,
                        (Strings.notify_owned_removed_desc):format(plate, name), 'success', 'fa-check')
                else
                    TriggerEvent('apex_adminmenu:notify', Strings.notify_owned_fail, Strings.notify_owned_fail_desc, 'error', 'fa-xmark')
                end
            end
        end
    end

    currentDialog = nil
    cb('ok')
end)

-- Helper functions for NUI
function ShowTextUI(text, icon)
    TriggerEvent('apex_adminmenu:notify', "Admin Menu", text, 'success')
end

function HideTextUI()
    -- Empty function as we're using notifications instead
end

-- Store selected player for dialog callbacks
local selectedPlayer = nil
local selectedPlayerName = nil

function SetSelectedPlayer(id, name)
    selectedPlayer = id
    selectedPlayerName = name
end

function GetSelectedPlayer()
    return selectedPlayer
end

function GetSelectedPlayerName()
    return selectedPlayerName
end

-- Dialog helpers
function ShowDialog(title, content, callback)
    currentDialog = callback
    SendNUIMessage({
        action = 'showDialog',
        title = title,
        content = content,
        callback = callback
    })
end

function ShowInputDialog(title, inputs, callback)
    currentDialog = callback
    SendNUIMessage({
        action = 'showInputDialog',
        title = title,
        inputs = inputs,
        callback = callback
    })
end

-- Internal: other client modules use this to forcibly clear the
-- "menu is open" flag (e.g. Object Remover taking over input).
AddEventHandler('apex_adminmenu:internal:closeMenu', function()
    isMenuOpen = false
end)

-- Event handlers
RegisterNetEvent('apex_adminmenu:searchInventory', function(target)
    if GetInvokingResource() ~= GetCurrentResourceName() then return end
    OpenPlyInv(target)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if isMenuOpen then
        SetNuiFocus(false, false)
    end
end)

AddEventHandler('apex_adminmenu:playerLoaded', function()
   TriggerServerEvent('apex_adminmenu:reqsync')
end)

-- Actually put a notification on screen.
--
-- This handler used to end in a bare `TriggerEvent('apex:notify', ...)`.
-- Nothing registers `apex:notify` — not this resource, not any other
-- resource on the server (whole-tree scan). So every notify call site in
-- apex_adminmenu was a silent no-op: 133 live ones across 18 files. That
-- is the whole reason "Warn" wrote its database row and the target saw
-- nothing, and why the jail notice never appeared either.
--
-- ox_lib is a hard dependency (fxmanifest loads @ox_lib/init.lua), so
-- lib.notify is always there, and it is the only sink that carries all
-- four fields the call sites already pass. The framework bridges'
-- ShowNotification / Notify sit behind it as fallbacks — they were written
-- for exactly this and, until now, had no callers anywhere.
--
-- Config.NotifyEvent lets a server route these into its own notification
-- resource, which is what that dead `apex:notify` hop was reaching for.
--
-- NOTE: this lives OUTSIDE the handler on purpose. The handler's third
-- parameter is named `type`, which shadows Lua's global `type()` for the
-- whole of its body — `type(hook)` in there would call a string.
local OX_NOTIFY_TYPES = {
    info = 'inform', inform = 'inform',
    success = 'success', error = 'error', warning = 'warning'
}

local function renderNotification(title, message, ntype, icon)
    local hook = Config and Config.NotifyEvent
    if type(hook) == 'string' and hook ~= '' then
        TriggerEvent(hook, title, message, 3000, ntype)
        return
    end

    if lib and lib.notify then
        lib.notify({
            title       = title,
            description = message,
            type        = OX_NOTIFY_TYPES[ntype] or 'inform',
            icon        = icon,
            duration    = 3000
        })
        return
    end

    -- Bridge fallbacks take a single string, so fold the title in.
    local line = (title and title ~= '') and (title .. ': ' .. (message or '')) or (message or '')
    if ShowNotification then ShowNotification(line, ntype) return end
    if Notify then Notify(line, ntype) return end
    TriggerEvent('chat:addMessage', { args = { title or 'Admin', message or '' } })
end

-- Prevent duplicate notifications
RegisterNetEvent('apex_adminmenu:notify', function(title, message, type, icon)
    -- Create a unique key for this notification.
    -- Concatenating raw arguments threw on any call site that omitted a
    -- title or a message, which killed the notification before it started.
    title, message = tostring(title or ''), tostring(message or '')
    local notificationKey = title .. message
    
    -- Check if this notification is on cooldown
    if notificationCooldown[notificationKey] then
        return
    end
    
    -- Set cooldown for this notification
    notificationCooldown[notificationKey] = true
    
    -- Clear cooldown after 500ms
    Citizen.SetTimeout(500, function()
        notificationCooldown[notificationKey] = nil
    end)

    -- With the F6 panel open, ox_lib's toast (a second NUI) is drawn
    -- underneath the focused panel: every "You do not have permission"
    -- the server sent to a panel action was invisible, so the action just
    -- looked dead. Route it into the panel's own toast instead.
    if IsPanelOpen and IsPanelOpen() then
        local kind = (type == 'success' or type == 'warning' or type == 'error') and type or 'info'
        local line = (title ~= '' and message ~= '') and (title .. ': ' .. message) or (title .. message)
        SendNUIMessage({ action = 'panel:toast', kind = kind, message = line, duration = 6000 })
        return
    end

    renderNotification(title, message, type, icon)
end)

-- Commands
-- Name and aliases come from Config.Commands.AdminMenu, same as the
-- Admin Panel command in client/adminpanel.lua.
local QuickCmd     = (Config.Commands and Config.Commands.AdminMenu) or {}
local quickCommand = QuickCmd.command or 'adminmenu'

local function openQuickMenu()
    -- `false` = no throttle. This used to pass 100, which ox_lib reads
    -- as "refuse to fire again within 100 ms" (NOT a timeout) and then
    -- returns nil — indistinguishable from "no permission" on the line
    -- below, so a quick second press silently did nothing.
    local hasPerms, why = lib.callback.await('apex_adminmenu:checkPerms', false, 'QuickMenu')
    if not hasPerms then
        -- Staff, but this menu is closed to them (Config.MenuAccess): say
        -- so, because a key press that does nothing reads as "broken".
        if why == 'menu' then
            TriggerEvent('apex_adminmenu:notify', Strings.main_title or 'Admin Menu',
                Strings.menu_no_access or 'You do not have access to this menu.', 'error')
        end
        return
    end

    AdminMenu()
end

if QuickCmd.enabled ~= false then
    local names = { quickCommand }

    RegisterCommand(quickCommand, openQuickMenu, false)
    TriggerEvent('chat:removeSuggestion', '/' .. quickCommand)

    for _, alias in ipairs(QuickCmd.aliases or {}) do
        if type(alias) == 'string' and alias ~= '' and alias ~= quickCommand then
            RegisterCommand(alias, openQuickMenu, false)
            TriggerEvent('chat:removeSuggestion', '/' .. alias)
            names[#names + 1] = alias
        end
    end

    -- The keybind drives the configured command name, so renaming the
    -- command above keeps Config.OpenKey working.
    RegisterKeyMapping(quickCommand, Strings.keymapping_desc, 'keyboard', Config.OpenKey)

    print(('^5[apex_adminmenu]^7 Quick Menu commands: /%s  (%s)')
        :format(table.concat(names, ', /'), Config.OpenKey or 'F9'))
end

-- ── The configurable commands, resolved on the client ──────
-- /ban /kick /noclip /searchinv /clearinv /skinmenu did their work on the
-- server and were REGISTERED there only, which is the one place a command
-- name is shared with every other resource: ESX Legacy has its own /noclip,
-- qb-adminmenu its own /kick and /ban, and whichever resource the server
-- happened to load in the right order answered.
--
-- A command registered here is resolved by the client BEFORE anything is
-- forwarded to the server (the same reason an alias in Config.Commands wins
-- over another menu's /admin), so each enabled one is registered on the
-- client too and simply hands the words to the server. Nothing is decided
-- here: the permission check is in the server handler, where it always was.
--
-- `enabled = false` in Config.Commands registers nothing on either side,
-- which is how you hand a name back to the framework or to another resource.
do
    local FORWARDED = { 'Ban', 'Kick', 'NoClip', 'SearchInv', 'ClearInv', 'SkinMenu' }
    local names = {}
    for _, key in ipairs(FORWARDED) do
        local def = Config.Commands and Config.Commands[key]
        if type(def) == 'table' and def.enabled and type(def.command) == 'string' and def.command ~= '' then
            RegisterCommand(def.command, function(_, args)
                TriggerServerEvent('apex_adminmenu:command', key, args)
            end, false)
            names[#names + 1] = def.command
        end
    end
    if #names > 0 then
        print(('^5[apex_adminmenu]^7 Staff commands: /%s'):format(table.concat(names, ', /')))
    end
end
