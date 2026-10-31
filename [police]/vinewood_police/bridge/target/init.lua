-- Target bridge (client). Options use one shape whichever target script runs:
--   { name, label, icon, distance, canInteract = function(entity) end, onSelect = function(entity) end }
--
--   VPO.Target.AddBox(name, { coords = vec3, size = vec3, rotation = number }, options)
--   VPO.Target.RemoveZone(name)
--   VPO.Target.AddGlobalPlayer(options)      VPO.Target.RemoveGlobalPlayer(names)
--   VPO.Target.AddGlobalVehicle(options)     VPO.Target.RemoveGlobalVehicle(names)
--   VPO.Target.AddGlobalPed(options)         VPO.Target.RemoveGlobalPed(names)   (NPCs, not players)
--   VPO.Target.AddEntity(netIdOrEntity, options) VPO.Target.RemoveEntity(entity, names)

VPO.Target = {}
local T = VPO.Target
local adapters, order = {}, {}

function T._Register(name, detect, impl)
    adapters[name] = { detect = detect, impl = impl }
    order[#order + 1] = name
end

local current
local function get()
    if current ~= nil then return current or nil end
    local want = tostring(Config.Target or 'auto'):lower()
    if want ~= 'auto' then
        current = adapters[want] and adapters[want].impl or false
    else
        current = false
        for _, n in ipairs(order) do
            if adapters[n].detect() then current = adapters[n].impl; T.Name = n; break end
        end
    end
    if not current then VPO.Log.warn('No supported target script found (ox_target or qb-target).') end
    return current or nil
end

local function call(fn, ...)
    local impl = get()
    if not impl or not impl[fn] then return nil end
    local ok, r = pcall(impl[fn], ...)
    if not ok then VPO.Log.error('target %s failed: %s', fn, r) end
    return r
end

function T.AddBox(...) return call('AddBox', ...) end
function T.RemoveZone(...) return call('RemoveZone', ...) end
function T.AddGlobalPlayer(...) return call('AddGlobalPlayer', ...) end
function T.RemoveGlobalPlayer(...) return call('RemoveGlobalPlayer', ...) end
function T.AddGlobalVehicle(...) return call('AddGlobalVehicle', ...) end
function T.RemoveGlobalVehicle(...) return call('RemoveGlobalVehicle', ...) end
function T.AddGlobalPed(...) return call('AddGlobalPed', ...) end
function T.RemoveGlobalPed(...) return call('RemoveGlobalPed', ...) end
function T.AddGlobalObject(...) return call('AddGlobalObject', ...) end
function T.RemoveGlobalObject(...) return call('RemoveGlobalObject', ...) end
function T.AddEntity(...) return call('AddEntity', ...) end
function T.RemoveEntity(...) return call('RemoveEntity', ...) end
