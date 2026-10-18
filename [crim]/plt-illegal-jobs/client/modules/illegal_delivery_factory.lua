return function(JOB_KEY)
    local Utils = require 'client.modules.utils'
    local Target = require 'client.modules.target'
    local config = lib.load(('jobs.%s.config'):format(JOB_KEY))
    if not config then
        lib.print.error(('[delivery] missing config for %s'):format(JOB_KEY))
        return
    end

    local job = {}
    local state = {
        locationPoint = nil,
        locationBlip = nil,
        vehicleNetId = nil,
        vehicleBlip = nil,
        deliveryPeds = {},
        deliveryPoints = {},
        deliveryBlips = {},
        pickupZoneKey = nil,
        pickupPoint = nil,
        delivered = {},
        waypointThread = false,
        dropList = {},
    }

    local function getProduct()
        return client.currentJob and client.currentJob.game and client.currentJob.game.product or nil
    end

    local function getSpawnCoords()
        local product = getProduct()
        if product and product.pickup then
            return product.pickup
        end
        local location = client.currentJob and client.currentJob.game and client.currentJob.game.location
        return location and location.vehicle_location or nil
    end

    local function createPickupPoint()
        local spawnCoords = getSpawnCoords()
        if not spawnCoords then
            Utils.notify('No pickup location configured.', 'error')
            return false
        end

        if state.pickupPoint then
            state.pickupPoint:remove()
            state.pickupPoint = nil
        end

        if client.lobby.owner == cache.serverId then
            state.pickupPoint = lib.points.new({
                coords = vector3(spawnCoords.x, spawnCoords.y, spawnCoords.z),
                distance = 80.0,
                onEnter = function(self)
                    local response = lib.callback.await(
                        _e(('server:jobs:%s:onVehicleSpawn'):format(JOB_KEY)),
                        false, client.lobby.id
                    )
                    if not response then
                        Utils.notify('Delivery van failed to spawn. Try again.', 'error')
                        return
                    end
                    self:remove()
                    state.pickupPoint = nil
                end,
            })
        end

        local product = getProduct()
        local blipOptions = shared.deepCopy(config.blips.location or {})
        blipOptions.text = ('Pick up %s'):format(product and product.label or 'Shipment')
        Utils.setStepWaypoint(spawnCoords, blipOptions)
        return true
    end

    local function collectShipment()
        local product = getProduct()
        local res = lib.callback.await(
            _e(('server:jobs:%s:pickupShipment'):format(JOB_KEY)),
            false, client.lobby.id
        )
        if not res then return end
        if res.error then
            Utils.notify(res.error, 'error')
            return
        end
        Utils.notify(('Received %sx %s'):format(res.count or 0, product and product.label or 'items'), 'success')
    end

    local function createPickupZone()
        local product = getProduct()
        local spawnCoords = getSpawnCoords()
        if not product or not spawnCoords then return false end

        local zoneCoords = product.load_zone or spawnCoords
        local zoneKey = ('%s.pickup'):format(JOB_KEY)

        if state.pickupZoneKey then
            Target.removeZone(state.pickupZoneKey)
        end
        state.pickupZoneKey = zoneKey

        -- Target.addBoxZone also registers the built-in [E] prompt fallback
        -- when ox_target/qb-target aren't running (see client/modules/target.lua).
        Target.addBoxZone(zoneKey, {
            coords = vector3(zoneCoords.x, zoneCoords.y, zoneCoords.z),
            name = zoneKey,
            size = vector3(4.0, 4.0, 3.0),
            options = { {
                label = ('Collect %s'):format(product.label or 'Shipment'),
                icon = 'fa-solid fa-box',
                distance = 2.0,
                canInteract = function()
                    return client.currentJob and not client.currentJob.steps[2].done
                end,
                onSelect = collectShipment,
            } },
        })

        local blipOptions = shared.deepCopy(config.blips.location or {})
        blipOptions.text = ('Load %s'):format(product.label or 'Shipment')
        Utils.setStepWaypoint(zoneCoords, blipOptions)
        return true
    end

    local function createDeliveryPed(coords)
        local models = {
            'a_m_m_farmer_01', 'a_f_y_business_02', 'a_m_m_hasjew_01',
            'g_m_y_mexgoon_03', 'a_m_y_stbla_02', 'a_f_m_eastsa_02',
        }
        local model = joaat(models[math.random(#models)])
        lib.requestModel(model)
        local spawnZ = coords.z
        local ped = CreatePed(4, model, coords.x, coords.y, spawnZ, coords.w or 0.0, false, true)
        if not DoesEntityExist(ped) then
            SetModelAsNoLongerNeeded(model)
            return nil
        end
        SetPedDefaultComponentVariation(ped)
        SetPedDiesWhenInjured(ped, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetModelAsNoLongerNeeded(model)
        return ped
    end

    local function createDeliveryPoints()
        local product = getProduct()
        local drop_off_points = client.currentJob.game.drop_off_points or {}
        local target = client.currentJob.steps[3].progress.target or 0

        state.delivered = {}
        state.dropList = {}

        for index = 1, target do
            local entry = drop_off_points[index]
            local coords = entry and (entry.coords or entry) or nil
            if coords then
                state.dropList[index] = { coords = coords, index = index }
                state.deliveryPeds[index] = createDeliveryPed(coords)
                state.deliveryBlips[index] = Utils.addBlip(coords, config.blips.delivery, true)
                state.deliveryPoints[index] = lib.points.new({
                    coords = coords,
                    distance = 5.0,
                    onEnter = function()
                        if not state.delivered[index] then
                            Utils.showTextUI('[E] ' .. locale('deliver'))
                        end
                    end,
                    onExit = function()
                        Utils.hideTextUI()
                    end,
                    nearby = function(self)
                        if state.delivered[index] then return end
                        if IsControlJustPressed(0, 38) then
                            local Dialogue = require 'client.modules.dialogue'
                            local buyer = state.deliveryPeds[index]
                            if not Dialogue.confirm(
                                (buyer and DoesEntityExist(buyer)) and buyer or nil,
                                'You got my package?',
                                'Hand it over',
                                'Nevermind'
                            ) then
                                return
                            end
                            local res = lib.callback.await(
                                _e(('server:jobs:%s:onDelivered'):format(JOB_KEY)),
                                false, client.lobby.id, index
                            )
                            if not res then return end
                            if res.error then
                                Utils.notify(res.error, 'error')
                                return
                            end
                            if res.policeAlert then
                                Utils.triggerPoliceAlert(JOB_KEY, locale('illegal_delivery'))
                            end
                            state.delivered[index] = true
                            Utils.hideTextUI()
                            self:remove()
                            state.deliveryPoints[index] = nil
                            if state.deliveryBlips[index] then
                                RemoveBlip(state.deliveryBlips[index])
                                state.deliveryBlips[index] = nil
                            end
                            local buyerPed = state.deliveryPeds[index]
                            state.deliveryPeds[index] = nil
                            if buyerPed and DoesEntityExist(buyerPed) then
                                Utils.dismissPedWalkAway(buyerPed, { speed = 1.15 })
                            end
                        end
                    end,
                })
            end
        end

        local blipOptions = shared.deepCopy(config.blips.delivery or {})
        blipOptions.text = ('Deliver %s'):format(product and product.label or 'Shipment')
        local first = state.dropList[1] and state.dropList[1].coords
        if first then
            Utils.setStepWaypoint(first, blipOptions)
            Utils.setNearestWaypoint(state.dropList, function(p) return state.delivered[p.index] == true end)
        end
    end

    local function createFinishPoint()
        local spawnCoords = getSpawnCoords()
        if not spawnCoords then return end
        local finishPrompt = false

        state.locationPoint = lib.points.new({
            coords = vector3(spawnCoords.x, spawnCoords.y, spawnCoords.z),
            distance = 12.0,
            onEnter = function()
                if cache.vehicle and cache.seat == -1 then
                    finishPrompt = true
                    Utils.showTextUI(('[E] %s'):format(locale('illegal_delivery.park_vehicle')))
                end
            end,
            onExit = function()
                finishPrompt = false
                Utils.hideTextUI()
            end,
            nearby = function(self)
                if cache.vehicle and cache.seat == -1 and IsControlJustPressed(0, 38) then
                    Utils.hideTextUI()
                    TaskLeaveVehicle(cache.ped, cache.vehicle, 0)
                    while cache.vehicle do Wait(0) end
                    Wait(1000)
                    lib.callback.await(_e('server:jobs:onStepDone'), false, client.lobby.id, 4)
                    self:remove()
                    state.locationPoint = nil
                elseif finishPrompt and not cache.vehicle then
                    finishPrompt = false
                    Utils.hideTextUI()
                end
            end,
        })
        state.locationBlip = Utils.addBlip(spawnCoords, config.blips.location, true)
    end

    function job.cleanup()
        if state.locationPoint then state.locationPoint:remove() state.locationPoint = nil end
        if state.locationBlip then RemoveBlip(state.locationBlip) state.locationBlip = nil end
        if state.vehicleBlip then RemoveBlip(state.vehicleBlip) state.vehicleBlip = nil end
        if state.pickupPoint then state.pickupPoint:remove() state.pickupPoint = nil end
        if state.pickupZoneKey then Target.removeZone(state.pickupZoneKey) state.pickupZoneKey = nil end
        for _, point in pairs(state.deliveryPoints) do if point then point:remove() end end
        for _, ped in pairs(state.deliveryPeds) do if DoesEntityExist(ped) then DeleteEntity(ped) end end
        for _, blip in pairs(state.deliveryBlips) do if blip then RemoveBlip(blip) end end
        if state.vehicleNetId and NetworkDoesEntityExistWithNetworkId(state.vehicleNetId) then
            local veh = NetToVeh(state.vehicleNetId)
            if DoesEntityExist(veh) then Target.removeLocalEntity(veh) end
        end
        state.deliveryPoints = {}
        state.deliveryPeds = {}
        state.deliveryBlips = {}
        state.vehicleNetId = nil
        state.delivered = {}
        state.waypointThread = false
        Utils.hideTextUI()
    end

    function job.start()
        return job.onStepStart(1) == true
    end

    function job.stop()
        job.cleanup()
        return true
    end

    function job.onStepStart(stepIndex)
        if stepIndex <= 1 then
            return createPickupPoint() == true
        elseif stepIndex == 2 then
            return createPickupZone() == true
        elseif stepIndex == 3 then
            createDeliveryPoints()
            if not state.waypointThread then
                state.waypointThread = true
                CreateThread(function()
                    while client.currentJob and state.waypointThread do
                        if GetFirstBlipInfoId(8) == 0 then
                            Utils.setNearestWaypoint(state.dropList, function(p)
                                return state.delivered[p.index] == true
                            end)
                        end
                        Wait(2000)
                    end
                end)
            end
            return true
        elseif stepIndex == 4 then
            createFinishPoint()
            return true
        end

        if client.lobby.owner == cache.serverId then
            lib.callback.await(_e('server:jobs:finishJob'), false, client.lobby.id)
        end
        return false
    end

    function job.onStepDone(stepIndex)
        if stepIndex == 1 then
            if state.locationBlip then RemoveBlip(state.locationBlip) state.locationBlip = nil end
            if state.locationPoint then state.locationPoint:remove() state.locationPoint = nil end
        elseif stepIndex == 2 then
            if state.pickupZoneKey then Target.removeZone(state.pickupZoneKey) state.pickupZoneKey = nil end
            if state.pickupPoint then state.pickupPoint:remove() state.pickupPoint = nil end
            Utils.hideTextUI()
        elseif stepIndex == 3 then
            state.waypointThread = false
            for _, point in pairs(state.deliveryPoints) do if point then point:remove() end end
            for _, ped in pairs(state.deliveryPeds) do if DoesEntityExist(ped) then DeleteEntity(ped) end end
            for _, blip in pairs(state.deliveryBlips) do if blip then RemoveBlip(blip) end end
            state.deliveryPoints = {}
            state.deliveryPeds = {}
            state.deliveryBlips = {}
            Utils.hideTextUI()
        elseif stepIndex == 4 then
            if state.locationPoint then state.locationPoint:remove() state.locationPoint = nil end
            if state.locationBlip then RemoveBlip(state.locationBlip) state.locationBlip = nil end
            if state.vehicleBlip then RemoveBlip(state.vehicleBlip) state.vehicleBlip = nil end
            Utils.hideTextUI()
        end
        return job.onStepStart(stepIndex + 1)
    end

    RegisterNetEvent(_e(('client:jobs:%s:onVehicleSpawned'):format(JOB_KEY)), function(netId)
        CreateThread(function()
            state.vehicleNetId = netId
            local vehicle = lib.waitFor(function()
                if NetworkDoesEntityExistWithNetworkId(netId) then
                    local veh = NetToVeh(netId)
                    if DoesEntityExist(veh) then return veh end
                end
            end, false, false)
            if not vehicle then return end

            SetVehicleDoorsLocked(vehicle, 2)
            SetVehicleDoorsLockedForAllPlayers(vehicle, true)
            if state.vehicleBlip then RemoveBlip(state.vehicleBlip) end
            state.vehicleBlip = Utils.addBlip(vehicle, config.blips.vehicle)
            Utils.notify(locale('illegal_delivery.van_ready'), 'inform')

            Target.addLocalEntity(vehicle, { {
                label = locale('illegal_delivery.lockpick_van'),
                icon = 'fa-solid fa-lock-open',
                distance = 2.0,
                canInteract = function()
                    return client.currentJob ~= nil
                        and GetPedInVehicleSeat(vehicle, -1) == 0
                end,
                onSelect = function()
                    if not DoesEntityExist(vehicle) then return end

                    local success = Utils.playJobMinigame(JOB_KEY, 'unlockVehicle')
                    if not success then return end

                    success = Utils.progressJobBar(JOB_KEY, 'unlockVehicle', {
                        label = locale('progress'),
                        position = 'bottom',
                        anim = {
                            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                            clip = 'machinic_loop_mechandplayer',
                        },
                    })
                    if not success then return end

                    SetVehicleDoorsLocked(vehicle, 1)
                    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    Jobs.giveVehicleKey(GetVehicleNumberPlateText(vehicle), vehicle)
                    Target.removeLocalEntity(vehicle, true)
                    Utils.notify(locale('illegal_delivery.van_unlocked'), 'success')
                end,
            } }, true)
        end)
    end)

    RegisterNetEvent(_e(('client:jobs:%s:onDelivered'):format(JOB_KEY)), function(index)
        Utils.notify(locale('illegal_delivery.box_delivered'), 'success')
        state.delivered[index] = true
        local buyerPed = state.deliveryPeds[index]
        state.deliveryPeds[index] = nil
        if buyerPed and DoesEntityExist(buyerPed) then
            Utils.dismissPedWalkAway(buyerPed, { speed = 1.15 })
        end
        if state.deliveryPoints[index] then
            state.deliveryPoints[index]:remove()
            state.deliveryPoints[index] = nil
        end
        if state.deliveryBlips[index] then
            RemoveBlip(state.deliveryBlips[index])
            state.deliveryBlips[index] = nil
        end
        Utils.setNearestWaypoint(state.dropList, function(p) return state.delivered[p.index] == true end)
    end)

    Jobs.register(JOB_KEY, job)
end
