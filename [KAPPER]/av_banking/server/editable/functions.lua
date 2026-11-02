function isAdmin(src)
	if IsPlayerAceAllowed(src, ("command.%s"):format(Config.AdminCommand)) then
		dbug("isAdmin", src, "via command ace")
		return true
	end
	for _, group in ipairs(Config.Admins or {}) do
		if IsPlayerAceAllowed(src, group) then
			dbug("isAdmin", src, "via", group)
			return true
		end
	end
	dbug("isAdmin", src, false)
	return false
end

IsAdmin = isAdmin

function NotifyPlayer(src, message, type)
	TriggerClientEvent("av_laptop:notification", src, Config.App.label, message, type or "info")
end

-- Triggered after the money has moved, so you can use it for logs
--- @param src number The player source who initiated the action
--- @param action string The action that was performed ("atm_withdraw", "atm_deposit", "atm_transfer", "withdraw", "deposit", "transfer", "invoice_paid")
--- @param amount number The amount of money that was moved
--- @param accountNumber string The account number that was affected
function OnMoneyMoved(src, action, amount, accountNumber) end

-- Where the wealth tax goes
-- Default: the society account named in Settings → Tax → "Collected into"
function OnTaxCollected(amount)
	local society = Config.Tax and Config.Tax.society
	if not society or society == "" or not amount or amount <= 0 then
		return
	end
	local ok = AddSociety(-1, society, amount, L("bank_name"), "wealth tax")
	if not ok then
		dbug("tax payout failed", society, amount)
	end
end

-- Where confiscated fraud holds go
-- Default: the same society as the tax
function OnFraudConfiscated(amount)
	local society = (Config.Tax and Config.Tax.society) or "government"
	return AddSociety(-1, society, amount, L("bank_name"), "confiscated funds")
end

-- Checks if av_dealership is started (or your custom Dealership script)
function DealershipAvailable()
	return GetResourceState("av_dealership") == "started"
end

-- Returns a table with the financing info for a given player identifier, or nil if not available
function GetVehicleFinancing(identifier)
	if not identifier or not DealershipAvailable() then
		return nil
	end
	local ok, result = pcall(function()
		return exports["av_dealership"]:getCustomerFinancing(identifier)
	end)
	if ok and type(result) == "table" then
		return result
	end
	return nil
end

function PayVehicleFinancing(src, plates, isFull)
	if not DealershipAvailable() then
		return { ok = false, error = "errors.dealership_off" }
	end
	local ok, result = pcall(function()
		return exports["av_dealership"]:payFinancing(src, plates, isFull == true)
	end)
	if ok and type(result) == "table" then
		return result
	end
	return { ok = false, error = "errors.dealership_off" }
end

-- Checks if av_mail is started (or your custom Mail script)
function MailProviderAvailable()
	return GetResourceState("av_mail") == "started"
end

function MailProviderSend(payload)
	local ok, err = pcall(function()
		return exports["av_mail"]:sendMail({
			to = payload.to,
			from = payload.from,
			subject = payload.subject,
			body = payload.body,
		})
	end)
	if not ok then
		dbug("mail provider send failed", tostring(err))
		return false
	end
	return true
end

function MailProviderAccountExists(email)
	local ok, exists = pcall(function()
		return exports["av_mail"]:accountExists(email)
	end)
	if not ok then
		return true
	end
	return exists ~= false
end

function MailProviderAccountOwner(email, identifier)
	local ok, owns = pcall(function()
		return exports["av_mail"]:isAccountOwner(email, identifier)
	end)
	if not ok then
		return true
	end
	return owns ~= false
end
