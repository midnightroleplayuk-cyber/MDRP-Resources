Config = Config or {}
Config.Events = { -- Used to create zones
	-- key index needs to be the item type
	-- label: string (except for cashiers, it uses table)
	-- subheader?:string Description for context menu (only available if not using target)
	-- icon: "string" (except for cashiers, it uses table)
	-- job: boolean (job restricted zone)
	-- icons are from the free section in fontawesome website: https://fontawesome.com/search?m=free&o=r
	["cashier"] = { -- Cashier zone (pay, cashier and counter options in the same zone)
		label = {
			employee = "Cashier",
			customer = "Pay",
			counter = "Order",
		},
		icon = {
			employee = "fas fa-cash-register",
			customer = "fas fa-credit-card",
			counter = "fas fa-cash-register",
		},
		subheader = {
			employee = "Create a new order",
			customer = "Pay for your order",
			counter = "Order Something",
		},
		event = {
			employee = "av_business:cashierEmployee",
			customer = "av_business:cashierCustomer",
			counter = "av_business:cashierCounter",
		},
		job = {
			employee = true,
			customer = false,
			counter = false,
		},
	},
	["drink"] = { -- For Drinks crafting stations
		label = "Drinks",
		subheader = "Use the drinks station",
		event = "av_business:products",
		icon = "fas fa-glass-whiskey",
		job = true,
	},
	["food"] = { -- For Food crafting stations
		label = "Food",
		subheader = "Use the food station",
		event = "av_business:products",
		icon = "fas fa-utensils",
		job = true,
	},
	["joint"] = { -- For Joint crafting station
		label = "Joint",
		subheader = "Use the joint station",
		event = "av_business:products",
		icon = "fas fa-cannabis",
		job = true,
	},
	["alcohol"] = { -- For Alcohol crafting station
		label = "Alcohol",
		subheader = "Use the alcohol station",
		event = "av_business:products",
		icon = "fa-solid fa-wine-glass",
		job = true,
	},
	["others"] = { -- For other crafting stations that don't fit in the previous categories
		label = "Others",
		subheader = "Use the others station",
		event = "av_business:products",
		icon = "fas fa-box",
		job = true,
	},
	["stash"] = { -- For stash zones
		label = "Stash",
		subheader = "Open the business stash",
		event = "av_business:stash",
		icon = "fas fa-box-open",
		job = true,
	},
	["tray"] = { -- For customer trays
		label = "Tray",
		subheader = "Open the tray",
		event = "av_business:tray",
		icon = "fas fa-box-open",
		job = false,
	},
	["duty"] = { -- For toggling duty status
		label = "Duty",
		subheader = "Toggle your duty status",
		event = "av_business:duty",
		icon = "fa-solid fa-briefcase",
		job = true,
	},
	["applications"] = { -- For job applications
		label = "Applications",
		subheader = "Leave your job application",
		event = "av_business:applications",
		icon = "fa-solid fa-briefcase",
		job = false,
	},
	["box"] = { -- For box zones, used to grab boxes for products or to pack orders
		label = "Boxes",
		subheader = "Grab a box for your products",
		event = "av_business:products",
		icon = "fa-solid fa-box",
		job = true,
	},
	["orders"] = { -- For viewing pending orders
		label = "Orders",
		subheader = "View pending orders",
		event = "av_business:orders",
		icon = "fa-solid fa-clipboard-list",
		job = true,
	},
	["poster"] = { -- For showing the business poster
		label = "Poster",
		subheader = "View the business poster",
		event = "av_business:showPoster",
		icon = "fa-solid fa-file-image",
		job = false,
	},
	["dirty_vault"] = { -- For the dirty vault, where boss can launder the dirty money they got from sales
		label = "Vault",
		subheader = "Business Vault",
		event = "av_business:openVault",
		icon = "fa-solid fa-vault",
		job = true,
	},
	["pawnshop"] = { -- For pawnshop cashiers and trays, since they have a different functionality than the regular ones
		admin = "Pawnshop Cashier", -- only used for admin menu
		label = { employee = "Cashier", customer = "Tray" },
		icon = { employee = "fas fa-cash-register", customer = "fas fa-box" },
		subheader = {
			employee = "Check the pawnshop tray",
			customer = "Open the pawnshop tray",
		},
		event = { employee = "av_business:pawnCashier", customer = "av_business:pawnTray" },
		job = { employee = true, customer = false },
	},
	["counter_stash"] = { -- For counter stash zones (offline shop)
		label = "Counter Stash",
		subheader = "Open the counter stash",
		event = "av_business:counterStash",
		icon = "fas fa-box-open",
		job = true,
	},
	["loyalty_print"] = { -- For printing loyalty cards at the designated zone
		label = "Loyalty Cards",
		subheader = "Print a loyalty card for a customer",
		event = "av_business:loyaltyPrintZone",
		icon = "fa-solid fa-id-card",
		job = true,
	},
	-- Please DON'T modify the index key name, the script need it to detect the type of zone, you can modify the label and subheader
	["business_polyzone"] = { -- For polyzone business zones, used for cleaning and other interactions that require a zone instead of a point
		label = "Business PolyZone",
		subheader = "Custom business zone",
	},
	["rate"] = {
		label = "Rate Us",
		subheader = "Provide feedback about your experience",
		event = "av_business:rate",
		icon = "fa-solid fa-star",
		job = false,
	},
}
