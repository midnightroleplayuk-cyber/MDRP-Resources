local QBX = exports.qbx_core

local categories = {
    ['Officer Conduct / Behaviour'] = true,
    ['Standard of Service Provided'] = true,
    ['Unreasonable Delay or Omission'] = true,
    ['Discourtesy or Unfair Treatment'] = true,
    ['Equipment / Resources'] = true,
    ['Other Matter'] = true
}

local allowedStatuses = {
    submitted = true,
    reviewed = true,
    psd = true,
    iopc = true,
    closed = true
}

local anonymousSubmissions = {}

local function trim(value)
    return value:match('^%s*(.-)%s*$')
end

local function notify(src, message, kind)
    TriggerClientEvent('uk_complaints:notify', src, message, kind)
end

local function getPlayer(src)
    return QBX:GetPlayer(src)
end

local function canAccess(src, minimumGrade)
    local player = getPlayer(src)
    local job = player and player.PlayerData.job
    return job and job.name == Config.PoliceJobName and
        job.grade and job.grade.level >= minimumGrade
end

local function makeReference()
    return ('COMP-%s-%06d'):format(os.date('%Y%m%d'), math.random(0, 999999))
end

local function validText(value, maxLength, required)
    if type(value) ~= 'string' then return nil end
    local result = trim(value)
    if #result > maxLength or (required and result == '') then return nil end
    return result
end

lib.callback.register('uk_complaints:submit', function(src, data)
    if type(data) ~= 'table' then
        return { ok = false, message = 'Please check the form and try again.' }
    end

    local player = getPlayer(src)
    if not player then
        return { ok = false, message = 'Your character could not be verified.' }
    end

    local category = type(data.category) == 'string' and data.category or ''
    local title = validText(data.title, Config.MaxTitleLength, true)
    local description = validText(data.desc, Config.MaxDescLength, true)
    local location = validText(data.location or '', Config.MaxLocLength, false)
    local contact = validText(data.contact or '', Config.MaxContactLength, false)
    local anonymous = data.anonymous == true

    if not categories[category] or not title or not description or not location or not contact then
        return { ok = false, message = 'Please complete the required fields and check their length.' }
    end

    local citizenId = player.PlayerData.citizenid
    if not anonymous then
        local recent = MySQL.single.await(
            'SELECT COUNT(*) AS n FROM uk_complaints WHERE citizen_id = ? AND submitted_at > NOW() - INTERVAL 1 HOUR',
            { citizenId }
        )
        if recent and (tonumber(recent.n) or 0) >= Config.MaxPerHour then
            return { ok = false, message = 'You have reached the hourly complaint limit. Please try again later.' }
        end
    else
        local now = os.time()
        local submissions = anonymousSubmissions[src] or {}
        local recent = {}
        for _, timestamp in ipairs(submissions) do
            if now - timestamp < 3600 then recent[#recent + 1] = timestamp end
        end
        if #recent >= Config.MaxPerHour then
            anonymousSubmissions[src] = recent
            return { ok = false, message = 'You have reached the hourly complaint limit. Please try again later.' }
        end
        recent[#recent + 1] = now
        anonymousSubmissions[src] = recent
    end

    local character = player.PlayerData.charinfo or {}
    local citizenName = anonymous and 'Anonymous' or
        trim(('%s %s'):format(character.firstname or '', character.lastname or ''))
    local reference = makeReference()
    local storedCitizenId = anonymous and '' or citizenId
    local storedContact = anonymous and '' or contact

    local ok, insertId = pcall(function()
        return MySQL.insert.await(
            'INSERT INTO uk_complaints (reference, citizen_id, citizen_name, category, title, location, contact, description, anonymous) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
            {
                reference, storedCitizenId, citizenName, category, title,
                location ~= '' and location or 'Not specified',
                storedContact, description, anonymous and 1 or 0
            }
        )
    end)

    if not ok or not insertId then
        print(('[uk_complaints] Failed to save submission for player %s'):format(src))
        return { ok = false, message = 'Your complaint could not be saved. Please try again.' }
    end

    if Config.DiscordWebhook ~= '' then
        PerformHttpRequest(Config.DiscordWebhook, function(status)
            if not status or status < 200 or status >= 300 then
                print(('[uk_complaints] Discord webhook returned HTTP %s'):format(status))
            end
        end, 'POST', json.encode({
            embeds = {{
                title = 'New Police Complaint',
                fields = {
                    { name = 'Reference', value = reference, inline = true },
                    { name = 'From', value = citizenName, inline = true },
                    { name = 'Category', value = category },
                    { name = 'Details', value = description:sub(1, 1024) }
                },
                color = 16766720
            }}
        }), { ['Content-Type'] = 'application/json' })
    end

    return {
        ok = true,
        reference = reference,
        message = ('Your complaint has been lodged. Reference: %s. We aim to respond within 10 working days.'):format(reference)
    }
end)

RegisterNetEvent('uk_complaints:requestAccess', function()
    local src = source
    if not canAccess(src, Config.Permissions.ReviewAccess) then
        notify(src, 'You do not have permission to access complaint reviews.', 'error')
        return
    end
    TriggerClientEvent('uk_complaints:openPanel', src)
end)

lib.callback.register('uk_complaints:requestData', function(src)
    if not canAccess(src, Config.Permissions.ReviewAccess) then
        return {}
    end

    local rows = MySQL.query.await('SELECT * FROM uk_complaints ORDER BY submitted_at DESC LIMIT 100')
    for _, row in ipairs(rows or {}) do
        row.created_at = row.submitted_at
        row.officer_name = row.updated_by or 'Unassigned'
    end
    return rows or {}
end)

lib.callback.register('uk_complaints:setStatus', function(src, id, status)
    if not canAccess(src, Config.Permissions.ReviewAccess) then
        return { ok = false, message = 'You do not have permission to update complaints.' }
    end
    if type(id) ~= 'number' or id < 1 or id % 1 ~= 0 or not allowedStatuses[status] then
        return { ok = false, message = 'Invalid complaint or status.' }
    end
    if (status == 'psd' or status == 'iopc') and not canAccess(src, Config.Permissions.PSDAccess) then
        return { ok = false, message = 'Inspector rank or higher is required for this referral.' }
    end

    local player = getPlayer(src)
    local who = ('%s (%s)'):format(
        (player.PlayerData.charinfo or {}).lastname or 'Officer',
        tostring(player.PlayerData.citizenid or ''):sub(1, 4)
    )
    local changed = MySQL.update.await(
        'UPDATE uk_complaints SET status = ?, updated_by = ?, updated_at = NOW() WHERE id = ?',
        { status, who, id }
    )
    if not changed or changed < 1 then
        return { ok = false, message = 'Complaint not found or status unchanged.' }
    end
    return { ok = true, message = 'Complaint status updated.' }
end)

lib.callback.register('uk_complaints:addNote', function(src, id, note)
    if not canAccess(src, Config.Permissions.ReviewAccess) then
        return { ok = false, message = 'You do not have permission to add review notes.' }
    end
    if type(id) ~= 'number' or id < 1 or id % 1 ~= 0 then
        return { ok = false, message = 'Invalid complaint.' }
    end

    local cleanNote = validText(note, Config.MaxNoteLength, true)
    if not cleanNote then
        return { ok = false, message = 'Enter a note of up to 1,000 characters.' }
    end

    local player = getPlayer(src)
    local who = ('%s (%s)'):format(
        (player.PlayerData.charinfo or {}).lastname or 'Officer',
        tostring(player.PlayerData.citizenid or ''):sub(1, 4)
    )
    local stamp = os.date('%d/%m/%Y %H:%M') .. ' - ' .. who
    local changed = MySQL.update.await(
        'UPDATE uk_complaints SET officer_note = CONCAT(IFNULL(officer_note, ""), ?), updated_by = ?, updated_at = NOW() WHERE id = ?',
        { ('\n[%s]\n%s\n'):format(stamp, cleanNote), who, id }
    )
    if not changed or changed < 1 then
        return { ok = false, message = 'Complaint not found; the note was not saved.' }
    end
    return { ok = true, message = 'Review note added.' }
end)

AddEventHandler('playerDropped', function()
    anonymousSubmissions[source] = nil
end)
