local registered = {}
local prompts = {}
local inRange = 0
local loopRunning = false
local menuBusy = false

local function targetResource()
	if Config.TargetSystem == nil then
		Config.TargetSystem = exports["av_laptop"]:getTarget() or false
	end
	local system = Config.TargetSystem
	if system == "ox_target" and GetResourceState("ox_target") == "started" then
		return "ox_target"
	end
	if system == "qb-target" and GetResourceState("qb-target") == "started" then
		return "qb-target"
	end
	if system and system ~= false then
		warn(
			("Config.TargetSystem is set to '%s' but that resource is not started, falling back to TextUI"):format(
				tostring(system)
			)
		)
	end
	return nil
end

local function nearbyInteractions()
	local coords = GetEntityCoords(cache.ped)
	local now = GetGameTimer()
	local list = {}
	for _, entry in ipairs(prompts) do
		if #(coords - entry.coords) <= entry.distance then
			if not entry.checkedAt or (now - entry.checkedAt) > 3000 then
				entry.checkedAt = now
				entry.allowed = not entry.job or HasJob(entry.job) == true
			end
			if entry.allowed then
				list[#list + 1] = entry
			end
		end
	end
	return list
end

local function openInteractions(list)
	if menuBusy then
		return
	end
	if #list == 1 then
		list[1].onSelect()
		return
	end
	menuBusy = true
	local options = {}
	for _, entry in ipairs(list) do
		options[#options + 1] = {
			title = entry.label,
			icon = entry.icon,
			event = "av_dealership:interactionPick",
			args = { key = entry.key },
		}
	end
	exports["av_laptop"]:registerContext({
		id = "dealership_interaction",
		title = Lang["interact"] or "Interact",
		options = options,
	})
	exports["av_laptop"]:showContext("dealership_interaction")
	SetTimeout(500, function()
		menuBusy = false
	end)
end

RegisterNetEvent("av_dealership:interactionPick", function(args)
	local key = args and args.key
	if not key then
		return
	end
	for _, entry in ipairs(prompts) do
		if entry.key == key then
			entry.onSelect()
			return
		end
	end
end)

local function promptLoop()
	if loopRunning then
		return
	end
	loopRunning = true
	CreateThread(function()
		local currentLabel = nil
		local list = {}
		local scannedAt = 0
		while inRange > 0 do
			if (IsCatalogueOpen and IsCatalogueOpen()) or PlacementActive then
				HideTextUI("interactions")
				currentLabel = nil
				Wait(300)
			else
				local now = GetGameTimer()
				if (now - scannedAt) > 150 then
					scannedAt = now
					list = nearbyInteractions()
				end
				if #list == 0 then
					HideTextUI("interactions")
					currentLabel = nil
					Wait(250)
				else
					local label = #list == 1 and list[1].label or (Lang["interact"] or "Interact")
					if label ~= currentLabel or not TextUIActive() then
						HideTextUI("interactions")
						ShowTextUI("interactions", label)
						currentLabel = label
					end
					if TextUIActive("interactions") and IsControlJustPressed(0, 38) then
						HideTextUI("interactions")
						currentLabel = nil
						openInteractions(list)
					end
					Wait(0)
				end
			end
		end
		HideTextUI("interactions")
		loopRunning = false
	end)
end

function RegisterInteraction(data)
	local system = targetResource()
	if not system then
		local entry = {
			key = data.id or ("point:" .. tostring(data.label)),
			coords = vector3(data.coords.x, data.coords.y, data.coords.z),
			distance = data.distance or 3.0,
			label = data.label,
			icon = data.icon or "fa-solid fa-desktop",
			job = data.job,
			onSelect = data.onSelect,
		}
		prompts[#prompts + 1] = entry
		local point = lib.points.new({
			coords = entry.coords,
			distance = entry.distance,
		})
		function point:onEnter()
			inRange = inRange + 1
			promptLoop()
		end
		function point:onExit()
			inRange = inRange - 1
			if inRange < 0 then
				inRange = 0
			end
		end
		registered[#registered + 1] = { kind = "point", point = point }
		return
	end

	local size = data.size or vec3(1.5, 1.5, 2.0)
	if system == "ox_target" then
		local zoneId = exports.ox_target:addBoxZone({
			coords = vec3(data.coords.x, data.coords.y, data.coords.z),
			size = size,
			rotation = data.heading or 0.0,
			options = {
				{
					name = data.id,
					label = data.label,
					icon = data.icon or "fa-solid fa-desktop",
					groups = data.job and { [data.job] = 0 } or nil,
					onSelect = data.onSelect,
				},
			},
		})
		registered[#registered + 1] = { kind = "ox_target", id = zoneId }
		return
	end

	exports["qb-target"]:AddBoxZone(data.id, vector3(data.coords.x, data.coords.y, data.coords.z), size.x, size.y, {
		name = data.id,
		heading = data.heading or 0.0,
		minZ = data.coords.z - 1.5,
		maxZ = data.coords.z + 1.5,
	}, {
		options = {
			{
				label = data.label,
				icon = data.icon or "fas fa-desktop",
				job = data.job,
				action = data.onSelect,
			},
		},
		distance = data.distance or 2.5,
	})
	registered[#registered + 1] = { kind = "qb-target", id = data.id }
end

function RegisterEntityInteraction(entity, data)
	local system = targetResource()
	if not system or not entity or not DoesEntityExist(entity) then
		return false
	end
	if system == "ox_target" then
		exports.ox_target:addLocalEntity(entity, {
			{
				name = data.id,
				label = data.label,
				icon = data.icon or "fa-solid fa-car-side",
				distance = data.distance or 3.0,
				onSelect = data.onSelect,
			},
		})
		return true
	end
	exports["qb-target"]:AddTargetEntity(entity, {
		options = {
			{
				label = data.label,
				icon = data.icon or "fas fa-car-side",
				action = data.onSelect,
			},
		},
		distance = data.distance or 3.0,
	})
	return true
end

function RemoveEntityInteraction(entity)
	local system = targetResource()
	if not system or not entity then
		return
	end
	if system == "ox_target" then
		exports.ox_target:removeLocalEntity(entity)
		return
	end
	exports["qb-target"]:RemoveTargetEntity(entity)
end

function ClearInteractions()
	for _, entry in ipairs(registered) do
		if entry.kind == "point" then
			entry.point:remove()
		elseif entry.kind == "ox_target" then
			exports.ox_target:removeZone(entry.id)
		elseif entry.kind == "qb-target" then
			exports["qb-target"]:RemoveZone(entry.id)
		end
	end
	registered = {}
	prompts = {}
	inRange = 0
	HideTextUI()
end
