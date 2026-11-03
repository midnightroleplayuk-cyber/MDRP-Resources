if Sky.Config.billing ~= "jacksam" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "billing_ui"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    local senderIdentifier = request.source and Sky.FW.GetIdentifier(request.source) or nil
    local targetIdentifier = Sky.FW.GetIdentifier(request.target)
    local billAccount = request.type == "society" and request.account or (senderIdentifier or "system")

    exports[RESOURCE]:createBill(
        senderIdentifier or targetIdentifier,
        targetIdentifier,
        request.reason,
        request.amount,
        billAccount,
        request.type == "society" and "society" or "player"
    )
end
