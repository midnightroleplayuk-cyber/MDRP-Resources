Intel = {}

local hourWindowStart, leadsThisHour = 0, 0

local function underHourlyCap()
    local now = os.time()
    if now - hourWindowStart >= 3600 then
        hourWindowStart, leadsThisHour = now, 0
    end
    return leadsThisHour < Config.Heat.maxLeadsPerHour
end

local function buildSummary(gang, zone, precision)
    local where = zone and Zones.Label(zone) or 'the city'
    if precision == 'vague' then
        return ('Reports of increased organised criminal activity in %s'):format(where)
    elseif precision == 'area' then
        return ('An organised crime group is believed to be operating in %s'):format(where)
    end
    local text = ('%s is assessed to be active in %s.'):format(gang and gang.label or 'An organised crime group', where)
    local address = gang and Safehouses and Safehouses.AddressFor(gang.id)
    if address then text = text .. (' A property at %s is believed to be used by the group.'):format(address) end
    return text
end

---@param lead { gangId?:number, citizenid?:string, source:string, zone?:string, precision?:string, summary?:string, data?:table }
function Intel.CreateLead(lead)
    if not lead.force then
        if not underHourlyCap() then return false end
        leadsThisHour = leadsThisHour + 1
    end

    local gang = lead.gangId and Gangs.Get(lead.gangId)
    local precision = lead.precision or 'vague'
    local summary = (lead.summary or buildSummary(gang, lead.zone, precision)):sub(1, 255)

    local id = MySQL.insert.await([[
        INSERT INTO vg_intel_leads (gang_id, citizenid, source, zone, `precision`, summary, data, expires_at)
        VALUES (NULLIF(?, 0), NULLIF(?, ''), ?, NULLIF(?, ''), ?, ?, NULLIF(?, ''), DATE_ADD(NOW(), INTERVAL ? HOUR))
    ]], {
        lead.gangId or 0, lead.citizenid or '', lead.source, lead.zone or '', precision, summary,
        lead.data and json.encode(lead.data) or '', Config.Heat.leadExpiryHours,
    })

    local row = {
        id = id, source = lead.source, zone = lead.zone, zoneLabel = lead.zone and Zones.Label(lead.zone),
        precision = precision, summary = summary,
        -- Only reveal the gang to police when the lead is precise enough
        gangId = precision == 'exact' and lead.gangId or nil,
        gangLabel = precision == 'exact' and gang and gang.label or nil,
        subject = lead.subject, grading = lead.grading,
    }
    Bridge.MDT.PushLead(row)
    TriggerEvent('vinewood_gangs:server:leadCreated', row)
    return id
end

function Intel.ExpireOld()
    MySQL.update("UPDATE vg_intel_leads SET status = 'expired' WHERE status IN ('open','assigned') AND expires_at < NOW()")
end

-- Large sums moving through a gang treasury leave a paper trail
AddEventHandler('vinewood_gangs:server:transactionFlagged', function(gangId, txId, account, amount, txType)
    if txType == 'disband_refund' then return end
    Intel.CreateLead({
        gangId = gangId,
        source = 'financial',
        precision = 'vague',
        summary = ('Unexplained movement of around %s linked to an organised crime group.'):format(Utils.FormatMoney(math.abs(amount))),
        data = { transaction = txId, account = account },
    })
end)
