if Sky.Config.billing ~= "okok" then return end
if not IsDuplicityVersion() then return end

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    local invoice_source = request.infos or Sky.FW.GetName(request.source)
    local sourceIdentifier = Sky.FW.GetIdentifier(request.source)
    TriggerEvent(
        "okokBilling:CreateCustomInvoice",
        request.target, -- target
        request.amount, -- amount
        request.reason, -- reason
        invoice_source,
        request.type == "society" and request.jobName or nil, -- society
        request.type == "society" and request.jobName or nil, -- societyName
        sourceIdentifier or nil -- authorIdentifier
    )
end
