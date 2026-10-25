-- Mechanic script adapters: where MOTs can happen and who may carry them out.
Mechanic = { garages = {}, provider = 'config' }

local M = Config.MOT
local J = M.jgMechanic

local function log(msg) print(('^3[vinewood-vehicleservices]^7 %s'):format(msg)) end

---------------------------------------------------------------------------
-- jg-mechanic
---------------------------------------------------------------------------
local jg = { cfg = nil, employeesOk = false }

local function loadJgConfig()
    local raw = LoadResourceFile('jg-mechanic', 'config/config.lua')
    if not raw or raw == '' then return nil, 'config/config.lua not readable' end
    local env = setmetatable({ Config = {} }, { __index = _G })
    local chunk, err = load(raw, '@jg-mechanic/config/config.lua', 't', env)
    if not chunk then return nil, err end
    local ok, e = pcall(chunk)
    if not ok then return nil, e end
    if type(env.Config.MechanicLocations) ~= 'table' then return nil, 'Config.MechanicLocations missing' end
    return env.Config
end

local function probeEmployees()
    local t, idc, mc = J.employeesTable, J.employeeIdColumn, J.employeeMechanicColumn
    local n = MySQL.scalar.await([[SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME IN (?, ?)]], { t, idc, mc })
    return tonumber(n) == 2
end

local function pretty(id)
    return (tostring(id):gsub('[_%-]', ' '):gsub('(%a)([%w]*)', function(a, b) return a:upper() .. b end))
end

local function jgGarages(cfg)
    local list = {}
    for id, mech in pairs(cfg.MechanicLocations) do
        if type(mech) == 'table' and (mech.type == 'owned' or not J.ownedOnly) then
            for _, loc in ipairs(mech.locations or {}) do
                if loc.coords then
                    list[#list + 1] = {
                        label = mech.label or mech.name or pretty(id),
                        coords = vec3(loc.coords.x, loc.coords.y, loc.coords.z),
                        radius = (tonumber(loc.size) or 5.0) + J.locationPadding,
                        jgId = id,
                        jgJob = mech.job,
                    }
                end
            end
        end
    end
    return list
end

local function jgCanTest(src, garage)
    if not garage.jgId then return nil end
    if jg.cfg.UseFrameworkJobs then
        if not garage.jgJob then return false end
        local name, _, duty = Bridge.Job(src)
        return name == garage.jgJob and (duty or not M.requireDuty)
    end
    if not jg.employeesOk then
        -- Built-in job table not found: fall back to the job named on the location.
        local name, _, duty = Bridge.Job(src)
        return garage.jgJob ~= nil and name == garage.jgJob and (duty or not M.requireDuty)
    end
    local cid = Bridge.Cid(src)
    local sql = ('SELECT 1 FROM `%s` WHERE `%s` = ? AND `%s` = ? LIMIT 1'):format(J.employeesTable, J.employeeIdColumn, J.employeeMechanicColumn)
    return MySQL.scalar.await(sql, { cid, garage.jgId }) ~= nil
end

---------------------------------------------------------------------------
-- Setup
---------------------------------------------------------------------------
local function useJg()
    if M.provider == 'config' then return false end
    if M.provider ~= 'jg-mechanic' and GetResourceState('jg-mechanic') ~= 'started' then return false end
    local cfg, err = loadJgConfig()
    if not cfg then
        log(('jg-mechanic found but its config could not be read (%s). Using Config.MOT.garages.'):format(err))
        return false
    end
    jg.cfg = cfg
    jg.employeesOk = not cfg.UseFrameworkJobs and probeEmployees()
    if not cfg.UseFrameworkJobs and not jg.employeesOk then
        log(('jg-mechanic built-in jobs: table %s(%s, %s) not found. Matching testers on each location\'s job instead.')
            :format(J.employeesTable, J.employeeIdColumn, J.employeeMechanicColumn))
    end
    return true
end

CreateThread(function()
    -- Give mechanic scripts a moment to start.
    for _ = 1, 20 do
        if GetResourceState('jg-mechanic') ~= 'starting' then break end
        Wait(500)
    end

    local garages = {}
    if J.enabled and useJg() then
        Mechanic.provider = 'jg-mechanic'
        for _, g in ipairs(jgGarages(jg.cfg)) do garages[#garages + 1] = g end
        log(('jg-mechanic: %d MOT location(s) imported (%s jobs).')
            :format(#garages, jg.cfg.UseFrameworkJobs and 'framework' or 'built-in'))
    end
    if Mechanic.provider == 'config' or J.keepConfigGarages then
        for _, g in ipairs(M.garages) do
            garages[#garages + 1] = { label = g.label, coords = g.coords, radius = g.radius, jobs = g.jobs }
        end
    end
    Mechanic.garages = garages
    TriggerClientEvent('vw-vehsvc:garages', -1, garages)
end)

lib.callback.register('vw-vehsvc:getGarages', function() return Mechanic.garages end)

function Mechanic.GarageFor(src)
    local pos = GetEntityCoords(GetPlayerPed(src))
    local best, bestDist
    for _, g in ipairs(Mechanic.garages) do
        local d = #(pos - g.coords)
        if d <= g.radius and (not bestDist or d < bestDist) then best, bestDist = g, d end
    end
    return best
end

-- Whether this player may carry out an MOT at this garage.
function Mechanic.CanTest(src, garage)
    if M.CanTest then
        local ok, res = pcall(M.CanTest, src, garage)
        if ok and res ~= nil then return res end
    end
    local r = jg.cfg and jgCanTest(src, garage)
    if r ~= nil then return r end
    return Bridge.HasJob(src, garage.jobs or M.jobs, M.requireDuty)
end

-- Authorised testers online for each garage: { [garageIndex] = count }.
-- jg built-in employees are looked up in one query rather than per player.
function Mechanic.TesterCounts()
    local counts, players = {}, GetPlayers()
    local employees
    if jg.cfg and not jg.cfg.UseFrameworkJobs and jg.employeesOk and not M.CanTest then
        employees = {}
        local cids, bySrc = {}, {}
        for _, id in ipairs(players) do
            local cid = Bridge.Cid(tonumber(id))
            if cid then cids[#cids + 1] = cid; bySrc[cid] = true end
        end
        if #cids > 0 then
            local sql = ('SELECT `%s` AS cid, `%s` AS mech FROM `%s` WHERE `%s` IN (%s)'):format(
                J.employeeIdColumn, J.employeeMechanicColumn, J.employeesTable, J.employeeIdColumn, ('?,'):rep(#cids):sub(1, -2))
            for _, r in ipairs(MySQL.query.await(sql, cids) or {}) do
                employees[r.mech] = (employees[r.mech] or 0) + 1
            end
        end
    end
    for i, g in ipairs(Mechanic.garages) do
        if employees and g.jgId then
            counts[i] = employees[g.jgId] or 0
        else
            local n = 0
            for _, id in ipairs(players) do
                if Mechanic.CanTest(tonumber(id), g) then n = n + 1 end
            end
            counts[i] = n
        end
    end
    return counts
end

lib.callback.register('vw-vehsvc:stations', function()
    return { garages = Mechanic.garages, testers = Mechanic.TesterCounts() }
end)

---------------------------------------------------------------------------
-- Odometer and servicing
---------------------------------------------------------------------------
-- Returns miles (integer) or nil.
function Mechanic.Mileage(veh, plate)
    if not M.recordMileage then return end
    if GetResourceState('jg-vehiclemileage') == 'started' then
        local ok, km = pcall(function() return exports['jg-vehiclemileage']:getMileageByEntity(veh) end)
        if not ok or not km then
            ok, km = pcall(function() return exports['jg-vehiclemileage']:getMileageByPlate(plate) end)
        end
        km = ok and tonumber(km)
        if km then return math.floor(km * 0.621371 + 0.5) end
    end
    if M.GetMileage then
        local ok, miles = pcall(M.GetMileage, veh, plate)
        if ok and tonumber(miles) then return math.floor(tonumber(miles)) end
    end
end

-- Extra advisories from mechanic scripts (not failures).
function Mechanic.Advisories(plate)
    local out = {}
    if J.serviceAdvisory and GetResourceState('jg-mechanic') == 'started' then
        local ok, due = pcall(function() return exports['jg-mechanic']:doesVehicleNeedServicing(plate) end)
        if ok and due then out[#out + 1] = 'Vehicle is due a service' end
    end
    return out
end
