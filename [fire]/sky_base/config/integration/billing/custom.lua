-- Set Config.billing = "custom" to enable this server-side template.
if Sky.Config.billing ~= "custom" then return end
if not IsDuplicityVersion() then return end

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    -- Normalize legacy and current calls before forwarding them to the provider.
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)

    -- Use request.source, request.target, request.type, request.account,
    -- request.jobName, request.reason, request.amount and request.infos here.
    error(("Custom billing integration: SendBill is not implemented for target %s"):format(tostring(request.target)))
end
