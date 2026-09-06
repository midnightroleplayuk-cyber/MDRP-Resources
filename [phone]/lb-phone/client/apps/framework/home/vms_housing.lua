-- File provided by vames

if Config.HouseScript ~= "vms_housing" then
    return
end

local function FormatKeyHolders(keys)
    local formatted = {}

    if keys then
        local keys = json.decode(keys)
        if exports['vms_housing']:GetConfiguration('UseKeysOnItem') then
            for _, keySerialNumber in pairs(keys) do
                table.insert(formatted, {
                    identifier = nil,
                    name = keySerialNumber
                })
            end
        else
            for identifier, characterName in pairs(keys) do
                table.insert(formatted, {
                    identifier = identifier,
                    name = characterName
                })
            end
        end
    end

    return formatted
end

local function FormatHouses(houses)
    local formatted = {}
    for i = 1, #houses do
        local houseData = houses[i]

        local coords = nil
        local building = nil
        if houseData.object_id then
            local object = exports['vms_housing']:GetProperty(houseData.object_id)
            if not object then
                return
            end

            if object.type == 'building' then
                building = object
            end
        end
        coords = building and building.metadata.enter or houseData.metadata.enter or houseData.metadata.menu

        formatted[i] = {
            label = houseData.name,
            id = houseData.id,
            uniqueId = houseData.id,
            coords = coords,
            locked = nil,
            keyholders = FormatKeyHolders(houseData.keys)
        }
    end

    return formatted
end

RegisterNUICallback("Home", function(data, cb)
    local action, houseData = data.action, data.houseData
    debugprint("vms_housing - Home:" .. (action or ""))

    if action == "getHomes" then
        cb(FormatHouses(exports['vms_housing']:GetPlayerProperties()))

    elseif action == "removeKeyholder" then
        -- To make the Remove Keyholder option work, you have to use `Config.UseKeysOnItem = false` in VMS Housing
        if not exports['vms_housing']:GetConfiguration('UseKeysOnItem') then
            TriggerServerEvent('vms_housing:sv:removeKey', houseData.uniqueId, data.identifier)
            Wait(500)
            cb(FormatKeyHolders(exports['vms_housing']:GetProperty(houseData.uniqueId)?.keys))
        end

    elseif action == "addKeyholder" then
        TriggerServerEvent('vms_housing:sv:buyKey', houseData.uniqueId, tonumber(data.source))
        TriggerServerEvent('vms_housing:sv:giveKey', houseData.uniqueId, tonumber(data.source))
        Wait(500)
        cb(FormatKeyHolders(exports['vms_housing']:GetProperty(houseData.uniqueId)?.keys))

    elseif action == "setWaypoint" then
        if houseData.coords then
            SetNewWaypoint(houseData.coords.x, houseData.coords.y)
        end

        cb(true)
    end
end)
