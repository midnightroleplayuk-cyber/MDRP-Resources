local screens = {}
local function validKey(key)
    return type(key) == 'string' and #key <= 110 and key:match('^%-?%d+:%-?%d+:%-?%d+:%-?%d+$') ~= nil
end
local function hostAllowed(url)
    if type(url) ~= 'string' or #url > Config.MaxUrlLength or url:find('[%c]') then return false end
    if not url:match('^https://') then return false end
    local host = url:match('^https://([^/:?#]+)')
    if not host then return false end
    host = host:lower():gsub('%.$', '')
    -- Enforce blacklist on the server for all playback and website requests.
    for _, blocked in ipairs(Config.BlockedWebsiteHosts or {}) do
        blocked = tostring(blocked):lower():gsub('^%.*', ''):gsub('%.$', '')
        if blocked ~= '' and (host == blocked or host:sub(-#blocked - 1) == '.' .. blocked) then
            return false
        end
    end
    if host == 'localhost' or host:match('^127%.') or host:match('^10%.') or host:match('^192%.168%.') or host:match('^172%.1[6-9]%.') or host:match('^172%.2%d%.') or host:match('^172%.3[01]%.') then return false end
    if #Config.AllowedWebsiteHosts > 0 then
        local allowed = false
        for _, v in ipairs(Config.AllowedWebsiteHosts) do if host == v:lower() then allowed = true break end end
        if not allowed then return false end
    end
    return true
end
local function validate(data)
    if type(data) ~= 'table' then return false end
    if data.kind == 'off' or data.kind == 'test' then return true end
    if type(data.url) ~= 'string' or not hostAllowed(data.url) then return false end
    if data.kind == 'website' then return Config.AllowWebsites end
    if data.kind == 'video' then return true end
    local host = data.url:match('^https://([^/:?#]+)')
    if not host then return false end
    host = host:lower()
    local function domain(base)
        return host == base or host:sub(-#base-1) == '.' .. base
    end
    if data.kind == 'youtube' then
        return domain('youtube.com') or domain('youtube-nocookie.com') or host == 'youtu.be'
    end
    if data.kind == 'twitch' then return domain('twitch.tv') end
    if data.kind == 'tiktok' then return domain('tiktok.com') end
    return false
end
local function keyCoords(key)
    local x,y,z = key:match('^%-?%d+:(%-?%d+):(%-?%d+):(%-?%d+)$')
    if not x then return nil end
    return vector3(tonumber(x)/10, tonumber(y)/10, tonumber(z)/10)
end
RegisterNetEvent('hf1_tv:update', function(key, data)
    local src = source
    if not validKey(key) or not validate(data) then
        print(('[hf1_tv] Rejected update from %s: key=%s kind=%s url=%s'):format(src,tostring(key),tostring(data and data.kind),tostring(data and data.url)))
        TriggerClientEvent('hf1_tv:rejected', src, 'Invalid TV URL or content type')
        return
    end
    local pos = keyCoords(key)
    local ped = GetPlayerPed(src)
    if ped == 0 or #(GetEntityCoords(ped)-pos) > Config.InteractDistance + 5.0 then return end
    local entry = {kind=data.kind, url=data.url, volume=math.floor(math.max(0, math.min(100, tonumber(data.volume) or Config.DefaultVolume))), started=os.time()}
    screens[key] = entry.kind == 'off' and nil or entry
    TriggerClientEvent('hf1_tv:changed', -1, key, screens[key])
end)
RegisterNetEvent('hf1_tv:request', function()
    TriggerClientEvent('hf1_tv:snapshot', source, screens)
end)

-- A picked-up TV must stop playback for everyone. The key is model + rounded coords.
AddEventHandler('hf1_tv:placedDeletedInternal',function(tv)
    local p=tv.coords
    local model=joaat(tv.model)
    local function rnd(v) return math.floor(v*10+0.5) end
    local key=('%d:%d:%d:%d'):format(model,rnd(p.x),rnd(p.y),rnd(p.z))
    screens[key]=nil
    TriggerClientEvent('hf1_tv:changed',-1,key,nil)
end)
