---<b>Key:</b> player source
---<br><b>Value:</b> phone object
---@type { [number]: number }
local phoneObjects = {}

---@param entity number
local function DeleteEntityIfExists(entity)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end

---@param netId? number
RegisterNetEvent("phone:setPhoneObject", function(netId)
    local src = source

    if Config.PropSpawn == "server" then
        if not netId then
            local phone = phoneObjects[src]

            if phone then
                debugprint("Deleting phone object for player " .. src)
                DeleteEntityIfExists(phone)
            end

            phoneObjects[src] = nil
        end

        return
    end

    phoneObjects[src] = nil

    if netId then
        local entity = NetworkGetEntityFromNetworkId(netId)

        if DoesEntityExist(entity) then
            phoneObjects[src] = entity
        end
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    local phoneEntity = phoneObjects[src]

    if phoneEntity then
        DeleteEntityIfExists(phoneEntity)

        phoneObjects[src] = nil
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for _, phoneEntity in pairs(phoneObjects) do
        DeleteEntityIfExists(phoneEntity)
    end
end)

if not Config.ServerSideSpawn and Config.PropSpawn ~= "server" then
    return
end

local allowedModels = {
    [`prop_amp_phone`] = true,
    [Config.PhoneModel] = true,
}

if Config.Item.Names then
    for i = 1, #Config.Item.Names do
        allowedModels[Config.Item.Names[i].model] = true
    end
end

---@param entity number
---@return boolean exists
local function WaitForEntity(entity)
    local timer = GetGameTimer() + 5000

    while not DoesEntityExist(entity) and timer > GetGameTimer() do
        Wait(0)
    end

    return DoesEntityExist(entity)
end

---@param entity number
local function IgnoreControlFilter(entity)
    SetEntityIgnoreRequestControlFilter(entity, true)

    SetTimeout(10000, function()
        if DoesEntityExist(entity) then
            SetEntityIgnoreRequestControlFilter(entity, false)
        end
    end)
end

---@param source any
---@param model number
---@return number? phoneEntity
function CreatePhoneObject(source, model)
    if phoneObjects[source] then
        DeleteEntityIfExists(phoneObjects[source])

        phoneObjects[source] = nil
    end

    local playerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(playerPed)
    local phone = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, true, true, false)

    if not WaitForEntity(phone) then
        return
    end

    -- allow the player to take control of the phone, so they can attach it
    IgnoreControlFilter(phone)

    return phone
end

---@param model number
RegisterCallback("createPhoneObject", function(source, model)
    if not allowedModels[model] then
        infoprint("warning", ("%s | %i tried to create a phone object with a model (%s) that's not allowed"):format(GetPlayerName(source), source, tostring(model)))
        return false
    end

    debugprint("Creating phone object for", source)

    local phone = CreatePhoneObject(source, model)

    if phone then
        phoneObjects[source] = phone

        return NetworkGetNetworkIdFromEntity(phone)
    else
        return false
    end
end)

RegisterNetEvent("phone:failedControl", function()
    local src = source
    local entity = phoneObjects[src]

    if entity then
        DeleteEntityIfExists(entity)
        debugprint(src .. " failed to take control of phone object, deleting it.")

        phoneObjects[src] = nil
    end
end)

---@param model number
---@param coords vector3
---@param heading? number
---@return number? vehicle
function CreateServerVehicle(model, coords, heading)
    heading = heading or 0

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)

    if not WaitForEntity(vehicle) then
        return
    end

    -- allow the player to take control of the vehicle, so they can set mods
    IgnoreControlFilter(vehicle)

    return vehicle
end

---@param model number
---@param coords vector3
---@param heading? number
---@return number? ped
function CreateServerPed(model, coords, heading)
    heading = heading or 0

    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, heading, true, true)

    if not WaitForEntity(ped) then
        return
    end

    IgnoreControlFilter(ped)

    return ped
end
