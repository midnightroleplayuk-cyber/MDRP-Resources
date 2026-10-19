-- ============================================================
-- APEX ADMIN — THIRD-PARTY COMPATIBILITY LAYER
-- ------------------------------------------------------------
-- One place that knows how to talk to every common vehicle-key,
-- appearance/clothing and inventory resource, for ESX, QBCore and
-- QBox alike.
--
-- Why this file exists
--   The old code hard-coded a single event per feature (for example
--   `vehiclekeys:client:SetOwner` for keys and `esx_skin:openSaveableMenu`
--   for clothing). On a QBox server running qbx_vehiclekeys +
--   illenium-appearance those events simply do not exist, so the
--   admin menu silently did nothing.
--
-- How it works
--   Each provider declares the resources it owns and one or more
--   "entry points". At runtime we pick the first provider whose
--   resource is actually started (Config.* = 'auto'), then fire its
--   entry points in order until one of them succeeds. Exports are
--   wrapped in pcall, so a renamed export in a newer version of a
--   third-party script degrades to the next fallback instead of
--   throwing.
--
-- Adding your own
--   Either set Config.* = 'custom' and fill in the Custom* functions
--   in configs/modifyme.lua, or append a provider table below.
-- ============================================================

Apex = Apex or {}
Apex.Compat = Apex.Compat or {}

local IS_SERVER = IsDuplicityVersion()

-- ── Helpers ─────────────────────────────────────────────────

local function started(resource)
    return GetResourceState(resource) == 'started'
end

--- First started resource from a list, or nil.
local function firstStarted(resources)
    for i = 1, #resources do
        if started(resources[i]) then return resources[i] end
    end
end

--- Call an export without ever letting a missing/renamed one throw.
--- Returns true only when the call actually went through.
local function tryExport(resource, method, ...)
    if not started(resource) then return false end
    local ok, err = pcall(function(...)
        return exports[resource][method](exports[resource], ...)
    end, ...)
    if not ok then
        Apex.Compat.debug(('export %s:%s failed → %s'):format(resource, method, tostring(err)))
    end
    return ok
end

--- Name of the running Wasabi Ambulance V2 resource, or nil (V1 / absent).
function Apex.Compat.WasabiV2()
    if started('wasabi_ambulance_v2') then return 'wasabi_ambulance_v2' end
    if started('wasabi_ambulance') then
        local v = GetResourceMetadata('wasabi_ambulance', 'version', 0) or ''
        local major = tonumber(v:match('^%s*v?(%d+)'))
        if major and major >= 2 then return 'wasabi_ambulance' end
    end
    return nil
end

function Apex.Compat.debug(msg)
    if Config and Config.Debug then
        print(('[apex_adminmenu:compat] %s'):format(msg))
    end
end

-- ============================================================
-- VEHICLE KEYS
-- ------------------------------------------------------------
-- ctx = { vehicle = entity, plate = string, model = string|number,
--         netId = int, target = serverId|nil }
-- Client side unless noted. Returns true when a provider handled it.
-- ============================================================

Apex.Compat.VehicleKeys = {
    {
        id = 'qbx',
        resources = { 'qbx_vehiclekeys' },
        give = function(ctx)
            -- Modern QBox export (client): GiveKeys(vehicle)
            if tryExport('qbx_vehiclekeys', 'GiveKeys', ctx.vehicle) then return true end
            -- Older builds exposed it server-side via a net event.
            if ctx.netId and ctx.netId ~= 0 then
                TriggerServerEvent('qbx_vehiclekeys:server:GiveKeys', ctx.netId)
                return true
            end
            -- qbx keeps the qb-vehiclekeys event around for compatibility.
            TriggerEvent('vehiclekeys:client:SetOwner', ctx.plate)
            return true
        end
    },
    {
        id = 'qb',
        resources = { 'qb-vehiclekeys' },
        give = function(ctx)
            TriggerEvent('vehiclekeys:client:SetOwner', ctx.plate)
            TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', ctx.plate)
            return true
        end
    },
    {
        id = 'wasabi',
        resources = { 'wasabi_carlock' },
        give = function(ctx)
            if tryExport('wasabi_carlock', 'GiveKey', ctx.plate) then return true end
            TriggerServerEvent('wasabi_carlock:giveKey', ctx.plate)
            return true
        end
    },
    {
        id = 'renewed',
        resources = { 'Renewed-Vehiclekeys' },
        give = function(ctx)
            if tryExport('Renewed-Vehiclekeys', 'addKey', ctx.plate) then return true end
            TriggerServerEvent('Renewed-Vehiclekeys:server:GiveKeys', ctx.plate)
            return true
        end
    },
    {
        id = 'mrnewb',
        resources = { 'MrNewbVehicleKeys' },
        give = function(ctx)
            if tryExport('MrNewbVehicleKeys', 'GiveKeys', ctx.vehicle) then return true end
            TriggerEvent('vehiclekeys:client:SetOwner', ctx.plate)
            return true
        end
    },
    {
        id = 'quasar',
        resources = { 'qs-vehiclekeys' },
        give = function(ctx)
            if tryExport('qs-vehiclekeys', 'GiveKeys', ctx.plate, ctx.model) then return true end
            TriggerEvent('vehiclekeys:client:SetOwner', ctx.plate)
            return true
        end
    },
    {
        id = 'jaksam',
        resources = { 'vehicles_keys', 'jaksam-carlock' },
        give = function(ctx)
            TriggerServerEvent('vehicles_keys:selfGiveVehicleKeys', ctx.plate)
            TriggerServerEvent('jaksam-carlock:giveKey', ctx.plate)
            return true
        end
    },
    {
        id = 'cd',
        resources = { 'cd_garage' },
        give = function(ctx)
            TriggerEvent('cd_garage:AddKeys', ctx.plate)
            return true
        end
    },
    {
        id = 't1ger',
        resources = { 't1ger_keys' },
        give = function(ctx)
            TriggerServerEvent('t1ger_keys:addKeys', ctx.plate, ctx.model)
            return true
        end
    },
    {
        id = 'okok',
        resources = { 'okokGarage' },
        give = function(ctx)
            TriggerServerEvent('okokGarage:GiveKeys', ctx.plate)
            return true
        end
    },
    {
        id = 'mono',
        resources = { 'mono_carkeys' },
        give = function(ctx)
            TriggerServerEvent('mono_carkeys:addKey', ctx.plate)
            return true
        end
    },
    {
        id = 'apex',
        resources = { 'apex_carlock' },
        give = function(ctx)
            TriggerServerEvent('apex_carlock:giveKey', ctx.plate)
            return true
        end
    },
    {
        id = 'custom',
        resources = {},
        give = function(ctx)
            if type(CustomGiveKeys) ~= 'function' then return false end
            CustomGiveKeys(ctx.plate, ctx.model, ctx.vehicle)
            return true
        end
    }
}

-- ============================================================
-- APPEARANCE / CLOTHING
-- ------------------------------------------------------------
-- `open`    → open the saveable customisation menu for this player
-- `restore` → reload the saved appearance (used by "Restore ped")
-- ============================================================

Apex.Compat.Appearance = {
    {
        id = 'illenium',
        resources = { 'illenium-appearance' },
        open = function()
            -- illenium-appearance is a fivem-appearance fork, so it keeps
            -- the same export surface plus its own menu event.
            if tryExport('illenium-appearance', 'startPlayerCustomization') then return true end
            TriggerEvent('illenium-appearance:client:openMenu')
            return true
        end,
        restore = function()
            if tryExport('illenium-appearance', 'reloadPedData') then return true end
            TriggerServerEvent('illenium-appearance:server:getAppearance')
            return true
        end
    },
    {
        id = 'fivem-appearance',
        resources = { 'fivem-appearance' },
        open = function()
            if tryExport('fivem-appearance', 'startPlayerCustomization') then return true end
            TriggerEvent('fivem-appearance:openSaveableMenu')
            return true
        end,
        restore = function()
            TriggerServerEvent('fivem-appearance:server:getAppearance')
            return true
        end
    },
    {
        id = 'bl',
        resources = { 'bl_appearance' },
        open = function()
            if tryExport('bl_appearance', 'openMenu', 'default') then return true end
            TriggerEvent('bl_appearance:client:openMenu')
            return true
        end,
        restore = function()
            return tryExport('bl_appearance', 'setPedAppearance')
        end
    },
    {
        id = 'rcore',
        resources = { 'rcore_clothing' },
        open = function()
            TriggerEvent('rcore_clothing:openClothingMenu')
            return true
        end,
        restore = function()
            TriggerEvent('rcore_clothing:reloadSkin')
            return true
        end
    },
    {
        id = 'codem',
        resources = { 'codem-appearance' },
        open = function()
            TriggerEvent('codem-appearance:client:openMenu')
            return true
        end,
        restore = function()
            TriggerServerEvent('codem-appearance:server:loadSkin')
            return true
        end
    },
    {
        id = 'tgiann',
        resources = { 'tgiann-clothing' },
        open = function()
            if tryExport('tgiann-clothing', 'openClothingShopMenu') then return true end
            TriggerEvent('tgiann-clothing:openMenu')
            return true
        end,
        restore = function()
            return tryExport('tgiann-clothing', 'reloadSkin')
        end
    },
    {
        id = 'qb',
        resources = { 'qb-clothing', 'qb-clothes' },
        open = function()
            TriggerEvent('qb-clothing:client:openMenu')
            TriggerEvent('qb-clothes:client:openMenu')
            return true
        end,
        restore = function()
            TriggerServerEvent('qb-clothes:loadPlayerSkin')
            return true
        end
    },
    {
        id = 'esx_skin',
        resources = { 'esx_skin', 'skinchanger' },
        open = function()
            TriggerEvent('esx_skin:openSaveableMenu')
            return true
        end,
        restore = function()
            if not ESX then return false end
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                if not skin then return end
                TriggerEvent('skinchanger:loadDefaultModel', skin.sex == 0, function()
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
            end)
            return true
        end
    },
    {
        id = 'custom',
        resources = {},
        open = function()
            if type(CustomSkinMenu) ~= 'function' then return false end
            CustomSkinMenu()
            return true
        end,
        restore = function()
            if type(CustomRestoreSkin) ~= 'function' then return false end
            CustomRestoreSkin()
            return true
        end
    }
}

-- ============================================================
-- INVENTORY
-- ------------------------------------------------------------
-- `openOther` runs on the SERVER (admin = the staff member's source,
-- target = the inspected player). Almost every modern inventory only
-- exposes a server-side "force open" API, which is also the only safe
-- place to do it — a client-side event would be trivially exploitable.
-- ============================================================

Apex.Compat.Inventory = {
    {
        id = 'ox',
        resources = { 'ox_inventory' },
        openOther = function(admin, target)
            return tryExport('ox_inventory', 'forceOpenInventory', admin, 'player', target)
        end,
        clear = function(target)
            return tryExport('ox_inventory', 'ClearInventory', target)
        end
    },
    {
        id = 'qs',
        resources = { 'qs-inventory' },
        openOther = function(admin, target)
            if tryExport('qs-inventory', 'OpenInventoryById', admin, target) then return true end
            TriggerClientEvent('inventory:client:OpenInventory', admin, 'otherplayer', target)
            return true
        end,
        clear = function(target)
            return tryExport('qs-inventory', 'ClearInventory', target, {})
        end
    },
    {
        id = 'ps',
        resources = { 'ps-inventory' },
        openOther = function(admin, target)
            TriggerClientEvent('ps-inventory:client:OpenInventory', admin, 'otherplayer', target)
            return true
        end,
        clear = function(target)
            return tryExport('ps-inventory', 'ClearInventory', target)
        end
    },
    {
        id = 'codem',
        resources = { 'codem-inventory' },
        openOther = function(admin, target)
            return tryExport('codem-inventory', 'OpenInventoryById', admin, target)
        end,
        clear = function(target)
            return tryExport('codem-inventory', 'ClearInventory', target)
        end
    },
    {
        id = 'origen',
        resources = { 'origen_inventory' },
        openOther = function(admin, target)
            return tryExport('origen_inventory', 'openInventoryById', admin, target)
        end,
        clear = function(target)
            return tryExport('origen_inventory', 'ClearInventory', target)
        end
    },
    {
        id = 'tgiann',
        resources = { 'tgiann-inventory' },
        openOther = function(admin, target)
            return tryExport('tgiann-inventory', 'OpenInventoryById', admin, target)
        end,
        clear = function(target)
            return tryExport('tgiann-inventory', 'ClearInventory', target)
        end
    },
    {
        id = 'core',
        resources = { 'core_inventory' },
        openOther = function(admin, target)
            return tryExport('core_inventory', 'openInventory', admin, tostring(target), 'player')
        end,
        clear = function(target)
            return tryExport('core_inventory', 'clearInventory', tostring(target), 'player')
        end
    },
    {
        id = 'mf',
        resources = { 'mf-inventory' },
        openOther = function(admin, target)
            TriggerClientEvent('mf-inventory:client:openInventory', admin, 'player', target)
            return true
        end,
        clear = function(target, identifier)
            if not identifier then return false end
            local ok = tryExport('mf-inventory', 'clearInventory', identifier)
            tryExport('mf-inventory', 'clearLoadout', identifier)
            return ok
        end
    },
    {
        id = 'qb',
        -- Deliberately last of the "real" providers: qb-inventory is the
        -- fallback shipped with QBCore, and several of the inventories
        -- above also register its events.
        resources = { 'qb-inventory', 'lj-inventory' },
        openOther = function(admin, target)
            if tryExport('qb-inventory', 'OpenInventoryById', admin, target) then return true end
            TriggerClientEvent('inventory:client:OpenInventory', admin, 'otherplayer', target)
            return true
        end,
        clear = function(target)
            return tryExport('qb-inventory', 'ClearInventory', target)
        end
    },
    {
        id = 'cheeza',
        resources = { 'chezza_inventory' },
        openOther = function(admin, target)
            TriggerClientEvent('inventory:client:OpenInventory', admin, 'otherplayer', target)
            return true
        end,
        clear = function() return false end
    },
    {
        id = 'esx',
        resources = { 'es_extended' },
        openOther = function() return false end, -- no standalone UI
        clear = function() return false end      -- handled by the framework branch
    }
}

-- ============================================================
-- MEDICAL / AMBULANCE
-- ------------------------------------------------------------
-- `revive` → bring the local player back up
-- `heal`   → clear injuries, bleeding and the limp
--
-- These MUST go through the ambulance resource, not raw natives. Every
-- one of them tracks death in its own state (qb-ambulancejob keeps
-- `isDead` + `InLaststand` client-side and a death flag on the character
-- server-side). NetworkResurrectLocalPlayer on its own gets the ped off
-- the floor but leaves all of that set, so their death thread carries on
-- with the respawn timer, the death camera and the disabled controls —
-- which is exactly what "the revive button does nothing" looks like.
-- ============================================================

Apex.Compat.Medical = {
    {
        id = 'osp',
        resources = { 'osp_ambulance' },
        revive = function()
            -- OSP's own handler clears death/laststand, wounds, UI and saved status.
            TriggerEvent('hospital:client:Revive', true)
            return true
        end,
        heal = function()
            -- OSP uses RestorePlayer internally for its full medical reset.
            -- Its revive handler also safely heals an already-conscious player.
            TriggerEvent('hospital:client:Revive', true)
            return true
        end
    },
    {
        -- Wasabi Ambulance V1 and V2 revive in completely different ways:
        --   V1 (wasabi_ambulance)    → client event wasabi_ambulance:revive
        --   V2 (wasabi_ambulance_v2) → SERVER exports RevivePlayer(id) /
        --                              ApplyHeal(id, opts); the old client
        --                              event no longer clears its death state
        -- V2 is recognised by its resource name, or by the manifest version
        -- when a server renamed the folder back to wasabi_ambulance. For V2
        -- the server does the revive (Apex.Compat.ServerRevive) and the
        -- client must NOT resurrect natively on top of it.
        id = 'wasabi',
        resources = { 'wasabi_ambulance_v2', 'wasabi_ambulance' },
        serverSide = function() return Apex.Compat.WasabiV2() ~= nil end,
        revive = function()
            if Apex.Compat.WasabiV2() then return true end   -- already done by the server
            if tryExport('wasabi_ambulance', 'revivePlayer') then return true end
            TriggerEvent('wasabi_ambulance:revive')
            return true
        end,
        heal = function()
            if Apex.Compat.WasabiV2() then return true end
            if tryExport('wasabi_ambulance', 'healPlayer') then return true end
            TriggerEvent('wasabi_ambulance:heal')
            return true
        end,
        serverRevive = function(target)
            local res = Apex.Compat.WasabiV2()
            if not res then return false end
            return tryExport(res, 'RevivePlayer', target)
        end,
        serverHeal = function(target)
            local res = Apex.Compat.WasabiV2()
            if not res then return false end
            return tryExport(res, 'ApplyHeal', target, { health = 200, injuries = 'all', limbHealth = true, resetNeeds = true })
        end
    },
    {
        id = 'qbx',
        resources = { 'qbx_medical' },
        revive = function()
            if tryExport('qbx_medical', 'Revive') then return true end
            TriggerEvent('qbx_medical:client:playerRevived')
            TriggerEvent('hospital:client:Revive')   -- kept by qbx for compat
            return true
        end,
        heal = function()
            TriggerEvent('hospital:client:HealInjuries', 'full')
            return true
        end
    },
    {
        id = 'qb',
        resources = { 'qb-ambulancejob', 'ps-ambulancejob', 'lj-ambulancejob' },
        revive = function()
            -- Clears isDead + laststand, restores weapon damage, resets the
            -- movement clipset and wipes the server-side death status.
            TriggerEvent('hospital:client:Revive')
            return true
        end,
        heal = function()
            TriggerEvent('hospital:client:HealInjuries', 'full')
            return true
        end
    },
    {
        id = 'codem',
        resources = { 'codem-ambulancejob' },
        revive = function() TriggerEvent('codem-ambulancejob:client:revive'); return true end,
        heal   = function() TriggerEvent('codem-ambulancejob:client:heal');   return true end
    },
    {
        id = 'ars',
        resources = { 'ars_ambulancejob' },
        revive = function() TriggerEvent('ars_ambulancejob:revive'); return true end,
        heal   = function() TriggerEvent('ars_ambulancejob:heal');   return true end
    },
    {
        id = 'esx',
        resources = { 'esx_ambulancejob' },
        revive = function()
            TriggerEvent('esx_ambulancejob:revive')
            return true
        end,
        heal = function()
            TriggerEvent('esx_ambulancejob:heal', 'big')
            return true
        end
    },
    {
        id = 'custom',
        resources = {},
        revive = function()
            if type(CustomRevive) ~= 'function' then return false end
            CustomRevive()
            return true
        end,
        heal = function()
            if type(CustomHeal) ~= 'function' then return false end
            CustomHeal()
            return true
        end
    }
}

-- ============================================================
-- RESOLUTION
-- ------------------------------------------------------------
-- Resolve once, then cache. Resolution is re-run automatically when a
-- resource starts or stops so a live `ensure` doesn't leave us pointing
-- at a dead provider.
-- ============================================================

local resolved = {}

--- @param kind 'VehicleKeys'|'Appearance'|'Inventory'|'Medical'
--- @param configured string|false|nil  value from Config
local function resolve(kind, configured)
    if resolved[kind] ~= nil then return resolved[kind] or nil end

    local list = Apex.Compat[kind]
    local pick

    if configured == false or configured == nil or configured == '' then
        -- Explicitly disabled.
        resolved[kind] = false
        return nil
    end

    if configured ~= 'auto' then
        for i = 1, #list do
            if list[i].id == configured then pick = list[i] break end
        end
        if not pick then
            print(('[apex_adminmenu] ^3Unknown %s provider "%s" — falling back to auto-detect.^7')
                :format(kind, tostring(configured)))
        end
    end

    if not pick then
        for i = 1, #list do
            local p = list[i]
            if #p.resources > 0 and firstStarted(p.resources) then pick = p break end
        end
    end

    resolved[kind] = pick or false
    if pick then
        Apex.Compat.debug(('%s → %s'):format(kind, pick.id))
    end
    return pick
end

local function invalidate()
    resolved = {}
end

-- The client fires onClientResourceStart/Stop, the server fires
-- onResourceStart/Stop. Register both so a live `ensure qbx_vehiclekeys`
-- is picked up on either side without a restart.
AddEventHandler('onResourceStart',       function() invalidate() end)
AddEventHandler('onResourceStop',        function() invalidate() end)
AddEventHandler('onClientResourceStart', function() invalidate() end)
AddEventHandler('onClientResourceStop',  function() invalidate() end)

function Apex.Compat.Resolve(kind, configured)
    return resolve(kind, configured)
end

--- Which provider ended up being used — handy for /apexcompat.
function Apex.Compat.Which(kind, configured)
    local p = resolve(kind, configured)
    return p and p.id or 'none'
end

-- ============================================================
-- PUBLIC API — CLIENT
-- ============================================================

if not IS_SERVER then

    --- Give the local player keys to a vehicle.
    --- @param vehicle number entity handle
    --- @return boolean handled
    function Apex.Compat.GiveVehicleKeys(vehicle)
        if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return false end

        local provider = resolve('VehicleKeys', Config.UsingVehicleKeys)
        if not provider then return false end

        local ctx = {
            vehicle = vehicle,
            plate   = (GetVehicleNumberPlateText(vehicle) or ''):gsub('^%s*(.-)%s*$', '%1'),
            model   = GetEntityModel(vehicle),
            netId   = NetworkGetNetworkIdFromEntity(vehicle)
        }

        -- Most key scripts read ownership from the server, so make sure the
        -- entity is registered on the network before we announce it.
        if not NetworkGetEntityIsNetworked(vehicle) then
            NetworkRegisterEntityAsNetworked(vehicle)
            ctx.netId = NetworkGetNetworkIdFromEntity(vehicle)
        end

        local ok = provider.give(ctx)
        Apex.Compat.debug(('GiveVehicleKeys via %s → %s'):format(provider.id, tostring(ok)))
        return ok and true or false
    end

    --- Open the clothing / appearance editor for the local player.
    function Apex.Compat.OpenAppearance()
        local provider = resolve('Appearance', Config.SkinMenu)
        if not provider then return false end
        return provider.open() and true or false
    end

    --- Reload the player's saved appearance (undo a /setped).
    function Apex.Compat.RestoreAppearance()
        local provider = resolve('Appearance', Config.SkinMenu)
        if not provider then return false end
        return provider.restore() and true or false
    end

    --- Revive the local player through the server's ambulance resource.
    --- @return boolean handled  false = no provider, caller should fall back
    --- @return boolean handled, boolean serverSide  serverSide = the server
    --- already revived through the provider; do not touch the ped natively
    function Apex.Compat.Revive()
        local provider = resolve('Medical', Config.Medical)
        if not provider then return false, false end
        local ok = provider.revive() and true or false
        local srv = ok and provider.serverSide ~= nil and provider.serverSide() == true or false
        Apex.Compat.debug(('Revive via %s → %s (server-side: %s)'):format(provider.id, tostring(ok), tostring(srv)))
        return ok, srv
    end

    --- Clear injuries / bleeding through the server's ambulance resource.
    --- @return boolean handled
    function Apex.Compat.Heal()
        local provider = resolve('Medical', Config.Medical)
        if not provider then return false end
        return provider.heal() and true or false
    end

    --- Ask the server to open another player's inventory for us.
    function Apex.Compat.OpenPlayerInventory(target)
        target = tonumber(target)
        if not target then return false end
        TriggerServerEvent('apex_adminmenu:compat:openInventory', target)
        return true
    end
end

-- ============================================================
-- PUBLIC API — SERVER
-- ============================================================

if IS_SERVER then

    --- Force-open `target`'s inventory on `admin`'s screen.
    function Apex.Compat.ForceOpenInventory(admin, target)
        local provider = resolve('Inventory', Config.Inventory)
        if not provider then return false end
        return provider.openOther(admin, target) and true or false
    end

    --- Server-side half of revive / heal, for ambulance scripts that only
    --- revive from the server (Wasabi Ambulance V2). Safe to call for every
    --- provider: returns false when there is nothing to do server-side.
    function Apex.Compat.ServerRevive(target)
        target = tonumber(target)
        if not target then return false end
        local provider = resolve('Medical', Config.Medical)
        if not (provider and provider.serverRevive) then return false end
        local ok = provider.serverRevive(target) and true or false
        Apex.Compat.debug(('ServerRevive %d via %s → %s'):format(target, provider.id, tostring(ok)))
        return ok
    end

    function Apex.Compat.ServerHeal(target)
        target = tonumber(target)
        if not target then return false end
        local provider = resolve('Medical', Config.Medical)
        if not (provider and provider.serverHeal) then return false end
        return provider.serverHeal(target) and true or false
    end

    --- Every revive / heal the menu sends goes through these two, so the
    --- ambulance script's server half always runs before the client event.
    function ApexRevivePlayer(target)
        target = tonumber(target)
        if not target or not GetPlayerName(target) then return false end
        Apex.Compat.ServerRevive(target)
        TriggerClientEvent('apex_adminmenu:revive', target)
        return true
    end

    function ApexHealPlayer(target)
        target = tonumber(target)
        if not target or not GetPlayerName(target) then return false end
        Apex.Compat.ServerHeal(target)
        TriggerClientEvent('apex_adminmenu:heal', target)
        return true
    end

    --- Wipe `target`'s inventory using whichever provider is running.
    --- @param identifier string|nil framework identifier (mf-inventory needs it)
    function Apex.Compat.ClearInventory(target, identifier)
        local provider = resolve('Inventory', Config.Inventory)
        if not provider then return false end
        return provider.clear(target, identifier) and true or false
    end

    RegisterNetEvent('apex_adminmenu:compat:openInventory', function(target)
        local src = source
        -- Permission gate lives in server/functions.lua; it is loaded after
        -- this shared file but is always present by the time we run.
        if type(HasActionPermission) == 'function' then
            if not HasActionPermission(src, 'giveItems') then return end
        elseif type(AdminPerms) == 'function' then
            if not AdminPerms(src) then return end
        else
            return -- fail closed
        end

        target = tonumber(target)
        if not target or not GetPlayerName(target) then return end

        Apex.Compat.ForceOpenInventory(src, target)
    end)

    -- Diagnostic: prints what the auto-detection picked. Console only.
    RegisterCommand('apexcompat', function(src)
        if src ~= 0 then return end
        print('[apex_adminmenu] compatibility layer:')
        print(('  vehicle keys : %s'):format(Apex.Compat.Which('VehicleKeys', Config.UsingVehicleKeys)))
        print(('  appearance   : %s'):format(Apex.Compat.Which('Appearance',  Config.SkinMenu)))
        print(('  inventory    : %s'):format(Apex.Compat.Which('Inventory',   Config.Inventory)))
        print(('  medical      : %s'):format(Apex.Compat.Which('Medical',     Config.Medical)))
    end, true)
end
