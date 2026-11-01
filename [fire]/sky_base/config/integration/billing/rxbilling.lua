if Sky.Config.billing ~= "rxbilling" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "RxBilling"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    local senderId = request.source
    local targetId = request.target
    if senderId == nil or senderId == 0 then
        senderId = targetId
    end

    exports[RESOURCE]:SendInvoice(
        senderId,
        targetId,
        request.amount,
        request.reason,
        request.type == "society"
    )
    return true
end
