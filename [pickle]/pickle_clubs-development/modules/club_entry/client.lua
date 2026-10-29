local ClubEntries = {}
local ClubEntryInteractions = {} -- [clubId][entityId] -> interactionIndex
local CurrentLine = nil
local IsYeeted = false
local ClubPasses = {}
local CurrentClub = nil

function DEBUG_RAYCAST_DOOR()
    CreateThread(function()
        while true do
        -- Draw a debug raycast to the entity the camera is pointing at, draw a line and display the model above it
            local camCoords = GetGameplayCamCoord()
            local hit, hitCoords, entityHit = GetDirectionCoords(nil, nil, 16)
            if hit and entityHit and DoesEntityExist(entityHit) then
                local model = GetEntityModel(entityHit)
                -- Draw line from camera to hit coords
                DrawLine(camCoords.x, camCoords.y, camCoords.z, hitCoords.x, hitCoords.y, hitCoords.z, 255, 0, 0, 255)
                -- Get position above entity for text
                local entCoords = GetEntityCoords(entityHit)
                local success, screenX, screenY = World3dToScreen2d(entCoords.x, entCoords.y, entCoords.z + 1.0)
                if success then
                    local modelStr = tostring(model) .. " ("..GetEntityType(entityHit)..")"
                    SetTextFont(0)
                    SetTextScale(0.35, 0.35)
                    SetTextColour(255, 0, 0, 255)
                    SetTextOutline()
                    SetTextEntry("STRING")
                    AddTextComponentString("Model: " .. tostring(model))
                    DrawText(screenX, screenY)
                end
            end

            Wait(0) -- short interval for good rendering
        end
    end)
end

function RenderClubEntry(id, entityId)
    if not ClubEntries[id] then ClubEntries[id] = {} end
    if not ClubEntryInteractions[id] then ClubEntryInteractions[id] = {} end
    
    -- Cleanup existing interaction if it exists
    if ClubEntryInteractions[id][entityId] then
        DeleteInteraction(ClubEntryInteractions[id][entityId])
        ClubEntryInteractions[id][entityId] = nil
    end
    
    local club = Clubs[id]
    if not club then return end
    local entity = club.entities[entityId]
    if not entity then return end
    local entry = {
        bouncer = {},
        eject = {},
        players = {},
    }
    -- TODO entry.doors
    -- TODO entry.bouncer
    -- TODO entry.eject
    local interactionIndex = CreateInteraction({
        label = _L("enter_line"),
        icon = Config.TargetIcons.club_entry,
        coords = entity.bouncer.coords + vector3(0.0, 0.0, 1.0),
        heading = entity.bouncer.heading,
    }, function()
        lib.callback("pickle_clubs:canManageClub", false, function(canManage)
            if canManage then
                local contextId = ("club_entry_interact_%s_%s"):format(id, entityId)
                lib.registerContext({
                    id = contextId,
                    title = "Club Entry Interaction",
                    options = {
                        {
                            title = "Interact",
                            description = "Use this entry interaction",
                            onSelect = function()
                                PromptCEL(id, entityId)
                            end,
                        },
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
            else
                PromptCEL(id, entityId)
            end
        end, id)
    end)
    ClubEntryInteractions[id][entityId] = interactionIndex
    entry.bouncer.ped = CreateClubNPC(entity.bouncer.ped, entity.bouncer.coords, entity.bouncer.heading)
    entry.bouncer.coords = entity.bouncer.coords
    entry.bouncer.heading = entity.bouncer.heading
    local forwardVector, rightVector, upVector, position = GetEntityMatrix(entry.bouncer.ped)
    entry.bouncer.forward = forwardVector
    entry.bouncer.right = rightVector
    entry.eject.coords = entity.eject.coords
    entry.eject.heading = entity.eject.heading
    local temp = CreateTennisBall(entity.eject.coords.x, entity.eject.coords.y, entity.eject.coords.z)
    SetEntityRotation(temp, 0.0, 0.0, entity.eject.heading, 2, true)
    local forwardVector, rightVector, upVector, position = GetEntityMatrix(temp)
    DeleteEntity(temp)
    entry.eject.forward = forwardVector
    entry.eject.right = rightVector
    ClubEntries[id][entityId] = entry
end

function DoesClubEntryExist(id, entityId)
    return ClubEntries[id] and ClubEntries[id][entityId]
end

function UnrenderClubEntry(id, entityId)
    if not DoesClubEntryExist(id, entityId) then return end
    local entry = ClubEntries[id][entityId]
    if DoesEntityExist(entry.bouncer.ped) then
        DeleteEntity(entry.bouncer.ped)
    end
    if ClubEntryInteractions[id] and ClubEntryInteractions[id][entityId] then
        DeleteInteraction(ClubEntryInteractions[id][entityId])
        ClubEntryInteractions[id][entityId] = nil
    end
    ClubEntries[id][entityId] = nil
end

function GetClubEntry(id, entityId)
    return ClubEntries[id] and ClubEntries[id][entityId]
end

function ClubEntryThread(id, entityId)
    local entry = GetClubEntry(id, entityId)
    if not entry then return end
    if not CanEnterClub(id) and not IsYeeted and not PlayerHasClubJobAccess(id) then
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        local doorCoords = entry.bouncer.coords + vector3(0.0, 0.0, 1.0)
        local playerOffset = GetOffsetFromEntityGivenWorldCoords(entry.bouncer.ped, pcoords.x, pcoords.y, pcoords.z)
        local dist = #(pcoords - (doorCoords + vector3(0.0, 0.0, 1.0)))
        if math.abs(playerOffset.x) < 2.0 and playerOffset.y < -0.25 and playerOffset.y > -2.0 then
            ShowNotification(_L("club_entry_no_pass"))
            IsYeeted = true
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                DeleteEntity(vehicle)
            end
            -- Use eject position to determine throw direction
            local ejectCoords = entry.eject.coords
            local direction = ejectCoords - pcoords
            local directionNormalized = direction / #direction
            local force = 15
            SetEntityVelocity(ped, directionNormalized.x * force, directionNormalized.y * force, 3.0)
            SetTimeout(100, function()
                SetPedToRagdoll(ped, 3000, 3000, 0, false, false, false)
            end)
            SetTimeout(1000, function()
                IsYeeted = false
            end)
        end
        
        -- DrawMarker(1, doorCoords.x, doorCoords.y, doorCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 255, false, true)
    end
end

function RefreshCEL(id, entityId)
    local entry = GetClubEntry(id, entityId)
    if not entry then return end
    local inLine = false
    local playerCount = 0 
    local source = GetPlayerServerId(PlayerId())
    for i=1, #entry.players do
        local player = entry.players[i]
        if player.source ~= source then
            playerCount = playerCount + 1
        else 
            inLine = true
            if CurrentLine then 
                CurrentLine.position = playerCount + 1
            end
            break
        end
    end
    if not inLine then return end
    -- Line positioning logic removed - eject is only for throw-out position
end

local ClubEntryDialogOpen = false
local ClubEntryDialogClubId = nil

function PromptCEL(id, entityId)
    local entry = GetClubEntry(id, entityId)
    if not entry then return end
    if ClubEntryDialogOpen then return end

    local club = Clubs[id]
    local clubName = club and club.label or ("Club #" .. id)

    -- Camera transition to face the bouncer
    local ped = entry.bouncer.ped
    local pedCoords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    local heading = GetEntityHeading(ped)
    local camCoords = pedCoords + (forward * 0.5)
    CreateScriptedCamera()
    SetCamParams(CurrentCamera, camCoords.x, camCoords.y, camCoords.z + 0.5,
        0.0, 0.0, heading + 180.0, 90.0,
        2000, 0, 0, 2
    )

    lib.callback("pickle_clubs:getEntryPrices", false, function(prices)
        if not prices then
            ExitScriptedCamera()
            return
        end
        ClubEntryDialogOpen = true
        ClubEntryDialogClubId = id
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
        SendNUIMessage({
            type = "openClubEntryDialog",
            data = {
                clubId = id,
                clubName = clubName,
                entryPrice = prices.entry,
                vipPrice = prices.vip,
                vipEnabled = prices.vipEnabled,
                hasPass = ClubPasses[id] == true or ClubPasses[id] == "vip",
                hasVip = ClubPasses[id] == "vip",
                speech = _L("club_entry_bouncer_speech"),
                currency = Config.Currency and Config.Currency.currency or "USD",
                countryCode = Config.Currency and Config.Currency.countryCode or "en-US",
            },
        })
    end, id)
end

function CloseClubEntryDialog()
    ClubEntryDialogOpen = false
    ClubEntryDialogClubId = nil
    SetNuiFocus(false, false)
    ExitScriptedCamera()
    SendNUIMessage({ type = "closeClubEntryDialog" })
end

RegisterNUICallback("closeClubEntryDialog", function(_, cb)
    CloseClubEntryDialog()
    cb("ok")
end)

RegisterNUICallback("payClubEntry", function(data, cb)
    if not data or not data.clubId then cb({ success = false }); return end
    local passType = data.passType == "vip" and "vip" or "standard"
    lib.callback("pickle_clubs:payEntry", false, function(success, msg)
        if success then
            cb({ success = true })
            SetTimeout(1500, function()
                CloseClubEntryDialog()
            end)
        else
            cb({ success = false, message = msg or "Not enough money" })
        end
    end, tonumber(data.clubId), passType)
end)

function CanEnterClub(id)
    return ClubPasses[id]
end

-- ClubPasses is local to this file; bouncer module uses this for VIP patrol mode.
function HasVipClubPass(id)
    return ClubPasses[id] == "vip"
end

RegisterNetEvent("pickle_clubs:updateClubEntry", function(id, entityId, entry)
    if not entry then return end
    local localEntry = GetClubEntry(id, entityId)
    if not localEntry then return end
    localEntry.players = entry.players
end)

RegisterNetEvent("pickle_clubs:promptCEL", function(id, entityId)
    PromptCEL(id, entityId)
end)

RegisterNetEvent("pickle_clubs:updateClubPass", function(id, pass)
    ClubPasses[id] = pass
end)

CreateThread(function()
    -- DEBUG_RAYCAST_DOOR()
    RegisterEntityType("club_entry", {
        label = "Club Entry",
        description = "This is the club entry entity type.",
        onRender = function(id, entityId)
            RenderClubEntry(id, entityId)
        end,
        onUnrender = function(id, entityId)
            if CurrentClub and CurrentClub == id then
                CurrentClub = nil
            end
            UnrenderClubEntry(id, entityId)
        end,
    })
    while true do
        local wait = 1500
        local pcoords = GetEntityCoords(PlayerPedId())
        local closest = nil
        for k,v in pairs(ClubEntries) do
            for entityId, entity in pairs(v) do
                local dist = #(pcoords - entity.bouncer.coords)
                if not closest or dist < closest.dist then
                    closest = {
                        clubId = k,
                        entityId = entityId,
                        dist = dist,
                    }
                end
            end
        end
        if closest then
            wait = 0
            ClubEntryThread(closest.clubId, closest.entityId)
        end
        Wait(wait)
    end
end)