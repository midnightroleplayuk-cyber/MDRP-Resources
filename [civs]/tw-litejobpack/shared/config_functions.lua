Config = Config or {}

if IsDuplicityVersion and not IsDuplicityVersion() then
    -- ── Notification ────────────────────────────────────────────────

    function Config.sendNotification(data)
        if not data then return end

        local text = data.text or data
        local notifType = data.type or "info"
        local duration = data.duration or 5000
        local system = Config.Notification or "default"

        -- Header/title: per-call override > current job's display name > fallback.
        -- getCurrentJobId is a client global (this dispatcher is client-only via
        -- the IsDuplicityVersion guard), so "NEWSPAPER DELIVERY" etc. shows per job.
        local title = data.title
        if not title then
            local jid = getCurrentJobId and getCurrentJobId()
            title = (jid and _('jobs.' .. jid .. '.name')) or 'Job Pack'
        end

        if system == "custom" then
            if Config.CustomNotification then
                Config.CustomNotification(text, notifType, duration)
            end
            return
        end

        if system == "default" then
            SendNUIMessage({
                action = "SHOW_NOTIFICATION",
                payload = {
                    text = text,
                    type = notifType,
                    duration = duration,
                    tag = data.tag or nil
                }
            })
            return
        end

        if system == "qb" then
            if QBCore and QBCore.Functions then
                QBCore.Functions.Notify(text, notifType)
            end
            return
        end

        if system == "esx" then
            if ESX then
                ESX.ShowNotification(text)
            end
            return
        end

        if system == "ox_lib" then
            lib.notify({ title = title, description = text, type = notifType, position = 'top-right' })
            return
        end
    end

    -- ── Action Progress ─────────────────────────────────────────────

    local actionProgressActive = false

    local function _defaultActionProgress(duration, label, options)
        options = options or {}
        local cancelKey = options.cancelKey or 194
        local cancelLabel = options.cancelLabel or "X"

        actionProgressActive = true

        SendNUIMessage({
            action = "SHOW_ACTION_PROGRESS",
            payload = {
                duration = duration,
                label = label,
                cancelLabel = cancelLabel,
            }
        })

        local elapsed = 0.0
        local cancelled = false

        while elapsed < duration do
            local dt = GetFrameTime() * 1000
            elapsed = elapsed + dt

            DisableControlAction(0, cancelKey, true)
            if IsDisabledControlJustPressed(0, cancelKey) then
                cancelled = true
                break
            end

            Wait(0)
        end

        SendNUIMessage({ action = "HIDE_ACTION_PROGRESS" })
        actionProgressActive = false

        if cancelled and options.onCancel then
            options.onCancel()
        end

        return not cancelled
    end

    local function _qbProgressBar(duration, label, options)
        actionProgressActive = true
        local prom = promise.new()

        QBCore.Functions.Progressbar("jobpack_action", label, duration, false, true,
            { disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = true },
            {}, {}, {},
            function() prom:resolve(true) end,
            function() prom:resolve(false) end
        )

        local result = Citizen.Await(prom)
        actionProgressActive = false
        return result
    end

    local function _oxLibProgress(duration, label, options)
        actionProgressActive = true
        local params = { duration = duration, label = label, canCancel = true }
        if options then
            for k, v in pairs(options) do
                if params[k] == nil then
                    params[k] = v
                end
            end
        end
        local result = lib.progressBar(params)
        actionProgressActive = false
        return result
    end

    function Config.ActionProgress(duration, label, options)
        if actionProgressActive then
            Wait(duration)
            return true
        end

        local system = Config.ProgressBar or "default"

        if system == "custom" then
            actionProgressActive = true
            local result = true
            if Config.CustomActionProgress then
                result = Config.CustomActionProgress(duration, label, options)
            end
            actionProgressActive = false
            return result
        elseif system == "qb-progressbar" then
            return _qbProgressBar(duration, label, options)
        elseif system == "ox_lib" then
            return _oxLibProgress(duration, label, options)
        else
            return _defaultActionProgress(duration, label, options)
        end
    end

    function Config.IsActionProgressActive()
        return actionProgressActive
    end

    -- ── Draw Text ───────────────────────────────────────────────────
    -- Flicker-safe implementation:
    --  * SHOW is payload-deduplicated (no NUI / library spam on Wait(0) loops).
    --  * HIDE is deferred ~120ms via a sequence token. If DrawText is called
    --    again within that window the pending hide is cancelled, which
    --    absorbs frame-boundary oscillation (e.g. distance == threshold).

    local HIDE_DEBOUNCE_MS = 120

    local isDrawTextShowing = false
    local currentText = nil
    local currentKey = nil
    local hideSeq = 0
    local hidePending = false

    local function doImmediateHide(system)
        if system == "custom" then
            if Config.CustomHideText then
                Config.CustomHideText()
            end
            return
        end
        if system == "default" then
            SendNUIMessage({ action = "HIDE_DRAWTEXT" })
            return
        end
        if system == "ox_lib" then
            lib.hideTextUI()
            return
        end
        if system == "qb" then
            if QBCore and QBCore.Functions and QBCore.Functions.HideText then
                QBCore.Functions.HideText()
            end
            return
        end
    end

    function Config.DrawText(text, position)
        position = position or 'right-center'
        local system = Config.DrawTextUI or "default"

        -- A new show cancels any pending deferred hide.
        hideSeq = hideSeq + 1

        local cleanText = text
        local key = nil
        if type(text) == "string" and not string.find(text, "|") then
            local k, rest = string.match(text, "^%[(%w+)%]%s*(.+)$")
            if k then
                key = k
                cleanText = rest
            elseif not string.find(text, "^%[") then
                -- No bracket prefix at all → default to `E` badge.
                -- Preserves existing `[Hold LMB]` / `[Shift + E]` style text
                -- verbatim (they start with `[` but aren't single-word keys).
                key = "E"
            end
        end

        -- Dedup: same content already on screen → no-op.
        if isDrawTextShowing and currentText == cleanText and currentKey == key then
            return
        end

        isDrawTextShowing = true
        currentText = cleanText
        currentKey = key

        if system == "custom" then
            if Config.CustomDrawText then
                Config.CustomDrawText(text, position)
            end
            return
        end

        if system == "default" then
            SendNUIMessage({
                action = "SHOW_DRAWTEXT",
                payload = { text = cleanText, key = key }
            })
            return
        end

        if system == "ox_lib" then
            lib.showTextUI(text, { position = position })
            return
        end

        if system == "qb" then
            if QBCore and QBCore.Functions and QBCore.Functions.DrawText then
                QBCore.Functions.DrawText(text, 'right')
            end
            return
        end

        if system == "esx" then
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName(text)
            EndTextCommandDisplayHelp(0, false, true, -1)
            return
        end
    end

    function Config.HideText()
        if not isDrawTextShowing then return end
        -- Already a deferred hide in flight → don't reschedule. Successive
        -- HideText calls from tight loops (e.g. NPC sweep calling HideText
        -- every 100ms) would otherwise keep rolling the debounce window
        -- forward and the hide would never commit.
        if hidePending then return end

        hidePending = true
        local mySeq = hideSeq
        local system = Config.DrawTextUI or "default"

        CreateThread(function()
            Wait(HIDE_DEBOUNCE_MS)
            hidePending = false
            -- A DrawText arrived within the debounce window → bumped hideSeq;
            -- cancel this hide so the new text stays visible.
            if mySeq ~= hideSeq then return end
            if not isDrawTextShowing then return end
            isDrawTextShowing = false
            currentText = nil
            currentKey = nil
            doImmediateHide(system)
        end)
    end

    exports('ShowDrawText', function(text) Config.DrawText(text) end)
    exports('HideDrawText', function() Config.HideText() end)
    exports('GetLocale', function(key, params) return _(key, params) end)

    -- ── Open Trigger ────────────────────────────────────────────────

    function Config.OpenTrigger(enable)
        if enable then
            RegisterCommand('openjobmenu', function()
                if openJobMenu then
                    openJobMenu()
                end
            end, false)

            RegisterKeyMapping('openjobmenu', 'Open Job Menu', 'keyboard', 'F5')
        end
    end

    -- ── List Menu ───────────────────────────────────────────────────

    local _listMenuPromise = nil

    local function _defaultOpenListMenu(title, options)
        if _listMenuPromise then
            _listMenuPromise:resolve(nil)
            _listMenuPromise = nil
        end

        local prom = promise.new()
        _listMenuPromise = prom

        SendNUIMessage({
            action = "SHOW_LIST_MENU",
            payload = {
                title = title,
                options = options,
            }
        })
        SetNuiFocus(true, true)

        local result = Citizen.Await(prom)
        return result
    end

    local function _oxLibOpenListMenu(title, options)
        local prom = promise.new()
        local contextOptions = {}

        for i, opt in ipairs(options) do
            contextOptions[#contextOptions + 1] = {
                title = opt.title or ("Option " .. i),
                description = opt.description or nil,
                icon = opt.icon or nil,
                disabled = opt.disabled or false,
                onSelect = function()
                    prom:resolve(i)
                end,
            }
        end

        lib.registerContext({
            id = 'tw_jobpack_list',
            title = title or 'Select',
            canClose = true,
            onExit = function()
                prom:resolve(nil)
            end,
            options = contextOptions,
        })

        lib.showContext('tw_jobpack_list')

        local result = Citizen.Await(prom)
        return result
    end

    function Config.OpenListMenu(title, options)
        local system = Config.ListMenu or "default"

        if system == "custom" then
            if Config.CustomOpenListMenu then
                return Config.CustomOpenListMenu(title, options)
            end
            return nil
        elseif system == "ox_lib" then
            return _oxLibOpenListMenu(title, options)
        else
            return _defaultOpenListMenu(title, options)
        end
    end

    function Config.CloseListMenu()
        local system = Config.ListMenu or "default"

        if system == "custom" then
            if Config.CustomCloseListMenu then
                Config.CustomCloseListMenu()
            end
            return
        end

        if system == "ox_lib" then
            lib.hideContext(false)
        else
            SendNUIMessage({ action = "HIDE_LIST_MENU" })
            SetNuiFocus(false, false)
        end

        if _listMenuPromise then
            _listMenuPromise:resolve(nil)
            _listMenuPromise = nil
        end
    end

    RegisterNUICallback('listMenuResult', function(data, cb)
        cb('ok')
        SetNuiFocus(false, false)
        if _listMenuPromise then
            local index = data.index
            if index == -1 then
                _listMenuPromise:resolve(nil)
            else
                _listMenuPromise:resolve(index + 1)
            end
            _listMenuPromise = nil
        end
    end)

    -- ── Input Number ────────────────────────────────────────────────

    local _inputNumberPromise = nil

    function Config.InputNumber(title, default, min, max)
        if _inputNumberPromise then
            _inputNumberPromise:resolve(nil)
            _inputNumberPromise = nil
        end

        local prom = promise.new()
        _inputNumberPromise = prom

        SendNUIMessage({
            action = "SHOW_INPUT_NUMBER",
            payload = {
                title = title or "Amount",
                default = default or 1,
                min = min or 1,
                max = max or 99,
            }
        })
        SetNuiFocus(true, true)

        local result = Citizen.Await(prom)
        return result
    end

    RegisterNUICallback('inputNumberResult', function(data, cb)
        cb('ok')
        SetNuiFocus(false, false)
        if _inputNumberPromise then
            local value = data.value
            if value == -1 then
                _inputNumberPromise:resolve(nil)
            else
                _inputNumberPromise:resolve(value)
            end
            _inputNumberPromise = nil
        end
    end)

    -- ── Vehicle Spawn Hooks ─────────────────────────────────────────
    -- Called immediately after a job vehicle is created on the client.
    -- Use this to integrate anticheat whitelisting, fuel systems, key systems, etc.
    --
    -- Parameters:
    --   entity    (number) – the local vehicle entity handle
    --   model     (string) – the vehicle model name (e.g. "boxville")
    --   netId     (number) – the network ID of the vehicle
    --   jobName   (string) – the job id (e.g. "trucker", "newspaper")
    --
    -- Example (eqpg-pro / snt-vehicles):
    --   Config.OnClientVehicleSpawned = function(entity, model, netId, jobName)
    --       SetVehicleFuelLevel(entity, 100.0)
    --       Entity(entity).state:set("unlocked", true, false)
    --   end

    Config.OnClientVehicleSpawned = nil

    -- ── Object Spawn Hook (client) ──────────────────────────────────
    -- Called after JobSpawn.Object creates a client-side prop/object.
    -- Useful for anti-cheat whitelists that auto-delete unregistered entities.
    --
    -- Parameters:
    --   entity     (number) – the local object entity handle
    --   modelHash  (number) – the object model hash
    --   netId      (number|nil) – network ID if the object is networked, else nil
    --   jobName    (string) – the job id

    Config.OnClientObjectSpawned = nil

    -- ── Ped Spawn Hook (client) ─────────────────────────────────────
    -- Called after JobSpawn.Ped creates a client-side ped/animal.
    --
    -- Parameters:
    --   entity     (number) – the local ped entity handle
    --   modelHash  (number) – the ped model hash
    --   netId      (number|nil) – network ID if the ped is networked, else nil
    --   jobName    (string) – the job id

    Config.OnClientPedSpawned = nil

    -- ── Weapon Give Hook (client) ───────────────────────────────────
    -- Replaces native GiveWeaponToPed at job weapon sites.
    -- Return true to indicate the hook handled the give; return false/nil to
    -- fall back to the default native behaviour.
    --
    -- Parameters:
    --   ped         (number) – the target ped
    --   weaponHash  (number) – the weapon hash
    --   ammo        (number) – ammo count
    --   isHidden    (boolean) – match native arg
    --   bForceInHand(boolean) – match native arg
    --
    -- Example (eqpg-pro custom inventory):
    --   Config.GiveJobWeapon = function(ped, weaponHash, ammo, isHidden, bForceInHand)
    --       exports['eqpg-pro']:EQPGWeapon(ped, weaponHash, ammo or 0, isHidden, bForceInHand)
    --       return true
    --   end

    Config.GiveJobWeapon = nil

    -- ── Weapon Remove Hook (client) ─────────────────────────────────
    -- Counterpart to GiveJobWeapon. Return true if handled.
    --
    -- Parameters:
    --   ped         (number)
    --   weaponHash  (number)

    Config.RemoveJobWeapon = nil

    -- ── Debug flag ──────────────────────────────────────────────────
    -- When true, JobSpawn helpers emit a post-spawn existence check so you
    -- can see in the client console which entities were deleted by an
    -- anti-cheat or third-party resource.

    Config.DebugEntitySpawns = false

else
    -- ── Server-Side Vehicle Spawn Hook ──────────────────────────────
    -- Called immediately after a job vehicle is created on the server.
    -- Use this to integrate anticheat whitelisting, statebags, trackers, etc.
    --
    -- Parameters:
    --   entity     (number) – the server-side vehicle entity handle
    --   owner      (number) – the server ID of the player who owns the vehicle
    --   modelHash  (number) – the vehicle model hash (GetHashKey result)
    --   plate      (string) – the vehicle's license plate text
    --   jobName    (string) – the job id (e.g. "trucker")
    --
    -- Example (eqpg-pro anticheat):
    --   Config.OnServerVehicleSpawned = function(entity, owner, modelHash, plate, jobName)
    --       exports["eqpg-pro"]:setSpawnClient(owner, modelHash)
    --       Entity(entity).state:set("Lockpick", true, true)
    --   end

    Config.OnServerVehicleSpawned = nil

    -- ── Object Spawn Hook (server) ──────────────────────────────────
    -- Called after a server-side JobSpawn.Object creates a networked prop.
    --
    -- Parameters:
    --   entity     (number) – the server-side object entity handle
    --   owner      (number|nil) – the player source that requested the spawn
    --   modelHash  (number) – the object model hash
    --   jobName    (string) – the job id

    Config.OnServerObjectSpawned = nil

    -- ── Ped Spawn Hook (server) ─────────────────────────────────────
    -- Called after a server-side JobSpawn.Ped creates a networked ped.
    --
    -- Parameters:
    --   entity     (number) – the server-side ped entity handle
    --   owner      (number|nil) – the player source that requested the spawn
    --   modelHash  (number) – the ped model hash
    --   jobName    (string) – the job id

    Config.OnServerPedSpawned = nil

    -- ── Debug flag ──────────────────────────────────────────────────
    Config.DebugEntitySpawns = false
end
