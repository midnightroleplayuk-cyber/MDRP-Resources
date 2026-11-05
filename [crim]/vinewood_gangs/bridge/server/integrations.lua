-- Links to vinewood-dispatch and vinewood-mdt. Both are optional: if a resource isn't running,
-- these calls do nothing and the gang script carries on.

local function started(resource)
    return resource and GetResourceState(resource) == 'started'
end

-------------------------------------------------------------------------------
-- Dispatch
-------------------------------------------------------------------------------

Bridge.Dispatch = {}

---@param data { preset?:string, title:string, description?:string, code?:string, priority?:number, coords:vector3, services?:string[], approximate?:boolean }
---@return number|false alertId
function Bridge.Dispatch.Alert(data)
    local res = Config.Integrations.dispatch
    if not started(res) or not data.coords then return false end

    local blip = data.approximate and { radius = 80.0, approximate = true } or nil

    -- Presets get the dispatch script's own wording and icons; fall back to a custom alert
    if data.preset then
        local ok, id = pcall(function()
            return exports[res]:SendPreset(data.preset, data.coords, { description = data.description })
        end)
        if ok and id then return id end
    end

    local ok, id = pcall(function()
        return exports[res]:CreateAlert({
            title = data.title,
            description = data.description,
            code = data.code,
            priority = data.priority or 2,
            services = data.services or { 'police' },
            coords = data.coords,
            blip = blip,
        })
    end)
    if not ok then
        lib.print.warn(('Dispatch alert failed: %s'):format(tostring(id)))
        return false
    end
    return id or false
end

---Police on duty, or nil when the dispatch script isn't running (callers treat nil as "unknown").
function Bridge.Dispatch.OnDuty(service)
    local res = Config.Integrations.dispatch
    if not started(res) then return nil end
    local ok, count = pcall(function() return exports[res]:GetOnDutyCount(service or 'police') end)
    return ok and tonumber(count) or nil
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
