-- Society entity: interaction point for club society (balance, deposit, withdraw)
-- Uses the bridge's GetSocietyBalance/AddSocietyMoney/RemoveSocietyMoney for any framework.

local SocietyInteractions = {} -- [clubId][entityId] -> interactionIndex
local SocietyPanelOpen = false
local SocietyPanelClubId = nil

function OpenSocietyPanel(clubId)
    if SocietyPanelOpen then
        CloseSocietyPanel()
        return
    end
    SocietyPanelOpen = true
    SocietyPanelClubId = clubId
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    -- Fetch balance from server
    lib.callback("pickle_clubs:getSocietyBalance", false, function(balance)
        if not SocietyPanelOpen then return end
        local club = Clubs[clubId]
        local clubName = club and club.label or ("Club #" .. clubId)
        SendNUIMessage({
            type = "openSocietyPanel",
            data = {
                clubId = clubId,
                clubName = clubName,
                balance = balance or 0,
                currency = Config.Currency and Config.Currency.currency or "USD",
                countryCode = Config.Currency and Config.Currency.countryCode or "en-US",
            },
        })
    end, clubId)
end

function CloseSocietyPanel()
    SocietyPanelOpen = false
    SocietyPanelClubId = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "closeSocietyPanel" })
end

RegisterNUICallback("closeSocietyPanel", function(_, cb)
    CloseSocietyPanel()
    cb("ok")
end)

RegisterNUICallback("societyDeposit", function(data, cb)
    if not SocietyPanelOpen or not SocietyPanelClubId then cb("ok"); return end
    local amount = tonumber(data and data.amount)
    if not amount or amount <= 0 then cb("ok"); return end
    lib.callback("pickle_clubs:societyDeposit", false, function(success, msg)
        if success then
            ShowNotification(_L("deposit_success") or "Deposited successfully")
            -- Refresh balance
            lib.callback("pickle_clubs:getSocietyBalance", false, function(balance)
                if SocietyPanelOpen then
                    SendNUIMessage({ type = "updateSocietyBalance", balance = balance or 0 })
                end
            end, SocietyPanelClubId)
        else
            ShowNotification(msg or "Deposit failed")
        end
    end, SocietyPanelClubId, amount)
    cb("ok")
end)

RegisterNUICallback("societyWithdraw", function(data, cb)
    if not SocietyPanelOpen or not SocietyPanelClubId then cb("ok"); return end
    local amount = tonumber(data and data.amount)
    if not amount or amount <= 0 then cb("ok"); return end
    lib.callback("pickle_clubs:societyWithdraw", false, function(success, msg)
        if success then
            ShowNotification(_L("withdraw_success") or "Withdrawn successfully")
            lib.callback("pickle_clubs:getSocietyBalance", false, function(balance)
                if SocietyPanelOpen then
                    SendNUIMessage({ type = "updateSocietyBalance", balance = balance or 0 })
                end
            end, SocietyPanelClubId)
        else
            ShowNotification(msg or "Withdraw failed")
        end
    end, SocietyPanelClubId, amount)
    cb("ok")
end)

RegisterNUICallback("getEntrySettings", function(data, cb)
    if not data or not data.clubId then cb({}); return end
    lib.callback("pickle_clubs:getEntrySettings", false, function(settings)
        cb(settings or {})
    end, tonumber(data.clubId))
end)

RegisterNUICallback("setEntrySettings", function(data, cb)
    if not data or not data.clubId or not data.settings then cb("ok"); return end
    lib.callback("pickle_clubs:setEntrySettings", false, function(success)
        if success then
            ShowNotification("Entry settings updated")
        else
            ShowNotification("Failed to update entry settings")
        end
    end, tonumber(data.clubId), data.settings)
    cb("ok")
end)

RegisterNUICallback("getEmployees", function(data, cb)
    if not data or not data.clubId then cb({}); return end
    lib.callback("pickle_clubs:getEmployees", false, function(employees)
        cb(employees or {})
    end, tonumber(data.clubId))
end)

RegisterNUICallback("getJobGrades", function(data, cb)
    if not data or not data.clubId then cb({}); return end
    lib.callback("pickle_clubs:getJobGrades", false, function(grades)
        cb(grades or {})
    end, tonumber(data.clubId))
end)

RegisterNUICallback("setEmployeeGrade", function(data, cb)
    if not data or not data.clubId then cb("ok"); return end
    lib.callback("pickle_clubs:setEmployeeGrade", false, function(success, msg)
        if success then
            ShowNotification("Grade updated")
        else
            ShowNotification(msg or "Failed to update grade")
        end
    end, tonumber(data.clubId), tonumber(data.targetSource), tonumber(data.grade))
    cb("ok")
end)

RegisterNUICallback("fireEmployee", function(data, cb)
    if not data or not data.clubId then cb("ok"); return end
    lib.callback("pickle_clubs:fireEmployee", false, function(success, msg)
        if success then
            ShowNotification("Employee fired")
        else
            ShowNotification(msg or "Failed to fire employee")
        end
    end, tonumber(data.clubId), tonumber(data.targetSource))
    cb("ok")
end)

RegisterNUICallback("hirePlayer", function(data, cb)
    if not data or not data.clubId then cb("ok"); return end
    lib.callback("pickle_clubs:hirePlayer", false, function(success, msg)
        if success then
            ShowNotification("Player hired!")
        else
            ShowNotification(msg or "Failed to hire player")
        end
    end, tonumber(data.clubId), tonumber(data.targetSource))
    cb("ok")
end)

RegisterNUICallback("getNearbyPlayers", function(data, cb)
    lib.callback("pickle_clubs:getNearbyPlayers", false, function(players)
        cb(players or {})
    end)
end)

local function GetPrimaryJobName(club)
    if not club or not club.jobs then return nil end
    for i = 1, #club.jobs do
        if club.jobs[i].primary and type(club.jobs[i].name) == "string" and club.jobs[i].name ~= "" then
            return club.jobs[i].name
        end
    end
    return nil
end

local function RenderSociety(clubId, entityId)
    if not SocietyInteractions[clubId] then SocietyInteractions[clubId] = {} end
    if SocietyInteractions[clubId][entityId] then
        DeleteInteraction(SocietyInteractions[clubId][entityId])
        SocietyInteractions[clubId][entityId] = nil
    end

    local club = Clubs[clubId]
    if not club then return end
    local entity = club.entities and club.entities[entityId]
    if not entity or entity.type ~= "society" or not entity.society then return end

    local coords = entity.society.coords
    if type(coords) == "table" then
        coords = vector3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
    end
    local interactCoords = coords
    local heading = entity.society.heading or 0.0

    local interactionIndex = CreateInteraction({
        label = "Management",
        icon = Config.TargetIcons.society,
        coords = interactCoords,
        heading = heading,
    }, function()
        lib.callback("pickle_clubs:canManageClub", false, function(canManage)
            if canManage then
                local options = {
                    {
                        title = "Manage",
                        description = "Open this entity's management menu",
                        onSelect = function()
                            OpenClubManagementNuiForEntity(clubId, entityId)
                        end,
                    },
                    {
                        title = _L("society_open") or "Society Management",
                        description = "Open the society banking panel",
                        onSelect = function()
                            OpenSocietyPanel(clubId)
                        end,
                    },
                }
                local contextId = ("society_interact_%s_%s"):format(clubId, entityId)
                lib.registerContext({
                    id = contextId,
                    title = "Management",
                    options = options,
                })
                lib.showContext(contextId)
            else
                OpenSocietyPanel(clubId)
            end
        end, clubId)
    end)
    SocietyInteractions[clubId][entityId] = interactionIndex
end

local function UnrenderSociety(clubId, entityId)
    if SocietyInteractions[clubId] and SocietyInteractions[clubId][entityId] then
        DeleteInteraction(SocietyInteractions[clubId][entityId])
        SocietyInteractions[clubId][entityId] = nil
    end
end

CreateThread(function()
    RegisterEntityType("society", {
        label = "Society",
        description = "Society deposit/withdraw interaction point.",
        onRender = function(id, entityId)
            RenderSociety(id, entityId)
        end,
        onUnrender = function(id, entityId)
            UnrenderSociety(id, entityId)
        end,
    })
end)
