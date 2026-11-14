local isOpen = false
local mode -- 'tablet' | 'admin'
local tabletProp
local ANIM_DICT = 'amb@code_human_in_bus_passenger_idles@female@tablet@base'
local PROP = GetHashKey('prop_cs_tablet')

-- Only these server callbacks can be reached from the NUI
---Who can start a gang and the price: set by the server (config, or what staff changed in game).
local function creationRules()
    local r = GlobalState.vg_gang_creation
    if type(r) == 'table' then return r end
    return { allow = Config.Gangs.allowPlayerCreation ~= false, cost = Config.Gangs.creationCost or 0, account = Config.Gangs.creationAccount or 'bank' }
end

local ALLOWED = {
    getOverview = true, getMembers = true, getTerritory = true, getTreasury = true, getNearby = true, getTags = true,
    createGang = true, invite = true, kick = true, setGrade = true, transfer = true, editRank = true,
    updateDetails = true, leave = true, disband = true, deposit = true, withdraw = true, depositDirty = true, withdrawDirty = true,
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
    getHeists = true, heistStart = true, heistAbandon = true,
    getAirdrop = true, airdropCall = true, hexExpand = true,
}

local ADMIN_ALLOWED = {
    listGangs = true, gangDetail = true, createGang = true, disband = true, addMember = true, removeMember = true,
    setGrade = true, pendingDesigns = true, reviewDesign = true,
    listTags = true, removeTag = true, gotoTag = true, onlinePlayers = true,
    pendingLogos = true, reviewLogo = true, rackets = true, releaseRacket = true,
    safehouses = true, evictSafehouse = true, deleteSafehouse = true, gotoSafehouse = true, safehouseShells = true,
    enterprises = true, closeEnterprise = true, agreements = true, cancelAgreement = true,
    director = true, directorStart = true, directorEnd = true, informants = true, informantActive = true,
    auctions = true, auctionOpen = true, auctionCancel = true, setTier = true, adjustReputation = true,
    contractSpots = true, addContractSpot = true, deleteContractSpot = true, gotoContractSpot = true,
    addRacketShop = true, deleteRacketShop = true, gotoRacketShop = true,
    hexGang = true, hexMap = true, hexResize = true, heistLaptops = true, heistLaptopAdd = true, heistLaptopRemove = true,
    heistLootTables = true, heistLootTablesSave = true,
    itemCount = true, itemGive = true, itemTake = true, packages = true, packageSave = true, packageDelete = true, packageSend = true, shopGet = true, shopSave = true, shopReset = true, tagTiming = true, tagTimingSave = true, tagTimingReset = true, hexGive = true, hexRemove = true, hexControl = true, hexMain = true, hexSettings = true, hexSettingsSave = true,
    blackmarketSettings = true, blackmarketSave = true, blackmarketOpen = true, blackmarketReset = true,
    airdrops = true, airdropCancel = true, airdropAdminCall = true,
    airdropSchedules = true, airdropScheduleSave = true, airdropScheduleDelete = true, airdropScheduleToggle = true, airdropLoot = true, airdropLootSave = true, airdropLootReset = true,
    searchItems = true, drugItems = true, drugItemsSave = true, drugItemsReset = true,
    staffAccess = true, staffGrant = true, staffRevoke = true, staffPerms = true,
    customContracts = true, customContractSave = true, customContractDelete = true, customContractOffer = true,
    contractSettings = true, contractSettingsSave = true, contractSettingsReset = true,
    gangCreation = true, gangCreationSave = true, gangCreationReset = true,
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

    -- Permissions for features gangs can't use on this server aren't offered on the Ranks page
    local hidden = {
        airdrops = not (Config.Airdrops and Config.Airdrops.enabled and Config.Airdrops.playersCanCall == true),
        heists = Config.Heists and Config.Heists.enabled == false,
    }
    local permissions = {}
    for _, p in ipairs(Config.Permissions) do
        if not hidden[p] then permissions[#permissions + 1] = { key = p, label = locale('perm_' .. p) } end
    end

    return {
        zones = zones,
        permissions = permissions,
        currency = Config.Currency,
        creationCost = creationRules().cost,
        creationAccount = creationRules().account,
        allowCreation = creationRules().allow,
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
        auctions = Config.Modules.auctions and GlobalState.vg_blackmarket ~= false, -- staff can close the black market in game
        progression = Config.Progression.enabled,
        shop = Config.Shop.enabled and GlobalState.vg_shop_open ~= false, -- staff can close the shop in game
        tabletMap = Config.Territory.tabletMap,
        heists = Config.Heists.enabled,
        airdrops = Config.Airdrops.enabled and Config.Airdrops.playersCanCall == true, -- the gang tablet's Air drop app
        hexMode = true,
        hexSize = Hex.Grid().size, hexOrigin = Hex.Grid().origin, hexDistricts = Config.Hexes.districts,
        airdropShowTo = Config.Airdrops.showTo,
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

---Teleports the player to x, y, landing on whatever's there (loads the area first). Returns where they ended up.
function TeleportToGround(x, y, heading)
    local ped = cache.ped
    FreezeEntityPosition(ped, true)
    local z
    for _, h in ipairs({ 1000.0, 800.0, 600.0, 400.0, 250.0, 150.0, 100.0, 50.0, 25.0, 0.0 }) do
        SetEntityCoordsNoOffset(ped, x, y, h, false, false, false)
        RequestCollisionAtCoord(x, y, h)
        local t = GetGameTimer()
        while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() - t < 1500 do Wait(0) end
        local found, gz = GetGroundZFor_3dCoord(x, y, h, false)
        if found then z = gz break end
    end
    SetEntityCoords(ped, x, y, (z or 30.0) + 0.1, false, false, false, false)
    if heading then SetEntityHeading(ped, heading) end
    FreezeEntityPosition(ped, false)
    Wait(300)
    local c = GetEntityCoords(ped)
    return { x = c.x, y = c.y, z = c.z, w = GetEntityHeading(ped) }
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
    -- No tablet item on you, no tablet (the server checks your inventory)
    if Config.Tablet.requireItem and Config.Tablet.item and not lib.callback.await('vinewood_gangs:server:canOpenTablet', false) then
        lib.notify({ description = locale('tablet_need_item'), type = 'error' })
        return
    end
    local gang = RefreshPlayerGang()
    if not gang and not creationRules().allow then
        lib.notify({ description = locale('not_in_gang_staff_create'), type = 'error' })
        return
    end
    isOpen, mode = true, 'tablet'
    startAnim()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', static = staticData(), gang = gang })
end

exports('openTablet', OpenTablet)
RegisterNetEvent('vinewood_gangs:client:openTablet', OpenTablet)

RegisterNetEvent('vinewood_gangs:client:openAdmin', function(access)
    if isOpen then closeTablet() end
    isOpen, mode = true, 'admin'
    SetNuiFocus(true, true)
    local static = staticData()
    static.access = access -- { role = 'management'|'staff', perms = { group = true } } (the server checks every action anyway)
    SendNUIMessage({ action = 'openAdmin', static = static })
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

---A heist laptop: shows the heist board (anyone can use one; staff place them around the map).
function OpenHeistLaptop(board, label)
    if isOpen or IsEntityDead(cache.ped) then return end
    isOpen, mode = true, 'laptop'
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openLaptop', board = board, label = label, static = staticData() })
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
    local res, extra, d1, d2 = lib.callback.await(prefix .. action, false, args[1], args[2], args[3], args[4], args[5], args[6])
    if res == nil or res == false then
        -- Errors can come with details (a limit, an amount...) that fill in the message
        local msg = locale(extra or 'failed')
        if d1 ~= nil then
            local ok, filled = pcall(locale, extra or 'failed', d1, d2)
            if ok and filled then msg = filled end
        end
        cb({ ok = false, error = msg })
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
        if res.ground then
            -- Picked on the map: no height known, so load the area and land on whatever's there
            CreateThread(function() TeleportToGround(res.x, res.y, heading) end)
        else
            SetEntityCoords(cache.ped, res.x, res.y, res.z - 0.9, false, false, false, false)
            SetEntityHeading(cache.ped, heading)
        end
    end
end)

-- Air drop app: where's my waypoint?
RegisterNUICallback('airdropWaypoint', function(_, cb)
    local blip = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blip) then return cb({ ok = false }) end
    local c = GetBlipInfoIdCoord(blip)
    cb({ ok = true, x = c.x, y = c.y })
end)

-- Air drop app: is this spot on land? (A crate dropped in water would sink out of reach.)
RegisterNUICallback('airdropCheck', function(data, cb)
    local x, y = tonumber(data and data.x), tonumber(data and data.y)
    if not x or not y then return cb({ ok = false }) end
    local ground
    for _, start in ipairs({ 1000.0, 500.0, 200.0 }) do
        local found, z = GetGroundZFor_3dCoord(x, y, start, false)
        if found then ground = z break end
    end
    local water, waterZ = GetWaterHeight(x, y, (ground or 0.0) + 50.0)
    local wet = water and (not ground or waterZ > ground + 0.5)
    cb({ ok = not wet, water = wet })
end)

-- Areas tab: close the panel and start drawing in the world

RegisterNUICallback('setupSafehouse', function(data, cb)
    cb('ok')
    if mode ~= 'admin' then return end
    closeTablet()
    Wait(200)
    StartSafehouseEditor(type(data) == 'table' and type(data.shell) == 'string' and data.shell or nil,
        type(data) == 'table' and data.mode == 'walkin' and 'walkin' or nil)
end)

-- Placing NPCs in the world from the staff panel: the panel hides (keeping its place), staff place the NPC,
-- then it comes back with the result
RegisterNUICallback('placeNpc', function(data, cb)
    cb('ok')
    if mode ~= 'admin' or type(data) ~= 'table' then return end
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'adminHide' })
    CreateThread(function()
        Wait(150)
        local ok, points = pcall(PlaceNpcs, { model = data.model, multi = data.multi, max = data.max, object = data.object })
        if not ok then points = nil end
        if mode == 'admin' then
            SetNuiFocus(true, true)
            SendNUIMessage({ action = 'adminPlaced', token = data.token, points = points })
        end
    end)
end)

RegisterNUICallback('pickDoors', function(data, cb)
    cb('ok')
    if mode ~= 'admin' or type(data) ~= 'table' then return end
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'adminHide' })
    CreateThread(function()
        Wait(150)
        local ok, doors = pcall(PickDoors)
        if not ok then doors = nil end
        if mode == 'admin' then
            SetNuiFocus(true, true)
            SendNUIMessage({ action = 'adminPlaced', token = data.token, points = doors })
        end
    end)
end)

RegisterNUICallback('goPicked', function(data, cb)
    cb('ok')
    if mode ~= 'admin' or type(data) ~= 'table' or not tonumber(data.x) or not tonumber(data.y) then return end
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'adminHide' })
    CreateThread(function()
        local ok, at = pcall(TeleportToGround, tonumber(data.x), tonumber(data.y))
        Wait(400)
        if mode == 'admin' then
            SetNuiFocus(true, true)
            SendNUIMessage({ action = 'adminPlaced', token = data.token, points = ok and { at } or nil })
        end
    end)
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
    if not data and not creationRules().allow then
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
