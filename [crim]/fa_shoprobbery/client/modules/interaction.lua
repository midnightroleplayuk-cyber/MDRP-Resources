-- Configuration
local Functions = require("config.functions")

-- Modules
local ShopPeds = require("client.modules.shop-ped")
local Robbery = require("client.modules.fa-shoprobbery")
local checkJob = require("client.modules.job")
local checkLicense = require("client.modules.license")

---@param shopKey string
local function openShopUI(shopKey)
	if not Robbery.CanUseActive() then return end
	Functions.ToggleHud(false)

	SetNuiFocus(true, true)
	SendNUIMessage({ action = "toggleShop", showShop = true })
	LocalPlayer.state:set("currentShop", shopKey, true)

	while IsScreenblurFadeRunning() do
		Wait(50)
	end
	if LocalPlayer.state["currentShop"] ~= shopKey or not Robbery.CanUseActive() then return end
	TriggerScreenblurFadeIn(200)

	ShopPeds.ApplySpeech("Generic_Hi", "Speech_Params_Force")
end

---@param shopKey string
---@param shopData table
local function openShop(shopKey, shopData, shopCoords)
	if not shopKey or not shopData then return end
	if not shopCoords then
		local playerCoords = GetEntityCoords(cache.ped)
		local nearestDistance = math.huge
		for i = 1, #shopData.Locations do
			local coords = shopData.Locations[i]
			local distance = #(vector3(coords.x, coords.y, coords.z) - playerCoords)
			if distance < nearestDistance then shopCoords = coords nearestDistance = distance end
		end
	end
	if not shopCoords or not Robbery.CanUse(shopCoords) then return end

	log.verbose("[openShop]", json.encode({ "Categories:", shopData.Categories, "Items:", shopData.Items }))

	if shopData.Requirement.Job.required and not checkJob(shopData) then return end
	if shopData.Requirement.License.required and not checkLicense(shopKey, shopData) then return end

	-- License callbacks can yield while the clerk changes state.
	if not Robbery.CanUse(shopCoords) then return end
	Robbery.SetActive(shopCoords)
	openShopUI(shopKey)
end

local function closeShopUI()
	Robbery.SetActive(nil)
	SetNuiFocus(false, false)
	SendNUIMessage({ action = "toggleShop", showShop = false })
	LocalPlayer.state:set("currentShop", nil, true)

	while IsScreenblurFadeRunning() do
		Wait(50)
	end
	TriggerScreenblurFadeOut(200)

	Functions.ToggleHud(true)

end

local function closeShop()
	closeShopUI()
	ShopPeds.ApplySpeech("Generic_Bye", "Speech_Params_Force")
end

return {
	Open = openShop,
	OpenUI = openShopUI,
	Close = closeShop,
	CloseUI = closeShopUI,
}
