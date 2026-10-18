Editable = Editable or {}

---@param state boolean true = show HUD, false = hide HUD
function Editable.toggleHud(state)
    -- Example:
    -- if GetResourceState('your-hud') == 'started' then
    --     exports['your-hud']:Toggle(state)
    -- end
end

---@param key string   alert / job key (e.g. 'car_theft', 'gun_smuggling')
---@param message string display / code message
---@param coords vector3|nil world coords (defaults to local player)
function Editable.policeAlert(key, message, coords)
    coords = coords or GetEntityCoords(cache.ped)

    -- Forward to open server editable hook (optional)
    TriggerServerEvent(_e('server:editable:policeAlert'), key, message, coords)

    -- Example (ps-dispatch):
    -- exports['ps-dispatch']:CustomAlert({
    --     coords = coords,
    --     message = message,
    --     dispatchCode = key,
    --     description = message,
    --     radius = 0,
    --     sprite = 161,
    --     color = 1,
    --     scale = 1.0,
    --     length = 3,
    -- })

    -- Example (cd_dispatch):
    -- TriggerServerEvent('cd_dispatch:AddNotification', {
    --     job_table = { 'police' },
    --     coords = coords,
    --     title = message,
    --     message = message,
    --     flash = 0,
    --     unique_id = tostring(math.random(1000000, 9999999)),
    --     blip = { sprite = 161, scale = 1.2, colour = 1, flashes = false, text = message, time = 5, radius = 0 },
    -- })
end

---@param plate string
---@param entity number|nil vehicle entity
function Editable.giveVehicleKey(plate, entity)
    if not plate or plate == '' then return end
    plate = string.gsub(plate, '^%s*(.-)%s*$', '%1')

    -- QB / Qbox vehicle keys (default)
    if shared.framework ~= 'esx' then
        if GetResourceState('qb-vehiclekeys') == 'started' then
            TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
            TriggerEvent('vehiclekeys:client:SetOwner', plate)
            return
        end
        if GetResourceState('qbx_vehiclekeys') == 'started' then
            TriggerEvent('qb-vehiclekeys:client:AddKeys', plate)
            TriggerEvent('vehiclekeys:client:SetOwner', plate)
            return
        end
        -- Generic fallback used by many key scripts
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
        TriggerEvent('qb-vehiclekeys:client:AddKeys', plate)
    end

    -- Example (wasabi_carlock):
    -- if GetResourceState('wasabi_carlock') == 'started' and entity then
    --     exports['wasabi_carlock']:GiveKey(entity)
    --     return
    -- end

    -- Example (ox_inventory keys / custom):
    -- TriggerServerEvent('your-keys:server:give', plate, NetworkGetNetworkIdFromEntity(entity))
end

---@param plate string
---@param entity number|nil vehicle entity
function Editable.removeVehicleKey(plate, entity)
    if not plate or plate == '' then return end
    plate = string.gsub(plate, '^%s*(.-)%s*$', '%1')

    -- Example (qb-vehiclekeys):
    -- if GetResourceState('qb-vehiclekeys') == 'started' then
    --     TriggerEvent('qb-vehiclekeys:client:RemoveKeys', plate)
    --     return
    -- end

    -- Example (wasabi_carlock):
    -- if GetResourceState('wasabi_carlock') == 'started' and entity then
    --     exports['wasabi_carlock']:RemoveKey(entity)
    --     return
    -- end

    -- TriggerServerEvent('your-keys:server:remove', plate)
end
