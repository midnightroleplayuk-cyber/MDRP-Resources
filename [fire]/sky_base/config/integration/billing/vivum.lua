if Sky.Config.billing ~= "vivum" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "vivum-billing"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)

    if not request.amount or request.amount <= 0 then
        Sky.Debug("error", "vivum-billing: invoice amount is invalid")
        return
    end

    if not request.reason then
        Sky.Debug("error", "vivum-billing: invoice reason is missing")
        return
    end

    if request.type == "society" and not request.jobName then
        Sky.Debug("error", "vivum-billing: society invoice is missing the company identifier")
        return
    end

    if request.type == "player" and (not request.source or request.source == 0) then
        Sky.Debug("error", "vivum-billing: personal invoice is missing a valid sender source")
        return
    end

    local recipient_identifier = Sky.FW.GetIdentifier(request.target)
    if not recipient_identifier then
        Sky.Debug("error", "vivum-billing: could not resolve recipient identifier for source " .. tostring(request.target))
        return
    end

    exports[RESOURCE]:SendInvoice(request.source, {
        sender = request.type == "society" and request.jobName or "__me",
        sender_label = request.infos or Sky.FW.GetName(request.source) or request.jobName or "System",
        recipient = recipient_identifier,
        recipient_label = Sky.FW.GetName(request.target) or recipient_identifier,
        amount = request.amount,
        payments_num = 1,
        payments_period = 7,
        summary = request.reason
    }, function(response)
        if type(response) ~= "table" or response.status ~= "OK" then
            Sky.Debug("error", "vivum-billing: failed to create invoice")
        end
    end)
end
