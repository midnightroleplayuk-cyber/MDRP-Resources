Clubs = {}
RegisteredEntityTypes = {}
EntityPlayers = {}

local function IsVectorTable(value)
    if type(value) ~= "table" then return false end
    if type(value.x) ~= "number" or type(value.y) ~= "number" or type(value.z) ~= "number" then
        return false
    end
    for k, _ in pairs(value) do
        if k ~= "x" and k ~= "y" and k ~= "z" then
            return false
        end
    end
    return true
end

local function NormalizeForDb(value)
    local valueType = type(value)
    if valueType == "vector3" then
        return { x = value.x, y = value.y, z = value.z }
    end
    if valueType ~= "table" then
        return value
    end
    local output = {}
    for k, v in pairs(value) do
        output[k] = NormalizeForDb(v)
    end
    return output
end

local function NormalizeFromDb(value)
    if type(value) ~= "table" then return value end
    if IsVectorTable(value) then
        return vector3(value.x, value.y, value.z)
    end
    local output = {}
    for k, v in pairs(value) do
        output[k] = NormalizeFromDb(v)
    end
    return output
end

local function NormalizeJobs(jobs)
    if type(jobs) ~= "table" then return {} end
    local out = {}
    for i = 1, #jobs do
        local j = jobs[i]
        if type(j) == "table" and type(j.name) == "string" and j.name ~= "" then
            out[#out + 1] = { name = j.name, primary = j.primary == true }
        end
    end
    return out
end

function GetClubDrinkMenu(clubId)
    local club = Clubs[clubId]
    if not club then return {} end
    return club.drink_menu or {}
end

local function BuildClubPacket(data)
    return {
        label = data.label,
        description = data.description,
        coords = data.coords,
        jobs = NormalizeJobs(data.jobs or {}),
        entities = data.entities or {},
        drink_menu = data.drink_menu and type(data.drink_menu) == "table" and data.drink_menu or {},
        blip = data.blip,
        entry_settings = data.entry_settings,
    }
end

local function GenerateEntityId()
    return ("club-%d-%d"):format(os.time(), math.random(100000, 999999))
end

local function IsVectorLike(value)
    if type(value) == "vector3" then return true end
    if type(value) ~= "table" then return false end
    local x = value.x or value[1]
    local y = value.y or value[2]
    local z = value.z or value[3]
    return type(x) == "number" and type(y) == "number" and type(z) == "number"
end

local function DeepCopyTable(t)
    if type(t) ~= "table" then return t end
    local o = {}
    for k, v in pairs(t) do
        o[k] = DeepCopyTable(v)
    end
    return o
end

-- Merge incoming entity fields into existing so partial updates (e.g. move position) do not drop flags like bouncer.vipMode.
local function MergeNestedEntity(existing, incoming)
    if type(existing) ~= "table" then existing = {} end
    if type(incoming) ~= "table" then return DeepCopyTable(existing) end
    local out = DeepCopyTable(existing)
    for k, v in pairs(incoming) do
        if IsVectorLike(v) then
            out[k] = v
        elseif type(v) == "table" and type(out[k]) == "table" and not IsVectorLike(out[k]) then
            out[k] = MergeNestedEntity(out[k], v)
        else
            out[k] = v
        end
    end
    return out
end

local function MergeEntityUpdate(existing, incoming)
    if type(existing) ~= "table" or type(incoming) ~= "table" then return incoming or existing end
    local out = DeepCopyTable(existing)
    for k, v in pairs(incoming) do
        if k == "type" then
            out[k] = v
        elseif k == "bouncer" and type(v) == "table" then
            out.bouncer = MergeNestedEntity(out.bouncer, v)
        elseif k == "bartender" and type(v) == "table" then
            out.bartender = MergeNestedEntity(out.bartender, v)
        elseif k == "society" and type(v) == "table" then
            out.society = MergeNestedEntity(out.society, v)
        elseif k == "eject" and type(v) == "table" then
            out.eject = MergeNestedEntity(out.eject, v)
        else
            out[k] = v
        end
    end
    return out
end

local function ValidateEntityData(entityType, entityData)
    if type(entityData) ~= "table" then
        return false, "Invalid entity payload"
    end

    if entityType == "bartender" then
        local bartender = entityData.bartender
        if type(bartender) ~= "table" then
            return false, "Missing bartender settings"
        end
        if not IsVectorLike(bartender.coords) then
            return false, "Bartender coords are required"
        end
        if type(bartender.heading) ~= "number" then
            return false, "Bartender heading is required"
        end
        return true
    end

    if entityType == "bouncer" then
        local bouncer = entityData.bouncer
        if type(bouncer) ~= "table" then
            return false, "Missing bouncer settings"
        end
        if not IsVectorLike(bouncer.coords) then
            return false, "Bouncer coords are required"
        end
        if type(bouncer.heading) ~= "number" then
            return false, "Bouncer heading is required"
        end
        if type(bouncer.ped) ~= "string" or bouncer.ped == "" then
            return false, "Bouncer ped id is required"
        end
        if bouncer.vipMode ~= nil and type(bouncer.vipMode) ~= "boolean" then
            return false, "vipMode must be a boolean"
        end
        return true
    end

    if entityType == "club_entry" then
        local bouncer = entityData.bouncer
        local eject = entityData.eject
        if type(bouncer) ~= "table" or type(eject) ~= "table" then
            return false, "Club entry requires bouncer and eject settings"
        end
        if not IsVectorLike(bouncer.coords) or type(bouncer.heading) ~= "number" then
            return false, "Club entry bouncer coords/heading are required"
        end
        if type(bouncer.ped) ~= "string" or bouncer.ped == "" then
            return false, "Club entry bouncer ped id is required"
        end
        if not IsVectorLike(eject.coords) or type(eject.heading) ~= "number" then
            return false, "Club entry eject coords/heading are required"
        end
        return true
    end

    if entityType == "society" then
        local society = entityData.society
        if type(society) ~= "table" then
            return false, "Missing society settings"
        end
        if not IsVectorLike(society.coords) then
            return false, "Society coords are required"
        end
        if type(society.heading) ~= "number" then
            return false, "Society heading is required"
        end
        return true
    end

    return true
end

local function SyncAllClubs(target)
    local payload = {}
    for id, club in pairs(Clubs) do
        payload[id] = {
            label = club.label,
            description = club.description,
            coords = club.coords,
            jobs = club.jobs,
            entities = club.entities,
            drink_menu = club.drink_menu or {},
            blip = club.blip,
            entry_settings = club.entry_settings,
        }
    end
    TriggerClientEvent("pickle_clubs:syncClubs", target or -1, payload)
end

function RegisterClub(data, skipSync)
    Clubs[data.id] = BuildClubPacket(data)
    for entityId, _ in pairs(Clubs[data.id].entities) do
        StartClubEntity(data.id, entityId)
    end
    if not skipSync then
        SyncAllClubs(-1)
    end
end

function StartClubEntity(id, entityId)
    local club = Clubs[id]
    if not club then return end
    local entity = club.entities[entityId]
    if not entity then return end
    if not RegisteredEntityTypes[entity.type] then return end
    RegisteredEntityTypes[entity.type].onStart(id, entityId)
end

function StopClubEntity(id, entityId)
    local club = Clubs[id]
    if not club then return end
    local entity = club.entities[entityId]
    if not entity then return end
    if not RegisteredEntityTypes[entity.type] then return end
    RegisteredEntityTypes[entity.type].onStop(id, entityId)
end

function RegisterEntityType(entityType, data)
    RegisteredEntityTypes[entityType] = {
        label = data.label or entityType,
        description = data.description or ("This is the " .. entityType .. " entity type."),
        data = data.data or {},
        onStart = data.onStart or function()
            print("ERROR: No onStart callback for entity type: " .. entityType)
        end,
        onRender = data.onRender or function()
            print("ERROR: No onRender callback for entity type: " .. entityType)
        end,
        onUnrender = data.onUnrender or function()
            print("ERROR: No onUnrender callback for entity type: " .. entityType)
        end,
        onStop = data.onStop or function()
            print("ERROR: No onStop callback for entity type: " .. entityType)
        end,
    }

    for clubId, club in pairs(Clubs) do
        for entityId, entity in pairs(club.entities or {}) do
            if entity.type == entityType then
                StartClubEntity(clubId, entityId)
            end
        end
    end
end

function UnregisterEntityType(entityType)
    RegisteredEntityTypes[entityType] = nil
end

function TriggerEntityEvent(event, id, entityId, ...)
    if not EntityPlayers[id] or not EntityPlayers[id][entityId] then return end
    for i = 1, #EntityPlayers[id][entityId] do
        local player = EntityPlayers[id][entityId][i]
        TriggerClientEvent(event, player, id, entityId, ...)
    end
end

function GetClub(id)
    return Clubs[id]
end

function CreateClub(data, cb)
    local payloadCoords = NormalizeForDb(data.coords)
    local jobs = NormalizeJobs(data.jobs or {})
    local jobsJson = json.encode(NormalizeForDb(jobs))
    local drinkMenu = type(data.drink_menu) == "table" and data.drink_menu or {}
    local drinkMenuJson = json.encode(NormalizeForDb(drinkMenu))
    local blip = type(data.blip) == "table" and NormalizeForDb(data.blip) or nil
    local blipJson = blip and json.encode(blip) or nil
    local entrySettings = type(data.entry_settings) == "table" and NormalizeForDb(data.entry_settings) or nil
    local entrySettingsJson = entrySettings and json.encode(entrySettings) or nil
    MySQL.Async.insert(
        "INSERT INTO pickle_clubs (label, description, coords, jobs, drink_menu, blip, entry_settings) VALUES (@label, @description, @coords, @jobs, @drink_menu, @blip, @entry_settings)",
        {
            ["@label"] = data.label,
            ["@description"] = data.description or "",
            ["@coords"] = json.encode(payloadCoords),
            ["@jobs"] = jobsJson,
            ["@drink_menu"] = drinkMenuJson,
            ["@blip"] = blipJson,
            ["@entry_settings"] = entrySettingsJson,
        },
        function(insertId)
            if not insertId then
                if cb then cb(false, "Failed to create club") end
                return
            end
            RegisterClub({
                id = insertId,
                label = data.label,
                description = data.description or "",
                coords = data.coords,
                jobs = jobs,
                entities = {},
                drink_menu = drinkMenu,
                blip = blip,
                entry_settings = entrySettings,
            }, false)
            if cb then cb(true, insertId) end
        end
    )
end

local function CountPrimaryJobs(jobs)
    local n = 0
    for i = 1, #(jobs or {}) do
        if jobs[i].primary then n = n + 1 end
    end
    return n
end

function UpdateClub(id, data, cb)
    if data.drink_menu~=nil and not ClubValidMenu(data.drink_menu) then if cb then cb(false,'Invalid drink menu') end; return end
    local club = Clubs[id]
    if not club then
        if cb then cb(false, "Club not found") end
        return
    end
    local jobs = (data.jobs ~= nil) and NormalizeJobs(data.jobs) or club.jobs
    if CountPrimaryJobs(jobs) ~= 1 and #jobs > 0 then
        if cb then cb(false, "Exactly one job must be marked primary") end
        return
    end
    local drinkMenu = (data.drink_menu ~= nil and type(data.drink_menu) == "table") and data.drink_menu or club.drink_menu
    if drinkMenu == nil then drinkMenu = {} end
    local blip = (data.blip ~= nil) and data.blip or club.blip
    local entrySettings = (data.entry_settings ~= nil) and data.entry_settings or club.entry_settings
    local updateData = {
        label = data.label or club.label,
        description = data.description or club.description,
        coords = data.coords or club.coords,
        jobs = jobs,
        drink_menu = drinkMenu,
        blip = blip,
        entry_settings = entrySettings,
    }
    MySQL.Async.execute(
        "UPDATE pickle_clubs SET label = @label, description = @description, coords = @coords, jobs = @jobs, drink_menu = @drink_menu, blip = @blip, entry_settings = @entry_settings WHERE id = @id",
        {
            ["@id"] = id,
            ["@label"] = updateData.label,
            ["@description"] = updateData.description or "",
            ["@coords"] = json.encode(NormalizeForDb(updateData.coords)),
            ["@jobs"] = json.encode(NormalizeForDb(updateData.jobs or {})),
            ["@drink_menu"] = json.encode(NormalizeForDb(updateData.drink_menu or {})),
            ["@blip"] = updateData.blip and json.encode(NormalizeForDb(updateData.blip)) or nil,
            ["@entry_settings"] = updateData.entry_settings and json.encode(NormalizeForDb(updateData.entry_settings)) or nil,
        },
        function(affectedRows)
            if affectedRows and affectedRows > 0 then
                club.label = updateData.label
                club.description = updateData.description
                club.coords = updateData.coords
                club.jobs = updateData.jobs
                club.drink_menu = updateData.drink_menu
                club.blip = updateData.blip
                club.entry_settings = updateData.entry_settings
                SyncAllClubs(-1)
                if cb then cb(true) end
            else
                if cb then cb(false, "Failed to update club") end
            end
        end
    )
end

function DeleteClub(id, cb)
    local club = Clubs[id]
    if not club then
        if cb then cb(false, "Club not found") end
        return
    end
    for entityId, _ in pairs(club.entities or {}) do
        StopClubEntity(id, entityId)
    end
    Clubs[id] = nil
    EntityPlayers[id] = nil
    SyncAllClubs(-1)
    MySQL.Sync.execute("DELETE FROM pickle_club_entities WHERE club_id = @id", {["@id"]=id})
    MySQL.Async.execute("DELETE FROM pickle_clubs WHERE id = @id", {
        ["@id"] = id,
    }, function(affectedRows)
        if cb then cb((affectedRows or 0) > 0) end
    end)
end

function CreateClubEntity(clubId, entityType, entityData, entityId, cb)
    local club = Clubs[clubId]
    if not club then
        if cb then cb(false, "Club not found") end
        return
    end
    local key = entityId or GenerateEntityId()
    local valid, validationMessage = ValidateEntityData(entityType, entityData)
    if not valid then
        if cb then cb(false, validationMessage or "Invalid entity payload") end
        return
    end
    local payload = NormalizeForDb(entityData or {})
    MySQL.Async.insert(
        "INSERT INTO pickle_club_entities (club_id, entity_key, entity_type, entity_data) VALUES (@club_id, @entity_key, @entity_type, @entity_data)",
        {
            ["@club_id"] = clubId,
            ["@entity_key"] = key,
            ["@entity_type"] = entityType,
            ["@entity_data"] = json.encode(payload),
        },
        function(insertId)
            if not insertId then
                if cb then cb(false, "Failed to create entity") end
                return
            end
            club.entities[key] = entityData or {}
            club.entities[key].type = entityType
            StartClubEntity(clubId, key)
            SyncAllClubs(-1)
            if cb then cb(true, key) end
        end
    )
end

function UpdateClubEntity(clubId, entityId, entityData, cb)
    local club = Clubs[clubId]
    if not club then
        if cb then cb(false, "Club not found") end
        return
    end
    local entity = club.entities[entityId]
    if not entity then
        if cb then cb(false, "Entity not found") end
        return
    end
    local merged = MergeEntityUpdate(entity, entityData)
    local nextType = merged.type or entityData.type or entity.type
    merged.type = nextType
    if merged.bouncer and merged.bouncer.vipMode ~= nil then
        local v = merged.bouncer.vipMode
        merged.bouncer.vipMode = (v == true or v == 1 or v == "1" or v == "true")
    end
    local valid, validationMessage = ValidateEntityData(nextType, merged)
    if not valid then
        if cb then cb(false, validationMessage or "Invalid entity payload") end
        return
    end
    local payload = NormalizeForDb(merged)
    payload.type = nil
    MySQL.Async.execute(
        "UPDATE pickle_club_entities SET entity_type = @entity_type, entity_data = @entity_data WHERE club_id = @club_id AND entity_key = @entity_key",
        {
            ["@club_id"] = clubId,
            ["@entity_key"] = entityId,
            ["@entity_type"] = nextType,
            ["@entity_data"] = json.encode(payload),
        },
        function(affectedRows)
            if affectedRows and affectedRows > 0 then
                StopClubEntity(clubId, entityId)
                club.entities[entityId] = merged
                club.entities[entityId].type = nextType
                StartClubEntity(clubId, entityId)
                SyncAllClubs(-1)
                if cb then cb(true) end
            else
                if cb then cb(false, "Failed to update entity") end
            end
        end
    )
end

function DeleteClubEntity(clubId, entityId, cb)
    local club = Clubs[clubId]
    if not club or not club.entities[entityId] then
        if cb then cb(false, "Entity not found") end
        return
    end
    StopClubEntity(clubId, entityId)
    club.entities[entityId] = nil
    if EntityPlayers[clubId] then
        EntityPlayers[clubId][entityId] = nil
    end
    SyncAllClubs(-1)
    MySQL.Async.execute(
        "DELETE FROM pickle_club_entities WHERE club_id = @club_id AND entity_key = @entity_key",
        {
            ["@club_id"] = clubId,
            ["@entity_key"] = entityId,
        },
        function(affectedRows)
            if cb then cb((affectedRows or 0) > 0) end
        end
    )
end

function LoadAllClubs()
    MySQL.Async.fetchAll("SELECT * FROM pickle_clubs", {}, function(clubRows)
        MySQL.Async.fetchAll("SELECT * FROM pickle_club_entities", {}, function(entityRows)
            local loaded = {}
            for i = 1, #(clubRows or {}) do
                local row = clubRows[i]
                local coords = json.decode(row.coords or "{}") or {}
                local jobsRaw = row.jobs
                local jobsDecoded = (type(jobsRaw) == "string" and json.decode(jobsRaw)) or (type(jobsRaw) == "table" and jobsRaw) or {}
                local drinkMenuRaw = row.drink_menu
                local drinkMenu = (type(drinkMenuRaw) == "string" and json.decode(drinkMenuRaw)) or (type(drinkMenuRaw) == "table" and drinkMenuRaw) or {}
                local blipRaw = row.blip
                local blip = (type(blipRaw) == "string" and json.decode(blipRaw)) or (type(blipRaw) == "table" and blipRaw) or nil
                local entrySettingsRaw = row.entry_settings
                local entrySettings = (type(entrySettingsRaw) == "string" and json.decode(entrySettingsRaw)) or (type(entrySettingsRaw) == "table" and entrySettingsRaw) or nil
                loaded[row.id] = {
                    id = row.id,
                    label = row.label,
                    description = row.description or "",
                    coords = NormalizeFromDb(coords),
                    jobs = NormalizeJobs(jobsDecoded),
                    entities = {},
                    drink_menu = drinkMenu,
                    blip = blip,
                    entry_settings = entrySettings,
                }
            end
            for i = 1, #(entityRows or {}) do
                local row = entityRows[i]
                local club = loaded[row.club_id]
                if club then
                    local decodedData = json.decode(row.entity_data or "{}") or {}
                    local entityData = NormalizeFromDb(decodedData)
                    entityData.type = row.entity_type
                    club.entities[row.entity_key] = entityData
                end
            end
            Clubs = {}
            for id, clubData in pairs(loaded) do
                RegisterClub(clubData, true)
            end
            ClubsLoaded=true
            SyncAllClubs(-1)
            print(("^2[pickle_clubs]^0 Loaded %s clubs from SQL."):format(#(clubRows or {})))
        end)
    end)
end

RegisterNetEvent("pickle_clubs:renderEntity", function(id, entityId, ...)
    local source = source
    local club = Clubs[id]
    if not club then return end
    local entity = club.entities[entityId]
    if not entity then return end
    if not RegisteredEntityTypes[entity.type] then return end
    RegisteredEntityTypes[entity.type].onRender(id, entityId, source, ...)
    if not EntityPlayers[id] then EntityPlayers[id] = {} end
    if not EntityPlayers[id][entityId] then EntityPlayers[id][entityId] = {} end
    for i = 1, #EntityPlayers[id][entityId] do
        local player = EntityPlayers[id][entityId][i]
        if player == source then
            table.remove(EntityPlayers[id][entityId], i)
            break
        end
    end
    table.insert(EntityPlayers[id][entityId], source)
end)

RegisterNetEvent("pickle_clubs:unrenderEntity", function(id, entityId, ...)
    local source = source
    local club = Clubs[id]
    if not club then return end
    local entity = club.entities[entityId]
    if not entity then return end
    if not RegisteredEntityTypes[entity.type] then return end
    RegisteredEntityTypes[entity.type].onUnrender(id, entityId, source, ...)
    if not EntityPlayers[id] then EntityPlayers[id] = {} end
    if not EntityPlayers[id][entityId] then EntityPlayers[id][entityId] = {} end
    for i = 1, #EntityPlayers[id][entityId] do
        local player = EntityPlayers[id][entityId][i]
        if player == source then
            table.remove(EntityPlayers[id][entityId], i)
            break
        end
    end
end)

RegisterNetEvent("pickle_clubs:createClub", function(payload)
    local src = source
    if not IsPlayerAdmin(src) then return end
    CreateClub(payload, function(success, result)
        if success then
            ShowNotification(src, "Created club #" .. tostring(result))
        else
            ShowNotification(src, result or "Failed to create club")
        end
    end)
end)

RegisterNetEvent("pickle_clubs:updateClub", function(id, payload)
    local src = source
    if not CanManageClub(src, id) then return end
    UpdateClub(id, payload, function(success, result)
        if success then
            ShowNotification(src, "Club updated")
        else
            ShowNotification(src, result or "Failed to update club")
        end
    end)
end)

RegisterNetEvent("pickle_clubs:deleteClub", function(id)
    local src = source
    if not IsPlayerAdmin(src) then return end
    DeleteClub(id, function(success)
        if success then
            ShowNotification(src, "Club deleted")
        else
            ShowNotification(src, "Failed to delete club")
        end
    end)
end)

RegisterNetEvent("pickle_clubs:createClubEntity", function(clubId, entityType, entityData)
    local src = source
    if not CanManageClub(src, clubId) then return end
    CreateClubEntity(clubId, entityType, entityData, nil, function(success, result)
        if success then
            ShowNotification(src, ("Added %s entity (%s)"):format(entityType, result))
        else
            ShowNotification(src, result or "Failed to create entity")
        end
    end)
end)

RegisterNetEvent("pickle_clubs:updateClubEntity", function(clubId, entityId, entityData)
    local src = source
    if not CanManageClub(src, clubId) then return end
    UpdateClubEntity(clubId, entityId, entityData, function(success, result)
        if success then
            ShowNotification(src, "Entity updated")
        else
            ShowNotification(src, result or "Failed to update entity")
        end
    end)
end)

RegisterNetEvent("pickle_clubs:deleteClubEntity", function(clubId, entityId)
    local src = source
    if not CanManageClub(src, clubId) then return end
    DeleteClubEntity(clubId, entityId, function(success)
        if success then
            ShowNotification(src, "Entity deleted")
        else
            ShowNotification(src, "Failed to delete entity")
        end
    end)
end)

function GetPrimaryJobName(club)
    local jobs = club and club.jobs or {}
    for i = 1, #jobs do
        if jobs[i].primary and type(jobs[i].name) == "string" and jobs[i].name ~= "" then
            return jobs[i].name
        end
    end
    return nil
end

function CanManageClub(source, clubId)
    if IsPlayerAdmin(source) then return true end
    local club = Clubs[clubId]
    if not club then return false end
    local primary = GetPrimaryJobName(club)
    if not primary then return false end
    return IsPlayerJobBoss(source, primary)
end

function PlayerCanManageAnyClub(source)
    if IsPlayerAdmin(source) then return true end
    for clubId, club in pairs(Clubs) do
        local primary = GetPrimaryJobName(club)
        if primary and IsPlayerJobBoss(source, primary) then return true end
    end
    return false
end

local function PlayerHasClubAccess(source, clubId)
    local club = Clubs[clubId]
    if not club or not club.jobs then return false end
    local jobName = GetPlayerJobName(source)
    if not jobName then return false end
    for i = 1, #club.jobs do
        if club.jobs[i].name == jobName then
            return true
        end
    end
    return false
end

lib.callback.register("pickle_clubs:getSocietyBalance", function(source, clubId)
    if not clubId or not Clubs[clubId] then return nil end
    if not CanManageClub(source, clubId) then return nil end
    local club = Clubs[clubId]
    local societyName = GetPrimaryJobName(club)
    if not societyName then return 0 end
    local balance = 0
    local done = false
    GetSocietyBalance(societyName, function(b)
        balance = b
        done = true
    end)
    local deadline=GetGameTimer()+5000
    while not done and GetGameTimer()<deadline do Wait(0) end
    if not done then return false,"Society API timeout" end
    return balance
end)

local societyLocks={}
local function transfer(source,clubId,amount,withdraw)
    if not CanManageClub(source,clubId) or not ClubFinite(amount,1,10000000) or amount%1~=0 then return false,'Invalid transfer' end
    local name=GetPrimaryJobName(Clubs[clubId])
    if not name or societyLocks[name] then return false,'Society busy' end
    societyLocks[name]=true
    local owner=GetIdentifier(source)
    local ok,success=pcall(function()
        if withdraw then
            local done,balance=false,nil
            GetSocietyBalance(name,function(n) balance=n; done=true end)
            local deadline=GetGameTimer()+5000
            while not done and GetGameTimer()<deadline do Wait(0) end
            if not done or not ClubFinite(balance,amount,1e15) then return false end
            done=false
            local removed=false
            RemoveSocietyMoney(name,amount,function(result) removed=result==true; done=true end)
            deadline=GetGameTimer()+5000
            while not done and GetGameTimer()<deadline do Wait(0) end
            if not done or not removed then return false end
            if GetIdentifier(source)~=owner or AddMoney(source,amount,'money')~=true then
                AddSocietyMoney(name,amount); return false
            end
            return true
        end
        if RemoveMoney(source,amount,'money')~=true then return false end
        if AddSocietyMoney(name,amount)~=true then AddMoney(source,amount,'money'); return false end
        return true
    end)
    societyLocks[name]=nil
    return ok and success==true
end
lib.callback.register('pickle_clubs:societyDeposit',function(source,id,amount) return transfer(source,id,tonumber(amount),false) end)
lib.callback.register('pickle_clubs:societyWithdraw',function(source,id,amount) return transfer(source,id,tonumber(amount),true) end)

lib.callback.register("pickle_clubs:checkIsAdmin", function(source)
    return IsPlayerAdmin(source) or PlayerCanManageAnyClub(source)
end)

lib.callback.register("pickle_clubs:canManageClub", function(source, clubId)
    return CanManageClub(source, clubId)
end)

AddEventHandler("playerDropped", function()
    local src = source
    for _, entityMap in pairs(EntityPlayers) do
        for _, players in pairs(entityMap) do
            for i = 1, #players do
                if players[i] == src then
                    table.remove(players, i)
                    break
                end
            end
        end
    end
end)

RegisterNetEvent("pickle_clubs:initializePlayer", function()
    local src = source
    SyncAllClubs(src)
end)

RegisterCommand("clubs", function(source)
    if source == 0 then return end
    if not IsPlayerAdmin(source) then
        ShowNotification(source, "You don't have permission to use this command")
        return
    end
    TriggerClientEvent("pickle_clubs:openClubManagement", source)
end, false)

MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS pickle_clubs (
            id INT AUTO_INCREMENT PRIMARY KEY,
            label VARCHAR(255) NOT NULL,
            description TEXT NULL,
            coords JSON NOT NULL,
            jobs JSON NULL,
            drink_menu JSON NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    ]], {}, function()
        MySQL.Async.execute("ALTER TABLE pickle_clubs ADD COLUMN IF NOT EXISTS drink_menu JSON NULL", {}, function() end)
        MySQL.Async.execute("ALTER TABLE pickle_clubs ADD COLUMN IF NOT EXISTS blip JSON NULL", {}, function() end)
        MySQL.Async.execute("ALTER TABLE pickle_clubs ADD COLUMN IF NOT EXISTS entry_settings JSON NULL", {}, function() end)
        MySQL.Async.execute([[
            CREATE TABLE IF NOT EXISTS pickle_club_entities (
                id INT AUTO_INCREMENT PRIMARY KEY,
                club_id INT NOT NULL,
                entity_key VARCHAR(255) NOT NULL,
                entity_type VARCHAR(100) NOT NULL,
                entity_data LONGTEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE KEY unique_club_entity (club_id, entity_key),
                INDEX idx_club_id (club_id)
            )
        ]], {}, function()
            LoadAllClubs()
        end)
    end)
end)