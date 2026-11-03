-- Make sure to follow the laptop installation steps before using this or any other laptop app:
-- https://docs.av-scripts.com/laptop-pack/av-laptop/installation

Config = {}
Config.Debug = false -- Used to show some prints in client and server console
Config.ZonesDebug = false -- It will show the zones debug
Config.Target = exports["av_laptop"]:getTarget() -- No need to modify this, do it from av_laptop/config directly
Config.ZonesTarget = true -- true it will use target system for zones, false it will use default E to interact
Config.InteractionKey = 38 -- key used for interaction zones when not using target script
Config.delivery_key = 38 -- key used for orders delivery when not using target script
Config.supplies_key = 38 -- key used to interact with supplies NPC when not using target script
Config.Command = "admin:business" -- Used to open the admin menu
Config.AdminLevel = { "group.admin", "group.god" } -- Permission level needed to use admin command
Config.BankAccount = "bank" -- Used for deposit/withdraw and receive bonus payments
Config.UnemployedJobName = "unemployed" -- If a player gets fired he will get this job

-- Misc:
Config.UseMetadataImage = false -- Enable this to store item image URL in metadata; essential for servers using non-Latin characters (e.g., Japanese, Chinese).

-- Ingredients settings:
Config.MinIngredients = 0 -- Min ingredients needed to register a new item in the Products tab
Config.MaxIngredients = 5 -- max ingredients u can select when u register an item in the Products tab

-- true/false allow players to set a custom description for item, false it will use the registered in av_items table
-- benefits: players can add coupon codes, the customer name or any other message visible on inventory
Config.CustomDescriptionJobs = { -- List of jobs with permission to write custom description on items
	["uwucafe"] = true,
	["burgershot"] = true,
	["upnatom"] = true,
}

Config.App = {
	name = "business",
	label = "Business", -- You can rename the app by editing this field
	maximize = true,
	isEnabled = function(serial)
		local job = exports["av_laptop"]:getJob()
		if (job and job.name) and not Config.BlacklistedJobs[job.name] then
			return true
		end
		return false
	end,
}

Config.BlacklistedJobs = { -- jobs from this list won't be able to access the business app
	["unemployed"] = true,
	["slaughterer"] = true,
	["fisherman"] = true,
	["miner"] = true,
	["lumberjack"] = true,
	["fueler"] = true,
	["reporter"] = true,
	["tailor"] = true,
}

-- The following jobs won't be able to register new items, they can only use the provided by administration
Config.BlacklistedItemJobs = {
	["myJob1"] = true,
	["myJob2"] = true,
}

function dbug(...)
	if Config.Debug then
		print("^3[DEBUG]^7", ...)
	end
end

function warn(...)
	print("^1[WARNING]^7", ...)
end
