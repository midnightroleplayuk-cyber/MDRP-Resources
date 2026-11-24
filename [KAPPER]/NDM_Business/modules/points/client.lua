local ZONE_IN = 40.0
local ZONE_OUT = 55.0
local MAX_PLACE_DISTANCE = 20.0

local Points = {}
local Zones = {}
local Props = {}
local BadModels = {}
local placing = false
local loaded = false
local ghostEntity = nil

local PROP_IN = 80.0
local PROP_OUT = 100.0

local function removeZone(id)
    if Zones[id] then
        exports.ox_target:removeZone(Zones[id])
        Zones[id] = nil
    end
end

local function removeProp(id)
    local entity = Props[id]
    if not entity then return end
    Props[id] = nil
    if DoesEntityExist(entity) then
        exports.ox_target:removeLocalEntity(entity)
        DeleteEntity(entity)
    end
end

local function usesProp(point)
    return point.model and point.model ~= '' and not BadModels[point.model]
end

-- Loads a model, and remembers a missing one so that location falls back to an invisible point.
local function loadModel(model)
    local hash = joaat(model)
    if IsModelInCdimage(hash) and pcall(lib.requestModel, hash) then return hash end
    if not BadModels[model] then
        BadModels[model] = true
        print(('^3[%s] prop model %s could not be loaded.^7'):format(NDM.Resource, model))
    end
    return nil
end

local function interact(point)
    if point.type == 'management' then
        NDM.OpenPanel(point.venue_id)
        return
    end
    if point.type == 'stock' then
        NDM.OpenPanel(point.venue_id, 'stock')
        return
    end
    if point.type == 'register' or point.type == 'shop' then
        NDM.OpenRegister(point.id)
    elseif point.type == 'crafting' or NDM.PointTypeById[point.type].station then
        NDM.OpenCrafting(point.id)
    elseif point.type == 'sale' then
        NDM.OpenSale(point.id)
    elseif point.type == 'club_entry' then
        NDM.OpenClubEntry(point.id)
    elseif point.type == 'bar' then
        NDM.OpenBar(point.id)
    elseif point.type == 'seat' then
        NDM.Sit(point.id)
    elseif point.type == 'menu_board' then
        NDM.OpenMenuBoard(point.id)
    end
end

local function targetOptions(point)
    local definition = NDM.PointTypeById[point.type]
    if not definition or definition.noTarget then return nil end
    local options = {
        {
            name = ('ndm_business_point_%d'):format(point.id),
            icon = definition.icon,
            label = point.label,
            distance = 2.0,
            groups = not definition.public and point.job or nil,
            canInteract = function()
                if point.type == 'sale' and not point.forSale then return false end
                return not NDM.IsCarryingFor(point.venue_id)
            end,
            onSelect = function() interact(point) end,
        },
    }
    if point.type == 'stock' then
        options[#options + 1] = {
            name = ('ndm_business_deliver_%d'):format(point.id),
            icon = 'fa-solid fa-box-open',
            label = 'Deliver stock box',
            distance = 3.0,
            canInteract = function() return NDM.IsCarryingFor(point.venue_id) end,
            onSelect = function() NDM.DeliverBox() end,
        }
    end
    return options
end

local function addZone(point)
    if usesProp(point) then return end
    local options = targetOptions(point)
    if not options then return end
    Zones[point.id] = exports.ox_target:addSphereZone({
        coords = vec3(point.x, point.y, point.z),
        radius = 0.6,
        options = options,
    })
end

local function spawnProp(point)
    local hash = loadModel(point.model)
    if not hash then return end
    -- The point may have been moved or removed while the model was loading.
    if Points[point.id] ~= point or Props[point.id] then
        SetModelAsNoLongerNeeded(hash)
        return
    end

    local entity = CreateObjectNoOffset(hash, point.x, point.y, point.z, false, false, false)
    SetModelAsNoLongerNeeded(hash)
    if entity == 0 then return end
    SetEntityHeading(entity, point.heading)
    FreezeEntityPosition(entity, true)
    Props[point.id] = entity

    local options = targetOptions(point)
    if options then exports.ox_target:addLocalEntity(entity, options) end
end

local function loadPoints()
    if loaded then return end
    for _ = 1, 30 do
        local ok, rows = pcall(lib.callback.await, 'ndm_business:points:list', false)
        if ok and type(rows) == 'table' then
            for _, row in ipairs(rows) do Points[row.id] = row end
            loaded = true
            return
        end
        Wait(2000)
    end
    print(('^1[%s] could not load venue points from the server.^7'):format(NDM.Resource))
end

RegisterNetEvent('ndm_business:points:updated', function(point)
    if type(point) ~= 'table' or not point.id then return end
    removeZone(point.id)
    removeProp(point.id)
    Points[point.id] = point
end)

RegisterNetEvent('ndm_business:points:removed', function(id)
    removeZone(id)
    removeProp(id)
    Points[id] = nil
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateThread(loadPoints)
end)

CreateThread(function()
    loadPoints()
    while true do
        local coords = GetEntityCoords(cache.ped)
        local toSpawn = {}
        for id, point in pairs(Points) do
            local distance = #(coords - vec3(point.x, point.y, point.z))
            if distance <= ZONE_IN and not Zones[id] then
                addZone(point)
            elseif distance > ZONE_OUT and Zones[id] then
                removeZone(id)
            end
            if distance <= PROP_IN and usesProp(point) and not Props[id] then
                toSpawn[#toSpawn + 1] = point
            elseif distance > PROP_OUT and Props[id] then
                removeProp(id)
            end
        end
        -- Model loading yields, so it must not run while iterating over Points.
        for _, point in ipairs(toSpawn) do spawnProp(point) end
        Wait(1000)
    end
end)

local BLOCKED_CONTROLS = { 14, 15, 16, 17, 24, 25, 37, 38, 44, 140, 141, 142, 172, 173, 194, 199, 200, 257, 263 }

-- Returns coordinates and heading, or nil when the player cancels.
local function clearGhost()
    if ghostEntity and DoesEntityExist(ghostEntity) then DeleteEntity(ghostEntity) end
    ghostEntity = nil
end

local function runPlacer(startHeading, startHeightOffset, model)
    local heading = startHeading or GetEntityHeading(cache.ped)
    local heightOffset = startHeightOffset or 0.0
    local target

    if model and model ~= '' then
        local hash = loadModel(model)
        if hash then
            local start = GetEntityCoords(cache.ped)
            ghostEntity = CreateObjectNoOffset(hash, start.x, start.y, start.z - 20.0, false, false, false)
            SetModelAsNoLongerNeeded(hash)
            SetEntityAlpha(ghostEntity, 160, false)
            SetEntityCollision(ghostEntity, false, false)
            FreezeEntityPosition(ghostEntity, true)
        end
    end

    lib.showTextUI('[E] Place  \n[Scroll] Rotate  \n[Arrow Up/Down] Height  \n[Backspace] Cancel')

    while true do
        Wait(0)
        for _, control in ipairs(BLOCKED_CONTROLS) do
            DisableControlAction(0, control, true)
        end

        local hit, _, hitCoords = lib.raycast.fromCamera(17, 4, 12.0)
        if hit then target = hitCoords end

        if IsDisabledControlJustPressed(0, 15) then heading = (heading + 7.5) % 360.0 end
        if IsDisabledControlJustPressed(0, 14) then heading = (heading - 7.5) % 360.0 end
        if IsDisabledControlPressed(0, 172) then heightOffset = math.min(heightOffset + 0.01, 3.0) end
        if IsDisabledControlPressed(0, 173) then heightOffset = math.max(heightOffset - 0.01, -1.0) end

        local inRange = false
        if target then
            local point = vec3(target.x, target.y, target.z + heightOffset)
            inRange = #(GetEntityCoords(cache.ped) - point) <= MAX_PLACE_DISTANCE
            local red, green = inRange and 86 or 235, inRange and 196 or 99
            local radians = math.rad(heading)
            local forward = vec3(-math.sin(radians), math.cos(radians), 0.0)
            local tip = point + forward * 0.6
            DrawMarker(28, point.x, point.y, point.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.18, 0.18, 0.18, red, green, 132, 190, false, false, 2, false, nil, nil, false)
            DrawLine(point.x, point.y, point.z, tip.x, tip.y, tip.z, red, green, 132, 255)
            if ghostEntity then
                SetEntityCoordsNoOffset(ghostEntity, point.x, point.y, point.z, false, false, false)
                SetEntityHeading(ghostEntity, heading)
            end
        end

        if IsDisabledControlJustPressed(0, 194) then
            clearGhost()
            lib.hideTextUI()
            return nil
        end

        if IsDisabledControlJustPressed(0, 38) then
            if target and inRange then
                clearGhost()
                lib.hideTextUI()
                return vec3(target.x, target.y, target.z + heightOffset), heading
            end
            lib.notify({ type = 'error', description = 'Aim at a spot closer to you.' })
        end
    end
end

NDM.RunPlacer = runPlacer

-- Only decides whether to offer the security menu. The server checks the real permission.
function NDM.IsNearOwnClub()
    local coords = GetEntityCoords(cache.ped)
    for _, point in pairs(Points) do
        if point.venueType == 'club'
            and #(coords - vec3(point.x, point.y, point.z)) <= NDM.ClubConfig.securityRange
            and exports.qbx_core:HasGroup(point.job) then
            return true
        end
    end
    return false
end

function NDM.StartPlacement(options)
    if placing then return end
    placing = true

    CreateThread(function()
        local existing = options.pointId and Points[tonumber(options.pointId)]
        local previewModel = options.model
        if previewModel == nil and existing then previewModel = existing.model end

        -- Hide the current prop so the placement ray and preview are not blocked by it.
        local currentProp = existing and Props[existing.id]
        if currentProp then
            SetEntityVisible(currentProp, false, false)
            SetEntityCollision(currentProp, false, false)
        end

        local coords, heading = runPlacer(existing and existing.heading or nil, nil, previewModel)

        if currentProp and DoesEntityExist(currentProp) then
            SetEntityVisible(currentProp, true, false)
            SetEntityCollision(currentProp, true, true)
        end

        if coords then
            local ok, result = pcall(lib.callback.await, 'ndm_business:mgmt:savePoint', false, {
                venue = options.venue,
                pointId = options.pointId,
                type = options.type,
                label = options.label,
                model = options.model,
                x = coords.x,
                y = coords.y,
                z = coords.z,
                heading = heading,
            })
            if ok and result and result.ok then
                lib.notify({ type = 'success', description = 'Location saved.' })
            else
                lib.notify({ type = 'error', description = result and result.error or 'The server did not respond.' })
            end
        end

        placing = false
        NDM.OpenPanel(options.venue, 'points')
    end)
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if placing then lib.hideTextUI() end
    clearGhost()
    for id in pairs(Zones) do removeZone(id) end
    for id in pairs(Props) do removeProp(id) end
end)
