-- ------------------------------------------------------------
-- INTEGRATIONS / DISPATCH (INTEG2): a request made in the Services app (police, EMS, mechanic, ...) ALSO
-- becomes an alert in the server's dispatch / MDT, so on-duty units see it there too.
-- Caller: server/services.lua (services.request); builtin = the phone's own notifications only.
--   alert(src, data) -> true when the dispatch took the alert (false = not for this system: the phones
--   are notified as usual)
--   data = { id, service, label, job, jobs = { 'police', 'sheriff' }, caller, phone, cid, message,
--            coords = { x, y, z } (never nil when the player has a ped), street?, code }
-- Only the jobs listed in Config.Integrations.dispatchJobs are sent here. ONE provider per server (the
-- dispatcher picks the first one started), so units never get the same call twice.
-- Event based providers (TriggerEvent / TriggerClientEvent) cannot report delivery: they return true.
-- verified = false: written from the vendor's public docs (escrowed resource), not run against it.
-- ------------------------------------------------------------
local PI = PhoneIntegrations
if not PI then return end   -- server/integrations.lua did not load: server/integrations/escrow_check.lua says why in the console

local function str(v, max)
    v = v ~= nil and tostring(v) or ''
    return max and v:sub(1, max) or v
end

local function vec(c)
    if type(c) ~= 'table' and type(c) ~= 'vector3' then return nil end
    local x, y, z = tonumber(c.x), tonumber(c.y), tonumber(c.z)
    if not x or not y then return nil end
    return vector3(x + 0.0, y + 0.0, (z or 0.0) + 0.0)
end

local function copy(list)
    local o = {}
    for i, v in ipairs(list or {}) do o[i] = v end
    return o
end

local POLICE_JOBS = { police = true, sheriff = true, lspd = true, bcso = true, sasp = true, sast = true, state = true, statepolice = true, fib = true, ranger = true, trooper = true, leo = true }
local EMS_JOBS = { ambulance = true, ems = true, doctor = true, fire = true, firefighter = true, safd = true, lsfd = true, medic = true, paramedic = true, hospital = true }

-- 'police' | 'ems' | nil (mechanic, taxi, ...) from the service's job and the mapped dispatch jobs
local function kind(d)
    if POLICE_JOBS[tostring(d.job or '')] then return 'police' end
    if EMS_JOBS[tostring(d.job or '')] then return 'ems' end
    for _, j in ipairs(d.jobs or {}) do
        if POLICE_JOBS[j] then return 'police' end
        if EMS_JOBS[j] then return 'ems' end
    end
    return nil
end

-- "Name · number"
local function who(d)
    local w = str(d.caller, 60)
    if d.phone and str(d.phone) ~= '' then w = (w ~= '' and (w .. ' · ') or '') .. str(d.phone, 20) end
    return w
end

-- one line of text for systems that only take a title + message: "message (Name · number)"
local function body(d)
    local w, msg = who(d), str(d.message, 300)
    if msg == '' then return w end
    return w ~= '' and (msg .. ' (' .. w .. ')') or msg
end
PI.dispatchBody = body

local function title(d) return str(d.label, 60) end
local function street(d) local s = str(d.street, 80) return s ~= '' and s or nil end

-- players of the mapped jobs that are on duty (for targeted sends)
local function unitSources(d)
    local seen, out = {}, {}
    for _, j in ipairs(d.jobs or {}) do
        local ok, list = pcall(FW.GetJobPlayers, j)
        for _, s in ipairs(ok and type(list) == 'table' and list or {}) do
            if not seen[s] then seen[s] = true out[#out + 1] = s end
        end
    end
    return out
end

-- export call that RAISES on failure (the dispatcher warns once and the phones are notified instead)
local function ex(res, name, ...)
    local r = table.pack(PI.callExport(res, name, ...))
    if not r[1] then error(('%s:%s %s'):format(res, name, tostring(r[2])), 0) end
    return table.unpack(r, 2, r.n)
end

-- ------------------------------------------------------------
-- apex_mdt (VERIFIED against the local apex_mdt server/exports.lua + server.lua createCall):
--   exports.apex_mdt:CreateCall({ mode = 'police'|'ems', type, code, label, priority, desc, location, coords,
--   postal, caller }) -> call id. Calls live in memory and go to the on-duty units of that mode.
--   Mode per job comes from apex_mdt's own Config.jobs (shared/config.lua, escrow ignored).
-- ------------------------------------------------------------
local function mdtMode(d)
    local jobs = PI.readResourceTable('apex_mdt', 'shared/config.lua', 'Config.jobs')
    if type(jobs) == 'table' then
        local j = jobs[tostring(d.job or '')]
        if type(j) == 'table' and (j.mode == 'police' or j.mode == 'ems') then return j.mode end
        for _, name in ipairs(d.jobs or {}) do
            j = jobs[name]
            if type(j) == 'table' and (j.mode == 'police' or j.mode == 'ems') then return j.mode end
        end
    end
    return kind(d)
end

PI.define('dispatch', 'apex_mdt', {
    label = 'Apex MDT (CAD calls)', resources = { 'apex_mdt' },
    alert = function(src, d)
        local mode = mdtMode(d)
        if not mode then return false end   -- apex_mdt has only police and EMS calls
        local id = ex('apex_mdt', 'CreateCall', {
            mode = mode, type = 'phone', code = str(d.code, 20), label = title(d),
            priority = 'medium', desc = body(d), location = street(d) or (d.phone and ('Tel. ' .. str(d.phone, 20))) or 'GPS',
            coords = d.coords, caller = str(d.caller, 60),
        })
        return id ~= nil
    end,
})

-- ------------------------------------------------------------
-- ps-dispatch (VERIFIED against Project-Sloth/ps-dispatch 2.2.2 and 3.0.0 server/main.lua + client alerts):
--   3.x: exports['ps-dispatch']:SendTargetedAlert(targets, data) with addToList = true (its notify event
--        compares `source` with a number and breaks when triggered from the server)
--   2.x: TriggerEvent('ps-dispatch:server:notify', data) (no SendTargetedAlert export there)
--   data = the shape of its own PhoneCall alert: message (title), codeName '911call', code, icon, priority,
--   coords, street, name, number, information, jobs (job names or QB job types), alert{} (blip fallback).
-- ------------------------------------------------------------
local function psData(d)
    return {
        message = title(d), codeName = '911call', code = str(d.code, 10), icon = 'fas fa-phone', priority = 2,
        coords = vec(d.coords), street = street(d) or '', name = str(d.caller, 60), number = str(d.phone, 20),
        information = str(d.message, 256), jobs = copy(d.jobs),
        alert = { radius = 0, sprite = 480, color = 1, scale = 1.2, length = 2, sound = 'Lose_1st', sound2 = 'GTAO_FM_Events_Soundset', offset = false, flash = false },
    }
end

PI.define('dispatch', 'ps-dispatch', {
    label = 'ps-dispatch', resources = { 'ps-dispatch' },
    alert = function(src, d)
        local data = psData(d)
        if not data.coords then return false end
        data.addToList = true
        -- on-duty units of the mapped job NAMES; mapped QB job TYPES ('leo', 'ems') match no name here, so
        -- then everyone gets it and each ps-dispatch client keeps it only for its jobs + duty
        local targets = unitSources(d)
        if #targets == 0 then for _, s in ipairs(GetPlayers()) do targets[#targets + 1] = tonumber(s) end end
        local ok, res = PI.callExport('ps-dispatch', 'SendTargetedAlert', targets, data)
        if ok then return res ~= false end
        -- 2.x: no targeted export -> its server event (works from the server on 2.x)
        if tostring(res):find('No such export', 1, true) then
            data.addToList = nil
            TriggerEvent('ps-dispatch:server:notify', data)
            return true
        end
        error(tostring(res), 0)
    end,
})

-- ------------------------------------------------------------
-- cd_dispatch (escrowed; docs.codesign.pro/paid-scripts/dispatch, "server side" method): a client event to
-- everyone, cd_dispatch filters by job_table on each client.
-- ------------------------------------------------------------
PI.define('dispatch', 'cd_dispatch', {
    label = 'cd_dispatch', resources = { 'cd_dispatch' }, verified = false,
    alert = function(src, d)
        local c = vec(d.coords); if not c then return false end
        TriggerClientEvent('cd_dispatch:AddNotification', -1, {
            job_table = copy(d.jobs), coords = c, title = str(d.code, 10) .. ' - ' .. title(d), message = body(d),
            flash = 0, unique_id = 'apexphone' .. tostring(d.id or math.random(1000000, 9999999)), sound = 1,
            blip = { sprite = 480, scale = 1.2, colour = 3, flashes = false, text = str(d.code, 10) .. ' - ' .. title(d), time = 5, radius = 0 },
        })
        return true
    end,
})

-- ------------------------------------------------------------
-- qs-dispatch (escrowed; quasar-store.com/docs/dispatch-and-mdt/create-dispatch-call, server side event)
-- ------------------------------------------------------------
PI.define('dispatch', 'qs-dispatch', {
    label = 'qs-dispatch', resources = { 'qs-dispatch' }, verified = false,
    alert = function(src, d)
        local c = vec(d.coords); if not c then return false end
        local other = { { text = who(d), icon = 'fas fa-phone' } }
        if street(d) then other[#other + 1] = { text = street(d), icon = 'fas fa-location-dot' } end
        TriggerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = copy(d.jobs), callLocation = c, callCode = { code = str(d.code, 10), snippet = title(d) },
            message = str(d.message, 300), flashes = false, image = nil,
            blip = { sprite = 480, scale = 1.2, colour = 3, flashes = false, text = title(d), time = 5 * 60 * 1000 },
            otherData = other,
        })
        return true
    end,
})

-- ------------------------------------------------------------
-- rcore_dispatch (escrowed; documentation.rcore.cz/paid-resources/rcore_dispatch/add-alerts, server API)
-- ------------------------------------------------------------
PI.define('dispatch', 'rcore_dispatch', {
    label = 'rcore_dispatch', resources = { 'rcore_dispatch' }, verified = false,
    alert = function(src, d)
        local c = vec(d.coords); if not c then return false end
        TriggerEvent('rcore_dispatch:server:sendAlert', {
            code = str(d.code, 10), default_priority = 'medium', coords = c, job = copy(d.jobs),
            text = title(d) .. ': ' .. body(d), type = 'alerts', blip_time = 300,
            blip = { sprite = 480, colour = 3, scale = 1.0, text = title(d), flashes = false, radius = 0 },
        })
        return true
    end,
})

-- ------------------------------------------------------------
-- core_dispatch (C8re, escrowed; docs.c8re.store/core-dispatch/exports, server export sendAlert{...})
-- ------------------------------------------------------------
PI.define('dispatch', 'core_dispatch', {
    label = 'core_dispatch', resources = { 'core_dispatch' }, verified = false,
    alert = function(src, d)
        local c = vec(d.coords); if not c then return false end
        local extra = { { icon = 'fa-user', info = str(d.caller, 60) }, { icon = 'fa-phone', info = str(d.phone, 20) } }
        if street(d) then extra[#extra + 1] = { icon = 'fa-location-dot', info = street(d) } end
        ex('core_dispatch', 'sendAlert', {
            code = str(d.code, 10), message = title(d) .. ': ' .. str(d.message, 300), extraInfo = extra, coords = c,
            priority = false, job = copy(d.jobs), time = 8000, blip = 480, color = 3,
        })
        return true
    end,
})

-- ------------------------------------------------------------
-- tk_dispatch (escrowed; tk-scripts.gitbook.io/docs/tk_dispatch/exports/server, addCall with phoneNumber)
-- ------------------------------------------------------------
PI.define('dispatch', 'tk_dispatch', {
    label = 'tk_dispatch', resources = { 'tk_dispatch' }, verified = false,
    alert = function(src, d)
        local c = vec(d.coords); if not c then return false end
        ex('tk_dispatch', 'addCall', {
            title = title(d), code = str(d.code, 10), priority = 'Priority 2', message = str(d.message, 300),
            coords = c, location = street(d), person = str(d.caller, 60), phoneNumber = str(d.phone, 20),
            removeTime = 10 * 60 * 1000, showTime = 8000, playSound = true, jobs = copy(d.jobs),
            blip = { sprite = 480, scale = 1.0, color = 3, flash = false, display = 4, shortRange = false, radius = 0 },
        })
        return true
    end,
})

-- ------------------------------------------------------------
-- linden_outlawalert (VERIFIED against thelindat/linden_outlawalert server.lua, ESX): custom alert event
-- 'wf-alerts:svNotify' with dispatchData (recipientList = job names) + caller + coords.
-- ------------------------------------------------------------
PI.define('dispatch', 'linden_outlawalert', {
    label = 'linden_outlawalert', resources = { 'linden_outlawalert' },
    alert = function(src, d)
        local c = vec(d.coords); if not c then return false end
        TriggerEvent('wf-alerts:svNotify', {
            dispatchData = {
                displayCode = str(d.code, 10), description = title(d), isImportant = 0, recipientList = copy(d.jobs),
                length = '13000', infoM = 'fa-phone', info = str(d.message, 300), infoM2 = 'fa-user', info2 = who(d),
                blipSprite = 480, blipColour = 84, blipScale = 1.5,
            },
            caller = who(d), coords = c,
        })
        return true
    end,
})

-- ------------------------------------------------------------
-- lb-tablet (escrowed; docs.lbscripts.com/tablet/script-integration/server-exports, AddDispatch)
-- ------------------------------------------------------------
PI.define('dispatch', 'lb-tablet', {
    label = 'lb-tablet', resources = { 'lb-tablet' }, verified = false,
    alert = function(src, d)
        local c = vec(d.coords); if not c then return false end
        local id = ex('lb-tablet', 'AddDispatch', {
            priority = 'medium', code = str(d.code, 10), title = title(d), description = str(d.message, 300),
            location = { label = street(d) or 'GPS', coords = vector2(c.x, c.y) }, time = 300,
            job = copy(d.jobs),
            fields = { { icon = 'fa-solid fa-user', label = 'Caller', value = str(d.caller, 60) },
                       { icon = 'fa-solid fa-phone', label = 'Phone', value = str(d.phone, 20) } },
            blip = { sprite = 480, color = 3, size = 1.0, label = title(d), shortRange = false },
        })
        return id ~= false and id ~= nil
    end,
})

-- ------------------------------------------------------------
-- kartik-mdt V2 (escrowed; kartik-scripts.gitbook.io kartik-mdt-v2 exports/server/create-call)
-- ------------------------------------------------------------
PI.define('dispatch', 'kartik-mdt', {
    label = 'kartik-mdt (V2)', resources = { 'kartik-mdt' }, verified = false,
    alert = function(src, d)
        local c = vec(d.coords); if not c then return false end
        local id = ex('kartik-mdt', 'CreateCall', {
            title = title(d), description = body(d), coords = c, isPanic = false, job = copy(d.jobs),
            street = street(d), person = str(d.caller, 60),
        }, src)
        return id ~= nil and id ~= false
    end,
})

-- ------------------------------------------------------------
-- origen_police (escrowed; docs.origennetwork.com/scripts/origen_police/exports, server SendAlert)
-- `job` is one job group: the first mapped job.
-- ------------------------------------------------------------
PI.define('dispatch', 'origen_police', {
    label = 'origen_police', resources = { 'origen_police' }, verified = false,
    alert = function(src, d)
        local c = vec(d.coords); if not c then return false end
        ex('origen_police', 'SendAlert', {
            coords = c, title = str(d.code, 10) .. ' - ' .. title(d), type = 'GENERAL', message = body(d),
            job = (d.jobs or {})[1] or d.job, metadata = { name = str(d.caller, 60) },
        })
        return true
    end,
})

-- ------------------------------------------------------------
-- Police-only MDTs without a job field: only police services are sent to them.
-- wasabi_mdt (escrowed; docs.wasabiscripts.com wasabi-mdt exports, CreateDispatch)
-- redutzu-mdt (escrowed; docs.redutzu.com addDispatchToMDT server event)
-- ND_MDT (VERIFIED against ND-Framework/ND_MDT source/server.lua createDispatch)
-- ------------------------------------------------------------
PI.define('dispatch', 'wasabi_mdt', {
    label = 'wasabi_mdt (police)', resources = { 'wasabi_mdt' }, verified = false,
    alert = function(src, d)
        if kind(d) ~= 'police' then return false end
        local c = vec(d.coords); if not c then return false end
        local r = ex('wasabi_mdt', 'CreateDispatch', {
            type = 'disturbance', title = title(d), description = body(d), location = street(d) or 'GPS',
            coords = c, priority = 1, code = str(d.code, 10), senderName = str(d.caller, 60),
        })
        return r ~= false and r ~= nil
    end,
})

PI.define('dispatch', 'redutzu-mdt', {
    label = 'redutzu-mdt (police)', resources = { 'redutzu-mdt' }, verified = false,
    alert = function(src, d)
        if kind(d) ~= 'police' then return false end
        local c = vec(d.coords); if not c then return false end
        TriggerEvent('redutzu-mdt:server:addDispatchToMDT', {
            code = str(d.code, 10), title = title(d) .. ': ' .. body(d), street = street(d) or who(d),
            duration = 5 * 60 * 1000, coords = { x = c.x, y = c.y, z = c.z },
        })
        return true
    end,
})

PI.define('dispatch', 'ND_MDT', {
    label = 'ND_MDT (police)', resources = { 'ND_MDT' },
    alert = function(src, d)
        if kind(d) ~= 'police' then return false end
        local c = vec(d.coords); if not c then return false end
        ex('ND_MDT', 'createDispatch', { caller = who(d), location = street(d) or 'GPS', callDescription = title(d) .. ': ' .. str(d.message, 300), coords = c })
        return true
    end,
})

-- 'auto' order: the owner's MDT first, then the dedicated dispatch resources, then MDTs with a dispatch board
PI.order.dispatch = { 'apex_mdt', 'ps-dispatch', 'cd_dispatch', 'qs-dispatch', 'rcore_dispatch', 'core_dispatch', 'tk_dispatch',
    'linden_outlawalert', 'lb-tablet', 'kartik-mdt', 'origen_police', 'wasabi_mdt', 'redutzu-mdt', 'ND_MDT' }
