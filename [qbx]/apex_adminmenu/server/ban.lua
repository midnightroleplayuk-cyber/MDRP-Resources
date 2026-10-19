local function extractIdentifiers(src)
    local identifiers = { ip = '', discord = '', license = '' }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, 'ip') then
            identifiers.ip = id
        elseif string.find(id, 'discord') then
            identifiers.discord = id
        elseif string.find(id, 'license') then
            identifiers.license = id
        end
    end
    return identifiers
end

-- PERMANENT is stored as -1, not the string 'perm'.
-- `exp_time` is an INT column: writing 'perm' into it made MySQL coerce
-- the value to 0, and 0 reads back as "expired in 1970", so permanent
-- bans silently let the player reconnect. -1 is unambiguous, and every
-- read site below treats anything <= 0 as permanent so rows written by
-- older builds keep working.
BAN_PERMANENT = -1

--- True when a stored exp_time means "never expires".
function IsPermanentBan(expTime)
    if expTime == 'perm' then return true end
    local n = tonumber(expTime)
    return n == nil or n <= 0
end

local function getBanExpire(currentTime, hours)
    if hours == 'perm' or tonumber(hours) == nil then
        return BAN_PERMANENT
    end

    local hour = 3600
    local time = hour * tonumber(hours)
    return currentTime + time
end

local function splitTime(seconds)
    local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

    if seconds <= 0 then
        return 0, 0
    else
        local hours = string.format('%02.f', math.floor(seconds / 3600))
        local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
        local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

        return hours, mins
    end
end

BanPlayer = function(target, time, reason, source)
    local identifiers = extractIdentifiers(target)
    local author = GetPlayerName(source)
    local player = GetPlayerName(target)
    local license = identifiers.license
    local ip = identifiers.ip
    local discord = identifiers.discord
    local reason = reason or ''
    local currentTime = os.time()
    local banExp = getBanExpire(currentTime, time)
    
    MySQL.insert(
        'INSERT INTO apex_bans (author, player, license, ip, discord, reason, ban_time, exp_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        {author, player, license, ip, discord, reason, currentTime, banExp}, function(id)
        end)
    
    DropPlayer(target, reason)
    return true
end

DisableConnect = function(name, setKickReason, deferrals)
    local player = source
    deferrals.defer()
    Wait(0)
    deferrals.update((Strings.deferral_welcome):format(GetCurrentResourceName(), name))
    local info = extractIdentifiers(player)
    local playerIdentifier = info.license
    
    MySQL.query('SELECT * FROM apex_bans WHERE license = ?', {playerIdentifier}, function(result)
        if result[1] then
            local time = result[1].ban_time
            local expTime = result[1].exp_time

            if IsPermanentBan(expTime) then
                deferrals.done((Strings.deferral_banned_perm):format(result[1].reason))
                return
            end

            local timeLeft = math.floor(tonumber(expTime) - os.time())
            
            if timeLeft < 1 then
                MySQL.query('DELETE FROM apex_bans WHERE license = ?', { playerIdentifier })
                deferrals.done()
            elseif timeLeft > 1 or timeLeft == 1 then
                local hours, minutes = splitTime(timeLeft)
                deferrals.done((Strings.deferral_banned):format(result[1].reason, hours, minutes))
            end
        else
            deferrals.done()
        end
    end)
end

lib.callback.register('apex_adminmenu:getBanList', function(source)
    if not AdminPerms(source) then return false end
    
    local data = {}
    local result = MySQL.query.await('SELECT * FROM apex_bans')
    
    if result and #result > 0 then
        for i=1, #result do
            local timeLeft

            if IsPermanentBan(result[i].exp_time) then
                timeLeft = 'perm'
            else
                timeLeft = tonumber(result[i].exp_time) - os.time()
            end

            if timeLeft == 'perm' or timeLeft > 0 then
                data[#data + 1] = {
                    name = result[i].player,
                    license = result[i].license,
                    author = result[i].author,
                    reason = result[i].reason,
                    exp_time = result[i].exp_time,
                    time_left = timeLeft
                }
            end
        end
    end
    
    return data
end)

lib.callback.register('apex_adminmenu:unban', function(source, targetlicense)
    if not AdminPerms(source) then return false end
    
    MySQL.query('DELETE FROM apex_bans WHERE license = ?', { targetlicense })
    return true
end)AddEventHandler('playerConnecting', DisableConnect)
