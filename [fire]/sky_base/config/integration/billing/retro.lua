if Sky.Config.billing ~= "retro" then return end
if not IsDuplicityVersion() then return end

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)

    error((
        "Retro Billing is not supported by Sky.Functions.SendBill because rs_billing does not expose " ..
        "a documented server-side invoice creation API (target: %s)"
    ):format(tostring(request.target)), 2)
end
