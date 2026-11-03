Config = {}
Config.AdminCommand = "admin:banking"
Config.Admins = { "group.admin", "group.god" }
Config.BankAccount = "bank"

-- Banking main APP config
Config.App = {
	name = "banking",
	label = "Banking",
	maximize = true,
	isEnabled = function(serial)
		return true
	end,
}

-- Banker Terminal APP config
Config.BankerApp = {
	enabled = true,
	name = "avbanker",
	label = "Banker Terminal",
	icon = "icon.png",
	isEnabled = function(serial)
		return exports["av_laptop"]:hasJob(GlobalState.bankJob or "banker")
	end,
}

Config.Phone = {
	enabled = false,
	resource = "sd-phone",
	identifier = "av_banking",
	name = "Fleeca",
	description = "Check your balance, move money and manage your cards from anywhere.",
	developer = "AV Scripts",
	defaultApp = true,
	ui = "ui-phone/dist/index.html",
	icon = "icon.png",
	job = nil,
	requires = nil,
}

function dbug(...)
	if GlobalState["bankDebug"] then
		print("^3[DEBUG]^7", ...)
	end
end

function warn(...)
	print("^1[WARNING]^7", ...)
end
