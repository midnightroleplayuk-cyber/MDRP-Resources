--[[
  Shared illegal-delivery server factory.
  Call: require 'server.modules.illegal_delivery_factory'(JOB_KEY)
]]

return function(JOB_KEY)
    local Utils = require 'server.modules.utils'
    local LockManager = require 'server.modules.lockmanager'
    local Inventory = require 'server.modules.inventory'
    local config = lib.load(('jobs.%s.config'):format(JOB_KEY))
    if not config then
        lib.print.error(('[delivery] missing config for %s'):format(JOB_KEY))
        return
    end

    local job = {}
    local state = { busyLocations = {} }
    local vehicleModel = (config.game and config.game.vehicle_model) or 'burrito3'

    local function deleteLobbyVan(netId)
        if not netId or type(netId) ~= 'number' then return end
        local entity = NetworkGetEntityFromNetworkId(netId)
        if DoesEntityExist(entity) then DeleteEntity(entity) end
    end

    local function getBuyerTypeConfig(buyerType)
        local types = (config.game and config.game.buyer_types) or {}
        return (buyerType and types[buyerType]) or nil
    end

    function job.getAvailableLocation()
        local keys = {}
        for key in pairs(config.game.locations or {}) do
            keys[#keys + 1] = key
        end
        if #keys == 0 then return false end
        keys = table.shuffle(keys)
        for _, key in ipairs(keys) do
            if not state.busyLocations[key] then
                return key
            end
        end
        return false
    end

    function job.start(lobby)
        local lobbyId = lobby.id
        if not server.exports.beforeJobStart(lobby, lobby.currentJob) then
            return Jobs.abort(lobbyId, locale('job_start_blocked'))
        end

        local availableLocationIndex = job.getAvailableLocation()
        if not availableLocationIndex then
            return Jobs.abort(lobbyId, locale('no_available_location'))
        end

        state.busyLocations[availableLocationIndex] = true

        -- Fixed product for this job (drug-specific configs)
        local product = config.game.product
        if not product then
            local products = config.game.products or {}
            if #products > 0 then
                product = products[math.random(#products)]
            end
        end
        if not product or not product.pickup then
            state.busyLocations[availableLocationIndex] = nil
            return Jobs.abort(lobbyId, 'No product/pickup configured for this delivery job.')
        end

        local drops = table.shuffle(shared.deepCopy(config.game.drop_off_points or {}))
        lobby.currentJob.game = {
            location_index = availableLocationIndex,
            location = config.game.locations[availableLocationIndex],
            product = product,
            vehicleNetId = nil,
            drop_off_points = drops,
            delivered_locations = {},
        }

        return true
    end

    function job.stop(lobbyId)
        local lobby = Lobby.getLobbyById(lobbyId)
        if not lobby then return false end
        LockManager.unlock('delivery:' .. tostring(lobbyId) .. ':' .. JOB_KEY)
        if lobby.currentJob and lobby.currentJob.game then
            deleteLobbyVan(lobby.currentJob.game.vehicleNetId)
            local idx = lobby.currentJob.game.location_index
            if idx then state.busyLocations[idx] = nil end
        end
        return true
    end

    function job.onStepDone(source, lobbyId, stepId)
        local lobby = Lobby.getLobbyById(lobbyId)
        if not lobby or not lobby.currentJob then return false end
        if lobby.currentJob.steps[stepId].done then return false end
        lobby.currentJob.steps[stepId].done = true
        for _, member in pairs(lobby.members) do
            TriggerClientEvent(_e('client:jobs:onStepDone'), member.source, JOB_KEY, stepId, lobby.currentJob)
        end
        return true
    end

    lib.callback.register(_e(('server:jobs:%s:onVehicleSpawn'):format(JOB_KEY)), function(source, lobbyId)
        local lobby = Utils.assertJobMember(source, lobbyId, JOB_KEY, JOB_KEY .. ':onVehicleSpawn', 1500)
        if not lobby then return false end
        if lobby.currentJob.game.vehicleNetId then return true end

        local product = lobby.currentJob.game.product
        local vehicleCoords = product and product.pickup
        if not vehicleCoords then
            vehicleCoords = lobby.currentJob.game.location and lobby.currentJob.game.location.vehicle_location
        end
        if not vehicleCoords then return false end

        local netId = Utils.spawnVehicle({ model = vehicleModel, coords = vehicleCoords })
        if not netId or netId <= 0 then return false end

        lobby.currentJob.game.vehicleNetId = netId
        for _, member in pairs(lobby.members) do
            TriggerClientEvent(_e(('client:jobs:%s:onVehicleSpawned'):format(JOB_KEY)), member.source, netId)
        end

        job.onStepDone(source, lobbyId, 1)
        return true
    end)

    lib.callback.register(_e(('server:jobs:%s:pickupShipment'):format(JOB_KEY)), function(source, lobbyId)
        local lobby = Utils.assertJobMember(source, lobbyId, JOB_KEY, JOB_KEY .. ':pickupShipment', 1500)
        if not lobby then return false end
        if lobby.currentJob.steps[2].done then return false end

        local product = lobby.currentJob.game.product
        if not product or not product.item then
            return { error = 'No product configured for this run.' }
        end

        if product.pickup and not Utils.isPlayerNearCoords(source, product.pickup, 15.0) then
            return { error = 'not_near' }
        end

        local deliverTarget = (lobby.currentJob.steps[3].progress and lobby.currentJob.steps[3].progress.target) or 0
        if deliverTarget <= 0 then
            return { error = 'Invalid delivery target.' }
        end

        if not Inventory.giveItem(source, product.item, deliverTarget) then
            return { error = locale('illegal_delivery.item_give_failed', product.label or product.item) }
        end

        job.onStepDone(source, lobbyId, 2)
        return { ok = true, item = product.item, count = deliverTarget }
    end)

    lib.callback.register(_e(('server:jobs:%s:onDelivered'):format(JOB_KEY)), function(source, lobbyId, index)
        local lockKey = 'delivery:' .. tostring(lobbyId) .. ':' .. JOB_KEY
        if not LockManager.lock(lockKey) then
            return { ok = false, error = locale('illegal_delivery.wait') }
        end

        local success, result = pcall(function()
            local lobby, err = Utils.assertJobMember(source, lobbyId, JOB_KEY, JOB_KEY .. ':onDelivered', 1500)
            if not lobby then return { ok = false, error = err or 'not_member' } end

            if lobby.currentJob.steps[3].done
                or lobby.currentJob.steps[3].progress.current >= lobby.currentJob.steps[3].progress.target then
                return { ok = false, error = locale('illegal_delivery.already_delivered_location') }
            end

            if lobby.currentJob.game.delivered_locations[index] then
                return { ok = false, error = locale('illegal_delivery.already_delivered_location') }
            end

            local drop = lobby.currentJob.game.drop_off_points[index]
            if not drop then
                return { ok = false, error = 'invalid_drop' }
            end
            if not Utils.isPlayerNearCoords(source, drop, 12.0) then
                return { ok = false, error = 'not_near' }
            end

            local product = lobby.currentJob.game.product
            if not product or not product.item then
                return { ok = false, error = 'No product configured for this run.' }
            end

            if not Inventory.hasItem(source, product.item, 1) then
                return { ok = false, error = locale('illegal_delivery.donot_have_box') }
            end

            Inventory.removeItem(source, product.item, 1)

            local buyerType = drop.buyerType or 'street'
            local buyerCfg = getBuyerTypeConfig(buyerType)
            local pay = (buyerCfg and buyerCfg.pay) or 0
            if pay > 0 then
                if Config.DirtyMoney.isItem then
                    Inventory.giveItem(source, Config.DirtyMoney.itemName, pay)
                else
                    server.playerAddMoney(source, Config.DirtyMoney.accountName, pay)
                end
            end

            local alertChance = (buyerCfg and buyerCfg.police_alert_chance) or config.game.police_alert_chance or 0.0
            local policeAlert = alertChance > 0.0 and math.random() < alertChance

            lobby.currentJob.game.delivered_locations[index] = true
            lobby.currentJob.steps[3].progress.current = lobby.currentJob.steps[3].progress.current + 1

            for _, member in pairs(lobby.members) do
                TriggerClientEvent(_e(('client:jobs:%s:onDelivered'):format(JOB_KEY)), member.source, index)
                TriggerClientEvent(_e('client:jobs:onStepProgressed'), member.source, JOB_KEY, lobby.currentJob)
            end

            if lobby.currentJob.steps[3].progress.current >= lobby.currentJob.steps[3].progress.target then
                job.onStepDone(source, lobbyId, 3)
            end

            return { ok = true, policeAlert = policeAlert, pay = pay, buyerType = buyerType }
        end)

        LockManager.unlock(lockKey)
        if success then return result end
        lib.print.error('[ERROR] Delivery failed:', result)
        return { ok = false, error = 'Unexpected server error.' }
    end)

    Jobs.register(JOB_KEY, job)
end
