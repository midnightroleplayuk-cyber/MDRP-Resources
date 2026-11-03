if Sky.Config.billing ~= "apex" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "apex_billing"

local can_issue_player = Sky.Functions.CanIssueBill

function Sky.Functions.CanIssueBill(source)
    if not can_issue_player(source) then
        return false
    end

    local allowed = exports[RESOURCE]:CanIssue(tonumber(source))
    if not allowed or allowed == 0 then
        Sky.Debug("debug", "apex_billing: source %s is not permitted to issue invoices", tostring(source))
        return false
    end

    return true
end

function Sky.Functions.SendBill(source, target, bill_type, account, reason, amount, infos)
    local request = Sky.Functions.NormalizeBillRequest(source, target, bill_type, account, reason, amount, infos)
    if type(request.source) ~= "number" or request.source <= 0 then
        Sky.Debug("error", "apex_billing: a player source is required as invoice issuer")
        return false
    end

    if not request.amount or request.amount <= 0 or request.amount >= math.huge
        or request.amount ~= request.amount then
        Sky.Debug("error", "apex_billing: invoice amount must be a positive finite number")
        return false
    end

    if not request.reason then
        Sky.Debug("error", "apex_billing: invoice reason is missing")
        return false
    end

    -- Apex resolves the issuing society from the player's job. Bill has no
    -- documented option for an arbitrary account or a system issuer.
    local success, error_code, invoice = exports[RESOURCE]:Bill({
        issuer = request.source,
        recipient = request.target,
        recipientType = "player",
        issueAs = request.type,
        title = request.reason,
        items = {
            { label = request.reason, qty = 1, price = request.amount }
        },
        vatRate = 0,
        notes = request.infos
    })

    if not success or success == 0 then
        Sky.Debug("error", "apex_billing: invoice creation failed (%s)", tostring(error_code))
        return false
    end

    return invoice.id
end
