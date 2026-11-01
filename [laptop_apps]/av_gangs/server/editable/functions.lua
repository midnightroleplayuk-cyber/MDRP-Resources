-- This functions are here just in case u need it, I don't provide any support on how to trigger X event/export to other resources that aren't mine, including qb-core/gangs
-- The qb gangs code is just an example, if isn't working anymore bc qb-core got updated is on u to make the needed changes

function newGang(name, label, boss) -- Triggered when a new gang is created
	-- gang name, gang label, boss playerID?
	
end

function removeGang(name) -- Triggered when a gang gets deleted
	-- gang name

end


function AddMember(src,identifier,isboss,gang) -- triggered when someone is added to a gang
    -- local target = Core.Functions.GetPlayer(src)
    -- target.Functions.SetGang(gang, 0)
end

function RemoveMember(identifier,gang) -- triggered when someone is removed from a gang
    -- local Player = Core.Functions.GetPlayerByCitizenId(identifier)
    -- if Player then -- Online
    --     Player.Functions.SetGang("none", '0')
    -- else
    --     local target = MySQL.query.await('SELECT * FROM players WHERE citizenid = ? LIMIT 1', {identifier})
    --     if target[1] ~= nil then
	-- 		Player = target[1]
	-- 		Player.gang = json.decode(Player.gang)
	-- 		local gang = {}
	-- 		gang.name = "none"
	-- 		gang.label = "No Affiliation"
	-- 		gang.payment = 0
	-- 		gang.onduty = true
	-- 		gang.isboss = false
	-- 		gang.grade = {}
	-- 		gang.grade.name = nil
	-- 		gang.grade.level = 0
	-- 		MySQL.update('UPDATE players SET gang = ? WHERE citizenid = ?', {json.encode(gang), identifier})
	-- 	end
    -- end
end

-- Triggered when a player applies a graffiti
--- @param playerId number ID of the player who applied the graffiti
--- @param gang string Name of the gang that owns the graffiti
--- @param coords {x:number, y:number, z:number} Coords where the graffiti is being applied
--- @param zone string|nil Specific zone identifier or nil if not applicable
function SprayApplied(playerId,gang,coords,zone) -- triggered when someone applies a graffiti

end

-- Triggered when a player removes a gang graffiti
--- @param playerId number ID of the player who removed the graffiti
--- @param gang string Name of the gang that owned the graffiti
--- @param zone string|nil Specific zone identifier or nil if not applicable
function SprayRemoved(playerId,gang,zone)

end

 -- triggered right before sending an invite to player, return false to cancel the invite
--- @param playerId number ID of the player who got invited to join gang
--- @param gang string Name of the gang
function CanJoinGang(playerId, gang)
	local canJoin = true
	-- Add your own check here and change canJoin to false/true

	if not canJoin then
		TriggerClientEvent('av_laptop:notification', playerId, Lang['app_title'], "You can't join the gang", "error") -- Modify the notification
	end
	return canJoin
end

function getMaxMembers(gang)
	local max = Config.DefaultMembers
	if gangs[gang] and gangs[gang]['slots'] then
		max = gangs[gang]['slots']
	end
	return max
end

-- After running all process to buy a property, this function will be the last filter to allow (or not) a player to buy a property
-- Run your own check (if needed) or leave it as it is
--[[
	playerId:string Player server id
	productInfo:table Product info (name, label, price, level, etc)
	gang:Table Includes all gang info (level, xp, name, label, etc)
	zone:string Zone where the player is trying to buy
	door:Table door info (coords, zone, identifier, etc)
]]--
function extraPropertyCheck(playerId, productInfo, gang, zone, door)
	local canBuy = true

	return canBuy
end