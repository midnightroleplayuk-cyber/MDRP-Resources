local allCheckpoints = {}

function drawCheckpoint(identifier,coords)
    if allCheckpoints[identifier] then return end
    dbug('drawCheckpoint(identifier)', identifier)
    if Config.SleeplessWaypoints and Config.SleeplessWaypoints['enabled'] then
        local waypointConfig = Config.SleeplessWaypoints
        allCheckpoints[identifier] = exports['sleepless_waypoints']:create({
            coords = vec3(coords.x, coords.y, coords.z),
            type = waypointConfig['type'],
            color = waypointConfig['color'],
            icon = waypointConfig['icon'],
            size = waypointConfig['size'],
            drawDistance = waypointConfig['drawDistance'],
            groundZ = coords.z - 1,
            minHeight = 5.0,
            maxHeight = 80.0,
        })
    end
end

function removeCheckpoint(identifier)
    if not allCheckpoints[identifier] then return end
    dbug('removeCheckpoint(identifier)', identifier)
    if Config.SleeplessWaypoints and Config.SleeplessWaypoints['enabled'] then
        exports['sleepless_waypoints']:remove(allCheckpoints[identifier])
        allCheckpoints[identifier] = nil
    end
end

function removeAllCheckpoints()
    dbug('removeAllCheckpoints()')
    if Config.SleeplessWaypoints and Config.SleeplessWaypoints['enabled'] then
        dbug('sleepless_waypoints:removeAll()')
        exports['sleepless_waypoints']:removeAll()
        allCheckpoints = {}
    end
end