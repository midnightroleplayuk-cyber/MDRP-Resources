-- Integration registry. Each optional resource gets one adapter, created only while that
-- resource is running. Nothing outside this folder calls another Vinewood resource directly.
--
--   VPO.Integrations.Define(name, { resources, minVersion, setup = function(res, version, limited) return adapter end })
--   VPO.Integrations.Available(name)         true while the resource is running and set up
--   VPO.Integrations.Get(name)               the adapter or nil
--   VPO.Integrations.Call(name, method, ...) calls adapter[method] with a timeout; returns results, or nil + error
--   VPO.Integrations.Status()                { [name] = { available, resource, version, limited, reason } }

VPO.Integrations = {}
local I = VPO.Integrations
local defs, state = {}, {}

function I.Define(name, def)
    defs[name] = def
    state[name] = { available = false, reason = 'not_checked' }
end

local function cfg(name) return (Config.Integrations or {})[name] or {} end

local function resourcesFor(name)
    return cfg(name).resources or defs[name].resources or {}
end

local function detect(name)
    local def, c = defs[name], cfg(name)
    local prev = state[name]
    local new = { available = false }

    if c.enabled == false then
        new.reason = 'disabled'
    else
        new.reason = 'not_running'
        for _, res in ipairs(resourcesFor(name)) do
            if GetResourceState(res) == 'started' then
                local version = GetResourceMetadata(res, 'version', 0)
                local min = c.minVersion or def.minVersion
                local limited = (min and version and VPO.Util.CompareVersion(version, min) < 0) or false
                local ok, adapter = pcall(def.setup, res, version, limited)
                if ok and adapter then
                    new = { available = true, resource = res, version = version, limited = limited, adapter = adapter }
                else
                    new.reason = 'setup_failed'
                    VPO.Log.error('Integration %s (%s) failed to set up: %s', name, res, tostring(adapter))
                end
                break
            end
        end
    end

    state[name] = new
    if new.available and not (prev and prev.available and prev.resource == new.resource) then
        VPO.Log.info('Integration %s: using %s %s%s', name, new.resource, new.version or '?',
            new.limited and ' (older version, limited)' or '')
    elseif prev and prev.available and not new.available then
        VPO.Log.warn('Integration %s: %s stopped, using the built-in fallback', name, prev.resource)
    end
    TriggerEvent('vinewood_police:server:integrationChanged', name, new.available)
end

function I.DetectAll() for name in pairs(defs) do detect(name) end end

function I.Available(name) return state[name] ~= nil and state[name].available == true end

function I.Get(name)
    local s = state[name]
    return s and s.available and s.adapter or nil
end

function I.Status()
    local out = {}
    for name, s in pairs(state) do
        out[name] = { available = s.available, resource = s.resource, version = s.version, limited = s.limited, reason = s.reason }
    end
    return out
end

--- Calls an adapter method in its own thread so a slow or broken resource can't hang the caller.
--- Must be called from a thread (net events, callbacks and exports already are).
function I.Call(name, method, ...)
    local a = I.Get(name)
    if not a or type(a[method]) ~= 'function' then return nil, 'unavailable' end
    local args = table.pack(...)
    local p, done = promise.new(), false
    CreateThread(function()
        local r = table.pack(pcall(a[method], table.unpack(args, 1, args.n)))
        if not done then done = true; p:resolve(r) end
    end)
    SetTimeout(Config.Integrations.Timeout or 5000, function()
        if not done then done = true; p:resolve({ n = 2, false, 'timeout' }) end
    end)
    local r = Citizen.Await(p)
    if not r[1] then
        VPO.Log.warn('Integration %s.%s failed: %s', name, method, tostring(r[2]))
        return nil, r[2]
    end
    return table.unpack(r, 2, r.n)
end

-- Re-check when a watched resource starts or stops.
local function onChange(res)
    for name in pairs(defs) do
        if VPO.Util.Contains(resourcesFor(name), res) then
            -- Give a starting resource a moment to register its exports.
            SetTimeout(1000, function() detect(name) end)
        end
    end
end
AddEventHandler('onResourceStart', onChange)
AddEventHandler('onResourceStop', onChange)
