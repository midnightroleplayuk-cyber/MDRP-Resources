ClubEntries = {}
ClubPasses = {}

function GetClubEntry(id, entityId)
    return ClubEntries[id] and ClubEntries[id][entityId]
end

function RegisterClubEntry(id, entityId)
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
    if not ClubEntries[id] then ClubEntries[id] = {} end
    ClubEntries[id][entityId] = entry
end

function UnregisterClubEntry(id, entityId)
    if not ClubEntries[id] or not ClubEntries[id][entityId] then return end
    ClubEntries[id][entityId] = nil
end

function IsPlayerInCEL(id, entityId, source)
    local entry = GetClubEntry(id, entityId)
    if not entry then return false end
    for i=1, #entry.players do
        if entry.players[i].source == source then
            return true
        end
    end
    return false
end

function GetCELVariable(id, entityId, variable)
    local entry = GetClubEntry(id, entityId)
    if not entry then return nil end
    return entry.variables[variable]
end
function SetCELVariable(id, entityId, variable, value)
    local entry = GetClubEntry(id, entityId)
    if not entry then return end
    entry.variables[variable] = value
end

function PromptCEL(id, entityId, source)
    TriggerClientEvent("pickle_clubs:promptCEL", source, id, entityId)
    SetCELVariable(id, entityId, "promptResult", {
        repsonse = false,
        result = nil,
    })
    local promptResult = nil
    local timeout = 10
    while timeout > 0 do
        promptResult = GetCELVariable(id, entityId, "promptResult")
        if promptResult and promptResult.response then
            if promptResult.result then
                -- Allow into club
                ShowNotification(source, "Welcome to the club! Enjoy the club!")
            else
                -- Deny entry
                ShowNotification(source, "Sorry, you're not welcome here.")
            end
            LeaveCEL(id, entityId, source)
            break
        else 
            timeout = timeout - 1
            if timeout <= 0 or not IsPlayerInCEL(id, entityId, source) then
                break
            end
        end
        Wait(1000)
    end
    if promptResult then return end
    print("Player left CEL: " .. id .. " " .. entityId .. " " .. source)
    LeaveCEL(id, entityId, source)
end

function EnsureCELThread(id, entityId)
    local entry = GetClubEntry(id, entityId)
    if not entry then return end
    if entry.lineThread then return end
    entry.lineThread = true
    CreateThread(function()
        while entry.lineThread do
            local players = entry.players
            if #players <= 0 then
                entry.lineThread = false
                return
            end
            local source = players[1].source
            if not source then 
                LeaveCEL(id, entityId, nil)
            else
                PromptCEL(id, entityId, source)
            end
            Wait(1000)
        end
    end)
end

function CELToTargets(id, entityId)
    local entry = GetClubEntry(id, entityId)
    if not entry then return end
    local targets = {}
    for i=1, #entry.players do
        table.insert(targets, entry.players[i].source)
    end
    return targets
end

function LeaveCEL(id, entityId, source)
    local entry = GetClubEntry(id, entityId)
    if not entry then return end
    for i=1, #entry.players do
        if entry.players[i].source == source then
            table.remove(entry.players, i)
            break
        end
    end
    TriggerEntityEvent("pickle_clubs:leaveLine", id, entityId, source, entry.players)
end

function GetClubPass(source, id)
    if not ClubPasses[id] then return false end
    if not ClubPasses[id][source] then return false end
    return ClubPasses[id][source]
end

-- passType: true = standard, "vip" = VIP pass, false/nil = revoke
function SetClubPass(source, id, passType)
    if not ClubPasses[id] then ClubPasses[id] = {} end
    ClubPasses[id][source] = passType
    if passType then
        ShowNotification(source, _L("club_entry_welcome"))
    else
        ShowNotification(source, _L("club_entry_exit"))
    end
    TriggerClientEvent("pickle_clubs:updateClubPass", source, id, ClubPasses[id][source])
end

function GetAnyClubEntry(id)
    for k,v in pairs(ClubEntries[id]) do
        return v, k
    end
    return nil, nil
end

-- Get club's primary job name for society deposits
local function GetClubSocietyName(clubId)
    local club = Clubs[clubId]
    if not club or not club.jobs then return nil end
    for _, j in ipairs(club.jobs) do
        if j.primary and type(j.name) == "string" and j.name ~= "" then
            return j.name
        end
    end
    return nil
end

lib.callback.register("pickle_clubs:payEntry", function(source, id, passType)
    local club = Clubs[id]
    if not club then return false,"Unknown club" end
    local current=GetClubPass(source,id)
    if current=="vip" or current and passType~="vip" then return true end
    local es = club and club.entry_settings
    local price
    if passType == "vip" then
        price = (es and es.vipPrice) or (Config.ClubEntry and Config.ClubEntry.vipPrice) or 5000
    else
        price = (es and es.entryPrice) or (Config.ClubEntry and Config.ClubEntry.defaultPrice) or 1000
    end
    local cash = (GetMoney and GetMoney(source, "money")) or 0
    if cash < price then
        return false, "Sorry, you don't have enough money for that."
    end
    if not ClubFinite(price,0,100000) or (price>0 and RemoveMoney(source,price,"money")~=true) then return false,"Payment failed" end
    -- Deposit to society
    local societyName = GetClubSocietyName(id)
    if societyName and AddSocietyMoney then
        AddSocietyMoney(societyName, price)
    end
    SetClubPass(source, id, passType == "vip" and "vip" or true)
    return true
end)

lib.callback.register("pickle_clubs:getEntryPrices", function(source, clubId)
    local club = Clubs[clubId]
    local es = club and club.entry_settings
    return {
        entry = (es and es.entryPrice) or (Config.ClubEntry and Config.ClubEntry.defaultPrice) or 1000,
        vip = (es and es.vipPrice) or (Config.ClubEntry and Config.ClubEntry.vipPrice) or 5000,
        vipEnabled = Config.ClubEntry and Config.ClubEntry.vipEnabled ~= false,
    }
end)

CreateThread(function()
    RegisterEntityType("club_entry", {
        label = "Club Entry",
        description = "This is the club entry entity type.",
        onStart = function(id, entityId)
            RegisterClubEntry(id, entityId)
        end,
        onRender = function(id, entityId, source)
            TriggerClientEvent("pickle_clubs:updateClubEntry", source, id, entityId, GetClubEntry(id, entityId))
        end,
        onUnrender = function(id, entityId, source)
            -- Rendering changes do not revoke purchased entry.
        end,
        onStop = function(id, entityId)
            UnregisterClubEntry(id, entityId)
        end,
    })
end)