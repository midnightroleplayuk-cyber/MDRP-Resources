-- Lore creates society invoices through its issuer's client-to-server event.
if Sky.Config.billing ~= "lore" then return end

if not IsDuplicityVersion() then
    RegisterNetEvent("sky_base:billing:lore:send", function(request)
        if source ~= 65535 then
            Sky.Debug("error", "lore-billing: rejected a billing relay that did not originate from the server")
            return
        end

        TriggerServerEvent("lore-billing:sendBill", request.target, request.amount,
            request.reason, request.infos, request.jobName)
    end)
    return
end

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    if not Sky.Functions.CanIssueBill(request.source) or not Sky.FW.IsPlayerOnline(request.source) then
        Sky.Debug("error", "lore-billing: an online player is required as invoice issuer")
        return false
    end

    if type(request.target) ~= "number" or request.target <= 0 or request.target >= math.huge
        or request.target % 1 ~= 0 or not Sky.FW.IsPlayerOnline(request.target) then
        Sky.Debug("error", "lore-billing: an online player is required as invoice recipient")
        return false
    end

    if request.type ~= "society" or not request.jobName or request.jobName == "" then
        Sky.Debug("error", "lore-billing: only society invoices with a society account are supported")
        return false
    end

    if not request.amount or request.amount < 1 or request.amount > 2147483647
        or request.amount % 1 ~= 0 then
        Sky.Debug("error", "lore-billing: invoice amount must be a positive integer within the provider's storage limit")
        return false
    end

    for field, value in pairs({ reason = request.reason or "", society = request.jobName, infos = request.infos }) do
        local length = utf8.len(value)
        if not length or length < 1 or length > 255 then
            Sky.Debug("error", "lore-billing: invoice %s must contain 1 to 255 valid UTF-8 characters", field)
            return false
        end
    end

    -- Keep the actual issuer as the provider's event source. Lore has no creation
    -- acknowledgement, so nil means dispatched, not confirmed saved or paid.
    TriggerClientEvent("sky_base:billing:lore:send", request.source, request)
end
