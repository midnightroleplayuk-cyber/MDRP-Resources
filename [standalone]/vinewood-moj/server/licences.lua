-- Driving licence adapter: points and disqualifications ordered by the court.
-- vinewood_licensing queues actions for drivers who aren't in the city; the older
-- citydriving needs them online. Add your own in Licences.Custom.
Licences = {}

Licences.Resources = { 'vinewood_licensing', 'citydriving' }

-- Replace these if you use a different licence script. Return true on success.
Licences.Custom = nil
-- Licences.Custom = {
--     Endorse = function(cid, points, code, reason, by) return true end,
--     Disqualify = function(cid, days, reason, by) return true end,
-- }

local function running()
    for _, name in ipairs(Licences.Resources) do
        if GetResourceState(name) == 'started' then return exports[name], name end
    end
end

-- vinewood_licensing takes a citizen id for offline drivers; citydriving only a server id.
local function target(cid)
    local res, name = running()
    if not res then return nil, nil, 'No driving licence system is running.' end
    local src = Bridge.GetSource(cid)
    if src then return res, src end
    if name ~= 'citydriving' then return res, cid end
    return nil, nil, 'The driver must be in the city for this licence system.'
end

function Licences.Available()
    return Licences.Custom ~= nil or running() ~= nil
end

function Licences.Endorse(cid, points, code, reason, by)
    if Licences.Custom then return Licences.Custom.Endorse(cid, points, code, reason, by) end
    local res, id, err = target(cid)
    if not res then return false, err end
    local ok = pcall(function() return res:AddPoints(id, points, code or 'TT99', reason, by) end)
    return ok, not ok and 'The licence system rejected the endorsement.' or nil
end

function Licences.Disqualify(cid, days, reason, by)
    if Licences.Custom then return Licences.Custom.Disqualify(cid, days, reason, by) end
    local res, id, err = target(cid)
    if not res then return false, err end
    local ok = pcall(function() return res:BanDriver(id, days, reason, by) end)
    return ok, not ok and 'The licence system rejected the disqualification.' or nil
end
