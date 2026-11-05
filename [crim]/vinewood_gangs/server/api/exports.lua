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
