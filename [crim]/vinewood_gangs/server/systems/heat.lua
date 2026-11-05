Heat = {}

local dirtyGangs, dirtyMembers = {}, {}

function Heat.Add(gangId, citizenid, amount, zone)
    local gang = Gangs.Get(gangId)
    if not gang or amount == 0 then return end
    if amount > 0 and Director then
        amount = amount * Director.Mult('heatZone', zone) * Director.Mult('heatGang', gangId)
    end

    local before = gang.heat
    gang.heat = math.max(0, before + amount)
    dirtyGangs[gangId] = true

    if citizenid then
        local m = Gangs.GetMembership(citizenid)
        if m and m.gangId == gangId then
            m.heat = math.max(0, (m.heat or 0) + amount)
            dirtyMembers[citizenid] = true
        end
    end

    if amount > 0 and Config.Modules.heat then
        for _, t in ipairs(Config.Heat.thresholds) do
            if before < t.level and gang.heat >= t.level then
                Intel.CreateLead({ gangId = gangId, source = 'heat', zone = zone, precision = t.precision })
            end
        end
    end
end

function Heat.Flush()
    local gangRows, memberRows = {}, {}
    for gangId in pairs(dirtyGangs) do
        local g = Gangs.Get(gangId)
        if g then gangRows[#gangRows + 1] = { g.heat, gangId } end
    end
    for cid in pairs(dirtyMembers) do
        local m = Gangs.GetMembership(cid)
        if m then memberRows[#memberRows + 1] = { m.heat, cid } end
    end
    dirtyGangs, dirtyMembers = {}, {}

    if #gangRows > 0 then MySQL.prepare('UPDATE vg_gangs SET heat = ? WHERE id = ?', gangRows) end
    if #memberRows > 0 then MySQL.prepare('UPDATE vg_members SET personal_heat = ? WHERE citizenid = ?', memberRows) end
end

local function tick()
    local cfg = Config.Heat
    local factor = 1 - (cfg.decayPercentPerHour / 100) * (cfg.tickMinutes / 60)
    for gangId, gang in pairs(Gangs.All()) do
        if gang.heat > 0 then
            gang.heat = Utils.Round(gang.heat * factor, 2)
            dirtyGangs[gangId] = true
        end
    end
    -- Personal heat decays at the same rate; TODO: iterate online members only if member counts get large
    Heat.Flush()
    Intel.ExpireOld()
end

Heat.Tick = tick

function Heat.Start()
    CreateThread(function()
        while true do
            Wait(Config.Heat.tickMinutes * 60000)
            tick()
        end
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then Heat.Flush() end
end)
