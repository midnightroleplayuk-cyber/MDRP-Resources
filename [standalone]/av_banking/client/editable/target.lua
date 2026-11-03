local models = {}
local zones = {}
local modelHandles = {}
local zoneHandles = {}
local loopRunning = false
local busy = false

local function targetResource()
	if Config.TargetSystem == nil or Config.TargetSystem == false then
		local ok, detected = pcall(function()
			return exports["av_laptop"]:getTarget()
		end)
		Config.TargetSystem = (ok and detected) or "none"
	end

	local system = Config.TargetSystem
	if system == "ox_target" and GetResourceState("ox_target") == "started" then
		return "ox_target"
	end
	if system == "qb-target" and GetResourceState("qb-target") == "started" then
		return "qb-target"
	end
	if system and system ~= "none" and system ~= false then
		warn(
			("Config.TargetSystem is set to '%s' but that resource is not started, falling back to TextUI"):format(
				tostring(system)
			)
		)
		Config.TargetSystem = "none"
	end
	return nil
end

local function allowed(entry)
	if not entry.canInteract then
		return true
	end
	local ok, result = pcall(entry.canInteract)
	return ok and result ~= false
end

local function runProximityLoop()
	if loopRunning then
		return
	end
	loopRunning = true
	CreateThread(function()
		while true do
			local wait = 800
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local active = nil
			local activeEntity = nil
			for _, entry in ipairs(models) do
				if not active and allowed(entry) then
					for _, model in ipairs(entry.models) do
						local object = GetClosestObjectOfType(
							coords.x,
							coords.y,
							coords.z,
							entry.distance or Config.Interaction.distance,
							GetHashKey(model),
							false,
							false,
							false
						)
						if object and object ~= 0 then
							active = entry
							activeEntity = object
							break
						end
					end
				end
			end
			if not active then
				for _, entry in ipairs(zones) do
					if
						allowed(entry)
						and #(coords - entry.coords) <= (entry.distance or Config.Interaction.distance)
					then
						active = entry
						break
					end
				end
			end
			if active then
				wait = 0
				ShowTextUI(active.key, active.label)
				if IsControlJustReleased(0, Config.Interaction.key) and not busy then
					busy = true
					HideTextUI(active.key)
					active.onSelect(activeEntity)
					Wait(500)
					busy = false
				end
			else
				HideTextUI()
			end
			Wait(wait)
		end
	end)
end

function RegisterModelInteraction(entry)
	local system = targetResource()
	modelHandles[#modelHandles + 1] = entry
	if system == "ox_target" then
		exports.ox_target:addModel(entry.models, {
			{
				name = "av_banking_" .. entry.key,
				label = entry.label,
				icon = entry.icon or Config.Interaction.icon,
				distance = entry.distance or Config.Interaction.distance,
				canInteract = entry.canInteract,
				onSelect = function(data)
					entry.onSelect(data and data.entity)
				end,
			},
		})
		return
	end
	if system == "qb-target" then
		local hashes = {}
		for _, model in ipairs(entry.models) do
			hashes[#hashes + 1] = GetHashKey(model)
		end
		exports["qb-target"]:AddTargetModel(hashes, {
			options = {
				{
					label = entry.label,
					icon = entry.icon or Config.Interaction.icon,
					action = function(entity)
						entry.onSelect(entity)
					end,
					canInteract = entry.canInteract,
				},
			},
			distance = entry.distance or Config.Interaction.distance,
		})
		return
	end
	models[#models + 1] = entry
	runProximityLoop()
end

function RegisterZoneInteraction(entry)
	local system = targetResource()
	if system == "ox_target" then
		zoneHandles[#zoneHandles + 1] = exports.ox_target:addSphereZone({
			coords = entry.coords,
			radius = entry.distance or Config.Interaction.distance,
			options = {
				{
					name = "av_banking_" .. entry.key,
					label = entry.label,
					icon = entry.icon or Config.Interaction.icon,
					canInteract = entry.canInteract,
					onSelect = function()
						entry.onSelect()
					end,
				},
			},
		})
		return
	end
	if system == "qb-target" then
		zoneHandles[#zoneHandles + 1] = entry.key
		exports["qb-target"]:AddCircleZone(entry.key, entry.coords, entry.distance or Config.Interaction.distance, {
			name = entry.key,
			useZ = true,
		}, {
			options = {
				{
					label = entry.label,
					icon = entry.icon or Config.Interaction.icon,
					action = function()
						entry.onSelect()
					end,
					canInteract = entry.canInteract,
				},
			},
			distance = entry.distance or Config.Interaction.distance,
		})
		return
	end
	zones[#zones + 1] = entry
	runProximityLoop()
end

function ClearModelInteractions()
	local system = targetResource()
	for _, entry in ipairs(modelHandles) do
		if system == "ox_target" then
			pcall(function()
				exports.ox_target:removeModel(entry.models, "av_banking_" .. entry.key)
			end)
		elseif system == "qb-target" then
			local hashes = {}
			for _, model in ipairs(entry.models) do
				hashes[#hashes + 1] = GetHashKey(model)
			end
			pcall(function()
				exports["qb-target"]:RemoveTargetModel(hashes, entry.label)
			end)
		end
	end
	modelHandles = {}
	models = {}
end

function ClearZoneInteractions()
	local system = targetResource()
	for _, handle in ipairs(zoneHandles) do
		if system == "ox_target" then
			pcall(function()
				exports.ox_target:removeZone(handle)
			end)
		elseif system == "qb-target" then
			pcall(function()
				exports["qb-target"]:RemoveZone(handle)
			end)
		end
	end
	zoneHandles = {}
	zones = {}
end
