local __turn_config = nil
local MusicInstances = {}
local LocalMusicInstances = {}
local CurrentControlInstanceId = nil
local CurrentListeningInstanceId = nil

CreateThread(function()
	Wait(1000)
	TriggerServerEvent('music:rtc:requestTurnConfig')
	TriggerServerEvent('music:requestSync')
end)

function UnregisterMusicInstance(id)
	-- No need
	if not LocalMusicInstances[id] then return end
	LocalMusicInstances[id] = nil
end

function RegisterMusicInstance(id)
	UnregisterMusicInstance(id)
	local musicInstance = MusicInstances[id]
	if not musicInstance then return end
	LocalMusicInstances[id] = {interior = 0}
	local tennis = CreateTennisBall(musicInstance.coords)
	LocalMusicInstances[id].interior = GetInteriorFromEntity(tennis)
	DeleteScriptObject(tennis)
	-- No need
end

function SetMusicController(id)
	CurrentControlInstanceId = id
end

-- Export function for other resources
exports('SetMusicController', SetMusicController)

RegisterNetEvent("music:syncMusicInstances", function(data)
	for k,v in pairs(data) do
		MusicInstances[k] = v
		RegisterMusicInstance(k)
	end
end)

RegisterNetEvent("music:musicInstanceUpdated", function(id, instance)
	MusicInstances[id] = instance
	RegisterMusicInstance(id)
end)

RegisterNetEvent('music:rtc:turnConfig', function(data)
	local payload = {}
	local ok, parsed = pcall(function() return json.decode(data or "{}") end)
	if ok and type(parsed) == "table" then payload = parsed end
	__turn_config = payload
	debugPrint("turn config", json.encode(__turn_config))
end)

RegisterNUICallback('music_rtc_get_turn_config', function(data, cb)
	cb({ ok = true, config = __turn_config })
end)

RegisterNUICallback('music_rtc_request_turn_config', function(data, cb)
	TriggerServerEvent('music:rtc:requestTurnConfig')
	if cb then cb({ ok = true }) end
end)

RegisterNUICallback('music_rtc_announce_broadcast', function(data, cb)
	-- Ensure instanceId is set (use the controller the player opened)
	local payload = data or {}
	debugPrint("[music] NUI announceBroadcast callback received", json.encode(payload), "CurrentControlInstanceId:", CurrentControlInstanceId)
	
	-- Convert instanceId to number if it's a string
	if payload.instanceId ~= nil then
		payload.instanceId = tonumber(payload.instanceId) or payload.instanceId
	end
	-- Fallback to CurrentControlInstanceId if instanceId is still nil
	if payload.instanceId == nil then 
		payload.instanceId = CurrentControlInstanceId 
		debugPrint("[music] Using CurrentControlInstanceId fallback:", payload.instanceId)
	end
	-- Ensure instanceId is a number
	if payload.instanceId ~= nil then
		payload.instanceId = tonumber(payload.instanceId)
	end
	
	-- Validate that we have a valid instanceId before proceeding
	-- This should only be called when a player opens the DJ controller
	if payload.instanceId == nil or payload.instanceId == 0 then
		debugPrint("[music] ERROR: Cannot announce broadcast - instanceId is nil or invalid. This should only happen when a player opens the DJ controller.")
		debugPrint("[music] This may indicate a stale broadcast attempt or the controller was opened before the music instance was ready.")
		if cb then cb({ ok = false, error = "instanceId is nil or invalid" }) end
		return
	end
	
	debugPrint("[music] NUI announceBroadcast sending to server", json.encode(payload))
	-- If streamId is provided, use it; otherwise let server generate one
	-- Note: Server will validate and may override streamId if needed
	local enc = json.encode(payload)
	TriggerServerEvent('music:rtc:announceBroadcast', enc, #enc)
	if cb then cb({ ok = true }) end
end)

-- Handle automatic broadcast start from server
RegisterNetEvent('pickle_dj:startBroadcasting', function(musicInstanceId, streamId)
	debugPrint("[music] Received pickle_dj:startBroadcasting", musicInstanceId, streamId, type(musicInstanceId))
	-- Set the current control instance (this is critical for the NUI callback to know which instance)
	CurrentControlInstanceId = tonumber(musicInstanceId) or musicInstanceId
	debugPrint("[music] Set CurrentControlInstanceId to", CurrentControlInstanceId)
	-- Note: The dj/client.lua also handles this event to send to NUI
	-- We just set CurrentControlInstanceId here
end)

-- Handle automatic broadcast stop from server
RegisterNetEvent('pickle_dj:stopBroadcasting', function()
	-- Send to NUI to stop broadcasting
	SendNUIMessage({
		type = 'music:stopAutoBroadcast',
		data = {}
	})
end)

RegisterNUICallback('music_rtc_stop_broadcast', function(data, cb)
	TriggerServerEvent('music:rtc:stopBroadcast')
	if cb then cb({ ok = true }) end
end)

RegisterNUICallback('music_rtc_offer', function(data, cb)
	debugPrint("[music] NUI music_rtc_offer")
	-- data: { sdp: string }
	local sdp = (data and data.sdp) or ""
	-- Include the instance the listener is attempting to join
	local payload = {
		instanceId = CurrentListeningInstanceId,
		sdp = sdp
	}
	local enc = json.encode(payload)
	TriggerServerEvent('music:rtc:offer', enc, #enc)
	if cb then cb({ ok = true }) end
end)

RegisterNUICallback('music_rtc_answer', function(data, cb)
	debugPrint("[music] NUI music_rtc_answer -> to", (data and data.to) or -1)
	-- data: { to: number, sdp: string }
	local to = (data and data.to) or -1
	local sdp = (data and data.sdp) or ""
	TriggerServerEvent('music:rtc:answer', to, sdp)
	if cb then cb({ ok = true }) end
end)

RegisterNUICallback('music_rtc_ice_to_broadcaster', function(data, cb)
	debugPrint("[music] NUI music_rtc_ice_to_broadcaster")
	-- data: { candidate: any-json }
	local cand = (data and data.candidate) or nil
	if cand ~= nil then
		local enc = json.encode({ instanceId = CurrentListeningInstanceId, candidate = cand })
		TriggerServerEvent('music:rtc:iceToBroadcaster', enc)
	end
	if cb then cb({ ok = true }) end
end)

RegisterNUICallback('music_rtc_ice_to_listener', function(data, cb)
	debugPrint("[music] NUI music_rtc_ice_to_listener -> to", (data and data.to) or -1)
	-- data: { to: number, candidate: any-json }
	local to = (data and data.to) or -1
	local cand = (data and data.candidate) or nil
	if to ~= -1 and cand ~= nil then
		TriggerServerEvent('music:rtc:iceToListener', to, json.encode(cand))
	end
	if cb then cb({ ok = true }) end
end)

-- OLD, NO LONGER USED

-- RegisterNetEvent('music:rtc:broadcastStarted', function(data)
-- 	local payload = {}
-- 	local ok, parsed = pcall(function() return json.decode(data or "{}") end)
-- 	if ok and type(parsed) == "table" then payload = parsed end
-- 	-- Prevent broadcaster from listening to their own stream unless DebugListen is true
-- 	local myId = GetPlayerServerId(PlayerId())
-- 	-- if not (Config and Config.DebugListen) and payload.broadcaster == myId then
-- 	-- 	return
-- 	-- end
-- 	SendNUIMessage({
-- 		type = 'music:rtc:broadcastStarted',
-- 		payload = {
-- 			streamId = payload.streamId,
-- 			broadcaster = payload.broadcaster
-- 		}
-- 	})
-- end)

RegisterNetEvent('music:rtc:broadcastStopped', function(data)
	SendNUIMessage({
		type = 'music:rtc:broadcastStopped',
		payload = {}
	})
end)

RegisterNetEvent('music:rtc:offer', function(data)
	local payload = {}
	local ok, parsed = pcall(function() return json.decode(data or "{}") end)
	if ok and type(parsed) == "table" then payload = parsed end
	SendNUIMessage({
		type = 'music:rtc:offer',
		payload = payload
	})
end)

RegisterNetEvent('music:rtc:answer', function(data)
	local payload = {}
	local ok, parsed = pcall(function() return json.decode(data or "{}") end)
	if ok and type(parsed) == "table" then payload = parsed end
	SendNUIMessage({
		type = 'music:rtc:answer',
		payload = payload
	})
end)

RegisterNetEvent('music:rtc:iceFromListener', function(data)
	local payload = {}
	local ok, parsed = pcall(function() return json.decode(data or "{}") end)
	if ok and type(parsed) == "table" then payload = parsed end
	SendNUIMessage({
		type = 'music:rtc:iceFromListener',
		payload = payload
	})
end)

RegisterNetEvent('music:rtc:iceFromBroadcaster', function(data)
	local payload = {}
	local ok, parsed = pcall(function() return json.decode(data or "{}") end)
	if ok and type(parsed) == "table" then payload = parsed end
	SendNUIMessage({
		type = 'music:rtc:iceFromBroadcaster',
		payload = payload
	})
end)

-- Proximity-based listening to nearest active instance
CreateThread(function()
	while true do
		local wait = 1500
		local ped = PlayerPedId()
		local pcoords = GetEntityCoords(ped)
		local nearestId = nil
		local nearestDist = 999999.0
		local currentInterior = GetInteriorFromEntity(PlayerPedId())
		for id, inst in pairs(MusicInstances) do
			if inst and inst.streamId ~= nil and inst.broadcaster ~= nil then
				-- choose the minimum distance to any speaker if present, else to booth coords
				local minInstDist = 999999.0
				if inst.speakers and type(inst.speakers) == "table" and #inst.speakers > 0 then
					for _, sp in ipairs(inst.speakers) do
						if sp.coords then
							local d = #(pcoords - sp.coords)
							if d < minInstDist then minInstDist = d end
						end
					end
				elseif inst.coords ~= nil then
					minInstDist = #(pcoords - inst.coords)
				end
				if minInstDist < nearestDist then
					nearestDist = minInstDist
					nearestId = id
				end
			end
		end
		local controllerRadius = (Config and Config.MusicRadius) or 50.0
		if nearestId ~= nil then
			-- Determine if listener is within range of the nearest instance using per-speaker radii
			local __inRange = false
			do
				local inst = MusicInstances[nearestId]
				if inst then
					if inst.speakers and type(inst.speakers) == "table" and #inst.speakers > 0 then
						for _, sp in ipairs(inst.speakers) do
							if sp.coords then
								local spec = (Config and Config.SpeakerProps and sp.speakerType and Config.SpeakerProps[sp.speakerType]) or nil
								local r = (spec and spec.soundRadius) or 0.0
								if r > 0.0 then
									local d = #(pcoords - sp.coords)
									if d <= r then
										__inRange = true
										break
									end
								end
							end
						end
					elseif inst.coords ~= nil then
						local d = #(pcoords - inst.coords)
						if d <= controllerRadius then
							__inRange = true
						end
					end
				end
			end
			if __inRange then
			wait = 0
			local inst = MusicInstances[nearestId]
			-- Check if we need to start/restart listening to this instance
			local shouldStartListening = false
			if CurrentListeningInstanceId ~= nearestId then
				-- Switching to a different instance
				shouldStartListening = true
				if CurrentListeningInstanceId ~= nil then
					debugPrint("[MSC] STOP BROADCAST", CurrentListeningInstanceId)
					SendNUIMessage({
						type = 'music:rtc:broadcastStopped',
						payload = {}
					})
				end
			elseif CurrentListeningInstanceId == nearestId then
				-- Same instance, but check if broadcaster exists or changed
				if inst.broadcaster == nil then
					-- Broadcast stopped, clear and wait for restart
					CurrentListeningInstanceId = nil
					debugPrint("[MSC] STOP BROADCAST (no broadcaster)", nearestId)
					SendNUIMessage({
						type = 'music:rtc:broadcastStopped',
						payload = {}
					})
					shouldStartListening = false
				else
					-- Check if streamId changed (new broadcast started)
					local lastStreamId = (inst._lastStreamId or nil)
					if lastStreamId ~= inst.streamId then
						-- Stream ID changed, restart listening
						shouldStartListening = true
						inst._lastStreamId = inst.streamId
					end
				end
			end
			
			if shouldStartListening and inst.broadcaster ~= nil then
				-- If I'm the broadcaster and DebugListen is false, do not start listening
				-- local myId = GetPlayerServerId(PlayerId())
				-- if inst.broadcaster == myId then
				-- 	CurrentListeningInstanceId = nil
				-- 	-- ensure UI is stopped and volume/pan reset
				-- 	SendNUIMessage({ type = 'music:rtc:broadcastStopped', payload = {} })
				-- 	goto __after_listen_tick
				-- end
				CurrentListeningInstanceId = nearestId
				inst._lastStreamId = inst.streamId
				debugPrint("[MSC] START BROADCAST", nearestId)
				SendNUIMessage({
					type = 'music:rtc:broadcastStarted',
					payload = {
						instanceId = nearestId,
						streamId = inst.streamId,
						broadcaster = inst.broadcaster
					}
				})
			end
			-- Multi-speaker attenuation and panning
			local inst2 = MusicInstances[nearestId]
			local speakers = nil
			if inst2.speakers and type(inst2.speakers) == "table" and #inst2.speakers > 0 then
				speakers = inst2.speakers
			elseif inst2.coords then
				-- Fallback "controller" speaker uses Config.MusicRadius
				speakers = { { coords = inst2.coords, __controller = true } }
			else
				speakers = {}
			end
			-- accumulate contributions from all in-range speakers
			local totalWeight = 0.0
			local sumPan = 0.0
			local maxVol = 0.0
			for _, sp in ipairs(speakers) do
				if sp.coords then
					local d = #(pcoords - sp.coords)
					local r = 0.0
					if sp.__controller then
						r = controllerRadius
					else
						local spec = (Config and Config.SpeakerProps and sp.speakerType and Config.SpeakerProps[sp.speakerType]) or nil
						r = (spec and spec.soundRadius) or 0.0
					end
					local w = 0.0
					if r > 0.0 then
						w = 1.0 - (d / r)
					end
					if w < 0.0 then w = 0.0 end
					if w > 1.0 then w = 1.0 end
					if w > 0.0 then
						-- panning for this speaker
						local toX = (sp.coords.x - pcoords.x)
						local toY = (sp.coords.y - pcoords.y)
						local len = math.sqrt(toX * toX + toY * toY)
						local pan_i = 0.0
						if len > 0.0001 then
							toX = toX / len
							toY = toY / len
							local camRot = GetGameplayCamRot(0) or vector3(0.0, 0.0, 0.0)
							local heading = camRot.z or 0.0
							local rad = math.rad(heading)
							local fx = -math.sin(rad)
							local fy = math.cos(rad)
							local rx = fy
							local ry = -fx
							pan_i = (toX * rx) + (toY * ry)
							if pan_i < -1.0 then pan_i = -1.0 end
							if pan_i > 1.0 then pan_i = 1.0 end
						end
						totalWeight = totalWeight + w
						sumPan = sumPan + (w * pan_i)
						-- For volume, sum contributions but clamp at 1.0
						maxVol = maxVol + w
					end
				end
			end
			if maxVol > 1.0 then maxVol = 1.0 end
			local pan = 0.0
			if totalWeight > 0.0001 then
				pan = sumPan / totalWeight
				if pan < -0.9 then pan = -0.9 end
				if pan > 0.9 then pan = 0.9 end
			end
			local muffled = (LocalMusicInstances[nearestId]?.interior or 0) ~= currentInterior
			SendNUIMessage({
				type = 'music:setAudioValues',
				payload = { volume = maxVol * (muffled and 0.5 or 1.0), pan = pan, muffled = muffled }
			})
		else
			if CurrentListeningInstanceId ~= nil then
				-- Leave current instance
				CurrentListeningInstanceId = nil
				SendNUIMessage({
					type = 'music:rtc:broadcastStopped',
					payload = {}
				})
				SendNUIMessage({
					type = 'music:setAudioValues',
					payload = { volume = 0, pan = 0, muffled = false }
				})
			end
		end
		end
		::__after_listen_tick::
		Wait(wait)
	end
end)
