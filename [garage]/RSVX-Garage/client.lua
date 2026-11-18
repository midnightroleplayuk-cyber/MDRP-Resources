local garages, points, peds = {}, {}, {}

local modSlots = {
    engine = 11,
    brakes = 12,
    transmission = 13,
    suspension = 15,
    armour = 16,
}

local function round(value)
    return math.floor(value * 100 + 0.5) / 100
end

local preview = { token = 0 }

local function clearPreview()
    preview.token += 1
    if preview.veh then
        DeleteEntity(preview.veh)
        preview.veh = nil
    end
    if preview.cam then
        RenderScriptCams(false, true, 300, true, false)
        DestroyCam(preview.cam, false)
        preview.cam = nil
    end
end

local function closeUi()
    clearPreview()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function hasAccess(garage)
    local job = QBX.PlayerData and QBX.PlayerData.job
    if not job then return false end
    local min = garage.jobs[job.name]
    return min ~= nil and job.grade.level >= min
end

local function openGarage(garage)
    local job = QBX.PlayerData.job
    local vehicles = {}

    for i, vehicle in ipairs(garage.vehicles) do
        local locked = job.grade.level < vehicle.grade
        local visible = not vehicle.job or vehicle.job == job.name

        if visible and not (locked and Config.HideLockedVehicles) then
            vehicles[#vehicles + 1] = {
                index = i,
                label = vehicle.label,
                model = vehicle.model,
                grade = vehicle.grade,
                locked = locked,
            }
        end
    end

    SendNUIMessage({
        action = 'garage',
        garage = { id = garage.id, label = garage.label, job = job.label, rank = job.grade.name, vehicles = vehicles },
    })
    SetNuiFocus(true, true)
end

local function applySetup(veh, vehicle)
    local mods = vehicle.mods or {}
    SetVehicleModKit(veh, 0)

    for name, slot in pairs(modSlots) do
        if mods[name] then SetVehicleMod(veh, slot, mods[name], false) end
    end
    if mods.turbo then ToggleVehicleMod(veh, 18, true) end
    if mods.windowTint then SetVehicleWindowTint(veh, mods.windowTint) end

    if vehicle.colour then
        SetVehicleColours(veh, vehicle.colour.primary, vehicle.colour.secondary)
    end

    if vehicle.livery then
        SetVehicleLivery(veh, vehicle.livery)
        SetVehicleMod(veh, 48, vehicle.livery, false)
    end

    if vehicle.extras then
        local enabled = {}
        for _, extra in ipairs(vehicle.extras) do enabled[extra] = true end
        for extra = 0, 20 do
            if DoesExtraExist(veh, extra) then
                SetVehicleExtra(veh, extra, not enabled[extra])
            end
        end
    end

    SetVehicleDirtLevel(veh, 0.0)
end

local function findGarage(id)
    for _, garage in ipairs(garages) do
        if garage.id == id then return garage end
    end
end

-- Local-only vehicle in a bay so the player can see the preset before taking it out.
local function showPreview(garage, vehicle)
    clearPreview()
    local token = preview.token

    local model = joaat(vehicle.model)
    if not IsModelInCdimage(model) then return end
    if not pcall(lib.requestModel, model, 10000) or token ~= preview.token then return end

    local bay = garage.spawns[1]
    for _, spawn in ipairs(garage.spawns) do
        if not IsAnyVehicleNearPoint(spawn.x, spawn.y, spawn.z, 3.0) then
            bay = spawn
            break
        end
    end

    local veh = CreateVehicle(model, bay.x, bay.y, bay.z, bay.w, false, false)
    SetModelAsNoLongerNeeded(model)
    SetVehicleOnGroundProperly(veh)
    FreezeEntityPosition(veh, true)
    SetEntityInvincible(veh, true)
    SetVehicleDoorsLocked(veh, 2)
    applySetup(veh, vehicle)
    preview.veh = veh

    local min, max = GetModelDimensions(model)
    local length = math.max(max.y - min.y, 4.0)
    local camPos = GetOffsetFromEntityInWorldCoords(veh, -length * 0.6, length * 0.95, (max.z - min.z) * 0.5 + 0.4)

    local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camPos.x, camPos.y, camPos.z, 0.0, 0.0, 0.0, 45.0, false, 0)
    PointCamAtEntity(cam, veh, 0.0, 0.0, 0.0, true)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 400, true, false)
    preview.cam = cam
end

-- Reads the vehicle the admin is sitting in so it can be saved as a preset.
local function captureVehicle()
    local veh = cache.vehicle
    if not veh then return false end

    local livery = GetVehicleLivery(veh)
    if livery < 0 then livery = GetVehicleMod(veh, 48) end

    local extras = {}
    for extra = 0, 20 do
        if DoesExtraExist(veh, extra) and IsVehicleExtraTurnedOn(veh, extra) then
            extras[#extras + 1] = extra
        end
    end

    local mods = { turbo = IsToggleModOn(veh, 18), windowTint = math.max(GetVehicleWindowTint(veh), 0) }
    for name, slot in pairs(modSlots) do mods[name] = GetVehicleMod(veh, slot) end

    local primary, secondary = GetVehicleColours(veh)

    return {
        model = GetEntityArchetypeName(veh),
        livery = livery >= 0 and livery or nil,
        extras = extras,
        mods = mods,
        colour = { primary = primary, secondary = secondary },
    }
end

local PROP_IDS = { 0, 1, 2, 6, 7 }

local function applyOutfit(ped, outfit)
    SetPedDefaultComponentVariation(ped)
    SetPedHeadBlendData(ped, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, false)

    for _, c in ipairs(outfit.components or {}) do
        SetPedComponentVariation(ped, c.id, c.drawable, c.texture, 0)
    end

    for _, c in ipairs(outfit.props or {}) do
        if c.drawable < 0 then
            ClearPedProp(ped, c.id)
        else
            SetPedPropIndex(ped, c.id, c.drawable, c.texture, true)
        end
    end

    if outfit.hair then SetPedHairColor(ped, outfit.hair.colour, outfit.hair.highlight) end
end

local function captureOutfit()
    local ped = cache.ped
    local outfit = {
        model = GetEntityArchetypeName(ped),
        components = {},
        props = {},
        hair = { colour = GetPedHairColor(ped), highlight = GetPedHairHighlightColor(ped) },
    }

    for id = 0, 11 do
        outfit.components[#outfit.components + 1] = {
            id = id,
            drawable = GetPedDrawableVariation(ped, id),
            texture = GetPedTextureVariation(ped, id),
        }
    end

    for _, id in ipairs(PROP_IDS) do
        local drawable = GetPedPropIndex(ped, id)
        outfit.props[#outfit.props + 1] = {
            id = id,
            drawable = drawable,
            texture = drawable >= 0 and GetPedPropTextureIndex(ped, id) or 0,
        }
    end

    return outfit
end

local function clear()
    for _, point in ipairs(points) do point:remove() end
    for _, ped in pairs(peds) do
        exports.ox_target:removeLocalEntity(ped)
        DeleteEntity(ped)
    end
    points, peds = {}, {}
end

local function build()
    clear()

    for _, garage in ipairs(garages) do
        local cfg = garage.ped
        local point = lib.points.new({ coords = vec3(cfg.x, cfg.y, cfg.z), distance = 60.0 })

        function point:onEnter()
            local model = joaat(cfg.model)
            if not IsModelInCdimage(model) then model = `s_m_y_cop_01` end
            lib.requestModel(model)

            local ped = CreatePed(4, model, cfg.x, cfg.y, cfg.z - 1.0, cfg.w, false, false)
            SetModelAsNoLongerNeeded(model)
            if cfg.outfit then applyOutfit(ped, cfg.outfit) end
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)

            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'rsvx_garage_' .. garage.id,
                    icon = 'fa-solid fa-warehouse',
                    label = garage.label,
                    distance = 2.5,
                    canInteract = function() return hasAccess(garage) end,
                    onSelect = function() openGarage(garage) end,
                },
            })

            peds[garage.id] = ped
        end

        function point:onExit()
            local ped = peds[garage.id]
            if not ped then return end
            exports.ox_target:removeLocalEntity(ped)
            DeleteEntity(ped)
            peds[garage.id] = nil
        end

        points[#points + 1] = point
    end
end

-- Set by the server on spawn; whoever owns the entity applies the preset so it syncs to everyone.
AddStateBagChangeHandler('rsvxGarage', nil, function(bagName, _, value)
    if not value then return end

    CreateThread(function()
        local veh = 0
        local timeout = GetGameTimer() + 5000
        while veh == 0 and GetGameTimer() < timeout do
            veh = GetEntityFromStateBagName(bagName)
            Wait(50)
        end

        if veh ~= 0 and NetworkGetEntityOwner(veh) == cache.playerId then
            applySetup(veh, value)
        end
    end)
end)

RegisterNetEvent('rsvx_garage:sync', function(list)
    clearPreview()
    garages = list
    build()
end)

RegisterNetEvent('rsvx_garage:openAdmin', function(list)
    SendNUIMessage({ action = 'admin', garages = list })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('close', function(_, cb)
    clearPreview()
    SetNuiFocus(false, false)
    cb(1)
end)

RegisterNUICallback('preview', function(data, cb)
    cb(1)
    local garage = findGarage(data.garage)
    local vehicle = garage and garage.vehicles[data.index]
    if vehicle then showPreview(garage, vehicle) end
end)

RegisterNUICallback('takeOut', function(data, cb)
    TriggerServerEvent('rsvx_garage:takeOut', data.garage, data.index)
    closeUi()
    cb(1)
end)

RegisterNUICallback('return', function(data, cb)
    TriggerServerEvent('rsvx_garage:return', data.garage)
    closeUi()
    cb(1)
end)

RegisterNUICallback('position', function(_, cb)
    local entity = cache.vehicle or cache.ped
    local pos = GetEntityCoords(entity)
    cb({ x = round(pos.x), y = round(pos.y), z = round(pos.z), w = round(GetEntityHeading(entity)) })
end)

RegisterNUICallback('capture', function(_, cb)
    cb(captureVehicle())
end)

RegisterNUICallback('captureOutfit', function(_, cb)
    cb(captureOutfit())
end)

RegisterNUICallback('save', function(data, cb)
    cb(lib.callback.await('rsvx_garage:save', false, data) or { ok = false, error = 'No response from server.' })
end)

RegisterNUICallback('delete', function(data, cb)
    cb(lib.callback.await('rsvx_garage:delete', false, data.id) or { ok = false, error = 'No response from server.' })
end)

CreateThread(function()
    garages = lib.callback.await('rsvx_garage:getGarages', false) or {}
    build()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= cache.resource then return end
    clearPreview()
    clear()
end)
