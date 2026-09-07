---@diagnostic disable: duplicate-set-field

if not detectFramework("qbox", "qbx_core") then return end

local Config = require("config.main")

Bridge = {}

--- @param source number
--- @return table|nil
local function getPlayerObject(source)
	if not source or source == 0 then return nil end
	return exports.qbx_core:GetPlayer(source)
end

--[[ Item Handling ]]

---@param itemName string
---@return boolean
local function isWeapon(itemName)
	return itemName:sub(1, 7):lower() == "weapon_" and not Config.WeaponAsItem and GetResourceState("ox_inventory") ~= "started"
end

---@param source number
---@param itemName string
---@param quantity number
---@return boolean
local function canCarryItem(source, itemName, quantity)
	if GetResourceState("ox_inventory") == "started" then
		return exports.ox_inventory:CanCarryItem(source, itemName, quantity)
	else
		return true
	end
end

---@param source number
---@param itemName string
---@param quantity number
---@return boolean, string
local function addItem(source, itemName, quantity)
	if not canCarryItem(source, itemName, quantity) then return false, "Cannot carry item" end

	if GetResourceState("ox_inventory") == "started" then
		local success = exports.ox_inventory:AddItem(source, itemName, quantity)
		return success, success and "Item added" or "Failed to add item"
	else
		log.error("[Bridge.AddItem] No supported inventory detected")
		return false, "Failed to add item"
	end
end

---@param source number
---@param weaponName string
---@return boolean
local function hasWeapon(source, weaponName)
	return false
end

---@param source number
---@param weaponName string
---@return boolean, string
local function addWeapon(source, weaponName)
	if hasWeapon(source, weaponName) then return false, "Already has weapon" end
	return false, "Failed to add weapon"
end

---@param source number
---@param itemName string
---@param quantity number
---@return boolean, string
function Bridge.AddItem(source, itemName, quantity)
	if not source or source <= 0 then return false, "Invalid source" end
	if not itemName then return false, "Invalid item name" end
	if not quantity or quantity <= 0 then return false, "Invalid quantity" end

	if isWeapon(itemName) then
		return addWeapon(source, itemName)
	else
		return addItem(source, itemName, quantity)
	end
end

--[[ Money Handling ]]

---@param source number
---@param accountType string <"cash"|"bank">
---@return number|nil
function Bridge.GetMoney(source, accountType)
	if not accountType then return end

	local Player = getPlayerObject(source)
	if not Player then return nil end

	return Player.Functions.GetMoney(accountType) or nil
end

---@param source number
---@param accountType string <"cash"|"bank">
---@param amount number
---@return boolean
function Bridge.RemoveMoney(source, accountType, amount)
	if not accountType then return false end
	if not amount or amount <= 0 then return false end

	local Player = getPlayerObject(source)
	if not Player then return false end

	return Player.Functions.RemoveMoney(accountType, amount)
end

--[[ License Handling ]]

---@param source number
---@param licenseType string
---@return boolean
lib.callback.register("cloud-shop:hasLicense", function(source, licenseType)
	if not source or source <= 0 then return false end
	if not licenseType then return false end

	local Player = getPlayerObject(source)
	if not Player then return false end

	return Player.PlayerData.metadata.licences[licenseType] or false
end)

---@param source number
---@param licenseType string
function Bridge.AddLicense(source, licenseType)
	if not source or source <= 0 then return end
	if not licenseType then return end

	local Player = getPlayerObject(source)
	if not Player then return end

	local licenseTable = Player.PlayerData.metadata.licences
	licenseTable[licenseType] = true
	Player.Functions.SetMetaData("licences", licenseTable)
end

--[[ Job Handling ]]

--- @param source number
--- @return string|nil, number|nil
lib.callback.register("cloud-shop:getJobData", function(source)
	local Player = getPlayerObject(source)
	if not Player then return nil end

	local job = Player.PlayerData.job or { name = "unknown", grade = { level = 0 } }
	local gang = Player.PlayerData.gang or { name = "none", label = "unknown", grade = { level = 0 } }

	-- If player has both gang and job, prioritize job info
	if gang.name ~= "none" and job.name ~= "unemployed" then return job.name, job.grade.level end

	-- Otherwise, use gang if exists, fallback to job
	return gang.name ~= "none" and gang.label or job.name, gang.name ~= "none" and gang.grade.level or job.grade.level
end)
