if Sky.Config.billing ~= "groot" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "g-billing"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    local targetIdentifier = Sky.FW.GetIdentifier(request.target)
    local issuerIdentifier = request.source and Sky.FW.GetIdentifier(request.source) or nil

    if not targetIdentifier then
        Sky.Debug("error", "g-billing: could not resolve target identifier for source " .. tostring(request.target))
        return false
    end

    local data = {
        amount             = request.amount,
        target_identifier  = targetIdentifier,
        target_name        = Sky.FW.GetName(request.target),
        issuer_identifier  = issuerIdentifier or request.jobName or "system",
        issuer_name        = (request.source and Sky.FW.GetName(request.source)) or request.jobName or "System",
        society            = request.type == "society" and request.jobName or nil,
        reason             = request.reason,
        status             = "unpaid",
        type               = request.type == "society" and "personal_to_society" or "personal",
        due_date           = os.date("%Y-%m-%d", os.time() + 7 * 24 * 60 * 60),
        items              = { { label = request.reason, price = request.amount, quantity = 1 } },
    }

    local invoice, err = exports[RESOURCE]:CreateInvoice(data)
    if err then
        Sky.Debug("error", "g-billing: CreateInvoice returned errorCode " .. tostring(err))
        return false
    end
    return invoice
end
