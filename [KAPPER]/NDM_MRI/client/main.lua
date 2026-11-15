local lyingOn = nil          -- scanner id we are lying on
local scanning = false       -- this client is running a scan as the medic
local activeSounds = {}      -- [scannerId] = true while that scanner is running
local moveToken = 0          -- bumped to cancel any table movement in progress

local function notify(msg, kind)
    lib.notify({ title = 'MRI', description = msg, type = kind or 'inform' })
end

-- No collision / no ragdoll while the table carries the patient through the scanner model
local function setGhost(ped, on)
    SetEntityCollision(ped, not on, not on)
    SetPedCanRagdoll(ped, not on)
end

local function ospIsDead()
    local ok, dead = pcall(function() return exports.osp_ambulance:isDead() end)
    return ok and dead == true
end

local function jobGroups()
    local groups = {}
    for job, grade in pairs(Config.Jobs) do groups[job] = grade end
    return groups
end

---------------------------------------------------------------------------
-- Lying on the table
---------------------------------------------------------------------------
local function playLie(ped)
    if ospIsDead() then return end -- OSP keeps its own downed pose
    lib.requestAnimDict(Config.LieAnim.dict)
    TaskPlayAnim(ped, Config.LieAnim.dict, Config.LieAnim.clip, 8.0, 1.0, -1, 1, 0, false, false, false)
end

local function getUp()
    if not lyingOn then return end
    local id = lyingOn
    lyingOn = nil
    moveToken = moveToken + 1
    local ped = cache.ped
    setGhost(ped, false)
    FreezeEntityPosition(ped, false)
    if not ospIsDead() then
        ClearPedTasks(ped)
        local t = Config.Scanners[id].table
        local side = GetOffsetFromEntityInWorldCoords(ped, 1.2, 0.0, 0.0)
        SetEntityCoords(ped, side.x, side.y, t.z - 0.9, false, false, false, false)
    end
    lib.hideTextUI()
    TriggerServerEvent('NDM_MRI:server:leftTable', id)
end

RegisterNetEvent('NDM_MRI:client:lieDown', function(id)
    local s = Config.Scanners[id]
    if not s or lyingOn then return end
    local ped = cache.ped
    local t = s.table

    DoScreenFadeOut(400)
    while not IsScreenFadedOut() do Wait(50) end

    if IsPedInAnyVehicle(ped, false) then TaskLeaveAnyVehicle(ped, 0, 16) Wait(800) end
    DetachEntity(ped, true, false)
    SetEntityCoords(ped, t.x, t.y, t.z + 0.02, false, false, false, false)
    SetEntityHeading(ped, t.w)
    playLie(ped)
    Wait(300)
    FreezeEntityPosition(ped, true)
    lyingOn = id

    DoScreenFadeIn(400)
    lib.showTextUI('[X] Get off the MRI table')

    CreateThread(function()
        while lyingOn == id do
            if not ospIsDead() and not IsEntityPlayingAnim(ped, Config.LieAnim.dict, Config.LieAnim.clip, 3) then
                playLie(ped)
            end
            Wait(1000)
        end
    end)
    CreateThread(function()
        while lyingOn == id do
            -- 73 = X
            if IsControlJustPressed(0, 73) and not activeSounds[id] and not ospIsDead() then
                getUp()
            end
            Wait(0)
        end
    end)
end)

RegisterNetEvent('NDM_MRI:client:getUp', function()
    getUp()
end)

---------------------------------------------------------------------------
-- Table movement (slides the patient in / out of the bore)
---------------------------------------------------------------------------

-- Smoothly moves the ped between two points. Returns false if interrupted.
local function slide(ped, from, to, ms, token, heading)
    local start = GetGameTimer()
    while true do
        if token ~= moveToken then return false end
        local p = math.min((GetGameTimer() - start) / ms, 1.0)
        local e = p * p * (3.0 - 2.0 * p) -- ease in / out
        local pos = from + (to - from) * e
        SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z, false, false, false)
        SetEntityHeading(ped, heading)
        -- keep the lying pose if anything knocked it off
        if not ospIsDead() and not IsEntityPlayingAnim(ped, Config.LieAnim.dict, Config.LieAnim.clip, 3) then
            TaskPlayAnim(ped, Config.LieAnim.dict, Config.LieAnim.clip, 1000.0, 1.0, -1, 1, 0, false, false, false)
        end
        if p >= 1.0 then return true end
        Wait(0)
    end
end

local function tableHome(s)
    return vector3(s.table.x, s.table.y, s.table.z + 0.02)
end

local function startTableMotion(id)
    local s = Config.Scanners[id]
    if not s or not s.bore or lyingOn ~= id or ospIsDead() then return end
    moveToken = moveToken + 1
    local token = moveToken
    local m = Config.TableMotion
    CreateThread(function()
        local ped = cache.ped
        local home = tableHome(s)
        local bore = vector3(s.bore.x, s.bore.y, home.z)
        local dir = home - bore
        local len = #dir
        if len > 0.001 then dir = dir / len end

        setGhost(ped, true)
        if not slide(ped, GetEntityCoords(ped), bore, m.slideTime, token, s.table.w) then return end

        local pos, out = bore, false
        while token == moveToken and lyingOn == id and (m.shuffle or 0) > 0 do
            Wait(m.pause)
            out = not out
            local target = out and (bore + dir * m.shuffle) or bore
            if not slide(ped, pos, target, m.shuffleTime, token, s.table.w) then return end
            pos = target
        end
    end)
end

local function stopTableMotion(id)
    moveToken = moveToken + 1
    local token = moveToken
    local s = Config.Scanners[id]
    if not s or not s.bore or lyingOn ~= id or ospIsDead() then return end
    CreateThread(function()
        local ped = cache.ped
        if slide(ped, GetEntityCoords(ped), tableHome(s), Config.TableMotion.slideTime, token, s.table.w) then
            setGhost(ped, false)
        end
    end)
end

RegisterNetEvent('NDM_MRI:client:holdStill', function(id, duration)
    if duration and duration > 0 then
        notify('MRI scan in progress, hold still...', 'inform')
        FreezeEntityPosition(cache.ped, true)
        startTableMotion(id)
    else
        stopTableMotion(id)
        if lyingOn ~= id then FreezeEntityPosition(cache.ped, false) end
    end
end)

---------------------------------------------------------------------------
-- Sound (3D, everyone nearby hears it)
---------------------------------------------------------------------------
local soundLoopRunning = false

local function soundLoop()
    if soundLoopRunning then return end
    soundLoopRunning = true
    CreateThread(function()
        local lastVol = -1
        while next(activeSounds) do
            local cam = GetFinalRenderedCamCoord()
            local best = 0.0
            for id in pairs(activeSounds) do
                local t = Config.Scanners[id].table
                local d = #(cam - vector3(t.x, t.y, t.z))
                if d < Config.SoundRange then
                    local v = Config.SoundVolume * (1.0 - d / Config.SoundRange) ^ 1.6
                    if v > best then best = v end
                end
            end
            best = math.floor(best * 100 + 0.5) / 100
            if best ~= lastVol then
                SendNUIMessage({ action = 'soundVolume', volume = best })
                lastVol = best
            end
            Wait(200)
        end
        SendNUIMessage({ action = 'soundStop' })
        soundLoopRunning = false
    end)
end

RegisterNetEvent('NDM_MRI:client:sound', function(id, playing)
    if not Config.Scanners[id] then return end
    if playing then
        local first = next(activeSounds) == nil
        activeSounds[id] = true
        if first then
            SendNUIMessage({ action = 'soundStart', file = Config.SoundFile, volume = 0.0 })
        end
        soundLoop()
    else
        activeSounds[id] = nil
    end
end)

---------------------------------------------------------------------------
-- Scan
---------------------------------------------------------------------------
local function confirmFractures(report)
    local parts = report.confirmFractures
    if not parts or #parts == 0 then return end
    local data = Player(report.patientId).state.BodyDamage
    if type(data) ~= 'table' or type(data.BodyPartDamage) ~= 'table' then return end
    local changed = false
    for _, part in ipairs(parts) do
        if data.BodyPartDamage.Fractures and data.BodyPartDamage.Fractures[part] == true then
            data.BodyPartDamage.Fractures[part] = 'xrayed'
            changed = true
        end
    end
    -- Same save path the OSP X-ray uses (medic -> patient)
    if changed then
        TriggerServerEvent('osp_ambulance:SaveDataSv', report.patientId, data)
    end
end

local function startScan(id)
    if scanning then return end
    local ok, result = lib.callback.await('NDM_MRI:server:startScan', false, id)
    if not ok then return notify(result or 'Could not start the scan', 'error') end

    scanning = true
    local completed = lib.progressBar({
        duration = result,
        label = 'MRI scan in progress...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'anim@heists@prison_heiststation@cop_reactions', clip = 'cop_b_idle', flag = 49 },
    })
    scanning = false

    local success, report = lib.callback.await('NDM_MRI:server:finishScan', false, id, completed)
    if not success then return notify(report or 'Scan failed', 'error') end

    if Config.ConfirmFractures then confirmFractures(report) end
    SendNUIMessage({ action = 'showReport', report = report, scanner = Config.Scanners[id].label })
    SetNuiFocus(true, true)
end

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

local function layNearestPatient(id)
    local coords = GetEntityCoords(cache.ped)
    local playerId = lib.getClosestPlayer(coords, Config.LayPatientRange, false)
    if not playerId then return notify('No patient nearby', 'error') end
    TriggerServerEvent('NDM_MRI:server:layPatient', id, GetPlayerServerId(playerId))
end

---------------------------------------------------------------------------
-- Targets
---------------------------------------------------------------------------
CreateThread(function()
    local groups = jobGroups()
    for id, s in ipairs(Config.Scanners) do
        local t = s.table
        local tableOptions = {
            {
                name = 'NDM_MRI_lay_' .. id,
                icon = 'fa-solid fa-bed-pulse',
                label = 'Place patient on MRI table',
                groups = groups,
                distance = 2.5,
                onSelect = function() layNearestPatient(id) end,
            },
            {
                name = 'NDM_MRI_remove_' .. id,
                icon = 'fa-solid fa-person-walking-arrow-right',
                label = 'Remove patient from MRI table',
                groups = groups,
                distance = 2.5,
                onSelect = function() TriggerServerEvent('NDM_MRI:server:removePatient', id) end,
            },
            {
                name = 'NDM_MRI_selflie_' .. id,
                icon = 'fa-solid fa-bed',
                label = 'Lie on MRI table',
                distance = 2.0,
                canInteract = function() return lyingOn == nil end,
                onSelect = function() TriggerServerEvent('NDM_MRI:server:selfLie', id) end,
            },
        }
        if not s.console then
            table.insert(tableOptions, 1, {
                name = 'NDM_MRI_scan_' .. id,
                icon = 'fa-solid fa-magnet',
                label = 'Start MRI scan',
                groups = groups,
                distance = 2.5,
                canInteract = function() return not scanning end,
                onSelect = function() startScan(id) end,
            })
        end

        exports.ox_target:addSphereZone({
            coords = vector3(t.x, t.y, t.z),
            radius = 1.6,
            debug = Config.Debug,
            options = tableOptions,
        })

        if s.console then
            exports.ox_target:addSphereZone({
                coords = s.console,
                radius = 0.8,
                debug = Config.Debug,
                options = {
                    {
                        name = 'NDM_MRI_console_' .. id,
                        icon = 'fa-solid fa-magnet',
                        label = 'Start MRI scan',
                        groups = groups,
                        distance = 2.0,
                        canInteract = function() return not scanning end,
                        onSelect = function() startScan(id) end,
                    },
                },
            })
        end
    end
end)

---------------------------------------------------------------------------
-- Helper for setting up vectors
---------------------------------------------------------------------------
RegisterCommand('mripos', function()
    local c = GetEntityCoords(cache.ped)
    local h = GetEntityHeading(cache.ped)
    local line = ('vector4(%.2f, %.2f, %.2f, %.1f)'):format(c.x, c.y, c.z, h)
    print('[NDM_MRI] ' .. line)
    lib.setClipboard(line)
    notify('Copied ' .. line, 'success')
end, false)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if lyingOn then setGhost(cache.ped, false) FreezeEntityPosition(cache.ped, false) ClearPedTasks(cache.ped) lib.hideTextUI() end
end)
