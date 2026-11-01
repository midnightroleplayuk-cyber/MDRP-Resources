if Sky.Config.billing ~= "hex" then return end
if not IsDuplicityVersion() then return end

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    if request.type ~= "society" then
        Sky.Debug("error", "hex_jobscreator: personal invoices are not supported by sendJobBill")
        return false
    end

    local Sky_Jobs = exports["sky_jobs_base"]:Get()
    request.jobName = Sky_Jobs.PlayerCache.GetJob(request.source)
    if not request.jobName then
        Sky.Debug("error", "hex_jobscreator: no job found for invoice issuer (%s)", tostring(request.source))
        return false
    end

    if request.target == nil then
        request.target = request.source
    end

    local success, bill_id = exports["hex_jobscreator"]:sendJobBill(
        request.jobName, request.target, request.amount, request.reason
    )
    if not success then
        Sky.Debug("error", "hex_jobscreator: invoice creation failed (%s)", tostring(bill_id))
        return false
    end

    return bill_id
end
