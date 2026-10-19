-- ============================================================
-- Reports Center — server store
-- In-memory store (with optional MySQL persistence below) for
-- player reports and the conversation that follows. Designed to
-- be triggered from the new client/reports.lua and the NUI.
-- ============================================================

local Reports        = {} -- [id] = report
local Messages       = {} -- [id] = { msg, msg, ... }
local NextId         = 1
local StaffOnDuty    = {} -- [src] = true  (admins in staff mode)
local CurrentAssist  = {} -- [src] = reportId
local Cooldowns      = {} -- [identifier] = lastTimestamp

-- Both come from Config.Reports (configs/config.lua) and fall back to the
-- previous hardcoded defaults if the config block is missing.
local COOLDOWN_SECS  = (Config.Reports and tonumber(Config.Reports.Cooldown)) or 30
local MAX_MESSAGES   = (Config.Reports and tonumber(Config.Reports.MaxMessages)) or 200

-- ── Utility ────────────────────────────────────────────────
local function now() return os.time() end

local function getPlayerLabel(src)
    local p = GetPlayer(src)
    if p and Framework == 'qb' and p.PlayerData and p.PlayerData.charinfo then
        return ('%s %s'):format(p.PlayerData.charinfo.firstname or '', p.PlayerData.charinfo.lastname or '')
    elseif p and Framework == 'esx' and p.getName then
        return p.getName()
    end
    return GetPlayerName(src) or ('ID ' .. src)
end

local function publicReport(r)
    if not r then return nil end
    return {
        id          = r.id,
        category    = r.category,
        subject     = r.subject,
        details     = r.details,
        playerId    = r.playerId,
        playerName  = r.playerName,
        identifier  = r.identifier,
        createdAt   = r.createdAt,
        assistedBy  = r.assistedBy,
        assistedName= r.assistedName,
        resolved    = r.resolved or false,
        resolvedBy  = r.resolvedBy,
        resolvedAt  = r.resolvedAt
    }
end

local function snapshot()
    local list = {}
    for _, r in pairs(Reports) do list[#list + 1] = publicReport(r) end
    table.sort(list, function(a, b) return a.id > b.id end)
    return list
end

local function broadcastToAdmins()
    local list = snapshot()
    for src in pairs(StaffOnDuty) do
        TriggerClientEvent('apex_adminmenu:reports:syncList', src, list)
    end
end

local function pushToReporter(src)
    if not src then return end
    local list = {}
    for _, r in pairs(Reports) do
        if r.playerId == src then list[#list + 1] = publicReport(r) end
    end
    TriggerClientEvent('apex_adminmenu:reports:syncList', src, list)
end

local function staffHudSync(src)
    local active = {}
    for _, r in pairs(Reports) do
        if not r.resolved then active[#active + 1] = publicReport(r) end
    end
    table.sort(active, function(a, b) return a.id < b.id end)
    TriggerClientEvent('apex_adminmenu:reports:staffSync', src, active, CurrentAssist[src])
end

local function staffHudSyncAll()
    for src in pairs(StaffOnDuty) do staffHudSync(src) end
end

-- ── Fetch callback ─────────────────────────────────────────
lib.callback.register('apex_adminmenu:reports:fetch', function(source)
    local isAdmin = AdminPerms(source) or false
    local list = {}

    if isAdmin then
        list = snapshot()
    else
        for _, r in pairs(Reports) do
            if r.playerId == source then list[#list + 1] = publicReport(r) end
        end
        table.sort(list, function(a, b) return a.id > b.id end)
    end

    return {
        reports   = list,
        isAdmin   = isAdmin,
        staffMode = StaffOnDuty[source] == true
    }
end)

-- Returns the open (non-resolved) report owned by the given source, if any.
local function findOpenReportFor(src)
    for _, r in pairs(Reports) do
        if r.playerId == src and not r.resolved then return r end
    end
    return nil
end

-- ── Submit new report ──────────────────────────────────────
RegisterNetEvent('apex_adminmenu:reports:submit', function(category, subject, details)
    local src = source
    if not GetPlayer(src) then return end

    category = ({ player_report = true, question = true, bug = true })[category] and category or 'question'
    subject  = tostring(subject or ''):sub(1, 100)
    details  = tostring(details or ''):sub(1, 800)
    if subject == '' or details == '' then return end

    -- One open report per player. If they already have one, just open it.
    local existing = findOpenReportFor(src)
    if existing then
        TriggerClientEvent('apex_adminmenu:notify', src,
            'Reports', 'You already have an open report. Continue the conversation there.', 'error')
        TriggerClientEvent('apex_adminmenu:reports:openDetail', src,
            publicReport(existing), Messages[existing.id] or {})
        return
    end

    -- Cooldown per identifier
    local id = GetIdentifier and GetIdentifier(src) or ('source:' .. src)
    if Cooldowns[id] and (now() - Cooldowns[id]) < COOLDOWN_SECS then
        TriggerClientEvent('apex_adminmenu:notify', src,
            'Reports', 'Please wait a moment before sending another report.', 'error')
        return
    end
    Cooldowns[id] = now()

    local r = {
        id         = NextId,
        category   = category,
        subject    = subject,
        details    = details,
        playerId   = src,
        playerName = getPlayerLabel(src),
        identifier = id,
        createdAt  = now(),
        resolved   = false
    }
    NextId = NextId + 1
    Reports[r.id] = r
    Messages[r.id] = {
        { system = true, text = ('Report opened — %s'):format(r.subject), time = now() },
        { author = r.playerName, text = details, time = now() }
    }

    TriggerClientEvent('apex_adminmenu:notify', src,
        'Report sent', 'Staff has been notified. Keep this menu open to chat.',
        'success', 'fa-check')

    -- Push to reporter so they see the new report in the list.
    pushToReporter(src)

    -- Drop the reporter straight into the chat for their report.
    TriggerClientEvent('apex_adminmenu:reports:openDetail', src, publicReport(r), Messages[r.id])

    -- Notify admins.
    broadcastToAdmins()
    for staffSrc in pairs(StaffOnDuty) do
        TriggerClientEvent('apex_adminmenu:reports:notifyAdmin', staffSrc, publicReport(r))
    end
    staffHudSyncAll()

    -- Discord log.
    SendDiscordLog(
        'New Report #' .. r.id,
        ('**%s**\n%s'):format(r.subject, r.details),
        {
            { name = 'Player',   value = ('%s (ID %d)'):format(r.playerName, src), inline = true },
            { name = 'Category', value = r.category, inline = true }
        },
        'utilityActions'
    )
end)

-- ── Open detail (push full convo to requester) ─────────────
RegisterNetEvent('apex_adminmenu:reports:openDetail', function(id)
    local src = source
    local r = Reports[id]
    if not r then return end

    -- Permission: admin OR the original reporter.
    if not AdminPerms(src) and r.playerId ~= src then return end

    TriggerClientEvent('apex_adminmenu:reports:openDetail', src, publicReport(r), Messages[id] or {})
end)

-- Deliver a message to sender + reporter + every on-duty admin. Uses
-- latent events so large image payloads don't trip the network limit.
local function deliverMessage(id, msg)
    local r = Reports[id]; if not r then return end

    Messages[id] = Messages[id] or {}
    Messages[id][#Messages[id] + 1] = msg

    -- Cap the history so a long-running report can't grow without bound
    -- (images are inlined as data URIs, so this is a real memory concern).
    while #Messages[id] > MAX_MESSAGES do
        table.remove(Messages[id], 1)
    end

    local KBPS = 256 * 1024 -- latent event throttle (256 KB/s)

    local function send(target, isSelf)
        if msg.image then
            TriggerLatentClientEvent('apex_adminmenu:reports:message', target, KBPS, id, {
                author = msg.author, staff = msg.staff,
                text = msg.text, image = msg.image,
                time = msg.time, self = isSelf or false
            })
        else
            TriggerClientEvent('apex_adminmenu:reports:message', target, id, {
                author = msg.author, staff = msg.staff,
                text = msg.text, image = msg.image,
                time = msg.time, self = isSelf or false
            })
        end
    end

    -- Echo to sender.
    if msg.senderSrc then send(msg.senderSrc, true) end

    -- Send to reporter (if not the sender).
    if r.playerId ~= msg.senderSrc then
        send(r.playerId, false)
        TriggerClientEvent('apex_adminmenu:reports:notifyPlayer', r.playerId,
            ('Reply on report #%d'):format(id))
    end

    -- Send to all admins watching.
    for staffSrc in pairs(StaffOnDuty) do
        if staffSrc ~= msg.senderSrc and staffSrc ~= r.playerId then
            send(staffSrc, false)
        end
    end
end

-- ── Send chat message ──────────────────────────────────────
RegisterNetEvent('apex_adminmenu:reports:message', function(id, text, image)
    local src = source
    local r = Reports[id]
    if not r then return end
    if not AdminPerms(src) and r.playerId ~= src then return end

    text = tostring(text or ''):sub(1, 500)
    -- NOTE: do NOT truncate `image` here — a data URI is tens of KB.
    -- It is sanity-checked by length below.
    if type(image) ~= 'string' or image == '' then image = nil end
    if image and #image > 2 * 1024 * 1024 then image = nil end -- 2 MB hard cap
    if text == '' and not image then return end

    local isStaff = AdminPerms(src) and r.playerId ~= src
    deliverMessage(id, {
        author    = getPlayerLabel(src),
        staff     = isStaff,
        text      = (text ~= '' and text) or nil,
        image     = image,
        time      = now(),
        senderSrc = src
    })
end)

-- ── Chunked screenshot upload ─────────────────────────────
-- The client splits the base64 data URI into 60 KB chunks and posts
-- them sequentially. We buffer them per (source, reportId, token) and
-- once all are in, deliver as a normal image message.
local ImgBuffers = {} -- [key] = { total, received, parts = {} }

RegisterNetEvent('apex_adminmenu:reports:imgChunk', function(reportId, token, idx, total, part)
    local src = source
    local r = Reports[reportId]; if not r then return end
    if not AdminPerms(src) and r.playerId ~= src then return end
    if type(token) ~= 'string' or type(part) ~= 'string' then return end
    if total < 1 or total > 200 then return end -- ~12 MB hard limit

    local key = src .. ':' .. reportId .. ':' .. token
    local buf = ImgBuffers[key]
    if not buf then
        buf = { total = total, received = 0, parts = {}, started = now() }
        ImgBuffers[key] = buf
    end
    if buf.parts[idx] then return end -- duplicate
    buf.parts[idx] = part
    buf.received = buf.received + 1

    if buf.received >= buf.total then
        local assembled = table.concat(buf.parts)
        ImgBuffers[key] = nil

        local isStaff = AdminPerms(src) and r.playerId ~= src
        deliverMessage(reportId, {
            author    = getPlayerLabel(src),
            staff     = isStaff,
            text      = nil,
            image     = assembled,
            time      = now(),
            senderSrc = src
        })
    end
end)

-- Clean stale buffers periodically (orphaned uploads).
CreateThread(function()
    while true do
        Wait(60 * 1000)
        local cutoff = now() - 60
        for k, buf in pairs(ImgBuffers) do
            if buf.started < cutoff then ImgBuffers[k] = nil end
        end
    end
end)

-- ── Assist / Resolve ──────────────────────────────────────
RegisterNetEvent('apex_adminmenu:reports:assist', function(id)
    local src = source
    if not AdminPerms(src) then return end
    local r = Reports[id]; if not r then return end

    r.assistedBy   = src
    r.assistedName = getPlayerLabel(src)
    CurrentAssist[src] = id

    Messages[id] = Messages[id] or {}
    Messages[id][#Messages[id] + 1] = { system = true, text = r.assistedName .. ' is assisting this report.', time = now() }

    -- Notify both sides + sync list.
    TriggerClientEvent('apex_adminmenu:reports:notifyPlayer', r.playerId,
        r.assistedName .. ' is helping with your report.')

    broadcastToAdmins()
    pushToReporter(r.playerId)
    staffHudSyncAll()

    SendDiscordLog(
        'Assist Report #' .. r.id,
        ('Admin %s started assisting'):format(r.assistedName),
        {
            { name = 'Subject', value = r.subject, inline = false },
            { name = 'Player',  value = r.playerName, inline = true }
        },
        'utilityActions'
    )
end)

RegisterNetEvent('apex_adminmenu:reports:resolve', function(id)
    local src = source
    if not AdminPerms(src) then return end
    local r = Reports[id]; if not r then return end

    r.resolved   = true
    r.resolvedBy = getPlayerLabel(src)
    r.resolvedAt = now()
    if CurrentAssist[src] == id then CurrentAssist[src] = nil end

    Messages[id] = Messages[id] or {}
    Messages[id][#Messages[id] + 1] = { system = true, text = 'Resolved by ' .. r.resolvedBy, time = now() }

    TriggerClientEvent('apex_adminmenu:reports:notifyPlayer', r.playerId,
        'Your report has been resolved. Thank you!')

    broadcastToAdmins()
    pushToReporter(r.playerId)
    staffHudSyncAll()

    SendDiscordLog(
        'Resolve Report #' .. r.id,
        ('Resolved by %s'):format(r.resolvedBy),
        { { name = 'Subject', value = r.subject } },
        'utilityActions'
    )
end)

RegisterNetEvent('apex_adminmenu:reports:resolveCurrent', function()
    local src = source
    if not AdminPerms(src) then return end
    local id = CurrentAssist[src]
    if not id then
        TriggerClientEvent('apex_adminmenu:notify', src,
            'Reports', 'You are not assisting any report.', 'error')
        return
    end
    TriggerEvent('apex_adminmenu:reports:resolve', id)
end)

-- Accept the next pending (or currently-being-assisted) report:
-- prefer the one this admin is already on; otherwise pick the oldest
-- unassisted, unresolved report.
RegisterNetEvent('apex_adminmenu:reports:acceptNext', function()
    local src = source
    if not AdminPerms(src) then return end

    -- If they're already assisting one, just reopen its detail.
    local target = CurrentAssist[src]
    if target and Reports[target] and not Reports[target].resolved then
        TriggerClientEvent('apex_adminmenu:reports:openDetail', src,
            publicReport(Reports[target]), Messages[target] or {})
        return
    end

    -- Find oldest unresolved without an assigned admin.
    local pick
    for _, r in pairs(Reports) do
        if not r.resolved and not r.assistedBy then
            if not pick or r.id < pick.id then pick = r end
        end
    end

    if not pick then
        TriggerClientEvent('apex_adminmenu:notify', src,
            'Reports', 'No pending reports to accept.', 'info')
        return
    end

    -- Assist + auto-open detail.
    pick.assistedBy   = src
    pick.assistedName = getPlayerLabel(src)
    CurrentAssist[src] = pick.id

    Messages[pick.id] = Messages[pick.id] or {}
    Messages[pick.id][#Messages[pick.id] + 1] = {
        system = true,
        text   = pick.assistedName .. ' is assisting this report.',
        time   = now()
    }

    TriggerClientEvent('apex_adminmenu:reports:notifyPlayer', pick.playerId,
        pick.assistedName .. ' is helping with your report.')

    broadcastToAdmins()
    pushToReporter(pick.playerId)
    staffHudSyncAll()

    -- Open the chat in the admin's UI.
    TriggerClientEvent('apex_adminmenu:reports:openDetail', src,
        publicReport(pick), Messages[pick.id] or {})

    SendDiscordLog(
        'Assist Report #' .. pick.id,
        ('Admin %s started assisting (hotkey)'):format(pick.assistedName),
        {
            { name = 'Subject', value = pick.subject, inline = false },
            { name = 'Player',  value = pick.playerName, inline = true }
        },
        'utilityActions'
    )
end)

-- ── TP / Bring ────────────────────────────────────────────
RegisterNetEvent('apex_adminmenu:reports:teleport', function(id)
    local src = source
    if not AdminPerms(src) then return end
    local r = Reports[id]; if not r then return end
    local targetPed = GetPlayerPed(r.playerId)
    if targetPed == 0 then return end
    local coords = GetEntityCoords(targetPed)
    TriggerClientEvent('apex_adminmenu:reports:teleportTo', src,
        { x = coords.x, y = coords.y, z = coords.z })
end)

RegisterNetEvent('apex_adminmenu:reports:bring', function(id)
    local src = source
    if not AdminPerms(src) then return end
    local r = Reports[id]; if not r then return end
    local adminPed = GetPlayerPed(src)
    if adminPed == 0 then return end
    local coords = GetEntityCoords(adminPed)
    TriggerClientEvent('apex_adminmenu:reports:teleportTo', r.playerId,
        { x = coords.x, y = coords.y, z = coords.z })
    TriggerClientEvent('apex_adminmenu:reports:notifyPlayer', r.playerId,
        'You were teleported by staff for your report.')
end)

-- ── Staff mode ────────────────────────────────────────────
RegisterNetEvent('apex_adminmenu:reports:staffMode', function(enabled)
    local src = source
    if not AdminPerms(src) then return end

    if enabled then
        StaffOnDuty[src] = true
        TriggerClientEvent('apex_adminmenu:notify', src,
            'Reports Mode', 'You will now receive report alerts.', 'success')
    else
        StaffOnDuty[src] = nil
        CurrentAssist[src] = nil
        TriggerClientEvent('apex_adminmenu:notify', src,
            'Reports Mode', 'Disabled.', 'info')
    end

    local active = {}
    for _, r in pairs(Reports) do
        if not r.resolved then active[#active + 1] = publicReport(r) end
    end
    TriggerClientEvent('apex_adminmenu:reports:staffModeState', src, enabled, active, CurrentAssist[src])
end)

-- ── Disconnect cleanup ────────────────────────────────────
AddEventHandler('playerDropped', function()
    local src = source
    StaffOnDuty[src] = nil
    CurrentAssist[src] = nil
end)

-- ── Public helpers ─────────────────────────────────────────
-- The Home dashboard needs the open-report count. Reports live in
-- memory (there is no apex_reports table), so expose a getter rather
-- than letting the panel query a table that does not exist.
function ApexOpenReportCount()
    local n = 0
    for _, r in pairs(Reports) do
        if not r.resolved then n = n + 1 end
    end
    return n
end
