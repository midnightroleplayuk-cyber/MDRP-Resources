-- RTX HOUSING - https://rtx.tebex.io/package/7181359

if Config.HouseScript ~= "rtx_housing" then
    return
end

local function FormatPerms(houseid)
    local formattedperms = {}
	local houselocationhandler = exports["rtx_housing"]:GetPropertyData(houseid)
	for i, permissionhandler in pairs(houselocationhandler.permissions) do
		table.insert(formattedperms, {
			identifier = permissionhandler.identifierdata,
			name = permissionhandler.playername,
		})
	end

    return formattedperms
end

local function FormatOwnedHouses()
	local ownedhouses = exports["rtx_housing"]:GetPlayerOwnedProperties()
    local formatteddata = {}
	local ownedhouseindex = 0
    for i, houselocationhandler in pairs(ownedhouses) do
		local housecoords = houselocationhandler.enter.coords
		if houselocationhandler.partofcomplex.enabled == true then
			local apartmentcomplexhandler = exports["rtx_housing"]:GetPropertyData(houselocationhandler.partofcomplex.complexid)
			housecoords = apartmentcomplexhandler.enter.coords
		end
		local lockedstatus = false
		if GlobalState["rtxhousing-"..houselocationhandler.houseid.."-locked"] ~= nil then
			lockedstatus = GlobalState["rtxhousing-"..houselocationhandler.houseid.."-locked"]
		end
		ownedhouseindex = ownedhouseindex+1
        formatteddata[ownedhouseindex] = {
            label = houselocationhandler.propertyname,
            id = houselocationhandler.houseid,
            uniqueId = houselocationhandler.houseid,
            coords = {x = housecoords.x, y = housecoords.y},
            locked = lockedstatus,
            keyholders = FormatPerms(houselocationhandler.houseid)
        }
    end

    return formatteddata
end

RegisterNUICallback("Home", function(data, cb)
    local action, houseData = data.action, data.houseData

    if action == "getHomes" then
        cb(FormatOwnedHouses())

    elseif action == "removeKeyholder" then
		TriggerServerEvent("rtx_housing:Global:RemovePermission", houseData.uniqueId, data.identifier)

		Citizen.Wait(500)
		cb(FormatPerms(houseData.uniqueId))

    elseif action == "addKeyholder" then
        TriggerServerEvent("rtx_housing:Global:AddPermission", houseData.uniqueId, tonumber(data.source))
		Citizen.Wait(500)
        cb(FormatPerms(houseData.uniqueId))
    elseif action == "toggleLocked" then
        TriggerServerEvent("rtx_housing:Global:PropertyLockStatus", data.uniqueId)
		Citizen.Wait(1000)
        cb(GlobalState["rtxhousing-"..data.uniqueId.."-locked"])
    elseif action == "setWaypoint" then
        SetNewWaypoint(houseData.coords.x, houseData.coords.y)

        cb(true)
    end
end)
