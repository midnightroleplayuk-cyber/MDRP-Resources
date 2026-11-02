if not Config.ZonesTarget then return end
local exists = {}

local function isKeyRestricted(eventConfig, key, zoneJob)
    -- counter/customer dependen del GlobalState del negocio (igual que zones.lua)
    if key == "counter" then
        return GlobalState[(zoneJob or '')..'_counter'] ~= true
    end
    if key == "customer" then
        return GlobalState[(zoneJob or '')..'_counter'] == true
    end
    if type(eventConfig['job']) == "table" then
        return eventConfig['job'][key] == true
    end
    return eventConfig['job'] == true
end

function addZone(data, isUpdate)
    dbug("addZone(target?)", Config.Target)
    while not Config.Target do
        Config.Target = exports['av_laptop']:getTarget()
        warn("We couldn't detect your Config.Target, if not using one, please set Config.ZonesTarget = false")
        Wait(50)
    end
    if not data then
        dbug("addZone() received null as argument")
        return
    end
    local name = data and data['name']
    dbug('zoneName?', name)
    if isUpdate then
        exists[name] = nil
        removeZone(name)
    end
    if exists[name] then return end
    exists[name] = true
    local eventConfig = Config.Events[data['type']]
    if not eventConfig then
        warn("Zone type", data['type'], "doesn't exist in Config.Events, check your config/events.lua !")
        return
    end
    local isMultiOption = type(eventConfig['label']) == "table"
    if isMultiOption then
        local options = {}
        for key, label in pairs(eventConfig['label']) do
            local eventKey = eventConfig['event'] and eventConfig['event'][key]
                or ("av_business:" .. data['type'] .. key:sub(1,1):upper() .. key:sub(2))
            local restricted = isKeyRestricted(eventConfig, key, data['job'])
            local job = restricted and data['job'] or false
            local counterJob = data['job']
            options[#options + 1] = {
                name = data['name'] .. "_" .. key,
                type = "client",
                event = eventKey,
                icon = eventConfig['icon'][key],
                label = label,
                groups = job,
                job = job,
                zoneName = data['name'],
                zoneJob = data['job'],
                distance = tonumber(data['distance']),
                canInteract = function()
                    if key == "counter" then
                        if not counterJob then return false end
                        return GlobalState[counterJob..'_counter'] == true
                    end
                    if key == "customer" then
                        if not counterJob then return false end
                        return GlobalState[counterJob..'_counter'] ~= true
                    end
                    return true
                end,
            }
        end
        if Config.Target == "ox_target" then
            local radius = getZoneRadius(data)
            exports.ox_target:addSphereZone({
                name = data['name'],
                coords = vector3(data['coords']['x'], data['coords']['y'], data['coords']['z']),
                radius = radius or 1.0,
                debug = Config.ZonesDebug,
                drawSprite = true,
                options = options,
            })
        else
            local boxData = getZoneBox(data)
            exports[Config.Target]:AddBoxZone(
                data['name'],
                vector3(data['coords']['x'], data['coords']['y'], data['coords']['z']),
                boxData['width'], boxData['height'],
                {
                    name = data['name'],
                    heading = boxData['heading'],
                    debugPoly = Config.ZonesDebug,
                    minZ = boxData['minZ'],
                    maxZ = boxData['maxZ'],
                },
                {
                    options = options,
                    distance = tonumber(data['distance']),
                }
            )
        end
    else
        local job = eventConfig['job'] and data['job'] or false
        local option = {
            name = data['name'],
            type = "client",
            event = eventConfig['event'],
            icon = eventConfig['icon'],
            label = eventConfig['label'],
            groups = job,
            job = job,
            zoneJob = data['job'],
            zoneType = data['type'],
            zoneName = data['name'],
            distance = tonumber(data['distance']),
            animType = data['animType'],
        }
        if Config.Target == "ox_target" then
            local radius = getZoneRadius(data)
            exports.ox_target:addSphereZone({
                name = data['name'],
                coords = vector3(data['coords']['x'], data['coords']['y'], data['coords']['z']),
                radius = radius or 1.0,
                debug = Config.ZonesDebug,
                drawSprite = true,
                options = { option },
            })
        else
            local boxData = getZoneBox(data)
            exports[Config.Target]:AddBoxZone(
                data['name'],
                vector3(data['coords']['x'], data['coords']['y'], data['coords']['z']),
                boxData['width'], boxData['height'],
                {
                    name = data['name'],
                    heading = boxData['heading'],
                    debugPoly = Config.ZonesDebug,
                    minZ = boxData['minZ'],
                    maxZ = boxData['maxZ'],
                },
                {
                    options = { option },
                    distance = tonumber(data['distance']),
                }
            )
        end
    end
end

function removeZone(name)
    if Config.Target == "ox_target" then
        exports.ox_target:removeZone(name)
    else
        exports[Config.Target]:RemoveZone(name)
    end
end