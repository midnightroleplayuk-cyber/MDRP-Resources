if Sky.Config.billing ~= "corem" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "crm-billing"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    local senderId = request.source
    local targetId = request.target
    if targetId == nil then
        targetId = senderId
    end

    if request.type == "society" and request.jobName then
        exports[RESOURCE]:addSocietyInvoice({
            crm_id       = request.jobName,
            crm_label    = request.jobName,
            crm_receiver = targetId,
            crm_amount   = request.amount,
            crm_reason   = request.reason,
        })
    else
        exports[RESOURCE]:addPersonalInvoice(senderId, targetId, request.amount, request.reason)
    end
end
