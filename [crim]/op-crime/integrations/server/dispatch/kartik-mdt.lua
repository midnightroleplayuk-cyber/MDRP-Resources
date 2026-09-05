if Config.dispatchScript ~= "kartik-mdt" then return end

local function pushKartikAlert(data)
    if GetResourceState('kartik-mdt') ~= 'started' then
        print('[op-crime] kartik-mdt is not started, alert skipped.')
        return false
    end

    if type(data) ~= "table" then return false end

    local x = tonumber(data.x or (data.coords and data.coords.x))
    local y = tonumber(data.y or (data.coords and data.coords.y))
    local z = tonumber(data.z or (data.coords and data.coords.z))
    if not x or not y or not z then
        print('[op-crime] kartik-mdt alert skipped: missing coords.')
        return false
    end

    local blip = type(data.blip) == "table" and data.blip or {}
    local payload = {
        title = tostring(data.title or "Alert"),
        code = tostring(data.code or "Alert"),
        description = tostring(data.description or data.message or ""),
        location = tostring(data.location or "Unknown"),
        sound = data.sound or "dispatch",
        x = x + 0.0,
        y = y + 0.0,
        z = z + 0.0,
        type = data.type or "Alert",
        blip = {
            radius = tonumber(blip.radius) or 75.0,
            sprite = tonumber(blip.sprite) or 161,
            color = tonumber(blip.color) or 1,
            scale = tonumber(blip.scale) or 1.0,
            length = tonumber(blip.length) or 5,
        },
        jobs = type(data.jobs) == "table" and data.jobs or {
            police = true,
            sheriff = true,
            sasp = true,
        },
    }

    TriggerEvent('kartik-mdt:server:sendDispatchNotification', payload)
    return true
end

AddEventHandler('op-crime:internalKartikDispatchAlert', function(data)
    pushKartikAlert(data)
end)

function sendKartikDispatchAlert(data)
    TriggerEvent('op-crime:internalKartikDispatchAlert', data)
end

RegisterNetEvent('op-crime:kartikDispatchAlert', function(data)
    TriggerEvent('op-crime:internalKartikDispatchAlert', data)
end)