if not LoadResourceFile(cache.resource, "web/dist/index.html") then error("UI has not been built! Download the release version from https://github.com/cloud-resources/cloud-shop/releases") end

-- Configuration
local Config = require("config.main")
local Functions = require("config.functions")

-- Locales
local locales = lib.loadJson(("locales.%s"):format(Config.Locale))

-- Modules
local Interaction = require("client.modules.interaction")
local ShopPeds = require("client.modules.shop-ped")
local handleTransaction = require("client.modules.transaction")

--[[ Initialization ]]

LocalPlayer.state:set("currentShop", nil, true)

local function getInteractDistance(shopData)
	if shopData.Interaction.HelpText.enabled then
		return shopData.Interaction.HelpText.distance
	elseif shopData.Interaction.FloatingText.enabled then
		return shopData.Interaction.FloatingText.distance
	end
	return nil
end

local function createPoints(shopKey, shopData, shopCoords)
	local shopPoint = lib.points.new({
		coords = shopCoords,
		distance = shopData.PointRadius,
		interactDistance = getInteractDistance(shopData),
		ped = nil,
	})

	function shopPoint:onEnter()
		if shopData.Indicator.Ped.enabled then self.ped = ShopPeds.Spawn(shopData, shopCoords) end
	end

	function shopPoint:onExit()
		if shopData.Indicator.Ped.enabled then ShopPeds.Delete(self.ped) end
	end

	function shopPoint:nearby()
		if not LocalPlayer.state["currentShop"] then
			if shopData.Indicator.Marker.enabled then
				local markerConfig = shopData.Indicator.Marker
				---@diagnostic disable-next-line: missing-parameter
				DrawMarker(markerConfig.type, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerConfig.size.x, markerConfig.size.y, markerConfig.size.z, markerConfig.color[1], markerConfig.color[2], markerConfig.color[3], markerConfig.color[4], markerConfig.bobUpAndDown, markerConfig.faceCamera, 2, markerConfig.rotate)
			end
		end

		if shopData.Interaction.HelpText.enabled or shopData.Interaction.FloatingText.enabled then
			if self.isClosest and self.currentDistance <= self.interactDistance then
				if IsPlayerDead(cache.playerId) or IsPedInAnyVehicle(cache.ped, false) then return end

				if not LocalPlayer.state["currentShop"] then
					if shopData.Interaction.HelpText.enabled then Functions.Interact.HelpText(locales.interaction.help_text) end
					if shopData.Interaction.FloatingText.enabled then Functions.Interact.FloatingHelpText(locales.interaction.floating_text, self.ped, self.coords) end
				end

				if IsControlJustReleased(0, shopData.Interaction.OpenKey) then Interaction.Open(shopKey, shopData) end
			end
		end
	end
end

CreateThread(function()
	for shopKey, shopData in pairs(Config.Shops) do
		for i = 1, #shopData.Locations do
			local shopCoords = shopData.Locations[i]

			if shopData.Blip.enabled then createBlip(shopCoords, shopData.Blip) end
			createPoints(shopKey, shopData, shopCoords)
			if shopData.Interaction.Target.enabled then Functions.Interact.AddTarget(shopKey, shopData, shopCoords, Interaction.Open) end
		end
	end
end)

--[[ NUI Callbacks ]]

RegisterNUICallback("shop:callback", function(data, cb)
	local actionName = data.action
	if type(actionName) ~= "string" then return end

	local shopData = Config.Shops[LocalPlayer.state["currentShop"]]

	local handlers = {
		closeShop = function()
			local success = pcall(Interaction.Close)
			cb(success)
		end,

		payItems = function()
			log.debug(("[NUI:payItems] Payment Type: %s | Cart Array: %s"):format(data.type, json.encode(data.cart)))

			local success = handleTransaction(data.type, data.cart)
			if success then ShopPeds.ApplySpeech("Generic_Thanks", "Speech_Params_Force_Shouted_Critical") end
			cb(success)
		end,

		-- Initialization

		getCategories = function()
			cb(shopData.Categories)
		end,
		getItems = function()
			cb(shopData.Items)
		end,
		getLocales = function()
			locales.ui.main.header = shopData.Locales.MainHeader
			locales.ui.cart.header = shopData.Locales.CartHeader
			cb({ imagePath = Config.ImagePath, soundVolume = (GetProfileSetting(300) / 10), locales = locales.ui })
		end,

		-- Sounds

		selectCategory = function()
			playSound("select")
			cb(true)
		end,
		addItem = function()
			playSound("add")
			cb(true)
		end,
		updateQuantity = function()
			playSound("quantity")
			cb(true)
		end,
		removeItem = function()
			playSound("remove")
			cb(true)
		end,
	}

	local handler = handlers[actionName]
	if handler then handler() end
end)

-- [[ Clean Up ]]

local function cleanUp()
	Interaction.CloseUI()
	ShopPeds.DeleteAll()
end

AddEventHandler("onResourceStop", function(resource)
	if resource ~= cache.resource then return end
	cleanUp()
end)
