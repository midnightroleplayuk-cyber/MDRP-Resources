local MOD_NAMES = { 'engine', 'brakes', 'transmission', 'suspension', 'armour' }

local garages = {}
local out = {}

local function notify(src, message, kind)
    TriggerClientEvent('ox_lib:notify', src, { title = 'Garage', description = message, type = kind or 'error' })
end

local function find(id)
    for i, garage in ipairs(garages) do
        if garage.id == id then return garage, i end
    end
end

local function sync()
    TriggerClientEvent('rsvx_garage:sync', -1, garages)
end

local function store(garage)
    MySQL.prepare.await(
        'INSERT INTO rsvx_garages (id, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
        { garage.id, json.encode(garage) }
    )
    sync()
end

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS rsvx_garages (
            id VARCHAR(24) NOT NULL PRIMARY KEY,
            data LONGTEXT NOT NULL,
            created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
    ]])

    local rows = MySQL.query.await('SELECT data FROM rsvx_garages ORDER BY created, id') or {}
    for _, row in ipairs(rows) do
        local garage = json.decode(row.data)
        if garage then garages[#garages + 1] = garage end
    end
    sync()
end)

local function isAdmin(src)
    return IsPlayerAceAllowed(src, 'command.' .. Config.Command)
end

local function text(value, max)
    if type(value) ~= 'string' then return end
    value = value:match('^%s*(.-)%s*$'):sub(1, max)
    return value ~= '' and value or nil
end

local function int(value, min, max)
    value = tonumber(value)
    if not value then return end
    return math.floor(math.max(min, math.min(max, value)))
end

local function coords(value)
    if type(value) ~= 'table' then return end
    local x, y, z = tonumber(value.x), tonumber(value.y), tonumber(value.z)
    if not x or not y or not z then return end
    return { x = x, y = y, z = z, w = tonumber(value.w) or 0.0 }
end

local function sanitiseVehicle(data)
    if type(data) ~= 'table' then return end
    local label, model = text(data.label, 40), text(data.model, 40)
    if not label or not model then return end

    local vehicle = {
        label = label,
        model = model:lower(),
        job = text(data.job, 30),
        grade = int(data.grade, 0, 99) or 0,
        livery = int(data.livery, 0, 255),
        mods = {},
    }

    if type(data.extras) == 'table' then
        vehicle.extras = {}
        for _, extra in ipairs(data.extras) do
            extra = int(extra, 0, 20)
            if extra then vehicle.extras[#vehicle.extras + 1] = extra end
        end
    end

    if type(data.mods) == 'table' then
        for _, name in ipairs(MOD_NAMES) do
            local level = tonumber(data.mods[name])
            if level and level >= 0 then vehicle.mods[name] = int(level, 0, 10) end
        end
        if data.mods.turbo == true then vehicle.mods.turbo = true end
        local tint = tonumber(data.mods.windowTint)
        if tint and tint >= 1 then vehicle.mods.windowTint = int(tint, 1, 6) end
    end

    if type(data.colour) == 'table' then
        local primary, secondary = int(data.colour.primary, 0, 255), int(data.colour.secondary, 0, 255)
        if primary and secondary then vehicle.colour = { primary = primary, secondary = secondary } end
    end

    return vehicle
end

local function sanitiseGarage(data)
    local label = text(data.label, 50)
    if not label then return nil, 'Give the garage a name.' end

    local ped = coords(data.ped)
    if not ped then return nil, 'Set the attendant position.' end
    ped.model = text(data.ped.model, 40) or 's_m_y_cop_01'

    local garage = {
        label = label,
        platePrefix = (text(data.platePrefix, 4) or ''):upper():gsub('[^%w]', ''),
        ped = ped,
        jobs = {},
        spawns = {},
        vehicles = {},
    }

    local jobCount = 0
    if type(data.jobs) == 'table' then
        for name, grade in pairs(data.jobs) do
            name = text(name, 30)
            if name then
                garage.jobs[name] = int(grade, 0, 99) or 0
                jobCount += 1
            end
        end
    end
    if jobCount == 0 then return nil, 'Add at least one job.' end

    if type(data.spawns) == 'table' then
        for i = 1, math.min(#data.spawns, 20) do
            local spawn = coords(data.spawns[i])
            if spawn then garage.spawns[#garage.spawns + 1] = spawn end
        end
    end
    if #garage.spawns == 0 then return nil, 'Add at least one bay.' end

    if type(data.vehicles) == 'table' then
        for i = 1, math.min(#data.vehicles, 60) do
            local vehicle = sanitiseVehicle(data.vehicles[i])
            if not vehicle then return nil, ('Vehicle %d needs a name and a model.'):format(i) end
            if vehicle.job and not garage.jobs[vehicle.job] then vehicle.job = nil end
            garage.vehicles[#garage.vehicles + 1] = vehicle
        end
    end

    return garage
end

local function authorise(src, id)
    local garage = find(id)
    local player = exports.qbx_core:GetPlayer(src)
    if not garage or not player then return end

    local job = player.PlayerData.job
    local min = garage.jobs[job.name]
    if not min or job.grade.level < min then return end

    local ped = garage.ped
    if #(GetEntityCoords(GetPlayerPed(src)) - vec3(ped.x, ped.y, ped.z)) > 10.0 then return end

    if Config.RequireDuty and not job.onduty then
        notify(src, 'You must be on duty.')
        return
    end

    return garage, job
end

local function freeSpawn(garage)
    local vehicles = GetAllVehicles()
    for _, spawn in ipairs(garage.spawns) do
        local position = vec3(spawn.x, spawn.y, spawn.z)
        local clear = true
        for _, veh in ipairs(vehicles) do
            if #(GetEntityCoords(veh) - position) < 3.0 then
                clear = false
                break
            end
        end
        if clear then return vec4(spawn.x, spawn.y, spawn.z, spawn.w) end
    end
end

local function makePlate(prefix)
    local digits = 8 - #prefix
    return prefix .. ('%0' .. digits .. 'd'):format(math.random(0, math.floor(10 ^ digits) - 1))
end

RegisterNetEvent('rsvx_garage:takeOut', function(id, index)
    local src = source
    local garage, job = authorise(src, id)
    if not garage then return end

    local vehicle = garage.vehicles[tonumber(index)]
    if not vehicle or job.grade.level < vehicle.grade then return end
    if vehicle.job and vehicle.job ~= job.name then return end

    local current = out[src]
    if current == true or (current and DoesEntityExist(current)) then
        return notify(src, 'Return your current vehicle first.')
    end

    local spawn = freeSpawn(garage)
    if not spawn then return notify(src, 'All bays are blocked.') end

    out[src] = true
    local ok, _, veh = pcall(qbx.spawnVehicle, { model = joaat(vehicle.model), spawnSource = spawn })
    if not ok or not veh or veh == 0 then
        out[src] = nil
        return notify(src, 'Vehicle failed to spawn.')
    end
    out[src] = veh

    SetVehicleNumberPlateText(veh, makePlate(garage.platePrefix))

    local state = Entity(veh).state
    state:set('fuel', Config.FuelLevel, true)
    state:set('rsvxGarage', vehicle, true)

    if GetResourceState('qbx_vehiclekeys') == 'started' then
        exports.qbx_vehiclekeys:GiveKeys(src, veh)
    end

    notify(src, ('%s is ready in the bay.'):format(vehicle.label), 'success')
end)

RegisterNetEvent('rsvx_garage:return', function(id)
    local src = source
    local garage = authorise(src, id)
    if not garage then return end

    local veh = out[src]
    if not veh or veh == true or not DoesEntityExist(veh) then
        out[src] = nil
        return notify(src, 'You have no vehicle out.')
    end

    local ped = garage.ped
    if #(GetEntityCoords(veh) - vec3(ped.x, ped.y, ped.z)) > Config.ReturnDistance then
        return notify(src, 'Bring the vehicle back to the garage first.')
    end

    DeleteEntity(veh)
    out[src] = nil
    notify(src, 'Vehicle returned.', 'success')
end)

lib.callback.register('rsvx_garage:getGarages', function()
    return garages
end)

lib.callback.register('rsvx_garage:save', function(src, data)
    if not isAdmin(src) then return { ok = false, error = 'No permission.' } end
    if type(data) ~= 'table' then return { ok = false, error = 'Bad data.' } end

    local garage, err = sanitiseGarage(data)
    if not garage then return { ok = false, error = err } end

    local _, index = find(data.id)
    if index then
        garage.id = data.id
        garages[index] = garage
    else
        garage.id = ('%x%04x'):format(os.time(), math.random(0, 0xffff))
        garages[#garages + 1] = garage
    end

    store(garage)
    return { ok = true, id = garage.id, garages = garages }
end)

lib.callback.register('rsvx_garage:delete', function(src, id)
    if not isAdmin(src) then return { ok = false, error = 'No permission.' } end

    local _, index = find(id)
    if not index then return { ok = false, error = 'Garage not found.' } end

    table.remove(garages, index)
    MySQL.prepare.await('DELETE FROM rsvx_garages WHERE id = ?', { id })
    sync()
    return { ok = true, garages = garages }
end)

lib.addCommand(Config.Command, {
    help = 'Open the emergency garage setup',
    restricted = Config.AdminGroup,
}, function(source)
    TriggerClientEvent('rsvx_garage:openAdmin', source, garages)
end)

AddEventHandler('playerDropped', function()
    local veh = out[source]
    out[source] = nil
    if Config.DeleteOnDrop and veh and veh ~= true and DoesEntityExist(veh) then
        DeleteEntity(veh)
    end
end)
