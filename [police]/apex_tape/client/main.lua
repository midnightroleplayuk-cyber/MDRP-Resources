local renderCustomText
local runDeployment
local renderRestLength
local renderAccess
local renderRibbonAllowance
local renderContacts
local selectedSurface
local function featurePadActive()
    if not Config.Controller.Enabled then return false end
    if type(IsUsingKeyboardAndMouse)=='function' then return not IsUsingKeyboardAndMouse(0) end
    return type(IsInputDisabled)=='function' and not IsInputDisabled(0) or false
end
local function featureControl(action)
    if featurePadActive() then return ({confirm=Config.Controller.Confirm,cancel=Config.Controller.Cancel,up=Config.Controller.HeightUp,down=Config.Controller.HeightDown,left=Config.Controller.Left,right=Config.Controller.Right})[action] end
    return ({confirm=38,cancel=177,up=Config.Placement.HeightUp,down=Config.Placement.HeightDown,left=Config.Placement.RotateLeft,right=Config.Placement.RotateRight})[action]
end
local function featurePressed(action)
    local control=featureControl(action)
    return IsDisabledControlJustPressed(0,control) or IsControlJustPressed(0,control)
end
local availableTapeStyles=Config.TapeStyles
local activeSceneId,perimeterTool,movingEndpoint,advancedPlacement
local scenePanelOpen=false
local placementHeight=Config.PostHeight
local placementSlack=1
local lastPerimeterPreset
local selectedLevelHeight
local placementHint
local snapEnabled=Config.Placement.SnapEnabled
local gridSize=Config.Placement.GridSize
local runtimeTxd,queueTapeTexture
local textureQueue={}
local freeAim = Config.FreeAim == true
local chainPlacement = Config.ChainPlacement == true
local selectedPost = false
local postObjects = {}
local selectedAnchor = nil
local selectedAnchorId = nil
local selectedAttach = nil
local selectedMirror = nil
local selectedWrap = nil
local nearbyAnchor = nil
local coneModelSet = {}
local poleBitList = {}
local anchorNameByModel = {}
local poleExcludeList = {}
local mirrorClassSet = {}
local activeTapes = {}
local tapeTextureReady = false
local tapeDict = nil
local tapeName = nil
local textureState = {}
local selectedTapeStyle = 'police'
local tapeMenuOpen = false
local menuOpenedAt = 0
local promptShown = false
local promptText = nil
local creatingTape = false
local targetRegistered = false
local tapeMode = false
local pendingCreates = {}
local nextCreateId = 1
local roadBlocks = {}
local tapeBarriers = {}
local barrierTapeByEntity = {}
local barrierBuild = nil
local barrierWanted = {}
local nextBarrierAttempt = 0
local barrierModelRequestedAt = nil
local clearAiRoadBlock
local clearAllAiRoadBlocks

local INPUT_PICKUP = 38
local INPUT_FRONTEND_CANCEL = 177

local function addNativeText(text)
    text=tostring(text or '')
    local chunk=''
    for _,cp in utf8.codes(text) do
        local char=utf8.char(cp)
        if #chunk+#char>90 then AddTextComponentSubstringPlayerName(chunk);chunk='' end
        chunk=chunk..char
    end
    if chunk~='' then AddTextComponentSubstringPlayerName(chunk) end
end

local function notify(description, nType)
    description=TapeLocale.Render(description)
    if lib and lib.notify then
        lib.notify({
            title = 'Police Tape',
            description = description,
            type = nType or 'inform',
        })
        return
    end

    BeginTextCommandThefeedPost('STRING')
    addNativeText(description)
    EndTextCommandThefeedPostTicker(false, false)
end

local function setPrompt(text)
    text=TapeLocale.Render(text)
    if TapePolishClient and TapePolishClient.prompt(text) then promptText=text;return end
    if text and featurePadActive() then text=text:gsub('%[E%]','['..Config.Controller.ConfirmLabel..']'):gsub('Backspace',Config.Controller.CancelLabel):gsub('backspace',Config.Controller.CancelLabel):gsub('Retour arrière',Config.Controller.CancelLabel):gsub('Rücktaste',Config.Controller.CancelLabel):gsub('arrows','D-pad'):gsub('flèches','D-pad'):gsub('Pfeile','D-pad') end
    if text == promptText then
        return
    end

    promptText = text

    if not text then
        if promptShown and lib and lib.hideTextUI then
            lib.hideTextUI()
        end
        promptShown = false
        return
    end

    if lib and lib.showTextUI then
        lib.showTextUI(text, {
            position = 'right-center',
            icon = 'fa-solid fa-link',
        })
        promptShown = true
    end
end

local function drawNativePrompt()
    if not promptText then
        return
    end

    if TapePolishClient and TapePolishClient.largePrompt() then return end
    if lib and lib.showTextUI then
        return
    end

    BeginTextCommandDisplayHelp('STRING')
    addNativeText(promptText)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

local function awaitServer(eventName, ...)
    local requestId = nextCreateId
    nextCreateId = nextCreateId + 1

    local result
    local done = false
    pendingCreates[requestId] = function(res)
        result = res
        done = true
    end

    TriggerServerEvent(eventName, requestId, ...)

    local timeout = GetGameTimer() + 5000
    while not done and GetGameTimer() < timeout do
        Wait(0)
    end

    pendingCreates[requestId] = nil
    return result
end

local function buildAnchorLookups()
    coneModelSet = {}
    for _, name in ipairs(Config.ConeModels or {}) do
        coneModelSet[joaat(name)] = true
    end

    poleBitList = {}
    for _, bit in ipairs(Config.PoleNameBits or {}) do
        poleBitList[#poleBitList + 1] = string.lower(bit)
    end

    poleExcludeList = {}
    for _, bit in ipairs(Config.PoleNameExclude or {}) do
        poleExcludeList[#poleExcludeList + 1] = string.lower(bit)
    end

    -- Match configured names by hash. The archetype-name native can throw
    -- inside the engine for streamed map objects, even inside Lua pcall.
    anchorNameByModel = {}
    local function addName(name)
        if type(name)=='string' then anchorNameByModel[joaat(name)]=name:lower() end
    end
    for _,name in ipairs(TapeAnchorModels or {}) do addName(name) end
    for _,name in ipairs(Config.PoleModels or {}) do addName(name) end
    if type(GetAllVehicleModels)=='function' then
        for _,name in ipairs(GetAllVehicleModels()) do addName(name) end
    end

    mirrorClassSet = {}
    local classes = (Config.Mirror and Config.Mirror.classes) or {}
    for i = 1, #classes do
        mirrorClassSet[tonumber(classes[i])] = true
    end
end

local function barrierTapeId(entity)
    if not entity or entity == 0 then
        return nil
    end

    local tapeId = barrierTapeByEntity[entity]
    if not tapeId then
        return nil
    end

    -- A deleted barrier handle can be reused. Only trust it while it is still our invisible prop.
    if not DoesEntityExist(entity) or GetEntityAlpha(entity) ~= 0 then
        barrierTapeByEntity[entity] = nil
        return nil
    end

    return tapeId
end

local function entityArchetypeName(entity)
    if not entity or entity==0 or barrierTapeId(entity) or not DoesEntityExist(entity) then return '' end
    local ok,model=pcall(GetEntityModel,entity)
    return ok and anchorNameByModel[model] or ''
end

-- GET_ENTITY_MODEL (0x9F47B058362C84B5) throws inside gta-streaming-five when the
-- entity still exists but its archetype was released. Invisible tape barriers do this
-- after a few placements, and ox_target then crashes in isConeEntity.
local function safeEntityModel(entity)
    if not entity or entity == 0 or barrierTapeId(entity) or not DoesEntityExist(entity) then
        return nil
    end

    local okType, entityType = pcall(GetEntityType, entity)
    if not okType or (entityType ~= 1 and entityType ~= 2 and entityType ~= 3) then
        return nil
    end

    local ok, model = pcall(GetEntityModel, entity)
    if not ok or type(model) ~= 'number' or model == 0 then
        return nil
    end

    return model
end

local function isConeEntity(entity)
    local model = safeEntityModel(entity)
    if not model then
        return false
    end

    return coneModelSet[model] == true
end

local function isPoleEntity(entity)
    if not entity or entity == 0 or barrierTapeId(entity) or not DoesEntityExist(entity) then
        return false
    end

    if isConeEntity(entity) or IsEntityAVehicle(entity) then
        return false
    end

    local model=safeEntityModel(entity)
    for _,custom in ipairs(Config.PoleModels or {}) do if model==joaat(custom) then return true end end
    local name = entityArchetypeName(entity)
    if name == '' then
        return false
    end

    for i = 1, #poleExcludeList do
        if name:find(poleExcludeList[i], 1, true) then
            return false
        end
    end

    for i = 1, #poleBitList do
        if name:find(poleBitList[i], 1, true) then
            return true
        end
    end

    return false
end

local function isTapeAnchor(entity)
    return isConeEntity(entity) or isPoleEntity(entity)
end

local function safeModelDimensions(entity)
    local model = safeEntityModel(entity)
    local minDim, maxDim
    local ok = model and pcall(function()
        minDim, maxDim = GetModelDimensions(model)
    end)
    if not ok or not maxDim then
        return vector3(-0.2, -0.2, 0.0), vector3(0.2, 0.2, 3.0)
    end
    return minDim, maxDim
end

local function getStomachZ()
    local ped = PlayerPedId()
    local bone = Config.StomachBone or 24817
    local coords = GetPedBoneCoords(ped, bone, 0.0, 0.0, 0.0)
    if coords and coords.z and coords.z ~= 0.0 then
        return coords.z
    end

    return GetEntityCoords(ped).z + 1.0
end

local function getConeAttachPoint(entity)
    local _, maxDim = safeModelDimensions(entity)
    local zOff = tonumber(maxDim and maxDim.z) or 0.6
    if zOff < 0.35 then
        zOff = 0.55
    elseif zOff > 1.6 then
        zOff = 1.6
    end
    return GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, zOff)
end

local function getPoleAttachPoint(entity, storedZ)
    local minDim, maxDim = safeModelDimensions(entity)
    local bottom = GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, minDim and minDim.z or 0.0)
    local top = GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, maxDim and maxDim.z or 1.0)
    local lo = math.min(bottom.z, top.z) + 0.2
    local hi = math.max(bottom.z, top.z) - 0.05
    if hi < lo then
        hi = lo
    end

    local z = storedZ or getStomachZ()
    z = math.max(lo, math.min(hi, z))
    local pos = GetEntityCoords(entity)
    return vector3(pos.x, pos.y, z)
end

local function usableWrap(value)
    value = tonumber(value)
    if not value or value ~= value or value < 0.04 or value > 0.45 then
        return nil
    end
    return value
end

-- Street lights and sign boards have a wide model box because of the arm or the board.
-- The post itself is at the entity origin, so a wide box still gets a shaft-sized band.
local function poleWrapRadius(entity)
    local cfg = Config.PoleWrap or {}
    local minRadius = tonumber(cfg.minRadius) or 0.032
    local maxRadius = tonumber(cfg.maxRadius) or 0.055
    local padding = tonumber(cfg.padding) or 0.004
    local thinSpan = tonumber(cfg.thinSpan) or 0.14
    local wideRadius = tonumber(cfg.wideRadius) or 0.042

    local minDim, maxDim = safeModelDimensions(entity)
    local sx = math.abs((maxDim.x or 0.2) - (minDim.x or -0.2))
    local sy = math.abs((maxDim.y or 0.2) - (minDim.y or -0.2))
    local minSpan = math.min(sx, sy)

    local radius = wideRadius
    if minSpan <= thinSpan then
        radius = (minSpan * 0.5) + padding
    end

    if radius < minRadius then
        radius = minRadius
    elseif radius > maxRadius then
        radius = maxRadius
    end

    return radius
end

local function getAttachPoint(entity, storedZ)
    if isConeEntity(entity) then
        return getConeAttachPoint(entity)
    end

    return getPoleAttachPoint(entity, storedZ)
end

local function getAnchorId(entity)
    local networked = false
    pcall(function()
        networked = NetworkGetEntityIsNetworked(entity) == true
    end)

    if networked then
        local netId = 0
        pcall(function()
            netId = NetworkGetNetworkIdFromEntity(entity)
        end)
        if netId and netId ~= 0 then
            return ('net:%s'):format(netId)
        end
    end

    local coords = GetEntityCoords(entity)
    local model = safeEntityModel(entity) or 0
    return ('local:%s:%.2f:%.2f:%.2f'):format(model, coords.x, coords.y, coords.z)
end

local function resolveAnchor(anchorId)
    if type(anchorId) ~= 'string' then
        return 0, nil
    end

    local netId, side = anchorId:match('^net:(%d+):([LR])$')
    if not netId then
        netId = anchorId:match('^net:(%d+)$')
        side = nil
    end

    if not netId then
        return 0, nil
    end

    local entity = 0
    local idNum = tonumber(netId)
    pcall(function()
        entity = NetworkGetEntityFromNetworkId(idNum)
    end)

    if entity and entity ~= 0 and DoesEntityExist(entity) then
        return entity, side
    end

    return 0, side
end

local function poleFootprint(entity)
    local minDim, maxDim = safeModelDimensions(entity)
    local sx = math.abs((maxDim and maxDim.x or 0.25) - (minDim and minDim.x or -0.25))
    local sy = math.abs((maxDim and maxDim.y or 0.25) - (minDim and minDim.y or -0.25))
    return math.max(sx, sy)
end

local function xyDistance(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    return math.sqrt(dx * dx + dy * dy)
end

local function isFiniteVec(v)
    return v
        and v.x == v.x and v.y == v.y and v.z == v.z
        and math.abs(v.x) < 20000.0
        and math.abs(v.y) < 20000.0
        and math.abs(v.z) < 2500.0
end

local function vec3(tbl)
    return vector3(tbl.x + 0.0, tbl.y + 0.0, tbl.z + 0.0)
end

local function isTapeVehicle(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) or not IsEntityAVehicle(entity) then
        return false
    end

    if mirrorClassSet[GetVehicleClass(entity)] ~= true then
        return false
    end

    local name = entityArchetypeName(entity)
    if name:find('trailer', 1, true) or name:find('tanker', 1, true) then
        return false
    end

    return true
end

local function doorHingeLocalY(entity, side)
    local boneName = side == 'R' and 'door_pside_f' or 'door_dside_f'
    local index = GetEntityBoneIndexByName(entity, boneName)
    if not index or index < 0 then
        return nil
    end

    local bonePos = GetWorldPositionOfEntityBone(entity, index)
    if not isFiniteVec(bonePos) then
        return nil
    end

    local localPos = GetOffsetFromEntityGivenWorldCoords(entity, bonePos.x, bonePos.y, bonePos.z)
    if not localPos or localPos.y ~= localPos.y then
        return nil
    end

    return localPos.y
end

local function getMirrorAttachPoint(entity, side)
    local minDim, maxDim = safeModelDimensions(entity)
    local cfg = Config.Mirror or {}
    local length = math.abs((maxDim.y or 1.2) - (minDim.y or -1.2))
    local height = math.abs((maxDim.z or 1.2) - (minDim.z or -0.4))
    if height < 0.4 then
        height = 0.4
    end

    local back = tonumber(cfg.backFromFront) or 0.30
    if length > 7.0 then
        back = math.min(back, 0.16)
    elseif length > 5.5 then
        back = math.min(back, 0.22)
    end

    local y = (maxDim.y or 0.8) - (length * back)
    local hingeY = doorHingeLocalY(entity, side)
    local frontZone = (maxDim.y or 1.0) - (length * 0.45)
    if hingeY and hingeY >= frontZone then
        -- The front door hinge is the A-pillar, which is where the wing mirror is mounted.
        y = hingeY + 0.06
    end
    local yMin = (minDim.y or -1.0) + 0.12
    local yMax = (maxDim.y or 1.0) - 0.12
    if y < yMin then
        y = yMin
    elseif y > yMax then
        y = yMax
    end

    local inset = tonumber(cfg.sideInset) or 0.22
    local x
    if side == 'R' then
        x = (maxDim.x or 0.8) - inset
    else
        x = (minDim.x or -0.8) + inset
    end

    local fraction = tonumber(cfg.heightFraction) or 0.72
    local z = (minDim.z or 0.0) + (height * fraction)
    local zMin = (minDim.z or 0.0) + (height * 0.42)
    local zMax = (maxDim.z or z) - (height * 0.08)
    if zMax < zMin then
        zMax = zMin
    end
    if z < zMin then
        z = zMin
    elseif z > zMax then
        z = zMax
    end

    return GetOffsetFromEntityInWorldCoords(entity, x, y, z)
end

local function getMirrorAnchorId(entity, side)
    local networked = false
    pcall(function()
        networked = NetworkGetEntityIsNetworked(entity) == true
    end)

    if networked then
        local netId = 0
        pcall(function()
            netId = NetworkGetNetworkIdFromEntity(entity)
        end)
        if netId and netId ~= 0 then
            return ('net:%s:%s'):format(netId, side)
        end
    end

    local coords = GetEntityCoords(entity)
    local model = safeEntityModel(entity) or 0
    return ('local:%s:%.2f:%.2f:%.2f:%s'):format(model, coords.x, coords.y, coords.z, side)
end

local function nearestMirrorAnchor(playerCoords)
    local cfg = Config.Mirror or {}
    local mirrorRange = tonumber(cfg.interactDistance) or 2.15
    local scan = tonumber(cfg.scanDistance) or 14.0
    local best, bestDist
    local vehicles = GetGamePool('CVehicle')

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if isTapeVehicle(vehicle) and xyDistance(playerCoords, GetEntityCoords(vehicle)) <= scan then
            for sideIndex = 1, 2 do
                local side = sideIndex == 1 and 'L' or 'R'
                local attach = getMirrorAttachPoint(vehicle, side)
                if isFiniteVec(attach) then
                    local dist = #(playerCoords - attach)
                    if dist <= mirrorRange and (not bestDist or dist < bestDist) then
                        best = {
                            entity = vehicle,
                            id = getMirrorAnchorId(vehicle, side),
                            coords = attach,
                            attach = attach,
                            distance = dist,
                            isCone = false,
                            mirrorSide = side,
                        }
                        bestDist = dist
                    end
                end
            end
        end
    end

    return best
end

local function currentAttachPoint(entity, mirrorSide, storedZ)
    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return nil, nil
    end

    if mirrorSide == 'L' or mirrorSide == 'R' then
        local pos = getMirrorAttachPoint(entity, mirrorSide)
        if isFiniteVec(pos) then
            return pos, nil
        end
        return nil, nil
    end

    local pos = getAttachPoint(entity, storedZ)
    if isPoleEntity(entity) then
        return pos, poleWrapRadius(entity)
    end

    return pos, nil
end

local function refreshSelectedAttach()
    if selectedAnchor and DoesEntityExist(selectedAnchor) then
        local pos, wrap = currentAttachPoint(selectedAnchor, selectedMirror, selectedAttach and selectedAttach.z)
        if pos then
            selectedAttach = pos
            selectedWrap = wrap
        end
    end

    return selectedAttach, selectedWrap
end

local function findNearestAnchor(playerCoords, range)
    if next(coneModelSet) == nil and #poleBitList == 0 then
        buildAnchorLookups()
    end

    local cones = {}
    local poles = {}
    local objects = GetGamePool('CObject')
    local clusterRadius = Config.PoleClusterRadius or 2.2

    for i = 1, #objects do
        local entity = objects[i]
        if entity and entity ~= 0 and not barrierTapeId(entity) and DoesEntityExist(entity) then
            local coords = GetEntityCoords(entity)
            local dist = xyDistance(playerCoords, coords)
            if dist <= range then
                if isConeEntity(entity) then
                    cones[#cones + 1] = {
                        entity = entity,
                        id = getAnchorId(entity),
                        coords = coords,
                        attach = getConeAttachPoint(entity),
                        distance = dist,
                        isCone = true,
                    }
                elseif isPoleEntity(entity) then
                    poles[#poles + 1] = {
                        entity = entity,
                        id = getAnchorId(entity),
                        coords = coords,
                        attach = getPoleAttachPoint(entity),
                        distance = dist,
                        footprint = poleFootprint(entity),
                        wrap = poleWrapRadius(entity),
                        isCone = false,
                    }
                end
            end
        end
    end

    -- One attachment point per pole: collapse light heads, signs and boxes on the same post.
    local used = {}
    local polePoints = {}
    for i = 1, #poles do
        if not used[i] then
            local group = { poles[i] }
            used[i] = true
            for j = i + 1, #poles do
                if not used[j] and xyDistance(poles[i].coords, poles[j].coords) <= clusterRadius then
                    used[j] = true
                    group[#group + 1] = poles[j]
                end
            end

            local best = group[1]
            for g = 2, #group do
                local item = group[g]
                if item.footprint < best.footprint - 0.05
                    or (math.abs(item.footprint - best.footprint) <= 0.05 and item.distance < best.distance)
                then
                    best = item
                end
            end

            best.attach = getPoleAttachPoint(best.entity)
            best.wrap = poleWrapRadius(best.entity)
            best.distance = xyDistance(playerCoords, best.coords)
            polePoints[#polePoints + 1] = best
        end
    end

    local best, bestDist
    for i = 1, #cones do
        if not bestDist or cones[i].distance < bestDist then
            best = cones[i]
            bestDist = cones[i].distance
        end
    end
    for i = 1, #polePoints do
        if not bestDist or polePoints[i].distance < bestDist then
            best = polePoints[i]
            bestDist = polePoints[i].distance
        end
    end

    local mirror = nearestMirrorAnchor(playerCoords)
    if mirror and (not bestDist or mirror.distance < bestDist) then
        best = mirror
    end

    return best, polePoints
end

local hotbarTapeEquipped = false
local nextHotbarCheck = 0

local function hasTapeItemEquipped()
    local now = GetGameTimer()
    if now < nextHotbarCheck then
        return hotbarTapeEquipped
    end
    nextHotbarCheck = now + 250

    local itemName = Config.Item
    if type(itemName) ~= 'string' or itemName == '' then
        hotbarTapeEquipped = false
        return false
    end

    if GetResourceState('APEX_Inventory') ~= 'started' then
        hotbarTapeEquipped = false
        return false
    end

    local ok, name = pcall(function()
        return exports.APEX_Inventory:GetActiveHotbarItem()
    end)

    hotbarTapeEquipped = ok and name == itemName
    return hotbarTapeEquipped
end

local function isTapeModeActive()
    return tapeMode == true or hasTapeItemEquipped()
end

local inventoryOpen = false
local nextInventoryCheck = 0

local function isBlocked()
    if TapeAccessClient and TapeAccessClient.holding() then return true end
    local ped = PlayerPedId()
    if IsEntityDead(ped) or IsPauseMenuActive() or IsPedInAnyVehicle(ped, false) then
        return true
    end

    if GetResourceState('APEX_Inventory') == 'started' then
        local now = GetGameTimer()
        if now >= nextInventoryCheck then
            nextInventoryCheck = now + 200
            local ok, open = pcall(function()
                return exports.APEX_Inventory:IsInventoryOpen()
            end)
            inventoryOpen = ok and open == true
        end
        if inventoryOpen then
            return true
        end
    end

    if IsNuiFocused and IsNuiFocused() then
        return true
    end

    return false
end

local function playerCanUseTape()
    return awaitServer('apex_policetape:canUse') == true
end

local function requestCreateTape(payload)
    payload.slack=placementSlack
    local ok,ticket=runDeployment('place',payload.b)
    if not ok then return {success=false,error='Deployment cancelled.'} end
    payload.ticket=ticket
    return awaitServer('apex_policetape:create', payload)
end

local function normalizeTapeStyle(style)
    local styles = Config.TapeStyles or {}
    if type(style) == 'string' and styles[style] then
        return style
    end
    return 'police'
end

local function styleTileLength(style)
    local ribbon = Config.Ribbon or {}
    local height = tonumber(ribbon.height) or 0.075
    if renderCustomText then return height*16.0 end
    local styleCfg = (Config.TapeStyles or {})[normalizeTapeStyle(style)] or {}
    local aspect = tonumber(styleCfg.aspect)
    if aspect and aspect > 1.0 then
        return height * aspect
    end
    return tonumber(styleCfg.tileLength) or tonumber(ribbon.tileLength) or 1.48
end

local function styleTexture(style)
    if renderCustomText and TapeCustomTextClient then return TapeCustomTextClient.texture(renderCustomText) end
    style=normalizeTapeStyle(style)
    local entry = textureState[style]
    if entry then entry.lastUsed=GetGameTimer() elseif queueTapeTexture then queueTapeTexture(style) end
    if entry and entry.ready and entry.dict and entry.name then
        return entry.dict, entry.name
    end

    local police = textureState.police
    if police and police.ready and police.dict and police.name then
        return police.dict, police.name
    end

    return nil, nil
end

local textureFailureReported=false
local function loadTapeStyleTexture(txd, dictName, style)
    local cfg=Config.TapeStyles[style] or {}
    local name=style..'_tape'
    local path=cfg.image or ('textures/'..style..'.png')
    local image=TapeImageData and TapeImageData[style] or path
    local ok,handle=pcall(CreateRuntimeTextureFromImage,txd,name,image)
    local ready=ok and handle~=nil and handle~=false and handle~=0
    textureState[style]={dict=dictName,name=name,ready=ready,static=true,lastUsed=GetGameTimer()}
    if not ready and not textureFailureReported then
        textureFailureReported=true
        print('[APEX Tape] A tape texture could not load. Check the installation; /'..TapeCommands.name('tapediag')..' lists failed designs. Further texture warnings are suppressed this session.')
    end
    return ready
end

local function ensureTapeTexture()
    if tapeTextureReady and tapeDict and tapeName then
        return true
    end

    local dictName = 'apex_policetape_txd'
    local txd = CreateRuntimeTxd(dictName)
    runtimeTxd=txd
    local anyOk = false

    for style in pairs(Config.TapeStyles or {}) do
        if (not Config.Performance.LazyTextures or style=='police') and loadTapeStyleTexture(txd, dictName, style) then
            anyOk = true
        end
    end

    tapeDict = dictName
    tapeName = 'police_tape'
    tapeTextureReady = true -- geometry still draws a solid fallback if an asset is missing
    return tapeTextureReady
end

local function lerpVec(a, b, t)
    return vector3(
        a.x + (b.x - a.x) * t,
        a.y + (b.y - a.y) * t,
        a.z + (b.z - a.z) * t
    )
end

-- DrawSpritePoly crashes the client once a frame submits too many triangles.
-- Three ribbons sampled every 0.4m and drawn double-sided crossed that limit.
-- Placed tape and the placement preview have separate budgets so aiming at the
-- next point cannot spend the triangles that deployed tape needs.
local TAPE_POLY_BUDGET = {
    placed = math.min(360,math.max(40,Config.Performance.PlacedPolyBudget)),
    preview = math.min(140,math.max(20,Config.Performance.PreviewPolyBudget)),
}
local tapePolyFrame = -1
local tapePolysLeft = {
    placed = 0,
    preview = 0,
}
local tapeViewFrame = -1
local tapeViewPos = vector3(0.0, 0.0, 0.0)
local tapeViewFwd = vector3(0.0, 1.0, 0.0)

local function tapeCameraView()
    local frame = GetFrameCount()
    if frame ~= tapeViewFrame then
        tapeViewFrame = frame
        tapeViewPos = GetGameplayCamCoord()
        local rot = GetGameplayCamRot(2)
        local yaw = math.rad(rot.z)
        local pitch = math.rad(rot.x)
        local horizontal = math.abs(math.cos(pitch))
        tapeViewFwd = vector3(-math.sin(yaw) * horizontal, math.cos(yaw) * horizontal, math.sin(pitch))
    end

    return tapeViewPos, tapeViewFwd
end

-- Wide on purpose. A tight frustum test pops tape as the camera turns, because
-- DrawSpritePoly drops a whole triangle once any corner leaves the view.
local function tapePointInView(pos)
    if not isFiniteVec(pos) then
        return false
    end

    local camPos, camFwd = tapeCameraView()
    local dx = pos.x - camPos.x
    local dy = pos.y - camPos.y
    local dz = pos.z - camPos.z
    local distSq = (dx * dx) + (dy * dy) + (dz * dz)
    if distSq < (22.0 * 22.0) then
        return true
    end

    local dist = math.sqrt(distSq)
    if dist < 0.001 then
        return true
    end

    local dot = ((dx * camFwd.x) + (dy * camFwd.y) + (dz * camFwd.z)) / dist
    return dot > -0.55
end

local function reserveTapePolys(count, channel)
    channel = channel == 'preview' and 'preview' or 'placed'
    local frame = GetFrameCount()
    if frame ~= tapePolyFrame then
        tapePolyFrame = frame
        tapePolysLeft.placed = TAPE_POLY_BUDGET.placed
        tapePolysLeft.preview = TAPE_POLY_BUDGET.preview
    end

    if tapePolysLeft[channel] < count then
        return false
    end

    tapePolysLeft[channel] = tapePolysLeft[channel] - count
    return true
end

local function drawTapeSegmentUV(a, b, halfHeight, u0, u1, dict, tex, alpha, channel)
    if not reserveTapePolys(4, channel) then
        return false
    end

    local ax, ay, az = a.x, a.y, a.z
    local bx, by, bz = b.x, b.y, b.z
    local aTop, aBot = az + halfHeight, az - halfHeight
    local bTop, bBot = bz + halfHeight, bz - halfHeight

    -- Both windings share one viewer-oriented UV mapping. This stays visible
    -- with either cull mode without opposite faces overwriting readable text.
    local camera=GetGameplayCamCoord()
    local left=(camera.x-(ax+bx)*.5)*(-(by-ay))+(camera.y-(ay+by)*.5)*(bx-ax)>=0
    local ua,ub=left and (1-u0) or u0,left and (1-u1) or u1
    local function triangle(x1,y1,z1,x2,y2,z2,x3,y3,z3,ta,va,tb,vb,tc,vc)
        if dict and tex and type(DrawTexturedPoly)=='function' then
            DrawTexturedPoly((x1+0.0),(y1+0.0),(z1+0.0),(x2+0.0),(y2+0.0),(z2+0.0),(x3+0.0),(y3+0.0),(z3+0.0),255,255,255,alpha,dict,tex,(ta+0.0),(va+0.0),1.0,(tb+0.0),(vb+0.0),1.0,(tc+0.0),(vc+0.0),1.0)
        else DrawPoly(x1,y1,z1,x2,y2,z2,x3,y3,z3,245,210,35,alpha) end
    end
    triangle(ax,ay,aTop,bx,by,bTop,ax,ay,aBot,ua,0,ub,0,ua,1)
    triangle(bx,by,bTop,bx,by,bBot,ax,ay,aBot,ub,0,ub,1,ua,1)
    triangle(bx,by,bTop,ax,ay,aTop,bx,by,bBot,ub,0,ua,0,ub,1)
    triangle(ax,ay,aTop,ax,ay,aBot,bx,by,bBot,ua,0,ua,1,ub,1)
    return true
end

local function emitTiledSegment(a, b, d0, d1, tileLength, halfHeight, dict, tex, alpha, channel)
    if not tileLength or tileLength < 0.05 then
        tileLength = 1.48
    end

    local span = d1 - d0
    if span < 0.001 or span ~= span then
        return true
    end

    local start = d0
    local guard = 0
    while start < (d1 - 0.0001) and guard < 64 do
        guard = guard + 1
        local tileIndex = math.floor((start / tileLength) + 0.000001)
        local tileEnd = (tileIndex + 1) * tileLength
        local stop = math.min(d1, tileEnd)
        if stop <= start + 0.0001 then
            start = start + 0.002
        else
            local t0 = (start - d0) / span
            local t1 = (stop - d0) / span
            local u0 = (start / tileLength) - tileIndex
            local u1 = (stop / tileLength) - tileIndex
            if u0 < 0.0 then u0 = 0.0 end
            if u1 > 1.0 then u1 = 1.0 end
            if not drawTapeSegmentUV(lerpVec(a, b, t0), lerpVec(a, b, t1), halfHeight, u0, u1, dict, tex, alpha, channel) then
                return false
            end
            start = stop
        end
    end

    return true
end

local function drawTapeRibbon(posA, posB, style, channel)
    local dict, tex = styleTexture(style)
    if not tapeTextureReady then
        return
    end
    if not isFiniteVec(posA) or not isFiniteVec(posB) then
        return
    end

    local span = #(posB - posA)
    if span ~= span or span < 0.05 or span > ((Config.MaxDistance or 30.0)*math.max(1,Config.Tension.MaxStretch)+Config.Access.LiftHeight*2) then
        return
    end

    local cfg = Config.Ribbon or {}
    local alpha = cfg.alpha or 255
    local halfHeight = (cfg.height or 0.075) * 0.5
    local tileLength = styleTileLength(style)
    local cameraDistance=#(GetGameplayCamCoord()-(posA+posB)*0.5)
    if channel=='placed' and cameraDistance>Config.Performance.FarLodDistance then tileLength=tileLength*math.max(1,Config.Performance.FarStepMultiplier) end
    if not tileLength or tileLength < 0.05 then
        tileLength = 1.48
    end

    -- One repeat per tile length. Capping the ribbon at a handful of quads
    -- stretched that same artwork across the whole span.
    local steps = math.ceil(span / tileLength)
    if steps < 1 then
        steps = 1
    elseif steps > 64 then
        steps = 64
    end

    local sag = TapeSceneTools.sag(span,channel=='preview' and span*placementSlack or renderRestLength)
    local windCfg=Config.Wind
    local windAmp=0.0
    local windSpeed=windCfg.Speed
    local windDirection=vector3(1,0,0)
    if windCfg.Enabled and cameraDistance<=windCfg.Distance then
        local speed=windCfg.WeatherDriven and math.min(GetWindSpeed(),windCfg.MaxWeatherSpeed) or windCfg.IdleSpeed
        windAmp=windCfg.Amplitude*windCfg.Strength*(math.max(speed,windCfg.IdleSpeed)/3.0)
        if windCfg.WeatherDriven then windDirection=GetWindDirection() end
    end
    local now = GetGameTimer() / 1000.0
    local delta = posB - posA
    local perp = vector3(-delta.y, delta.x, 0.0)
    local perpLen = #perp
    if perpLen > 0.001 then
        perp = perp / perpLen
    else
        perp = vector3(1.0, 0.0, 0.0)
    end

    local function basePointAt(t)
        local base = lerpVec(posA, posB, t)
        local belly = 4.0 * t * (1.0 - t)
        local wind = 0.0
        local windZ = 0.0
        if belly > 0.0 then
            local gust=1.0+windCfg.GustStrength*math.sin(now*windCfg.GustSpeed+posA.x*0.02)
            local across=windDirection.x*perp.x+windDirection.y*perp.y
            wind = (across*0.6+math.sin((now * windSpeed) + (t * 6.8))*0.4) * windAmp * belly*gust
            windZ = math.sin((now * windSpeed * 0.82) + (t * 4.2)) * windAmp * windCfg.VerticalRatio * belly*gust
        end

        return vector3(
            base.x + (perp.x * wind),
            base.y + (perp.y * wind),
            base.z - (sag * belly) + windZ
        )
    end

    local function pointAt(t)
        local point=basePointAt(t)
        if renderAccess then
            local f=renderAccess.fraction
            local lineBase=lerpVec(posA,posB,f)
            local natural=basePointAt(f)
            local displacement=(renderAccess.grip-lineBase)-(natural-lineBase)*renderAccess.amount
            local weight=t<=f and t/f or (1-t)/(1-f)
            point=point+displacement*math.max(0,weight)
        end
        if renderContacts then
            local displacement=vector3(0,0,0)
            local total=0
            for _,contact in ipairs(renderContacts) do
                local weight=TapeContactMath.weight(t,contact.fraction,contact.width,span)
                displacement=displacement+vector3(contact.x,contact.y,contact.z)*weight
                total=total+weight
            end
            point=point+displacement/math.max(1,total)
        end
        return point
    end

    local pieces = {}
    local prev = pointAt(0.0)
    local travelled = 0.0
    local camPos = tapeCameraView()
    local maxQuads=math.max(1,math.floor((renderRibbonAllowance or TAPE_POLY_BUDGET[channel=='preview' and 'preview' or 'placed'])/4))
    steps=math.min(steps,maxQuads)
    local samples={}
    for i=1,steps do samples[#samples+1]=i/steps end
    if renderAccess then samples[#samples+1]=renderAccess.fraction;table.sort(samples) end
    if renderContacts then
        for _,contact in ipairs(renderContacts) do
            for _,offset in ipairs({-1,-.35,0,.35,1}) do samples[#samples+1]=math.max(0,math.min(1,contact.fraction+offset*contact.width/span)) end
        end
        table.sort(samples)
    end
    if #samples>maxQuads then
        local reduced={}
        for i=1,maxQuads do reduced[#reduced+1]=samples[math.ceil(i*#samples/maxQuads)] end
        samples=reduced
    end
    if renderAccess and maxQuads>=2 then
        local found=false;for _,f in ipairs(samples)do if math.abs(f-renderAccess.fraction)<.0001 then found=true end end
        if not found then samples[1]=renderAccess.fraction;table.sort(samples) end
    end
    for _,sample in ipairs(samples) do
        local point = pointAt(sample)
        local edge = #(point - prev)
        if edge > 0.0001 then
            local mid = (prev + point) * 0.5
            if tapePointInView(prev) or tapePointInView(point) or tapePointInView(mid) then
                pieces[#pieces + 1] = {
                    a = prev,
                    b = point,
                    d0 = travelled,
                    d1 = travelled + edge,
                    dist = #(mid - camPos),
                }
            end
            travelled = travelled + edge
        end
        prev = point
    end

    table.sort(pieces, function(a, b)
        return a.dist < b.dist
    end)

    local estimated=0
    for _,piece in ipairs(pieces)do estimated=estimated+math.ceil((piece.d1-piece.d0)/tileLength)+1 end
    local coarse=estimated>maxQuads
    for i = 1, #pieces do
        local piece = pieces[i]
        if coarse then
            if not drawTapeSegmentUV(piece.a,piece.b,halfHeight,0,1,dict,tex,alpha,channel) then return end
        elseif not emitTiledSegment(piece.a, piece.b, piece.d0, piece.d1, tileLength, halfHeight, dict, tex, alpha, channel) then
            return
        end
    end
end

local function pullToWrapSurface(center, toward, radius)
    if not radius or not isFiniteVec(center) or not isFiniteVec(toward) then
        return center
    end

    local dx = toward.x - center.x
    local dy = toward.y - center.y
    local len = math.sqrt((dx * dx) + (dy * dy))
    local contact = math.max(0.02, radius - 0.008)
    if len < 0.001 or contact >= len - 0.02 then
        return center
    end

    return vector3(
        center.x + (dx / len) * contact,
        center.y + (dy / len) * contact,
        center.z
    )
end

local function drawTapeRing(center, radius, awayFrom, style, channel)
    local dict, tex = styleTexture(style)
    if not tapeTextureReady then
        return
    end
    if not isFiniteVec(center) or not radius or not tapePointInView(center) then
        return
    end

    local cfg = Config.Ribbon or {}
    local wrapCfg = Config.PoleWrap or {}
    local alpha = cfg.alpha or 255
    local halfHeight = (cfg.height or 0.075) * 0.5
    local tileLength = styleTileLength(style)
    local segments = tonumber(wrapCfg.segments) or 6
    if segments < 4 then
        segments = 4
    elseif segments > 6 then
        segments = 6
    end

    local start = math.pi
    if awayFrom and isFiniteVec(awayFrom) then
        local dx = awayFrom.x - center.x
        local dy = awayFrom.y - center.y
        if (dx * dx + dy * dy) > 0.0001 then
            start = math.atan(dy, dx) + math.pi
        end
    end

    local travelled = 0.0
    local prev = vector3(
        center.x + (math.cos(start) * radius),
        center.y + (math.sin(start) * radius),
        center.z
    )

    for i = 1, segments do
        local angle = start + ((i / segments) * (math.pi * 2.0))
        local point = vector3(
            center.x + (math.cos(angle) * radius),
            center.y + (math.sin(angle) * radius),
            center.z
        )
        local edge = #(point - prev)
        if edge > 0.0001 then
            if not emitTiledSegment(prev, point, travelled, travelled + edge, tileLength, halfHeight, dict, tex, alpha, channel) then
                return
            end
            travelled = travelled + edge
        end
        prev = point
    end
end

local function clampWrapRadius(radius)
    if not radius then
        return nil
    end

    local cfg = Config.PoleWrap or {}
    local minRadius = tonumber(cfg.minRadius) or 0.032
    local maxRadius = tonumber(cfg.maxRadius) or 0.055
    if radius < minRadius then
        radius = minRadius
    elseif radius > maxRadius then
        radius = maxRadius
    end
    return radius
end

local function drawTapeSpan(posA, posB, wrapA, wrapB, drawnWraps, style, part, channel)
    local dict, tex = styleTexture(style)
    if not tapeTextureReady then
        return
    end

    wrapA = clampWrapRadius(usableWrap(wrapA))
    wrapB = clampWrapRadius(usableWrap(wrapB))
    if not isFiniteVec(posA) or not isFiniteVec(posB) then
        return
    end

    if part ~= 'wrap' then
        drawTapeRibbon(pullToWrapSurface(posA, posB, wrapA), pullToWrapSurface(posB, posA, wrapB), style, channel)
    end

    if part == 'ribbon' then
        return
    end

    if wrapA then
        local key = ('%.2f:%.2f:%.2f'):format(posA.x, posA.y, posA.z)
        if not drawnWraps or not drawnWraps[key] then
            if drawnWraps then
                drawnWraps[key] = true
            end
            drawTapeRing(posA, wrapA, posB, style, channel)
        end
    end

    if wrapB then
        local key = ('%.2f:%.2f:%.2f'):format(posB.x, posB.y, posB.z)
        if not drawnWraps or not drawnWraps[key] then
            if drawnWraps then
                drawnWraps[key] = true
            end
            drawTapeRing(posB, wrapB, posA, style, channel)
        end
    end
end

local function resolveTapeEnd(anchorId, stored, storedWrap)
    local entity, side = resolveAnchor(anchorId)
    if entity ~= 0 then
        if side == 'L' or side == 'R' then
            local pos = getMirrorAttachPoint(entity, side)
            if isFiniteVec(pos) then
                return pos, nil
            end
        elseif isConeEntity(entity) then
            return getConeAttachPoint(entity), nil
        elseif isPoleEntity(entity) then
            return getPoleAttachPoint(entity, stored and stored.z), poleWrapRadius(entity)
        end
    end

    if stored and isFiniteVec(stored) then
        return stored, usableWrap(storedWrap)
    end

    return stored, usableWrap(storedWrap)
end

-- An anchor that leaves the camera view can report the world origin while the
-- entity still exists. Trust the last real point instead of hiding the ribbon.
local function acceptLiveEnd(live, stored, lastGood)
    if isFiniteVec(lastGood) then
        stored = lastGood
    end

    if not isFiniteVec(live) then
        return stored
    end

    if isFiniteVec(stored) then
        local liveFlat = (live.x * live.x) + (live.y * live.y)
        local storedFlat = (stored.x * stored.x) + (stored.y * stored.y)
        if liveFlat < 4.0 and storedFlat > 400.0 then
            return stored
        end
    end

    return live
end

local function liveTapeEnds(tape)
    local posA, wrapA = resolveTapeEnd(tape.coneAId, tape.a, tape.aWrap)
    local posB, wrapB = resolveTapeEnd(tape.coneBId, tape.b, tape.bWrap)
    posA = acceptLiveEnd(posA, tape.a, tape.liveA)
    posB = acceptLiveEnd(posB, tape.b, tape.liveB)
    if isFiniteVec(posA) then
        tape.liveA = posA
    end
    if isFiniteVec(posB) then
        tape.liveB = posB
    end

    if not isFiniteVec(posA) or not isFiniteVec(posB) then
        return posA, posB, tape.mid, wrapA, wrapB
    end

    return posA, posB, (posA + posB) * 0.5, wrapA, wrapB
end

local function addLocalTape(tape)
    if not tape or not tape.id then
        return
    end

    if TapeContactClient then TapeContactClient.update(tape.id,tape.contacts or {}) end
    local posA = vec3(tape.a)
    local posB = vec3(tape.b)
    local previous=activeTapes[tape.id]
    local breakElapsed=tape.breakElapsedMs
    if tape.brokenAt and previous and previous.brokenAt==tape.brokenAt then
        breakElapsed=math.max(breakElapsed or 0,(previous.breakElapsedMs or 0)+math.max(0,GetGameTimer()-(previous.brokenReceivedAt or GetGameTimer())))
    end

    activeTapes[tape.id] = {
        id = tape.id,
        a = posA,
        b = posB,
        mid = (posA + posB) * 0.5,
        pairKey = tape.pairKey,
        coneAId = tape.coneAId,
        coneBId = tape.coneBId,
        owner = tonumber(tape.owner),
        postA = tape.postA == true, postB = tape.postB == true,
        sceneId=tape.sceneId,revision=tape.revision or 0,brokenAt=tape.brokenAt,breakFraction=tape.breakFraction,breakElapsedMs=breakElapsed,brokenReceivedAt=GetGameTimer(),tearFloorA=tape.tearFloorA,tearFloorB=tape.tearFloorB,
        aSurface=tape.aSurface,bSurface=tape.bSurface,restLength=tape.restLength,accessOpen=tape.accessOpen,openUntil=tape.openUntil,accessHold=tape.accessHold,accessReceivedAt=GetGameTimer(),detour=tape.detour,
        aWrap = usableWrap(tape.aWrap),
        bWrap = usableWrap(tape.bWrap),
        style = normalizeTapeStyle(tape.style),customText=tape.customText,carry=tape.carry,tailDrop=tape.tailDrop and {side=tape.tailDrop.side,point=tape.tailDrop.point,started=GetGameTimer()-(tape.tailDrop.elapsed or 0),duration=tape.tailDrop.duration} or nil,looseRemoved=tape.looseRemoved,wear=tape.wear,placedBy=tape.placedBy,
    }
end

local function clearSelection()
    selectedLevelHeight=nil
    selectedPost = false
    selectedSurface = nil
    selectedAnchor = nil
    selectedAnchorId = nil
    selectedAttach = nil
    selectedMirror = nil
    selectedWrap = nil
end

local function myServerId()
    return GetPlayerServerId(PlayerId())
end

local function entityHasOwnedTape(entity)
    if not entity or entity == 0 then
        return false
    end

    -- The target ray hits the invisible barrier on the tape before the cone.
    local tapeId = barrierTapeId(entity)
    if tapeId then
        local tape = activeTapes[tapeId]
        return tape ~= nil and tape.owner == myServerId()
    end

    if not DoesEntityExist(entity) then
        return false
    end

    local ownerId = myServerId()
    local clusterRadius = Config.PoleClusterRadius or 1.7

    if IsEntityAVehicle(entity) then
        local leftId = getMirrorAnchorId(entity, 'L')
        local rightId = getMirrorAnchorId(entity, 'R')
        for _, tape in pairs(activeTapes) do
            if tape.owner == ownerId then
                local idA = tape.coneAId
                local idB = tape.coneBId
                if idA == leftId or idA == rightId or idB == leftId or idB == rightId then
                    return true
                end
            end
        end
        return false
    end

    if isConeEntity(entity) then
        local anchorId = getAnchorId(entity)
        for _, tape in pairs(activeTapes) do
            if tape.owner == ownerId and (tape.coneAId == anchorId or tape.coneBId == anchorId) then
                return true
            end
        end
        return false
    end

    if not isPoleEntity(entity) then
        return false
    end

    local pos = GetEntityCoords(entity)
    for _, tape in pairs(activeTapes) do
        if tape.owner == ownerId then
            if xyDistance(pos, tape.a) <= clusterRadius or xyDistance(pos, tape.b) <= clusterRadius then
                return true
            end
        end
    end

    return false
end

local function removeOwnedTapesOnEntity(entity)
    if not entity or entity == 0 then
        return
    end

    local tapeId = barrierTapeId(entity)
    if tapeId then
        local tape = activeTapes[tapeId]
        if tape and tape.owner == myServerId() and type(tape.coneAId) == 'string' then
            TriggerServerEvent('apex_policetape:removeOnCone', tape.coneAId)
        end
        return
    end

    if not DoesEntityExist(entity) then
        return
    end

    if IsEntityAVehicle(entity) then
        TriggerServerEvent('apex_policetape:removeOnAnchors', {
            getMirrorAnchorId(entity, 'L'),
            getMirrorAnchorId(entity, 'R'),
        })
        return
    end

    local ids = { getAnchorId(entity) }
    if isPoleEntity(entity) then
        local clusterRadius = Config.PoleClusterRadius or 1.7
        local pos = GetEntityCoords(entity)
        local objects = GetGamePool('CObject')
        for i = 1, #objects do
            local other = objects[i]
            if other ~= entity and isPoleEntity(other) and xyDistance(pos, GetEntityCoords(other)) <= clusterRadius then
                ids[#ids + 1] = getAnchorId(other)
            end
        end
    end

    for i = 1, #ids do
        TriggerServerEvent('apex_policetape:removeOnCone', ids[i])
    end
end

local function registerAnchorTargets()
    if not Config.Target.Enabled or Config.Target.System~='ox' or not Config.Target.AnchorOptions or targetRegistered or GetResourceState('ox_target') ~= 'started' then
        return
    end

    exports.ox_target:addGlobalObject({
        {
            name = 'apex_policetape:remove',
            icon = 'fa-solid fa-scissors',
            label = TapeLocale.Text('Remove Tape'),
            distance = 2.4,
            canInteract = function(entity)
                if isTapeModeActive() then
                    return false
                end
                return entityHasOwnedTape(entity)
            end,
            onSelect = function(data)
                removeOwnedTapesOnEntity(data.entity)
            end,
        },
    })

    pcall(function()
        exports.ox_target:addGlobalVehicle({
            {
                name = 'apex_policetape:remove_vehicle',
                icon = 'fa-solid fa-scissors',
                label = TapeLocale.Text('Remove Tape'),
                distance = 2.6,
                canInteract = function(entity)
                    if isTapeModeActive() then
                        return false
                    end
                    return entityHasOwnedTape(entity)
                end,
                onSelect = function(data)
                    removeOwnedTapesOnEntity(data.entity)
                end,
            },
        })
    end)

    targetRegistered = true
end

local function tryAttachAnchor(anchor)
    if creatingTape or not anchor then
        return
    end

    if not selectedAnchorId then
        selectedAnchor = anchor.entity
        selectedAnchorId = anchor.id
        selectedAttach = anchor.attach
        selectedLevelHeight=placementHeight
        selectedMirror = anchor.mirrorSide
        selectedWrap = anchor.wrap
        selectedPost = anchor.post == true
        selectedSurface = anchor.surface
        notify(Config.Prompt.nextCone, 'inform')
        return
    end

    if anchor.id == selectedAnchorId then
        notify('Select a different point.', 'error')
        return
    end

    local firstAttach, firstWrap = refreshSelectedAttach()

    if not firstAttach then
        clearSelection()
        notify('The first point is no longer available. Select again.', 'error')
        return
    end

    local posA = firstAttach
    local posB = anchor.attach
    if not isFiniteVec(posA) or not isFiniteVec(posB) then
        notify('Could not attach tape there.', 'error')
        return
    end

    local distance = #(posA - posB)
    local maxDistance = Config.MaxDistance or 30.0
    if distance > maxDistance then
        notify(Config.Prompt.outOfReach, 'error')
        return
    end

    creatingTape = true
    local result = requestCreateTape({
        coneAId = selectedAnchorId,
        coneBId = anchor.id,
        a = { x = posA.x, y = posA.y, z = posA.z },
        b = { x = posB.x, y = posB.y, z = posB.z },
        aWrap = firstWrap,
        bWrap = anchor.wrap,aSurface=selectedSurface,bSurface=anchor.surface,
        style = selectedTapeStyle,
        postA = selectedPost, postB = anchor.post == true,
        sceneId = activeSceneId,
    })
    creatingTape = false

    if not result or not result.success then
        local reason = result and result.error or 'Unable to attach tape.'
        if reason == 'duplicate' then
            notify('Those two points are already connected.', 'error')
        elseif reason == 'too_far' then
            notify(Config.Prompt.outOfReach, 'error')
        else
            notify(reason, 'error')
        end
        return
    end

    notify('Tape placed. E: next length. Backspace: reset selection. /ptape: put away.', 'success')
    if chainPlacement then
        selectedAnchor = anchor.entity
        selectedAnchorId = anchor.id
        selectedAttach = anchor.attach
        selectedLevelHeight=placementHeight
        selectedMirror = anchor.mirrorSide
        selectedWrap = anchor.wrap
        selectedPost = anchor.post == true
        selectedSurface = anchor.surface
    else
        clearSelection()
    end
end

RegisterCommand(TapeCommands.name('ptape'), function(_, args)
    local action = args and args[1] and string.lower(tostring(args[1])) or ''
    if action == 'undo' then TriggerServerEvent('apex_policetape:undo'); return end
    if action == 'remove' or action == 'clear' then
        TriggerServerEvent('apex_policetape:removeMine')
        return
    end

    if tapeMode then
        perimeterTool=nil;movingEndpoint=nil
        tapeMode = false
        clearSelection()
        setPrompt(nil)
        notify('Police tape put away.', 'inform')
        return
    end

    if not playerCanUseTape() then
        notify('You do not have permission to use police tape.', 'error')
        return
    end

    tapeMode = true
    local styleLabel = TapeCustomTextClient and TapeCustomTextClient.selected() and 'Custom text' or ((Config.TapeStyles or {})[selectedTapeStyle] or {}).label or 'UK Police Tape'
    notify(('%s ready. E: attach • /tapemode: aim/anchors • /tapechain: chain • /changetape: styles.'):format(styleLabel), 'success')
end, false)

local function closeTapeMenu(force)
    if not force and tapeMenuOpen and (GetGameTimer() - menuOpenedAt) < 600 then
        return
    end

    tapeMenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function applySelectedTapeStyle(style)
    if TapeCustomTextClient and not TapeCustomTextClient.command({'off'},true) then return false end
    selectedTapeStyle = normalizeTapeStyle(style)
    SetResourceKvp('apex_policetape_style', selectedTapeStyle)

    local styleLabel = TapeCustomTextClient and TapeCustomTextClient.selected() and 'Custom text' or ((Config.TapeStyles or {})[selectedTapeStyle] or {}).label or 'UK Police Tape'
    notify(('%s selected. New tape will use this texture.'):format(styleLabel), 'success')
    return true
end

RegisterCommand(TapeCommands.name('changetape'), function()
    if tapeMenuOpen or scenePanelOpen then
        return
    end

    if not playerCanUseTape() then
        notify('You do not have permission to use police tape.', 'error')
        return
    end

    tapeMenuOpen = true
    menuOpenedAt = GetGameTimer()
    SetNuiFocus(true, true)

    -- The Enter key that runs this command is still down. Showing the page
    -- immediately lets that key hit the menu and close it before it is seen.
    CreateThread(function()
        Wait(300)
    if not tapeMenuOpen then
            return
        end
        SendNUIMessage({
            action = 'open',
            style = TapeCustomTextClient and TapeCustomTextClient.selected() and '__custom_text' or selectedTapeStyle,
            styles = availableTapeStyles,locale=TapeLocale.UI(),commands=Config.Commands,
            customText={enabled=Config.CustomText.Enabled,label='Custom text',text=TapeCustomTextClient and TapeCustomTextClient.selected() or 'YOUR TEXT HERE',background=Config.CustomText.Background,foreground=Config.CustomText.Foreground},
        })
    end)
end, false)

RegisterNUICallback('applyTapeStyle', function(data, cb)
    if data and data.style=='__custom_text' then
        if not Config.CustomText.Enabled or not TapeCustomTextClient then cb({ok=false});return end
        closeTapeMenu(true);cb({ok=true})
        CreateThread(function()if TapeCustomTextClient.command({}) and data.deploy==true and playerCanUseTape() then tapeMode=true end end)
        return
    end
    local applied=applySelectedTapeStyle(data and data.style)
    if applied then
        closeTapeMenu(true)
        if data.deploy==true and playerCanUseTape() then tapeMode=true end
    end
    cb({ ok = applied==true })
end)

RegisterNUICallback('closeTapeMenu', function(_, cb)
    closeTapeMenu(true)
    cb({ ok = true })
end)

RegisterCommand(TapeCommands.name('removealltape'), function()
    TriggerServerEvent('apex_policetape:removeMine')
end, false)

local commandName = Config.Command or 'ptape'
CreateThread(function()
    Wait(1500)
    TriggerEvent('chat:addSuggestion', '/' .. commandName, 'Toggle police tape. Equip Police Tape on your hotbar or use this command, then press E on a cone, sign, pole or car wing mirror.')
    TriggerEvent('chat:addSuggestion', '/'..TapeCommands.name('changetape'), 'Choose UK Police, UK Fire, Ambulance or Crime Scene tape')
    TriggerEvent('chat:addSuggestion', '/'..TapeCommands.name('removealltape'), 'Remove only the police tape you placed')
end)

RegisterNetEvent('apex_policetape:createResult', function(requestId, result)
    local cb = pendingCreates[requestId]
    if cb then
        cb(result)
    end
end)

RegisterNetEvent('apex_policetape:canUseResult', function(requestId, result)
    local cb = pendingCreates[requestId]
    if cb then
        cb(result)
    end
end)

RegisterNetEvent('apex_policetape:add', function(tape)
    if tape and clearAiRoadBlock then clearAiRoadBlock(tape.id) end
    addLocalTape(tape)
end)

RegisterNetEvent('apex_policetape:remove', function(id)
    activeTapes[id] = nil
    if clearAiRoadBlock then
        clearAiRoadBlock(id)
    end
end)

RegisterNetEvent('apex_policetape:sync', function(list)
    activeTapes = {}
    local keep = {}
    for i = 1, #(list or {}) do
        addLocalTape(list[i])
        if list[i] and list[i].id then
            keep[list[i].id] = true
        end
    end

    if clearAiRoadBlock then
        for id in pairs(roadBlocks) do
            if not keep[id] then
                clearAiRoadBlock(id)
            end
        end
    end
end)

RegisterNetEvent('apex_policetape:notify', function(description, nType)
    notify(description, nType)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    setPrompt(nil)
    closeTapeMenu(true)

    for _, entry in pairs(textureState) do
        if entry.dui then
            DestroyDui(entry.dui)
            entry.dui = nil
        end
    end

    if clearAllAiRoadBlocks then
        clearAllAiRoadBlocks()
    end

    if targetRegistered and GetResourceState('ox_target') == 'started' then
        pcall(function()
            exports.ox_target:removeGlobalObject('apex_policetape:remove')
            exports.ox_target:removeGlobalVehicle('apex_policetape:remove_vehicle')
        end)
    end
end)

local savedTapeStyle = GetResourceKvpString('apex_policetape_style')
if type(savedTapeStyle) == 'string' and (Config.TapeStyles or {})[savedTapeStyle] then
    selectedTapeStyle = savedTapeStyle
end

buildAnchorLookups()

CreateThread(function()
    buildAnchorLookups()
    ensureTapeTexture()
    Wait(500)
    TriggerServerEvent('apex_policetape:requestSync')

    if GetResourceState('ox_target') == 'started' then
        registerAnchorTargets()
    else
        CreateThread(function()
            local waited = 0
            while GetResourceState('ox_target') ~= 'started' and waited < 15000 do
                Wait(500)
                waited = waited + 500
            end
            if GetResourceState('ox_target') == 'started' then
                registerAnchorTargets()
            end
        end)
    end
end)

local function drawAttachmentTab(pos,normal,toward,style,drawn)
    if not Config.AttachmentVisual.Enabled or not normal then return end
    local key=('tab:%.2f:%.2f:%.2f'):format(pos.x,pos.y,pos.z)
    if drawn[key] then return end
    drawn[key]=true
    if not reserveTapePolys(4,'placed') then return end
    local n=vector3(normal.x,normal.y,normal.z)
    local tangent=vector3(-n.y,n.x,0)
    if #tangent<.1 then tangent=vector3(toward.x-pos.x,toward.y-pos.y,0) end
    if #tangent<.001 then tangent=vector3(1,0,0) end
    tangent=tangent/#tangent
    local width=vector3(n.y*tangent.z-n.z*tangent.y,n.z*tangent.x-n.x*tangent.z,n.x*tangent.y-n.y*tangent.x)
    width=width/math.max(.001,#width)*(Config.Ribbon.height*.55)
    local center=pos+n*.002
    local a=center-tangent*(Config.AttachmentVisual.TabLength*.5)
    local b=center+tangent*(Config.AttachmentVisual.TabLength*.5)
    local at,ab,bt,bb=a+width,a-width,b+width,b-width
    local dict,tex=styleTexture(style)
    local extent=math.min(1.0,Config.AttachmentVisual.TabLength/styleTileLength(style))
    local function triangle(p,q,r,ua,va,ub,vb,uc,vc)
        if dict and tex then
            DrawTexturedPoly(p.x+0.0,p.y+0.0,p.z+0.0,q.x+0.0,q.y+0.0,q.z+0.0,r.x+0.0,r.y+0.0,r.z+0.0,255,255,255,Config.Ribbon.alpha,dict,tex,ua*extent+0.0,va+0.0,1.0,ub*extent+0.0,vb+0.0,1.0,uc*extent+0.0,vc+0.0,1.0)
        else DrawPoly(p.x,p.y,p.z,q.x,q.y,q.z,r.x,r.y,r.z,245,210,35,255) end
    end
    triangle(at,bt,ab,0,0,1,0,0,1)
    triangle(bt,bb,ab,1,0,1,1,0,1)
    triangle(bt,at,bb,1,0,0,0,1,1)
    triangle(at,ab,bb,0,0,0,1,1,1)
end

local function drawTieFinish(pos,toward,style,drawn)
    if not Config.Polish.Enabled or not Config.Polish.AttachmentFinish then return end
    local key=('finish:%.2f:%.2f:%.2f'):format(pos.x,pos.y,pos.z)
    if drawn[key] then return end;drawn[key]=true
    local d=toward-pos;local length=math.sqrt(d.x*d.x+d.y*d.y)
    if length<.01 then return end
    local across=vector3(-d.y/length,d.x/length,0)
    local forward=vector3(d.x/length,d.y/length,0)
    local fold=Config.Polish.FoldLength;local dict,tex=styleTexture(style)
    emitTiledSegment(pos-across*fold*.3,pos+across*fold*.3+vector3(0,0,fold*.2),0,fold*.6,styleTileLength(style),Config.Ribbon.height*.45,dict,tex,255,'placed')
    emitTiledSegment(pos+across*fold*.3+vector3(0,0,fold*.2),pos+forward*fold+across*fold*.5-vector3(0,0,fold*.75),0,fold,styleTileLength(style),Config.Ribbon.height*.4,dict,tex,255,'placed')
end
local function drawLooseTails(tape)
    local paths=TapeTearClient.paths(tape,tape.posA,tape.posB)
    local dict,tex=styleTexture(tape.style)
    local halfHeight=Config.Ribbon.height*.5
    local allowance=math.max(2,math.floor((renderRibbonAllowance or TAPE_POLY_BUDGET.placed)/4))
    local perSide=math.max(1,math.floor(allowance/2))
    local pieces={}
    local tileLength=styleTileLength(tape.style)
    local estimate=0
    for _,path in ipairs(paths)do
        local count=math.min(#path-1,perSide)
        local previous=vec3(path[1]);local travelled=0.0
        for i=1,count do
            local index=1+math.ceil(i*(#path-1)/count)
            local point=vec3(path[index]);local distance=#(point-previous)
            if distance>.001 then
                pieces[#pieces+1]={a=previous,b=point,d0=travelled,d1=travelled+distance}
                estimate=estimate+math.ceil(distance/tileLength)+1
                travelled=travelled+distance
            end
            previous=point
        end
    end
    for _,piece in ipairs(pieces)do
        if estimate>allowance then
            if not drawTapeSegmentUV(piece.a,piece.b,halfHeight,0.0,1.0,dict,tex,Config.Ribbon.alpha,'placed') then return end
        elseif not emitTiledSegment(piece.a,piece.b,piece.d0,piece.d1,tileLength,halfHeight,dict,tex,Config.Ribbon.alpha,'placed') then return end
    end
end

local function drawPlacedSpanBase(tape,drawnWraps,part)
    if part=='ribbon' and not tape.customText and TapeEditorClient and TapeEditorClient.ready(tape.id) then return end
    if part=='wrap' then
        if not (tape.looseRemoved and tape.looseRemoved.a) then
            drawTieFinish(tape.posA,tape.posB,tape.style,drawnWraps)
            drawAttachmentTab(tape.posA,tape.aSurface,tape.posB,tape.style,drawnWraps)
        end
        if not (tape.looseRemoved and tape.looseRemoved.b) then
            drawTieFinish(tape.posB,tape.posA,tape.style,drawnWraps)
            drawAttachmentTab(tape.posB,tape.bSurface,tape.posA,tape.style,drawnWraps)
        end
    end
    if tape.accessHold and TapeAccessClient and not tape.brokenAt then
        local grip,amount=TapeAccessClient.grip(tape)
        renderRestLength=tape.restLength
        renderAccess={grip=grip,amount=amount,fraction=tape.accessHold.fraction}
        drawTapeSpan(tape.posA,tape.posB,tape.wrapA,tape.wrapB,drawnWraps,tape.style,part,'placed')
        renderAccess=nil;renderRestLength=nil
        return
    end
    if tape.accessOpen and not tape.brokenAt then
        local delta=tape.posB-tape.posA
        local lift=vector3(0,0,Config.Access.LiftHeight)
        local a=tape.posA+delta*0.2+lift
        local b=tape.posB-delta*0.2+lift
        drawTapeSpan(tape.posA,a,tape.wrapA,nil,drawnWraps,tape.style,part,'placed')
        drawTapeSpan(a,b,nil,nil,drawnWraps,tape.style,part,'placed')
        drawTapeSpan(b,tape.posB,nil,tape.wrapB,drawnWraps,tape.style,part,'placed')
        return
    end
    if not tape.brokenAt then
        renderRestLength=tape.restLength
        renderContacts=Config.Contact.Enabled and TapeContactClient and TapeContactClient.get(tape.id) or nil
        drawTapeSpan(tape.posA,tape.posB,tape.wrapA,tape.wrapB,drawnWraps,tape.style,part,'placed')
        renderContacts=nil;renderRestLength=nil;return
    end
    if part=='ribbon' and TapeTearClient then drawLooseTails(tape);return end
    local delta=tape.posB-tape.posA
    local length=#delta
    if length<0.01 then return end
    local cut=tape.posA+delta*(tape.breakFraction or 0.5)
    local gap=delta/length*((Config.Breakaway.TearGap or .6)*.5)
    local drop=vector3(0,0,Config.Breakaway.HangingDrop)
    if not (tape.looseRemoved and tape.looseRemoved.a) then drawTapeSpan(tape.posA,cut-gap-drop,tape.wrapA,nil,drawnWraps,tape.style,part,'placed') end
    if not (tape.looseRemoved and tape.looseRemoved.b) then drawTapeSpan(cut+gap-drop,tape.posB,nil,tape.wrapB,drawnWraps,tape.style,part,'placed') end
end

local function drawPlacedSpan(tape,drawnWraps,part)
    local previous=renderCustomText;renderCustomText=tape.customText
    drawPlacedSpanBase(tape,drawnWraps,part);renderCustomText=previous
end

CreateThread(function()
    while true do
        local hasTapes = next(activeTapes) ~= nil
        if not hasTapes then
            Wait(400)
        else
            local drewTape = false
            if tapeTextureReady then
                for _, entry in pairs(textureState) do
                    if entry.ready and entry.dict and entry.name then
                        DrawSprite(entry.dict, entry.name, 0.0, 0.0, 0.001, 0.001, 0.0, 255, 255, 255, 1)
                    end
                end

                local playerCoords = GetEntityCoords(PlayerPedId())
                local drawDist = Config.DrawDistance or 90.0
                local cullDist = drawDist + 20.0
                local drawnWraps = {}
                local visible = {}
                for _, tape in pairs(activeTapes) do
                    local known = tape.mid or tape.liveA or tape.a
                    if not known or #(playerCoords - known) <= cullDist then
                        local posA, posB, mid, wrapA, wrapB = liveTapeEnds(tape)
                        if isFiniteVec(mid) then
                            tape.mid = mid
                        end
                        if isFiniteVec(posA) and isFiniteVec(posB) and isFiniteVec(mid) and #(playerCoords - mid) <= drawDist then
                            visible[#visible + 1] = {
                                posA = posA,
                                posB = posB,
                                wrapA = wrapA,
                                wrapB = wrapB,aSurface=tape.aSurface,bSurface=tape.bSurface,
                                style = tape.style,
                                id=tape.id,carry=tape.carry,tailDrop=tape.tailDrop,looseRemoved=tape.looseRemoved,customText=tape.customText,brokenAt=tape.brokenAt,breakFraction=tape.breakFraction,breakElapsedMs=tape.breakElapsedMs,brokenReceivedAt=tape.brokenReceivedAt or GetGameTimer(),tearFloorA=tape.tearFloorA,tearFloorB=tape.tearFloorB,restLength=tape.restLength,accessOpen=tape.accessOpen,accessHold=tape.accessHold,accessReceivedAt=tape.accessReceivedAt,
                                dist = #(playerCoords - mid),
                            }
                        end
                    end
                end

                table.sort(visible, function(a, b)
                    return a.dist < b.dist
                end)

                while #visible>math.min(Config.Performance.MaxVisibleTapes,math.max(1,math.floor(TAPE_POLY_BUDGET.placed/8))) do table.remove(visible) end
                for i = 1, #visible do
                    local tape = visible[i]
                    renderRibbonAllowance=math.max(8,math.floor((tapePolysLeft.placed or TAPE_POLY_BUDGET.placed)/math.max(1,#visible-i+1)))
                    if i==1 then renderRibbonAllowance=math.max(8,math.floor(TAPE_POLY_BUDGET.placed/math.max(1,#visible))) end
                    drawPlacedSpan(tape,drawnWraps,'ribbon');renderRibbonAllowance=nil
                    drewTape = true
                end

                for i = 1, #visible do
                    local tape = visible[i]
                    drawPlacedSpan(tape,drawnWraps,'wrap')
                end
            end

            if drewTape then
                Wait(0)
            else
                Wait(250)
            end
        end
    end
end)

local function aimedAnchor()
    placementHint=nil
    local origin = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(2)
    local pitch,yaw = math.rad(rot.x),math.rad(rot.z)
    local direction = vector3(-math.sin(yaw)*math.cos(pitch), math.cos(yaw)*math.cos(pitch), math.sin(pitch))
    local target = origin + direction*Config.AimReach
    local handle = StartShapeTestLosProbe(origin.x,origin.y,origin.z,target.x,target.y,target.z,1+2+16,PlayerPedId(),7)
    local state,hit,pos,normal,entity = GetShapeTestResult(handle)
    local deadline = GetGameTimer()+150
    while state==1 and GetGameTimer()<deadline do Wait(0); state,hit,pos,normal,entity=GetShapeTestResult(handle) end
    if state~=2 or (hit~=1 and hit~=true) or not isFiniteVec(pos) then return nil end
    local visuals=Config.AttachmentVisual
    if not isFiniteVec(normal) then return nil end
    entity=tonumber(entity) or 0
    -- Map floors can return an entity handle too. Classify by hit height, not
    -- entity presence, so pavement/interior floors still get a waist-high post.
    local pedPosition=GetEntityCoords(PlayerPedId())
    local groundLike=entity==0 or pos.z<=pedPosition.z-Config.Placement.GroundBelowPed
    local post = normal.z > 0.7 and groundLike
    local surfaceHeight=placementHeight-Config.PostHeight
    local attach = post and (pos+vector3(0,0,placementHeight)) or (pos+vector3(0,0,surfaceHeight))
    local level=Config.Placement.Level and selectedAttach and not movingEndpoint and not perimeterTool
    if level then
        attach=vector3(attach.x,attach.y,selectedAttach.z+placementHeight-(selectedLevelHeight or placementHeight))
        -- Verify the chosen object's surface at the locked height. Do not silently
        -- jump to its top or move the endpoint to a neighbouring snap point.
        if not post then
            local nx,ny=normal.x,normal.y;local n=math.sqrt(nx*nx+ny*ny)
            if n<.01 then nx,ny=-direction.x,-direction.y;n=math.sqrt(nx*nx+ny*ny) end
            if n>.01 then
                local d=Config.Placement.SurfaceProbeDistance
                local probe=StartShapeTestLosProbe(attach.x+nx/n*d,attach.y+ny/n*d,attach.z,attach.x-nx/n*d,attach.y-ny/n*d,attach.z,1+2+16,PlayerPedId(),7)
                local status,found,at,norm,object=GetShapeTestResult(probe)
                local untilAt=GetGameTimer()+150
                while status==1 and GetGameTimer()<untilAt do Wait(0);status,found,at,norm,object=GetShapeTestResult(probe) end
                if status~=2 or (found~=1 and found~=true) or not isFiniteVec(at) or math.abs(at.z-attach.z)>.1 then placementHint='Object does not reach this height. Adjust arrows or /tapelevel to follow surfaces.';return nil end
                attach=at;normal=isFiniteVec(norm) and norm or normal
            end
        end
    end
    local surface
    if visuals and visuals.Enabled and not post then
        attach=attach+normal*visuals.SurfaceOffset
        surface={x=normal.x,y=normal.y,z=normal.z}
        if entity~=0 and type(isPoleEntity)=='function' and isPoleEntity(entity) then
            local center=getPoleAttachPoint(entity,attach.z)
            if level and math.abs(center.z-attach.z)>.05 then return nil end
            local radius=math.sqrt((pos.x-center.x)^2+(pos.y-center.y)^2)+visuals.SurfaceOffset
            radius=math.max(.04,math.min(visuals.MaxWrapRadius,radius))
            return {entity=nil,id=('world:%.2f:%.2f:%.2f'):format(center.x,center.y,center.z),attach=center,post=false,wrap=radius}
        end
    end
    if Config.Placement.Enabled and gridSize>0 and post then
        attach=vector3(math.floor(attach.x/gridSize+0.5)*gridSize,math.floor(attach.y/gridSize+0.5)*gridSize,attach.z)
    end
    if Config.Placement.Enabled and snapEnabled and not movingEndpoint and not perimeterTool then
        local best=post and Config.Placement.SnapDistance or math.min(Config.Placement.SnapDistance,Config.Placement.SurfaceSnapDistance)
        local snapped
        for _,t in pairs(activeTapes) do
            if not t.brokenAt then
                for _,side in ipairs({'a','b'}) do
                    local point=t[side]
                    local id=t[side=='a' and 'coneAId' or 'coneBId']
                    local d=#(attach-point)
                    if d<best and id~=selectedAnchorId and (not level or math.abs(point.z-attach.z)<=Config.Placement.LevelSnapTolerance) and type(id)=='string' and not id:match('^net:') then
                        best=d;snapped={entity=nil,id=id,attach=point,post=t[side=='a' and 'postA' or 'postB'],wrap=t[side=='a' and 'aWrap' or 'bWrap'],surface=t[side=='a' and 'aSurface' or 'bSurface'],snapped=true}
                    end
                end
            end
        end
        if snapped then return snapped end
    end
    -- Free-aim positions are static world anchors; moving vehicles use mirror mode.
    if entity~=0 and IsEntityAVehicle(entity) then return nil end
    return {entity=nil, id=('world:%.2f:%.2f:%.2f'):format(attach.x,attach.y,attach.z),attach=attach,post=post,surface=surface}
end

local placementAnchor = nil
local placementPoles = nil
local nextPlacementScan = 0
-- Poll asynchronous raycasts separately so pending probes cannot swallow E/button presses.
CreateThread(function()
    while true do
        if freeAim and isTapeModeActive() and not isBlocked() then
            placementAnchor=aimedAnchor()
            placementPoles={}
            Wait(math.max(30,Config.Performance.PlacementScanMs))
        else Wait(100) end
    end
end)


CreateThread(function()
    while true do
        local equipped = isTapeModeActive()
        if not equipped or isBlocked() then
            if selectedAnchorId then
                clearSelection()
            end
            nearbyAnchor = nil
            placementAnchor = nil
            placementPoles = nil
            nextPlacementScan = 0
            setPrompt(nil)
            Wait(200)
        else
            Wait(0)
            drawNativePrompt()

            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)
            local now = GetGameTimer()
            if not freeAim and now >= nextPlacementScan then
                nextPlacementScan = now + math.max(30,Config.Performance.PlacementScanMs)
                placementAnchor, placementPoles = findNearestAnchor(playerCoords, Config.InteractDistance or 3.0)
            end
            local anchor = placementAnchor
            local poleAnchors = placementPoles
            nearbyAnchor = anchor
            if advancedPlacement and advancedPlacement(anchor) then
                -- Tool owns confirmation and preview this frame.
            else

            SetCurrentPedWeapon(ped, joaat('WEAPON_UNARMED'), true)
            DisablePlayerFiring(PlayerId(), true)
            local prompt=freeAim and 'Aim at a solid surface within reach. [E] sets the first point.' or 'Move near a cone, pole or wing mirror. /tapemode switches to aim.'
            if selectedAnchorId then
                local firstAttach, firstWrap = refreshSelectedAttach()

                if anchor and anchor.id ~= selectedAnchorId and firstAttach and isFiniteVec(anchor.attach) then
                    local distance = #(firstAttach - anchor.attach)
                    if distance > (Config.MaxDistance or 30.0) then
                        prompt = Config.Prompt.outOfReach
                    else
                        prompt = Config.Prompt.attach .. (' (%.1f m)'):format(distance)
                        renderCustomText=TapeCustomTextClient and TapeCustomTextClient.selected() or nil
                        drawTapeSpan(firstAttach, anchor.attach, firstWrap, anchor.wrap, nil, selectedTapeStyle, nil, 'preview')
                        renderCustomText=nil
                    end
                else
                    prompt = Config.Prompt.nextCone
                end
            elseif anchor then
                prompt = Config.Prompt.attach
            end

            if freeAim then prompt=prompt..(' • height %.2f m • arrows up/down'):format(placementHeight) end
            if freeAim and not anchor and placementHint then prompt=placementHint end
            if freeAim and anchor then prompt=prompt..(' | %s | %.2f m'):format(anchor.post and 'Ground post' or anchor.mirror and 'Vehicle mirror' or anchor.wrap and 'Pole wrap' or 'Surface attachment',placementHeight) end
            if selectedAttach and anchor and TapePolishClient then TapePolishClient.previewTraffic(selectedAttach,anchor.attach);prompt=prompt..' | traffic: red stop / gold bypass' end
            if Config.PlacementFeedback.Enabled then
                local valid,reason=TapeEnhanceMath.feedback(anchor,selectedAttach,Config.MinLength,Config.MaxDistance,placementHint)
                if not valid or Config.PlacementFeedback.ShowReason then prompt=prompt..' | '..reason end
            end
            setPrompt(prompt)

            local function markerBeside(attach)
                local dx = playerCoords.x - attach.x
                local dy = playerCoords.y - attach.y
                local len = math.sqrt((dx * dx) + (dy * dy))
                if len < 0.05 then
                    return attach
                end
                local nudge = 0.14
                return vector3(
                    attach.x + ((dx / len) * nudge),
                    attach.y + ((dy / len) * nudge),
                    attach.z
                )
            end

            local function drawSelectBall(pos, scale, red, green, blue, alpha)
                DrawMarker(
                    28,
                    pos.x, pos.y, pos.z,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    scale, scale, scale,
                    red, green, blue, alpha,
                    false, false, 2, false, nil, nil, false
                )
            end

            local selectedId = selectedAnchorId
            for i = 1, #(poleAnchors or {}) do
                local pole = poleAnchors[i]
                if pole and isFiniteVec(pole.attach) and pole.id ~= selectedId then
                    local scale = (anchor and pole.id == anchor.id) and 0.22 or 0.18
                    drawSelectBall(markerBeside(pole.attach), scale, 255, 255, 255, 230)
                end
            end

            if anchor and anchor.id ~= selectedId then
                local attach = anchor.attach
                if not isFiniteVec(attach) and anchor.coords then
                    attach = vector3(anchor.coords.x, anchor.coords.y, anchor.coords.z + 0.75)
                end
                if isFiniteVec(attach) then
                    local scale = (anchor.mirrorSide or anchor.wrap) and 0.12 or 0.24
                    local valid = not selectedAttach or (#(selectedAttach-attach)>=Config.MinLength and #(selectedAttach-attach)<=Config.MaxDistance)
                    drawSelectBall(attach, scale, valid and 40 or 240, valid and 200 or 60, 80, 240)
                end
            end

            if selectedAnchorId and isFiniteVec(selectedAttach) then
                local scale = 0.32
                local pos = selectedAttach
                if selectedMirror then
                    scale = 0.12
                elseif selectedWrap then
                    scale = 0.22
                    pos = markerBeside(selectedAttach)
                end
                drawSelectBall(pos, scale, 40, 200, 80, 230)
            end

            if (prompt and prompt:sub(1,#Config.Prompt.attach)==Config.Prompt.attach) or prompt == Config.Prompt.outOfReach then
                DisableControlAction(0,featureControl('confirm'),true)
            end

            if featurePressed('confirm') then
                if prompt == Config.Prompt.outOfReach then
                    notify(Config.Prompt.outOfReach, 'error')
                elseif anchor and anchor.id ~= selectedAnchorId then
                    tryAttachAnchor(anchor)
                end
            end

            if selectedAnchorId and featurePressed('cancel') then
                clearSelection()
                notify('Tape selection cancelled.', 'inform')
            end
            end -- regular placement
        end
    end
end)

local function aiBlockConfig()
    return Config.AiBlock or {}
end

local function roadPoint(pos)
    return vector3(pos.x, pos.y, pos.z - 1.0)
end

local function restoreRoadBlock(block)
    if not block then
        return
    end

    SetRoadsBackToOriginalInAngledArea(
        block.a.x, block.a.y, block.a.z,
        block.b.x, block.b.y, block.b.z,
        block.width
    )
end

local function discardBarrierObject(object)
    if not object then
        return
    end

    barrierTapeByEntity[object] = nil
    if DoesEntityExist(object) then
        SetEntityAsMissionEntity(object, true, true)
        DeleteEntity(object)
    end
end

local function deleteTapeBarriers(id)
    if barrierBuild and barrierBuild.id == id then
        for i = 1, #barrierBuild.objects do
            discardBarrierObject(barrierBuild.objects[i])
        end
        barrierBuild = nil
    end
    barrierWanted[id] = nil

    local entry = tapeBarriers[id]
    if not entry then
        return
    end

    for i = 1, #(entry.objects or {}) do
        discardBarrierObject(entry.objects[i])
    end

    tapeBarriers[id] = nil
end

local function releaseBarrierModel()
    if next(tapeBarriers) ~= nil or barrierBuild or next(barrierWanted) ~= nil then
        return
    end

    barrierModelRequestedAt = nil
    SetModelAsNoLongerNeeded(joaat((aiBlockConfig().barrierModel) or 'prop_barrier_work05'))
end

clearAiRoadBlock = function(id)
    local block = roadBlocks[id]
    if block then
        restoreRoadBlock(block)
        roadBlocks[id] = nil
    end

    deleteTapeBarriers(id)
    releaseBarrierModel()
end

clearAllAiRoadBlocks = function()
    local ids = {}
    for id in pairs(roadBlocks) do
        ids[#ids + 1] = id
    end
    for id in pairs(tapeBarriers) do
        ids[#ids + 1] = id
    end

    local seen = {}
    for i = 1, #ids do
        local id = ids[i]
        if not seen[id] then
            seen[id] = true
            clearAiRoadBlock(id)
        end
    end

    barrierWanted = {}
    if barrierBuild then
        deleteTapeBarriers(barrierBuild.id)
    end
    releaseBarrierModel()
end

local function roadMoved(from, to)
    if not from or not to then
        return true
    end
    return #(from - to) > 1.25
end

local function applyRoadBlock(id, posA, posB, width)
    local current = roadBlocks[id]
    if current and current.width == width and not roadMoved(current.rawA, posA) and not roadMoved(current.rawB, posB) then
        return
    end

    local a = roadPoint(posA)
    local b = roadPoint(posB)
    restoreRoadBlock(current)
    SetRoadsInAngledArea(a.x, a.y, a.z, b.x, b.y, b.z, width, false, false, false)
    roadBlocks[id] = {
        a = a,
        b = b,
        rawA = posA,
        rawB = posB,
        width = width,
    }
end

-- Ground snaps (GetGroundZFor_3dCoord / PlaceObjectOnGroundProperly) call LoadObjectsNow
-- and stall the client. Barriers are queued, probed with an async shape test, and created
-- one prop per frame, and only while the player is close enough for collision to be loaded.
local function closestPointOnSegment2d(point, a, b)
    local abx = b.x - a.x
    local aby = b.y - a.y
    local apx = point.x - a.x
    local apy = point.y - a.y
    local lengthSq = (abx * abx) + (aby * aby)
    local t = 0.0
    if lengthSq > 0.0001 then
        t = (apx * abx + apy * aby) / lengthSq
        if t < 0.0 then
            t = 0.0
        elseif t > 1.0 then
            t = 1.0
        end
    end

    local x = a.x + (abx * t)
    local y = a.y + (aby * t)
    local dx = point.x - x
    local dy = point.y - y
    return math.sqrt((dx * dx) + (dy * dy)), x, y, t
end

local function segmentsIntersect2d(p, q, a, b)
    local function cross(ax, ay, bx, by)
        return (ax * by) - (ay * bx)
    end

    local rx = q.x - p.x
    local ry = q.y - p.y
    local sx = b.x - a.x
    local sy = b.y - a.y
    local denom = cross(rx, ry, sx, sy)
    if math.abs(denom) < 0.00001 then
        return false
    end

    local qpx = a.x - p.x
    local qpy = a.y - p.y
    local t = cross(qpx, qpy, sx, sy) / denom
    local u = cross(qpx, qpy, rx, ry) / denom
    return t >= 0.0 and t <= 1.0 and u >= 0.0 and u <= 1.0
end

local function isPlayerControlledVehicle(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return true
    end

    local playerPed = PlayerPedId()
    if vehicle == GetVehiclePedIsIn(playerPed, false) or vehicle == GetVehiclePedIsIn(playerPed, true) then
        return true
    end

    local seats = GetVehicleMaxNumberOfPassengers(vehicle)
    for seat = -1, seats - 1 do
        local ped = GetPedInVehicleSeat(vehicle, seat)
        if ped ~= 0 and IsPedAPlayer(ped) then
            return true
        end
    end

    local popType = GetEntityPopulationType(vehicle)
    return popType < 1 or popType > 5
end

local function haltAiVehicle(vehicle, driver)
    if NetworkGetEntityIsNetworked(vehicle) and not NetworkHasControlOfEntity(vehicle) then
        NetworkRequestControlOfEntity(vehicle)
    end

    SetVehicleForwardSpeed(vehicle, 0.0)
    SetVehicleBrakeLights(vehicle, true)
    if driver and driver ~= 0 and not IsPedAPlayer(driver) then
        TaskVehicleTempAction(driver, vehicle, 1, 1200)
        SetDriveTaskCruiseSpeed(driver, 0.0)
    end
    pcall(BringVehicleToHalt, vehicle, 0.8, 600, false)
end

local function holdAiAtTape(vehicle, coords, dist, closestX, closestY, hardStop)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    if driver==0 or IsPedAPlayer(driver) or isPlayerControlledVehicle(vehicle) then return end
    if (NetworkGetEntityIsNetworked(vehicle) and not NetworkHasControlOfEntity(vehicle))
        or (NetworkGetEntityIsNetworked(driver) and not NetworkHasControlOfEntity(driver)) then return end
    if dist <= hardStop then
        haltAiVehicle(vehicle, driver)
        if dist < 1.35 then
            local dx = coords.x - closestX
            local dy = coords.y - closestY
            local length = math.sqrt((dx * dx) + (dy * dy))
            if length < 0.05 then
                local forward = GetEntityForwardVector(vehicle)
                dx = -forward.x
                dy = -forward.y
                length = math.sqrt((dx * dx) + (dy * dy))
            end
            if length > 0.05 then
                SetEntityVelocity(vehicle, (dx / length) * 1.15, (dy / length) * 1.15, 0.0)
            end
        end
        return
    end

    local speed = GetEntitySpeed(vehicle)
    local maxSpeed = math.max(0.0, (dist - hardStop) * 0.85)
    if speed > maxSpeed then
        SetVehicleForwardSpeed(vehicle, maxSpeed)
    end
    SetVehicleBrakeLights(vehicle, true)
    if driver ~= 0 and not IsPedAPlayer(driver) then
        TaskVehicleTempAction(driver, vehicle, 1, 500)
        SetDriveTaskCruiseSpeed(driver, maxSpeed)
    end
end

local function holdAiTraffic(segments, cfg, playerCoords, scanDistance)
    local approach = tonumber(cfg.approachDistance) or 7.0
    local hardStop = tonumber(cfg.hardStopDistance) or 2.6
    local lookahead = tonumber(cfg.lookahead) or 0.45
    local heightTolerance = tonumber(cfg.heightTolerance) or 5.0
    local pool = GetGamePool('CVehicle')
    if TapeTraffic then TapeTraffic.tick(segments) end

    for i = 1, #pool do
        local vehicle = pool[i]
        if DoesEntityExist(vehicle) then
            local coords = GetEntityCoords(vehicle)
            if #(coords - playerCoords) <= scanDistance and not isPlayerControlledVehicle(vehicle) and not (TapeTraffic and TapeTraffic.isRouted(vehicle))
                and not (Config.Traffic.SkipMissionEntities and (IsEntityAMissionEntity(vehicle) or (GetPedInVehicleSeat(vehicle,-1)~=0 and IsEntityAMissionEntity(GetPedInVehicleSeat(vehicle,-1))))) then
                local velocity = GetEntityVelocity(vehicle)
                local speed = GetEntitySpeed(vehicle)
                local nextPos = vector3(
                    coords.x + (velocity.x * lookahead),
                    coords.y + (velocity.y * lookahead),
                    coords.z
                )

                for s = 1, #segments do
                    local segment = segments[s]
                    if math.abs(coords.z - segment.z) <= heightTolerance then
                        local dist, closestX, closestY, along = closestPointOnSegment2d(coords, segment.a, segment.b)
                        local onSpan = along > 0.02 and along < 0.98
                        if dist <= math.max(approach + 10.0,Config.Traffic.StartDistance) then
                            local towardX = closestX - coords.x
                            local towardY = closestY - coords.y
                            local movingToward = ((velocity.x * towardX) + (velocity.y * towardY)) > 0.2
                            local crossing = segmentsIntersect2d(coords, nextPos, segment.a, segment.b)
                            local driver = GetPedInVehicleSeat(vehicle, -1)
                            local rolling = speed > 0.45 or (driver ~= 0 and movingToward)
                            if onSpan and movingToward and dist<=Config.Traffic.StartDistance and TapeTraffic and TapeTraffic.tryDivert(vehicle,segment,segments) then
                                break
                            elseif crossing or (onSpan and dist <= hardStop and rolling) or (onSpan and dist <= approach and movingToward) then
                                if TapeTraffic then TapeTraffic.stopped(vehicle,driver,segment.id) end
                                holdAiAtTape(vehicle, coords, dist, closestX, closestY, hardStop)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

CreateThread(function()
    local nextAiWork = 0
    local nextPassWork = 0
    local nextFarRefresh = 0

    while true do
        if Config.BlockAiTraffic == false or next(activeTapes) == nil then
            if TapeTraffic then TapeTraffic.clear() end
            if next(roadBlocks) ~= nil or next(tapeBarriers) ~= nil or barrierBuild or next(barrierWanted) ~= nil then
                clearAllAiRoadBlocks()
            end
            Wait(500)
        else
            -- Traffic uses AI tasks and road nodes; never invisible collision props.
            local now = GetGameTimer()
            local due = now >= nextAiWork
            local segmentCount = 0

            if due then
                nextAiWork = now + 100
                local refreshFar = now >= nextFarRefresh
                if refreshFar then
                    nextFarRefresh = now + 2000
                end

                local cfg = aiBlockConfig()
                local width = tonumber(cfg.roadWidth) or 8.0
                local scanDistance = tonumber(cfg.scanDistance) or 90.0
                local playerCoords = GetEntityCoords(PlayerPedId())
                local segments = {}
                local seen = {}
                local resolveDist = scanDistance + 40.0

                for id, tape in pairs(activeTapes) do
                    local known = tape.mid or tape.a
                    local posA, posB, mid
                    if refreshFar or (known and #(playerCoords - known) <= resolveDist) then
                        posA, posB, mid = liveTapeEnds(tape)
                        if isFiniteVec(mid) then
                            tape.mid = mid
                        end
                    else
                        posA, posB = tape.a, tape.b
                        mid = tape.mid or ((tape.a + tape.b) * 0.5)
                    end

                    if not tape.brokenAt and not tape.accessOpen and isFiniteVec(posA) and isFiniteVec(posB) and isFiniteVec(mid) and #(posB - posA) >= 0.8 then
                        seen[id] = true
                        applyRoadBlock(id, posA, posB, width)
                        -- No physical tape wall.
                        if #(playerCoords - mid) <= scanDistance then
                            segments[#segments + 1] = {
                                id=id,detour=tape.detour,
                                a = posA,
                                b = posB,
                                z = (posA.z + posB.z) * 0.5,
                            }
                        end
                    end
                end

                for id in pairs(roadBlocks) do
                    if not seen[id] then
                        clearAiRoadBlock(id)
                    end
                end

                for id in pairs(tapeBarriers) do
                    if not seen[id] then
                        deleteTapeBarriers(id)
                    end
                end

                if #segments==0 and TapeTraffic then TapeTraffic.clear() end
                segmentCount = #segments
                if segmentCount > 0 then
                    if now >= nextPassWork then
                        nextPassWork = now + 400
                        -- Players pass tape without physics collisions.
                    end
                    holdAiTraffic(segments, cfg, playerCoords, scanDistance)
                end
            end

            if segmentCount > 0 then
                Wait(100)
            else
                Wait(400)
            end
        end
    end
end)

-- Upgrade controls. Server authorization remains authoritative for every mutation.
RegisterCommand(TapeCommands.name('tapemode'),function()
    perimeterTool=nil;movingEndpoint=nil
    freeAim=not freeAim; clearSelection()
    notify(freeAim and 'Free aim: look at a surface, E to attach. Ground creates a post.' or 'Anchor mode: cones, poles and wing mirrors.')
end,false)
RegisterCommand(TapeCommands.name('tapechain'),function() chainPlacement=not chainPlacement; notify(chainPlacement and 'Chain placement enabled.' or 'Chain placement disabled.') end,false)
RegisterCommand(TapeCommands.name('tapeundo'),function() TriggerServerEvent('apex_policetape:undo') end,false)
local function nearestTape()
    local pos=GetEntityCoords(PlayerPedId())
    local best,distance=nil,Config.EditReach
    for id,t in pairs(activeTapes) do
        local a,b=liveTapeEnds(t)
        local delta=b-a
        local length=delta.x^2+delta.y^2+delta.z^2
        local offset=pos-a
        local ratio=length>0 and math.max(0,math.min(1,(offset.x*delta.x+offset.y*delta.y+offset.z*delta.z)/length)) or 0
        local d=#(pos-(a+delta*ratio))
        if d<distance then best=id;distance=d end
    end
    return best
end
RegisterCommand(TapeCommands.name('removetape'),function()
    local id=nearestTape()
    if id then
        local t=activeTapes[id];local a,b=liveTapeEnds(t);local pos=GetEntityCoords(PlayerPedId());local point=vec3(TapeAccessMath.lerp(a,b,TapeAccessMath.fraction(pos,a,b)))
        local ok,ticket=runDeployment('cut',point)
        if ok then TriggerServerEvent('apex_policetape:edit',id,'remove',nil,ticket) end
    else notify('No tape within reach.','error') end
end,false)
RegisterCommand(TapeCommands.name('restyletape'),function()
    local id=nearestTape()
    if id then TriggerServerEvent('apex_policetape:edit',id,'style',selectedTapeStyle) else notify('No tape within reach.','error') end
end,false)
RegisterKeyMapping(Config.Command,'APEX: toggle tape placement','keyboard','')
RegisterKeyMapping(TapeCommands.name('changetape'),'APEX: choose tape design','keyboard','')
RegisterKeyMapping(TapeCommands.name('removetape'),'APEX: remove nearest tape','keyboard','')
RegisterKeyMapping(TapeCommands.name('restyletape'),'APEX: restyle nearest tape','keyboard','')
RegisterKeyMapping(TapeCommands.name('tapeundo'),'APEX: undo last span','keyboard','')
exports('StartPlacement',function() if not tapeMode then ExecuteCommand(Config.Command) end end)
exports('RemoveTape',function(id) CreateThread(function()if TapeClient then TapeClient.accessAction('cut',{id=id}) end end) end)

-- Posts are client-local, streamed from authoritative tape endpoints. Shared
-- chain endpoints reuse one object. Never create network entities for them.
local function clearPosts()
    for _,o in pairs(postObjects) do if DoesEntityExist(o) then DeleteEntity(o) end end
    postObjects={}
end
AddEventHandler('onResourceStop',function(name) if name==GetCurrentResourceName() then clearPosts() end end)
CreateThread(function()
    local model=joaat(Config.PostModel)
    while true do
        Wait(math.max(200,Config.Performance.PostRefreshMs))
        local wanted={}
        local player=GetEntityCoords(PlayerPedId())
        for _,t in pairs(activeTapes) do
            for _,side in ipairs({'A','B'}) do
                if t['post'..side] then
                    local pos=t[side=='A' and 'a' or 'b']
                    if #(player-pos)<Config.DrawDistance then wanted[('%.2f:%.2f:%.2f'):format(pos.x,pos.y,pos.z)]=pos end
                end
            end
        end
        for key,o in pairs(postObjects) do if not wanted[key] then DeleteEntity(o);postObjects[key]=nil end end
        if next(wanted) then
            if IsModelInCdimage(model) and IsModelValid(model) then
                RequestModel(model)
                local deadline=GetGameTimer()+2000
                while not HasModelLoaded(model) and GetGameTimer()<deadline do Wait(50) end
                if HasModelLoaded(model) then
                    local min,max=GetModelDimensions(model)
                    for key,pos in pairs(wanted) do
                        if not postObjects[key] or not DoesEntityExist(postObjects[key]) then
                            -- Place the prop's top at the recorded attachment height.
                            local o=CreateObjectNoOffset(model,pos.x,pos.y,pos.z-max.z,false,false,false)
                            if o~=0 then FreezeEntityPosition(o,true);SetEntityCollision(o,false,false);SetEntityAsMissionEntity(o,true,true);postObjects[key]=o end
                        end
                    end
                end
                SetModelAsNoLongerNeeded(model)
            end
        end
    end
end)

-- Advanced player tools and scene panel.
RegisterNetEvent('apex_policetape:advancedResult',function(requestId,result)
    local callback=pendingCreates[requestId]
    if callback then callback(result) end
end)
local function advanced(action,data)
    data=data or {}
    data.slack=data.slack or placementSlack
    if action=='enh_reconnect' or (action=='enh_adjust' and data.direction~='tight' and data.direction~='loose') then
        local ok,ticket=runDeployment(action=='enh_reconnect' and 'repair' or 'move',data.position)
        if not ok then return nil end;data.ticket=ticket
    end
    if action=='repair' and TapeEnhanceClient and TapeEnhanceClient.holding() then notify('Drop or reconnect the loose end first.','error');return nil end
    if action=='repair' and Config.RepairInteraction.Enabled then
        local t=activeTapes[tonumber(data.id)]
        if not t then return nil end
        local a,b=liveTapeEnds(t)
        local paths=TapeTearClient and TapeTearClient.paths(t,a,b) or TapeEnhanceMath.paths(t,a,b,Config.TornEnds.SettleMs,t.tearFloorA,t.tearFloorB)
        local nearest,reach=TapeTearMath.nearest(paths,GetEntityCoords(PlayerPedId()))
        local point=nearest and vec3(nearest)
        if not point or reach>Config.RepairInteraction.Reach then notify('Move beside the break to reconnect it.','error');return nil end
        data.position=point
    end
    if action=='target_remove' or action=='cut' then
        local t=activeTapes[tonumber(data.id)]
        if not t then return nil end
        local a,b=liveTapeEnds(t);local pos=GetEntityCoords(PlayerPedId())
        local f=TapeAccessMath.fraction(pos,a,b);local point=vec3(TapeAccessMath.lerp(a,b,f))
        local ok,ticket=runDeployment('cut',point)
        if not ok then return nil end
        data.ticket=ticket
    end
    if action=='perimeter' or action=='template_place' or action=='repair' or action=='move' then
        local ok,ticket=runDeployment(action,data.center or data.position)
        if not ok then return nil end
        data.ticket=ticket
    end
    local result=awaitServer('apex_policetape:advanced',action,data or {})
    if not result or not result.success then notify(result and result.error or 'Server request timed out.','error');return nil end
    return result
end
local function tablePoint(v) return {x=v.x,y=v.y,z=v.z} end
RegisterCommand(TapeCommands.name('tapescene'),function(_,args)
    local action=args[1] or 'list'
    if action=='new' then
        local result=advanced('new',{name=table.concat(args,' ',2)})
        if result then activeSceneId=result.sceneId;notify(('Scene #%s selected.'):format(activeSceneId),'success') end
    elseif action=='use' then
        if args[2]=='none' then activeSceneId=nil;notify('New tape will be ungrouped.');return end
        local result=advanced('select',{sceneId=tonumber(args[2])})
        if result then activeSceneId=result.sceneId;notify(('Scene #%s selected.'):format(activeSceneId)) end
    elseif action=='list' then
        local result=advanced('list')
        if result then
            notify(('Active scene: %s • %d available.'):format(activeSceneId or 'none',#result.scenes))
            for _,s in ipairs(result.scenes) do TriggerEvent('chat:addMessage',{args={'APEX',('#%d %s • %d spans'):format(s.id,s.name,s.count)}}) end
        end
    elseif activeSceneId then
        local mapped={rename='rename',clear='clear',delete='delete',style='style',expiry='expiry'}
        if not mapped[action] then notify('Use: new NAME / use ID / list / rename NAME / style / expiry MIN / clear / delete.');return end
        local result=advanced(mapped[action],{sceneId=activeSceneId,name=table.concat(args,' ',2),minutes=tonumber(args[2]),style=selectedTapeStyle})
        if result then notify('Scene updated.','success');if action=='delete' then activeSceneId=nil end end
    else notify('Create or select a scene first.','error') end
end,false)
RegisterCommand(TapeCommands.name('tapeheight'),function(_,args)
    if not Config.Placement.Enabled then return end
    local height=tonumber(args[1])
    if not TapeGeometry.finite(height) or height<Config.Placement.MinHeight or height>Config.Placement.MaxHeight then notify('Height must be within the configured limits.','error');return end
    placementHeight=height;notify(('Attachment height: %.2f m'):format(height))
end,false)
RegisterCommand(TapeCommands.name('tapesnap'),function()
    if not Config.Placement.Enabled then return end
    snapEnabled=not snapEnabled;notify(snapEnabled and 'Endpoint snapping on.' or 'Endpoint snapping off.')
end,false)
RegisterCommand(TapeCommands.name('tapegrid'),function(_,args)
    if not Config.Placement.Enabled then return end
    local value=tonumber(args[1])
    if not TapeGeometry.finite(value) or value<0 or value>2 then notify('Grid size: 0 to disable, or up to 2 metres.','error');return end
    gridSize=value;notify(('Placement grid: %.2f m'):format(value))
end,false)
RegisterCommand(TapeCommands.name('tapeperimeter'),function(_,args)
    if not Config.Presets.Enabled then return end
    if not activeSceneId then notify('Use /tapescene new NAME first.','error');return end
    if not playerCanUseTape() then notify('Tape access denied.','error');return end
    local kind=args[1] or 'rectangle'
    local defaults=Config.Presets
    local width=tonumber(args[2]) or (kind=='circle' and defaults.Circle.Radius or kind=='road' and defaults.Road.Width or defaults.Rectangle.Width)
    local length=tonumber(args[3]) or defaults.Rectangle.Length
    local spacing=tonumber(args[4]) or defaults.DefaultSpacing
    local spans,err=TapeGeometry.preset(kind,{x=0,y=0,z=0},0,width,length,spacing)
    if not spans then notify(err,'error');return end
    clearSelection();movingEndpoint=nil
    perimeterTool={kind=kind,width=width,length=length,spacing=spacing,heading=GetEntityHeading(PlayerPedId())}
    lastPerimeterPreset=perimeterTool and TapeSettings.copy(perimeterTool) or nil
    closeTapeMenu(true);scenePanelOpen=false;SetNuiFocus(false,false);SendNUIMessage({action='closeScenes'})
    freeAim=true;tapeMode=true;notify('Aim at level ground. E confirms; arrows rotate/adjust height; Backspace cancels.')
end,false)
RegisterCommand(TapeCommands.name('tapemove'),function(_,args)
    if not Config.Placement.Enabled then return end
    local id=nearestTape()
    local t=id and activeTapes[id]
    if not t or t.brokenAt then notify('No intact tape within reach.','error');return end
    local a,b=liveTapeEnds(t)
    local player=GetEntityCoords(PlayerPedId())
    local side=args[1] and args[1]:lower() or (#(player-a)<=#(player-b) and 'a' or 'b')
    if side~='a' and side~='b' then notify('Use /tapemove, /tapemove a or /tapemove b.','error');return end
    if #(player-(side=='a' and a or b))>Config.EditReach then notify('Move closer to the endpoint.','error');return end
    clearSelection();perimeterTool=nil
    movingEndpoint={id=id,side=side,revision=t.revision or 0}
    closeTapeMenu(true);scenePanelOpen=false;SetNuiFocus(false,false);SendNUIMessage({action='closeScenes'})
    freeAim=true;tapeMode=true;notify('Aim at the replacement point. E moves the junction; Backspace cancels.')
end,false)
RegisterCommand(TapeCommands.name('tapegroup'),function()
    if not activeSceneId then notify('Select a scene first.','error');return end
    local id=nearestTape()
    if not id then notify('No tape within reach.','error');return end
    if advanced('assign',{id=id,sceneId=activeSceneId}) then notify('Span added to the active scene.','success') end
end,false)
advancedPlacement=function(anchor)
    local cfg=Config.Placement
    if featurePadActive() then DisableControlAction(0,22,true);DisableControlAction(0,Config.Controller.Cancel,true) end
    if cfg.Enabled then
        for _,control in ipairs({featureControl('up'),featureControl('down')}) do DisableControlAction(0,control,true) end
        if IsDisabledControlJustPressed(0,featureControl('up')) then placementHeight=math.min(cfg.MaxHeight,placementHeight+cfg.HeightStep);placementAnchor=nil;nextPlacementScan=0 end
        if IsDisabledControlJustPressed(0,featureControl('down')) then placementHeight=math.max(cfg.MinHeight,placementHeight-cfg.HeightStep);placementAnchor=nil;nextPlacementScan=0 end
    end
    if not perimeterTool and not movingEndpoint then
        if featurePadActive() and (featurePressed('left') or featurePressed('right')) then
            local ids={} for id,style in pairs(availableTapeStyles) do if style.enabled~=false then ids[#ids+1]=id end end
            table.sort(ids)
            if #ids>0 then
                local index=1 for i,id in ipairs(ids) do if id==selectedTapeStyle then index=i end end
                index=(index-1+(featurePressed('left') and -1 or 1))%#ids+1
                applySelectedTapeStyle(ids[index])
            end
        end
        return false
    end
    SetCurrentPedWeapon(PlayerPedId(),joaat('WEAPON_UNARMED'),true);DisablePlayerFiring(PlayerId(),true)
    DisableControlAction(0,featureControl('confirm'),true)
    local data,valid
    if perimeterTool then
        for _,control in ipairs({featureControl('left'),featureControl('right')}) do DisableControlAction(0,control,true) end
        if IsDisabledControlJustPressed(0,featureControl('left')) then perimeterTool.heading=perimeterTool.heading-cfg.RotationStep end
        if IsDisabledControlJustPressed(0,featureControl('right')) then perimeterTool.heading=perimeterTool.heading+cfg.RotationStep end
        if anchor and anchor.post and not anchor.snapped then
            data={kind=perimeterTool.kind,center=tablePoint(anchor.attach),heading=perimeterTool.heading,width=perimeterTool.width,length=perimeterTool.length,spacing=perimeterTool.spacing,sceneId=activeSceneId,style=selectedTapeStyle}
            local spans
            if perimeterTool.kind=='template' then data.templateId=perimeterTool.templateId;spans=TapeSceneTools.transform(perimeterTool.spans,data.center,data.heading)
            else spans=TapeGeometry.preset(data.kind,data.center,data.heading,data.width,data.length,data.spacing) end
            valid=spans~=nil
            if spans then
                for _,s in ipairs(spans) do
                    renderCustomText=TapeCustomTextClient and TapeCustomTextClient.selected() or nil
                    drawTapeSpan(vec3(s.a),vec3(s.b),nil,nil,nil,s.style or selectedTapeStyle,nil,'preview')
                    renderCustomText=nil
                    DrawLine(s.a.x,s.a.y,s.a.z,s.b.x,s.b.y,s.b.z,230,192,93,220)
                    if TapePolishClient then TapePolishClient.previewTraffic(vec3(s.a),vec3(s.b)) end
                    DrawMarker(28,s.a.x,s.a.y,s.a.z,0.0,0.0,0.0,0.0,0.0,0.0,0.13,0.13,0.13,230,192,93,220,false,false,2,false,nil,nil,false)
                    if #(GetEntityCoords(PlayerPedId())-vec3(s.a))>Config.PlacementReach then valid=false end
                end
            end
        end
        setPrompt(valid and ('[E] Place %s • arrows: rotate/height • %.1f m • Backspace: cancel'):format(perimeterTool.kind,placementHeight) or 'Aim at level ground within reach. Backspace cancels.')
    else
        local t=activeTapes[movingEndpoint.id]
        if not t or t.brokenAt or t.revision~=movingEndpoint.revision then movingEndpoint=nil;notify('Tape changed. Select it again.','error');return true end
        if anchor then
            local a,b=liveTapeEnds(t)
            local fixed=movingEndpoint.side=='a' and b or a
            local length=#(anchor.attach-fixed)
            valid=length>=Config.MinLength and length<=Config.MaxDistance and #(GetEntityCoords(PlayerPedId())-anchor.attach)<=Config.EditReach
            renderCustomText=t.customText
            drawTapeSpan(fixed,anchor.attach,nil,nil,nil,t.style,nil,'preview')
            renderCustomText=nil
            data={id=t.id,side=movingEndpoint.side,revision=movingEndpoint.revision,position=tablePoint(anchor.attach),post=anchor.post==true}
        end
        setPrompt(valid and '[E] Move endpoint • arrows: height • Backspace: cancel' or 'Choose a valid point within edit reach. Backspace cancels.')
    end
    if featurePressed('cancel') then perimeterTool=nil;movingEndpoint=nil;setPrompt(nil);return true end
    if valid and featurePressed('confirm') then
        local result=advanced(perimeterTool and (perimeterTool.kind=='template' and 'template_place' or 'perimeter') or 'move',data)
        if result then if result.sceneId then activeSceneId=result.sceneId end;perimeterTool=nil;movingEndpoint=nil;clearSelection();notify('Placement updated.','success') end
    end
    return true
end
local scenePanelAdmin=false
local function fieldKitScenes(result)
    local pos=GetEntityCoords(PlayerPedId())
    for _,scene in ipairs(result.scenes or {}) do
        if scene.center then
            scene.distance=math.sqrt((pos.x-scene.center.x)^2+(pos.y-scene.center.y)^2+(pos.z-scene.center.z)^2)
        end
    end
    return result.scenes
end
local function refreshScenePanel()
    local result=advanced('list',{admin=scenePanelAdmin})
    if result and result.rules then availableTapeStyles=result.rules.styles end
    if result then SendNUIMessage({action='scenes',scenes=fieldKitScenes(result),active=activeSceneId,admin=scenePanelAdmin,styles=availableTapeStyles,locale=TapeLocale.UI()}) end
end
local function openScenePanel(isAdmin)
    if tapeMenuOpen or scenePanelOpen then return end
    if isAdmin and not Config.AdminPanel.Enabled then return end
    local result=advanced('list',{admin=isAdmin})
    if not result then return end
    if result.rules then availableTapeStyles=result.rules.styles end
    scenePanelAdmin=isAdmin;scenePanelOpen=true
    clearSelection();perimeterTool=nil;movingEndpoint=nil
    SetNuiFocus(true,true)
    SendNUIMessage({action='scenes',scenes=fieldKitScenes(result),active=activeSceneId,admin=isAdmin,styles=availableTapeStyles,locale=TapeLocale.UI()})
end
RegisterCommand(TapeCommands.name('tapescenes'),function() openScenePanel(false) end,false)
RegisterCommand(TapeCommands.name('tapeadmin'),function() openScenePanel(true) end,false)
RegisterNUICallback('sceneAction',function(data,cb)
    if not scenePanelOpen or type(data)~='table' then cb({ok=false});return end
    if data.action=='refresh' then refreshScenePanel();cb({ok=true});return end
    if data.action=='waypoint' then
        local result=advanced('list',{admin=scenePanelAdmin})
        if result then for _,s in ipairs(result.scenes) do if s.id==tonumber(data.sceneId) and s.center then SetNewWaypoint(s.center.x,s.center.y) end end end
        cb({ok=result~=nil});return
    end
    local allowed={new=true,rename=true,select=true,clear=true,delete=true,style=true,expiry=true,handover=true,recover=true}
    if not allowed[data.action] then cb({ok=false});return end
    local result=advanced(data.action,{sceneId=tonumber(data.sceneId),name=data.name,minutes=tonumber(data.minutes),style=data.style,target=tonumber(data.target),department=data.department})
    if result then
        if data.action=='new' or data.action=='select' or data.action=='recover' then activeSceneId=result.sceneId end
        if data.action=='delete' and activeSceneId==tonumber(data.sceneId) then activeSceneId=nil end
        refreshScenePanel()
    end
    cb({ok=result~=nil})
end)
RegisterNUICallback('closeScenes',function(_,cb) scenePanelOpen=false;SetNuiFocus(false,false);SendNUIMessage({action='closeScenes'});cb({ok=true}) end)
AddEventHandler('onResourceStop',function(name) if name==GetCurrentResourceName() and scenePanelOpen then SetNuiFocus(false,false) end end)

-- PNGs load once on demand. No browser instances, timeout race or DUI cache churn.
queueTapeTexture=function(style)
    if not textureState[style] then textureQueue[style]=true end
end
CreateThread(function()
    while true do
        Wait(50)
        if runtimeTxd then
            local style=next(textureQueue)
            if style then textureQueue[style]=nil;loadTapeStyleTexture(runtimeTxd,tapeDict,style) end
        end
    end
end)

RegisterNetEvent('apex_policetape:rules',function(rules)
    if type(rules)~='table' or type(rules.styles)~='table' then return end
    availableTapeStyles=rules.styles
    if not availableTapeStyles[selectedTapeStyle] and rules.default then selectedTapeStyle=rules.default end
end)
RegisterCommand(TapeCommands.name('tapecut'),function() ExecuteCommand(TapeCommands.name('removetape')) end,false)
RegisterCommand(TapeCommands.name('taperepair'),function()
    if not Config.Repair.Enabled then return end
    local player=GetEntityCoords(PlayerPedId())
    local nearest,best=nil,Config.EditReach
    for id,t in pairs(activeTapes) do
        if t.brokenAt then
            local a,b=liveTapeEnds(t)
            local paths=TapeTearClient and TapeTearClient.paths(t,a,b) or TapeEnhanceMath.paths(t,a,b,Config.TornEnds.SettleMs,t.tearFloorA,t.tearFloorB)
            local _,distance=TapeTearMath.nearest(paths,player)
            if distance<best then best=distance;nearest=id end
        end
    end
    if not nearest then notify('No torn tape within reach.','error');return end
    if advanced('repair',{id=nearest,revision=activeTapes[nearest].revision}) then notify('Tape repaired.','success') end
end,false)
RegisterCommand(TapeCommands.name('taperefund'),function()
    local result=advanced('refunds')
    if result then notify(('Claimed %d refunded items.'):format(result.count),'success') end
end,false)
RegisterKeyMapping(TapeCommands.name('taperepair'),'APEX: repair torn tape','keyboard','')

-- Deployment reuses existing help/notification surfaces; the NUI layout is unchanged.
local deploymentBusy=false
local deploymentObject
local deploymentAnim
local function cleanupDeployment(ped)
    if deploymentObject and DoesEntityExist(deploymentObject) then DeleteEntity(deploymentObject) end
    deploymentObject=nil
    local anim=deploymentAnim or Config.Deployment
    StopAnimTask(ped,anim.AnimDict,anim.AnimName,1.0)
    RemoveAnimDict(anim.AnimDict);deploymentAnim=nil
    setPrompt(nil)
end
runDeployment=function(operation,position)
    local cfg=TapeSettings.copy(Config.Deployment)
    if operation=='cut' then for k,v in pairs(Config.Cutting) do cfg[k]=v end end
    if operation=='repair' and Config.RepairInteraction.Enabled then cfg.DurationMs=Config.RepairInteraction.DurationMs end
    if not cfg.Enabled or (operation=='repair' and not cfg.ApplyToRepair) or (operation=='move' and not cfg.ApplyToMove) then return true end
    if deploymentBusy then return false end
    deploymentBusy=true;deploymentAnim=cfg
    local ped=PlayerPedId()
    local start=GetEntityCoords(ped)
    if position and type(TaskTurnPedToFaceCoord)=='function' then TaskTurnPedToFaceCoord(ped,position.x,position.y,position.z,250) end
    local plainPosition=position and {x=position.x,y=position.y,z=position.z} or nil
    local result=awaitServer('apex_policetape:advanced','deploy_begin',{operation=operation,position=plainPosition})
    if not result or not result.success then deploymentBusy=false;notify(result and result.error or 'Server request timed out.','error');return false end
    if result.disabled then deploymentBusy=false;return true end
    local cancelled=false
    local function shouldCancel()
        return IsEntityDead(ped) or IsPedInAnyVehicle(ped,false) or IsPauseMenuActive() or IsNuiFocused()
            or (operation~='repair' and operation~='cut' and not tapeMode) or #(GetEntityCoords(ped)-start)>cfg.MaxMovement or featurePressed('cancel')
    end
    if type(SetCurrentPedWeapon)=='function' then SetCurrentPedWeapon(ped,joaat('WEAPON_UNARMED'),true) end
    RequestAnimDict(cfg.AnimDict)
    local timeout=GetGameTimer()+2000
    while not HasAnimDictLoaded(cfg.AnimDict) and GetGameTimer()<timeout do Wait(0);if shouldCancel() then cancelled=true;break end end
    if cancelled then cleanupDeployment(ped);deploymentBusy=false;awaitServer('apex_policetape:advanced','deploy_cancel',{});return false end
    if HasAnimDictLoaded(cfg.AnimDict) then TaskPlayAnim(ped,cfg.AnimDict,cfg.AnimName,3.0,-3.0,-1,49,0.0,false,false,false) end
    if cfg.PropModel~='' then
        local model=joaat(cfg.PropModel)
        if IsModelInCdimage(model) and IsModelValid(model) then
            RequestModel(model);timeout=GetGameTimer()+2000
            while not HasModelLoaded(model) and GetGameTimer()<timeout do Wait(0);if shouldCancel() then cancelled=true;break end end
            if cancelled then SetModelAsNoLongerNeeded(model);cleanupDeployment(ped);deploymentBusy=false;awaitServer('apex_policetape:advanced','deploy_cancel',{});return false end
            if HasModelLoaded(model) then
                deploymentObject=CreateObjectNoOffset(model,start.x,start.y,start.z,cfg.NetworkedProp,true,false)
                if deploymentObject and deploymentObject~=0 then
                    SetEntityCollision(deploymentObject,false,false)
                    AttachEntityToEntity(deploymentObject,ped,GetPedBoneIndex(ped,cfg.Bone),cfg.Offset.x,cfg.Offset.y,cfg.Offset.z,cfg.Rotation.x,cfg.Rotation.y,cfg.Rotation.z,true,true,false,true,1,true)
                end
                SetModelAsNoLongerNeeded(model)
            end
        end
    end
    local begun,nextPrompt=GetGameTimer(),0
    while GetGameTimer()-begun<result.duration do
        Wait(0)
        DisablePlayerFiring(PlayerId(),true)
        DisableControlAction(0,featureControl('cancel'),true)
        if shouldCancel() then cancelled=true;break end
        if GetGameTimer()>=nextPrompt then
            nextPrompt=GetGameTimer()+150
            setPrompt(((operation=='cut' and 'Cutting tape' or operation=='repair' and 'Reconnecting tape' or 'Preparing tape')..'… %d%% • Backspace: cancel'):format(math.floor((GetGameTimer()-begun)/result.duration*100)))
        end
        drawNativePrompt()
    end
    cleanupDeployment(ped);deploymentBusy=false
    if not cancelled and operation=='repair' and TapePolishClient then TapePolishClient.sound() end
    if cancelled then awaitServer('apex_policetape:advanced','deploy_cancel',{});notify('Deployment cancelled.','inform');return false end
    return true,result.ticket
end
AddEventHandler('onResourceStop',function(name)if name==GetCurrentResourceName() then cleanupDeployment(PlayerPedId()) end end)
RegisterCommand(TapeCommands.name('tapeaccess'),function(_,args)
    local id=nearestTape()
    if not id then notify('No tape within reach.','error');return end
    local action=activeTapes[id].accessOpen and 'access_close' or 'access_open'
    if action=='access_open' and Config.Access.Interactive and TapeAccessClient and not TapeAccessClient.prepare() then notify('Lift animation unavailable. Please try again.','error');return end
    if advanced(action,{id=id,seconds=tonumber(args[1])}) then notify(action=='access_open' and (Config.Access.Interactive and 'Lifting tape. Stay still; Backspace lowers it early.' or 'Access gap opened.') or 'Lowering tape.','success') end
end,false)
RegisterCommand(TapeCommands.name('tapeclose'),function()
    local id=nearestTape()
    if id then advanced('access_close',{id=id}) end
end,false)
RegisterCommand(TapeCommands.name('tapedetour'),function(_,args)
    if not activeSceneId then notify('Select a scene first.','error');return end
    local action=args[1]=='clear' and 'detour_clear' or 'detour_add'
    local result=advanced(action,{sceneId=activeSceneId})
    if result then notify(('Detour now has %d waypoints.'):format(result.count),'success') end
end,false)
RegisterCommand(TapeCommands.name('tapetemplate'),function(_,args)
    local action=args[1] or 'list'
    if action=='list' then
        local result=advanced('template_list',{})
        if result then for _,template in ipairs(result.templates) do TriggerEvent('chat:addMessage',{args={'APEX',('#%d %s • %d spans'):format(template.id,template.name,template.count)}}) end end
    elseif action=='save' then
        if not activeSceneId then notify('Select a scene first.','error');return end
        local result=advanced('template_save',{sceneId=activeSceneId,name=table.concat(args,' ',2),heading=GetEntityHeading(PlayerPedId())})
        if result then notify(('Template #%d saved.'):format(result.templateId),'success') end
    elseif action=='delete' then
        if advanced('template_delete',{templateId=tonumber(args[2])}) then notify('Template deleted.','success') end
    elseif action=='place' then
        local result=advanced('template_get',{templateId=tonumber(args[2])})
        if not result then return end
        clearSelection();movingEndpoint=nil
        perimeterTool={kind='template',templateId=result.template.id,spans=result.template.spans,heading=GetEntityHeading(PlayerPedId())}
        lastPerimeterPreset=perimeterTool and TapeSettings.copy(perimeterTool) or nil
    closeTapeMenu(true);scenePanelOpen=false;SetNuiFocus(false,false);SendNUIMessage({action='closeScenes'})
    freeAim=true;tapeMode=true;notify('Aim at level ground. E confirms; arrows rotate/adjust height; Backspace cancels.')
    else notify('Use /tapetemplate list, save NAME, place ID or delete ID.','error') end
end,false)
RegisterKeyMapping(TapeCommands.name('tapeaccess'),'APEX: toggle temporary access gap','keyboard','')
RegisterCommand(TapeCommands.name('tapepad'),function()ExecuteCommand(Config.Command)end,false)
CreateThread(function()
    while true do
        if not Config.Controller.Enabled then Wait(1000)
        else
            Wait(0)
            if featurePadActive() and not IsPauseMenuActive() and not IsNuiFocused() then
                local modifier=Config.Controller.StartModifier
                if IsControlPressed(0,modifier) or IsDisabledControlPressed(0,modifier) then
                    if IsControlJustPressed(0,Config.Controller.StartButton) then ExecuteCommand(Config.Command)
                    elseif IsControlJustPressed(0,Config.Controller.AccessButton or 204) then ExecuteCommand(TapeCommands.name('tapeaccess'))
                    elseif not tapeMode and IsControlJustPressed(0,Config.Controller.Cancel) then ExecuteCommand(TapeCommands.name('taperepair')) end
                end
            end
        end
    end
end)
TapeClient={playerVehicle=isPlayerControlledVehicle,haltVehicle=haltAiVehicle,tapes=function()return activeTapes end,liveEnds=liveTapeEnds,accessAction=advanced}
-- /tapediag prints a compact state report locally and in FXServer for remote support.
RegisterCommand(TapeCommands.name('tapediag'),function()
    local loaded,failed,placed=0,0,0
    local failedStyles={}
    for style,entry in pairs(textureState) do if entry.ready then loaded=loaded+1 else failed=failed+1;failedStyles[#failedStyles+1]=style end end
    for _ in pairs(activeTapes) do placed=placed+1 end
    local report={version=Config.Version,build=Config.Build,mode=freeAim and 'aim' or 'anchors',active=isTapeModeActive(),blocked=isBlocked(),
        focus=IsNuiFocused and IsNuiFocused() or false,menu=tapeMenuOpen,scenePanel=scenePanelOpen,
        hit=placementAnchor~=nil,ground=placementAnchor and placementAnchor.post==true or false,
        firstPoint=selectedAnchorId~=nil,tapes=placed,textures=loaded,failed=failed,ready=tapeTextureReady,
        embedded=TapeImageData~=nil,drawNative=type(DrawTexturedPoly)=='function',failedStyles=failedStyles,uvFloats=true,
        holdAnimation=Config.Access.AnimDict..'/'..Config.Access.AnimName,armIK=Config.Access.Pose=='one_hand' and type(SetIkTarget)=='function'}
    print('[APEX Tape diagnostic] '..json.encode(report))
    TriggerServerEvent('apex_policetape:diagnostic',report)
    notify(('Tape check: %s, %d spans, %d textures. Report sent to server console.'):format(report.blocked and 'input blocked' or 'input ready',placed,loaded),'inform')
end,false)
-- Explicit recovery only closes APEX panels; it never releases another resource's focus.
RegisterCommand(TapeCommands.name('tapereset'),function()
    if tapeMenuOpen or scenePanelOpen then
        closeTapeMenu(true);scenePanelOpen=false;SendNUIMessage({action='closeScenes'})
    end
    perimeterTool=nil;movingEndpoint=nil;clearSelection();placementAnchor=nil;nextPlacementScan=0
    notify('Tape selection reset. /ptape toggles placement.','inform')
end,false)

-- Public internal hooks for the optional polish module; validated server actions remain authoritative.
TapeClient.notify=notify
TapeClient.preferences=function(value)
    if value then
        if value.style and availableTapeStyles[value.style] then applySelectedTapeStyle(value.style) end
        placementHeight=value.height or placementHeight;placementSlack=value.slack or placementSlack
        if value.perimeter then
            perimeterTool=TapeSettings.copy(value.perimeter);freeAim=true;tapeMode=true
            closeTapeMenu(true);scenePanelOpen=false;SetNuiFocus(false,false)
        end
    end
    return {style=selectedTapeStyle,height=placementHeight,slack=placementSlack,perimeter=perimeterTool or lastPerimeterPreset}
end
TapeClient.aimedAnchor=aimedAnchor
for _,name in ipairs({'tapeadjust','pickuptape','reconnecttape','droptape','tapepass','tapeinspect'})do
 RegisterCommand(TapeCommands.name(name),function(_,args)if TapeEnhanceClient then TapeEnhanceClient.command(name,args or {})end end,false)
end
TapeClient.scene=function()return activeSceneId end
TapeClient.selectScene=function(id)activeSceneId=id end
TapeClient.drawRemnant=function(record,drop)
    drawPlacedSpan({id=record.id,posA=vec3(record.a)-vector3(0,0,drop),posB=vec3(record.b)-vector3(0,0,drop),style=record.style,brokenAt=true,breakFraction=record.fraction or .5},{},'ribbon')
end
for _,id in ipairs({'tapehandover','taperecover','tapefavourite','tapecomfort','tapetension','tapetrafficpreview'}) do
    RegisterCommand(TapeCommands.name(id),function(_,args)if TapePolishClient then TapePolishClient.command(id,args or {}) end end,false)
end

TapeClient.refreshPrompt=function()local text=promptText;promptText=nil;setPrompt(text)end

RegisterCommand(TapeCommands.name('tapelevel'),function()
    Config.Placement.Level=not Config.Placement.Level
    placementAnchor=nil;nextPlacementScan=0
    notify(Config.Placement.Level and 'Level tape placement on: connected spans keep their height.' or 'Surface height placement on: aim each endpoint independently.')
end,false)

RegisterCommand(TapeCommands.name('tapeeditor'),function(_,args)if TapeEditorClient then TapeEditorClient.command(args or {}) end end,false)

RegisterCommand(TapeCommands.name('tapetext'),function(_,args)if TapeCustomTextClient then CreateThread(function()TapeCustomTextClient.command(args or {})end) end end,false)

TapeClient.closePanels=function()
 if tapeMenuOpen or scenePanelOpen then
  closeTapeMenu(true);scenePanelOpen=false;SendNUIMessage({action='closeScenes'});SetNuiFocus(false,false)
 end
end

-- APEX Field Kit: NUI routes keep all scene mutations on the existing server API.
RegisterNUICallback('fieldKitNavigate',function(data,cb)
    if not tapeMenuOpen and not scenePanelOpen then cb({ok=false});return end
    if data.tab=='scenes' then
        local result=advanced('list',{admin=false})
        if not result then cb({ok=false});return end
        if result.rules then availableTapeStyles=result.rules.styles end
        tapeMenuOpen=false;scenePanelOpen=true;scenePanelAdmin=false
        SendNUIMessage({action='scenes',scenes=fieldKitScenes(result),active=activeSceneId,admin=false,styles=availableTapeStyles,locale=TapeLocale.UI()})
    elseif data.tab=='deploy' then
        scenePanelOpen=false;tapeMenuOpen=true;menuOpenedAt=GetGameTimer()
        SendNUIMessage({action='open',style=TapeCustomTextClient and TapeCustomTextClient.selected() and '__custom_text' or selectedTapeStyle,styles=availableTapeStyles,locale=TapeLocale.UI(),commands=Config.Commands,
          customText={enabled=Config.CustomText.Enabled,label='Custom text',text=TapeCustomTextClient and TapeCustomTextClient.selected() or 'YOUR TEXT HERE',background=Config.CustomText.Background,foreground=Config.CustomText.Foreground}})
    else cb({ok=false});return end
    cb({ok=true})
end)
local function fieldKitPreferences()
    local comfort=TapePolishClient and TapePolishClient.preferences and TapePolishClient.preferences() or {}
    return {height=placementHeight,minHeight=Config.Placement.MinHeight,maxHeight=Config.Placement.MaxHeight,freeAim=freeAim,chain=chainPlacement,snap=snapEnabled,slack=placementSlack,
        scale=comfort.scale or 1,maxScale=Config.Polish.MaxPromptScale,lift=comfort.lift or 'toggle'}
end
RegisterNUICallback('fieldKitPreferences',function(data,cb)
    if not tapeMenuOpen and not scenePanelOpen then cb({ok=false});return end
    if data.action=='save' then
        local height,slack,scale=tonumber(data.height),tonumber(data.slack),tonumber(data.scale)
        if not TapeGeometry.finite(height) or height<Config.Placement.MinHeight or height>Config.Placement.MaxHeight
          or not TapeGeometry.finite(slack) or slack<.98 or slack>1.08
          or not TapeGeometry.finite(scale) or scale<1 or scale>Config.Polish.MaxPromptScale
          or type(data.freeAim)~='boolean' or type(data.chain)~='boolean' or type(data.snap)~='boolean'
          or (data.lift~='hold' and data.lift~='toggle') then cb({ok=false});return end
        placementHeight=height;placementSlack=slack;freeAim=data.freeAim;chainPlacement=data.chain;snapEnabled=data.snap
        clearSelection();placementAnchor=nil;nextPlacementScan=0
        if TapePolishClient and Config.Polish.Enabled then
            TapePolishClient.command('tapecomfort',{'scale',tostring(scale)})
            TapePolishClient.command('tapecomfort',{'lift',data.lift})
        end
    elseif data.action~='get' then cb({ok=false});return end
    cb({ok=true,preferences=fieldKitPreferences()})
end)
TapeClient.fieldKitPlacement=function()return isTapeModeActive() and not isBlocked() and not tapeMenuOpen and not scenePanelOpen end
CreateThread(function()
    local wasVisible=false
    while true do
        Wait(150)
        local visible=TapeClient.fieldKitPlacement()
        if visible then
            local custom=TapeCustomTextClient and TapeCustomTextClient.selected()
            local label=custom and 'Custom text' or (availableTapeStyles[selectedTapeStyle] or {}).label or selectedTapeStyle
            local anchor=nearbyAnchor
            local length=selectedAttach and anchor and #(selectedAttach-anchor.attach) or 0
            local valid,reason=TapeEnhanceMath.feedback(anchor,selectedAttach,Config.MinLength,Config.MaxDistance,placementHint)
            if perimeterTool or movingEndpoint then reason=promptText or 'Choose an attachment point.' end
            local keys={{featurePadActive() and Config.Controller.ConfirmLabel or 'E','Attach'},{featurePadActive() and Config.Controller.CancelLabel or 'Backspace','Cancel selection'}}
            if freeAim then keys[#keys+1]={featurePadActive() and 'D-pad' or '↑ / ↓','Height'} end
            keys[#keys+1]={'/'..TapeCommands.name('tapeundo'),'Undo'}
            keys[#keys+1]={'/'..TapeCommands.name('ptape'),'Finish'}
            SendNUIMessage({action='fieldKitHud',visible=true,label=label,mode=freeAim and 'SURFACE AIM' or 'ANCHOR MODE',height=placementHeight,length=length,chain=chainPlacement,scene=activeSceneId,prompt=TapeLocale.Render(reason),scale=(TapePolishClient and TapePolishClient.preferences and TapePolishClient.preferences().scale or 1),keys=keys})
        elseif wasVisible then SendNUIMessage({action='fieldKitHud',visible=false}) end
        wasVisible=visible
    end
end)
