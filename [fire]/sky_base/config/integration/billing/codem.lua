if Sky.Config.billing ~= "codem" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "codem-billing"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    if request.target == nil then
        request.target = request.source
    end

    exports[RESOURCE]:createBilling(
        request.source,
        request.target,
        request.amount,
        request.reason,
        request.type == "society" and request.account or nil
    )
end
