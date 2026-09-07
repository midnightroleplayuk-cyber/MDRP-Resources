-- Configuration
local Config = require("config.main")
local Functions = require("config.functions")

-- Locales
local locales = lib.loadJson(("locales.%s"):format(Config.Locale))

---@param source number
---@param shopData table
---@return boolean, string
lib.callback.register("cloud-shop:buyLicense", function(source, shopData)
	if not source or source <= 0 then return false, "Invalid source" end
	if not shopData then return false, "Invalid shop data" end
	if not Player(source).state["currentShop"] then return false, "Invalid shop state" end

	local licenseType = shopData.Requirement.License.type
	local licenseLabel = shopData.Requirement.License.label
	local licensePrice = shopData.Requirement.License.price

	local cashAvailable = Bridge.GetMoney(source, "cash")
	local bankAvailable = Bridge.GetMoney(source, "bank")
	local accountType = nil

	if cashAvailable >= licensePrice then
		accountType = "cash"
	elseif bankAvailable >= licensePrice then
		accountType = "bank"
	else
		Functions.Notify.Server(source, {
			title = locales.notify.no_money.license.title,
			description = locales.notify.no_money.license.description:format(licenseLabel),
			type = locales.notify.no_money.license.type,
		})
		return false, "No money"
	end

	local success = Bridge.RemoveMoney(source, accountType, licensePrice)
	if not success then return false, "Failed to remove money from player" end

	Bridge.AddLicense(source, licenseType)

	Functions.Notify.Server(source, {
		title = locales.notify.payment_success.license.title,
		description = locales.notify.payment_success.license.description:format(licenseLabel, licensePrice),
		type = locales.notify.payment_success.license.type,
	})
	return true, "Successfully bought license"
end)
