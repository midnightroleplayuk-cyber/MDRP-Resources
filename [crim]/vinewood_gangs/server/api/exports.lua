-- Server exports for other resources (drug selling, robberies, police raids, etc.)

exports('RecordActivity', function(data) return Activity.Record(data) end)

exports('GetPlayerGang', function(src)
    local gang, membership = Gangs.GetPlayerGang(src)
    if not gang then return nil end
    return { id = gang.id, name = gang.name, label = gang.label, grade = membership.grade }
end)

exports('GetZoneAt', function(coords) return Zones.FromCoords(coords) end)
exports('GetZoneOwner', function(zone) return Influence.GetOwner(zone) end)
exports('HasPermission', function(citizenid, permission) return Gangs.HasPermission(citizenid, permission) end)
exports('LedgerTransact', function(gangId, account, amount, txType, opts)
    return Ledger.Transact(gangId, account, amount, txType, opts)
end)
exports('CreateIntelLead', function(lead) return Intel.CreateLead(lead) end)

-- Offline lookup for other resources (e.g. vinewood_multichar's character selection).
-- Reads the in-memory member cache, so it's instant and works for characters who aren't online.
-- ids: list of citizenids. Returns { [citizenid] = { id, name, label, colour, logo, grade, rank } }
local function characterGang(cid)
    local m = Gangs.GetMembership(cid)
    local g = m and Gangs.Get(m.gangId)
    if not g then return nil end
    return {
        id = g.id,
        name = g.name,
        label = g.label,
        colour = g.colour,
        logo = Gangs.ApprovedLogo(g.id), -- only staff-approved logos
        grade = m.grade,
        rank = Gangs.RankLabel(g.id, m.grade),
    }
end

exports('GetCharacterGang', function(citizenid)
    if type(citizenid) ~= 'string' then return nil end
    return characterGang(citizenid)
end)

exports('GetCharacterGangs', function(ids)
    local out = {}
    if type(ids) ~= 'table' then return out end
    for _, cid in ipairs(ids) do
        if type(cid) == 'string' then out[cid] = characterGang(cid) end
    end
    return out
end)
