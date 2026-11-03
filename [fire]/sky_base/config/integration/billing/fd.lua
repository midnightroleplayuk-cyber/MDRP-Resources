if Sky.Config.billing ~= "fd" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "fd_banking"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    if request.type ~= "society" or not request.jobName then
        Sky.Debug("error", "fd_banking: personal invoices are not supported by this adapter")
        return false
    end

    local targetIdentifier = Sky.FW.GetIdentifier(request.target)

    if not targetIdentifier then
        Sky.Debug("error", "fd_banking: could not resolve target identifier for source " .. tostring(request.target))
        return false
    end

    local businessAccount = exports[RESOURCE]:getBusinessAccount(request.jobName)
    if type(businessAccount) ~= "table" or not businessAccount.id or not businessAccount.name then
        Sky.Debug("error", "fd_banking: getBusinessAccount returned no account for job '" .. tostring(request.jobName) .. "'")
        return false
    end

    return exports[RESOURCE]:addInvoice(targetIdentifier, businessAccount.name, 1, request.amount, request.reason, businessAccount.id, false)
end
