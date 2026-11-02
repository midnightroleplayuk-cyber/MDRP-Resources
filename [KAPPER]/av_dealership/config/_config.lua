Config = {}
Config.PaymentsCommand = "payments" -- false to disable; opens the customer debt panel anywhere
Config.AdminCommand = "admin:dealership" -- command for admin panel
Config.BankAccount = "bank"
Config.MaxShowroomSlots = 12

Config.App = {
	name = "dealership",
	label = "Dealership", -- You can rename the app by editing this field
	isEnabled = function(serial)
		return lib.callback.await("av_dealership:isDealer", false, serial) == true
	end,
}
-- The Motors App config
Config.PublicApp = {
	enabled = true,
	name = "avmotors",
	label = "Motors",
}

-- Motors as an app on sd-phone. Ignored when sd-phone is not running
Config.PhoneApp = {
	enabled = true,
	identifier = "avmotors", -- unique app id
	name = "Motors", -- home screen and App Store name
	description = "Your financed vehicles, rentals, insurance and history.",
	developer = "AV Scripts",
	defaultApp = true, -- false = the player downloads it from the App Store
}

-- Auctions that dealerships open to civilians from their own warehouse stock
Config.CivilAuctions = {
	maxIncrement = 10000, -- a bid can raise the current one by at most this
	lockSeconds = 30, -- no bids accepted when less than this is left
	maxHours = 6, -- longest duration a dealership can pick
}

Config.AdminPanel = {
	accent = "#5effd8",
}

Config.Themes = {
	"#5effd8",
	"#4f6df5",
	"#6e39ff",
	"#0ea5a4",
	"#3fa96e",
	"#e8a33d",
	"#e05252",
	"#2f7de1",
	"#d9569b",
}

Config.Dealership = {
	currency = "$",
	speedUnit = "mph",
	unemployedJob = "unemployed",
	blipsAlwaysOn = true, -- false = the map only shows dealerships that are open
	disableVehiclesWithWeapons = true, -- ignore vehicles that have weapons when using admin import tool
}

-- Money accounts that can be used for dealership transactions
-- The `canUse` function is called to determine if the account is available for use
-- `label` is the name shown everywhere in the app, rename it freely
-- `symbol` is written before the amount, leave it out to use Config.Dealership.currency
-- `suffix` is written after the amount, handy for anything that is not money
Config.AvailableAccounts = {
	{
		value = "bank",
		label = "Bank Account",
		canUse = function(playerId)
			return true
		end,
	},
	{
		value = "cash",
		label = "Cash",
		canUse = function(playerId)
			return true
		end,
	},
	{
		value = "tokens",
		label = "VIP Tokens",
		symbol = "",
		suffix = " Tokens",
		canUse = function(playerId)
			return GetResourceState("av_vip") == "started"
		end,
	},
}

-- Ignored categories when using admin import tool
Config.BlacklistedCategories = {
	["10"] = true,
	["11"] = true,
	["17"] = true,
	["18"] = true,
	["19"] = true,
	["21"] = true,
}

Config.Colors = {
	{ index = 0, hex = "#0d0f13" },
	{ index = 111, hex = "#e5e5e0" },
	{ index = 4, hex = "#c0c0c0" },
	{ index = 27, hex = "#bf0010" },
	{ index = 38, hex = "#ffa500" },
	{ index = 99, hex = "#ffd700" },
	{ index = 92, hex = "#32cd32" },
	{ index = 51, hex = "#2e8b57" },
	{ index = 67, hex = "#70d1f4" },
	{ index = 73, hex = "#77a2d1" },
	{ index = 64, hex = "#0000ff" },
	{ index = 145, hex = "#bf40bf" },
	{ index = 136, hex = "#ff9999" },
	{ index = 96, hex = "#7b3f00" },
}

Config.Categories = {
	["0"] = { value = "compacts", label = "Compacts", basePrice = 1000 },
	["1"] = { value = "sedans", label = "Sedans", basePrice = 1000 },
	["2"] = { value = "suvs", label = "SUVs", basePrice = 1000 },
	["3"] = { value = "coupes", label = "Coupes", basePrice = 1000 },
	["4"] = { value = "muscle", label = "Muscle", basePrice = 1000 },
	["5"] = { value = "sportsclassic", label = "Sports Classics", basePrice = 1000 },
	["6"] = { value = "sports", label = "Sports", basePrice = 1000 },
	["7"] = { value = "super", label = "Super", basePrice = 1000 },
	["8"] = { value = "motorcycles", label = "Motorcycles", basePrice = 1000 },
	["9"] = { value = "offroad", label = "Off-road", basePrice = 1000 },
	["10"] = { value = "industrial", label = "Industrial", basePrice = 1000 },
	["11"] = { value = "utility", label = "Utility", basePrice = 1000 },
	["12"] = { value = "vans", label = "Vans", basePrice = 1000 },
	["13"] = { value = "cycles", label = "Cycles", basePrice = 1000 },
	["14"] = { value = "boats", label = "Boats", basePrice = 1000 },
	["15"] = { value = "helicopters", label = "Helicopters", basePrice = 1000 },
	["16"] = { value = "planes", label = "Planes", basePrice = 1000 },
	["17"] = { value = "service", label = "Service", basePrice = 1000 },
	["18"] = { value = "emergency", label = "Emergency", basePrice = 1000 },
	["19"] = { value = "military", label = "Military", basePrice = 1000 },
	["20"] = { value = "commercial", label = "Commercial", basePrice = 1000 },
	["21"] = { value = "trains", label = "Trains", basePrice = 1000 },
	["22"] = { value = "openwheel", label = "Open Wheel", basePrice = 1000 },
}

-- Starting bid = base price / divider. A category listed here overrides
-- Auctions.defaultDivider, so cheap classes can open closer to their value
-- and supercars can open lower. Keys are the `value` of Config.Categories.
Config.AuctionDividers = {
	-- ["super"] = 2.5,
	-- ["sports"] = 2.2,
	-- ["compacts"] = 1.6,
}

function dbug(...)
	if GlobalState["dealerDebug"] then
		print("^3[DEBUG]^7", ...)
	end
end

function warn(...)
	print("^1[WARNING]^7", ...)
end
