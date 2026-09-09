SH = {}

local shTable = {}
local shCache = {
	Draw = {},
	Peds = {},
	Keys = {}
}

function SH.RegisterBTN(key, onPress)
	local upperKey = string.upper(key)
	if not shCache.Keys[upperKey] then
		local cmd = "test"..upperKey
		shCache.Keys[upperKey] = {}
		table.insert(shCache.Keys[upperKey], onPress)

		CreateThread(function()
			RegisterCommand(cmd, function()
				for k, v in pairs(shCache.Keys[upperKey]) do
					v()
				end
			end, false)
			RegisterKeyMapping(cmd, "op-garages", "KEYBOARD", key)
            Wait(1000)
            TriggerEvent('chat:removeSuggestion', '/+'..cmd)
        end)
	else
		table.insert(shCache.Keys[upperKey], onPress)
	end
end

function SH.MarkNewCoords(coords, marker, floatingText, ped, exitEvent, pressEvent, additionalData, enterEvent)
	if coords.w then
		coords = vec3(coords.x, coords.y, coords.z)
	end
	local toSpawn = {}
	if type(ped) == "table" then
		toSpawn.gender = ped.gender
		toSpawn.model = ped.model
		toSpawn.weapon = ped.weapon
		toSpawn.animation = ped.animation
		toSpawn.heading = ped.heading
	else 
		toSpawn = false
	end
	local toDraw = {}
	if type(marker) == "boolean" and marker then
		toDraw.type = 6
		toDraw.size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize)
		toDraw.color = Config.Misc.zoneColor
	elseif type(marker) == "table" then
		toDraw.type = marker.type or 6
		toDraw.size = marker.size or vec3(1.2, 1.2, 1.2)
		toDraw.color = marker.color or Config.Misc.zoneColor
	end
	local data = {
		coords = coords,
		toSpawn = toSpawn,
		toDraw = toDraw,
		floatingText = floatingText,
		exitEvent = exitEvent,
		pressEvent = pressEvent,
		enterEvent = enterEvent or function() end,
		isDelated = false
	}

	if Config.Misc.Target ~= "none" then
		if toSpawn then
			coords = vector3(coords.x, coords.y, coords.z + 1.0)
		else 
			coords = vector3(coords.x, coords.y, coords.z)
		end
	
		local size = vec3(3.0, 3.0, 3.0)

		if additionalData.maxDistance then
			size = vec3(60.0, 60.0, 60.0)
		end

		local index = addTargetTyped(additionalData.name, coords, size, additionalData.icon, additionalData.label, function()
			pressEvent()
		end)
 
		shTable[index] = data
		return index
	else
		shTable[#shTable + 1] = data
		return #shTable + 1
	end
end

function SH.RemoveMarkedCoords(index)
	if Config.Misc.Target == "none" then
		index = index - 1
	end
	if shTable[index] then
		shTable[index].isDelated = true
	end

	if shCache.Draw[index] then
		shCache.Draw[index] = nil
	end

	if shCache.Peds[index] then
		if shCache.Peds[index].spawned then
			SH.deletePed(index)
		end
		shCache.Peds[index] = nil
	end

	if Config.Misc.Target ~= "none" then
		removeTarget(index)
	end
end


Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		for i, data in pairs(shTable) do
			if shTable[i] and not shTable[i].isDelated then
				local dist = #(shTable[i].coords - playerCoords)
				if dist < 35.0 then
					if Config.Misc.Target == "none" then
						if not shCache.Draw[i] then
							shCache.Draw[i] = {}
							shCache.Draw[i].draw = true
						else 
							shCache.Draw[i].draw = true
						end
					end
					if shTable[i].toSpawn then
						if not shCache.Peds[i] then
							shCache.Peds[i] = {}
						end

						if not shCache.Peds[i].spawned then
							SH.spawnPed(i) 	
							shCache.Peds[i].spawned = true
						end
					end
				else 
					if Config.Misc.Target == "none" then
						if shCache.Draw[i] then
							shCache.Draw[i].draw = false
						end
					end
					if shCache.Peds[i] then
						if shCache.Peds[i].spawned then
							SH.deletePed(i)
							shCache.Peds[i].spawned = false
						end
					end
				end
			end
		end
		Wait(1500)
	end
end)

function SH.GetForwardVector(index)
	if Config.Misc.Target == "none" then
		index = index - 1
	end

	if shCache.Peds[index] then
		local coords = shTable[index].coords
		return vec3(coords.x + (shCache.Peds[index].pedForward.x * 1.2), coords.y + (shCache.Peds[index].pedForward.y * 1.2), coords.z)
	end
end

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local sleep = 500
		for k, v in pairs(shCache.Draw) do
			if v.draw and not shTable[k].isDelated then
				if Config.Misc.Target == "none" then
					sleep = 0
					local coords = shTable[k].coords
					if shCache.Peds[k] then
						if shCache.Peds[k].spawned then
							coords = vec3(coords.x + (shCache.Peds[k].pedForward.x * 1.2), coords.y + (shCache.Peds[k].pedForward.y * 1.2), coords.z)
						end
					end
					local dist = #(coords - playerCoords)
					if dist < 30.0 and dist > shTable[k].toDraw.size.x then
						if shCache.Draw[k].joined then
							shTable[k].exitEvent()
							shCache.CurrentMarker = nil
							shCache.Draw[k].joined = false
						end
						if shTable[k].toDraw.type == 6 then
							--DrawMarker(6,coords,0.0,0.0,0.0,-90,0,-90,shTable[k].toDraw.size.x,shTable[k].toDraw.size.x,shTable[k].toDraw.size.x,shTable[k].toDraw.color.r,shTable[k].toDraw.color.g,shTable[k].toDraw.color.b,50,false,false,2,false,false,false,false)
						else 
							--DrawMarker(shTable[k].toDraw.type,coords,0.0,0.0,0.0,0,0,0,shTable[k].toDraw.size.x,shTable[k].toDraw.size.x,shTable[k].toDraw.size.x,shTable[k].toDraw.color.r,shTable[k].toDraw.color.g,shTable[k].toDraw.color.b,50,false,false,2,false,false,false,false)
						end
						if dist < 8.0 then
							if shTable[k].floatingText then
								--ESX.ShowFloatingHelpNotification(shTable[k].floatingText.outside, vector3(shTable[k].coords.x, shTable[k].coords.y, shTable[k].coords.z + 2.0))
							end
						end
					end

					if dist < shTable[k].toDraw.size.x then 
						if IsControlJustReleased(0, 38) then 
							shTable[k].pressEvent()
						end
						if shCache.Draw[k] and not shCache.Draw[k].joined then
							shCache.CurrentMarker = k
							shCache.Draw[k].joined = true
							shTable[k].enterEvent()
							--PlaySoundFrontend(-1, "Boss_Blipped", "GTAO_Magnate_Hunt_Boss_SoundSet", 1)
						end
						if shTable[k].floatingText then
							--ESX.ShowFloatingHelpNotification(shTable[k].floatingText.inside, vector3(shTable[k].coords.x, shTable[k].coords.y, shTable[k].coords.z + 2.0))
						end
						if shTable[k].toDraw.type == 6 then
							--DrawMarker(6,coords,0.0,0.0,0.0,-90,0,-90,shTable[k].toDraw.size.x,shTable[k].toDraw.size.x,shTable[k].toDraw.size.x,shTable[k].toDraw.color.r,shTable[k].toDraw.color.g,shTable[k].toDraw.color.b,80,false,false,2,false,false,false,false)
						else 
							--DrawMarker(shTable[k].toDraw.type,coords,0.0,0.0,0.0,0,0,0,shTable[k].toDraw.size.x,shTable[k].toDraw.size.x,shTable[k].toDraw.size.x,shTable[k].toDraw.color.r,shTable[k].toDraw.color.g,shTable[k].toDraw.color.b,80,false,false,2,false,false,false,false)
						end
					end
				end
			else
				shCache.Draw[k] = nil
			end
		end
		Wait(sleep)
	end
end)

function SH.spawnPed(index) 
	if shCache.Peds[i] then if shCache.Peds[i].spawned then return end end
    local genderNum = 0
	local Gender = shTable[index].toSpawn.gender 
	local Model = shTable[index].toSpawn.model
	local Coords = shTable[index].coords
	local Heading = shTable[index].toSpawn.heading
	local Weapon = shTable[index].toSpawn.weapon
	local Animation = shTable[index].toSpawn.animation

    RequestModel(GetHashKey(Model))
    while not HasModelLoaded(GetHashKey(Model)) do
        Citizen.Wait(1)
    end

    if Gender == 'male' then
		genderNum = 4
	elseif Gender == 'female' then 
		genderNum = 5
	else
		print("Error > Brak płci peda.")
	end	

    local CreatedPedd = CreatePed(genderNum, GetHashKey(Model), Coords, Heading, false, true)

	if not shCache.Peds[index] then shCache.Peds[index] = {} end
    shCache.Peds[index].ped = CreatedPedd
	shCache.Peds[index].pedForward = GetEntityForwardVector(CreatedPedd)
	shCache.Peds[index].spawned = true
	shCache.Peds[index].prop = nil

    FreezeEntityPosition(CreatedPedd, true)
    SetEntityInvincible(CreatedPedd, true) 
    SetBlockingOfNonTemporaryEvents(CreatedPedd, true)

    if Weapon then
        local hash = Weapon
        GiveWeaponToPed(CreatedPedd, hash, 1, false, true)
        SetCurrentPedWeapon(CreatedPedd, hash, true)
    end

    if Animation then
        SH.playAnim(Animation.Dict, Animation.Lib, index, Animation.Prop, 1)
    end
    
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    SH.deletePed("all")
end)

function SH.deletePed(index)
	if index == "all" then
		for k, v in pairs(shCache.Peds) do
			DeletePed(v.ped)
			DeleteObject(v.prop)
			shCache.Peds[k].prop = nil
			shCache.Peds[k].spawned = false
		end
	else 
		if shCache.Peds[index].spawned then
			DeletePed(shCache.Peds[index].ped)
			DeleteObject(shCache.Peds[index].prop)
			shCache.Peds[index].prop = nil
			shCache.Peds[index].spawned = false
		end
	end
end

function SH.playAnim(dict, lib, index, prop, movement)
    local playerped = nil 

    if index == "player" then
        playerped = PlayerPedId()
    else 
        playerped = shCache.Peds[index].ped
    end

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end

    TaskPlayAnim(playerped, dict, lib, 1.0, 1.0, -1, movement, 1.0, false,false,false)
    RemoveAnimDict(dict)

    if prop then
        local PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(prop.PropPlacement)
        local GenProp = CreateObject(GetHashKey(prop.Prop), 0, 0, 0, true, true, true)
        AttachEntityToEntity(GenProp, playerped, GetPedBoneIndex(playerped, prop.PropBone), PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6, true, true,
        false, true, 1, true)
        SetModelAsNoLongerNeeded(GenProp)
        if pedName ~= "player" then
            shCache.Peds[index].prop = GenProp
        end
    end
end

function SH.CheckPermission(permissionName)
	local playerJobs = GlobalState.playersJobs
    local serverOrgs = GlobalState.organisations
	local playerData = Fr.GetPlayerData()
	local identifier = trim(playerData.identifier or playerData.citizenid)

    local playerObject = playerJobs[identifier]

    if playerOrganisationData.isInOrg and playerObject then
        if serverOrgs[tostring(playerOrganisationData.jobId)] then
            local playerOrg = serverOrgs[tostring(playerOrganisationData.jobId)]
            local foundRank = false

            for k, v in pairs(playerOrg.ranks) do 
                if v.label == playerObject.rank then
                    foundRank = v
                end
            end

            if foundRank then
                for k, v in pairs(foundRank.permissionsList) do
                    if v.name == permissionName then
                        return true
                    end
                end

                return false
            else
                return false
            end
        else
            return false
        end
    else 
        return false
    end
end

function SH.fadeOutEntity(entity, half)
    if DoesEntityExist(entity) then
        if not half then
            for i = 0, 85 do
                local alpha = 255 - (i * 3)
                SetEntityAlpha(entity, alpha, false)
                Citizen.Wait(1)
            end
        else
            for i = 0, 180 do
                local alpha = 255 - i
                SetEntityAlpha(entity, alpha, false)
                Citizen.Wait(1)
            end
        end
    end
end

function SH.fadeInEntity(entity, half)
    if DoesEntityExist(entity) then
		for i = 0, 85 do
			local alpha = math.min(i * 3, 255)
			SetEntityAlpha(entity, alpha, false)
			Citizen.Wait(1)
		end
		SetEntityAlpha(entity, 255, false)
		ResetEntityAlpha(entity)
    end
end

function SH.addBlip(coords, blipId, blipColor, blipLabel)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, blipId)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, blipColor)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(blipLabel)
    EndTextCommandSetBlipName(blip)

    return blip
end

function SH.EnumerateVehicles() 
	return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        if not vehicle or vehicle == 0 then
            EndFindVehicle(handle)
            return
        end

        local success
        repeat
            coroutine.yield(vehicle)
            success, vehicle = FindNextVehicle(handle)
        until not success

        EndFindVehicle(handle)
    end)
end