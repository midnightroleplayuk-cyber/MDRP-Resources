local Bouncers = {}
local BouncerInteractions = {} -- [clubId][entityId] -> interactionIndex
local ClosestBouncer = nil
local ThrowOutScenes = {}
local PLAYING_BOUNCER_SCENE = false

-- Entity JSON may store coords as plain tables; normalize for vector math.
local function ToVector3(value, fallback)
    if type(value) == "vector3" then return value end
    if type(value) == "table" then
        local x = value.x or value[1]
        local y = value.y or value[2]
        local z = value.z or value[3]
        if x and y and z then
            return vector3(x, y, z)
        end
    end
    return fallback
end

function ThrowOutPlayerScene(clubId, entityId, id)
    if ThrowOutScenes[id] then 
        for i=1, #ThrowOutScenes[id].entities do
            DeleteEntity(ThrowOutScenes[id].entities[i])
        end
        ThrowOutScenes[id] = nil
    end
    local clubEntry = GetClubEntry(clubId, entityId)
    if not clubEntry then return end
    ThrowOutScenes[id] = {
        clubId = clubId,
        entityId = entityId,
        entities = {},
    }
    local heading = clubEntry.eject.heading
    local baseY = 0.5
    local ped = CreateClubNPC("bouncer_1", clubEntry.eject.coords + (clubEntry.eject.forward * baseY) + (clubEntry.eject.right * -0.3), heading + 290.0)
    FreezeEntityPosition(ped, false)
    table.insert(ThrowOutScenes[id].entities, ped)
    PlayAnim(ThrowOutScenes[id].entities[1], "mini@strip_club@throwout_d@", "throwout_d_bouncer_a", 8.0, -1.0, -1, 1, 0, true, true, true)
    if id == GetPlayerServerId(PlayerId()) then
        PLAYING_BOUNCER_SCENE = true
        local camCoords = clubEntry.eject.coords + (clubEntry.eject.forward * 6.0)
        CreateScriptedCamera()
        SetCamParams(CurrentCamera, camCoords.x, camCoords.y, camCoords.z + 0.5,
            0.0, 0.0, heading + 180.0, 45.0, 
            0, 0, 0, 2
        )
        SetEntityNoCollisionEntity(PlayerPedId(), ped)
        SetEntityCoords(PlayerPedId(), clubEntry.eject.coords + (clubEntry.eject.right * 0.1))
        SetEntityRotation(PlayerPedId(), 0.0, 0.0, heading - 12.0, 2, true)
        PlayAnim(PlayerPedId(), "mini@strip_club@throwout_d@", "throwout_d_victim", 8.0, -1.0, -1, 0, 0, true, true, true)
        SetTimeout(4000, function()
            ExitScriptedCamera()
        end)
        SetTimeout(6000, function()
            ClearPedTasks(PlayerPedId())
            PLAYING_BOUNCER_SCENE = false
        end)
    end
    SetTimeout(4000, function()
        local opacity = 255 
        while opacity > 0 do
            opacity = opacity - 5
            if opacity <= 0 then
                opacity = 0
            end
            SetEntityAlpha(ThrowOutScenes[id].entities[1], opacity, false)
            Wait(0)
        end
        DeleteEntity(ThrowOutScenes[id].entities[1])
        ThrowOutScenes[id] = nil
    end)
end

function RenderBouncer(id, entityId)
    if not Bouncers[id] then Bouncers[id] = {} end
    if not BouncerInteractions[id] then BouncerInteractions[id] = {} end
    
    -- Cleanup existing interaction if it exists
    if BouncerInteractions[id][entityId] then
        DeleteInteraction(BouncerInteractions[id][entityId])
        BouncerInteractions[id][entityId] = nil
    end
    
    local club = Clubs[id]
    if not club then return end
    local entity = club.entities[entityId]
    if not entity then return end
    local fallbackCoords = ToVector3(club.coords, vector3(0.0, 0.0, 0.0))
    local bouncerCoords = ToVector3(entity.bouncer.coords, fallbackCoords)
    local entry = {
        bouncer = {
            ped = nil,
            coords = bouncerCoords,
            heading = entity.bouncer.heading,
        },
    }
    -- TODO entry.doors
    -- TODO entry.bouncer
    -- TODO entry.line
    local interactionIndex = CreateInteraction({
        label = "Bouncer",
        icon = Config.TargetIcons.bouncer,
        coords = bouncerCoords + vector3(0.0, 0.0, 1.0),
        heading = entity.bouncer.heading,
    }, function()
        lib.callback("pickle_clubs:canManageClub", false, function(canManage)
            if canManage then
                local contextId = ("bouncer_interact_%s_%s"):format(id, entityId)
                lib.registerContext({
                    id = contextId,
                    title = "Bouncer Interaction",
                    options = {
                        {
                            title = "Manage",
                            description = "Open this entity's management menu",
                            onSelect = function()
                                OpenClubManagementNuiForEntity(id, entityId)
                            end,
                        },
                    },
                })
                lib.showContext(contextId)
            end
        end, id)
    end)
    BouncerInteractions[id][entityId] = interactionIndex
    entry.bouncer.ped = CreateClubNPC(entity.bouncer.ped, bouncerCoords, entity.bouncer.heading)
    Bouncers[id][entityId] = entry
end

function DoesBouncerExist(id, entityId)
    return Bouncers[id] and Bouncers[id][entityId]
end

function UnrenderBouncer(id, entityId)
    if not DoesBouncerExist(id, entityId) then return end
    local entry = Bouncers[id][entityId]
    if DoesEntityExist(entry.bouncer.ped) then
        DeleteEntity(entry.bouncer.ped)
    end
    if BouncerInteractions[id] and BouncerInteractions[id][entityId] then
        DeleteInteraction(BouncerInteractions[id][entityId])
        BouncerInteractions[id][entityId] = nil
    end
    Bouncers[id][entityId] = nil
end

function GetBouncer(id, entityId)
    return Bouncers[id] and Bouncers[id][entityId]
end

local function IsBouncerVipModeActive(bouncer)
    if not bouncer or type(bouncer) ~= "table" then return false end
    local v = bouncer.vipMode
    return v == true or v == 1 or v == "1" or v == "true"
end

-- Patrol rule for this bouncer entity: VIP mode only allows VIP pass; otherwise any club pass (standard or VIP).
function PlayerPassesBouncerPatrol(clubId, entityId)
    local club = Clubs[clubId]
    if not club or not club.entities or not club.entities[entityId] then return true end
    local ent = club.entities[entityId]
    if ent.type ~= "bouncer" or not ent.bouncer then return true end
    if IsBouncerVipModeActive(ent.bouncer) then
        return HasVipClubPass(clubId)
    end
    return CanEnterClub(clubId) and true or false
end

-- Bypass patrol (police, club staff, etc.). VIP mode can optionally require staff to have a VIP pass too.
local function BouncerPatrolAllowsBypass(clubId, entityId)
    if Config.BypassJobs and next(Config.BypassJobs) and CanAccessGroup(Config.BypassJobs) then
        return true
    end
    local club = Clubs[clubId]
    local ent = club and club.entities and club.entities[entityId]
    if ent and ent.type == "bouncer" and ent.bouncer and IsBouncerVipModeActive(ent.bouncer) and Config.BouncerVipModeIgnoreJobAccess then
        return false
    end
    return PlayerHasClubJobAccess(clubId)
end

-- Check if the player's job matches any of the club's assigned jobs or bypass jobs
function PlayerHasClubJobAccess(clubId)
    -- Check bypass jobs first (e.g. police can enter any club)
    if Config.BypassJobs and next(Config.BypassJobs) then
        if CanAccessGroup(Config.BypassJobs) then
            return true
        end
    end
    -- Check club-specific jobs
    local club = Clubs[clubId]
    if not club or not club.jobs then return false end
    local jobAccess = {}
    for _, j in ipairs(club.jobs) do
        if j.name and j.name ~= "" then
            jobAccess[j.name] = 0
        end
    end
    if not next(jobAccess) then return false end
    return CanAccessGroup(jobAccess)
end

function BouncerThread(id, entityId)
    local progressPerTick = 1
    local data = GetBouncer(id, entityId)
    if PlayerPassesBouncerPatrol(id, entityId) or PLAYING_BOUNCER_SCENE or BouncerPatrolAllowsBypass(id, entityId) or IsBouncerImmune(GetPlayerServerId(PlayerId())) then return end
    if not data then return end
    if not ClosestBouncer or ClosestBouncer.clubId ~= id or ClosestBouncer.entityId ~= entityId then
        ClosestBouncer = {
            visible = false,
            clubId = id,
            entityId = entityId,
            progress = 0,
            ticks = 20
        }
    end
    if ClosestBouncer.ticks <= 0 then
        ClosestBouncer.visible = HasEntityClearLosToEntityInFront(data.bouncer.ped, PlayerPedId())
        ClosestBouncer.ticks = 20
    end
    ClosestBouncer.ticks = ClosestBouncer.ticks - 1
    if ClosestBouncer.visible then
        ClosestBouncer.progress = ClosestBouncer.progress + progressPerTick
    else
        ClosestBouncer.progress = ClosestBouncer.progress - progressPerTick
    end
    if ClosestBouncer.progress >= 100 and not ClosestBouncer.detected then  
        ClosestBouncer.progress = 100
        ClosestBouncer.detected = true
        SetTimeout(1000, function()
            ClosestBouncer = nil
            TriggerServerEvent("pickle_clubs:throwOutPlayer", id)
        end)
    end
    if ClosestBouncer.progress <= 0 then
        ClosestBouncer.progress = 0
    end
    local progress = ClosestBouncer.progress or 0
    if progress > 0 or ClosestBouncer.detected then
        local onScreen, screenX, screenY = GetHudScreenPositionFromWorldPosition(data.bouncer.coords.x, data.bouncer.coords.y, data.bouncer.coords.z + 2.25)
        local icon_scale = 1.5
        local text_scale = 1.0
        local r, g, b = 255, 255, 255
        -- Progress bar color: white to yellow to red depending on progress
        if ClosestBouncer.detected or progress >= 100 then
            r = 255
            g = 0
            b = 0
        elseif progress < 50 then
            -- White to Yellow
            local t = progress / 50
            r = math.floor(255)
            g = math.floor(255 * t + 255 * (1 - t)) -- 255
            b = math.floor(255 * (1 - t))
        else
            -- Yellow to Red
            local t = (progress - 50) / 50
            r = 255
            g = math.floor(255 * (1 - t))
            b = 0
        end
        -- Icon
        -- RequestStreamedTextureDict("assassinations", false)
        -- DrawSprite("assassinations", "targetquestion", screenX, screenY - 0.015, 0.015 * icon_scale, 0.025 * icon_scale, 0.0, r, g, b, 255)
        -- Text
        SetTextFont(0)
        SetTextOutline()
        SetTextColour(r, g, b, 255)
        SetTextCentre(true)
        SetTextScale(0.0, text_scale)
        SetTextEntry("STRING")
        AddTextComponentString((progress >= 100 or ClosestBouncer.detected) and "!" or "?")
        DrawText(screenX, screenY)
    end
end

RegisterNetEvent("pickle_clubs:throwOutPlayer", function(clubId, entityId, serverId)
    ThrowOutPlayerScene(clubId, entityId, serverId)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for k,v in pairs(ThrowOutScenes) do
            for i=1, #v.entities do
                DeleteEntity(v.entities[i])
            end
        end
        ThrowOutScenes = {}

    end
end)

CreateThread(function()
    -- DEBUG_RAYCAST_DOOR()
    RegisterEntityType("bouncer", {
        label = "Bouncer",
        description = "This is the bouncer entity type.",
        onRender = function(id, entityId)
            RenderBouncer(id, entityId)
        end,
        onUnrender = function(id, entityId)
            if CurrentClub and CurrentClub == id then
                CurrentClub = nil
            end
            UnrenderBouncer(id, entityId)
        end,
    })
    while true do
        local wait = 1500
        local pcoords = GetEntityCoords(PlayerPedId())
        local closest = nil
        for k,v in pairs(Bouncers) do
            for entityId, entity in pairs(v) do
                local dist = #(pcoords - entity.bouncer.coords)
                if not closest or dist < closest.dist then
                    closest = {
                        dist = dist,
                        clubId = k,
                        entityId = entityId,
                    }
                end
            end
        end
        if closest then
            wait = 0
            BouncerThread(closest.clubId, closest.entityId)
        else
            ClosestBouncer = nil
        end
        Wait(wait)
    end
end)

-- =====================
-- BOUNCER ACTIONS (F6)
-- =====================

local EscortedPlayer = nil -- { serverId, ped }
local EscortImmunePlayers = {} -- serverId -> true (immune from NPC bouncer detection)
local SearchPanelOpen = false

-- Check if a player is immune from NPC bouncer detection
function IsBouncerImmune(serverId)
    return EscortImmunePlayers[serverId] == true
end

-- Get the closest player within range
local function GetClosestPlayer(range)
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local closestPlayer = nil
    local closestDist = range or 3.0
    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId ~= PlayerId() then
            local targetPed = GetPlayerPed(playerId)
            if targetPed and DoesEntityExist(targetPed) then
                local targetCoords = GetEntityCoords(targetPed)
                local dist = #(myCoords - targetCoords)
                if dist < closestDist then
                    closestDist = dist
                    closestPlayer = { playerId = playerId, serverId = GetPlayerServerId(playerId), ped = targetPed }
                end
            end
        end
    end
    return closestPlayer
end

-- Check if the local player is a bouncer at any club
local function IsPlayerBouncer()
    for clubId, _ in pairs(Clubs) do
        if PlayerHasClubJobAccess(clubId) then
            return true, clubId
        end
    end
    return false
end

-- ===== ESCORT SYSTEM =====

-- True if the local player is within Config.RenderDistance of any bouncer entity
-- belonging to a club whose job they have access to.
local function IsPlayerInBouncerZone()
    local pcoords = GetEntityCoords(PlayerPedId())
    for clubId, club in pairs(Clubs) do
        if club and club.entities and PlayerHasClubJobAccess(clubId) then
            for _, entity in pairs(club.entities) do
                if entity.type == "bouncer" and entity.bouncer and entity.bouncer.coords then
                    if #(pcoords - ToVector3(entity.bouncer.coords, vector3(0.0, 0.0, 0.0))) < Config.RenderDistance then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function StartEscort(target)
    if EscortedPlayer then return end
    if not (Config.Bouncer and Config.Bouncer.enableEscorting) then return end
    if not IsPlayerInBouncerZone() then
        ShowNotification(_L("bouncer_escort_too_far"))
        return
    end
    EscortedPlayer = target
    EscortImmunePlayers[target.serverId] = true
    local myServerId = GetPlayerServerId(PlayerId())
    TriggerServerEvent("pickle_clubs:startEscort", target.serverId, myServerId)
    ShowNotification(_L("bouncer_escort_started"))

    CreateThread(function()
        while EscortedPlayer and EscortedPlayer.serverId == target.serverId do
            if IsControlJustPressed(0, 38) then -- E key
                local myPed = PlayerPedId()
                local animDict = "melee@thrown@streamed_core"
                RequestAnimDict(animDict)
                while not HasAnimDictLoaded(animDict) do Wait(0) end
                TaskPlayAnim(myPed, animDict, "plyr_takedown_front", -8.0, 8.0, -1, 49, 0, false, false, false)
                Wait(200)
                SetTimeout(400, function()
                    ClearPedTasks(myPed)
                end)
                local forward = GetEntityForwardVector(myPed)
                TriggerServerEvent("pickle_clubs:flingEscort", target.serverId, forward.x, forward.y)
                TriggerServerEvent("pickle_clubs:revokeAllPasses", target.serverId)
                local clearedId = target.serverId
                SetTimeout(3000, function()
                    EscortImmunePlayers[clearedId] = nil
                end)
                EscortedPlayer = nil
                ShowNotification(_L("bouncer_escort_thrown"))
                return
            end
            Wait(0)
        end
    end)
end

local function StopEscort()
    if not EscortedPlayer then return end
    TriggerServerEvent("pickle_clubs:stopEscort", EscortedPlayer.serverId)
    local clearedId = EscortedPlayer.serverId
    SetTimeout(3000, function()
        EscortImmunePlayers[clearedId] = nil
    end)
    EscortedPlayer = nil
end

-- Victim-side: attach self to bouncer with animation
local BeingEscorted = false

RegisterNetEvent("pickle_clubs:escortAttach", function(bouncerServerId)
    local myPed = PlayerPedId()
    local bouncerPed = GetPlayerPed(GetPlayerFromServerId(bouncerServerId))
    if not bouncerPed or not DoesEntityExist(bouncerPed) then return end
    ClearPedTasksImmediately(myPed)
    AttachEntityToEntity(myPed, bouncerPed, GetPedBoneIndex(bouncerPed, 57005), 0.25, 0.0, 0.0, 0.0, -90.0, -45.0, false, false, false, true, 2, true)
    local animDict = "nm"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(0) end
    TaskPlayAnim(myPed, animDict, "firemans_carry", 8.0, -8.0, -1, 33, 0, false, false, false)
    BeingEscorted = true
    CreateThread(function()
        while BeingEscorted do
            local ped = PlayerPedId()
            if not IsEntityPlayingAnim(ped, animDict, "firemans_carry", 3) then
                TaskPlayAnim(ped, animDict, "firemans_carry", 8.0, -8.0, -1, 33, 0, false, false, false)
            end
            Wait(200)
        end
    end)
end)

-- Victim-side: detach and fling (same physics as club_entry door rejection)
RegisterNetEvent("pickle_clubs:escortFling", function(forwardX, forwardY)
    BeingEscorted = false
    local myPed = PlayerPedId()
    ClearPedTasks(myPed)
    DetachEntity(myPed, false, false)
    local force = 15.0
    SetEntityVelocity(myPed, forwardX * force, forwardY * force, 3.0)
    SetTimeout(100, function()
        SetPedToRagdoll(myPed, 3000, 3000, 0, false, false, false)
    end)
end)

-- Victim-side: detach (release without fling)
RegisterNetEvent("pickle_clubs:escortDetach", function()
    BeingEscorted = false
    local myPed = PlayerPedId()
    ClearPedTasks(myPed)
    DetachEntity(myPed, true, true)
end)

-- ===== SEARCH SYSTEM =====

local function SearchPlayer(target)
    if SearchPanelOpen then return end
    SearchPanelOpen = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    lib.callback("pickle_clubs:getPlayerInventory", false, function(items, charName)
        if not SearchPanelOpen then return end
        SendNUIMessage({
            type = "openSearchPanel",
            data = {
                playerName = charName or ("Player " .. target.serverId),
                items = items or {},
                imageDirectory = Config.ImageDirectory or "nui://ox_inventory/web/images/",
                imageExtension = Config.ImageExtension or "png",
            },
        })
    end, target.serverId)
end

function CloseSearchPanel()
    SearchPanelOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "closeSearchPanel" })
end

RegisterNUICallback("closeSearchPanel", function(_, cb)
    CloseSearchPanel()
    cb("ok")
end)

-- ===== F6 MENU =====

local function OpenBouncerActionsMenu()
    local isBouncer, clubId = IsPlayerBouncer()
    if not isBouncer then return end

    local options = {}

    if Config.Bouncer and Config.Bouncer.enableEscorting then
        if EscortedPlayer then
            table.insert(options, {
                title = _L("bouncer_release"),
                description = _L("bouncer_release_desc"),
                icon = Config.TargetIcons.release,
                onSelect = function()
                    StopEscort()
                    ShowNotification(_L("bouncer_escort_released"))
                end,
            })
        else
            table.insert(options, {
                title = _L("bouncer_escort"),
                description = _L("bouncer_escort_desc"),
                icon = Config.TargetIcons.escort,
                onSelect = function()
                    local target = GetClosestPlayer(3.0)
                    if not target then
                        ShowNotification(_L("bouncer_no_player"))
                        return
                    end
                    StartEscort(target)
                end,
            })
        end
    end

    table.insert(options, {
        title = _L("bouncer_search"),
        description = _L("bouncer_search_desc"),
        icon = Config.TargetIcons.search,
        onSelect = function()
            local target = GetClosestPlayer(3.0)
            if not target then
                ShowNotification(_L("bouncer_no_player"))
                return
            end
            SearchPlayer(target)
        end,
    })

    lib.registerContext({
        id = "bouncer_actions",
        title = _L("bouncer_actions_title"),
        options = options,
    })
    lib.showContext("bouncer_actions")
end

RegisterCommand("+bouncer_actions", function()
    OpenBouncerActionsMenu()
end, false)
RegisterKeyMapping("+bouncer_actions", "Bouncer Actions", "keyboard", "F6")

-- Target system: add bouncer actions to player targets
if Config.UseTarget and AddTargetGlobalPlayer then
    AddTargetGlobalPlayer({
        {
            name = "bouncer_escort",
            label = _L("bouncer_escort"),
            icon = Config.TargetIcons.escort,
            interactCheck = function(targetServerId)
                if not (Config.Bouncer and Config.Bouncer.enableEscorting) then return false end
                return IsPlayerBouncer() and not EscortedPlayer and IsPlayerInBouncerZone()
            end,
            onSelected = function(targetServerId)
                for _, playerId in ipairs(GetActivePlayers()) do
                    if GetPlayerServerId(playerId) == targetServerId then
                        StartEscort({ playerId = playerId, serverId = targetServerId, ped = GetPlayerPed(playerId) })
                        return
                    end
                end
            end,
        },
        {
            name = "bouncer_search",
            label = _L("bouncer_search"),
            icon = Config.TargetIcons.search,
            interactCheck = function(targetServerId)
                return IsPlayerBouncer()
            end,
            onSelected = function(targetServerId)
                for _, playerId in ipairs(GetActivePlayers()) do
                    if GetPlayerServerId(playerId) == targetServerId then
                        SearchPlayer({ playerId = playerId, serverId = targetServerId, ped = GetPlayerPed(playerId) })
                        return
                    end
                end
            end,
        },
    })
end
AddEventHandler('onResourceStop',function(name)
    if name~=GetCurrentResourceName() then return end
    BeingEscorted=false
    local ped=PlayerPedId()
    DetachEntity(ped,true,true)
    ClearPedTasks(ped)
end)
