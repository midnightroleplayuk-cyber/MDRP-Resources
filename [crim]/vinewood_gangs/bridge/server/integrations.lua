-- Links to your dispatch script (vinewood-dispatch, ps-dispatch, cd_dispatch, rcore_dispatch, qs-dispatch,
-- core_dispatch or lb-tablet, or your own) and vinewood-mdt. All optional: if none is running, these calls do
-- nothing and the gang script carries on.

local function started(resource)
    return resource and GetResourceState(resource) == 'started'
end

-------------------------------------------------------------------------------
-- Dispatch
-------------------------------------------------------------------------------

Bridge.Dispatch = {}

local SUPPORTED = { 'vinewood-dispatch', 'ps-dispatch', 'cd_dispatch', 'rcore_dispatch', 'qs-dispatch', 'core_dispatch', 'lb-tablet' }

---The dispatch script in use: the one named in Config.Integrations.dispatch, or with 'auto' the first one running.
local function dispatchRes()
    local d = Config.Integrations.dispatch
    if d == false or d == nil or d == '' then return nil end
    if d == 'custom' then return 'custom' end
    if d ~= 'auto' then return started(d) and d or nil end
    for _, r in ipairs(SUPPORTED) do if started(r) then return r end end
    return nil
end
Bridge.Dispatch.Using = dispatchRes

local function policeJobs() return Config.Integrations.policeJobs or { 'police' } end
local function blipCfg() return Config.Integrations.blip or { sprite = 161, colour = 1, scale = 1.2 } end
-- Our priority: 1 = urgent, 2 = normal, 3 = low
local function word(p) p = tonumber(p) or 2 return p <= 1 and 'high' or (p >= 3 and 'low' or 'medium') end

---Write your own here when Config.Integrations.dispatch = 'custom'. data is the same as Bridge.Dispatch.Alert's.
function Bridge.Dispatch.CustomAlert(data)
    -- Example: exports['my_dispatch']:Alert({ title = data.title, text = data.description, coords = data.coords, jobs = policeJobs() })
    return false
end

-- How each dispatch script takes an alert (from each one's documentation; check yours if you've changed it)
local SEND = {
    ['vinewood-dispatch'] = function(res, data)
        if data.preset then
            local ok, id = pcall(function() return exports[res]:SendPreset(data.preset, data.coords, { description = data.description }) end)
            if ok and id then return id end
        end
        return exports[res]:CreateAlert({
            title = data.title, description = data.description, code = data.code, priority = data.priority or 2,
            services = data.services or { 'police' }, coords = data.coords,
            blip = data.approximate and { radius = 80.0, approximate = true } or nil,
        })
    end,

    ['ps-dispatch'] = function(_, data)
        TriggerEvent('ps-dispatch:server:notify', {
            message = data.title, codeName = Config.Integrations.psDispatchCodeName or 'susactivity',
            code = data.code or '10-31', icon = 'fas fa-user-secret', priority = (tonumber(data.priority) or 2) <= 1 and 1 or 2,
            coords = data.coords, street = data.description or '', information = data.description,
            jobs = Config.Integrations.psDispatchJobs or { 'leo' },
        })
        return true
    end,

    ['cd_dispatch'] = function(_, data)
        local b = blipCfg()
        TriggerEvent('cd_dispatch:AddNotification', {
            job_table = policeJobs(), coords = data.coords, title = data.title, message = data.description or data.title,
            flash = (tonumber(data.priority) or 2) <= 1 and 1 or 0, unique_id = ('vg_%d_%d'):format(os.time(), math.random(1000, 9999)),
            sound = 1,
            blip = { sprite = b.sprite, scale = b.scale, colour = b.colour, flashes = false, text = data.title, time = 5,
                radius = data.approximate and 80 or 0 },
        })
        return true
    end,

    ['rcore_dispatch'] = function(_, data)
        local b = blipCfg()
        TriggerEvent('rcore_dispatch:server:sendAlert', {
            code = data.code and (data.code .. ' - ' .. data.title) or data.title, default_priority = word(data.priority),
            coords = data.coords, job = policeJobs(), text = data.description or data.title, type = 'alerts', blip_time = 60,
            blip = { sprite = b.sprite, colour = b.colour, scale = 0.8, text = data.title, flashes = false, radius = data.approximate and 80 or 0 },
        })
        return true
    end,

    ['qs-dispatch'] = function(_, data)
        local b = blipCfg()
        TriggerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = policeJobs(), callLocation = data.coords, callCode = { code = data.code or '10-31', snippet = data.title },
            message = data.description or data.title, flashes = (tonumber(data.priority) or 2) <= 1, image = nil,
            blip = { sprite = b.sprite, scale = b.scale, colour = b.colour, flashes = false, text = data.title, time = 60 * 1000 },
        })
        return true
    end,

    ['core_dispatch'] = function(res, data)
        local b = blipCfg()
        exports[res]:sendAlert({
            code = data.code or '10-31', message = data.description and (data.title .. ': ' .. data.description) or data.title,
            coords = data.coords, priority = (tonumber(data.priority) or 2) <= 1, job = policeJobs(), time = 10000,
            blip = b.sprite, color = b.colour,
        })
        return true
    end,

    ['lb-tablet'] = function(res, data)
        exports[res]:AddDispatch({
            job = policeJobs(), priority = word(data.priority), code = data.code or '10-31', title = data.title,
            description = data.description or '', location = { label = data.title, coords = vector2(data.coords.x, data.coords.y) }, time = 300,
        })
        return true
    end,

    custom = function(_, data) return Bridge.Dispatch.CustomAlert(data) end,
}

---@param data { preset?:string, title:string, description?:string, code?:string, priority?:number, coords:vector3, services?:string[], approximate?:boolean }
---@return any|false alertId (true for dispatch scripts that don't return an id)
function Bridge.Dispatch.Alert(data)
    local res = dispatchRes()
    if not res or not data or not data.coords then return false end
    local send = SEND[res]
    if not send then return false end
    local ok, id = pcall(send, res, data)
    if not ok then
        lib.print.warn(('Dispatch alert to %s failed: %s'):format(res, tostring(id)))
        return false
    end
    return id or false
end

---Counts on-duty police from the framework (for dispatch scripts that can't tell us).
local function countPolice()
    local jobs = {}
    for _, j in ipairs(policeJobs()) do jobs[j] = true end
    local n = 0
    for _, id in ipairs(GetPlayers()) do
        local s = tonumber(id)
        local job = Bridge.GetJob(s)
        if job and jobs[job] and Bridge.IsOnDuty(s) then n = n + 1 end
    end
    return n
end
Bridge.Dispatch.CountPolice = countPolice

---Police on duty. vinewood-dispatch says; with any other set-up the framework is counted (or nil = unknown).
function Bridge.Dispatch.OnDuty(service)
    local res = dispatchRes()
    if res == 'vinewood-dispatch' then
        local ok, count = pcall(function() return exports[res]:GetOnDutyCount(service or 'police') end)
        if ok and tonumber(count) then return tonumber(count) end
    end
    if (service or 'police') ~= 'police' then return nil end
    local ok, n = pcall(countPolice)
    return ok and n or nil
end

---Rolls a witness chance and raises an alert if someone calls it in.
function Bridge.Dispatch.Witness(chance, data)
    if chance and Director and data.coords then
        chance = math.min(1.0, chance * Director.Mult('witnessZone', Zones.FromCoords(data.coords)))
    end
    if not chance or chance <= 0 or math.random() >= chance then return false end
    if Bridge.Dispatch.OnDuty('police') == 0 then return false end
    return Bridge.Dispatch.Alert(data)
end

-------------------------------------------------------------------------------
-- MDT intelligence
-------------------------------------------------------------------------------

---Unlocks a door in your door-lock script (ox_doorlock or qb-doorlock). id = the door's ID or name there.
function Bridge.UnlockDoor(id)
    if GetResourceState('ox_doorlock') == 'started' then
        local door = tonumber(id) and exports.ox_doorlock:getDoor(tonumber(id)) or exports.ox_doorlock:getDoorFromName(id)
        if door then exports.ox_doorlock:setDoorState(door.id, 0) return true end
    elseif GetResourceState('qb-doorlock') == 'started' then
        TriggerEvent('qb-doorlock:server:updateState', id, false, false, false, true)
        return true
    end
    return false
end

Bridge.MDT = {}

local intelTable -- nil = not checked yet, false = missing

local function hasIntelTable()
    if intelTable == nil then
        intelTable = (tonumber(MySQL.scalar.await([[
            SELECT COUNT(*) FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'vw_mdt_intel'
        ]])) or 0) > 0
    end
    return intelTable
end

---Files an intelligence report on the MDT for a lead.
---@param lead { id:number, source:string, zone?:string, zoneLabel?:string, precision:string, summary:string, gangLabel?:string }
function Bridge.MDT.PushLead(lead)
    local cfg = Config.Integrations
    local res = cfg.mdt
    if not started(res) then return false end

    -- Use an export if the MDT ever adds one
    local ok, done = pcall(function() return exports[res]:AddIntel(lead) end)
    if ok and done then return true end

    if not hasIntelTable() then return false end

    local text = lead.summary
    local subject = lead.subject or {}
    if lead.gangLabel then text = text .. ('\nGroup believed responsible: %s.'):format(lead.gangLabel) end
    text = text .. ('\nSource: %s. Ref OCG-%d.'):format(lead.source, lead.id or 0)

    MySQL.insert('INSERT INTO vw_mdt_intel (subject_type, subject_id, subject_label, grading, text, officer_name, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        subject.type or 'place',
        subject.id or lead.zone or 'unknown',
        subject.label or lead.zoneLabel or 'Unknown area',
        lead.grading or (cfg.intelGrading and cfg.intelGrading[lead.precision]) or '2DP',
        text,
        cfg.intelAuthor or 'Organised Crime Unit',
        os.time(),
    })
    return true
end
