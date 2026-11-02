local frameworkPrices = nil

function GeneratePlate()
	local plate = lib.string.random("1AA11A.A", 8):upper()
	local exists = MySQL.scalar.await(
		"SELECT "
			.. Database.PlatesColumn
			.. " FROM "
			.. Database.VehiclesTable
			.. " WHERE "
			.. Database.PlatesColumn
			.. " = ?",
		{ plate }
	)
	if exists then
		return GeneratePlate()
	end
	return plate
end

function SaveSoldVehicle(customerId, model, plates, mods)
	local framework = exports["av_laptop"]:getFramework()
	if framework == "qb" or framework == "qbox" then
		local identifier = GetIdentifier(customerId)
		local license = GetLicense(customerId)
		MySQL.insert.await(
			"INSERT INTO "
				.. Database.VehiclesTable
				.. " (license, citizenid, vehicle, hash, mods, "
				.. Database.PlatesColumn
				.. ", state) VALUES (?, ?, ?, ?, ?, ?, ?)",
			{
				license,
				identifier,
				model,
				joaat(model),
				mods and json.encode(mods) or "{}",
				plates,
				0,
			}
		)
		return true
	end
	if framework == "esx" then
		local identifier = GetIdentifier(customerId)
		-- ESX garages read `type` to know which garage the vehicle belongs to.
		local category = Vehicles[model] and Vehicles[model].category
		local vehType = (category and Config.Types and Config.Types[category]) or Config.DefaultType or "car"
		MySQL.insert.await(
			"INSERT INTO "
				.. Database.VehiclesTable
				.. " (owner, "
				.. Database.PlatesColumn
				.. ", vehicle, type, stored) VALUES (?, ?, ?, ?, ?)",
			{
				identifier,
				plates,
				mods and json.encode(mods) or "{}",
				vehType,
				0,
			}
		)
		return true
	end
	warn("SaveSoldVehicle: unsupported framework, add your own insert in server/editable/vehicles.lua")
	return false
end

function ChangeVehicleOwner(currentOwner, newOwner, plates)
	MySQL.update.await(
		"UPDATE "
			.. Database.VehiclesTable
			.. " SET "
			.. Database.OwnerColumn
			.. " = ? WHERE "
			.. Database.OwnerColumn
			.. " = ? AND "
			.. Database.PlatesColumn
			.. " = ?",
		{
			newOwner,
			currentOwner,
			plates,
		}
	)
end

function DeleteOwnedVehicle(plates)
	MySQL.query.await(
		"DELETE FROM " .. Database.VehiclesTable .. " WHERE " .. Database.PlatesColumn .. " = ?",
		{ plates }
	)
end

local function frameworkPriceList()
	if frameworkPrices ~= nil then
		return frameworkPrices
	end
	frameworkPrices = {}
	local framework = exports["av_laptop"]:getFramework()
	if framework == "qb" then
		local ok, shared = pcall(function()
			return exports["qb-core"]:GetCoreObject().Shared.Vehicles
		end)
		if ok and type(shared) == "table" then
			for _, entry in pairs(shared) do
				local model = entry.model or entry.name
				if model and tonumber(entry.price) then
					frameworkPrices[tostring(model):lower()] = tonumber(entry.price)
				end
			end
		end
	elseif framework == "qbox" then
		local ok, shared = pcall(function()
			return exports.qbx_core:GetVehiclesByName()
		end)
		if ok and type(shared) == "table" then
			for model, entry in pairs(shared) do
				if tonumber(entry.price) then
					frameworkPrices[tostring(model):lower()] = tonumber(entry.price)
				end
			end
		end
	elseif framework == "esx" then
		local ok, rows = pcall(function()
			return MySQL.query.await("SELECT model, price FROM vehicles")
		end)
		if ok and type(rows) == "table" then
			for _, row in ipairs(rows) do
				if row.model and tonumber(row.price) then
					frameworkPrices[tostring(row.model):lower()] = tonumber(row.price)
				end
			end
		end
	end
	return frameworkPrices
end

function FrameworkVehiclePrice(model)
	if not model then
		return nil
	end
	local price = frameworkPriceList()[tostring(model):lower()]
	if price and price > 0 then
		return math.floor(price)
	end
	return nil
end

function IsVehicleOut(row)
	local framework = exports["av_laptop"]:getFramework()
	if framework == "esx" then
		return (tonumber(row.stored) or 0) == 0
	end
	return (tonumber(row.state) or 0) == 0
end

function GetLicense(src)
	local identifier = GetPlayerIdentifierByType and GetPlayerIdentifierByType(src, "license") or nil
	return identifier or ""
end
