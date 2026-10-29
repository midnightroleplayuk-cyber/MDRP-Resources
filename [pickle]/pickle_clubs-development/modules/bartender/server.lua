-- Multi-Station Bartender Server
-- Bartender entities are stored in Clubs[id].entities[entityId].

-- Get only the valid flavors from a drink entry (strips invalid keys)
function GetValidFlavors(entry)
    if type(entry) ~= "table" or type(entry.flavors) ~= "table" then
        return {}
    end
    local configFlavors = Config.Bartender and Config.Bartender.flavors or {}
    local valid = {}
    for _, flavorKey in ipairs(entry.flavors) do
        if configFlavors[flavorKey] then
            valid[#valid + 1] = flavorKey
        end
    end
    return valid
end

-- Check if a drink entry has at least one valid flavor
function DrinkHasValidFlavors(entry)
    return #GetValidFlavors(entry) > 0
end

-- Per-station runtime data: stationId -> {orderQueue, serviceActive, interactionData, spawnThread, timerThread}
StationData = {}
StationRegistry = {} -- stationId -> persisted station metadata from club entity
StationControllers = {} -- stationId -> {interaction = {source=...}, service = {source=...}}

local function BuildStationId(clubId, entityId)
    return ("%s:%s"):format(clubId, entityId)
end

local function GetPrimaryJobName(club)
    local jobs = club and club.jobs or {}
    for i = 1, #jobs do
        if jobs[i].primary and type(jobs[i].name) == "string" and jobs[i].name ~= "" then
            return jobs[i].name
        end
    end
    return nil
end

local function BuildStationFromEntity(clubId, entityId)
    local club = Clubs[clubId]
    if not club then return nil end
    local entity = club.entities and club.entities[entityId]
    if not entity or entity.type ~= "bartender" or not entity.bartender then return nil end

    local bartender = entity.bartender
    local coords = bartender.coords
    if type(coords) == "table" then
        coords = vector3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
    end

    return {
        id = BuildStationId(clubId, entityId),
        clubId = clubId,
        entityId = entityId,
        coords = coords,
        heading = bartender.heading or 0.0,
        blip = bartender.blip or (Config.Bartender.defaultBlip or {
            name = "Bartending Station",
            color = 5,
            sprite = 52,
            scale = 0.8,
            visible = true,
        }),
        society_name = GetPrimaryJobName(club),
    }
end

local function RegisterBartenderStation(clubId, entityId)
    local station = BuildStationFromEntity(clubId, entityId)
    if not station then return end
    StationRegistry[station.id] = station
    TriggerClientEvent("pickle_clubs:syncStations", -1, StationRegistry)
end

local function UnregisterBartenderStation(clubId, entityId)
    local stationId = BuildStationId(clubId, entityId)
    if StationData[stationId] and StationData[stationId].serviceActive then
        StopBartenderService(stationId)
    end
    StationData[stationId] = nil
    StationControllers[stationId] = nil
    StationRegistry[stationId] = nil
    TriggerClientEvent("pickle_clubs:syncStations", -1, StationRegistry)
    TriggerClientEvent("pickle_clubs:removeStation", -1, stationId)
end

local function GetStation(stationId)
    return StationRegistry[stationId]
end

local function GetClubIdFromStationId(stationId)
    if type(stationId) ~= "string" then return nil end
    local clubIdStr = stationId:match("^(%d+):")
    return clubIdStr and tonumber(clubIdStr) or nil
end

local function GetClubDrinkMenuForStation(stationId)
    local clubId = GetClubIdFromStationId(stationId)
    if not clubId or not GetClubDrinkMenu then return nil end
    return GetClubDrinkMenu(clubId)
end

-- Pay society its cut from a sale and return the bartender's share
local function PaySocietyCut(stationId, totalAmount)
    local societyCut = Config.Bartender.societyCut or 0
    if societyCut <= 0 or totalAmount <= 0 then return totalAmount end
    local clubId = GetClubIdFromStationId(stationId)
    if not clubId then return totalAmount end
    local club = Clubs[clubId]
    if not club then return totalAmount end
    local jobs = club.jobs or {}
    local societyName = nil
    for i = 1, #jobs do
        if jobs[i].primary and type(jobs[i].name) == "string" and jobs[i].name ~= "" then
            societyName = jobs[i].name
            break
        end
    end
    if not societyName or not AddSocietyMoney then return totalAmount end
    local societyAmount = math.floor(totalAmount * societyCut)
    if societyAmount > 0 then
        if AddSocietyMoney(societyName,societyAmount)~=true then return totalAmount end
    end
    return totalAmount - societyAmount
end

local function IsStationControlled(stationId, controlType)
    if not StationControllers[stationId] then return false end
    if controlType then
        return StationControllers[stationId][controlType] ~= nil
    end
    for _, controller in pairs(StationControllers[stationId]) do
        if controller then return true end
    end
    return false
end

-- Ensure StationData exists and timer is running (for player orders and/or NPC service)
local function EnsureStationData(stationId)
    if StationData[stationId] then return end
    local station = GetStation(stationId)
    if not station then return end
    local coords = station.coords
    if type(coords) == "table" then
        coords = vector3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
    end
    StationData[stationId] = {
        orderQueue = {},
        serviceActive = false,
        interactionData = {
            coords = coords,
            heading = station.heading or 0.0,
        },
    }
    CreateThread(function()
        while StationData[stationId] do
            Wait(1000)
            local sd = StationData[stationId]
            if not sd then break end
            local expiredOrders = {}
            for i = 1, #sd.orderQueue do
                local order = sd.orderQueue[i]
                -- Only count down the front order, and skip player orders (no time limit)
                if order.isPlayerOrder and (os.time()>order.expiresAt or order.playerIdentity~=GetIdentifier(order.playerSource)) then
                    table.insert(expiredOrders,order.id)
                elseif i == 1 and not order.isPlayerOrder then
                    order.timer = order.timer - 1
                    if order.timer <= 0 then
                        table.insert(expiredOrders, order.id)
                    end
                end
            end
            for _, orderId in ipairs(expiredOrders) do
                ExpireOrder(stationId, orderId)
            end
            UpdateCurrentOrderDisplay(stationId)
        end
    end)
end

local function SetStationController(stationId, source, controlType)
    if not ClubStation(source,stationId) or not ClubStaff(source,GetClubIdFromStationId(stationId))
        or (controlType~='interaction' and controlType~='service') then return false,'No access' end
    if not GetStation(stationId) then return false, "Station not found" end
    if IsStationControlled(stationId, controlType) then
        return false, "Station is already controlled"
    end
    if not StationControllers[stationId] then StationControllers[stationId] = {} end
    StationControllers[stationId][controlType] = {
        source = source,
        identity=GetIdentifier(source),
        craftReady=GetGameTimer()+5000,
        type = controlType,
    }
    if controlType == "interaction" then
        EnsureStationData(stationId)
    end
    return true
end

local function ClearStationController(stationId, controlType)
    if not StationControllers[stationId] then return end
    if controlType then
        StationControllers[stationId][controlType] = nil
        local hasAny = false
        for _, controller in pairs(StationControllers[stationId]) do
            if controller then
                hasAny = true
                break
            end
        end
        if not hasAny then
            StationControllers[stationId] = nil
        end
    else
        StationControllers[stationId] = nil
    end
end

-- Collect all unique drink item names from loaded club menus
-- Calculate forwardVector from heading using trigonometry
function CalculateForwardVector(heading)
    -- Convert heading (degrees) to radians
    local headingRad = math.rad(heading)
    -- Calculate forward vector (x = sin(heading), y = -cos(heading), z = 0)
    local forwardX = math.sin(headingRad)
    local forwardY = -math.cos(headingRad)
    local forwardZ = 0.0
    return vector3(forwardX, forwardY, forwardZ)
end

function CalculateSpawnPosition(stationId)
    local stationData = StationData[stationId]
    if not stationData or not stationData.interactionData then return nil end
    
    local coords = stationData.interactionData.coords
    local heading = stationData.interactionData.heading
    local forwardVector = CalculateForwardVector(heading)
    
    -- Ensure coords is vector3
    if type(coords) == "table" then
        coords = vector3(coords.x, coords.y, coords.z)
    end
    return coords + (forwardVector * Config.Bartender.orderSpawnOffset)
end

function CalculateWalkPosition(stationId, queueIndex)
    local stationData = StationData[stationId]
    if not stationData or not stationData.interactionData then return nil end
    
    local coords = stationData.interactionData.coords
    local heading = stationData.interactionData.heading
    local forwardVector = CalculateForwardVector(heading)
    
    -- Calculate rightVector for queue positioning
    local rightVector = vector3(math.cos(math.rad(heading + 90)), math.sin(math.rad(heading + 90)), 0.0)
    
    -- Ensure coords is vector3
    if type(coords) == "table" then
        coords = vector3(coords.x, coords.y, coords.z)
    end
    
    -- First NPC at walkOffset, others offset along rightVector
    local basePos = coords + (forwardVector * -1.5)
    if queueIndex > 0 then
        basePos = basePos + (rightVector * (Config.Bartender.orderQueueSpacing * queueIndex))
    end
    return basePos - vector3(0.0, 0.0, 1.0)
end

-- Pick a random drink from the club menu for the given station; returns nil if no drinks defined
function GenerateDrinkOrder(stationId)
    local clubId = GetClubIdFromStationId(stationId)
    local menu = (clubId and GetClubDrinkMenu and GetClubDrinkMenu(clubId)) or {}
    local entries = {}
    for key, entry in pairs(menu) do
        if type(entry) == "table" and type(entry.name) == "string" and entry.name ~= ""
            and DrinkHasValidFlavors(entry) then
            entries[#entries + 1] = { key = key, entry = entry }
        end
    end
    if #entries == 0 then return nil end
    local chosen = entries[math.random(1, #entries)].entry
    return chosen.name, GetValidFlavors(chosen), chosen.alcohol, chosen.item
end

function CreateOrder(stationId)
    local orderId = GetGameTimer() .. "_" .. math.random(1000, 9999)
    local drinkName, requiredFlavorKeys, alcoholPct, item = GenerateDrinkOrder(stationId)
    if not drinkName then return nil end
    return {
        id = orderId,
        drinkName = drinkName,
        requiredFlavorKeys = requiredFlavorKeys,
        alcoholPct = alcoholPct,
        item = item,
        flavors = requiredFlavorKeys,
        timer = Config.Bartender.orderTimerDuration,
        createdAt = GetGameTimer(),
        stationId = nil,
    }
end

function SpawnNextOrder(stationId)
    local stationData = StationData[stationId]
    if not stationData or not stationData.serviceActive then return end
    
    -- Check queue length
    if #stationData.orderQueue >= Config.Bartender.maxActiveOrders then return end
    
    local order = CreateOrder(stationId)
    if not order then
        return
    end
    order.stationId = stationId
    -- Add to end of queue
    table.insert(stationData.orderQueue, order)
    local queueIndex = #stationData.orderQueue - 1 -- 0-based index for positioning
    
    -- Calculate positions
    local spawnPos = CalculateSpawnPosition(stationId)
    local walkPos = CalculateWalkPosition(stationId, queueIndex)
    
    if not spawnPos or not walkPos then
        print("ERROR: Could not calculate spawn/walk positions for order")
        -- Remove from queue
        for i = 1, #stationData.orderQueue do
            if stationData.orderQueue[i].id == order.id then
                table.remove(stationData.orderQueue, i)
                break
            end
        end
        return
    end
    
    -- Select random NPC model server-side so all clients spawn the same ped
    local npcModels = Config.Bartender.orderNPCs
    local npcModel = "a_m_m_skater_01" -- default fallback
    if npcModels and #npcModels > 0 then
        npcModel = npcModels[math.random(1, #npcModels)]
    end
    if type(npcModel) ~= "string" or npcModel == "" then
        npcModel = "a_m_m_skater_01"
    end

    -- Trigger spawn event to all clients (model is server-authoritative)
    TriggerClientEvent("pickle_clubs:spawnOrderNPC", -1, {
        stationId = stationId,
        orderId = order.id,
        drinkName = order.drinkName,
        timer = order.timer,
        spawnCoords = spawnPos,
        walkCoords = walkPos,
        npcModel = npcModel,
        queueIndex = queueIndex,
        heading = stationData.interactionData.heading,
    })
    
    -- Update current order display (only first in queue)
    UpdateCurrentOrderDisplay(stationId)
end

function UpdateCurrentOrderDisplay(stationId)
    local stationData = StationData[stationId]
    if not stationData then return end
    
    -- First order in queue is the current order
    if #stationData.orderQueue > 0 then
        local currentOrder = stationData.orderQueue[1]
        local payload = {
            stationId = stationId,
            orderId = currentOrder.id,
            orderName = currentOrder.drinkName,
            flavors = currentOrder.requiredFlavorKeys,
            alcoholPct = currentOrder.alcoholPct,
            timeRemaining = (not currentOrder.isPlayerOrder) and currentOrder.timer or nil,
            active = true,
            isPlayerOrder = currentOrder.isPlayerOrder == true,
        }
        if currentOrder.isPlayerOrder and currentOrder.playerSource then
            local playerName = GetPlayerCharacterName(currentOrder.playerSource)
            payload.orderPlayerName = playerName
        end
        TriggerClientEvent("pickle_clubs:updateOrder", -1, payload)
    else
        TriggerClientEvent("pickle_clubs:updateOrder", -1, {
            stationId = stationId,
            active = false,
        })
    end
end

function RemoveOrderFromQueue(stationId, orderId)
    local stationData = StationData[stationId]
    if not stationData then return false end
    
    -- Find and remove order from queue
    for i = 1, #stationData.orderQueue do
        if stationData.orderQueue[i].id == orderId then
            table.remove(stationData.orderQueue, i)
            -- Send updated queue indices to clients
            local queueData = {}
            for j = 1, #stationData.orderQueue do
                queueData[stationData.orderQueue[j].id] = j - 1 -- 0-based index
            end
            TriggerClientEvent("pickle_clubs:updateQueuePositions", -1, stationId, stationData.interactionData.heading, queueData)
            return true
        end
    end
    return false
end

function ExpireOrder(stationId, orderId, skipPlayerExpiredNotify)
    local stationData = StationData[stationId]
    local order = nil
    if stationData then
        for i = 1, #stationData.orderQueue do
            if stationData.orderQueue[i].id == orderId then
                order = stationData.orderQueue[i]
                break
            end
        end
    end
    -- Delete NPC only for NPC orders (player orders have no NPC)
    if not order or not order.isPlayerOrder then
        TriggerClientEvent("pickle_clubs:deleteOrderNPC", -1, stationId, orderId)
    end
    if order and order.isPlayerOrder and order.playerSource and not skipPlayerExpiredNotify then
        ShowNotification(order.playerSource, "Your order expired")
    end
    -- Remove from queue
    RemoveOrderFromQueue(stationId, orderId)
    -- Reset the new front order's timer so the bartender gets a fresh countdown
    if stationData and #stationData.orderQueue > 0 then
        stationData.orderQueue[1].timer = Config.Bartender.orderTimerDuration
    end
    -- Update display
    UpdateCurrentOrderDisplay(stationId)
end

function StartBartenderService(stationId, coords, heading)
    local station = GetStation(stationId)
    if not station then
        print("ERROR: Station " .. stationId .. " not found")
        return false
    end

    if StationData[stationId] and StationData[stationId].serviceActive then
        print("ERROR: Bartender service already active for station " .. stationId)
        return false
    end

    EnsureStationData(stationId)
    local stationData = StationData[stationId]
    if not stationData then return false end

    stationData.serviceGeneration=(stationData.serviceGeneration or 0)+1
    local generation=stationData.serviceGeneration
    stationData.serviceActive = true
    if type(coords) == "table" then
        coords = vector3(coords.x, coords.y, coords.z)
    end
    stationData.interactionData = {
        coords = coords,
        heading = heading,
    }

    -- Do not clear orderQueue; player orders may already be in queue

    -- Check if there are any valid drinks on the menu
    local hasValidDrinks = GenerateDrinkOrder(stationId) ~= nil
    if not hasValidDrinks then
        stationData.serviceActive = false
        return false, "No eligible drinks on the menu. Update the drink menu to use valid flavors."
    end

    -- Timer thread is already running from EnsureStationData

    -- Start spawn thread
    StationData[stationId].spawnThread = CreateThread(function()
        while StationData[stationId]==stationData and stationData.serviceActive and stationData.serviceGeneration==generation do
            Wait(Config.Bartender.orderSpawnInterval * 1000)
            if StationData[stationId]==stationData and stationData.serviceActive and stationData.serviceGeneration==generation then
                SpawnNextOrder(stationId)
            end
        end
    end)

    -- Spawn first order immediately
    SpawnNextOrder(stationId)

    return true
end

function StopBartenderService(stationId)
    local stationData = StationData[stationId]
    if not stationData or not stationData.serviceActive then
        print("ERROR: Bartender service not active for station " .. stationId)
        return false
    end
    
    stationData.serviceActive = false
    stationData.serviceGeneration=(stationData.serviceGeneration or 0)+1

    -- Cleanup all orders, refund player orders
    for i = 1, #stationData.orderQueue do
        local order = stationData.orderQueue[i]
        TriggerClientEvent("pickle_clubs:deleteOrderNPC", -1, stationId, order.id)
        if order.isPlayerOrder and order.playerSource then
            -- Refund the player
            local price = order.price or 0
            if price > 0 and GetPlayerPing(order.playerSource) > 0 then
                if order.paid then AddMoney(order.playerSource, price, "money") end
            end
            if GetPlayerPing(order.playerSource) > 0 then
                ShowNotification(order.playerSource, "Your order has been cancelled")
            end
        end
    end
    stationData.orderQueue = {}
    
    -- Cleanup all NPCs on all clients for this station
    TriggerClientEvent("pickle_clubs:cleanupAllOrders", -1, stationId)
    
    -- Clear order display
    TriggerClientEvent("pickle_clubs:updateOrder", -1, {
        stationId = stationId,
        active = false,
    })
    
    return true
end

-- Events
RegisterNetEvent("pickle_clubs:startBartenderService", function(stationId, coords, heading)
    local source = source

    local success, message = SetStationController(stationId, source, "service")
    if not success then
        TriggerClientEvent("pickle_clubs:stationControlDenied", source, message or "Station is already in use")
        return
    end
    
    local serviceStarted, failMessage = StartBartenderService(stationId, coords, heading)
    if serviceStarted then
        -- service started
    else
        -- Clear controller if service failed to start
        ClearStationController(stationId, "service")
        TriggerClientEvent("pickle_clubs:stationControlDenied", source, failMessage or "Failed to start service")
    end
end)

RegisterNetEvent("pickle_clubs:stopBartenderService", function(stationId)
    if not ClubStation(source,stationId,"service") then return end
    local source = source
    
    if StopBartenderService(stationId) then
        ClearStationController(stationId, "service")
    end
end)

function ValidateDrink(stationId, orderId, flavorWeights)
    local stationData = StationData[stationId]
    if not stationData then return false, "Station not found" end

    local order = nil
    for i = 1, #stationData.orderQueue do
        if stationData.orderQueue[i].id == orderId then
            order = stationData.orderQueue[i]
            break
        end
    end
    if not order then return false, "Order not found" end

    local requiredFlavors = order.requiredFlavorKeys
    if not requiredFlavors or #requiredFlavors == 0 then
        return false, "Invalid order requirements"
    end

    -- Separate alcohol weight from taste flavor weights
    local alcoholKey = (Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.key) or "_alcohol"
    local alcoholWeight = flavorWeights[alcoholKey] or 0
    local submittedAlcoholPct = math.floor(alcoholWeight * 100 + 0.5)

    -- Validate alcohol content against order requirement
    local requiredAlcoholPct = order.alcoholPct or 0
    local tolerance = Config.Bartender.alcoholTolerance or 10
    if math.abs(submittedAlcoholPct - requiredAlcoholPct) > tolerance then
        return false, "Wrong alcohol strength"
    end

    -- Validate taste flavors (excluding alcohol from totals)
    local tasteWeight = 0
    for key, weight in pairs(flavorWeights) do
        if key ~= alcoholKey then
            tasteWeight = tasteWeight + weight
        end
    end
    if tasteWeight < 0.3 then return false, "Drink not full enough" end

    local numRequired = #requiredFlavors
    local requiredWeight = 0
    local flavorRatios = {}
    for i = 1, numRequired do
        local flavorKey = requiredFlavors[i]
        local weight = flavorWeights[flavorKey] or 0
        if weight < 0.01 then return false, "Missing required flavor" end
        requiredWeight = requiredWeight + weight
        flavorRatios[#flavorRatios + 1] = weight
    end

    local threshold = numRequired == 1 and 0.85 or 0.70
    if (requiredWeight / tasteWeight) < threshold then
        return false, "Too many extra flavors"
    end

    -- Balance check: each flavor should be close to 1/n of the required weight
    if numRequired > 1 then
        local balanceTolerance = 0.15
        local idealShare = 1.0 / numRequired
        for _, w in ipairs(flavorRatios) do
            local share = w / requiredWeight
            if math.abs(share - idealShare) > balanceTolerance then
                return false, "Flavors not balanced"
            end
        end
    end

    return true, "Correct"
end

-- Track registered drink items to avoid duplicate registrations (used by submitDrink and giveDrinkItem)
local RegisteredDrinkItems = {}

local function RegisterDrinkItemIfNeeded(itemName)
    if not ClubAllowedDrink(itemName) then return end
    if not itemName or itemName == "" then return end
    if RegisteredDrinkItems[itemName] then return end
    RegisterUsableItem(itemName, function(source, item)
        local metadata = Config.FrameworkSettings.usableItemMetadata(item, item)
        local flavors = metadata and metadata.flavors or nil
        local alcoholPct = metadata and metadata.alcoholPct or nil

        -- Fallback: look up flavors and alcohol % from club menus if metadata doesn't have them
        if not flavors or not alcoholPct or alcoholPct == 0 then
            for _, club in pairs(Clubs) do
                if club.drink_menu then
                    for _, entry in pairs(club.drink_menu) do
                        if entry.item == itemName then
                            if not flavors then flavors = GetValidFlavors(entry) end
                            if not alcoholPct or alcoholPct == 0 then alcoholPct = entry.alcohol or 0 end
                            break
                        end
                    end
                end
                if flavors and alcoholPct and alcoholPct > 0 then break end
            end
        end

        alcoholPct = alcoholPct or 0
        Inventory.RemoveItem(source, itemName, 1)
        TriggerClientEvent("pickle_clubs:useDrinkItem", source, itemName, flavors, alcoholPct)
    end)
    RegisteredDrinkItems[itemName] = true
end

RegisterNetEvent("pickle_clubs:submitDrink", function(stationId, orderId, flavorWeights)
    local source = source
    if not ClubStation(source,stationId,'interaction') or not ClubWeights(flavorWeights) then return end
    local controller=StationControllers[stationId].interaction
    if GetGameTimer()<controller.craftReady then return end
    local stationData = StationData[stationId]
    if not stationData then
        TriggerClientEvent("pickle_clubs:drinkSubmissionResult", source, false, "Station not found")
        return
    end
    
    -- Check if order exists and is first in queue (current order)
    if #stationData.orderQueue == 0 or stationData.orderQueue[1].id ~= orderId then
        TriggerClientEvent("pickle_clubs:drinkSubmissionResult", source, false, "This is not the current order")
        return
    end
    
    local order = stationData.orderQueue[1]
    if order.busy then return end
    local isValid, message = ValidateDrink(stationId, orderId, flavorWeights)
    
    if isValid then
        order.busy=true
        controller.craftReady=GetGameTimer()+5000
        if order.isPlayerOrder and order.playerSource then
            -- Player order: give drink item to ordering player
            local targetSource = order.playerSource
            if GetPlayerPing(targetSource) > 0 and order.playerIdentity==GetIdentifier(targetSource) then
                local itemName = order.item
                if itemName and itemName ~= "" then
                    local flavorsConfig = Config.Bartender.flavors
                    local flavorLabels = {}
                    for _, key in ipairs(order.flavors) do
                        local f = flavorsConfig[key]
                        if f then flavorLabels[#flavorLabels + 1] = string.lower(f.label) end
                    end
                    local description
                    if #flavorLabels == 1 then
                        description = ("A %s drink."):format(flavorLabels[1])
                    elseif #flavorLabels > 1 then
                        table.sort(flavorLabels)
                        description = ("A %s mixture."):format(table.concat(flavorLabels, "-"))
                    else
                        description = "A bar drink."
                    end
                    local alcoholPct = order.alcoholPct
                    if alcoholPct >= 20 then
                        description = description .. " Strong."
                    elseif alcoholPct >= 10 then
                        description = description .. " (Medium.)"
                    elseif alcoholPct > 0 then
                        description = description .. " (Light.)"
                    end
                    local metadata = { flavors = order.flavors, alcoholPct = alcoholPct, description = description }
                    RegisterDrinkItemIfNeeded(itemName)
                    if not Inventory.CanCarryItem or Inventory.CanCarryItem(targetSource, itemName, 1) then
                        if order.price>0 and RemoveMoney(targetSource,order.price,'money')~=true then order.busy=nil; return end
                        if Inventory.AddItem(targetSource,itemName,1,metadata)~=true then
                            if order.price>0 then AddMoney(targetSource,order.price,'money') end
                            order.busy=nil; return
                        end
                        PaySocietyCut(stationId,order.price)
                        ShowNotification(targetSource, "Your drink is ready!")
                    else
                        order.busy=nil
                        ShowNotification(targetSource, "Your drink is ready but you cannot carry it")
                        return
                    end
                end
            end
            ExpireOrder(stationId, orderId, true)
            TriggerClientEvent("pickle_clubs:drinkSubmissionResult", source, true, "Order fulfilled", nil)
        else
            -- NPC order: pay bartender (minus society cut)
            local orderPayment = Config.Bartender.orderPayment
            local bartenderShare = PaySocietyCut(stationId, orderPayment)
            AddMoney(source, bartenderShare, "money")
            local feedbackMessages = Config.Bartender.orderConversations.correct
            local feedback = feedbackMessages[math.random(1, #feedbackMessages)]
            ExpireOrder(stationId, orderId)
            TriggerClientEvent("pickle_clubs:drinkSubmissionResult", source, true, feedback, bartenderShare)
        end
    else
        ShowNotification(source, message)
        local feedbackMessages = Config.Bartender.orderConversations.incorrect
        local feedback = feedbackMessages[math.random(1, #feedbackMessages)]
        TriggerClientEvent("pickle_clubs:drinkSubmissionResult", source, false, feedback)
    end
end)

RegisterNetEvent("pickle_clubs:orderCompleted", function(stationId, orderId)
    -- Legacy client completion cannot mutate server order ownership.
end)

-- Build list of drinks for Place Order UI: { drinkKey, name, price, flavors, alcoholPct, item }
lib.callback.register("pickle_clubs:getClubDrinkMenu", function(source, stationId)
    local menu = GetClubDrinkMenuForStation(stationId)
    if not menu or type(menu) ~= "table" then return {} end
    local list = {}
    for drinkKey, entry in pairs(menu) do
        if type(entry) == "table" and type(entry.name) == "string" and entry.name ~= ""
            and DrinkHasValidFlavors(entry) then
            list[#list + 1] = {
                drinkKey = drinkKey,
                name = entry.name,
                price = entry.price,
                flavors = GetValidFlavors(entry),
                alcoholPct = entry.alcohol,
                item = entry.item,
            }
        end
    end
    table.sort(list, function(a, b) return (a.name or "") < (b.name or "") end)
    return list
end)

lib.callback.register("pickle_clubs:canPlacePlayerOrder", function(source, stationId)
    if not GetStation(stationId) then
        return false, "Station not found"
    end
    if Config.Bartender.requirePlayerBartender and not IsStationControlled(stationId, "interaction") then
        return false, "A bartender must be present to take your order"
    end
    -- Allow ordering even without a bartender (self-service)
    if IsStationControlled(stationId, "interaction") then
        local stationData = StationData[stationId]
        if stationData and #stationData.orderQueue >= Config.Bartender.maxActiveOrders then
            return false, "Too many orders, try again later"
        end
    end
    return true
end)

RegisterNetEvent("pickle_clubs:placePlayerOrder", function(stationId, drinkKey)
    local source = source
    if not GetStation(stationId) then
        ShowNotification(source, "Station not found")
        return
    end
    if Config.Bartender.requirePlayerBartender and not IsStationControlled(stationId, "interaction") then
        ShowNotification(source, "A bartender must be present to take your order")
        return
    end
    local menu = GetClubDrinkMenuForStation(stationId)
    if not menu or not drinkKey or type(menu[drinkKey]) ~= "table" then
        ShowNotification(source, "Invalid drink")
        return
    end
    local menuEntry = menu[drinkKey]
    if not DrinkHasValidFlavors(menuEntry) then
        ShowNotification(source, "Drink is unavailable")
        return
    end
    local requiredFlavorKeys = GetValidFlavors(menuEntry)
    local drinkName = menuEntry.name
    local price = menuEntry.price
    local alcoholPct = menuEntry.alcohol
    local itemName = menuEntry.item
    if not ClubAllowedDrink(itemName) then return end

    if not ClubStation(source,stationId) or not ClubFinite(price,0,100000) or price%1~=0 then return end
    -- If a bartender is active, queue the order for them to make
    if IsStationControlled(stationId, "interaction") then
        local stationData = StationData[stationId]
        if not stationData then
            ShowNotification(source, "Station not ready")
            return
        end
        if #stationData.orderQueue >= Config.Bartender.maxActiveOrders then
            ShowNotification(source, "Too many orders, try again later")
            return
        end
        local orderId = GetGameTimer() .. "_" .. math.random(1000, 9999)
        local timerDuration = Config.Bartender.playerOrderExpireSeconds or Config.Bartender.orderTimerDuration
        local order = {
            id = orderId,
            drinkKey = drinkKey,
            drinkName = drinkName,
            requiredFlavorKeys = requiredFlavorKeys,
            flavors = requiredFlavorKeys,
            alcoholPct = alcoholPct,
            item = itemName,
            timer = timerDuration,
            createdAt = GetGameTimer(),
            stationId = stationId,
            isPlayerOrder = true,
            playerSource = source,
            playerIdentity=GetIdentifier(source),
            expiresAt=os.time()+300,
            price = price or 0,
        }
        table.insert(stationData.orderQueue, order)
        UpdateCurrentOrderDisplay(stationId)
        ShowNotification(source, "Order placed: " .. drinkName)
    else
        -- Self-service: give the drink item directly
        if itemName and itemName ~= "" then
            local flavorsConfig = Config.Bartender.flavors
            local flavorLabels = {}
            for _, key in ipairs(requiredFlavorKeys) do
                local f = flavorsConfig[key]
                if f then flavorLabels[#flavorLabels + 1] = string.lower(f.label) end
            end
            local description
            if #flavorLabels == 1 then
                description = ("A %s drink."):format(flavorLabels[1])
            elseif #flavorLabels > 1 then
                table.sort(flavorLabels)
                description = ("A %s mixture."):format(table.concat(flavorLabels, "-"))
            else
                description = "A bar drink."
            end
            if alcoholPct and alcoholPct >= 20 then
                description = description .. " Strong."
            elseif alcoholPct and alcoholPct >= 10 then
                description = description .. " (Medium.)"
            elseif alcoholPct and alcoholPct > 0 then
                description = description .. " (Light.)"
            end
            local metadata = { flavors = requiredFlavorKeys, alcoholPct = alcoholPct or 0, description = description }
            RegisterDrinkItemIfNeeded(itemName)
            if not Inventory.CanCarryItem or Inventory.CanCarryItem(source, itemName, 1) then
                if price>0 and RemoveMoney(source,price,'money')~=true then return end
                if Inventory.AddItem(source,itemName,1,metadata)~=true then
                    if price>0 then AddMoney(source,price,'money') end
                    ShowNotification(source,'Drink delivery failed'); return
                end
                PaySocietyCut(stationId,price)
                ShowNotification(source, "Here's your " .. drinkName)
            else
                ShowNotification(source, "You cannot carry this item")
                -- Refund
                if price and price > 0 then
                    -- Payment is taken only at delivery.
                end
            end
        else
            ShowNotification(source, "Drink has no associated item")
            if price and price > 0 then
                -- Payment is taken only at delivery.
            end
        end
    end
end)

-- Track equipped drinks for syncing
local EquippedDrinksServer = {} -- source -> {coords, flavorWeights, color, progress, lastUpdate}

-- Match submitted flavorWeights against the club drink menu; returns the best matching entry or nil
local function MatchDrinkToMenu(stationId, flavorWeights)
    local menu = GetClubDrinkMenuForStation(stationId)
    if not menu or type(menu) ~= "table" then return nil end

    local alcoholKey = (Config.Bartender.alcoholBottle and Config.Bartender.alcoholBottle.key) or "_alcohol"
    local alcoholWeight = flavorWeights[alcoholKey] or 0
    local submittedAlcoholPct = math.floor(alcoholWeight * 100 + 0.5)
    local tolerance = Config.Bartender.alcoholTolerance or 10

    -- Collect taste flavors from submitted drink
    local tasteWeight = 0
    local submittedTaste = {}
    for key, weight in pairs(flavorWeights) do
        if key ~= alcoholKey and weight > 0.01 then
            submittedTaste[key] = weight
            tasteWeight = tasteWeight + weight
        end
    end
    if tasteWeight < 0.3 then return nil end

    -- Sort submitted taste flavors by weight descending
    local sortedTaste = {}
    for key, weight in pairs(submittedTaste) do
        sortedTaste[#sortedTaste + 1] = { key = key, weight = weight }
    end
    table.sort(sortedTaste, function(a, b) return a.weight > b.weight end)

    for _, entry in pairs(menu) do
        if type(entry) == "table" and DrinkHasValidFlavors(entry)
            and type(entry.item) == "string" and entry.item ~= "" then
            -- Check alcohol tolerance
            local entryAlcohol = entry.alcohol or 0
            if math.abs(submittedAlcoholPct - entryAlcohol) <= tolerance then
                -- Check all required flavors are present
                local requiredFlavors = GetValidFlavors(entry)
                local allPresent = true
                local requiredWeight = 0
                for _, flavorKey in ipairs(requiredFlavors) do
                    local w = submittedTaste[flavorKey] or 0
                    if w < 0.01 then allPresent = false; break end
                    requiredWeight = requiredWeight + w
                end
                if allPresent then
                    local threshold = #requiredFlavors == 1 and 0.85 or 0.70
                    if (requiredWeight / tasteWeight) >= threshold then
                        return entry
                    end
                end
            end
        end
    end
    return nil
end

RegisterNetEvent("pickle_clubs:giveDrinkItem", function(stationId, flavorWeights)
    local source = source
    if not ClubStation(source,stationId,'interaction') or not ClubWeights(flavorWeights) then return end
    local controller=StationControllers[stationId].interaction
    if GetGameTimer()<controller.craftReady then return end
    controller.craftReady=GetGameTimer()+5000

    local entry = MatchDrinkToMenu(stationId, flavorWeights)
    if not entry then
        ShowNotification(source, "This drink doesn't match anything on the menu")
        return
    end

    local itemName = entry.item
    if not ClubAllowedDrink(itemName) then return end
    if Inventory.CanCarryItem and not Inventory.CanCarryItem(source, itemName, 1) then
        ShowNotification(source, "You cannot carry this item")
        return
    end

    local flavorsConfig = Config.Bartender.flavors
    local flavorLabels = {}
    for _, key in ipairs(entry.flavors or {}) do
        local f = flavorsConfig[key]
        if f then flavorLabels[#flavorLabels + 1] = string.lower(f.label) end
    end
    local description
    if #flavorLabels == 1 then
        description = ("A %s drink."):format(flavorLabels[1])
    elseif #flavorLabels > 1 then
        table.sort(flavorLabels)
        description = ("A %s mixture."):format(table.concat(flavorLabels, "-"))
    else
        description = "A bar drink."
    end
    local alcoholPct = entry.alcohol or 0
    if alcoholPct >= 20 then
        description = description .. " Strong."
    elseif alcoholPct >= 10 then
        description = description .. " (Medium.)"
    elseif alcoholPct > 0 then
        description = description .. " (Light.)"
    end

    local metadata = { flavors = GetValidFlavors(entry), alcoholPct = alcoholPct, description = description }
    RegisterDrinkItemIfNeeded(itemName)
    if Inventory.AddItem(source,itemName,1,metadata)~=true then return end
    ShowNotification(source, "You received a " .. (entry.name or itemName))
end)

-- Callback so client only proceeds when server grants control (prevents race where client starts interaction despite denial)
lib.callback.register("pickle_clubs:requestStationControl", function(source, stationId, controlType)
    -- Check job access for bartending (interaction control)
    if controlType == "interaction" then
        local clubId = GetClubIdFromStationId(stationId)
        if clubId then
            local club = Clubs[clubId]
            if club and club.jobs and #club.jobs > 0 then
                local jobName = GetPlayerJobName(source)
                local hasAccess = false
                if jobName then
                    for _, j in ipairs(club.jobs) do
                        if j.name == jobName then
                            hasAccess = true
                            break
                        end
                    end
                end
                if not hasAccess then
                    return false, "You don't have the required job to bartend here"
                end
            end
        end
    end
    local success, message = SetStationController(stationId, source, controlType)
    return success, (not success and (message or "Station is already in use")) or nil
end)

RegisterNetEvent("pickle_clubs:setStationController", function(stationId, controlType)
    local src = source
    local success, message = SetStationController(stationId, src, controlType)
    if not success then
        TriggerClientEvent("pickle_clubs:stationControlDenied", src, message)
        return
    end
end)

RegisterNetEvent("pickle_clubs:clearStationController", function(stationId, controlType)
    if not ClubStation(source,stationId,controlType) then return end
    -- Cancel unpaid player orders when the bartender leaves
    if controlType == "interaction" then
        local stationData = StationData[stationId]
        if stationData and stationData.orderQueue then
            local refunded = {}
            for i = #stationData.orderQueue, 1, -1 do
                local order = stationData.orderQueue[i]
                if order.isPlayerOrder and order.playerSource then
                    local price = order.price or 0
                    if price > 0 and GetPlayerPing(order.playerSource) > 0 then
                        if order.paid then AddMoney(order.playerSource, price, "money") end
                    end
                    if GetPlayerPing(order.playerSource) > 0 then
                        ShowNotification(order.playerSource, "Your order has been cancelled")
                    end
                    table.insert(refunded, i)
                end
            end
            for _, idx in ipairs(refunded) do
                table.remove(stationData.orderQueue, idx)
            end
        end
    end
    ClearStationController(stationId, controlType)
end)

RegisterNetEvent("pickle_clubs:requestStationControllerStates", function()
    local src = source
    for stationId, _ in pairs(StationRegistry) do
        if IsStationControlled(stationId, "interaction") then
            TriggerClientEvent("pickle_clubs:hideStationRegister", src, stationId)
        else
            TriggerClientEvent("pickle_clubs:showStationRegister", src, stationId)
        end
    end
end)

RegisterNetEvent("pickle_clubs:requestStations", function()
    local src = source
    TriggerClientEvent("pickle_clubs:syncStations", src, StationRegistry)
end)

exports("GetStation", GetStation)
exports("IsStationControlled", IsStationControlled)
exports("SetStationController", SetStationController)
exports("ClearStationController", ClearStationController)

CreateThread(function()
    RegisterEntityType("bartender", {
        label = "Bartender",
        description = "Bartending station entity for club gameplay.",
        onStart = function(id, entityId)
            RegisterBartenderStation(id, entityId)
        end,
        onRender = function(id, entityId, source)
            local stationId = BuildStationId(id, entityId)
            local station = StationRegistry[stationId]
            if station then
                TriggerClientEvent("pickle_clubs:syncStations", source, {
                    [stationId] = station
                }, true)
            end
        end,
        onUnrender = function(id, entityId, source)
            local stationId = BuildStationId(id, entityId)
            TriggerClientEvent("pickle_clubs:removeStation", source, stationId)
        end,
        onStop = function(id, entityId)
            UnregisterBartenderStation(id, entityId)
        end,
    })
end)

-- Register club drink items as usable after clubs load
CreateThread(function()
    while not ClubsLoaded do Wait(100) end
    while true do
    local seen = {}
    for _, club in pairs(Clubs or {}) do
        for _, entry in pairs(club.drink_menu or {}) do
            if type(entry) == "table" and type(entry.item) == "string" and entry.item ~= "" and not seen[entry.item] and DrinkHasValidFlavors(entry) then
                seen[entry.item] = true
                RegisterDrinkItemIfNeeded(entry.item)
            end
        end
    end
    Wait(5000)
    end
end)

-- Sync equipped drink to nearby players
RegisterNetEvent("pickle_clubs:syncEquippedDrink", function(coords, flavorWeights, color, progress)
    local source = source
    if not ClubWeights(flavorWeights) or type(color)~='table' or not ClubFinite(progress,0,1) then return end
    for _,k in ipairs({1,2,3}) do if not ClubFinite(color[k],0,255) then return end end
    coords=GetEntityCoords(GetPlayerPed(source))
    -- Update server-side tracking
    EquippedDrinksServer[source] = {
        coords = coords,
        flavorWeights = flavorWeights,
        color = color,
        progress = progress,
        lastUpdate = GetGameTimer()
    }

    -- Sync to all nearby players (client will filter by distance)
    TriggerClientEvent("pickle_clubs:syncEquippedDrinkUpdate", -1, source, coords, flavorWeights, color, progress)
end)

-- Periodic sync thread for equipped drinks
CreateThread(function()
    while true do
        Wait(1000) -- Update every second
        local currentTime = GetGameTimer()
        
        for sourceId, drinkData in pairs(EquippedDrinksServer) do
            -- Remove stale entries (older than 5 seconds)
            if currentTime - (drinkData.lastUpdate or 0) > 5000 then
                EquippedDrinksServer[sourceId] = nil
                TriggerClientEvent("pickle_clubs:removeEquippedDrink", -1, sourceId)
            else
                -- Sync to all players periodically (client will filter by distance)
                TriggerClientEvent("pickle_clubs:syncEquippedDrinkUpdate", -1, sourceId, drinkData.coords, drinkData.flavorWeights, drinkData.color, drinkData.progress)
            end
        end
    end
end)

-- Handle player removing equipped drink
RegisterNetEvent("pickle_clubs:removeEquippedDrinkSync", function()
    local source = source
    if EquippedDrinksServer[source] then
        EquippedDrinksServer[source] = nil
        TriggerClientEvent("pickle_clubs:removeEquippedDrink", -1, source)
    end
end)

-- Handle scaled alcohol when player actually drinks (holds E); amount is proportion consumed 0-1
RegisterNetEvent("pickle_clubs:drinkConsumed", function(amount, alcoholPct)
    local source = source
    if not amount or amount <= 0 then return end
    if amount > 1.0 then amount = 1.0 end
    alcoholPct = tonumber(alcoholPct)
    if not alcoholPct or alcoholPct < 0 then alcoholPct = 0 end
    if alcoholPct > 100 then alcoholPct = 100 end
    if AddAlcohol then
        -- Send raw alcohol contribution: amount consumed * alcohol fraction
        -- e.g. full drink at 5% = 1.0 * 0.05 = 0.05
        local alcoholValue = amount * (alcoholPct / 100)
        if alcoholValue > 0 then
            AddAlcohol(source, alcoholValue)
        end
    end
end)

-- Handle removing drink item from inventory when finished
RegisterNetEvent("pickle_clubs:removeDrinkItem", function(itemName)
    local source = source
    Inventory.RemoveItem(source, itemName, 1)
end)

-- Cleanup on player disconnect
AddEventHandler("playerDropped", function()
    local source = source
    if EquippedDrinksServer[source] then
        EquippedDrinksServer[source] = nil
        TriggerClientEvent("pickle_clubs:removeEquippedDrink", -1, source)
    end
    for stationId, controllers in pairs(StationControllers) do
        for controlType, controller in pairs(controllers) do
            if controller and controller.source == source then
                ClearStationController(stationId, controlType)
            end
        end
    end
end)

-- Cleanup all station data on resource stop
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        -- Stop all active services and cleanup
        for stationId, stationData in pairs(StationData) do
            if stationData.serviceActive then
                StopBartenderService(stationId)
            end
        end
        
        -- Clear all station data
        StationData = {}
        StationRegistry = {}
        StationControllers = {}
        
        -- Clear equipped drinks
        EquippedDrinksServer = {}
        TriggerClientEvent("pickle_clubs:removeEquippedDrink", -1, -1) -- Remove all (playerId -1 means all)
    end
end)
