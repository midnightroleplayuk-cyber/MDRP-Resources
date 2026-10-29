local MusicInstances = {}

-- Export function to get music instances (for other resources)
exports('GetMusicInstances', function()
    return MusicInstances
end)

function CreateMusicInstance(name, coords, heading, speakers)
	local instance = {
		name = name,
		coords = coords,
		heading = heading,
		broadcaster = nil,
		streamId = nil,
		-- optional list of speaker definitions: { { speakerType=string, coords=vec3, heading=number }, ... }
		speakers = speakers or nil,
	}
	local id
	repeat 
		id = math.random(1, 999999)
	until not MusicInstances[id]
	MusicInstances[id] = instance
	-- broadcast creation to all clients
	TriggerClientEvent("music:musicInstanceUpdated", -1, id, instance)
	return id
end

-- TURN ICE config is fetched from Cloudflare's ephemeral credentials endpoint at runtime.

local function sendTurnConfigTo(targetSrc)
	-- Prefer Cloudflare token-based ephemeral credentials
	local apiToken = ConfigSV.StreamingServer.cloudflare.apiToken
	local turnTokenId = ConfigSV.StreamingServer.cloudflare.turnTokenId
    local ephemeralUrl = "https://rtc.live.cloudflare.com/v1/turn/keys/"..turnTokenId.."/credentials/generate-ice-servers"
	if turnTokenId ~= '' then
		local method = 'GET'
		local body = nil
		local headers = { ['Content-Type'] = 'application/json' }
		if apiToken ~= '' then
			headers['Authorization'] = 'Bearer ' .. apiToken
		end
		-- If a turnTokenId is provided, POST it in the body (common pattern)
		if turnTokenId ~= '' then
			method = 'POST'
			body = json.encode({ turnTokenId = turnTokenId })
		end
		PerformHttpRequest(ephemeralUrl, function(status, resp, respHeaders)
			local cfg = nil
			if status >= 200 and status < 300 then
				local ok, parsed = pcall(function() return json.decode(resp or '{}') end)
				if ok and type(parsed) == "table" then
					if parsed.iceServers ~= nil then
						cfg = { iceServers = parsed.iceServers }
					else
						-- Some providers return full RTCConfiguration directly
						cfg = parsed
					end
				end
            else
                debugPrint("Failed to get turn config", status, resp, respHeaders)
			end
			if cfg == nil then
				-- Fallback to Cloudflare STUN-only if token request fails
				cfg = {
					iceServers = {
						{ urls = { "stun:stun.cloudflare.com:3478", "stun:stun.cloudflare.com:53" } }
					}
				}
			end
            debugPrint("turn config", json.encode(cfg))
			TriggerClientEvent('music:rtc:turnConfig', targetSrc, json.encode(cfg))
		end, method, body, headers)
		return
	end

	-- STUN-only fallback when no token is configured
	local stunOnly = {
		iceServers = {
			{ urls = { "stun:stun.cloudflare.com:3478", "stun:stun.cloudflare.com:53" } }
		}
	}
	TriggerClientEvent('music:rtc:turnConfig', targetSrc, json.encode(stunOnly))
end

-- Allow clients to request a full sync of all music instances
RegisterNetEvent("music:requestSync", function()
	local src = tonumber(source)
	TriggerClientEvent("music:syncMusicInstances", src, MusicInstances)
end)

-- Update music instance speakers (called when speakers are added/removed)
RegisterNetEvent('pickle_dj:updateMusicInstanceSpeakers', function(musicInstanceId, speakers)
	if not musicInstanceId or not MusicInstances[musicInstanceId] then
		return
	end
	
	local instance = MusicInstances[musicInstanceId]
	instance.speakers = speakers
	
	-- Broadcast updated instance to all clients
	TriggerClientEvent("music:musicInstanceUpdated", -1, musicInstanceId, instance)
	debugPrint(("^2[music]^0 Updated speakers for instance %s"):format(musicInstanceId))
end)

AddEventHandler('playerDropped', function()
	local src = tonumber(source)
	-- If a player was a broadcaster for any instance, clear those instances
	for id, inst in pairs(MusicInstances) do
		if inst.broadcaster ~= nil and inst.broadcaster == src then
			inst.broadcaster = nil
			inst.streamId = nil
			TriggerClientEvent("music:musicInstanceUpdated", -1, id, inst)
			-- legacy broadcastStopped for compatibility
			TriggerClientEvent('music:rtc:broadcastStopped', -1, json.encode({}))
		end
	end
end)

RegisterNetEvent('music:rtc:requestTurnConfig', function()
	local src = tonumber(source)
	sendTurnConfigTo(src)
end)

RegisterNetEvent('music:rtc:announceBroadcast', function(data, datalen)
	debugPrint("announceBroadcast", data, datalen)
	local src = tonumber(source)
	local payload = {}
	do
		local ok, parsed = pcall(function() return json.decode(data or "{}") end)
		if ok and type(parsed) == "table" then payload = parsed end
	end
	debugPrint("[music] announceBroadcast payload:", json.encode(payload))
	local instanceId = tonumber(payload.instanceId or -1)
	if instanceId == nil or MusicInstances[instanceId] == nil then
		debugPrint("[music] announceBroadcast invalid instanceId", payload.instanceId, "type:", type(payload.instanceId))
		debugPrint("[music] Available instances:", json.encode(MusicInstances))
		return
	end
	local inst = MusicInstances[instanceId]
	-- Only allow one broadcaster per instance; replace if same src, ignore if different and already active
	if inst.broadcaster ~= nil and inst.broadcaster ~= src then
		debugPrint(("[music] instance %s already broadcasting by %s; reject %s"):format(instanceId, inst.broadcaster, src))
		return
	end
	-- Use provided streamId (from auto-broadcast) or use existing one, or generate one
	local streamId = payload.streamId or inst.streamId or tostring(src) .. "_" .. tostring(math.random(100000, 999999))
	inst.broadcaster = src
	inst.streamId = streamId
	debugPrint(("[music] instance %s broadcast announced by %s streamId=%s"):format(instanceId, src, streamId))
	-- Push updated instance to clients
	TriggerClientEvent("music:musicInstanceUpdated", -1, instanceId, inst)
	-- legacy: notify broadcast started (clients may use proximity and ignore)
	-- TriggerClientEvent('music:rtc:broadcastStarted', -1, json.encode({ streamId = streamId, broadcaster = src }))
end)

RegisterNetEvent('music:rtc:stopBroadcast', function()
	local src = tonumber(source)
	-- Stop any instance that this source is broadcasting
	for id, inst in pairs(MusicInstances) do
		if inst.broadcaster ~= nil and inst.broadcaster == src then
			inst.broadcaster = nil
			inst.streamId = nil
			debugPrint(("[music] instance %s broadcast stopped by %s"):format(id, src))
			TriggerClientEvent("music:musicInstanceUpdated", -1, id, inst)
			-- legacy
			TriggerClientEvent('music:rtc:broadcastStopped', -1, json.encode({}))
		end
	end
end)

RegisterNetEvent('music:rtc:offer', function(data, datalen)
	local src = tonumber(source)
	-- Expect data to be a JSON payload with instanceId and sdp
	local payload = {}
	do
		local ok, parsed = pcall(function() return json.decode(data or "{}") end)
		if ok and type(parsed) == "table" then payload = parsed end
	end
	local instanceId = tonumber(payload.instanceId or -1)
	if instanceId == nil or MusicInstances[instanceId] == nil then return end
	local inst = MusicInstances[instanceId]
	if inst.broadcaster == nil then return end
	-- Forward listener offer to the instance broadcaster
	debugPrint(("[music] offer (inst %s) from %s -> broadcaster %s, sdpLen=%s"):format(instanceId, src, inst.broadcaster, tostring(datalen)))
	TriggerClientEvent('music:rtc:offer', inst.broadcaster, json.encode({ instanceId = instanceId, from = src, sdp = payload.sdp or "" }))
end)

RegisterNetEvent('music:rtc:answer', function(targetId, sdp)
	local src = tonumber(source)
	-- For multi-instance, answer must be from a broadcaster of some instance.
	local toId = tonumber(targetId)
	if not toId then return end
	-- Find the instance the src is broadcasting
	local broadcasterInstanceId = nil
	for id, inst in pairs(MusicInstances) do
		if inst.broadcaster ~= nil and inst.broadcaster == src then
			broadcasterInstanceId = id
			break
		end
	end
	if not broadcasterInstanceId then return end
	debugPrint(("[music] answer (inst %s) from broadcaster %s -> %s, sdpLen=%s"):format(broadcasterInstanceId, src, toId, tostring(#(sdp or ""))))
	TriggerClientEvent('music:rtc:answer', toId, json.encode({ instanceId = broadcasterInstanceId, sdp = sdp }))
end)

RegisterNetEvent('music:rtc:iceToBroadcaster', function(data)
	local src = tonumber(source)
	-- Expect data to be a JSON payload: { instanceId, candidate }
	local payload = {}
	do
		local ok, parsed = pcall(function() return json.decode(data or "{}") end)
		if ok and type(parsed) == "table" then payload = parsed end
	end
	local instanceId = tonumber(payload.instanceId or -1)
	if instanceId == nil or MusicInstances[instanceId] == nil then return end
	local inst = MusicInstances[instanceId]
	if inst.broadcaster == nil then return end
	debugPrint(("[music] ice to broadcaster (inst %s) from %s"):format(instanceId, src))
	TriggerClientEvent('music:rtc:iceFromListener', inst.broadcaster, json.encode({ instanceId = instanceId, from = src, candidate = payload.candidate }))
end)

RegisterNetEvent('music:rtc:iceToListener', function(targetId, candidate)
	local src = tonumber(source)
	-- ICE from broadcaster to listener; ensure src is an active broadcaster of some instance
	local toId = tonumber(targetId)
	if not toId then return end
	local broadcasterInstanceId = nil
	for id, inst in pairs(MusicInstances) do
		if inst.broadcaster ~= nil and inst.broadcaster == src then
			broadcasterInstanceId = id
			break
		end
	end
	if not broadcasterInstanceId then return end
	debugPrint(("[music] ice to listener %s from broadcaster %s (inst %s)"):format(toId, src, broadcasterInstanceId))
	TriggerClientEvent('music:rtc:iceFromBroadcaster', toId, json.encode({ instanceId = broadcasterInstanceId, candidate = candidate }))
end)