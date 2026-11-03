function RemoveMoneyRTX(playersource, moneydata)
	if Config.Framework == "esx" then
		local xPlayer = ESX.GetPlayerFromId(playersource)
		if xPlayer then
			xPlayer.removeMoney(moneydata)
		end
	elseif Config.Framework == "qbcore" then
		local xPlayer = QBCore.Functions.GetPlayer(playersource)
		if xPlayer then	
			xPlayer.Functions.RemoveMoney('cash', moneydata)	
		end
	elseif Config.Framework == "standalone" then
		
	end
end	

function GetMoneyRTX(playersource)
	local moneydata = 0
	if Config.Framework == "esx" then
		local xPlayer = ESX.GetPlayerFromId(playersource)
		if xPlayer then
			moneydata = xPlayer.getMoney()
		end
	elseif Config.Framework == "qbcore" then
		local xPlayer = QBCore.Functions.GetPlayer(playersource)
		if xPlayer then	
			moneydata = xPlayer.Functions.GetMoney('cash')
		end
	elseif Config.Framework == "standalone" then
		moneydata = 99999999999
	
	end
	return moneydata
end

function GiveStorageReward(playersource, storagetype, storageitemid)
	if Config.Framework == "esx" then
		local xPlayer = ESX.GetPlayerFromId(playersource)
		if xPlayer then
			local storagetypehandler = Config.StorageType[storagetype]
			local storageitemhandler = storagetypehandler.randomitems[storageitemid]		
			print(storageitemhandler.itemtype)
			if storageitemhandler.itemtype == "item" then
				print("here give")
				xPlayer.addInventoryItem(storageitemhandler.itemname, storageitemhandler.itemcount)
			elseif storageitemhandler.itemtype == "event" then
				--	
			elseif storageitemhandler.itemtype == "weapon" then			
				local weaponName = string.upper(storageitemhandler.itemname)

				xPlayer.addWeapon(weaponName, 1)				
			end
		end		
	end
	if Config.Framework == "qbcore" then
		local xPlayer = QBCore.Functions.GetPlayer(playersource)
		if xPlayer then	
			local storagetypehandler = Config.StorageType[storagetype]
			local storageitemhandler = storagetypehandler.randomitems[storageitemid]		
			if storageitemhandler.itemtype == "item" then
				xPlayer.Functions.AddItem(storageitemhandler.itemname, storageitemhandler.itemcount, false, {})
			elseif storageitemhandler.itemtype == "event" then
				--			
			end			
		end		
	end		
	if Config.Framework == "standalone" then
		local storagetypehandler = Config.StorageType[storagetype]
		local storageitemhandler = storagetypehandler.randomitems[storageitemid]		
		if storageitemhandler.itemtype == "item" then
			-- add here your add item funciton for player example form esx - xPlayer.addInventoryItem(storageitemhandler.itemname, storageitemhandler.itemcount) 
		elseif storageitemhandler.itemtype == "event" then
			--			
		end				
	end			
end

if Config.Framework == "esx" then
	RegisterCommand("startstoragewars", function(source, args, raw)
		local playersource = source
		if playersource == 0 then	
			if storagewarstimerstartactivated == false then
				print(LanguageFile("manualstart", Config.StorageWarsStartTime*60))
				StorageWarsTimerStart()
			end
		else
			local xPlayer = ESX.GetPlayerFromId(playersource)
			local playergroup = xPlayer.getGroup()
			if playergroup == "admin" or playergroup == "superadmin" then
				if storagewarstimerstartactivated == false then
					TriggerClientEvent("rtx_storagewars:Notify", playersource, LanguageFile("manualstart", Config.StorageWarsStartTime*60))
					StorageWarsTimerStart()
				end
			end
		end
	end)
end

if Config.Framework == "qbcore" then
	RegisterCommand("startstoragewars", function(source, args, raw)
		local playersource = source
		if playersource == 0 then	
			if storagewarstimerstartactivated == false then
				print(LanguageFile("manualstart", Config.StorageWarsStartTime*60))
				StorageWarsTimerStart()
			end
		else
			if QBCore.Functions.HasPermission(playersource, 'admin') or QBCore.Functions.HasPermission(playersource, 'god') then
				if storagewarstimerstartactivated == false then
					TriggerClientEvent("rtx_storagewars:Notify", playersource, LanguageFile("manualstart", Config.StorageWarsStartTime*60))
					StorageWarsTimerStart()
				end
			end
		end
	end)
end

if Config.Framework == "standalone" then
	RegisterCommand("startstoragewars", function(source, args, raw)
		local playersource = source
		if playersource == 0 then	
			if storagewarstimerstartactivated == false then
				print(LanguageFile("manualstart", Config.StorageWarsStartTime*60))
				StorageWarsTimerStart()
			end
		else
		end
	end)
end

function CheckPlayerAccess(playersource)
	if Config.StorageWarsRegistrationOnlyForPeopleWithPermission == false then
		return true
	else
		if IsPlayerAceAllowed(playersource, "storagewars.register") then 
			return true
		else
			return false
		end
	end
end