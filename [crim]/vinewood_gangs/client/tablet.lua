local isOpen = false
local mode -- 'tablet' | 'admin'
local tabletProp
local ANIM_DICT = 'amb@code_human_in_bus_passenger_idles@female@tablet@base'
local PROP = GetHashKey('prop_cs_tablet')

-- Only these server callbacks can be reached from the NUI
local ALLOWED = {
    getOverview = true, getMembers = true, getTerritory = true, getTreasury = true, getNearby = true, getTags = true,
    createGang = true, invite = true, kick = true, setGrade = true, transfer = true, editRank = true,
    updateDetails = true, leave = true, disband = true, deposit = true, withdraw = true,
    submitDesign = true, deleteDesign = true, removeOwnTag = true,
    setLogo = true, getContracts = true, acceptContract = true, abandonContract = true,
    getRackets = true, dropRacket = true,
    getSafehouses = true, buySafehouse = true, sellSafehouse = true, upgradeSafehouse = true,
    getEnterprises = true, setupEnterprise = true, upgradeEnterprise = true, setStaff = true, setDistribution = true,
    sellWholesale = true, closeEnterprise = true, orderSupplies = true, startSupplyRun = true, bagUpStock = true,
    getLeaks = true, investigateLeak = true,
    getAuctions = true, auctionBid = true, auctionBuyNow = true,
    getShop = true, shopBuy = true,
    getLaundering = true, launder = true,
    getDiplomacy = true, proposeDeal = true, respondDeal = true, withdrawDeal = true, breakDeal = true, declareRelation = true,
}

local ADMIN_ALLOWED = {
    listGangs = true, gangDetail = true, createGang = true, disband = true, addMember = true, removeMember = true,
    setGrade = true, zones = true, addInfluence = true, tick = true, pendingDesigns = true, reviewDesign = true,
    listTags = true, removeTag = true, gotoTag = true, onlinePlayers = true,
    pendingLogos = true, reviewLogo = true, deleteZone = true, rackets = true, releaseRacket = true,
    safehouses = true, evictSafehouse = true, deleteSafehouse = true, gotoSafehouse = true, safehouseShells = true,
    enterprises = true, closeEnterprise = true, agreements = true, cancelAgreement = true,
    director = true, directorStart = true, directorEnd = true, informants = true, informantActive = true,
    auctions = true, auctionOpen = true, auctionCancel = true, setTier = true, adjustReputation = true,
    contractSpots = true, addContractSpot = true, deleteContractSpot = true, gotoContractSpot = true,
    addRacketShop = true, deleteRacketShop = true, gotoRacketShop = true,
    getHeists = true, heistStart = true, heistAbandon = true,
    heists = true, heistCreate = true, heistSave = true, heistDelete = true, heistReset = true, heistStop = true, heistHere = true, gotoPoint = true,
}

local function startAnim()
    local ped = cache.ped
    lib.requestAnimDict(ANIM_DICT)
    lib.requestModel(PROP)
    tabletProp = CreateObject(PROP, GetEntityCoords(ped), true, true, false)
    AttachEntityToEntity(tabletProp, ped, GetPedBoneIndex(ped, 60309), 0.03, 0.002, -0.0, 10.0, 160.0, 0.0, true, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(PROP)
    TaskPlayAnim(ped, ANIM_DICT, 'base', 3.0, 3.0, -1, 49, 0, false, false, false)
end

local function stopAnim()
    StopAnimTask(cache.ped, ANIM_DICT, 'base', 1.0)
    if tabletProp and DoesEntityExist(tabletProp) then DeleteEntity(tabletProp) end
    tabletProp = nil
end

local function staticData()
    local zones = {}
    for key, z in pairs(Config.Zones) do
        local points = {}
        for i, p in ipairs(z.points) do points[i] = { p.x, p.y } end
        zones[#zones + 1] = { key = key, label = z.label, points = points }
    end

    local permissions = {}
    for _, p in ipairs(Config.Permissions) do
        permissions[#permissions + 1] = { key = p, label = locale('perm_' .. p) }
    end

    return {
        zones = zones,
        permissions = permissions,
        currency = Config.Currency,
        creationCost = Config.Gangs.creationCost,
        allowCreation = Config.Gangs.allowPlayerCreation,
        nameMin = Config.Gangs.nameMin,
        nameMax = Config.Gangs.nameMax,
        maxTransaction = Config.Ledger.maxTransaction,
        graffiti = Config.Modules.graffiti,
        contracts = Config.Modules.contracts,
        rackets = Config.Modules.rackets,
        safehouses = Config.Modules.safehouses,
        enterprises = Config.Modules.enterprises,
        diplomacy = Config.Modules.diplomacy,
        informants = Config.Modules.informants,
        auctions = Config.Modules.auctions,
        progression = Config.Progression.enabled,
        shop = Config.Shop.enabled,
        tabletMap = Config.Territory.tabletMap,
        heists = Config.Heists.enabled,
        tiers = (function()
            local out = {}
            for i, t in ipairs(Config.Progression.tiers) do out[i] = { label = t.label, unlocks = t.unlocks } end
            return out
        end)(),
        logos = Config.Logos.enabled,
        logoHosts = Config.Logos.allowedHosts,
        logoAnyHost = Config.Logos.allowAnyHost,
        logoApproval = Config.Logos.requireApproval,
        fonts = Config.Graffiti.fonts,
    }
end

local function closeTablet()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    if mode == 'tablet' then stopAnim() end
    mode = nil
end

function OpenTablet()
    if isOpen or IsEntityDead(cache.ped) or IsPauseMenuActive() then return end
    local gang = RefreshPlayerGang()
    if not gang and not Config.Gangs.allowPlayerCreation then
        lib.notify({ description = locale('not_in_gang'), type = 'error' })
        return
    end
    isOpen, mode = true, 'tablet'
    startAnim()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', static = staticData(), gang = gang })
end

exports('openTablet', OpenTablet)
RegisterNetEvent('vinewood_gangs:client:openTablet', OpenTablet)

RegisterNetEvent('vinewood_gangs:client:openAdmin', function()
    if isOpen then closeTablet() end
    isOpen, mode = true, 'admin'
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openAdmin', static = staticData() })
end)

if Config.Tablet.keybind then
    lib.addKeybind({
        name = 'vinewood_gangs_tablet',
        description = locale('tablet_keybind'),
        defaultKey = Config.Tablet.keybind,
        onPressed = OpenTablet,
    })
end

if Config.Tablet.command then
    RegisterCommand(Config.Tablet.command, OpenTablet, false)
end

RegisterNUICallback('close', function(_, cb)
    closeTablet()
    cb('ok')
end)

local function forward(prefix, allowed, body, cb)
    local action = type(body) == 'table' and body.action
    if not allowed[action] then
        return cb({ ok = false, error = locale('invalid') })
    end
    local args = type(body.args) == 'table' and body.args or {}
    local res, extra = lib.callback.await(prefix .. action, false, args[1], args[2], args[3], args[4])
    if res == nil or res == false then
        cb({ ok = false, error = locale(extra or 'failed') })
        return res
    end
    -- Server functions return either the result, or true plus the result (e.g. true, heist). Pass the result on.
    local data = res
    if res == true and extra ~= nil then data = extra end
    cb({ ok = true, data = data })
    return data
end

RegisterNUICallback('request', function(body, cb)
    if mode ~= 'tablet' then return cb({ ok = false, error = locale('invalid') }) end
    forward('vinewood_gangs:server:', ALLOWED, body, cb)
end)

RegisterNUICallback('adminRequest', function(body, cb)
    if mode ~= 'admin' then return cb({ ok = false, error = locale('invalid') }) end
    local res = forward('vinewood_gangs:admin:', ADMIN_ALLOWED, body, cb)
    -- Teleport staff to a tag or safehouse they want to inspect
    if (body.action == 'gotoTag' or body.action == 'gotoSafehouse' or body.action == 'gotoContractSpot' or body.action == 'gotoRacketShop' or body.action == 'gotoPoint') and type(res) == 'table' then
        closeTablet()
        local heading = res.nx and GetHeadingFromVector_2d(-res.nx, -res.ny) or (res.w or 0.0)
        SetEntityCoords(cache.ped, res.x, res.y, res.z - 0.9, false, false, false, false)
        SetEntityHeading(cache.ped, heading)
    end
end)

-- Areas tab: close the panel and start drawing in the world
RegisterNUICallback('drawZone', function(_, cb)
    cb('ok')
    if mode ~= 'admin' then return end
    closeTablet()
    Wait(200)
    StartZoneEditor()
end)

RegisterNUICallback('setupSafehouse', function(data, cb)
    cb('ok')
    if mode ~= 'admin' then return end
    closeTablet()
    Wait(200)
    StartSafehouseEditor(type(data) == 'table' and type(data.shell) == 'string' and data.shell or nil)
end)

RegisterNUICallback('toggleOutlines', function(_, cb)
    cb({ on = ToggleZoneOutlines() })
end)

-- "Set waypoint" buttons in the tablet
RegisterNUICallback('waypoint', function(data, cb)
    cb('ok')
    local x, y = tonumber(type(data) == 'table' and data.x), tonumber(type(data) == 'table' and data.y)
    if x and y then
        SetNewWaypoint(x, y)
        lib.notify({ description = locale('waypoint_set'), type = 'inform' })
    end
end)

-- Spray button in the tablet: close it and start placing the tag
RegisterNUICallback('spray', function(design, cb)
    cb('ok')
    closeTablet()
    if type(design) == 'table' and design.id and design.spec then
        Wait(200)
        if StartSprayPlacement then StartSprayPlacement(design) end
    end
end)

-- Live refresh when your own membership or rank changes while the tablet is open
AddEventHandler('vinewood_gangs:client:gangUpdated', function(data)
    if not isOpen or mode ~= 'tablet' then return end
    if not data and not Config.Gangs.allowPlayerCreation then
        closeTablet()
        return
    end
    SendNUIMessage({ action = 'gang', gang = data })
end)

-- Dying or ragdolling mid-use closes the tablet
CreateThread(function()
    while true do
        if isOpen and mode == 'tablet' and (IsEntityDead(cache.ped) or IsPedRagdoll(cache.ped)) then closeTablet() end
        Wait(500)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and isOpen then closeTablet() end
end)
