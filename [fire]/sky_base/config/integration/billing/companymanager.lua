if Sky.Config.billing ~= "companymanager" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "bcs_companymanager"

function Sky.Functions.SendBill(source, target, bill_type, account, description, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, description, amount, infos)
    if not request.target then
        Sky.Debug("error", "bcs_companymanager: invoice target is missing")
        return false
    end
    if not request.amount or request.amount <= 0 then
        Sky.Debug("error", "bcs_companymanager: invoice amount is invalid")
        return false
    end
    if not request.reason then
        Sky.Debug("error", "bcs_companymanager: invoice reason is missing")
        return false
    end
    local from = {
        label = request.type == "society" and (request.jobName or request.account or "unknown") or (Sky.FW.GetName(request.source) or "unknown"),
        job = request.type == "society" and (request.jobName or request.account or "unknown") or "personal",
        identifier = request.type == "society"
            and tostring(request.account or request.source or "unknown")
            or tostring((request.source and Sky.FW.GetIdentifier(request.source)) or request.source or "unknown"),
    }
    return exports[RESOURCE]:CreateBill(
        request.source,
        request.target,
        request.amount,
        request.reason,
        nil,
        from
    )
end
