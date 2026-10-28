local QBX = exports.qbx_core

local function makeRef()
    local date = os.date('%Y%m%d')
    local count = MySQL.single.await(
        'SELECT COUNT(*) n FROM uk_complaints WHERE LEFT(reference,8) = ?', {date}
    )
    return string.format('COMP-%s-%04d', date, (count and count.n or 0) + 1)
end

local function canAccess(ply, lvl)
    local p = QBX:GetPlayer(ply)
    return p and p.PlayerData.job.name == Config.PoliceJobName and
           p.PlayerData.job.grade.level >= lvl
end

lib.callback.register('uk_complaints:submit', function(src, data)
    local ply = QBX:GetPlayer(src)
    if not ply then return end

    local recent = MySQL.single.await(
        'SELECT COUNT(*) n FROM uk_complaints WHERE citizen_id = ? AND submitted_at > NOW() - INTERVAL 1 HOUR',
        {ply.PlayerData.citizenid}
    )
    if recent and recent.n >= Config.MaxPerHour then
        TriggerClientEvent('uk_complaints:notify', src, 'Max complaints per hour reached.', 'error')
        return
    end

    local ref = makeRef()
    local anon = data.anonymous and 1 or 0
    local name = anon == 1 and 'Anonymous' or
        ply.PlayerData.charinfo.firstname .. ' ' .. ply.PlayerData.charinfo.lastname

    MySQL.insert('INSERT INTO uk_complaints \
        (reference, citizen_id, citizen_name, category, title, location, contact, description, anonymous) \
        VALUES (?,?,?,?,?,?,?,?,?)', {
        ref, ply.PlayerData.citizenid, name, data.category, data.title,
        data.location or 'Not specified', data.contact or 'Not provided', data.desc, anon
    })

    if Config.DiscordWebhook ~= '' then
        PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST', json.encode({
            embeds = {{
                title = '📩 New Complaint Lodged',
                fields = {
                    {name='Reference', value=ref, inline=true},
                    {name='From', value=name, inline=true},
                    {name='Category', value=data.category},
                    {name='Details', value=data.desc:sub(1,1024)}
                },
                color = 16766720
            }}
        }), {['Content-Type']='application/json'})
    end

    TriggerClientEvent('uk_complaints:notify', src,
        'Lodged ✅ Ref: '..ref..'\nWe aim to respond within 10 working days.', 'success')
    return ref
end)

RegisterNetEvent('uk_complaints:requestAccess', function()
    if not canAccess(source, Config.Permissions.ReviewAccess) then
        TriggerClientEvent('uk_complaints:notify', source, 'Sergeant+ required.', 'error')
        return
    end
    TriggerClientEvent('uk_complaints:openPanel', source)
end)

lib.callback.register('uk_complaints:requestData', function(src)
    if not canAccess(src, Config.Permissions.ReviewAccess) then return {} end
    local res = MySQL.query.await('SELECT * FROM uk_complaints ORDER BY submitted_at DESC LIMIT 100')
    for _,r in ipairs(res or {}) do
        r.created_at = r.submitted_at
        r.officer_name = r.updated_by or 'Unassigned'
    end
    return res or {}
end)

lib.callback.register('uk_complaints:setStatus', function(src, id, status)
    local ply = QBX:GetPlayer(src)
    if not ply or ply.PlayerData.job.name ~= Config.PoliceJobName then return false end
    if (status == 'psd' or status == 'iopc') and
       ply.PlayerData.job.grade.level < Config.Permissions.PSDAccess then
        TriggerClientEvent('uk_complaints:notify', src, 'Inspector+ required for this action.', 'error')
        return false
    end
    local who = ply.PlayerData.charinfo.lastname..' ('..ply.PlayerData.citizenid:sub(1,4)..')'
    MySQL.update('UPDATE uk_complaints SET status=?, updated_by=?, updated_at=NOW() WHERE id=?',
        {status, who, id})
    return true
end)

lib.callback.register('uk_complaints:addNote', function(src, id, note)
    if not canAccess(src, Config.Permissions.ReviewAccess) then return false end
    local ply = QBX:GetPlayer(src)
    local who = ply.PlayerData.charinfo.lastname..' ('..ply.PlayerData.citizenid:sub(1,4)..')'
    local stamp = os.date('%d/%m %H:%M')..' — '..who
    MySQL.update(
        'UPDATE uk_complaints SET officer_note=CONCAT(IFNULL(officer_note,""),?), updated_by=?, updated_at=NOW() WHERE id=?',
        {'\n['..stamp..']\n'..note..'\n', who, id}
    )
    return true
end)