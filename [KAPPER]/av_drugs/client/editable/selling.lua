local sellConfig = nil
local isSelling = false
local drugOptions = {}
local currentVehicle = nil
local currentDrug = nil
local currentCoords = nil
local npcTarget = nil
local offering = false
local neededCops = 0

function setSellConfig(data) -- don't edit this
    if not data then return end
    dbug('setSellConfig()')
    sellConfig = data
end

CreateThread(function()
    while not loaded do Wait(100) end
    dbug("drugOptions()")
    if sellConfig and next(sellConfig) then
        for k, v in pairs(sellConfig) do
            drugOptions[#drugOptions+1] = {
                name = k,
                type = "client",
                event = "av_drugs:sell",
                icon = v['icon'],
                label = Lang['sell']..' '..v['label'],
                extraInfo = v,
                bones = "boot",
                items = k, -- ox_target
                item = k, -- qb-target
                canInteract = function(entity)
                    local allowed = canSell(k,v,entity)
                    dbug("allowed to sell?", allowed)
                    return allowed
                end,
            }
        end
        drugOptions[#drugOptions+1] = {
            name = "stop_selling",
            type = "client",
            event = "av_drugs:stop",
            icon = 'fas fa-ban',
            label = Lang['stop'],
            bones = "boot",
            canInteract = function(entity)
                return isSelling
            end,
        }
    end
    while not Config.Target do
        Config.Target = exports['av_laptop']:getTarget()
        Wait(50)
        print("Config.Target", Config.Target)
    end
    if Config.Target == "ox_target" then
        dbug('addGlobalVehicle()')
        exports[Config.Target]:addGlobalVehicle(drugOptions)
    else
        dbug('AddTargetBone()')
        exports[Config.Target]:AddTargetBone('boot', {
            options = drugOptions,
            distance = 2.5,
        })
    end
end)

RegisterNetEvent('av_drugs:sell', function(data) -- event used for some checks and start searching customers
    dbug('av_drugs:sell event...')
    local vehicle = data and data['entity'] or false
    local info = data and data['extraInfo'] or false
    currentDrug = data and data['name'] or false
    if not currentDrug then
        dbug("currentDrug is null (?)")
        return
    end
    if vehicle and DoesEntityExist(vehicle) then
        currentVehicle = vehicle
    end
    if not currentVehicle then
        dbug("currentVehicle is null (?)")
        return
    end
    if not info then
        dbug('no extraInfo found (?)')
        return
    end
    neededCops = info and info['minCops'] or 0
    dbug("needed cops - online cops", neededCops, onlineCops)
    if onlineCops >= neededCops then
        dbug("player can sell...")
        SetVehicleDoorOpen(currentVehicle,5,false,false)
        CreateThread(function()
            sellingLoop()
        end)
    else
        TriggerEvent('av_laptop:notification', Lang['selling_title'], Lang['need_cops'],'error')
    end
end)

RegisterNetEvent('av_drugs:offer', function(data) -- final event for selling
    if LocalPlayer.state.busy then return end
    LocalPlayer.state.busy = true
    Wait(math.random(5, 500)) -- Just a little delay for security purposes
    dbug("av_drugs:offer")
    local customer = data['entity']
    if not customer or not DoesEntityExist(customer) then
        dbug("customer doesn't exist anymore (?)")
        RemoveNPC()
        LocalPlayer.state.busy = false
        return
    end
    dispatchCheck()
    local declined = math.random(1,10)
    if declined == 3 then
        TriggerEvent('av_laptop:notification', Lang['selling_title'], Lang['customer_declined'], "error")
        dbug("Customer declined...")
        RemoveNPC()
        offering = false
        lib.timer(500, function()
            LocalPlayer.state.busy = false
        end, true)
        return
    end
    local hasItem = exports['av_laptop']:hasItem(currentDrug)
    if hasItem then
        dbug("player have needed item", currentDrug)
        offering = true
        local state = Entity(customer).state
        if state and not state.corners then
            dbug("Customer can buy...")
            state:set('corners', true, true) -- set Entity state corners = true
            TaskStandStill(customer, 5000.0)
            TaskSetBlockingOfNonTemporaryEvents(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            FreezeEntityPosition(customer, true)
            FreezeEntityPosition(cache.ped,true)
            local customer_pos = GetEntityCoords(customer)
            local player_pos = GetEntityCoords(cache.ped)
            SetEntityHeading(customer, GetHeadingFromVector_2d(customer_pos.x-player_pos.x,customer_pos.y-player_pos.y)+180)
            SetEntityHeading(cache.ped, GetHeadingFromVector_2d(customer_pos.x-player_pos.x,customer_pos.y-player_pos.y))
            lib.requestAnimDict('mp_common', 10000)
            TaskPlayAnim(cache.ped, "mp_common", "givetake2_a", 8.0, 8.0, 2000, 0, 1, 0,0,0)
            TaskPlayAnim(customer, "mp_common", "givetake2_a", 8.0, 8.0, 2000, 0, 1, 0,0,0)
            Wait(1000)
            lib.callback('av_drugs:sell',false, function()
                FreezeEntityPosition(customer, false)
                FreezeEntityPosition(cache.ped,false)
                RemoveNPC()
                offering = false
            end, currentDrug,currentZone)
        else
            TriggerEvent('av_laptop:notification', Lang['selling_title'], Lang['customer_declined'], "error")
            dbug("Customer already bought, RemoveNPC()...")
            RemoveNPC()
            offering = false
        end
    else
        TriggerEvent('av_laptop:notification',Lang['selling_title'], Lang['missing_drugs'], "error")
        cancelCorner()
    end
    lib.timer(500, function()
        LocalPlayer.state.busy = false
    end, true)
end)

RegisterNetEvent('av_drugs:stop', function(data)
    cancelCorner()
end)

function sellingLoop()
    dbug('sellingLoop started...')
    isSelling = true
    currentCoords = GetEntityCoords(cache.ped)
    while isSelling do
        local playerCoords = GetEntityCoords(cache.ped)
        if #(playerCoords - currentCoords) >= Config.SellingDistance then
            RemoveNPC()
            isSelling = false
            currentDrug = nil
            TriggerEvent('av_laptop:notification',Lang['title'],Lang['too_far'],"error")
        end
        if not npcTarget then
            Wait(Config.SellingCooldown)
            local peds = lib.getNearbyPeds(playerCoords, 50.0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            if peds and next(peds) then
                for i=1, #peds do
                    local npc = peds[i]['ped']
                    if not npcTarget then
                        if verifyNPC(npc) then
                            local count = 0
                            NetworkRequestControlOfEntity(npc)
                            while not NetworkHasControlOfEntity(npc) do
                                NetworkRequestControlOfEntity(npc)
                                Wait(10)
                                count += 1
                                if count > 100 then break end
                            end
                            if NetworkHasControlOfEntity(npc) and verifyNPC(npc) then
                                SetEntityAsMissionEntity(npc,true,true)
                                TaskGoToCoordAnyMeans(npc,playerCoords.x, playerCoords.y, playerCoords.z, 1.0, 0, 0, 786603, 0)
                                RegisterNPC(npc)
                                npcTarget = npc
                            end
                        end
                    end
                end
            end
        end
        if npcTarget then
            if DoesEntityExist(npcTarget) then
                local dist = #(playerCoords - GetEntityCoords(npcTarget))
                if dist > 70 then
                    RemoveNPC()
                end
            else
                RemoveNPC()
            end
        end
        Wait(5000)
    end
end

function canSell(item,data,entity) -- all checks are handled here, return true to allow player start selling or false
    if isSelling then return false end -- Player is already selling drugs
    if exports['av_laptop']:hasJob(Config.PoliceJobs) then return false end -- no cops allowed
    if IsEntityAVehicle(entity) and Config.BlacklistedClasses[GetVehicleClass(entity)] then -- using a blacklisted vehicle
        return false
    end
    local allowedZones = data and data['zones'] or "ALL"
    dbug("Current zone: ", currentZone)
    if allowedZones == "ALL" or allowedZones[currentZone] or allowedZones['ALL'] then
        return true
    end
    return false
end

function verifyNPC(entity) -- some checks for the npc
    if offering then return false end
    local model = GetEntityModel(entity)
    model = tonumber(model)
    if Config.BlacklistedPeds[model] then return false end
    if GetPedType(entity) == 28 then return false end
	if IsPedAPlayer(entity) then return false end
	if IsPedDeadOrDying(entity) then return false end
    if IsEntityDead(entity) then return false end
    if (GetVehiclePedIsIn(entity,false) ~= 0) then return false end
    if Entity(entity).state and Entity(entity).state.corners then return false end
	return IsPedOnFoot(entity)
end

function RegisterNPC(npc) -- register NPC for target system
    dbug("RegisterNPC()")
    if not DoesEntityExist(npc) then return end -- just in case npc got deleted
    local options = {
        name = "npcTarget",
        type = "client",
        event = "av_drugs:offer",
        icon = 'fas fa-user-secret',
        label = Lang['offer'],
        distance = 2.5,
        canInteract = function(entity)
            if IsPedInAnyVehicle(cache.ped, false) then return false end
            if offering then return false end
            if not IsEntityDead(entity) then
                return true
            end
            return false
        end,
    }
    if Config.Target == "ox_target" then
        exports[Config.Target]:addLocalEntity(npc, options)
    else
        exports[Config.Target]:AddTargetEntity(npc, {
            options = {options},
            distance = 2.5,
        })
    end
    dbug("NPC registered as target entity")
end

function RemoveNPC()
    if npcTarget and DoesEntityExist(npcTarget) then
        TaskSetBlockingOfNonTemporaryEvents(npcTarget, false)
        SetBlockingOfNonTemporaryEvents(npcTarget, false)
        ClearPedTasks(npcTarget)
        SetEntityAsNoLongerNeeded(npcTarget)
        if Config.Target == "ox_target" then
            exports[Config.Target]:removeLocalEntity(npcTarget, "npcTarget")
        else
            exports[Config.Target]:RemoveTargetEntity(npcTarget, Lang['offer'])
        end
    end
    npcTarget = nil
end

function cancelCorner()
    RemoveNPC()
    isSelling = false
    currentDrug = nil
    currentVehicle = nil
    offering = false
end

function refreshCops()
    if not isSelling then return end
    if neededCops and onlineCops < neededCops then
        cancelCorner()
        TriggerEvent('av_laptop:notification', Lang['selling_title'], Lang['need_cops'],'error')
    end
end

lib.onCache('vehicle', function(value)
    if value and isSelling then
        cancelCorner()
        TriggerEvent('av_laptop:notification', Lang['selling_title'], Lang['selling_stopped_vehicle'] or "You can't sell while in a vehicle, process has been cancelled", 'error')
    end
end)