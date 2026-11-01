if not IsDuplicityVersion() then return end

function Sky.Functions.CanIssueBill(source)
    local player_source = tonumber(source)
    if not player_source or player_source <= 0 or player_source >= math.huge or player_source % 1 ~= 0 then
        Sky.Debug("debug", "Billing issuer must be a positive player source (received %s)", tostring(source))
        return false
    end

    return true
end

local function normalize_billing_text(value)
    if value == nil then
        return nil
    end

    local text = tostring(value):gsub("^%s+", ""):gsub("%s+$", "")
    if text == "" then
        return nil
    end

    return text
end

function Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    local normalized_type = normalize_billing_text(bill_type)
    normalized_type = normalized_type and normalized_type:lower() or nil
    if normalized_type ~= "society" and normalized_type ~= "player" then
        -- Preserve legacy SendBill(source, target, account, reason, amount) calls.
        account, reason, amount, infos = bill_type, account, reason, amount
        normalized_type = nil
    end

    local normalized_account = normalize_billing_text(account)
    if not normalized_type then
        normalized_type = normalized_account and "society" or "player"
    end

    if normalized_type == "society" and normalized_account and not normalized_account:match("^society_") then
        normalized_account = "society_" .. normalized_account
    end

    return {
        source = tonumber(source) or source,
        target = tonumber(target) or target,
        account = normalized_account,
        jobName = normalized_account and normalized_account:gsub("^society_", "") or nil,
        reason = normalize_billing_text(reason),
        amount = tonumber(amount),
        infos = normalize_billing_text(infos),
        type = normalized_type
    }
end
