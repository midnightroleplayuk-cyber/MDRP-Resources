local lyingOn = nil      -- table id we are lying on (patient)
local sedated = false    -- we are under anaesthesia (patient)
local operating = false  -- we are running a procedure (surgeon)

local function notify(msg, kind)
    lib.notify({ title = 'Surgery', description = msg, type = kind or 'inform' })
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

-- OSP skips its downed / dead animation loop while `onBackboard` is set, so we set it while the
-- patient is on the table. That lets the table lying pose be used for downed / dead patients too.
local holdingOsp = false
local function setOspHold(on)
    if on == holdingOsp then return end
    holdingOsp = on
    LocalPlayer.state:set('onBackboard', on, true)
    -- tells MDXBackboard this isn't a real backboard (hides its "Remove backboard" option)
    LocalPlayer.state:set('onMedicalTable', on, true)
end

local function refreshTextUI()
    if sedated then
        lib.showTextUI('You are under general anaesthesia')
    elseif lyingOn then
        lib.showTextUI('[X] Get off the operating table')
    else
        lib.hideTextUI()
    end
end

---------------------------------------------------------------------------
-- Anaesthesia (patient)
---------------------------------------------------------------------------
local function wakeUp()
    if not sedated then return end
    sedated = false
    if Config.Anaesthesia.blackout then DoScreenFadeIn(2500) end
    refreshTextUI()
    notify('You slowly wake up from the anaesthetic', 'inform')
end

RegisterNetEvent('NDM_Surgery:client:sedate', function(on)
    if not on then return wakeUp() end
    if sedated then return end
    sedated = true
    if Config.Anaesthesia.blackout then DoScreenFadeOut(2000) end
    refreshTextUI()
    local endAt = GetGameTimer() + (Config.Anaesthesia.maxTime or 900) * 1000
    CreateThread(function()
        while sedated do
            DisableAllControlActions(0)
            EnableControlAction(0, 245, true) -- chat
            EnableControlAction(0, 249, true) -- push to talk
            if GetGameTimer() > endAt then wakeUp() end
            Wait(0)
        end
    end)
end)

---------------------------------------------------------------------------
-- Lying on the table (patient)
---------------------------------------------------------------------------
local function playLie(ped)
    lib.requestAnimDict(Config.LieAnim.dict)
    TaskPlayAnim(ped, Config.LieAnim.dict, Config.LieAnim.clip, 8.0, 1.0, -1, 1, 0, false, false, false)
end

local function getUp()
    if not lyingOn then return end
    local id = lyingOn
    lyingOn = nil
    wakeUp()
    local ped = cache.ped
    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)
    local t = Config.Tables[id].coords
    local side = GetOffsetFromEntityInWorldCoords(ped, 1.2, 0.0, 0.0)
    SetEntityCoords(ped, side.x, side.y, t.z - 0.9, false, false, false, false)
    -- hand the pose back to OSP (downed / dead players go back to its own animation)
    setOspHold(false)
    refreshTextUI()
    TriggerServerEvent('NDM_Surgery:server:leftTable', id)
end

RegisterNetEvent('NDM_Surgery:client:lieDown', function(id)
    local tbl = Config.Tables[id]
    if not tbl or lyingOn then return end
    local t = tbl.coords
    local ped = cache.ped

    setOspHold(true)
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

    if not sedated then DoScreenFadeIn(400) end
    refreshTextUI()

    -- keep the pose (and bring the ped back if they die on the table)
    CreateThread(function()
        while lyingOn == id do
            ped = cache.ped
            if IsEntityDead(ped) then
                Wait(500)
                ped = PlayerPedId()
                if lyingOn == id and IsEntityDead(ped) then
                    NetworkResurrectLocalPlayer(t.x, t.y, t.z + 0.02, t.w, true, false)
                    ped = PlayerPedId()
                    SetEntityCoords(ped, t.x, t.y, t.z + 0.02, false, false, false, false)
                    SetEntityHeading(ped, t.w)
                    playLie(ped)
                    FreezeEntityPosition(ped, true)
                end
            elseif not IsEntityPlayingAnim(ped, Config.LieAnim.dict, Config.LieAnim.clip, 3) then
                playLie(ped)
            end
            Wait(1000)
        end
    end)

    CreateThread(function()
        while lyingOn == id do
            -- 73 = X
            if IsControlJustPressed(0, 73) and not sedated and not ospIsDead() then
                getUp()
            end
            Wait(0)
        end
    end)
end)

RegisterNetEvent('NDM_Surgery:client:getUp', function()
    getUp()
end)

---------------------------------------------------------------------------
-- Surgery menu (surgeon)
---------------------------------------------------------------------------
local openSurgeryMenu

local function runProcedure(id, proc, part)
    if operating then return end
    local ok, data = lib.callback.await('NDM_Surgery:server:begin', false, id, proc, part)
    if not ok then return notify(data or 'Could not start the procedure', 'error') end

    operating = true
    local anim = Config.SurgeonAnim
    local completed = lib.progressBar({
        duration = data.duration,
        label = data.label .. '...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = anim.dict, clip = anim.clip, flag = anim.flag or 49 },
    })

    local passed = false
    if completed then
        if data.skill and #data.skill > 0 then
            passed = lib.skillCheck(data.skill, Config.SkillKeys)
        else
            passed = true
        end
    end
    operating = false

    local _, msg, kind = lib.callback.await('NDM_Surgery:server:finish', false, id, data.token, completed, passed)
    if msg then notify(msg, kind) end
    if Config.ReopenMenu and completed then openSurgeryMenu(id) end
end

local function partSummary(p)
    local bits = {}
    if p.bullets > 0 then bits[#bits + 1] = p.bullets == 1 and '1 bullet' or (p.bullets .. ' bullets') end
    if p.shrapnel > 0 then bits[#bits + 1] = p.shrapnel == 1 and '1 shrapnel wound' or (p.shrapnel .. ' shrapnel wounds') end
    if p.internal then bits[#bits + 1] = 'internal damage' end
    if p.fracture then
        bits[#bits + 1] = p.fractureState == 'splint' and 'fracture (splinted)'
            or p.fractureState == 'cast' and 'fracture (in cast)' or 'fracture'
    end
    if p.debride > 0 then bits[#bits + 1] = p.debride == 1 and '1 open wound' or (p.debride .. ' open wounds') end
    if p.open then
        bits[#bits + 1] = 'open incision'
    elseif p.needsStitch then
        bits[#bits + 1] = 'needs stitches'
    end
    if #bits == 0 then return p.bleeding and 'Bleeding (external)' or 'No surgical findings' end
    return table.concat(bits, ' · ')
end

openSurgeryMenu = function(id)
    local ok, info = lib.callback.await('NDM_Surgery:server:overview', false, id)
    if not ok then return notify(info or 'Could not examine the patient', 'error') end

    local vitals = {}
    if info.pulse then vitals[#vitals + 1] = ('Pulse %d'):format(math.floor(info.pulse + 0.5)) end
    if info.bp then vitals[#vitals + 1] = 'BP ' .. info.bp end
    vitals[#vitals + 1] = ('Blood %.1f L'):format(info.blood or 6.0)

    local options = {
        {
            title = info.patient,
            description = info.state .. ' · ' .. table.concat(vitals, ' · '),
            icon = 'fa-solid fa-user-injured',
            readOnly = true,
        },
    }

    if info.needsAnaesthesia then
        options[#options + 1] = {
            title = 'Administer general anaesthesia',
            description = 'Required before any incision on a conscious patient',
            icon = 'fa-solid fa-syringe',
            iconColor = '#f59f00',
            onSelect = function() runProcedure(id, 'anaesthesia') end,
        }
    end

    for _, p in ipairs(info.parts) do
        local actions = {}
        if p.bullets > 0 then
            actions[#actions + 1] = {
                title = Config.Procedures.bullet.label,
                description = ('%d remaining'):format(p.bullets),
                icon = 'fa-solid fa-crosshairs',
                disabled = info.needsAnaesthesia,
                onSelect = function() runProcedure(id, 'bullet', p.part) end,
            }
        end
        if p.internal then
            actions[#actions + 1] = {
                title = Config.Procedures.internal.label,
                description = 'Repair damaged organs / stop internal bleeding',
                icon = 'fa-solid fa-lungs',
                disabled = info.needsAnaesthesia,
                onSelect = function() runProcedure(id, 'internal', p.part) end,
            }
        end
        if p.shrapnel > 0 then
            local progress = p.fragNeeded and (' · fragments %d/%d'):format(p.fragDone, p.fragNeeded) or ''
            actions[#actions + 1] = {
                title = Config.Procedures.shrapnel.label,
                description = ('%d wound(s) remaining%s'):format(p.shrapnel, progress),
                icon = 'fa-solid fa-burst',
                disabled = info.needsAnaesthesia,
                onSelect = function() runProcedure(id, 'shrapnel', p.part) end,
            }
        end
        if p.fracture then
            actions[#actions + 1] = {
                title = Config.Procedures.fracture.label,
                description = p.fractureFixable and 'Realign and fix the bone (ORIF)' or p.fractureReason,
                icon = 'fa-solid fa-bone',
                disabled = info.needsAnaesthesia or not p.fractureFixable,
                onSelect = function() runProcedure(id, 'fracture', p.part) end,
            }
        end
        if p.debride > 0 then
            actions[#actions + 1] = {
                title = Config.Procedures.debride.label,
                description = ('Clean and close %d wound(s)'):format(p.debride),
                icon = 'fa-solid fa-hand-holding-medical',
                onSelect = function() runProcedure(id, 'debride', p.part) end,
            }
        end
        if p.needsStitch then
            local blocked = p.bullets > 0 or p.internal or p.shrapnel > 0
                or (p.fracture and p.fractureFixable)
            actions[#actions + 1] = {
                title = Config.Procedures.stitch.label,
                description = blocked and 'Finish the other procedures on this area first' or 'Close the incision',
                icon = 'fa-solid fa-bandage',
                disabled = blocked,
                onSelect = function() runProcedure(id, 'stitch', p.part) end,
            }
        end

        local subId = ('NDM_Surgery_part_%d_%s'):format(id, p.part)
        lib.registerContext({
            id = subId,
            title = p.label,
            menu = 'NDM_Surgery_main',
            options = actions,
        })

        local critical = p.bullets > 0 or p.internal or p.shrapnel > 0 or p.fracture
        options[#options + 1] = {
            title = p.label,
            description = partSummary(p),
            icon = 'fa-solid fa-circle',
            iconColor = critical and '#e03131' or (p.needsStitch and '#f59f00' or '#2f9e44'),
            menu = #actions > 0 and subId or nil,
            arrow = #actions > 0,
            disabled = #actions == 0,
        }
    end

    if info.sedated then
        options[#options + 1] = {
            title = 'Wake patient',
            description = 'Reverse the anaesthetic',
            icon = 'fa-solid fa-eye',
            onSelect = function() TriggerServerEvent('NDM_Surgery:server:wake', id) end,
        }
    end

    lib.registerContext({
        id = 'NDM_Surgery_main',
        title = Config.Tables[id].label,
        options = options,
    })
    lib.showContext('NDM_Surgery_main')
end

local function layNearestPatient(id)
    local coords = GetEntityCoords(cache.ped)
    local playerId = lib.getClosestPlayer(coords, Config.LayPatientRange, false)
    if not playerId then return notify('No patient nearby', 'error') end
    TriggerServerEvent('NDM_Surgery:server:layPatient', id, GetPlayerServerId(playerId))
end

---------------------------------------------------------------------------
-- Targets
---------------------------------------------------------------------------
CreateThread(function()
    local groups = jobGroups()
    for id, tbl in ipairs(Config.Tables) do
        local t = tbl.coords
        exports.ox_target:addSphereZone({
            coords = vector3(t.x, t.y, t.z),
            radius = 1.6,
            debug = Config.Debug,
            options = {
                {
                    name = 'NDM_Surgery_operate_' .. id,
                    icon = 'fa-solid fa-user-doctor',
                    label = 'Perform surgery',
                    groups = groups,
                    distance = 2.5,
                    canInteract = function() return not operating and lyingOn == nil end,
                    onSelect = function() openSurgeryMenu(id) end,
                },
                {
                    name = 'NDM_Surgery_lay_' .. id,
                    icon = 'fa-solid fa-bed-pulse',
                    label = 'Place patient on operating table',
                    groups = groups,
                    distance = 2.5,
                    canInteract = function() return lyingOn == nil end,
                    onSelect = function() layNearestPatient(id) end,
                },
                {
                    name = 'NDM_Surgery_remove_' .. id,
                    icon = 'fa-solid fa-person-walking-arrow-right',
                    label = 'Remove patient from operating table',
                    groups = groups,
                    distance = 2.5,
                    canInteract = function() return not operating and lyingOn == nil end,
                    onSelect = function() TriggerServerEvent('NDM_Surgery:server:removePatient', id) end,
                },
                {
                    name = 'NDM_Surgery_selflie_' .. id,
                    icon = 'fa-solid fa-bed',
                    label = 'Lie on operating table',
                    distance = 2.0,
                    canInteract = function() return lyingOn == nil end,
                    onSelect = function() TriggerServerEvent('NDM_Surgery:server:selfLie', id) end,
                },
            },
        })
    end
end)

---------------------------------------------------------------------------
-- Helper for setting up vectors
---------------------------------------------------------------------------
RegisterCommand('surgerypos', function()
    local c = GetEntityCoords(cache.ped)
    local h = GetEntityHeading(cache.ped)
    local line = ('vector4(%.2f, %.2f, %.2f, %.1f)'):format(c.x, c.y, c.z, h)
    print('[NDM_Surgery] ' .. line)
    lib.setClipboard(line)
    notify('Copied ' .. line, 'success')
end, false)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if sedated then sedated = false DoScreenFadeIn(500) end
    if lyingOn then FreezeEntityPosition(cache.ped, false) ClearPedTasks(cache.ped) end
    lib.hideTextUI()
    setOspHold(false)
end)
