-- Fire alarm → dispatch adapters. Each one sends the same call in that
-- dispatch's own format. Built from each script's published docs:
--   vinewood-dispatch : exports CreateAlert / AddNote / CloseAlert
--   ps-dispatch       : server event ps-dispatch:server:notify
--   cd_dispatch       : cd_dispatch:AddNotification, sent via a nearby client (its documented route)
--   qs-dispatch       : server event qs-dispatch:server:CreateDispatchCall
--   rcore_dispatch    : server event rcore_dispatch:server:sendAlert
--   core_dispatch     : server export sendAlert
--   lb-tablet         : server export AddDispatch
Dispatch = {}

local ORDER = { 'vinewood-dispatch', 'ps-dispatch', 'cd_dispatch', 'qs-dispatch', 'rcore_dispatch', 'core_dispatch', 'lb-tablet' }
local RESOURCES = {
    ['vinewood-dispatch'] = { 'vinewood-dispatch', 'vinewood_dispatch' },
    ['ps-dispatch'] = { 'ps-dispatch' },
    ['cd_dispatch'] = { 'cd_dispatch' },
    ['qs-dispatch'] = { 'qs-dispatch' },
    ['rcore_dispatch'] = { 'rcore_dispatch' },
    ['core_dispatch'] = { 'core_dispatch' },
    ['lb-tablet'] = { 'lb-tablet' },
}

local function running(name)
    for _, r in ipairs(RESOURCES[name] or { name }) do
        if GetResourceState(r) == 'started' then return r end
    end
end

---@return string|nil system, string|nil resource
local function pick()
    local want = Config.Dispatch.system or 'auto'
    if want == 'none' then return nil end
    if want ~= 'auto' then
        local r = running(want)
        if not r then print(('^3[vinewood_firealarm] Config.Dispatch.system is "%s" but it isn\'t running^7'):format(want)) end
        return r and want, r
    end
    for _, name in ipairs(ORDER) do
        local r = running(name)
        if r then return name, r end
    end
end

local function prioWord(p) return p == 1 and 'high' or (p == 2 and 'medium' or 'low') end

local Adapters = {}

Adapters['vinewood-dispatch'] = function(res, d, cfg)
    local id, err = exports[res]:CreateAlert({
        code = cfg.code, title = cfg.title, description = d.description,
        priority = cfg.priority, services = cfg.jobs,
        coords = d.coords and { x = d.coords.x, y = d.coords.y, z = d.coords.z } or nil,
        blip = cfg.blip, location = d.location,
    })
    if not id then print(('^3[vinewood_firealarm] vinewood-dispatch rejected the alert: %s^7'):format(tostring(err))) end
    return id
end

Adapters['ps-dispatch'] = function(_, d, cfg)
    TriggerEvent('ps-dispatch:server:notify', {
        message = cfg.title,
        codeName = cfg.psCodeName,
        code = cfg.code,
        icon = cfg.icon,
        priority = cfg.priority,
        coords = d.coords,
        street = d.street,
        information = d.description,
        jobs = cfg.psJobs or cfg.jobs,
    })
end

Adapters['cd_dispatch'] = function(_, d, cfg)
    -- cd_dispatch takes alerts from a client, so hand it to the player nearest the alarm
    local best, bestDist
    for _, id in ipairs(GetPlayers()) do
        local ped = GetPlayerPed(id)
        if ped ~= 0 then
            local dist = #(GetEntityCoords(ped) - d.coords)
            if not bestDist or dist < bestDist then best, bestDist = tonumber(id), dist end
        end
    end
    if not best then print('^3[vinewood_firealarm] cd_dispatch: no players online to relay the alert^7') return end
    TriggerClientEvent('vinewood_firealarm:cdRelay', best, {
        job_table = cfg.jobs,
        coords = d.coords,
        title = ('%s - %s'):format(cfg.code, cfg.title),
        message = d.description,
        flash = cfg.priority == 1 and 1 or 0,
        sound = 1,
        blip = {
            sprite = cfg.blip.sprite, scale = cfg.blip.scale, colour = cfg.blip.colour,
            flashes = cfg.blip.flash, text = cfg.title,
            time = math.max(1, math.floor((cfg.blip.time or 300) / 60)), radius = 0,
        },
    })
end

Adapters['qs-dispatch'] = function(_, d, cfg)
    TriggerEvent('qs-dispatch:server:CreateDispatchCall', {
        job = cfg.jobs,
        callLocation = d.coords,
        callCode = { code = cfg.code, snippet = cfg.title },
        message = d.description,
        flashes = cfg.blip.flash,
        image = nil,
        blip = {
            sprite = cfg.blip.sprite, scale = cfg.blip.scale, colour = cfg.blip.colour,
            flashes = cfg.blip.flash, text = cfg.title, time = (cfg.blip.time or 300) * 1000,
        },
        otherData = { { text = d.system, icon = cfg.icon } },
    })
end

Adapters['rcore_dispatch'] = function(_, d, cfg)
    TriggerEvent('rcore_dispatch:server:sendAlert', {
        code = cfg.code,
        default_priority = prioWord(cfg.priority),
        coords = d.coords,
        job = cfg.jobs,
        text = d.description,
        type = 'alerts',
        blip_time = cfg.blip.time,
        blip = {
            sprite = cfg.blip.sprite, colour = cfg.blip.colour, scale = cfg.blip.scale,
            text = cfg.title, flashes = cfg.blip.flash, radius = 0,
        },
    })
end

Adapters['core_dispatch'] = function(res, d, cfg)
    local jobs = cfg.jobs
    exports[res]:sendAlert({
        code = cfg.code,
        message = cfg.title,
        extraInfo = { { icon = 'fa-fire', info = d.description } },
        coords = d.coords,
        priority = cfg.priority == 1,
        job = #jobs == 1 and jobs[1] or jobs,
        time = (cfg.blip.time or 300) * 1000,
        blip = cfg.blip.sprite,
        color = cfg.blip.colour,
    })
end

Adapters['lb-tablet'] = function(res, d, cfg)
    exports[res]:AddDispatch({
        mdt = cfg.lbMdt,
        priority = prioWord(cfg.priority),
        code = cfg.code,
        title = cfg.title,
        description = d.description,
        location = { label = d.street or d.system, coords = vector2(d.coords.x, d.coords.y) },
        time = cfg.blip.time,
    })
end

local current -- system name the last alert went to

---@return any alertId (vinewood-dispatch only)
function Dispatch.Send(data)
    local cfg = Config.Dispatch
    local loc = data.location
    data.street = loc and loc.street and (loc.zone and ('%s, %s'):format(loc.street, loc.zone) or loc.street) or data.system
    data.title = cfg.title
    data.description = ('%s. Zone %d %s%s. Alarm not reset at the premises.'):format(
        data.system, data.zone, data.zoneName,
        data.device and (', %s (%s)'):format(data.device, data.reason) or '')

    if cfg.Send then
        local ok, id = pcall(cfg.Send, data)
        if not ok then print(('^1[vinewood_firealarm] Config.Dispatch.Send error: %s^7'):format(id)) return nil end
        current = 'custom'
        return id
    end

    local name, res = pick()
    if not name then
        print(('^3[vinewood_firealarm] No dispatch. ARC call: %s, zone %d (%s)^7'):format(data.system, data.zone, data.zoneName))
        return nil
    end
    if not data.coords then print('^3[vinewood_firealarm] No device coords for the alert, skipping dispatch^7') return nil end

    current = name
    local ok, id = pcall(Adapters[name], res, data, cfg)
    if not ok then print(('^1[vinewood_firealarm] %s alert failed: %s^7'):format(name, id)) return nil end
    if Config.Debug then print(('[vinewood_firealarm] alert sent to %s'):format(name)) end
    return id
end

-- A non-alarm job (e.g. service due). `over` overrides Config.Dispatch fields.
function Dispatch.SendCustom(over, data)
    if Config.Dispatch.Send then return end
    local name, res = pick()
    if not name or not data.coords then return end
    local cfg = setmetatable(over, { __index = Config.Dispatch })
    local loc = data.location
    data.street = loc and loc.street and (loc.zone and ('%s, %s'):format(loc.street, loc.zone) or loc.street) or data.system
    local ok, err = pcall(Adapters[name], res, data, cfg)
    if not ok then print(('^1[vinewood_firealarm] %s job failed: %s^7'):format(name, err)) end
end

-- Notes and closing are vinewood-dispatch features
function Dispatch.Note(alertId, text)
    if not alertId or not Config.Dispatch.notes or current ~= 'vinewood-dispatch' then return end
    local res = running('vinewood-dispatch')
    if not res then return end
    local ok, err = pcall(function() exports[res]:AddNote(alertId, text) end)
    if not ok and Config.Debug then print(('[vinewood_firealarm] AddNote failed: %s'):format(err)) end
end

function Dispatch.Close(alertId)
    if not alertId or current ~= 'vinewood-dispatch' then return end
    local res = running('vinewood-dispatch')
    if res then pcall(function() exports[res]:CloseAlert(alertId) end) end
end
