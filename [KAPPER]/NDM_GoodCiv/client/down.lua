-- GoodCiv's own down state, used when no ambulance script is running (Config.Down).
-- On death the player is resurrected in place, made invincible and held in a
-- "down" animation until a GoodCiv volunteer brings them round, hands them over
-- at a hospital, an admin revives them, or they respawn after Config.Down.RespawnAfter.
Down = { active = false }

local D = Config.Down
local downSince = 0
local holdStart
local disabledAutoSpawn = false

local function enabled() return GoodCiv.DownMode() == 'goodciv' end

local function loadDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 3000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do Wait(10) end
    return HasAnimDictLoaded(dict)
end

local function playDownAnim(ped)
    local anim = IsPedInAnyVehicle(ped, false) and D.VehicleAnim or D.Anim
    if IsEntityPlayingAnim(ped, anim.dict, anim.clip, 3) then return end
    if loadDict(anim.dict) then
        TaskPlayAnim(ped, anim.dict, anim.clip, 8.0, -8.0, -1, 1, 0.0, false, false, false)
    end
end

local function setAutoSpawn(on)
    if GetResourceState('spawnmanager') ~= 'started' then return end
    exports.spawnmanager:setAutoSpawn(on)
end

local function vehicleSeat(ped)
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then return end
    for seat = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
        if GetPedInVehicleSeat(veh, seat) == ped then return veh, seat end
    end
end

local function enterDown()
    Down.active = true
    downSince = GetGameTimer()
    holdStart = nil

    -- Stop spawnmanager respawning us before we resurrect.
    if not disabledAutoSpawn then
        setAutoSpawn(false)
        disabledAutoSpawn = true
    end

    local ped = PlayerPedId()
    local veh, seat = vehicleSeat(ped)

    -- Let the ragdoll settle so we stay where we fell.
    local settle = GetGameTimer() + 1500
    while GetEntitySpeed(ped) > 0.3 and GetGameTimer() < settle do Wait(100) end

    local c = GetEntityCoords(ped)
    NetworkResurrectLocalPlayer(c.x, c.y, c.z, GetEntityHeading(ped), true, false)
    ped = PlayerPedId()
    if veh and DoesEntityExist(veh) and IsVehicleSeatFree(veh, seat) then
        SetPedIntoVehicle(ped, veh, seat)
    end
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetEntityInvincible(ped, true)
    playDownAnim(ped)

    LocalPlayer.state:set('goodciv:down', true, true)
end

---Bring the local player out of the down state at full health.
function Down.Revive()
    local ped = PlayerPedId()
    if IsEntityDead(ped) then
        local c = GetEntityCoords(ped)
        NetworkResurrectLocalPlayer(c.x, c.y, c.z, GetEntityHeading(ped), true, false)
        ped = PlayerPedId()
    end
    local wasDown = Down.active
    Down.active = false
    holdStart = nil
    SetEntityInvincible(ped, false)
    if wasDown and not IsPedInAnyVehicle(ped, false) then ClearPedTasks(ped) end
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    if disabledAutoSpawn then
        setAutoSpawn(true)
        disabledAutoSpawn = false
    end
    LocalPlayer.state:set('goodciv:down', false, true)
    Nui.Send('down', false)
end

-- From the server only (GoodCiv bring round / handover / admin revive).
RegisterNetEvent('goodciv:client:revive', function()
    if GetInvokingResource() then return end
    Down.Revive()
end)

RegisterNetEvent('goodciv:client:respawn', function(drop)
    if GetInvokingResource() then return end
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do Wait(10) end
    Down.Revive()
    local ped = PlayerPedId()
    if drop then
        SetEntityCoordsNoOffset(ped, drop.x, drop.y, drop.z, false, false, false)
        SetEntityHeading(ped, drop.w)
    end
    Wait(1000)
    DoScreenFadeIn(800)
end)

exports('IsDown', function() return Down.active end)

---------------------------------------------------------------------------
-- Detection
---------------------------------------------------------------------------
CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(500) end
    if not enabled() then return end
    LocalPlayer.state:set('goodciv:down', false, true)
    -- Only react to deaths after we've been alive once, so the pre-spawn ped on join
    -- never trips this and blocks spawnmanager's first spawn.
    local seenAlive = false
    while true do
        local ped = PlayerPedId()
        if not IsEntityDead(ped) then
            seenAlive = true
        elseif seenAlive and not Down.active and not IsPlayerSwitchInProgress() then
            enterDown()
        end
        Wait(250)
    end
end)

---------------------------------------------------------------------------
-- While down: controls, animation, respawn and the status card
---------------------------------------------------------------------------
local ALLOWED = {
    1, 2,       -- look
    0,          -- change camera
    245, 246,   -- chat
    249,        -- push to talk
    199, 200,   -- pause menu
}

local function formatTime(s)
    return ('%02d:%02d'):format(math.floor(s / 60), s % 60)
end

CreateThread(function()
    local lastAnim, lastCard = 0, 0
    while true do
        if not Down.active then
            Wait(500)
        else
            local ped = PlayerPedId()
            local t = GetGameTimer()

            DisableAllControlActions(0)
            for i = 1, #ALLOWED do EnableControlAction(0, ALLOWED[i], true) end

            if t - lastAnim > 500 then
                lastAnim = t
                SetEntityInvincible(ped, true)
                -- Responders move the patient in and out of vehicles; keep the right pose.
                playDownAnim(ped)
            end

            local elapsed = math.floor((t - downSince) / 1000)
            local canRespawn = D.RespawnAfter > 0 and elapsed >= D.RespawnAfter
            local hold = 0
            if canRespawn and IsDisabledControlPressed(0, 38) then
                holdStart = holdStart or t
                hold = math.min(1.0, (t - holdStart) / (D.RespawnHold * 1000))
                if hold >= 1.0 then
                    holdStart = nil
                    TriggerServerEvent('goodciv:server:respawn')
                    Wait(1500)
                end
            else
                holdStart = nil
            end

            if t - lastCard > 250 then
                lastCard = t
                local respawn
                if D.RespawnAfter > 0 then
                    if canRespawn then
                        local fee = (D.RespawnFee > 0 and Bridge.Name ~= 'standalone') and (' ($%d)'):format(D.RespawnFee) or ''
                        respawn = L('down_respawn_hold', fee)
                    else
                        respawn = L('down_respawn_in', formatTime(D.RespawnAfter - elapsed))
                    end
                end
                Nui.Send('down', {
                    title = L('down_title'),
                    hint = Patient.HasIncident() and nil or L('down_hint', Config.Dispatch.Command),
                    respawn = respawn,
                    hold = hold,
                })
            end
            Wait(0)
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() or not Down.active then return end
    local ped = PlayerPedId()
    SetEntityInvincible(ped, false)
    ClearPedTasks(ped)
    if disabledAutoSpawn then setAutoSpawn(true) end
end)
