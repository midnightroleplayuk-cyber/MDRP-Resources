local function convert(options)
    local out = {}
    for i, o in ipairs(options) do
        out[i] = {
            name = o.name,
            label = o.label,
            icon = o.icon,
            distance = o.distance or 2.0,
            canInteract = o.canInteract and function(entity) return o.canInteract(entity) end or nil,
            onSelect = function(data) if o.onSelect then o.onSelect(data.entity) end end,
        }
    end
    return out
end

local function names(options)
    local out = {}
    for i, o in ipairs(options) do out[i] = type(o) == 'table' and o.name or o end
    return out
end

local zones = {}

VPO.Target._Register('ox',
    function() return GetResourceState('ox_target') == 'started' end,
    {
        AddBox = function(name, z, options)
            zones[name] = exports.ox_target:addBoxZone({
                coords = z.coords, size = z.size or vec3(1.5, 1.5, 2.0), rotation = z.rotation or 0.0,
                debug = z.debug, options = convert(options),
            })
            return zones[name]
        end,
        RemoveZone = function(name)
            if zones[name] then exports.ox_target:removeZone(zones[name]); zones[name] = nil end
        end,
        AddGlobalPlayer = function(options) exports.ox_target:addGlobalPlayer(convert(options)) end,
        RemoveGlobalPlayer = function(list) exports.ox_target:removeGlobalPlayer(names(list)) end,
        AddGlobalVehicle = function(options) exports.ox_target:addGlobalVehicle(convert(options)) end,
        RemoveGlobalVehicle = function(list) exports.ox_target:removeGlobalVehicle(names(list)) end,
        AddGlobalPed = function(options) exports.ox_target:addGlobalPed(convert(options)) end,
        RemoveGlobalPed = function(list) exports.ox_target:removeGlobalPed(names(list)) end,
        AddGlobalObject = function(options) exports.ox_target:addGlobalObject(convert(options)) end,
        RemoveGlobalObject = function(list) exports.ox_target:removeGlobalObject(names(list)) end,
        AddEntity = function(entity, options) exports.ox_target:addLocalEntity(entity, convert(options)) end,
        RemoveEntity = function(entity, list) exports.ox_target:removeLocalEntity(entity, names(list)) end,
    })
