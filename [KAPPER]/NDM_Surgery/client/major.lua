-- Major surgery (organ / limb mini-games).
-- Based on pickle_surgery by Pickle Mods (Pickle License, see LICENSE / CREDITS.md).
-- Modified for NDM_Surgery by NDM Development: runs on the NDM operating tables, uses the NDM
-- patient / anaesthesia flow, writes results to OSP and drops the framework bridges.

---------------------------------------------------------------------------
-- Helpers used by the mini-games
---------------------------------------------------------------------------
function lerp(a, b, t) return a + (b - a) * t end

function CreateProp(modelHash, ...)
    lib.requestModel(modelHash)
    local obj = CreateObject(modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    return obj
end

function CreateNPC(modelHash, ...)
    lib.requestModel(modelHash)
    local ped = CreatePed(26, modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    return ped
end

function PlayAnim(ped, dict, ...)
    lib.requestAnimDict(dict)
    TaskPlayAnim(ped, dict, ...)
end

function ShowNotification(text)
    lib.notify({ title = 'Surgery', description = text, type = 'inform' })
end

---------------------------------------------------------------------------
-- Table scene positions
---------------------------------------------------------------------------
-- Scene centre: the mini-game props are placed relative to this point. By default it sits 0.85
-- below the table's patient position (the patient ped is attached 0.85 above it).
function GetSceneCenter(id)
    local tbl = Config.Tables[id]
    if tbl.scene then return vector3(tbl.scene.x, tbl.scene.y, tbl.scene.z), tbl.scene.w end
    local t = tbl.coords
    return vector3(t.x, t.y, t.z - 0.85), t.w
end

-- Where the surgeon stands during the mini-game (by default on the right side of the table)
function GetSurgeonSpot(id)
    local tbl = Config.Tables[id]
    if tbl.surgeon then return vector3(tbl.surgeon.x, tbl.surgeon.y, tbl.surgeon.z), tbl.surgeon.w end
    local c, h = GetSceneCenter(id)
    local r = math.rad(h)
    return vector3(c.x + math.cos(r) * 0.85, c.y + math.sin(r) * 0.85, c.z - 0.97), (h + 90.0) % 360.0
end

---------------------------------------------------------------------------
-- Bodies / patient attachment
---------------------------------------------------------------------------
local LIE_DICT, LIE_CLIP = 'anim@gangops@morgue@table@', 'body_search'

function GetPedGender(ped)
    return GetEntityModel(ped) == `mp_m_freemode_01` and 'male' or 'female'
end

function IsTargetMovedAway(targetId, distance, surgeryBodyProps)
    local prop = GetHandTargetProp(targetId)
    if not prop then return end
    if not IsSurgeryActive() then return true end
    return #(GetEntityCoords(prop.entity) - GetEntityCoords(surgeryBodyProps.center)) > (distance or 0.5)
end

local function applySurgeryClothing(ped, clothing)
    SetPedComponentVariation(ped, 3, clothing.arms[1], clothing.arms[2], 1)
    SetPedComponentVariation(ped, 11, clothing.torso[1], clothing.torso[2], 1)
    SetPedComponentVariation(ped, 8, clothing.accessories[1], clothing.accessories[2], 1)
end

local function keepLying(ped, stillActive)
    CreateThread(function()
        PlayAnim(ped, LIE_DICT, LIE_CLIP, -8.0, 8.0, -1, 2, 1.0)
        while stillActive() do
            if not IsEntityPlayingAnim(ped, LIE_DICT, LIE_CLIP, 3) then
                ClearPedTasksImmediately(ped)
                Wait(100)
                PlayAnim(ped, LIE_DICT, LIE_CLIP, -8.0, 8.0, -1, 2, 1.0)
            end
            Wait(100)
        end
    end)
end

local function spawnDummy(center, coords, heading, clothing)
    local ped = CreateNPC(`mp_m_freemode_01`, coords.x, coords.y, coords.z, heading, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    if clothing then applySurgeryClothing(ped, clothing) end
    FreezeEntityPosition(ped, true)
    SetEntityRotation(ped, 90.0, 0.0, heading, 2)
    AttachEntityToEntity(ped, center, -1, -0.02, 0.0, 0.85, 0.0, 0.0, -2.5, false, false, false, true, 0, 2)
    ClearPedTasksImmediately(ped)
    keepLying(ped, IsSurgeryActive)
    return ped
end

-- patientPed = true when a real player is on the table (no dummy is spawned)
-- isSync = true on the patient's own client (they see the opened torso)
function CreateSurgeryBody(coords, heading, patientPed, bodyType, isSync)
    local center = CreateObject(`prop_tennis_ball`, coords.x, coords.y, coords.z, false, true, true)
    FreezeEntityPosition(center, true)
    SetEntityHeading(center, heading)
    SetEntityCollision(center, false, false)
    SetEntityAlpha(center, 0, true)

    if bodyType == nil or bodyType == 'openRib' then
        local surgeryPed, torso, ribs
        if not patientPed then
            surgeryPed = spawnDummy(center, coords, heading, Config.MajorSurgery.clothing.male)
        elseif isSync then
            local c = GetOffsetFromEntityInWorldCoords(center, -0.01, -0.26, -0.16)
            torso = CreateObject(`mrc_torso`, c.x, c.y, c.z, false, true, true)
            SetEntityHeading(torso, heading + 180.0)
            SetEntityCollision(torso, false, false)
            FreezeEntityPosition(torso, true)
            c = GetOffsetFromEntityInWorldCoords(center, -0.01, -0.30, -0.16)
            ribs = CreateObject(`ribs`, c.x, c.y, c.z, false, true, true)
            SetEntityHeading(ribs, heading + 180.0)
            SetEntityCollision(ribs, false, false)
            FreezeEntityPosition(ribs, true)
        end
        return { center = center, torso = torso, ribs = ribs, surgeryPed = surgeryPed }
    end

    -- 'closed' body (arms / legs)
    local surgeryPed
    if not patientPed then surgeryPed = spawnDummy(center, coords, heading) end
    return { center = center, surgeryPed = surgeryPed }
end

---------------------------------------------------------------------------
-- Surgeon side
---------------------------------------------------------------------------
local SCENES = {
    heart  = { start = function(...) StartHeartSurgery(...) end,  cleanup = function() CleanupHeartSurgery() end },
    kidney = { start = function(...) StartKidneySurgery(...) end, cleanup = function() CleanupKidneySurgery() end },
    lung   = { start = function(...) StartLungSurgery(...) end,   cleanup = function() CleanupLungSurgery() end },
    arm    = { start = function(...) StartArmSurgery(...) end,    cleanup = function() CleanupArmSurgery() end },
    leg    = { start = function(...) StartLegSurgery(...) end,    cleanup = function() CleanupLegSurgery() end },
}

local active = nil   -- surgeon: { id, key, token, training }
local finishing = false

function IsSurgeryActive()
    return active ~= nil
end

function GetMajorSurgery(key)
    for _, s in ipairs(Config.MajorSurgeries) do
        if s.key == key then return s end
    end
end

local function finish(success, reason)
    if not active or finishing then return end
    finishing = true
    TriggerServerEvent('NDM_Surgery:server:finishMajor', active.id, active.token, success, reason)
end

function CompleteSurgery()
    finish(true)
end

function FailSurgery(reason)
    finish(false, reason)
end

local function stopScene()
    active = nil
    finishing = false
    SendNUIMessage({ type = 'hideHud' })
    StopHandTarget()
    SetEntityAlpha(cache.ped, 255, false)
    ResetEntityAlpha(cache.ped)
end

-- data = { id, key, token, training }
function StartMajorScene(data)
    local cfg = GetMajorSurgery(data.key)
    local scene = SCENES[data.key]
    if not cfg or not scene or active then return end

    local center, heading = GetSceneCenter(data.id)
    local spot, spotHeading = GetSurgeonSpot(data.id)
    local ped = cache.ped
    local mcfg = Config.MajorSurgery

    DoScreenFadeOut(1000)
    Wait(1050)
    FreezeEntityPosition(ped, true)
    SetEntityCoords(ped, spot.x, spot.y, spot.z, false, false, false, false)
    SetEntityHeading(ped, spotHeading)
    SetEntityAlpha(ped, 0, false)

    active = { id = data.id, key = data.key, token = data.token, training = data.training }
    finishing = false
    local blood = mcfg.blood.startingLevel

    SendNUIMessage({
        type = 'showHud',
        data = {
            blood = blood,
            showInfo = (data.training and mcfg.showControls.training) or (not data.training and mcfg.showControls.patient),
        },
    })

    -- blood loss from open bleeds + keep the surgeon animation going
    CreateThread(function()
        while active do
            blood = blood - (GetBleedingCount() * mcfg.blood.lossPerBleed)
            SendNUIMessage({ type = 'updateHud', data = { blood = math.max(blood, 0) } })
            if blood <= 0 then
                FailSurgery('The patient bled out')
                break
            end
            if not IsEntityPlayingAnim(cache.ped, 'mini@repair', 'fixing_a_ped', 3) then
                ClearPedTasksImmediately(cache.ped)
                PlayAnim(cache.ped, 'mini@repair', 'fixing_a_ped', -8.0, 8.0, -1, 1, 1.0)
            end
            Wait(1000)
        end
    end)

    -- 202 = Backspace / Esc: cancel
    CreateThread(function()
        while active do
            if IsControlJustPressed(1, 202) then FailSurgery('Surgery cancelled') end
            Wait(0)
        end
    end)

    StartHandTarget(center, heading - 180.0, vector3(0.2, 0.8, 0.0), 1, 0.28, function()
        scene.cleanup()
    end)
    scene.start(center, heading, not data.training)
    Wait(200)
    DoScreenFadeIn(1000)
end

RegisterNetEvent('NDM_Surgery:client:majorSurgeon', function(data)
    StartMajorScene(data)
end)

RegisterNetEvent('NDM_Surgery:client:majorSurgeonEnd', function(id)
    if not active or active.id ~= id then return end
    local spot, spotHeading = GetSurgeonSpot(id)
    SetEntityCoords(cache.ped, spot.x, spot.y, spot.z, false, false, false, false)
    SetEntityHeading(cache.ped, spotHeading)
    stopScene()
end)

---------------------------------------------------------------------------
-- Patient side
---------------------------------------------------------------------------
local patient = nil  -- { id, center, body, cam, clothes }

function IsSurgeryPatient()
    return patient ~= nil
end

local function saveClothes(ped)
    local saved = {}
    for _, comp in ipairs({ 3, 8, 11 }) do
        saved[comp] = { GetPedDrawableVariation(ped, comp), GetPedTextureVariation(ped, comp), GetPedPaletteVariation(ped, comp) }
    end
    return saved
end

local function restoreClothes(ped, saved)
    if not saved then return end
    for comp, v in pairs(saved) do SetPedComponentVariation(ped, comp, v[1], v[2], v[3]) end
end

local function endPatientScene()
    if not patient then return end
    local p = patient
    patient = nil
    local ped = cache.ped
    restoreClothes(ped, p.clothes)
    DetachEntity(ped, true, true)
    ClearPedTasksImmediately(ped)
    if p.center and DoesEntityExist(p.center) then DeleteEntity(p.center) end
    for _, e in pairs(p.body or {}) do
        if DoesEntityExist(e) then DeleteEntity(e) end
    end
    if p.cam then
        SetCamActive(p.cam, false)
        RenderScriptCams(false, true, 1, true, true)
        DestroyCam(p.cam, false)
    end
end

RegisterNetEvent('NDM_Surgery:client:majorPatient', function(id, key)
    local cfg = GetMajorSurgery(key)
    if not cfg or patient then return end
    local center, heading = GetSceneCenter(id)
    local ped = cache.ped
    local sedated = IsSedated and IsSedated()

    if not sedated then
        DoScreenFadeOut(1000)
        Wait(1050)
    end

    patient = { id = id, clothes = saveClothes(ped) }

    local c = CreateProp(`prop_tennis_ball`, center.x, center.y, center.z, true, true, true)
    FreezeEntityPosition(c, true)
    SetEntityHeading(c, heading)
    SetEntityCollision(c, false, false)
    SetEntityAlpha(c, 0, true)
    patient.center = c

    if cfg.bodyType == 'openRib' then
        applySurgeryClothing(ped, Config.MajorSurgery.clothing[GetPedGender(ped)])
        patient.body = CreateSurgeryBody(center, heading, true, cfg.bodyType, true)
    end

    FreezeEntityPosition(ped, true)
    SetEntityRotation(ped, 90.0, 0.0, heading, 2)
    AttachEntityToEntity(ped, c, -1, -0.02, 0.0, 0.85, 0.0, 0.0, -2.5, false, false, false, true, 0, 2)
    keepLying(ped, IsSurgeryPatient)

    -- top-down view of your own surgery
    local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', center.x, center.y, center.z + 2.0, -90.0, 0.0, heading - 180.0, 90.0, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1, true, true)
    patient.cam = cam

    Wait(200)
    if not (IsSedated and IsSedated()) then DoScreenFadeIn(1000) end
end)

-- kill = true when the patient dies from a failed / cancelled surgery
RegisterNetEvent('NDM_Surgery:client:majorPatientEnd', function(id, kill)
    if not patient or patient.id ~= id then return end
    Wait(1050)
    endPatientScene()
    if ResumeTablePose then ResumeTablePose() end
    if kill then
        Wait(250)
        SetEntityHealth(cache.ped, 0)
    end
end)

---------------------------------------------------------------------------
-- Cleanup
---------------------------------------------------------------------------
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if active then
        for _, scene in pairs(SCENES) do pcall(scene.cleanup) end
        SetEntityAlpha(cache.ped, 255, false)
        ResetEntityAlpha(cache.ped)
    end
    endPatientScene()
end)
