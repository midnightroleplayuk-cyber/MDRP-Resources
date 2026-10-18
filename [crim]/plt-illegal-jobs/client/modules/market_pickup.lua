--[[
  Black Market pickup delivery — after purchase, a van and/or contact ped
  is spawned at a configured location; interact to claim purchased items.
]]
local Utils = require 'client.modules.utils'
local Target = require 'client.modules.target'

local state = {
    blip = nil,
    vanNetId = nil,
    pedNetId = nil,
    mode = nil,
    coords = nil,
    fallbackPoint = nil,
}

local function clearPickupVisuals()
    if state.blip then
        RemoveBlip(state.blip)
        state.blip = nil
    end
    if state.fallbackPoint then
        state.fallbackPoint:remove()
        state.fallbackPoint = nil
    end

    local function removeTarget(netId)
        if not netId then return end
        if shared.isResourceStart('ox_target') then
            pcall(function()
                exports.ox_target:removeEntity(netId)
            end)
        end
        local ent = NetworkDoesEntityExistWithNetworkId(netId) and NetworkGetEntityFromNetworkId(netId)
        if ent and DoesEntityExist(ent) then
            Target.removeLocalEntity(ent)
        end
    end

    removeTarget(state.vanNetId)
    removeTarget(state.pedNetId)
    state.vanNetId = nil
    state.pedNetId = nil
    state.mode = nil
    state.coords = nil
end

local function claimOrder()
    local Dialogue = require 'client.modules.dialogue'
    local pedEnt = state.pedNetId
        and NetworkDoesEntityExistWithNetworkId(state.pedNetId)
        and NetworkGetEntityFromNetworkId(state.pedNetId)
    local okTalk = Dialogue.confirm(
        (pedEnt and DoesEntityExist(pedEnt)) and pedEnt or nil,
        'Hey, looking for something?',
        'I got the stuff…',
        'Nevermind'
    )
    if not okTalk then return false end

    local result = lib.callback.await(_e('server:market:claim'), false)
    if not result or not result.ok then
        Utils.notify(result and result.error or locale('market.collect_failed'), 'error')
        return false
    end
    Utils.notify(locale('market.collected'), 'success')
    clearPickupVisuals()
    return true
end

local function waitForNetEntity(netId, timeoutMs)
    if not netId then return nil end
    local untilAt = GetGameTimer() + (timeoutMs or 10000)
    while GetGameTimer() < untilAt do
        if NetworkDoesEntityExistWithNetworkId(netId) then
            local ent = NetworkGetEntityFromNetworkId(netId)
            if ent and ent ~= 0 and DoesEntityExist(ent) then
                return ent
            end
        end
        Wait(100)
    end
    return nil
end

local function attachClaimTarget(netId, entity, label)
    local option = {
        label = label,
        icon = 'fa-solid fa-box',
        distance = 2.5,
        onSelect = function()
            claimOrder()
        end,
    }

    if netId and shared.isResourceStart('ox_target') then
        exports.ox_target:addEntity(netId, { option })
        return
    end

    if entity and DoesEntityExist(entity) then
        Target.addLocalEntity(entity, { option })
    end
end

RegisterNetEvent(_e('client:market:pickupReady'), function(payload)
    if not payload or not payload.coords then return end
    clearPickupVisuals()

    local c = payload.coords
    local pos = vector3(c.x + 0.0, c.y + 0.0, c.z + 0.0)
    state.coords = pos
    state.mode = payload.mode
    state.vanNetId = payload.vanNetId
    state.pedNetId = payload.pedNetId

    local blipOpts = payload.blip or { sprite = 501, color = 1, text = 'Black Market Pickup', scale = 0.85 }
    state.blip = Utils.addBlip(pos, blipOpts, true)
    Utils.setStepWaypoint(pos, blipOpts)
    Utils.notify(locale('market.pickup_ready'), 'success')

    CreateThread(function()
        local label = (payload.mode == 'van')
            and (locale('market.collect_van') or 'Open van for delivery')
            or (locale('market.collect') or 'Collect black market order')

        local ped = waitForNetEntity(payload.pedNetId)
        local van = waitForNetEntity(payload.vanNetId)

        if payload.pedNetId then attachClaimTarget(payload.pedNetId, ped, label) end
        if payload.vanNetId then attachClaimTarget(payload.vanNetId, van, label) end

        if not ped and not van then
            state.fallbackPoint = lib.points.new({
                coords = pos,
                distance = 3.0,
                nearby = function(self)
                    Utils.showTextUI(('[E] %s'):format(label))
                    if IsControlJustReleased(0, 38) then
                        Utils.hideTextUI()
                        if claimOrder() then
                            self:remove()
                            state.fallbackPoint = nil
                        end
                    end
                end,
                onExit = function() Utils.hideTextUI() end,
            })
        end
    end)
end)

RegisterNetEvent(_e('client:market:pickupClear'), function()
    clearPickupVisuals()
    Utils.hideTextUI()
end)

return true
