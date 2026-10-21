-- In-game staff menu (server side). Authorisation is always decided by the panel.

local staffCache = {}
local lastAction = {}
local ALLOWED = {
    warn = true, kick = true, ban = true, revive = true, ['goto'] = true, bring = true, spectate = true,
    freeze = true, heal = true, sendback = true, message = true,
}

local function notify(src, msg)
    TriggerClientEvent('chat:addMessage', src, { args = { 'HELM', msg } })
end

local function staffInfo(src)
    local c = staffCache[src]
    if c and (GetGameTimer() - c.at) < 60000 then return c.data, c.reason end
    local res = HelmApi('POST', '/api/game/staff-check', { identifiers = HelmIdentifiers(src) })
    local data = false
    if res.status == 200 and res.data and res.data.isStaff then data = res.data end
    -- Why the menu is refused (for example, the role has no in-game menu access), shown instead of the default.
    local reason = res.data and res.data.reason or nil
    staffCache[src] = { at = GetGameTimer(), data = data, reason = reason }
    return data, reason
end

-- Used by anticheat.lua to skip staff (noclip and spectate look like cheats).
function HelmIsStaff(src) return staffInfo(src) and true or false end

local NOT_LINKED = 'You are not linked to a staff account. Link your game account on the panel (Game account), or your Discord ID.'

AddEventHandler('playerDropped', function()
    staffCache[source] = nil
    lastAction[source] = nil
end)

RegisterNetEvent('helm:server:openMenu', function()
    local src = source
    local info, reason = staffInfo(src)
    if not info then
        notify(src, reason or NOT_LINKED)
        return
    end

    local players = {}
    for _, s in ipairs(GetPlayers()) do
        local id = tonumber(s)
        players[#players + 1] = { id = id, name = GetPlayerName(id) or 'unknown' }
    end
    table.sort(players, function(a, b) return a.id < b.id end)

    TriggerClientEvent('helm:client:openMenu', src, { staff = info.name, caps = info.caps, players = players, alerts = HelmAlertsOn(src) })
end)

-- Staff alerts (new reports, flagged joins, ban evasion) on or off for this staff member.
local function toggleAlerts(src)
    local info, reason = staffInfo(src)
    if not info then
        notify(src, reason or NOT_LINKED)
        return
    end
    local on = not HelmAlertsOn(src)
    HelmSetAlerts(src, on)
    TriggerClientEvent('helm:client:alertsState', src, on)
    TriggerClientEvent('helm:client:staffNotice', src, 'Staff alerts',
        on and 'Staff alerts are on. You will be notified in game.' or 'Staff alerts are off. They still appear on the panel.')
end

RegisterNetEvent('helm:server:toggleAlerts', function() toggleAlerts(source) end)

RegisterCommand('helmalerts', function(src)
    if src == 0 then print('[helm] /helmalerts is for staff in game.') return end
    toggleAlerts(src)
end, false)

RegisterNetEvent('helm:server:action', function(data)
    local src = source
    if type(data) ~= 'table' or not ALLOWED[data.action] then return end

    -- Basic flood control; the panel still checks permissions on every call.
    local now = GetGameTimer()
    if lastAction[src] and (now - lastAction[src]) < 1000 then return end
    lastAction[src] = now

    local target = tonumber(data.target)
    if not target or not GetPlayerName(target) then
        notify(src, 'That player is no longer online.')
        return
    end

    local reason = nil
    if type(data.reason) == 'string' then reason = data.reason:sub(1, 300) end
    local hours = tonumber(data.hours)
    if hours then
        hours = math.floor(hours)
        if hours < 1 then hours = nil end
    end

    local res = HelmApi('POST', '/api/game/mod-action', {
        actorIdentifiers = HelmIdentifiers(src),
        action = data.action,
        targetLicense = HelmLicense(target),
        reason = reason,
        durationHours = hours,
    })

    if res.status ~= 200 or not res.data or not res.data.ok then
        local err = (res.data and res.data.error) or ('panel returned ' .. tostring(res.status))
        notify(src, 'Failed: ' .. err)
        return
    end

    local name = res.data.targetName or GetPlayerName(target)
    local staffName = staffInfo(src) and staffInfo(src).name
    if data.action == 'goto' then
        local c = GetEntityCoords(GetPlayerPed(target))
        TriggerClientEvent('helm:client:teleport', src, c.x, c.y, c.z)
        HelmTellPlayer(target, 'goto', '{who} teleported to you.', staffName)
        notify(src, 'Teleported to ' .. name)
    elseif data.action == 'spectate' then
        if target == src then notify(src, 'You cannot spectate yourself.') return end
        HelmStartSpectate(src, target)
        HelmTellPlayer(target, 'spectate', '{who} is spectating you.', staffName)
        notify(src, 'Spectating ' .. name)
    elseif data.action == 'bring' then
        local c = GetEntityCoords(GetPlayerPed(src))
        HelmRememberPosition(target)
        TriggerClientEvent('helm:client:teleport', target, c.x, c.y, c.z)
        HelmTellPlayer(target, 'bring', '{who} brought you to them.', staffName)
        notify(src, 'Brought ' .. name)
    elseif data.action == 'freeze' then
        local on = not HelmIsFrozen(target)
        HelmFreeze(target, on, staffName)
        notify(src, (on and 'Froze ' or 'Unfroze ') .. name)
    elseif data.action == 'heal' then
        HelmHeal(target, staffName)
        notify(src, 'Healed ' .. name)
    elseif data.action == 'sendback' then
        local ok, err = HelmSendBack(target, staffName)
        notify(src, ok and ('Sent ' .. name .. ' back') or ('Could not send ' .. name .. ' back: ' .. err))
    elseif data.action == 'message' then
        HelmMessage(target, reason, staffName)
        notify(src, 'Message sent to ' .. name)
    else
        -- warn / kick / ban / revive are queued by the panel and run on the next poll.
        notify(src, ('%s applied to %s (takes effect within a few seconds)'):format(data.action, name))
    end
end)

-- ---------------------------------------------------------------------------
-- Reports tab. The panel decides who may see (reports.view) and handle (reports.manage) reports.
-- ---------------------------------------------------------------------------

local reportCache = {} -- staff src -> { [report id] = report } from the last list, for "go to location"
local REPORT_ACTS = { claim = true, unclaim = true, reply = true, close = true }

local function sendReports(src)
    local res = HelmApi('POST', '/api/game/staff-reports', { actorIdentifiers = HelmIdentifiers(src), op = 'list' })
    if res.status ~= 200 or not res.data or not res.data.ok then
        local err = (res.data and res.data.error) or ('panel returned ' .. tostring(res.status))
        TriggerClientEvent('helm:client:reports', src, { error = err })
        return
    end
    local byId = {}
    for _, r in ipairs(res.data.reports or {}) do byId[r.id] = r end
    reportCache[src] = byId
    TriggerClientEvent('helm:client:reports', src, { reports = res.data.reports or {} })
end

RegisterNetEvent('helm:server:reports', function()
    local src = source
    local now = GetGameTimer()
    if lastAction[src] and (now - lastAction[src]) < 1000 then return end
    lastAction[src] = now
    sendReports(src)
end)

RegisterNetEvent('helm:server:reportAction', function(data)
    local src = source
    if type(data) ~= 'table' or type(data.id) ~= 'string' then return end
    local now = GetGameTimer()
    if lastAction[src] and (now - lastAction[src]) < 1000 then return end
    lastAction[src] = now

    -- Go to where the reporter was when they sent it: only for reports from this server, with teleport rights.
    if data.action == 'goto' then
        local info = staffInfo(src)
        local r = reportCache[src] and reportCache[src][data.id]
        if not info or not info.caps or not info.caps['goto'] then notify(src, 'You do not have permission to teleport.') return end
        if not r or not r.here or type(r.position) ~= 'table' then notify(src, 'That report has no location on this server.') return end
        TriggerClientEvent('helm:client:teleport', src, tonumber(r.position.x) or 0, tonumber(r.position.y) or 0, tonumber(r.position.z) or 0)
        return
    end

    if not REPORT_ACTS[data.action] then return end
    local act = { action = data.action }
    if data.action == 'reply' then
        if type(data.text) ~= 'string' or data.text:match('^%s*$') then notify(src, 'Type a reply first.') return end
        act.text = data.text:sub(1, 300)
    elseif data.action == 'close' and type(data.text) == 'string' and not data.text:match('^%s*$') then
        act.note = data.text:sub(1, 300)
    end

    local res = HelmApi('POST', '/api/game/staff-reports', { actorIdentifiers = HelmIdentifiers(src), op = 'act', id = data.id, act = act })
    if res.status ~= 200 or not res.data or not res.data.ok then
        local err = (res.data and res.data.error) or ('panel returned ' .. tostring(res.status))
        TriggerClientEvent('helm:client:staffNotice', src, 'Report', 'Failed: ' .. err)
        return
    end
    local ref = res.data.ref or ''
    local done = ({ claim = 'claimed', unclaim = 'released', reply = 'replied to', close = 'closed' })[data.action]
    local extra = ''
    if (data.action == 'reply' or data.action == 'close') and res.data.delivered == false then extra = ' The player is offline, so they were not told in game.' end
    TriggerClientEvent('helm:client:staffNotice', src, 'Report ' .. ref, ('Report %s %s.%s'):format(ref, done, extra))
    sendReports(src)
end)

AddEventHandler('playerDropped', function() reportCache[source] = nil end)

-- ---------------------------------------------------------------------------
-- Staff tools (Tools tab, /helmnoclip). Allowed by the staff member's panel role, and written to the activity log.
-- ---------------------------------------------------------------------------

local TOOLS = {
    noclip = { cap = 'noclip', label = 'Toggled noclip' },
    waypoint = { cap = 'goto', label = 'Teleported to waypoint' },
    fixvehicle = { cap = 'vehicles', label = 'Fixed a vehicle' },
    deletevehicle = { cap = 'vehicles', label = 'Deleted a vehicle' },
    -- Run here on the server, around the staff member.
    cleanupvehicles = { cap = 'cleanup', server = function(src, c) return ('Deleted %d empty vehicles within 50 m'):format(HelmCleanupVehicles(c, 50.0)) end },
    cleanupprops = { cap = 'cleanup', server = function(src, c) return ('Deleted %d spawned props within 30 m'):format(HelmCleanupProps(c, 30.0)) end },
    revivenearby = { cap = 'reviveNearby', server = function(src, c, by) return ('Revived %d players within 30 m'):format(HelmReviveNearby(c, 30.0, by)) end },
}

RegisterNetEvent('helm:server:selfTool', function(tool)
    local src = source
    local t = type(tool) == 'string' and TOOLS[tool]
    if not t then return end
    local now = GetGameTimer()
    if lastAction[src] and (now - lastAction[src]) < 500 then return end
    lastAction[src] = now

    local info, reason = staffInfo(src)
    if not info then
        notify(src, reason or NOT_LINKED)
        return
    end
    if not info.caps or not info.caps[t.cap] then
        TriggerClientEvent('helm:client:staffNotice', src, 'Staff tools', 'Your panel role does not allow that.')
        return
    end
    if t.server then
        local done = t.server(src, GetEntityCoords(GetPlayerPed(src)), info.name)
        pcall(function() exports[GetCurrentResourceName()]:Log(src, 'custom', 'staff_' .. tool, done) end)
        TriggerClientEvent('helm:client:staffNotice', src, 'Clean-up', done)
        return
    end
    exports[GetCurrentResourceName()]:Log(src, 'custom', 'staff_' .. tool, t.label)
    TriggerClientEvent('helm:client:selfTool', src, tool)
end)


CreateThread(function()
    local last = IsNuiFocused()
    while true do
        local now = IsNuiFocused()
        if now ~= last then
            print(('NUI focus changed: %s -> %s at %d'):format(tostring(last), tostring(now), GetGameTimer()))
            last = now
        end
        Wait(100)
    end
end)