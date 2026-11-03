if Sky.Config.billing ~= "esx" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "esx_billing"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    local societyName = request.jobName
    local senderIdentifier = request.type == "society" and (request.account or societyName)
        or (Sky.FW.GetIdentifier(request.source) or societyName)
    local billingTarget = request.type == "society" and request.account or (senderIdentifier or "system")
    exports[RESOURCE]:BillPlayer(request.target, senderIdentifier, billingTarget, request.reason, request.amount)
end
