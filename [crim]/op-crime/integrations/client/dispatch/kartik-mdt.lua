if Config.dispatchScript ~= "kartik-mdt" then return end

local function getStreetAndZone(coords)
    local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street = GetStreetNameFromHashKey(streetHash)
    local crossing = crossingHash ~= 0 and GetStreetNameFromHashKey(crossingHash) or nil

    local zone = GetNameOfZone(coords.x, coords.y, coords.z)
    local zoneLabel = GetLabelText(zone)
    if not zoneLabel or zoneLabel == "" or zoneLabel == "NULL" then
        zoneLabel = zone or "Unknown"
    end

    if crossing and crossing ~= "" then
        return ("%s & %s (%s)"):format(street, crossing, zoneLabel)
    end

    return ("%s (%s)"):format(street, zoneLabel)
end

local function normalizeCoords(arg)
    if type(arg) == "vector3" or type(arg) == "vector4" then
        return vector3(arg.x + 0.0, arg.y + 0.0, arg.z + 0.0)
    end

    if type(arg) == "table" and arg.x and arg.y and arg.z then
        return vector3(arg.x + 0.0, arg.y + 0.0, arg.z + 0.0)
    end

    return nil
end

function sendDispatchAlert(title, message, blipData, coordsData, Type)
    if GetResourceState("kartik-mdt") ~= "started" then
        print("^3[op-crime] Kartik-MDT not started, skipping dispatch^0")
        return
    end

    local coords = normalizeCoords(coordsData)
    if not coords then
        print("^1[op-crime] Kartik-MDT alert skipped: missing/invalid coords^0")
        return
    end

    local location = getStreetAndZone(coords)
    blipData = blipData or {}

    TriggerServerEvent('op-crime:kartikDispatchAlert', {
        title = title or "Alert",
        code = Type or "Alert",
        description = message or "",
        location = location,
        x = coords.x,
        y = coords.y,
        z = coords.z,
        type = "Alert",
        sound = "dispatch",
        blip = {
            radius = 75.0,
            sprite = blipData.sprite or 161,
            color = blipData.color or 1,
            scale = 1.0,
            length = 5,
        },
        jobs = {
            police = true,
            sheriff = true,
            sasp = true,
        },
    })
end