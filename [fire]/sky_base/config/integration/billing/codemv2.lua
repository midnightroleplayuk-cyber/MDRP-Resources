if Sky.Config.billing ~= "codemv2" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "codem-billingv2"

local function is_valid_player_source(source)
    local numeric_source = tonumber(source)
    return numeric_source and numeric_source > 0
end

local function get_sender_from_request(request)
    if request.type ~= "society" or type(request.account) ~= "string" or request.account == "" then
        if is_valid_player_source(request.source) then
            return Sky.FW.GetIdentifier(request.source) or "system", Sky.FW.GetName(request.source) or "System"
        end

        return "system", "System"
    end

    if request.jobName and request.jobName ~= "" then
        return request.account, request.jobName
    end

    return request.account, request.account
end

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    if not request.amount or request.amount <= 0 then
        Sky.Debug("error", "codem-billingv2: invoice amount is invalid")
        return false
    end

    if not request.reason then
        Sky.Debug("error", "codem-billingv2: invoice reason is missing")
        return false
    end

    if request.target == nil then
        request.target = request.source
    end

    local senderIdentifier, senderName = get_sender_from_request(request)
    local creatorIdentifier = is_valid_player_source(request.source) and Sky.FW.GetIdentifier(request.source) or nil

    local result = exports[RESOURCE]:CreateBillingCustom(
        request.target,
        request.amount,
        request.reason,
        true,
        senderIdentifier,
        senderName,
        creatorIdentifier
    )
    if not result then
        Sky.Debug("error", "codem-billingv2: failed to create invoice")
        return false
    end
    return result
end
