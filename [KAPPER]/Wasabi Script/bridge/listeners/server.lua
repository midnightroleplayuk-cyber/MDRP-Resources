-- online officer presence for roster + dispatch

local listeners = {}

---@type table<number, { identifier: string, job: table?, since: number }>
local online = {}
---@type table<string, table<number, boolean>> deptName -> set of online source ids
local byDept = {}

function listeners.getOnline()
    return online
end

function listeners.get(source)
    return online[source]
end

--- officers currently on this department
function listeners.getByDepartment(dept)
    return byDept[dept] or {}
end

--- keep dept buckets in sync with job
local function indexDept(src, job)
    for _, set in pairs(byDept) do set[src] = nil end
    if job and job.name and Config.Departments[job.name] then
        byDept[job.name] = byDept[job.name] or {}
        byDept[job.name][src] = true
    end
end

RegisterNetEvent('wasabi_mdt:server:playerReady', function()
    local src = source
    local bridge = Modules.require('bridge')
    online[src] = {
        identifier = bridge.getIdentifier(src),
        job = bridge.getJob(src),
        since = os.time(),
    }
    indexDept(src, online[src].job)
end)

RegisterNetEvent('wasabi_mdt:server:jobChanged', function(job)
    local src = source
    if not online[src] then
        local bridge = Modules.require('bridge')
        online[src] = { identifier = bridge.getIdentifier(src), since = os.time() }
    end
    online[src].job = job
    indexDept(src, job)
end)

AddEventHandler('playerDropped', function()
    local src = source
    online[src] = nil
    for _, set in pairs(byDept) do set[src] = nil end
end)

Modules.register('listeners', listeners)
