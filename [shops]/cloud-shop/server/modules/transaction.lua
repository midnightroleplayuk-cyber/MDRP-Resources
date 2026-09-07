-- Configuration
local Config = require("config.main")
local Functions = require("config.functions")

-- Locales
local locales = lib.loadJson(("locales.%s"):format(Config.Locale))

---@param source number
---@param type string
---@param cartArray table
---@return boolean, string
lib.callback.register("cloud-shop:processTransaction", function(source, type, cartArray)
	if not source or source <= 0 then return false, "Invalid source" end
	if not cartArray or #cartArray == 0 then return false, "Cart is empty or invalid" end

	local currentShop = Player(source).state["currentShop"]
	if not currentShop or not Config.Shops[currentShop] then return false, "Invalid shop state" end

	local accountType = type == "bank" and "bank" or "cash"
	local availableMoney = Bridge.GetMoney(source, accountType)
	if availableMoney <= 0 then return false, "Not enough money" end

	local shopItems = Config.Shops[currentShop].Items
	if not shopItems then return false, "Invalid shop configuration" end

	local validItems = {}
	for i = 1, #shopItems do
		local item = shopItems[i]
		validItems[item.name] = item
	end

	local totalCartPrice = 0
	local anySuccess = false

	for i = 1, #cartArray do
		local item = cartArray[i]

		if not item or not item.name or not item.label or not item.price or not item.quantity then
			log.warn("Invalid item in cart:" .. item.name)
			goto skipItem
		end

		local configItem = validItems[item.name]
		if not configItem then
			log.warn("Non existent item in cart:" .. item.name)
			goto skipItem
		end

		if item.quantity <= 0 or item.quantity > 999 then
			log.warn(("Invalid quantity for item %s: %d"):format(item.name, item.quantity))
			goto skipItem
		end

		if item.price ~= configItem.price then
			log.warn(("Price mismatch for item %s: expected %d, got %d"):format(item.name, configItem.price, item.price))
			goto skipItem
		end

		local totalItemPrice = item.price * item.quantity
		if availableMoney < totalItemPrice then
			Functions.Notify.Server(source, {
				title = locales.notify.no_money.shop.title,
				description = locales.notify.no_money.shop.description:format(item.label, item.price),
				type = locales.notify.no_money.shop.type,
			})
			goto skipItem
		end

		local success, message = Bridge.AddItem(source, item.name, item.quantity)
		log.debug("AddItem: " .. message)

		if not success then
			Functions.Notify.Server(source, {
				title = locales.notify.cant_add.item.title,
				description = locales.notify.cant_add.item.description:format(item.label),
				type = locales.notify.cant_add.item.type,
			})
			goto skipItem
		end

		availableMoney = availableMoney - totalItemPrice
		totalCartPrice = totalCartPrice + totalItemPrice
		anySuccess = true

		::skipItem::
	end

	if not anySuccess then return false, "No items could be purchased" end

	local removed = Bridge.RemoveMoney(source, accountType, totalCartPrice)
	if not removed then return false, "Failed to remove money from account" end

	Functions.Notify.Server(source, {
		title = locales.notify.payment_success.shop.title,
		description = locales.notify.payment_success.shop.description:format(totalCartPrice),
		type = locales.notify.payment_success.shop.type,
	})

	return true, ("Purchased items for $%d"):format(totalCartPrice)
end)
