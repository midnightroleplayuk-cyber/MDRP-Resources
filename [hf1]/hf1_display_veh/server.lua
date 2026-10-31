local displays = {}
local function authorized(source)
    if source == 0 then return false end
    local ids = GetPlayerIdentifiers(source)
    for _, identifier in ipairs(ids) do
        for _, allowed in ipairs(Config.AllowedIdentifiers) do
            if identifier == allowed and not allowed:find('REPLACE_WITH') then return true end
        end
    end
    return false
end
local function notify(src, msg, kind)
    TriggerClientEvent('ox_lib:notify', src, {description=msg, type=kind or 'error'})
end
local function broadcast()
    TriggerClientEvent('hf1_display_veh:client:sync', -1, displays)
end
local function clean(d)
    if type(d) ~= 'table' or type(d.name) ~= 'string' or #d.name < 1 or #d.name > 60 then return nil end
    if type(d.model) ~= 'string' or not d.model:match('^[%w_]+$') or #d.model > 60 then return nil end
    if type(d.plate) ~= 'string' or #d.plate > 8 then return nil end
    for _, k in ipairs({'x','y','z','heading','speed'}) do
        if type(d[k]) ~= 'number' or d[k] ~= d[k] or math.abs(d[k]) > 100000 then return nil end
    end
    if d.speed < Config.MinRotationSpeed or d.speed > Config.MaxRotationSpeed then return nil end
    local colors = {}
    for _, k in ipairs({'primary','secondary'}) do
        local v = tonumber(d[k])
        if not v or v < 0 or v > 160 or v % 1 ~= 0 then return nil end
        colors[k] = v
    end
    return {name=d.name, model=d.model, plate=d.plate, x=d.x,y=d.y,z=d.z,heading=d.heading%360,
        speed=d.speed, rotating=d.rotating == true, primary=colors.primary,secondary=colors.secondary}
end
CreateThread(function()
    local rows = MySQL.query.await('SELECT * FROM hf1_display_vehicles') or {}
    for _, row in ipairs(rows) do
        row.rotating = row.rotating == 1 or row.rotating == true
        displays[tonumber(row.id)] = row
    end
    broadcast()
end)
lib.callback.register('hf1_display_veh:server:access', function(source)
    return authorized(source)
end)
lib.callback.register('hf1_display_veh:server:get', function(source)
    return displays
end)
RegisterNetEvent('hf1_display_veh:server:save', function(data)
    local src = source
    if not authorized(src) then return notify(src, 'Access denied') end
    local d = clean(data)
    if not d then return notify(src, 'Invalid vehicle data') end
    local id = tonumber(data.id)
    if id then
        if not displays[id] then return notify(src, 'Display not found') end
        MySQL.update.await('UPDATE hf1_display_vehicles SET name=?,model=?,plate=?,x=?,y=?,z=?,heading=?,rotating=?,speed=?,primary_color=?,secondary_color=? WHERE id=?',
            {d.name,d.model,d.plate,d.x,d.y,d.z,d.heading,d.rotating and 1 or 0,d.speed,d.primary,d.secondary,id})
    else
        id = MySQL.insert.await('INSERT INTO hf1_display_vehicles (name,model,plate,x,y,z,heading,rotating,speed,primary_color,secondary_color) VALUES (?,?,?,?,?,?,?,?,?,?,?)',
            {d.name,d.model,d.plate,d.x,d.y,d.z,d.heading,d.rotating and 1 or 0,d.speed,d.primary,d.secondary})
    end
    d.id=id
    d.primary_color=d.primary; d.secondary_color=d.secondary
    displays[id]=d
    broadcast()
    notify(src, 'Display saved', 'success')
end)
RegisterNetEvent('hf1_display_veh:server:delete', function(id)
    local src=source
    if not authorized(src) then return notify(src, 'Access denied') end
    id=tonumber(id)
    if not id or not displays[id] then return end
    MySQL.update.await('DELETE FROM hf1_display_vehicles WHERE id=?', {id})
    displays[id]=nil
    broadcast()
    notify(src, 'Display deleted', 'success')
end)
