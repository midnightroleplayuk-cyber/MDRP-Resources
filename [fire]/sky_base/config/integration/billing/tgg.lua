if Sky.Config.billing ~= "tgg" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "tgg-billing"

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)

    if not request.amount or request.amount <= 0 then
        Sky.Debug("error", "tgg-billing: invoice amount is invalid")
        return
    end

    if not request.reason then
        Sky.Debug("error", "tgg-billing: invoice reason is missing")
        return
    end

    if request.type == "society" and not request.jobName then
        Sky.Debug("error", "tgg-billing: society invoice is missing the company identifier")
        return
    end

    local recipient_identifier = Sky.FW.GetIdentifier(request.target)
    if not recipient_identifier then
        Sky.Debug("error", "tgg-billing: could not resolve recipient identifier for source " .. tostring(request.target))
        return
    end

    local sender_identifier = request.source and request.source ~= 0 and Sky.FW.GetIdentifier(request.source) or nil
    if request.type == "player" and not sender_identifier then
        Sky.Debug("error", "tgg-billing: could not resolve sender identifier for source " .. tostring(request.source))
        return
    end

    local invoice = exports[RESOURCE]:CreateInvoice({
        total = request.amount,
        taxPercentage = 0,
        sender = request.type == "society" and request.jobName or "__personal",
        senderId = sender_identifier or request.jobName,
        senderName = request.infos or Sky.FW.GetName(request.source) or request.jobName or "System",
        recipientId = recipient_identifier,
        recipientName = Sky.FW.GetName(request.target),
        recipientType = "player",
        items = {
            {
                key = "sky_billing",
                label = request.reason,
                price = request.amount,
                quantity = 1,
                priceChange = false,
                quantityChange = false
            }
        }
    })

    if not invoice then
        Sky.Debug("error", "tgg-billing: failed to create invoice")
    end
end
