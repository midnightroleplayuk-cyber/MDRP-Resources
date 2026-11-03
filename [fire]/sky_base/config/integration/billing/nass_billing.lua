if Sky.Config.billing ~= "nass_billing" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "nass_billing"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)

    exports[RESOURCE]:createInvoice(
        request.source,      -- source
        request.target,      -- target
        request.reason,      -- reason
        request.reason,      -- description
        request.amount,      -- amount
        request.type == "society", -- isBusiness
        nil                  -- customAdjustment
    )
end
