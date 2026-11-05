Activity = {}

---The single entry point for every criminal action. Logs it, then fans out to influence, heat and listeners.
---@param data { type:string, gangId:number, citizenid?:string, zone?:string, coords?:vector3, targetGangId?:number, multiplier?:number, metadata?:table }
---@return boolean
function Activity.Record(data)
    local def = Config.Activities[data.type]
    if not def then
        lib.print.warn(('Unknown activity type: %s'):format(tostring(data.type)))
        return false
    end
    if not Gangs.Get(data.gangId) then return false end

    local mult = data.multiplier or 1.0
    local influence = (def.influence or 0) * mult
    local heat = (def.heat or 0) * mult
    local zone = data.zone or (data.coords and Zones.FromCoords(data.coords)) or nil
    local coords = data.coords and ('%.2f,%.2f,%.2f'):format(data.coords.x, data.coords.y, data.coords.z or 0.0) or ''

    MySQL.insert([[
        INSERT INTO vg_activity_log
            (gang_id, citizenid, type, zone, coords, influence_delta, heat_delta, target_gang_id, metadata)
        VALUES (?, NULLIF(?, ''), ?, NULLIF(?, ''), NULLIF(?, ''), ?, ?, NULLIF(?, 0), NULLIF(?, ''))
    ]], {
        data.gangId, data.citizenid or '', data.type, zone or '', coords, influence, heat,
        data.targetGangId or 0, data.metadata and json.encode(data.metadata) or '',
    })

    if zone and influence ~= 0 then
        Influence.Add(zone, data.gangId, influence)
    end
    if zone and def.rivalInfluence and data.targetGangId then
        Influence.Add(zone, data.targetGangId, def.rivalInfluence * mult)
    end
    if heat ~= 0 then
        Heat.Add(data.gangId, data.citizenid, heat, zone)
    end

    if Director and influence > 0 then Director.OnActivity(zone, data.gangId, influence) end
    Progression.OnActivity(data.type, data.gangId, mult, data.targetGangId)
    TriggerEvent('vinewood_gangs:server:activity', data.type, data.gangId, zone, influence, heat)
    return true
end

function Activity.Prune()
    MySQL.update('DELETE FROM vg_activity_log WHERE created_at < DATE_SUB(NOW(), INTERVAL ? DAY)', { Config.ActivityLog.retentionDays })
end
