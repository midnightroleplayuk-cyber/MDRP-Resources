if Sky.Config.billing ~= "synz" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "synz_banking"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)

    if not request.amount or request.amount <= 0 then
        Sky.Debug("error", "synz_banking: invoice amount is invalid")
        return false
    end

    if not request.reason then
        Sky.Debug("error", "synz_banking: invoice reason is missing")
        return false
    end

    local recipient_identifier = Sky.FW.GetIdentifier(request.target)
    if not recipient_identifier then
        Sky.Debug("error", "synz_banking: could not resolve recipient identifier for source " .. tostring(request.target))
        return false
    end

    local from_type
    local from_id
    local from_name

    if request.type == "society" then
        if not request.jobName then
            Sky.Debug("error", "synz_banking: society invoice is missing the business identifier")
            return false
        end

        from_type = "business"
        from_id = request.jobName
        from_name = request.infos or request.jobName
    elseif request.source and request.source ~= 0 then
        from_type = "player"
        from_id = Sky.FW.GetIdentifier(request.source)

        if not from_id then
            Sky.Debug("error", "synz_banking: could not resolve sender identifier for source " .. tostring(request.source))
            return false
        end

        from_name = request.infos or Sky.FW.GetName(request.source) or from_id
    else
        from_type = "system"
        from_id = "sky_base"
        from_name = request.infos or "System"
    end

    return exports[RESOURCE]:CreateInvoice(
        from_type,
        from_id,
        from_name,
        recipient_identifier,
        request.amount,
        request.reason,
        7
    )
end
