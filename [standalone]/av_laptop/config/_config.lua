-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/
-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/
-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/

Config = Config or {}
Config.AdminCommand = "admin:laptop" -- Admin panel command
Config.AdminGroups = { "group.admin", "group.god" } -- Groups allowed to use Config.AdminCommand
Config.LaptopItem = "laptop" -- The item used to open laptop
Config.HackingDeviceITem = "decrypter" -- Item used to hack laptops.
Config.BossGrades =
	{ -- This only applies for ESX, many ppl uses different boss grade names (boss, owner, chief, etc) add them here
		["boss"] = true,
		["owner"] = true,
		["chief"] = true,
	}

-- App toggles, battery, homepage and the rest of the runtime options live in the admin panel (Config.AdminCommand)
Config.UseTerminal = function(serial)
	return true -- you can add conditions here to only allow certain laptops to use terminal app
end

-- Other laptop configs
Config.UIlib = "lation_ui" -- Avaiable options "ox_lib" or "lation_ui"

--[[
    if you want to use an item as a money account add it here, the key is the item name and the value is true/false
    Useful for servers that want to use an item as a money account in APPs like Darkmarket, Business or any other where you can pay for something.
    So when the getMoney, addMoney or removeMoney functions are called it will check if the account is an item
    and if it is it will add/remove the item from the player's inventory instead of money
]]
Config.UseItemAsMoneyAccount = {
	["my_item_name"] = true,
}

-- Container config, this config is ONLY AVAILABLE WITH OX_INVENTORY and origen_inventory
Config.Container = {
	whitelist = { -- list of items allowed in laptop container
		["black_usb"] = true,
		["decrypter"] = true,
		["dongle"] = true,
		["pendrive"] = true,
		["vpn"] = true,
	},
}

exports("getFramework", function() -- don't edit/remove this
	return Config.Framework
end)

exports("getInventory", function() -- don't edit/remove this
	return Config.Inventory
end)

exports("getTarget", function() -- don't edit/remove this
	return Config.Target
end)

function dbug(...)
	if Config.Debug then
		print("^3[DEBUG]^7", ...)
	end
end
