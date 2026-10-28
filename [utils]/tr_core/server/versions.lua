---------------------------------------------------------------------------------------------------
-- Version check: once the server has finished starting, one block at the bottom of the console says
-- which TR scripts (tr_core and every started resource that uses it) have an update, and where to get
-- it. The latest versions come from the TR Scripts dashboard; scripts it doesn't know are left out.
---------------------------------------------------------------------------------------------------

local URL = 'https://admin.tr-scripts.com/api/versions'
local QUIET = 5000 -- ms without a resource starting: the server is done starting
local CORE = GetCurrentResourceName()

local lastStart = GetGameTimer()
AddEventHandler('onServerResourceStart', function() lastStart = GetGameTimer() end)

---Whether a resource loads tr_core ('@tr_core/init.lua') or lists it as a dependency.
local function usesCore(resource)
    for _, key in ipairs({ 'dependency', 'shared_script', 'server_script', 'client_script' }) do
        for i = 0, GetNumResourceMetadata(resource, key) - 1 do
            local value = GetResourceMetadata(resource, key, i)
            if value == 'tr_core' or (value and value:find('@tr_core/', 1, true) == 1) then return true end
        end
    end
    return false
end

---1 when a is newer than b, -1 when older, 0 when the same.
local function compare(a, b)
    local function parts(v)
        local out = {}
        for n in tostring(v):gmatch('%d+') do out[#out + 1] = tonumber(n) end
        return out
    end
    local x, y = parts(a), parts(b)
    for i = 1, math.max(#x, #y) do
        if (x[i] or 0) ~= (y[i] or 0) then return (x[i] or 0) > (y[i] or 0) and 1 or -1 end
    end
    return 0
end

---tr_core first, then the started resources that use it, as { resource, name, version }. `name` is the
---fxmanifest name, so a renamed folder still finds its script.
local function installed()
    local list = { { resource = CORE, name = 'tr_core', version = GetResourceMetadata(CORE, 'version', 0) } }
    for i = 0, GetNumResources() - 1 do
        local resource = GetResourceByFindIndex(i)
        if resource and resource ~= CORE and GetResourceState(resource) == 'started' and usesCore(resource) then
            list[#list + 1] = { resource = resource, name = GetResourceMetadata(resource, 'name', 0) or resource, version = GetResourceMetadata(resource, 'version', 0) }
        end
    end
    return list
end

local function report(latest)
    local rows, updates, width = {}, 0, 0
    for _, script in ipairs(installed()) do
        local known = latest[script.resource] or latest[script.name]
        if type(known) == 'table' and type(known.version) == 'string' and script.version then
            local newer = compare(known.version, script.version)
            if newer > 0 then updates = updates + 1 end
            rows[#rows + 1] = { script = script, known = known, newer = newer }
            width = math.max(width, #script.resource)
        end
    end
    if #rows == 0 then return end

    print(updates == 0 and '^2TR Scripts: everything is up to date^7'
        or ('^3TR Scripts: %d update%s available^7'):format(updates, updates == 1 and '' or 's'))
    for _, row in ipairs(rows) do
        local name = row.script.resource .. (' '):rep(width - #row.script.resource)
        local status
        if row.newer > 0 then
            status = ('^3update to %s^7: %s'):format(row.known.version, row.known.download or '')
        elseif row.newer < 0 then
            status = ('^5newer than the latest release (%s)^7'):format(row.known.version)
        else
            status = '^2up to date^7'
        end
        print(('  %s  %-8s %s'):format(name, row.script.version, status))
    end
end

CreateThread(function()
    while GetGameTimer() - lastStart < QUIET do Wait(1000) end

    PerformHttpRequest(URL, function(status, body)
        local ok, latest = pcall(json.decode, body or '')
        if status ~= 200 or not ok or type(latest) ~= 'table' then
            return print(('^3TR Scripts: couldn\'t check for updates (HTTP %s)^7'):format(status))
        end
        report(latest)
    end, 'GET', '', { Accept = 'application/json' })
end)
