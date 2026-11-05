if not Config.Modules.safehouses then return end

local cfg = Config.Safehouses
local houses = {}   -- from GlobalState.vg_safehouses
local current       -- the safehouse we're inside: { id, spawn, stash, exit, label }
local busy = false
local prompt

local BREACH_ANIM = { dict = 'mini@repair', clip = 'fixing_a_ped' }

local function notify(key, kind, ...)
    lib.notify({ description = locale(key, ...), type = kind or 'inform' })
end

local function v3(p) return vector3(p.x, p.y, p.z) end

local function setPrompt(key)
    if key == prompt then return end
    if prompt then lib.hideTextUI() end
    if key then lib.showTextUI(locale(key)) end
    prompt = key
end

local function teleport(p)
    DoScreenFadeOut(400)
    while not IsScreenFadedOut() do Wait(10) end
    SetEntityCoords(cache.ped, p.x, p.y, p.z - 0.95, false, false, false, false)
    if p.w then SetEntityHeading(cache.ped, p.w) end
    Wait(500)
    DoScreenFadeIn(400)
end

-------------------------------------------------------------------------------
-- Shells (only this player's game spawns them, inside the safehouse's own instance)
-------------------------------------------------------------------------------

local shellObject

---Spawns a shell prop at the shared shell spot. Returns false if the model isn't on the server.
function SpawnSafehouseShell(shell)
    if shellObject and DoesEntityExist(shellObject) then DeleteEntity(shellObject) end
    local hash = GetHashKey(shell.model)
    if not IsModelInCdimage(hash) then
        lib.notify({ description = locale('safehouse_shell_missing', shell.model), type = 'error' })
        return false
    end
    lib.requestModel(hash, 10000)
    shellObject = CreateObjectNoOffset(hash, shell.x, shell.y, shell.z, false, false, false)
    SetEntityHeading(shellObject, 0.0)
    FreezeEntityPosition(shellObject, true)
    SetModelAsNoLongerNeeded(hash)
    RequestCollisionAtCoord(shell.x, shell.y, shell.z)
    return true
end

function RemoveSafehouseShell()
    if shellObject and DoesEntityExist(shellObject) then DeleteEntity(shellObject) end
    shellObject = nil
end

local function apply(list) houses = type(list) == 'table' and list or {} end
apply(GlobalState.vg_safehouses)
AddStateBagChangeHandler('vg_safehouses', 'global', function(_, _, value) apply(value) end)

local function hasAccess()
    local gang = GetPlayerGang()
    if not gang then return nil end
    for _, p in ipairs(gang.permissions) do
        if p == '*' or p == 'safehouse_access' then return gang end
    end
    return nil
end

local function isPolice()
    local job = ClientBridge.GetJob()
    return job and cfg.raid.jobs[job]
end

-------------------------------------------------------------------------------
-- Actions
-------------------------------------------------------------------------------

local function enter(h)
    busy = true
    local res, err = lib.callback.await('vinewood_gangs:server:safehouseEnter', false, h.id)
    if res then
        if res.shell then
            DoScreenFadeOut(300)
            while not IsScreenFadedOut() do Wait(10) end
            if not SpawnSafehouseShell(res.shell) then
                lib.callback.await('vinewood_gangs:server:safehouseLeave', false)
                DoScreenFadeIn(300)
                busy = false
                return
            end
            -- Hold the player still while the shell's collision loads, so they don't drop through it
            FreezeEntityPosition(cache.ped, true)
            SetEntityCoords(cache.ped, res.spawn.x, res.spawn.y, res.spawn.z - 0.95, false, false, false, false)
            Wait(600)
            FreezeEntityPosition(cache.ped, false)
        end
        current = res
        teleport(res.spawn)
    else
        notify(err or 'failed', 'error')
    end
    busy = false
end

local function leave()
    busy = true
    local ok, err = lib.callback.await('vinewood_gangs:server:safehouseLeave', false)
    if not ok then notify(err or 'failed', 'error') end
    busy = false
end

local function breach(h)
    busy = true
    local time, err = lib.callback.await('vinewood_gangs:server:safehouseRaidStart', false, h.id)
    if not time then
        notify(err or 'failed', 'error')
        busy = false
        return
    end
    local done = lib.progressBar({
        duration = time, label = locale('safehouse_breaching'), canCancel = true,
        disable = { move = true, car = true, combat = true }, anim = BREACH_ANIM,
    })
    if done then
        local ok, ferr = lib.callback.await('vinewood_gangs:server:safehouseRaidFinish', false, h.id)
        if ok then notify('safehouse_breached', 'success') else notify(ferr or 'failed', 'error') end
    end
    busy = false
end

RegisterNetEvent('vinewood_gangs:client:safehouseOut', function(entrance)
    local wasInside = current ~= nil
    current = nil
    setPrompt(nil)
    if wasInside and entrance then teleport(entrance) end
    RemoveSafehouseShell()
end)

-------------------------------------------------------------------------------
-- Prompts outside and inside
-------------------------------------------------------------------------------

CreateThread(function()
    while true do
        local sleep, want, action = 1000, nil, nil
        if not busy then
            local pos = GetEntityCoords(cache.ped)
            if current then
                sleep = 250
                if #(pos - v3(current.stash)) < 1.5 then
                    want, action, sleep = 'safehouse_prompt_stash', 'stash', 0
                elseif #(pos - v3(current.exit)) < 1.5 then
                    want, action, sleep = 'safehouse_prompt_leave', 'leave', 0
                end
            else
                for _, h in ipairs(houses) do
                    local d = #(pos - v3(h.entrance))
                    if d < 25.0 then sleep = 250 end
                    if d < 1.8 and h.gangId then
                        local gang = hasAccess()
                        if gang and gang.id == h.gangId then
                            want, action = 'safehouse_prompt_enter', { 'enter', h }
                        elseif isPolice() then
                            want = h.breached and 'safehouse_prompt_enter_police' or 'safehouse_prompt_breach'
                            action = { h.breached and 'enter' or 'breach', h }
                        end
                        sleep = 0
                        break
                    end
                end
            end
        end

        setPrompt(want)
        if action and IsControlJustPressed(0, 38) then
            setPrompt(nil)
            if action == 'stash' then
                local ok, err = lib.callback.await('vinewood_gangs:server:safehouseStash', false)
                if not ok then notify(err or 'failed', 'error') end
            elseif action == 'leave' then
                leave()
            elseif action[1] == 'enter' then
                enter(action[2])
            elseif action[1] == 'breach' then
                breach(action[2])
            end
        end
        Wait(sleep)
    end
end)

-- Anyone who logs in inside a safehouse interior (their last position was saved there)
-- is put back outside, since they're no longer in its instance.
CreateThread(function()
    Wait(8000)
    if current then return end
    local pos = GetEntityCoords(cache.ped)
    local gang = GetPlayerGang()
    local match
    for _, h in ipairs(houses) do
        if h.spawn and #(pos - v3(h.spawn)) < 40.0 then
            if gang and h.gangId == gang.id then match = h break end
            match = match or h
        end
    end
    if match then
        teleport(match.entrance)
        notify('safehouse_rescued', 'inform', match.label)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if prompt then lib.hideTextUI() end
    RemoveSafehouseShell()
end)
