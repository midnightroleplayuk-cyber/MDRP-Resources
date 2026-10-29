-- NPC Ordering System (Multi-Station)
OrderNPCs = {} -- stationId -> {orderId -> npcData}
CurrentOrders = {} -- stationId -> orderData
BartenderServiceActive = {} -- stationId -> boolean
SubmittedDrinks = {} -- Track which drinks have been submitted
LoadedStations = {} -- stationId -> station data
StationInteractions = {} -- stationId -> interactionIndex
StationRegisterProps = {} -- stationId -> register prop entity (visible for all clients)

-- Drink menu for current station (fetched on station start)
CurrentStationMenu = nil -- array of { drinkKey, name, flavors, alcoholPct, item }

-- Match flavorWeights against the current station menu; returns the menu entry name or nil
function MatchDrinkToMenuName(flavorWeights)
    if not CurrentStationMenu or not flavorWeights then return nil end
    local alcoholKey = Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.key or "_alcohol"
    local alcoholWeight = flavorWeights[alcoholKey] or 0
    local submittedAlcoholPct = math.floor(alcoholWeight * 100 + 0.5)
    local tolerance = Config.Bartender.alcoholTolerance or 10

    local tasteWeight = 0
    local submittedTaste = {}
    for key, weight in pairs(flavorWeights) do
        if key ~= alcoholKey and weight > 0.01 then
            submittedTaste[key] = weight
            tasteWeight = tasteWeight + weight
        end
    end
    if tasteWeight < 0.3 then return nil end

    -- Balance tolerance: each flavor can deviate this much from the ideal equal share (1/n)
    -- e.g., for 3 flavors ideal is 33% each; with 0.15 tolerance, 18%-48% each is acceptable
    local balanceTolerance = 0.15

    for _, entry in ipairs(CurrentStationMenu) do
        if entry.flavors and #entry.flavors > 0 then
            local entryAlcohol = entry.alcoholPct or 0
            if math.abs(submittedAlcoholPct - entryAlcohol) <= tolerance then
                local numFlavors = #entry.flavors
                local allPresent = true
                local requiredWeight = 0
                local flavorRatios = {}
                for _, flavorKey in ipairs(entry.flavors) do
                    local w = submittedTaste[flavorKey] or 0
                    if w < 0.01 then allPresent = false; break end
                    requiredWeight = requiredWeight + w
                    flavorRatios[#flavorRatios + 1] = w
                end
                if allPresent then
                    -- Check that required flavors dominate (no big extra flavors)
                    local dominanceThreshold = numFlavors == 1 and 0.85 or 0.70
                    if (requiredWeight / tasteWeight) >= dominanceThreshold then
                        -- Check balance: each flavor should be close to 1/numFlavors of requiredWeight
                        local balanced = true
                        if numFlavors > 1 then
                            local idealShare = 1.0 / numFlavors
                            for _, w in ipairs(flavorRatios) do
                                local share = w / requiredWeight
                                if math.abs(share - idealShare) > balanceTolerance then
                                    balanced = false
                                    break
                                end
                            end
                        end
                        if balanced then
                            return entry.name
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- Equipped drinks system
EquippedDrinks = {} -- playerId -> {prop, flavorWeights, color, progress, thread}
PlayerEquippedDrink = nil -- Current player's equipped drink data
DrinkingThread = nil -- Thread for drinking mechanics

-- Sync locale to NUI on resource start
CreateThread(function()
    Wait(2000) -- Wait for everything to load
    if Language and Language[Config.Language] then
        SendNUIMessage({
            type = "setConfig",
            config = {
                locale = Language[Config.Language]
            }
        })
    end
end)

-- Calculate pour rate based on pitch (tilt angle)
-- Returns a multiplier from 0.0 to 1.0 based on how much the entity is tilted
function CalculatePourRate(pitch)
    -- Pitch is in degrees, where:
    -- 0-90: upright to slightly tilted
    -- 90-180: tilted, pouring starts
    -- 180: fully inverted (maximum pour)
    -- 180-270: tilted back
    -- 270-360: back to upright
    
    -- Normalize pitch to 0-360 range
    pitch = (pitch % 360 + 360) % 360
    
    -- Check if entity is tilted enough to pour (between 90 and 270 degrees)
    if pitch > 90.0 and pitch < 270.0 then
        -- Calculate how far from 90/270 we are
        -- Closer to 180 = more tilt = faster pour
        local normalizedPitch = 0.0
        if pitch <= 180.0 then
            -- Between 90 and 180: normalize from 0 to 1
            normalizedPitch = (pitch - 90.0) / 90.0
        else
            -- Between 180 and 270: normalize from 1 to 0 (mirrored)
            normalizedPitch = (270.0 - pitch) / 90.0
        end
        
        -- Apply a curve to make it feel more natural (ease-in)
        -- At 90/270: rate = 0.0 (barely pouring)
        -- At 180: rate = 1.0 (maximum pour)
        local rate = normalizedPitch * normalizedPitch -- Quadratic curve for smoother feel
        
        -- Ensure minimum pour rate when tilted (so it still pours a little)
        return math.max(0.1, rate)
    end
    
    -- Not tilted enough to pour
    return 0.0
end

-- Calculate the final color from ALL flavor weights in the drink
-- flavorWeights format: {strawberry = 0.3, lime = 0.7} where keys are flavor string keys
function CalculateColorFromFlavors(flavorWeights)
    if not flavorWeights or next(flavorWeights) == nil then
        return nil -- No flavors = no color
    end

    local totalWeight = 0
    local totalR, totalG, totalB = 0, 0, 0

    local alcoholKey = Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.key or "_alcohol"
    local alcoholColor = Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.color or {255, 255, 255}
    for flavorKey, weight in pairs(flavorWeights) do
        local color
        if flavorKey == alcoholKey then
            color = alcoholColor
        else
            local flavor = Config.Bartender.flavors[flavorKey]
            color = flavor and flavor.color
        end
        if color then
            totalWeight = totalWeight + weight
            totalR = totalR + color[1] * weight
            totalG = totalG + color[2] * weight
            totalB = totalB + color[3] * weight
        end
    end
    
    if totalWeight <= 0 then
        return nil
    end
    
    -- Normalize by total weight to get the final color from ALL flavors
    local r = math.floor(totalR / totalWeight)
    local g = math.floor(totalG / totalWeight)
    local b = math.floor(totalB / totalWeight)
    
    -- Check if the weighted average results in white (all three RGB components are high)
    -- This works with any number of flavors and any combination that produces white
    -- For example: red+green+blue, or yellow+blue, or cyan+red, etc.
    local allComponentsHigh = r > 180 and g > 180 and b > 180
    
    if allComponentsHigh then
        -- If all three components are high, produce bright white
        -- Use the average brightness to determine how white it should be
        local avgBrightness = (r + g + b) / 3
        local brightness = math.max(250, math.min(255, avgBrightness))
        return {math.floor(brightness), math.floor(brightness), math.floor(brightness)}
    end
    
    -- Return the weighted average color from ALL flavors
    return {r, g, b}
end

-- Generate item name from flavorWeights (taste flavors only; alcohol base is excluded from name)
-- Single flavor: {flavor_name}_drink
-- Mixed drinks: Sort top 2 flavors alphabetically -> {flavor1}_{flavor2}_bar_drink
function GenerateDrinkItemName(flavorWeights)
    if not flavorWeights or next(flavorWeights) == nil then
        return nil
    end
    -- Collect taste flavors only
    local flavorList = {}
    for flavorKey, weight in pairs(flavorWeights) do
        if weight > 0.001 then
            local flavor = Config.Bartender.flavors[flavorKey]
            if flavor then
                local flavorName = string.lower(flavor.label)
                flavorName = string.gsub(flavorName, "%s+", "_")
                flavorName = string.gsub(flavorName, "[^%w_]", "")
                table.insert(flavorList, {
                    name = flavorName,
                    weight = weight,
                })
            end
        end
    end
    
    if #flavorList == 0 then
        return nil
    end
    
    -- Sort by weight (descending)
    table.sort(flavorList, function(a, b) return a.weight > b.weight end)
    
    -- Single flavor
    if #flavorList == 1 or flavorList[1].weight >= (1.0 - Config.Bartender.mixThreshold) then
        return flavorList[1].name .. "_drink"
    end
    
    -- Mixed drink: sort top 2 alphabetically
    local topFlavors = {flavorList[1].name, flavorList[2].name}
    table.sort(topFlavors) -- Alphabetical sort
    return topFlavors[1] .. "_" .. topFlavors[2] .. "_bar_drink"
end

-- Convert RGB (0-255) to HSL (0-360, 0-1, 0-1)
function RGBToHSL(r, g, b)
    r = r / 255.0
    g = g / 255.0
    b = b / 255.0
    
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h, s, l = 0, 0, (max + min) / 2.0
    
    if max ~= min then
        local d = max - min
        s = l > 0.5 and d / (2.0 - max - min) or d / (max + min)
        
        if max == r then
            h = ((g - b) / d + (g < b and 6 or 0)) / 6.0
        elseif max == g then
            h = ((b - r) / d + 2) / 6.0
        else
            h = ((r - g) / d + 4) / 6.0
        end
    end
    
    return h * 360.0, s, l
end

-- Convert HSL (0-360, 0-1, 0-1) to RGB (0-255)
function HSLToRGB(h, s, l)
    h = h / 360.0
    local r, g, b
    
    if s == 0 then
        r, g, b = l, l, l
    else
        local function hue2rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end
        
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end
    
    return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end

-- Check if a color is a primary color (red, green, or blue)
function IsPrimaryColor(color)
    local r, g, b = color[1], color[2], color[3]
    -- Red: high R, low G and B
    local isRed = r > 200 and g < 50 and b < 50
    -- Green: high G, low R and B
    local isGreen = g > 200 and r < 50 and b < 50
    -- Blue: high B, low R and G
    local isBlue = b > 200 and r < 50 and g < 50
    return isRed, isGreen, isBlue
end

-- Check if mixing would result in all three primaries (should produce white)
function WouldProduceWhite(color1, color2)
    -- Simple check: if both colors together have significant amounts of all three RGB components
    -- This catches all cases: primaries, secondaries, or any mix
    local totalR = color1[1] + color2[1]
    local totalG = color1[2] + color2[2]
    local totalB = color1[3] + color2[3]
    
    -- If we have significant amounts of all three components, we have all primaries
    local hasAllComponents = totalR > 150 and totalG > 150 and totalB > 150
    if hasAllComponents then
        return true
    end
    
    -- Also check individual color detection for more accuracy
    local r1, g1, b1 = IsPrimaryColor(color1)
    local r2, g2, b2 = IsPrimaryColor(color2)
    
    -- Check if we have all three primaries between the two colors
    local hasRed = r1 or r2 or color1[1] > 150 or color2[1] > 150
    local hasGreen = g1 or g2 or color1[2] > 150 or color2[2] > 150
    local hasBlue = b1 or b2 or color1[3] > 150 or color2[3] > 150
    
    -- Check if color1 is a mix of two primaries (like yellow = red+green, cyan = green+blue, magenta = red+blue)
    -- Use more lenient thresholds to catch mixed colors
    local c1IsYellow = color1[1] > 80 and color1[2] > 80 and color1[3] < 100
    local c1IsCyan = color1[1] < 100 and color1[2] > 80 and color1[3] > 80
    local c1IsMagenta = color1[1] > 80 and color1[2] < 100 and color1[3] > 80
    
    -- Check if color2 is a mix of two primaries
    local c2IsYellow = color2[1] > 80 and color2[2] > 80 and color2[3] < 100
    local c2IsCyan = color2[1] < 100 and color2[2] > 80 and color2[3] > 80
    local c2IsMagenta = color2[1] > 80 and color2[2] < 100 and color2[3] > 80
    
    -- Check if color2 is a primary (for when color1 is a secondary)
    local c2IsRed = color2[1] > 150 and color2[2] < 100 and color2[3] < 100
    local c2IsGreen = color2[2] > 150 and color2[1] < 100 and color2[3] < 100
    local c2IsBlue = color2[3] > 150 and color2[1] < 100 and color2[2] < 100
    
    -- Check if color1 is a primary (for when color2 is a secondary)
    local c1IsRed = color1[1] > 150 and color1[2] < 100 and color1[3] < 100
    local c1IsGreen = color1[2] > 150 and color1[1] < 100 and color1[3] < 100
    local c1IsBlue = color1[3] > 150 and color1[1] < 100 and color1[2] < 100
    
    -- If one is yellow (red+green) and the other is blue
    if (c1IsYellow and c2IsBlue) or (c2IsYellow and c1IsBlue) then
        return true
    end
    -- If one is cyan (green+blue) and the other is red
    if (c1IsCyan and c2IsRed) or (c2IsCyan and c1IsRed) then
        return true
    end
    -- If one is magenta (red+blue) and the other is green
    if (c1IsMagenta and c2IsGreen) or (c2IsMagenta and c1IsGreen) then
        return true
    end
    
    -- Check if we have all three primaries directly
    if hasRed and hasGreen and hasBlue then
        return true
    end
    
    return false
end

-- Mix two colors in HSL space to preserve vibrancy, or use additive RGB if mixing primaries
function MixColors(color1, color2, weight1, weight2)
    -- First, calculate what the additive RGB mix would be
    local additiveR = math.min(255, math.floor(color1[1] * weight1 + color2[1] * weight2))
    local additiveG = math.min(255, math.floor(color1[2] * weight1 + color2[2] * weight2))
    local additiveB = math.min(255, math.floor(color1[3] * weight1 + color2[3] * weight2))
    
    -- Check if mixing would produce white using the detection function
    -- This detects when all three primaries (red, green, blue) are present
    if WouldProduceWhite(color1, color2) then
        -- All three primaries are present = pure white (255, 255, 255)
        -- Don't calculate based on weights - just return pure white
        return {255, 255, 255}
    end
    
    -- Also check if the additive mix would produce white (all three components are high)
    -- This is a fallback check in case WouldProduceWhite doesn't catch it
    local wouldBeWhite = additiveR > 150 and additiveG > 150 and additiveB > 150
    if wouldBeWhite then
        -- All three components are high = bright white
        -- Ensure it's bright white, not grey
        local brightness = math.max(250, math.min(255, (additiveR + additiveG + additiveB) / 3))
        return {math.floor(brightness), math.floor(brightness), math.floor(brightness)}
    end
    
    -- Otherwise use HSL mixing for vibrant color blending
    local h1, s1, l1 = RGBToHSL(color1[1], color1[2], color1[3])
    local h2, s2, l2 = RGBToHSL(color2[1], color2[2], color2[3])
    
    -- Mix hue (handle circular nature of hue)
    local h = 0
    local dh = math.abs(h2 - h1)
    if dh > 180 then
        if h1 < h2 then
            h1 = h1 + 360
        else
            h2 = h2 + 360
        end
    end
    h = (h1 * weight1 + h2 * weight2) % 360
    
    -- Mix saturation and lightness - ensure we maintain vibrancy
    -- Use weighted average but ensure minimum saturation to prevent white
    local s = (s1 * weight1 + s2 * weight2)
    s = math.max(s, 0.3) -- Ensure minimum saturation of 30% to prevent white
    s = math.min(s, 1.0) -- Clamp to 1.0
    
    -- Mix lightness but keep it in a vibrant range (not too light, not too dark)
    local l = (l1 * weight1 + l2 * weight2)
    l = math.max(l, 0.2) -- Minimum lightness 20%
    l = math.min(l, 0.8) -- Maximum lightness 80% to keep colors vibrant
    
    local r, g, b = HSLToRGB(h, s, l)
    
    -- Final validation: ensure we didn't get white or near-white (unless we should have white)
    if r >= 250 and g >= 250 and b >= 250 then
        -- If result is too close to white, boost saturation and reduce lightness
        s = math.min(s * 1.5, 1.0)
        l = math.max(l * 0.7, 0.3)
        r, g, b = HSLToRGB(h, s, l)
    end
    
    return {r, g, b}
end

function CreateScriptedCamera()
    if CurrentCamera then ExitScriptedCamera() end
    local initialCamSettings = {
        coords = GetGameplayCamCoord(),
        rotation = GetGameplayCamRot(),
        fov = GetGameplayCamFov(),
    }
    CurrentCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 
        initialCamSettings.coords.x, initialCamSettings.coords.y, initialCamSettings.coords.z, 
        initialCamSettings.rotation.x, initialCamSettings.rotation.y, initialCamSettings.rotation.z, initialCamSettings.fov
    )
    SetCamActive(CurrentCamera, true)
    RenderScriptCams(true, false, 0, true, true)
end

function ExitScriptedCamera(durationValue)
    local duration = durationValue
    if duration == nil then duration = 2000 end
    ClearFocus()
	DestroyAllCams()
    RenderScriptCams(false, true, duration, true, false) 
end

function SpawnOrderNPC(orderData)
    if not orderData or not orderData.stationId or not orderData.spawnCoords or not orderData.walkCoords then
        print("ERROR: Invalid order data for NPC spawn")
        return
    end
    
    local stationId = orderData.stationId
    
    -- Initialize station NPC tracking if needed
    if not OrderNPCs[stationId] then
        OrderNPCs[stationId] = {}
    end
    
    local modelHash = GetHashKey(orderData.npcModel)
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end
    
    -- Spawn NPC at queue position (not spawn position)
    local npc = CreateNPC(modelHash, orderData.walkCoords.x, orderData.walkCoords.y, orderData.walkCoords.z, orderData.heading or 0.0, false, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityAsMissionEntity(npc, true, true)
    
    -- Freeze NPC in place
    FreezeEntityPosition(npc, true)
    
    -- Face the interaction (flip heading 180 degrees to face towards interaction)
    if orderData.heading then
        local facingHeading = (orderData.heading + 180.0) % 360.0
        SetEntityHeading(npc, facingHeading)
    end
    
    -- Store NPC data per station
    OrderNPCs[stationId][orderData.orderId] = {
        npc = npc,
        orderId = orderData.orderId,
        stationId = stationId,
        drinkName = orderData.drinkName,
        queueIndex = orderData.queueIndex or 0,
        isWalking = false, -- Track if NPC is currently walking to queue position
    }
    
    SetModelAsNoLongerNeeded(modelHash)
end

-- Get station coords and heading for any client (from LoadedStations or current interaction)
local function GetStationTransform(stationId)
    if CURRENT_INTERACTION and CURRENT_INTERACTION.stationId == stationId and CURRENT_INTERACTION.coords then
        return CURRENT_INTERACTION.coords, CURRENT_INTERACTION.heading or 0.0
    end
    local station = LoadedStations[stationId]
    if not station then return nil, nil end
    local coords = station.coords
    if type(coords) == "table" then
        coords = vector3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
    end
    return coords, (station.heading or 0.0)
end

function UpdateQueuePositions(stationId, heading, queueData)
    if not OrderNPCs[stationId] then return end
    local coords, stationHeading = GetStationTransform(stationId)
    if not coords then return end
    local useHeading = heading or stationHeading or 0.0

    local npcsToWalk = {} -- Track NPCs that need to walk

    -- Update queue indices from server data
    if queueData then
        for orderId, queueIndex in pairs(queueData) do
            if OrderNPCs[stationId][orderId] then
                local oldIndex = OrderNPCs[stationId][orderId].queueIndex or 0
                OrderNPCs[stationId][orderId].queueIndex = queueIndex

                -- If queue index changed and NPC exists, mark for walking
                if oldIndex ~= queueIndex and DoesEntityExist(OrderNPCs[stationId][orderId].npc) then
                    table.insert(npcsToWalk, {orderId = orderId, queueIndex = queueIndex})
                end
            end
        end
    end

    -- Make NPCs walk to their new positions (all clients that have the NPCs)
    for i = 1, #npcsToWalk do
        local data = npcsToWalk[i]
        if OrderNPCs[stationId][data.orderId] then
            WalkNPCToQueuePosition(stationId, OrderNPCs[stationId][data.orderId].npc, data.orderId, data.queueIndex, coords, useHeading)
        end
    end

    -- Recalculate and correct positions for all NPCs that haven't moved (queue index unchanged and not walking)
    if queueData then
        local forwardVector = CalculateForwardVector(useHeading)
        local rightVector = vector3(math.cos(math.rad(useHeading + 90)), math.sin(math.rad(useHeading + 90)), 0.0)

        for orderId, queueIndex in pairs(queueData) do
            local npcData = OrderNPCs[stationId][orderId]
            if npcData and DoesEntityExist(npcData.npc) then
                if not npcData.isWalking then
                    local basePos = coords + (forwardVector * -1.5) + vector3(0.0, 0.0, -1.0)
                    if queueIndex > 0 then
                        basePos = basePos + (rightVector * (Config.Bartender.orderQueueSpacing * queueIndex))
                    end

                    SetEntityCoords(npcData.npc, basePos.x, basePos.y, basePos.z)
                    SetEntityHeading(npcData.npc, (useHeading + 180.0) % 360.0)
                    FreezeEntityPosition(npcData.npc, true)
                end
            end
        end
    end
end

function WalkNPCToQueuePosition(stationId, npc, orderId, queueIndex, coords, heading)
    if not coords or not DoesEntityExist(npc) or not OrderNPCs[stationId] or not OrderNPCs[stationId][orderId] then return end
    local useHeading = heading or 0.0

    FreezeEntityPosition(npc, false)
    OrderNPCs[stationId][orderId].isWalking = true

    local forwardVector = CalculateForwardVector(useHeading)
    local rightVector = vector3(math.cos(math.rad(useHeading + 90)), math.sin(math.rad(useHeading + 90)), 0.0)
    local basePos = coords + (forwardVector * -1.5)
    if queueIndex > 0 then
        basePos = basePos + (rightVector * (Config.Bartender.orderQueueSpacing * queueIndex))
    end

    TaskGoStraightToCoord(npc, basePos.x, basePos.y, basePos.z, 1.0, -1, 0.0, 0.0)

    CreateThread(function()
        while DoesEntityExist(npc) and OrderNPCs[stationId] and OrderNPCs[stationId][orderId] and OrderNPCs[stationId][orderId].isWalking do
            Wait(500)
            local npcCoords = GetEntityCoords(npc)
            local distance = #(npcCoords - basePos)
            if distance < 0.25 then
                ClearPedTasks(npc)
                SetEntityCoords(npc, basePos.x, basePos.y, basePos.z - 1.0)
                SetEntityHeading(npc, (useHeading + 180.0) % 360.0)
                FreezeEntityPosition(npc, true)
                OrderNPCs[stationId][orderId].isWalking = false
                break
            end
        end
    end)
end

function DeleteOrderNPC(stationId, orderId)
    if not OrderNPCs[stationId] or not OrderNPCs[stationId][orderId] then return end
    
    local npc = OrderNPCs[stationId][orderId].npc
    if DoesEntityExist(npc) then
        local coords, heading = GetStationTransform(stationId)
        if coords and heading then
            MakeNPCWalkAway(npc, coords, heading)
            SetTimeout(2000, function()
                if DoesEntityExist(npc) then
                    DeleteEntity(npc)
                end
            end)
        else
            DeleteEntity(npc)
        end
    end

    OrderNPCs[stationId][orderId] = nil
end

function DeleteAllOrderNPCs(stationId)
    if not stationId then
        -- Delete all NPCs for all stations
        for sid, stationNPCs in pairs(OrderNPCs) do
            DeleteAllOrderNPCs(sid)
        end
        return
    end
    
    if not OrderNPCs[stationId] then return end
    
    -- Store NPCs to delete (in case OrderNPCs gets cleared)
    local npcsToDelete = {}
    for orderId, npcData in pairs(OrderNPCs[stationId]) do
        if DoesEntityExist(npcData.npc) then
            table.insert(npcsToDelete, npcData.npc)
        end
    end
    
    -- Clear the OrderNPCs table for this station
    OrderNPCs[stationId] = nil
    CurrentOrders[stationId] = nil
    BartenderServiceActive[stationId] = false

    local coords, heading = GetStationTransform(stationId)
    if not coords or not heading then
        for i = 1, #npcsToDelete do
            if DoesEntityExist(npcsToDelete[i]) then
                DeleteEntity(npcsToDelete[i])
            end
        end
        return
    end

    for i = 1, #npcsToDelete do
        local npc = npcsToDelete[i]
        if DoesEntityExist(npc) then
            MakeNPCWalkAway(npc, coords, heading)
        end
    end

    SetTimeout(3000, function()
        for i = 1, #npcsToDelete do
            if DoesEntityExist(npcsToDelete[i]) then
                DeleteEntity(npcsToDelete[i])
            end
        end
    end)
end

function CalculateForwardVector(heading)
    local headingRad = math.rad(heading)
    local forwardX = math.sin(headingRad)
    local forwardY = -math.cos(headingRad)
    local forwardZ = 0.0
    return vector3(forwardX, forwardY, forwardZ)
end

function CalculateRightVector(heading)
    local headingRad = math.rad(heading)
    local rightX = math.cos(headingRad)
    local rightY = math.sin(headingRad)
    local rightZ = 0.0
    return vector3(rightX, rightY, rightZ)
end

-- Make NPC walk away: walk to the right, then delete
function MakeNPCWalkAway(npc, stationCoords, heading)
    if not DoesEntityExist(npc) then return end
    
    -- Unfreeze before walking away
    FreezeEntityPosition(npc, false)
    -- Stop any current tasks
    ClearPedTasks(npc)
    
    local rightVector = CalculateRightVector(heading)
    
    -- Walk to the right (2-3 steps to clear the queue area)
    local rightCoords = GetEntityCoords(npc) + (rightVector * 2.5)
    
    -- Walk to the right
    TaskGoStraightToCoord(npc, rightCoords.x, rightCoords.y, rightCoords.z, 1.0, 3000, 0.0, 0.0)
end

-- Events
RegisterNetEvent("pickle_clubs:spawnOrderNPC", function(orderData)
    SpawnOrderNPC(orderData)
end)

RegisterNetEvent("pickle_clubs:updateQueuePositions", function(stationId, heading, queueData)
    UpdateQueuePositions(stationId, heading, queueData)
end)

RegisterNetEvent("pickle_clubs:updateOrder", function(orderData)
    if orderData.stationId then
        CurrentOrders[orderData.stationId] = orderData
        -- Send to NUI only if this is the current station
        if CURRENT_INTERACTION and CURRENT_INTERACTION.stationId == orderData.stationId then
            -- Resolve flavor keys to labels/colors for the NUI
            local flavorDetails = {}
            if orderData.flavors then
                for _, key in ipairs(orderData.flavors) do
                    local f = Config.Bartender.flavors[key]
                    flavorDetails[#flavorDetails + 1] = {
                        key   = key,
                        label = f and f.label or key,
                        color = f and f.color or {128, 128, 128},
                    }
                end
            end
            SendNUIMessage({
                type = "updateOrderDisplay",
                data = {
                    stationId       = orderData.stationId,
                    orderId         = orderData.orderId,
                    orderName       = orderData.orderName,
                    flavors         = orderData.flavors,
                    flavorDetails   = flavorDetails,
                    alcoholPct      = orderData.alcoholPct,
                    timeRemaining   = orderData.timeRemaining,
                    active          = orderData.active,
                    isPlayerOrder   = orderData.isPlayerOrder,
                    orderPlayerName = orderData.orderPlayerName,
                }
            })
        end
    end
end)

RegisterNetEvent("pickle_clubs:deleteOrderNPC", function(stationId, orderId)
    DeleteOrderNPC(stationId, orderId)
end)

RegisterNetEvent("pickle_clubs:cleanupAllOrders", function(stationId)
    DeleteAllOrderNPCs(stationId)
    if stationId then
        BartenderServiceActive[stationId] = false
    else
        BartenderServiceActive = {}
    end
    SubmittedDrinks = {}
end)

function CheckDrinkOnCoaster(drinkEntity)
    if not INT_ENTITIES[drinkEntity] then return end
    if SubmittedDrinks[drinkEntity] then return end -- Already submitted
    
    local drinkData = INT_ENTITIES[drinkEntity]
    if not drinkData or drinkData.progress < 1.0 then return end -- Drink must be full
    
    local drinkCoords = GetEntityCoords(drinkEntity)
    local closestCoaster = nil
    local closestDistance = 999.0
    
    -- Find closest coaster
    for entity, data in pairs(INT_ENTITIES) do
        if data and data.type == "coaster" then
            local coasterCoords = GetEntityCoords(entity)
            local distance = #(drinkCoords - coasterCoords)
            if distance < closestDistance and distance < 0.045 then -- Within 0.2 units
                closestDistance = distance
                closestCoaster = entity
            end
        end
    end
    
    if closestCoaster and CURRENT_INTERACTION and CURRENT_INTERACTION.stationId then
        local stationId = CURRENT_INTERACTION.stationId
        
        -- Find the current order (first in queue - queueIndex 0) for this station
        -- NPC orders: get from OrderNPCs; Player orders: get from CurrentOrders (no NPC)
        local currentOrderId = nil
        if OrderNPCs[stationId] then
            for orderId, npcData in pairs(OrderNPCs[stationId]) do
                if npcData and npcData.queueIndex == 0 then
                    currentOrderId = orderId
                    break
                end
            end
        end
        if not currentOrderId and CurrentOrders[stationId] and CurrentOrders[stationId].orderId then
            currentOrderId = CurrentOrders[stationId].orderId
        end
        
        if currentOrderId then
            -- Check if drink is near the current order NPC (NPC orders) or on coaster (player orders)
            local npcData = OrderNPCs[stationId] and OrderNPCs[stationId][currentOrderId]
            local isPlayerOrder = CurrentOrders[stationId] and CurrentOrders[stationId].isPlayerOrder
            local shouldSubmit = false
            if npcData and DoesEntityExist(npcData.npc) then
                local npcCoords = GetEntityCoords(npcData.npc)
                local distance = #(drinkCoords - npcCoords)
                if distance < 2.0 then
                    shouldSubmit = true
                end
            elseif isPlayerOrder then
                -- Player order: drink on coaster is enough (no NPC to check distance to)
                shouldSubmit = true
            end
            if shouldSubmit and drinkData.flavorWeights then
                SubmittedDrinks[drinkEntity] = true
                TriggerServerEvent("pickle_clubs:submitDrink", stationId, currentOrderId, drinkData.flavorWeights)
                INT_ENTITIES[drinkEntity].progress = 0.0
                INT_ENTITIES[drinkEntity].flavorWeights = {}
                SetTimeout(1000, function()
                    SubmittedDrinks[drinkEntity] = nil
                end)
            end
        else
            -- No active order - match drink against menu and give the corresponding item
            if drinkData.flavorWeights and not SubmittedDrinks[drinkEntity] then
                SubmittedDrinks[drinkEntity] = true
                TriggerServerEvent("pickle_clubs:giveDrinkItem", stationId, drinkData.flavorWeights)
                INT_ENTITIES[drinkEntity].progress = 0.0
                INT_ENTITIES[drinkEntity].flavorWeights = {}
                SetTimeout(1000, function()
                    SubmittedDrinks[drinkEntity] = nil
                end)
            end
        end
    end
end

RegisterNetEvent("pickle_clubs:drinkSubmissionResult", function(success, feedback, payment)
    if success then
        ShowNotification("" .. feedback)
        if payment then
            ShowNotification("You received $" .. payment)
        end
    else
        ShowNotification("" .. feedback)
    end
end)

DrinkOrderOpen = false

function OpenPlayerOrderDrinkSelector(stationId)
    if DrinkOrderOpen then
        CloseDrinkOrder()
        return
    end
    lib.callback("pickle_clubs:getClubDrinkMenu", false, function(drinkList)
        if not drinkList or #drinkList == 0 then
            ShowNotification("No drinks available")
            return
        end
        local alcoholLabel = Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.label or "Alcohol"
        local drinks = {}
        for _, opt in ipairs(drinkList) do
            local flavorDetails = {}
            for _, fk in ipairs(opt.flavors or {}) do
                local f = Config.Bartender.flavors[fk]
                if f then
                    flavorDetails[#flavorDetails + 1] = {
                        key = fk,
                        label = f.label,
                        color = f.color,
                    }
                end
            end
            drinks[#drinks + 1] = {
                drinkKey = opt.drinkKey,
                name = opt.name,
                price = opt.price or 0,
                flavors = flavorDetails,
                alcoholPct = opt.alcoholPct or 0,
                alcoholLabel = alcoholLabel,
            }
        end
        table.sort(drinks, function(a, b) return a.name < b.name end)
        DrinkOrderOpen = true
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
        SendNUIMessage({
            type = "openDrinkOrder",
            data = {
                stationId = stationId,
                drinks = drinks,
                currency = Config.Currency and Config.Currency.currency or "USD",
                countryCode = Config.Currency and Config.Currency.countryCode or "en-US",
            },
        })
    end, stationId)
end

function CloseDrinkOrder()
    DrinkOrderOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "closeDrinkOrder" })
end

RegisterNUICallback("closeDrinkOrder", function(_, cb)
    CloseDrinkOrder()
    cb("ok")
end)

RegisterNUICallback("orderDrink", function(data, cb)
    if data and data.stationId and data.drinkKey then
        TriggerServerEvent("pickle_clubs:placePlayerOrder", data.stationId, data.drinkKey)
    end
    cb("ok")
end)

function OpenBartenderRegister()
    if not CURRENT_INTERACTION or not CURRENT_INTERACTION.stationId then
        ShowNotification("ERROR: No active station interaction")
        return
    end
    
    local stationId = CURRENT_INTERACTION.stationId
    local options = {}
    
    if not BartenderServiceActive[stationId] then
        table.insert(options, {
            title = _L("bartender_start_service"),
            description = "Start accepting NPC orders",
            onSelect = function()
                if not CURRENT_INTERACTION or not CURRENT_INTERACTION.stationId then
                    ShowNotification("ERROR: No active interaction")
                    return
                end
                -- Trigger server event with stationId
                TriggerServerEvent("pickle_clubs:startBartenderService", stationId, CURRENT_INTERACTION.coords, CURRENT_INTERACTION.heading)
                BartenderServiceActive[stationId] = true
                ShowNotification("Bartender service started")
            end
        })
    else
        table.insert(options, {
            title = _L("bartender_stop_service"),
            description = "Stop accepting NPC orders",
            onSelect = function()
                TriggerServerEvent("pickle_clubs:stopBartenderService", stationId)
                BartenderServiceActive[stationId] = false
                ShowNotification("Bartender service stopped")
            end
        })
    end
    
    lib.registerContext({
        id = "bartender_register",
        title = _L("bartender_cash_register"),
        options = options
    })
    lib.showContext("bartender_register")
end

RecipeBookOpen = false

function OpenRecipeBook()
    if RecipeBookOpen then
        CloseRecipeBook()
        return
    end
    if not CurrentStationMenu or #CurrentStationMenu == 0 then
        ShowNotification("No drinks on the menu")
        return
    end
    -- Build recipe list with flavor details
    local recipes = {}
    local alcoholLabel = Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.label or "Alcohol"
    for _, drink in ipairs(CurrentStationMenu) do
        local flavorDetails = {}
        for _, fk in ipairs(drink.flavors or {}) do
            local f = Config.Bartender.flavors[fk]
            if f then
                flavorDetails[#flavorDetails + 1] = {
                    key = fk,
                    label = f.label,
                    color = f.color,
                }
            end
        end
        recipes[#recipes + 1] = {
            name = drink.name,
            flavors = flavorDetails,
            alcoholPct = drink.alcoholPct or 0,
            alcoholLabel = alcoholLabel,
        }
    end
    table.sort(recipes, function(a, b) return a.name < b.name end)
    RecipeBookOpen = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        type = "openRecipeBook",
        recipes = recipes,
    })
end

function CloseRecipeBook()
    RecipeBookOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "closeRecipeBook" })
end

RegisterNUICallback("closeRecipeBook", function(_, cb)
    CloseRecipeBook()
    cb("ok")
end)

-- Store interaction indices for stations
StationInteractions = {} -- stationId -> interactionIndex

local function CreateStationRegisterProp(coords, heading)
    local model = Config.Bartender.registerModel or `vw_prop_casino_till`
    local prop = CreateProp(model, coords.x, coords.y, coords.z, false, false, false)
    if not prop or not DoesEntityExist(prop) then return nil end
    SetEntityCollision(prop, true, true)
    SetEntityHeading(prop, heading)
    return prop
end

-- Load station and create interaction
function LoadStation(station)
    if not station then return end
    
    -- Ensure coords is vector3 (may come as table from network sync)
    if station.coords and type(station.coords) == "table" then
        station.coords = vector3(station.coords.x or station.coords[1], station.coords.y or station.coords[2], station.coords.z or station.coords[3])
    end
    
    LoadedStations[station.id] = station
    
    -- Cleanup existing interaction and register prop if they exist
    if StationInteractions[station.id] then
        DeleteInteraction(StationInteractions[station.id])
        StationInteractions[station.id] = nil
    end
    if StationRegisterProps[station.id] and DoesEntityExist(StationRegisterProps[station.id]) then
        DeleteEntity(StationRegisterProps[station.id])
        StationRegisterProps[station.id] = nil
    end

    -- Ensure coords is still vector3
    local coords = station.coords

    local interactionIndex = CreateInteraction({
        label = "Bartending Station",
        icon = Config.TargetIcons.bartender,
        coords = coords,
        heading = station.heading or 0.0,
        radius = 1.0,
        interactRadius = Config.InteractDistance,
    }, function()
        local stationId = station.id
        -- Check if player has bartending job access for this station's club
        local clubIdStr = stationId:match("^(%d+):")
        local clubId = clubIdStr and tonumber(clubIdStr)
        local canBartend = false
        if clubId then
            local club = Clubs[clubId]
            if club and club.jobs then
                local jobAccess = {}
                for _, j in ipairs(club.jobs) do
                    if j.name and j.name ~= "" then
                        jobAccess[j.name] = 0
                    end
                end
                if next(jobAccess) then
                    canBartend = CanAccessGroup(jobAccess)
                else
                    canBartend = true -- No jobs configured = anyone can bartend
                end
            else
                canBartend = true
            end
        end

        local managementClubId
        do
            local cIdStr = stationId:match("^(%d+):")
            if cIdStr then managementClubId = tonumber(cIdStr) end
        end
        lib.callback("pickle_clubs:canManageClub", false, function(canManage)
            local options = {}

            if canManage then
                table.insert(options, {
                    title = "Manage",
                    description = "Open this station's management menu",
                    onSelect = function()
                        local cIdStr, entityId = stationId:match("^(%d+):(.+)$")
                        if cIdStr and entityId then
                            OpenClubManagementNuiForEntity(tonumber(cIdStr), entityId)
                        else
                            OpenClubManagementNui()
                        end
                    end,
                })
            end

            table.insert(options, {
                title = "Place Order",
                description = "Order a drink from the bar",
                onSelect = function()
                    lib.callback("pickle_clubs:canPlacePlayerOrder", false, function(canPlace, reason)
                        if not canPlace then
                            ShowNotification(reason or "Cannot place order")
                            return
                        end
                        OpenPlayerOrderDrinkSelector(stationId)
                    end, stationId)
                end,
            })

            if canBartend then
                table.insert(options, {
                    title = "Start Bartending",
                    description = "Begin bartending at this station",
                    onSelect = function()
                        StartStationInteraction({stationId = stationId})
                    end,
                })
            end

            lib.registerContext({
                id = "station_interact_" .. stationId,
                title = "Bartending Station",
                options = options,
            })
            lib.showContext("station_interact_" .. stationId)
        end, managementClubId)
    end)

    StationInteractions[station.id] = interactionIndex

    -- Render register model for all clients so the station location is visible
    local heading = station.heading or 0.0
    local registerProp = CreateStationRegisterProp(coords, heading)
    if registerProp then
        StationRegisterProps[station.id] = registerProp
    end
end

function StartStationInteraction(data)
    local stationId = data and data.stationId or data
    if not stationId or not LoadedStations[stationId] then
        ShowNotification("Station not found")
        return
    end

    local station = LoadedStations[stationId]

    -- Request control from server; only proceed if granted (so "in use" actually blocks entry)
    lib.callback("pickle_clubs:requestStationControl", false, function(granted, message)
        if not granted then
            ShowNotification(message or "Station is already in use")
            return
        end
        -- Hide persistent register prop while bartending (interactive register will be shown)
        if StationRegisterProps[stationId] and DoesEntityExist(StationRegisterProps[stationId]) then
            DeleteEntity(StationRegisterProps[stationId])
            StationRegisterProps[stationId] = nil
        end
        -- Fetch drink menu for matching drink names
        lib.callback("pickle_clubs:getClubDrinkMenu", false, function(drinkMenu)
            CurrentStationMenu = drinkMenu or {}
            CreateStationInteraction(station)
        end, stationId)
    end, stationId, "interaction")
end

-- Start interaction for a station
RegisterNetEvent("pickle_clubs:startStationInteraction", function(data)
    StartStationInteraction(data)
end)


-- Create interaction entities for a station
function CreateStationInteraction(station)
    if CURRENT_INTERACTION then
        ShowNotification("ERROR: Interaction already started")
        return
    end
    local temp = CreateTennisBall(station.coords.x, station.coords.y, station.coords.z)
    SetEntityRotation(temp, 0.0, 0.0, station.heading, 2, true)
    local forwardVector, rightVector, upVector, position = GetEntityMatrix(temp)
    DeleteEntity(temp)
    -- Ensure coords is vector3
    local coords = station.coords + (rightVector * 0.5) 
    if type(coords) == "table" then
        coords = vector3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
    end
    
    local heading = station.heading
    local interaction = StartInteraction(coords, heading)
    
    -- Add stationId to interaction
    if interaction then
        interaction.stationId = station.id
        CURRENT_INTERACTION.stationId = station.id
    end
    
    -- Create coaster
    CreateInteractiveEntity("coaster", coords + (interaction.rightVector * -0.2), heading, {})
    
    -- Create drink
    CreateInteractiveEntity("drink", coords + (interaction.rightVector * -0.05), heading, {
        progress = 0.0,
        flavorWeights = {},
        display = {
            title = _L("bartender_drink"),
            itemSize = 0.65,
            secondaryTitle = "0%",
            rows = {
                {type = "text", label = _L("bartender_empty")}
            }
        },
    })
    
    -- Create register
    CreateInteractiveEntity("register", coords + (interaction.rightVector * -0.5), heading, {
        display = {
            title = _L("bartender_cash_register"),
            hiddenHover = true,
            hoverRadius = 0.04,
            rows = {
                {type = "text", label = _L("bartender_start_stop_orders"), color = "secondary"}
            }
        },
    })

    -- Create recipe book
    CreateInteractiveEntity("recipe_book", coords + (interaction.rightVector * 0.45), heading, {
        display = {
            title = _L("bartender_recipe_book"),
            hiddenHover = true,
            hoverRadius = 0.04,
            maxScale = 0.5,
            rows = {
                {type = "text", label = _L("bartender_recipe_book_hint"), color = "secondary"}
            }
        },
    })

    -- Build flavor key list sorted alphabetically by label
    local flavorKeys = {}
    for key, _ in pairs(Config.Bartender.flavors) do
        flavorKeys[#flavorKeys + 1] = key
    end
    table.sort(flavorKeys, function(a, b)
        local labelA = Config.Bartender.flavors[a].label or a
        local labelB = Config.Bartender.flavors[b].label or b
        return labelA < labelB
    end)

    -- Create single flavor bottle (scroll to cycle flavors)
    local firstKey = flavorKeys[1]
    local firstFlavor = firstKey and Config.Bartender.flavors[firstKey]
    if firstFlavor then
        CreateInteractiveEntity("bottle", coords + (interaction.rightVector * 0.25), heading, {
            color = firstFlavor.color,
            flavorKey = firstKey,
            flavorIndex = 1,
            flavorKeys = flavorKeys,
            progress = 1.0,
            display = {
                title = firstFlavor.label,
                secondaryTitle = "",
                maxScale = 0.65,
                rows = {
                    {type = "text", label = _L("bartender_scroll_flavor")}
                }
            },
        })
    end

    -- Create alcohol bottle
    if Config.Bartender.alcoholBottle then
        CreateInteractiveEntity("bottle", coords + (interaction.rightVector * 0.1), heading, {
            color = Config.Bartender.alcoholBottle.color,
            flavorKey = Config.Bartender.alcoholBottle.key,
            progress = 1.0,
            display = {
                title = Config.Bartender.alcoholBottle.label,
                maxScale = 0.65,
                rows = {
                    {type = "text", label = _L("bartender_alcohol_subtitle"), color = "secondary"}
                }
            },
        })
    end
end

-- Handle station control denial
RegisterNetEvent("pickle_clubs:stationControlDenied", function(message)
    ShowNotification("" .. (message or "Station is already in use"))
end)

-- Load stations when synced
RegisterNetEvent("pickle_clubs:syncStations", function(stations, appendOnly)
    if not appendOnly then
        for stationId, interactionIndex in pairs(StationInteractions) do
            if not stations[stationId] then
                DeleteInteraction(interactionIndex)
                StationInteractions[stationId] = nil
                LoadedStations[stationId] = nil
                if StationRegisterProps[stationId] and DoesEntityExist(StationRegisterProps[stationId]) then
                    DeleteEntity(StationRegisterProps[stationId])
                    StationRegisterProps[stationId] = nil
                end
            end
        end
    end

    for stationId, station in pairs(stations or {}) do
        -- Ensure coords is vector3 (may come as table from network sync)
        if station.coords and type(station.coords) == "table" then
            station.coords = vector3(station.coords.x or station.coords[1], station.coords.y or station.coords[2], station.coords.z or station.coords[3])
        end

        if StationInteractions[stationId] then
            DeleteInteraction(StationInteractions[stationId])
            StationInteractions[stationId] = nil
        end
        LoadStation(station)
    end

    TriggerServerEvent("pickle_clubs:requestStationControllerStates")
end)

-- Handle station removal
RegisterNetEvent("pickle_clubs:removeStation", function(stationId)
    LoadedStations[stationId] = nil

    if StationRegisterProps[stationId] and DoesEntityExist(StationRegisterProps[stationId]) then
        DeleteEntity(StationRegisterProps[stationId])
        StationRegisterProps[stationId] = nil
    end

    -- Delete interaction if it exists
    if StationInteractions[stationId] then
        DeleteInteraction(StationInteractions[stationId])
        StationInteractions[stationId] = nil
    end

    -- If currently interacting with this station, stop interaction
    if CURRENT_INTERACTION and CURRENT_INTERACTION.stationId == stationId then
        StopInteraction()
        TriggerServerEvent("pickle_clubs:clearStationController", stationId, "interaction")
    end
end)

CreateThread(function()
    RegisterEntityType("bartender", {
        label = "Bartender",
        description = "Bartending station entity type.",
        onRender = function(id, entityId)
            local club = Clubs[id]
            if not club then return end
            local entity = club.entities and club.entities[entityId]
            if not entity or entity.type ~= "bartender" or not entity.bartender then return end
            local coords = entity.bartender.coords
            if type(coords) == "table" then
                coords = vector3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
            end
            local primaryJobName = nil
            for _, j in ipairs(club.jobs or {}) do
                if j.primary and type(j.name) == "string" and j.name ~= "" then
                    primaryJobName = j.name
                    break
                end
            end
            LoadStation({
                id = ("%s:%s"):format(id, entityId),
                coords = coords,
                heading = entity.bartender.heading or 0.0,
                clubId = id,
                entityId = entityId,
                society_name = primaryJobName,
            })
        end,
        onUnrender = function(id, entityId)
            local stationId = ("%s:%s"):format(id, entityId)
            LoadedStations[stationId] = nil
            if StationInteractions[stationId] then
                DeleteInteraction(StationInteractions[stationId])
                StationInteractions[stationId] = nil
            end
        end
    })
end)

-- Hook into StopInteraction to cleanup all bartender-related state
-- Note: Register visibility is handled by server event (pickle_clubs:showStationRegister)
AddEventHandler("pickle_clubs:stopInteraction", function()
    -- Close recipe book if open
    if RecipeBookOpen then
        CloseRecipeBook()
    end

    if CURRENT_INTERACTION and CURRENT_INTERACTION.stationId then
        local stationId = CURRENT_INTERACTION.stationId

        -- Stop bartender service if active (this will cleanup NPCs server-side)
        if BartenderServiceActive[stationId] then
            TriggerServerEvent("pickle_clubs:stopBartenderService", stationId)
            BartenderServiceActive[stationId] = false
        end
        
        -- Clear order display in NUI first (before cleanup)
        SendNUIMessage({
            type = "updateOrderDisplay",
            data = {
                stationId = stationId,
                active = false,
            }
        })
        
        -- Cleanup client-side NPCs and orders for this station
        -- Note: DeleteAllOrderNPCs will handle NPC deletion, but we need to call it
        -- before CURRENT_INTERACTION is cleared, so NPCs can walk away properly
        if OrderNPCs[stationId] then
            -- Store station data before cleanup
            local stationCoords = CURRENT_INTERACTION.coords
            local stationHeading = CURRENT_INTERACTION.heading
            
            -- Cleanup NPCs (they'll walk away since CURRENT_INTERACTION still exists)
            DeleteAllOrderNPCs(stationId)
        end
        
        -- Clear client-side state
        CurrentOrders[stationId] = nil
        
        -- Clear submitted drinks (they're keyed by entity, which will be deleted)
        -- But clear the table to be safe
        SubmittedDrinks = {}
        
        -- Clear station controller
        TriggerServerEvent("pickle_clubs:clearStationController", stationId, "interaction")

        -- Recreate persistent register prop for all clients to see
        local station = LoadedStations[stationId]
        if station and station.coords and not StationRegisterProps[stationId] then
            local coords = station.coords
            if type(coords) == "table" then
                coords = vector3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
            end
            local heading = station.heading or 0.0
            local prop = CreateStationRegisterProp(coords, heading)
            if prop then
                StationRegisterProps[stationId] = prop
            end
        end
    end
end)

-- Cleanup station interactions when stations are removed
-- Note: Interaction entity cleanup for render distance is handled by core/client.lua automatically
CreateThread(function()
    while true do
        Wait(5000) -- Check every 5 seconds
        
        -- Cleanup interactions and register props for stations that no longer exist
        for stationId, interactionIndex in pairs(StationInteractions) do
            if not LoadedStations[stationId] then
                DeleteInteraction(interactionIndex)
                StationInteractions[stationId] = nil
                if StationRegisterProps[stationId] and DoesEntityExist(StationRegisterProps[stationId]) then
                    DeleteEntity(StationRegisterProps[stationId])
                    StationRegisterProps[stationId] = nil
                end
            end
        end
    end
end)

-- Cleanup all stations, interactions, and NPCs on resource stop
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        -- Cleanup all station interactions
        for stationId, interactionIndex in pairs(StationInteractions) do
            DeleteInteraction(interactionIndex)
        end
        StationInteractions = {}

        -- Cleanup persistent register props
        for sid, prop in pairs(StationRegisterProps) do
            if prop and DoesEntityExist(prop) then
                DeleteEntity(prop)
            end
        end
        StationRegisterProps = {}

        -- Cleanup all NPCs
        for stationId, stationNPCs in pairs(OrderNPCs) do
            if stationNPCs then
                for orderId, npcData in pairs(stationNPCs) do
                    if npcData and DoesEntityExist(npcData.npc) then
                        DeleteEntity(npcData.npc)
                    end
                end
            end
        end
        OrderNPCs = {}
        
        -- Clear all station data
        LoadedStations = {}
        CurrentOrders = {}
        BartenderServiceActive = {}
        SubmittedDrinks = {}
        
        -- Clear station controller if currently interacting
        if CURRENT_INTERACTION and CURRENT_INTERACTION.stationId then
            TriggerServerEvent("pickle_clubs:clearStationController", CURRENT_INTERACTION.stationId, "interaction")
        end
    end
end)

CreateThread(function()
    Wait(1000)
    RegisterInteractiveEntity("bottle", {
        init = function(coords, heading, data, params)
            local bottle = CreateProp(`ng_proc_brkbottle_02a`, coords.x, coords.y, coords.z + 0.3, false, false, false)
            SetEntityCollision(bottle, true, true)
            SetEntityHeading(bottle, heading)
            return bottle, {
                color = params.color,
                flavorKey = params.flavorKey,
                flavorKeys = params.flavorKeys,
                flavorIndex = params.flavorIndex,
                progress = params.progress,
                heightOffset = 0.25,
            }
        end,
        entityThread = function(entity, data)
            local currentEntity = INT_ENTITIES[entity]
            local radius = 0.08
            local maxHeight = 0.1575
            local surfaceHeight = 0.01
            local alpha = 128
            local height = currentEntity.progress * maxHeight
            local rotation = GetEntityRotation(entity)
            local rx, ry, rz = rotation.x, rotation.y, rotation.z
            local forwardVector, rightVector, upVector, position = GetEntityMatrix(entity)
            local renderCoords = position + (upVector * surfaceHeight)
            local surfaceCoords = renderCoords + (upVector * height)
            local color = currentEntity.color
            if color and currentEntity.progress > 0.0 then
                DrawMarker(1, renderCoords.x, renderCoords.y, renderCoords.z, upVector.x, upVector.y, upVector.z, 90.0, -ry, rz, radius, radius, height, color[1], color[2], color[3], alpha, false, false, 2)
                DrawMarker(28, renderCoords.x, renderCoords.y, renderCoords.z, upVector.x, upVector.y, upVector.z, 270.0, -ry, rz, radius * 0.5, radius * 0.5, 0.001, color[1], color[2], color[3], alpha, false, false, 2)
                DrawMarker(1, surfaceCoords.x, surfaceCoords.y, surfaceCoords.z, upVector.x, upVector.y, upVector.z, 270.0, -ry, rz, radius, radius, height, color[1], color[2], color[3], alpha, false, false, 2)
                DrawMarker(28, surfaceCoords.x, surfaceCoords.y, surfaceCoords.z, upVector.x, upVector.y, upVector.z, 270.0, -ry, rz, radius * 0.5, radius * 0.5, 0.001, color[1], color[2], color[3], alpha, false, false, 2)
            end

            -- Scroll to cycle flavors (only when hovering over this bottle and not holding it)
            if currentEntity.flavorKeys and HOVERED_ENTITY == entity and not CURRENT_ENTITY and SCROLL_INPUT ~= 0 then
                local idx = currentEntity.flavorIndex or 1
                local keys = currentEntity.flavorKeys
                if SCROLL_INPUT == -1 then
                    idx = idx - 1
                    if idx < 1 then idx = #keys end
                else
                    idx = idx + 1
                    if idx > #keys then idx = 1 end
                end
                local newKey = keys[idx]
                local newFlavor = Config.Bartender.flavors[newKey]
                if newFlavor then
                    currentEntity.flavorIndex = idx
                    currentEntity.flavorKey = newKey
                    currentEntity.color = newFlavor.color
                    UpdateInteractiveEntityDisplay(entity, {
                        title = newFlavor.label,
                        secondaryTitle = "",
                        maxScale = 0.65,
                        rows = {
                            {type = "text", label = _L("bartender_scroll_flavor")}
                        }
                    })
                end
            end
        end,
        selectedThread = function(entity, data)
            local pitch = data.pitch
            local currentEntity = INT_ENTITIES[entity]
            local minimum, maximum = data.minimum, data.maximum
            if math.abs(pitch) > 90.0 and math.abs(pitch) < 270.0 then
                local closestChild = nil
                for k,v in pairs(INT_ENTITIES) do
                    if k ~= CURRENT_ENTITY then
                        local forwardVector, rightVector, upVector, position = GetEntityMatrix(CURRENT_ENTITY)
                        local currentCoords = GetEntityCoords(CURRENT_ENTITY) + (upVector * 0.25)
                        local childCoords = GetEntityCoords(k)
                        -- DrawMarker(28, currentCoords.x, currentCoords.y, currentCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.05, 0.05, 255, 0, 0, 255, false, false, 2)
                        local distance = #(vector3(currentCoords.x, currentCoords.y, 0.0) - vector3(childCoords.x, childCoords.y, 0.0))
                        if (not closestChild and distance < 0.05) or (closestChild and distance < closestChild.distance) then
                            if currentCoords.z > (childCoords.z + ((maximum.z - minimum.z))) then
                                closestChild = {
                                    entity = k,
                                    distance = distance,
                                }
                            end
                        end
                    end
                end
                local childEntity = closestChild and INT_ENTITIES[closestChild.entity] or nil
                if closestChild and (childEntity.type == "drink") and currentEntity.progress > 0.0 and childEntity.progress < 1.0 then
                    if not currentEntity.ptfx or currentEntity.refreshTime < GetGameTimer() then
                        currentEntity.refreshTime = GetGameTimer() + 2000
                        if currentEntity.ptfx then
                            local ptfxHandle = currentEntity.ptfx
                            SetTimeout(300, function()
                                StopParticleFxLooped(ptfxHandle, false)
                                RemoveParticleFx(ptfxHandle, true)
                            end)
                        end
                        RequestNamedPtfxAsset("cut_family1")
                        while not HasNamedPtfxAssetLoaded("cut_family1") do
                            Wait(0)
                        end
                        UseParticleFxAssetNextCall("cut_family1")
                        currentEntity.ptfx = StartParticleFxLoopedOnEntity("cs_fam1_bourbon_pour", CURRENT_ENTITY, 0.0, 0.0, 0.285, 0.0, 0.0, 0.0, 0.5, false, false, false)
                        SetParticleFxLoopedColour(currentEntity.ptfx, 255, 0, 0, 255)
                    end
                    -- -- Decrease bottle's progress when pouring (based on pitch)
                    -- if currentEntity.progress > 0.0 then
                    --     local pourRate = CalculatePourRate(pitch)
                    --     local basePourAmount = 0.015 -- Maximum pour amount
                    --     local pourAmount = basePourAmount * pourRate
                    --     currentEntity.progress = currentEntity.progress - pourAmount
                    --     if currentEntity.progress < 0.0 then
                    --         currentEntity.progress = 0.0
                    --     end
                    --     if currentEntity.ptfx then
                    --         local scale = 0.5 * pourRate
                    --         SetParticleFxLoopedScale(currentEntity.ptfx, scale)
                    --     end
                    -- end
                    -- INT_ENTITIES[CURRENT_ENTITY].progress = currentEntity.progress
                    if (childEntity.type == "drink") and childEntity.progress < 1.0 then
                        local oldProgress = childEntity.progress
                        -- Calculate pour rate based on pitch (how much the bottle is tilted)
                        local pourRate = CalculatePourRate(pitch)
                        local basePourAmount = 0.015 -- Maximum pour amount
                        -- Alcohol pours at quarter speed
                        local alcoholKey = Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.key or "_alcohol"
                        if currentEntity.flavorKey == alcoholKey then
                            basePourAmount = basePourAmount * 0.05
                        end
                        local pourAmount = basePourAmount * pourRate
                        childEntity.progress = math.min(childEntity.progress + pourAmount, 1.0)
                        INT_ENTITIES[closestChild.entity].progress = childEntity.progress
                        
                        -- Add flavor weight based on what's being poured
                        local bottleFlavorKey = currentEntity.flavorKey
                        if bottleFlavorKey then
                            -- Initialize flavorWeights if it doesn't exist
                            if not childEntity.flavorWeights then
                                childEntity.flavorWeights = {}
                            end
                            
                            -- Calculate the proportion this pour adds (pourAmount / total progress)
                            local flavorProportion = pourAmount / childEntity.progress
                            
                            -- Adjust existing weights to account for the new liquid
                            -- Existing weights need to be scaled down: oldWeight * (oldProgress / newProgress)
                            local scaleFactor = oldProgress / childEntity.progress
                            for flavorIndex, weight in pairs(childEntity.flavorWeights) do
                                childEntity.flavorWeights[flavorIndex] = weight * scaleFactor
                            end
                            
                            -- Add the new flavor proportion
                            local fw = childEntity.flavorWeights
                            if fw then
                                fw[bottleFlavorKey] = (fw[bottleFlavorKey] or 0) + flavorProportion
                                childEntity.flavorWeights = fw
                            end
                            
                            -- Update the entity data
                            INT_ENTITIES[closestChild.entity].flavorWeights = childEntity.flavorWeights
                        end
                    end
                elseif currentEntity.ptfx then
                    StopParticleFxLooped(currentEntity.ptfx, false)
                    RemoveParticleFx(currentEntity.ptfx, true)
                    currentEntity.ptfx = nil
                end
            elseif currentEntity.ptfx then
                StopParticleFxLooped(currentEntity.ptfx, false)
                RemoveParticleFx(currentEntity.ptfx, true)
                currentEntity.ptfx = nil
            end
        end,
        unSelected = function(entity, data)
            local currentEntity = INT_ENTITIES[entity]
            if not currentEntity then return end
            if currentEntity.ptfx then
                StopParticleFxLooped(currentEntity.ptfx, false)
                RemoveParticleFx(currentEntity.ptfx, true)
                currentEntity.ptfx = nil
            end
        end,
    })
    RegisterInteractiveEntity("drink", {
        init = function(coords, heading, data, params)
            local drink = CreateProp(`prop_tall_glass`, coords.x, coords.y, coords.z + 0.3, false, false, false)
            SetEntityCollision(drink, true, true)
            SetEntityHeading(drink, heading)
            return drink, {
                progress = params.progress,
                flavorWeights = params.flavorWeights,
                heightOffset = 0.25,
            }
        end,
        entityThread = function(entity, data)
            local radius = 0.08
            local maxHeight = 0.1875
            local surfaceHeight = 0.01
            local alpha = 128
            local height = INT_ENTITIES[entity].progress * maxHeight
            local rotation = GetEntityRotation(entity)
            local rx, ry, rz = rotation.x, rotation.y, rotation.z
            local forwardVector, rightVector, upVector, position = GetEntityMatrix(entity)
            local renderCoords = position + (upVector * surfaceHeight)
            local surfaceCoords = renderCoords + (upVector * height)
            -- Calculate color from flavor weights
            local color = CalculateColorFromFlavors(INT_ENTITIES[entity].flavorWeights)
            if color and INT_ENTITIES[entity].progress > 0.0 then
                DrawMarker(1, renderCoords.x, renderCoords.y, renderCoords.z, upVector.x, upVector.y, upVector.z, 90.0, -ry, rz, radius, radius, height, color[1], color[2], color[3], alpha, false, false, 2)
                DrawMarker(28, renderCoords.x, renderCoords.y, renderCoords.z, upVector.x, upVector.y, upVector.z, 270.0, -ry, rz, radius * 0.5, radius * 0.5, 0.001, color[1], color[2], color[3], alpha, false, false, 2)
                DrawMarker(1, surfaceCoords.x, surfaceCoords.y, surfaceCoords.z, upVector.x, upVector.y, upVector.z, 270.0, -ry, rz, radius, radius, height, color[1], color[2], color[3], alpha, false, false, 2)
                DrawMarker(28, surfaceCoords.x, surfaceCoords.y, surfaceCoords.z, upVector.x, upVector.y, upVector.z, 270.0, -ry, rz, radius * 0.5, radius * 0.5, 0.001, color[1], color[2], color[3], alpha, false, false, 2)
            end
            
            -- Draw flavor percentages above the drink
            local progress = INT_ENTITIES[entity].progress
            local totalPct = math.floor(progress * 100)
            local secondaryTitle = totalPct .. "%"
            local flavorWeights = INT_ENTITIES[entity].flavorWeights
            if flavorWeights and next(flavorWeights) ~= nil then
                local textY = position.z + 0.15 -- Start above the drink
                local textLines = {}

                local alcoholKey = Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.key or "_alcohol"
                local alcoholLabel = Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.label or "Alcohol"

                -- First pass: floor each percentage and track the sum
                local sumFloored = 0
                local largestIdx = nil
                local largestVal = -1
                for flavorKey, weight in pairs(flavorWeights) do
                    if weight > 0.001 then
                        local absolute = math.floor(weight * progress * 100)
                        sumFloored = sumFloored + absolute
                        local label
                        local isAlcohol = false
                        if flavorKey == alcoholKey then
                            label = alcoholLabel
                            isAlcohol = true
                        else
                            local flavor = Config.Bartender.flavors[flavorKey]
                            label = flavor and flavor.label or (_L("bartender_flavor_prefix") .. flavorKey)
                        end
                        table.insert(textLines, {type = "progress", label = label, value = absolute, isAlcohol = isAlcohol})
                        if absolute > largestVal then
                            largestVal = absolute
                            largestIdx = #textLines
                        end
                    end
                end

                -- Distribute rounding remainder to the largest ingredient
                local remainder = totalPct - sumFloored
                if remainder ~= 0 and largestIdx then
                    textLines[largestIdx].value = textLines[largestIdx].value + remainder
                end

                -- Sort by value (descending)
                table.sort(textLines, function(a, b) return a.value > b.value end)
                -- Match against menu for title; fall back to generic if no match
                local title = MatchDrinkToMenuName(flavorWeights) or _L("bartender_drink")
                if INT_ENTITIES[entity].progress >= 1.0 then 
                    table.insert(textLines, {type = "text", label = _L("bartender_place_drink_coaster"), center = true })
                    
                    -- Check if drink is on coaster and submit if not already submitted
                    CheckDrinkOnCoaster(entity)
                end
                UpdateInteractiveEntityDisplay(entity, {
                    title = title,
                    secondaryTitle = secondaryTitle,
                    rows = textLines
                })
            else
                UpdateInteractiveEntityDisplay(entity, {
                    title = _L("bartender_empty_drink"),
                    secondaryTitle = "0%",
                    rows = {
                        {type = "text", label = _L("bartender_fill_drink_flavors")}
                    }
                })
            end

        end,
        selectedThread = function(entity, data)
            local pitch = data.pitch
            local currentEntity = INT_ENTITIES[entity]
            local minimum, maximum = data.minimum, data.maximum
            if math.abs(pitch) > 90.0 and math.abs(pitch) < 270.0 and currentEntity.progress > 0.0 then
                -- Calculate pour rate based on pitch (how much the drink is tilted)
                local pourRate = CalculatePourRate(pitch)
                local basePourAmount = 0.015 -- Maximum pour amount
                local pourAmount = basePourAmount * pourRate
                currentEntity.progress = currentEntity.progress - pourAmount
                -- Ensure progress doesn't go below 0
                if currentEntity.progress <= 0.0 then
                    currentEntity.progress = 0.0
                    -- Reset flavor weights when drink is fully poured out
                    currentEntity.flavorWeights = {}
                    INT_ENTITIES[entity].flavorWeights = {}
                end
                if not currentEntity.ptfx or currentEntity.refreshTime < GetGameTimer() then
                    currentEntity.refreshTime = GetGameTimer() + 2000
                    if currentEntity.ptfx then
                        local ptfxHandle = currentEntity.ptfx
                        SetTimeout(300, function()
                            StopParticleFxLooped(ptfxHandle, false)
                            RemoveParticleFx(ptfxHandle, true)
                        end)
                    end
                    RequestNamedPtfxAsset("cut_family1")
                    while not HasNamedPtfxAssetLoaded("cut_family1") do
                        Wait(0)
                    end
                    UseParticleFxAssetNextCall("cut_family1")
                    currentEntity.ptfx = StartParticleFxLoopedOnEntity("cs_fam1_bourbon_pour", CURRENT_ENTITY, 0.0, 0.0, 0.285, 0.0, 0.0, 0.0, 2.5, false, false, false)
                    SetParticleFxLoopedColour(currentEntity.ptfx, 255, 0, 0, 255)
                else
                    local scale = 4 * pourRate
                    SetParticleFxLoopedScale(currentEntity.ptfx, scale)
                    SetParticleFxLoopedOffsets(currentEntity.ptfx, (0.045 * (pourRate + -1)) * (math.abs(pitch) < 180 and -1 or 1), 0.0, 0.285 + (0.05 * (pourRate + -1)), 0.0, 0.0, 0.0)
                end
            elseif currentEntity.ptfx then
                StopParticleFxLooped(currentEntity.ptfx, false)
                RemoveParticleFx(currentEntity.ptfx, true)
                currentEntity.ptfx = nil
            end
        end,
        unSelected = function(entity, data)
            local currentEntity = INT_ENTITIES[entity]
            if not currentEntity then return end
            if currentEntity.ptfx then
                StopParticleFxLooped(currentEntity.ptfx, false)
                RemoveParticleFx(currentEntity.ptfx, true)
                currentEntity.ptfx = nil
            end
        end,
    })
    RegisterInteractiveEntity("coaster", {
        init = function(coords, heading, data, params)
            local coaster = CreateProp(`npds_coaster_round_02`, coords.x, coords.y, coords.z - 0.035, false, false, false)
            SetEntityCollision(coaster, true, true)
            SetEntityHeading(coaster, heading)
            return coaster, {
                disableInteraction = true,
                disableGravity = true,
            }
        end,
    })
    RegisterInteractiveEntity("register", {
        init = function(coords, heading, data, params)
            local till = CreateProp(`vw_prop_casino_till`, coords.x, coords.y, coords.z, false, false, false)
            SetEntityCollision(till, true, true)
            SetEntityHeading(till, heading)
            return till, {
                disableInteraction = true,
                disableGravity = true,
            }
        end,
        clicked = function(entity, data)
            OpenBartenderRegister()
        end,
    })
    RegisterInteractiveEntity("recipe_book", {
        init = function(coords, heading, data, params)
            local book = CreateProp(`prop_stripmenu`, coords.x, coords.y, coords.z, false, false, false)
            SetEntityCollision(book, true, true)
            SetEntityHeading(book, heading)
            return book, {
                disableInteraction = true,
                disableGravity = true,
            }
        end,
        clicked = function(entity, data)
            OpenRecipeBook()
        end,
    })
    -- Stations are now loaded dynamically from database via syncStations event
    -- Hardcoded station removed - use /clubs to create stations
end)

-- Helper function to throw away drink with physics
local function ThrowAwayDrink(equippedDrinkRef)
    if not equippedDrinkRef or PlayerEquippedDrink~=equippedDrinkRef then return end
    
    local playerPed = PlayerPedId()
    
    -- Stop any animations
    ClearPedTasks(playerPed)

    if DoesEntityExist(equippedDrinkRef.prop) then
        DeleteEntity(equippedDrinkRef.prop)
    end
    -- Hide controls
    SendNUIMessage({
        type = "updateControls",
        controls = nil
    })
    TriggerServerEvent("pickle_clubs:removeEquippedDrinkSync")
    PlayerEquippedDrink = nil
end

-- Handle drink item use
RegisterNetEvent("pickle_clubs:useDrinkItem", function(itemName, flavors, alcoholPct)
    local playerPed = PlayerPedId()

    -- Clean up any existing equipped drink
    if PlayerEquippedDrink then
        if PlayerEquippedDrink.prop and DoesEntityExist(PlayerEquippedDrink.prop) then
            DeleteEntity(PlayerEquippedDrink.prop)
        end
        ClearPedTasks(playerPed)
        TriggerServerEvent("pickle_clubs:removeEquippedDrinkSync")
        PlayerEquippedDrink = nil
    end

    -- Build equal-weight flavorWeights from the recipe flavor indices
    local flavorWeights = {}
    if type(flavors) == "table" and #flavors > 0 then
        local share = 1.0 / #flavors
        for _, idx in ipairs(flavors) do
            flavorWeights[idx] = share
        end
    end
    -- Calculate color from flavor weights
    local color = CalculateColorFromFlavors(flavorWeights)
    
    -- Create drink prop
    local drinkProp = CreateProp(`prop_tall_glass`, 0.0, 0.0, 0.0, false, false, false)
    SetEntityCollision(drinkProp, false, false)
    SetEntityVisible(drinkProp, true, false)
    
    -- Attach to right hand (bone index 60309 or 28422)
    local boneIndex = GetPedBoneIndex(playerPed, 28422) -- hand_r
    AttachEntityToEntity(drinkProp, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    
    -- Play idle animation (holding drink)
    local idleDict = "amb@world_human_drinking@beer@male@base"
    RequestAnimDict(idleDict)
    while not HasAnimDictLoaded(idleDict) do
        Wait(0)
    end
    TaskPlayAnim(playerPed, idleDict, "base", 8.0, -8.0, -1, 49, 0, false, false, false)
    
    -- Store equipped drink data
    PlayerEquippedDrink = {
        prop = drinkProp,
        flavorWeights = flavorWeights,
        color = color,
        progress = 1.0, -- Start at 100% (full drink)
        itemName = itemName,
        alcoholPct = alcoholPct,
        isDrinking = false,
        drinkAnimDict = "amb@world_human_drinking@beer@male@idle_a",
        drinkAnim = "idle_b",
        idleDict = idleDict,
        idleAnim = "base"
    }
    
    -- Store reference for threads
    local equippedDrinkRef = PlayerEquippedDrink
    
    -- Sync to nearby players
    local playerCoords = GetEntityCoords(playerPed)
    TriggerServerEvent("pickle_clubs:syncEquippedDrink", playerCoords, flavorWeights, color, equippedDrinkRef.progress)
    
    -- Periodic sync thread to update position
    CreateThread(function()
        while PlayerEquippedDrink==equippedDrinkRef and DoesEntityExist(playerPed) do
            Wait(2000) -- Update every 2 seconds
            if equippedDrinkRef then
                local currentCoords = GetEntityCoords(playerPed)
                TriggerServerEvent("pickle_clubs:syncEquippedDrink", currentCoords, equippedDrinkRef.flavorWeights, equippedDrinkRef.color, equippedDrinkRef.progress)
            end
        end
    end)
    
    -- Create marker rendering thread
    equippedDrinkRef.thread = CreateThread(function()
        while PlayerEquippedDrink==equippedDrinkRef and DoesEntityExist(playerPed) do
            if DoesEntityExist(drinkProp) then
                local propCoords = GetEntityCoords(drinkProp)
                local forwardVector, rightVector, upVector, position = GetEntityMatrix(drinkProp)
                local radius = 0.08
                local maxHeight = 0.1875
                local surfaceHeight = 0.01
                local alpha = 128
                local height = equippedDrinkRef.progress * maxHeight
                local rotation = GetEntityRotation(drinkProp)
                local rx, ry, rz = rotation.x, rotation.y, rotation.z
                local renderCoords = position + (upVector * surfaceHeight)
                local surfaceCoords = renderCoords + (upVector * height)
                local drinkColor = equippedDrinkRef.color

                -- Draw drink markers (same as entityThread for drinks)
                if drinkColor then
                    DrawMarker(1, renderCoords.x, renderCoords.y, renderCoords.z, upVector.x, upVector.y, upVector.z, 90.0, -ry, rz, radius, radius, height, drinkColor[1], drinkColor[2], drinkColor[3], alpha, false, false, 2, false, nil, nil, false)
                    DrawMarker(28, renderCoords.x, renderCoords.y, renderCoords.z, upVector.x, upVector.y, upVector.z, 270.0, -ry, rz, radius * 0.5, radius * 0.5, 0.001, drinkColor[1], drinkColor[2], drinkColor[3], alpha, false, false, 2, false, nil, nil, false)
                    DrawMarker(1, surfaceCoords.x, surfaceCoords.y, surfaceCoords.z, upVector.x, upVector.y, upVector.z, 270.0, -ry, rz, radius, radius, height, drinkColor[1], drinkColor[2], drinkColor[3], alpha, false, false, 2, false, nil, nil, false)
                    DrawMarker(28, surfaceCoords.x, surfaceCoords.y, surfaceCoords.z, upVector.x, upVector.y, upVector.z, 270.0, -ry, rz, radius * 0.5, radius * 0.5, 0.001, drinkColor[1], drinkColor[2], drinkColor[3], alpha, false, false, 2, false, nil, nil, false)
                end
            end
            Wait(0)
        end
    end)
    
    -- Start drinking mechanics thread
    DrinkingThread = CreateThread(function()
        while PlayerEquippedDrink==equippedDrinkRef and DoesEntityExist(playerPed) do
            Wait(0)
            
            if PlayerEquippedDrink~=equippedDrinkRef then break end
            
            -- Check if animations have stopped and resume idle if needed
            if not equippedDrinkRef.isDrinking and equippedDrinkRef.progress > 0.0 then
                -- Check if idle animation is still playing
                if not IsEntityPlayingAnim(playerPed, equippedDrinkRef.idleDict, equippedDrinkRef.idleAnim, 3) then
                    -- Animation stopped (e.g., bumped into wall), resume idle
                    RequestAnimDict(equippedDrinkRef.idleDict)
                    while not HasAnimDictLoaded(equippedDrinkRef.idleDict) do
                        Wait(0)
                    end
                    TaskPlayAnim(playerPed, equippedDrinkRef.idleDict, equippedDrinkRef.idleAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
                end
            elseif equippedDrinkRef.isDrinking then
                -- Check if drinking animation is still playing
                if not IsEntityPlayingAnim(playerPed, equippedDrinkRef.drinkAnimDict, equippedDrinkRef.drinkAnim, 3) then
                    -- Drinking animation stopped, resume it
                    RequestAnimDict(equippedDrinkRef.drinkAnimDict)
                    while not HasAnimDictLoaded(equippedDrinkRef.drinkAnimDict) do
                        Wait(0)
                    end
                    TaskPlayAnim(playerPed, equippedDrinkRef.drinkAnimDict, equippedDrinkRef.drinkAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
                end
            end
            
            -- Show UI controls
            local progressPercent = math.floor(equippedDrinkRef.progress * 100)
            local controls = {}
            
            if not equippedDrinkRef.isDrinking and equippedDrinkRef.progress > 0.0 then
                -- Show drink controls with progress bar
                table.insert(controls, {key = "E", label = "drink_hold_to_drink", progress = progressPercent})
            elseif equippedDrinkRef.isDrinking then
                -- Show drinking status with progress bar
                table.insert(controls, {key = "E", label = "drink_drinking", progress = progressPercent})
            end
            
            -- Send controls to NUI
            SendNUIMessage({
                type = "updateControls",
                controls = controls
            })
            
            -- Check for throw away (ESC, Backspace, or X)
            -- ESC = 322 (group 0), Backspace = 194 (group 0), X = 73 (group 1 for keyboard)
            if (IsControlJustPressed(0, 322) or IsControlJustPressed(0, 194) or IsControlJustPressed(1, 323)) and equippedDrinkRef and equippedDrinkRef.progress > 0.0 then
                -- Throw away the drink
                equippedDrinkRef.progress = 0.0
                equippedDrinkRef.isDrinking = false
                
                -- Use shared throw away function
                ThrowAwayDrink(equippedDrinkRef)
                break
            end
            
            -- Check if E is being held (Control 38)
            local isHoldingE = IsControlPressed(0, 38) -- E key
            
            if isHoldingE and not equippedDrinkRef.isDrinking and equippedDrinkRef.progress > 0.0 then
                -- Start drinking
                equippedDrinkRef.isDrinking = true
                
                -- Request and play drinking animation
                RequestAnimDict(equippedDrinkRef.drinkAnimDict)
                while not HasAnimDictLoaded(equippedDrinkRef.drinkAnimDict) do
                    Wait(0)
                end
                TaskPlayAnim(playerPed, equippedDrinkRef.drinkAnimDict, equippedDrinkRef.drinkAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
                
                -- Drink while E is held - continuous smooth draining
                local drinkStartTime = GetGameTimer()
                local drinkDuration = 20000 -- 20 seconds to fully drain
                local lastProgressUpdate = GetGameTimer()
                local lastServerSync = GetGameTimer()
                local initialProgress = equippedDrinkRef.progress
                local shouldThrowAway = false
                local amountConsumed = 0.0 -- Proportion of drink consumed this sip (0-1), for scaled alcohol
                
                while IsControlPressed(0, 38) and equippedDrinkRef and equippedDrinkRef.progress > 0.0 do
                    Wait(0) -- Update every frame for smooth progress bar
                    
                    -- Check for ESC (322), Backspace (194), or X (73) to throw away
                    if IsControlJustPressed(0, 322) or IsControlJustPressed(0, 194) or IsControlJustPressed(0, 73) then
                        shouldThrowAway = true
                        amountConsumed = initialProgress - equippedDrinkRef.progress -- Only count what was drunk before throwing
                        equippedDrinkRef.progress = 0.0 -- Set to empty to trigger throw away
                        break
                    end
                    
                    local currentTime = GetGameTimer()
                    local elapsedTime = currentTime - drinkStartTime
                    
                    -- Calculate smooth continuous progress based on time elapsed
                    local progressDrained = math.min(1.0, elapsedTime / drinkDuration)
                    equippedDrinkRef.progress = math.max(0.0, initialProgress - progressDrained)
                    
                    -- Update UI in real-time (every 16ms for ~60fps smooth animation)
                    if currentTime - lastProgressUpdate >= 16 then
                        local progressPercent = math.floor(equippedDrinkRef.progress * 100)
                        SendNUIMessage({
                            type = "updateControls",
                            controls = {
                                {key = "E", label = "drink_drinking", progress = progressPercent}
                            }
                        })
                        lastProgressUpdate = currentTime
                    end
                    
                    -- Sync to server every 200ms for network efficiency
                    if currentTime - lastServerSync >= 200 then
                        local currentCoords = GetEntityCoords(playerPed)
                        TriggerServerEvent("pickle_clubs:syncEquippedDrink", currentCoords, equippedDrinkRef.flavorWeights, equippedDrinkRef.color, equippedDrinkRef.progress)
                        lastServerSync = currentTime
                    end
                    
                    -- If drink is empty, break and throw away
                    if equippedDrinkRef.progress <= 0.0 then
                        break
                    end
                end
                
                -- Amount consumed this sip (for scaled alcohol): only set if we didn't throw (throw branch already set amountConsumed)
                if not shouldThrowAway then
                    amountConsumed = initialProgress - equippedDrinkRef.progress
                end
                if amountConsumed > 0.0 then
                    TriggerServerEvent("pickle_clubs:drinkConsumed", amountConsumed, equippedDrinkRef.alcoholPct)
                end
                
                -- Stop drinking animation and return to idle
                ClearPedTasks(playerPed)
                if equippedDrinkRef and equippedDrinkRef.progress > 0.0 then
                    RequestAnimDict(equippedDrinkRef.idleDict)
                    while not HasAnimDictLoaded(equippedDrinkRef.idleDict) do
                        Wait(0)
                    end
                    TaskPlayAnim(playerPed, equippedDrinkRef.idleDict, equippedDrinkRef.idleAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
                end
                
                equippedDrinkRef.isDrinking = false
                
                -- If drink is empty, throw it away
                if equippedDrinkRef.progress <= 0.0 then
                    -- Use shared throw away function
                    ThrowAwayDrink(equippedDrinkRef)
                    break
                end
            end
        end
        
        -- Hide controls when thread ends
        SendNUIMessage({
            type = "updateControls",
            controls = nil
        })
        DrinkingThread = nil
    end)
end)

-- Sync equipped drinks from other players
RegisterNetEvent("pickle_clubs:syncEquippedDrinkUpdate", function(playerId, coords, flavorWeights, color, progress)
    local localServerId = GetPlayerServerId(PlayerId())
    if playerId == localServerId then return end -- Don't sync our own drink
    
    -- Update or create equipped drink entry
    EquippedDrinks[playerId] = {
        coords = coords,
        flavorWeights = flavorWeights,
        color = color,
        progress = progress,
        lastUpdate = GetGameTimer()
    }
end)

-- Remove equipped drink when player unequips
RegisterNetEvent("pickle_clubs:removeEquippedDrink", function(playerId)
    local localServerId = GetPlayerServerId(PlayerId())
    if playerId == localServerId or playerId == -1 then
        -- Clean up local equipped drink
        if PlayerEquippedDrink then
            if PlayerEquippedDrink.prop and DoesEntityExist(PlayerEquippedDrink.prop) then
                DeleteEntity(PlayerEquippedDrink.prop)
            end
            ClearPedTasks(PlayerPedId())
            PlayerEquippedDrink = nil
        end
        if DrinkingThread then
            DrinkingThread = nil
        end
        -- Hide controls
        SendNUIMessage({
            type = "updateControls",
            controls = nil
        })
    end
    
    if playerId ~= localServerId and playerId ~= -1 then
        -- Remove from other players' equipped drinks
        EquippedDrinks[playerId] = nil
    elseif playerId == -1 then
        -- Remove all equipped drinks
        EquippedDrinks = {}
    end
end)

-- Render markers for other players' equipped drinks
CreateThread(function()
    while true do
        local wait = 1500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local currentTime = GetGameTimer()
        
        for playerId, drinkData in pairs(EquippedDrinks) do
            -- Remove stale entries (older than 5 seconds)
            if currentTime - (drinkData.lastUpdate or 0) > 5000 then
                EquippedDrinks[playerId] = nil
            else
                local serverId = GetPlayerFromServerId(playerId)
                if serverId == -1 then
                    EquippedDrinks[playerId] = nil
                else
                    local otherPlayerPed = GetPlayerPed(serverId)
                    if DoesEntityExist(otherPlayerPed) then
                        local otherCoords = GetEntityCoords(otherPlayerPed)
                        local distance = #(playerCoords - otherCoords)
                        
                        -- Only render if within render distance
                        if distance < Config.RenderDistance then
                            -- Get bone position for right hand
                            local boneIndex = GetPedBoneIndex(otherPlayerPed, 28422) -- hand_r
                            local boneCoords = GetWorldPositionOfEntityBone(otherPlayerPed, boneIndex)
                            
                            if boneCoords then
                                wait = 0
                                local radius = 0.08
                                local maxHeight = 0.1875
                                local surfaceHeight = 0.01
                                local alpha = 128
                                local drinkProgress = drinkData.progress
                                local height = drinkProgress * maxHeight
                                local drinkColor = drinkData.color
                                
                                -- Calculate up vector from player heading
                                local playerHeading = GetEntityHeading(otherPlayerPed)
                                local upVector = vector3(0.0, 0.0, 1.0)
                                
                                local renderCoords = boneCoords + (upVector * surfaceHeight)
                                local surfaceCoords = renderCoords + (upVector * height)
                                
                                -- Draw drink markers
                                DrawMarker(1, renderCoords.x, renderCoords.y, renderCoords.z, upVector.x, upVector.y, upVector.z, 90.0, 0.0, playerHeading, radius, radius, height, drinkColor[1], drinkColor[2], drinkColor[3], alpha, false, false, 2)
                                DrawMarker(28, renderCoords.x, renderCoords.y, renderCoords.z, upVector.x, upVector.y, upVector.z, 270.0, 0.0, playerHeading, radius * 0.5, radius * 0.5, 0.001, drinkColor[1], drinkColor[2], drinkColor[3], alpha, false, false, 2)
                                DrawMarker(1, surfaceCoords.x, surfaceCoords.y, surfaceCoords.z, upVector.x, upVector.y, upVector.z, 270.0, 0.0, playerHeading, radius, radius, height, drinkColor[1], drinkColor[2], drinkColor[3], alpha, false, false, 2)
                                DrawMarker(28, surfaceCoords.x, surfaceCoords.y, surfaceCoords.z, upVector.x, upVector.y, upVector.z, 270.0, 0.0, playerHeading, radius * 0.5, radius * 0.5, 0.001, drinkColor[1], drinkColor[2], drinkColor[3], alpha, false, false, 2)
                            end
                        end
                    else
                        -- Player doesn't exist, remove entry
                        EquippedDrinks[playerId] = nil
                    end
                end
            end
        end
        Wait(wait)
    end
end)

-- Cleanup on resource stop
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        -- Clean up equipped drink
        if PlayerEquippedDrink then
            if PlayerEquippedDrink.prop and DoesEntityExist(PlayerEquippedDrink.prop) then
                DeleteEntity(PlayerEquippedDrink.prop)
            end
            ClearPedTasks(PlayerPedId())
            PlayerEquippedDrink = nil
        end
        DrinkingThread = nil
        
        -- Clear other players' equipped drinks
        EquippedDrinks = {}
    end
end)