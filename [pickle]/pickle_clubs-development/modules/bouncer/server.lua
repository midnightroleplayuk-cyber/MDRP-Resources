Bouncers = {}

function GetBouncer(id, entityId)
    return Bouncers[id] and Bouncers[id][entityId]
end

function RegisterBouncer(id, entityId)
    local club = Clubs[id]
    if not club then return end
    local entity = club.entities[entityId]
    if not entity then return end
    local entry = {
        lineThread = false,
        players = {
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
            -- {source = nil},
        },
        variables = {}
    }
    if not Bouncers[id] then Bouncers[id] = {} end
    Bouncers[id][entityId] = entry
end

function UnregisterBouncer(id, entityId)
    if not Bouncers[id] or not Bouncers[id][entityId] then return end
    Bouncers[id][entityId] = nil
end

function ThrowOutPlayer(source, id)
    local entry, entityId = GetAnyClubEntry(id)
    if not entry then return end
    if not entityId then return end
    TriggerEntityEvent("pickle_clubs:throwOutPlayer", id, entityId, source)
end

RegisterNetEvent("pickle_clubs:throwOutPlayer", function(id)
    local source = source
    ThrowOutPlayer(source, id)
end)

-- Returns true if the bouncer source is within Config.RenderDistance of any
-- bouncer-type entity belonging to a club whose primary job they hold.
local function BouncerIsInZone(bouncerSource)
    local ped = GetPlayerPed(bouncerSource)
    if not ped or ped == 0 then return false end
    local coords = GetEntityCoords(ped)
    local jobName = GetPlayerJobName(bouncerSource)
    if not jobName then return false end
    for clubId, club in pairs(Clubs) do
        if club and club.entities and club.jobs then
            local jobMatch = false
            for i = 1, #club.jobs do
                if club.jobs[i].name == jobName then jobMatch = true; break end
            end
            if jobMatch then
                for _, entity in pairs(club.entities) do
                    if entity.type == "bouncer" and entity.bouncer and entity.bouncer.coords then
                        local ec = entity.bouncer.coords
                        local ex = ec.x or (type(ec) == "table" and ec[1])
                        local ey = ec.y or (type(ec) == "table" and ec[2])
                        local ez = ec.z or (type(ec) == "table" and ec[3])
                        if ex and ey and ez then
                            if #(coords - vector3(ex, ey, ez)) < Config.RenderDistance then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

-- Escort: attach victim to bouncer
RegisterNetEvent("pickle_clubs:startEscort", function(targetSource, bouncerSource)
    if not (Config.Bouncer and Config.Bouncer.enableEscorting) then return end
    local src = source
    targetSource = tonumber(targetSource)
    bouncerSource = tonumber(bouncerSource)
    if not targetSource or not bouncerSource then return end
    if bouncerSource ~= src then return end
    if not BouncerIsInZone(bouncerSource) then return end
    if not ClubNearby(src,targetSource,3) or ClubEscorts[targetSource] then return end
    ClubEscorts[targetSource]=src
    ShowNotification(targetSource, "You are being escorted by a bouncer")
    TriggerClientEvent("pickle_clubs:escortAttach", targetSource, bouncerSource)
end)

-- Escort: fling victim
RegisterNetEvent("pickle_clubs:flingEscort", function(targetSource, forwardX, forwardY)
    if not (Config.Bouncer and Config.Bouncer.enableEscorting) then return end
    targetSource = tonumber(targetSource)
    if not targetSource then return end
    if ClubEscorts[targetSource]~=source or not ClubNearby(source,targetSource,5) then return end
    local forward=GetEntityForwardVector(GetPlayerPed(source))
    ClubEscorts[targetSource]=nil
    TriggerClientEvent("pickle_clubs:escortFling", targetSource, forward.x, forward.y)
end)

-- Escort: release victim
RegisterNetEvent("pickle_clubs:stopEscort", function(targetSource)
    targetSource = tonumber(targetSource)
    if not targetSource then return end
    if ClubEscorts[targetSource]~=source then return end
    ClubEscorts[targetSource]=nil
    TriggerClientEvent("pickle_clubs:escortDetach", targetSource)
end)

-- Revoke all club passes for a player
RegisterNetEvent("pickle_clubs:revokeAllPasses", function(targetSource)
    targetSource = tonumber(targetSource)
    if not targetSource then return end
    if not BouncerIsInZone(source) or not ClubNearby(source,targetSource,5) then return end
    for clubId, passes in pairs(ClubPasses or {}) do
        if ClubStaff(source,clubId) and passes[targetSource] then
            SetClubPass(targetSource, clubId, false)
        end
    end
end)

-- Get a player's inventory for search
lib.callback.register("pickle_clubs:getPlayerInventory", function(source, targetSource)
    targetSource = tonumber(targetSource)
    if not targetSource or not Inventory or not Inventory.GetInventory then return {}, "Unknown" end
    if not BouncerIsInZone(source) or not ClubNearby(source,targetSource,3) then return {},"No access" end
    local items = Inventory.GetInventory(targetSource)
    for i = 1, #items do
        local item = items[i]
        if Inventory.Items and Inventory.Items[item.name] then
            item.label = Inventory.Items[item.name].label or item.label or item.name
            item.description = Inventory.Items[item.name].description
        end
    end
    local charName = GetPlayerCharacterName and GetPlayerCharacterName(targetSource) or ("Player " .. targetSource)
    return items, charName
end)

CreateThread(function()
    RegisterEntityType("bouncer", {
        label = "Bouncer",
        description = "This is the bouncer entity type.",
        onStart = function(id, entityId)
            RegisterBouncer(id, entityId)
        end,
        onRender = function(id, entityId, source)
            -- SetTimeout(1000, function()
            --     ThrowOutPlayer(source, id)
            -- end)
        end,
        onUnrender = function(id, entityId, source)
        end,
        onStop = function(id, entityId)
            UnregisterBouncer(id, entityId)
        end,
    })
end)