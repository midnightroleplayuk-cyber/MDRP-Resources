--[[
    apex_dealerships — shared/integrations.lua  (open source, edit freely)
    Every optional integration is auto-detected. Override any function below
    to plug your own notify / keys / fuel / garage resources.
]]

Integrations = Integrations or {}

--[[============================================================================
    VEHICLE KEYS — the provider table, shared by BOTH sides
==============================================================================
    ⚠⚠ "IT DOESN'T GIVE KEYS. I HAVE TO LOOKPICK EVERY TIME, EVEN ON A CAR I
    JUST BOUGHT."

    The keys were being handed out from the CLIENT only. For a couple of key
    resources that is enough, and for most of them it is not: the key is owned
    by the SERVER, and a client-side call marks it for the current session, the
    current entity, or nothing at all. Store the car and take it out again, or
    relog, and the key is gone — which is exactly the report.

    So every provider below can declare TWO halves:

      client  what to call on the owning client (entity-based APIs live here)
      server  what to call on the server, with the player's source — this is
              the half that persists, and the half that was missing

    Both are optional and both are always called inside pcall: a renamed export
    in somebody else's key script must never abort a spawn or a purchase
    half-way. `nil` for remove simply means the resource documents no revoke.

    ⚠ THE SERVER HALF IS NEVER DRIVEN BY A CLIENT EVENT. It is called from the
    paths the server already authenticated (confirmSpawn for a garage take-out,
    the purchase handler for a sale), because "client asks the server for a key
    to plate X" is a free key to anybody's car.

    VERIFIED means the signature was taken from that resource's own
    documentation or export list. BEST-EFFORT means it is the documented shape
    as far as we know it; if keys do not arrive with one of those, run
    /dealerkeys and fix the two lines — this file ships open.
============================================================================]]
Integrations.KeyProviders = {
    { -- Qbox official ------------------------------------------- VERIFIED
        name   = 'qbx_vehiclekeys',
        client = function(vehicle, plate) exports.qbx_vehiclekeys:GiveKeys(vehicle, plate) end,
        server = function(src, vehicle) exports.qbx_vehiclekeys:GiveKeys(src, vehicle) end,
        removeClient = function(vehicle, plate) exports.qbx_vehiclekeys:RemoveKeys(vehicle, plate) end,
        removeServer = function(src, vehicle) exports.qbx_vehiclekeys:RemoveKeys(src, vehicle) end,
    },
    { -- QBCore classic ------------------------------------------ VERIFIED
      -- The event is what this resource has always exposed. Sent from the
      -- SERVER to the owning client as well, because a client that fires it at
      -- itself is trusting a client to decide it owns a car.
        name   = 'qb-vehiclekeys',
        client = function(_, plate) TriggerEvent('vehiclekeys:client:SetOwner', plate) end,
        server = function(src, _, plate) TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate) end,
    },
    { -- Wasabi ------------------------------------------------- VERIFIED
        name   = 'wasabi_carlock',
        client = function(_, plate) exports.wasabi_carlock:GiveKey(plate) end,
        server = function(src, _, plate) exports.wasabi_carlock:GiveKey(src, plate) end,
        removeClient = function(_, plate) exports.wasabi_carlock:RemoveKey(plate) end,
        removeServer = function(src, _, plate) exports.wasabi_carlock:RemoveKey(src, plate) end,
    },
    { -- Quasar: 3rd arg = "is owner", i.e. a key that survives a relog VERIFIED
        name   = 'qs-vehiclekeys',
        client = function(_, plate, model) exports['qs-vehiclekeys']:GiveKeys(plate, model, true) end,
        server = function(src, _, plate, model) exports['qs-vehiclekeys']:GiveKeys(src, plate, model) end,
        removeClient = function(_, plate) exports['qs-vehiclekeys']:RemoveKeys(plate) end,
    },
    { -- MrNewb works on the ENTITY, not the plate ---------------- VERIFIED
        name   = 'MrNewbVehicleKeys',
        client = function(vehicle) exports.MrNewbVehicleKeys:GiveKeys(vehicle) end,
        server = function(src, vehicle) exports.MrNewbVehicleKeys:GiveKeys(src, vehicle) end,
        removeClient = function(vehicle) exports.MrNewbVehicleKeys:RemoveKeys(vehicle) end,
        removeServer = function(src, vehicle) exports.MrNewbVehicleKeys:RemoveKeys(src, vehicle) end,
    },
    { -- Renewed ------------------------------------------------- VERIFIED
        -- Purchases are granted by the authenticated SERVER path only; calling
        -- both client + server for a purchased vehicle creates duplicate keys.
        --
        -- Test drives are different: they only use the CLIENT key hook, so
        -- allow the client export exclusively for the configured test-drive
        -- plate. The matching remove hook revokes that temporary key when the
        -- test drive ends.
        name   = 'Renewed-Vehiclekeys',
        client = function(_, plate)
            local testPlate = Config and Config.plate and Config.plate.testDrive
            if testPlate and cleanPlate(plate) == cleanPlate(testPlate) then
                return exports['Renewed-Vehiclekeys']:addKey(plate)
            end
        end,
        server = function(src, _, plate)
            return exports['Renewed-Vehiclekeys']:addKey(src, plate)
        end,
        removeClient = function(_, plate)
            local testPlate = Config and Config.plate and Config.plate.testDrive
            if testPlate and cleanPlate(plate) == cleanPlate(testPlate) then
                return exports['Renewed-Vehiclekeys']:removeKey(plate)
            end
        end,
        removeServer = function(src, _, plate)
            return exports['Renewed-Vehiclekeys']:removeKey(src, plate)
        end,
    },
    { -- tgiann ------------------------------------------------- VERIFIED
        name   = 'tgiann-hotwire',
        client = function(_, plate) exports['tgiann-hotwire']:setVehicleKey(plate) end,
        server = function(src, _, plate) TriggerClientEvent('tgiann-hotwire:addKey', src, plate) end,
        removeClient = function(_, plate) exports['tgiann-hotwire']:removeVehicleKey(plate) end,
    },
    { -- jaksam — the key is written by the SERVER ---------------- VERIFIED
        name   = 'vehicles_keys',
        client = function(_, plate) TriggerServerEvent('vehicles_keys:selfGiveVehicleKeys', plate) end,
        server = function(src, _, plate) TriggerClientEvent('vehicles_keys:client:addNewKey', src, plate) end,
    },
    { -- Codem --------------------------------------------------- BEST-EFFORT
        name   = 'codem-vehiclekeys',
        client = function(_, plate) exports['codem-vehiclekeys']:GiveKeys(plate) end,
        server = function(src, _, plate) exports['codem-vehiclekeys']:GiveKeys(src, plate) end,
        removeClient = function(_, plate) exports['codem-vehiclekeys']:RemoveKeys(plate) end,
    },
    { -- TrackIt ------------------------------------------------- BEST-EFFORT
        name   = 'ti_vehicleKeys',
        client = function(_, plate) exports.ti_vehicleKeys:GiveKeys(plate) end,
        server = function(src, _, plate) exports.ti_vehicleKeys:GiveKeys(src, plate) end,
        removeClient = function(_, plate) exports.ti_vehicleKeys:RemoveKeys(plate) end,
    },
    { -- rcore --------------------------------------------------- BEST-EFFORT
        name   = 'rcore_carkeys',
        server = function(src, _, plate) exports.rcore_carkeys:giveKeys(src, plate) end,
        removeServer = function(src, _, plate) exports.rcore_carkeys:removeKeys(src, plate) end,
    },
    { -- Brutal -------------------------------------------------- BEST-EFFORT
        name   = 'brutal_vehiclekeys',
        client = function(_, plate) exports.brutal_vehiclekeys:GiveKeys(plate) end,
        server = function(src, _, plate) exports.brutal_vehiclekeys:GiveKeys(src, plate) end,
    },
    { -- mono ---------------------------------------------------- BEST-EFFORT
        name   = 'mono_carkeys',
        client = function(_, plate) exports.mono_carkeys:GiveKey(plate) end,
        server = function(src, _, plate) exports.mono_carkeys:GiveKey(src, plate) end,
    },
    { -- garages that own their own keys ------------------------- VERIFIED
        name   = 'cd_garage',
        client = function(_, plate) TriggerEvent('cd_garage:AddKeys', plate) end,
    },
    {
        name   = 'okokGarage',
        client = function(_, plate) TriggerServerEvent('okokGarage:GiveKeys', plate) end,
        server = function(src, _, plate) TriggerClientEvent('okokGarage:GiveKeysClient', src, plate) end,
    },
    -- ---- the rest are BEST-EFFORT: the API is the documented shape as far as
    -- ---- we know it, and a wrong signature is a silent no-op because every
    -- ---- call is pcall'd. /dealerkeys says which of these were tried.
    {
        name   = 'mk_vehiclekeys',
        client = function(_, plate) exports.mk_vehiclekeys:AddKey(plate) end,
        removeClient = function(_, plate) exports.mk_vehiclekeys:RemoveKey(plate) end,
    },
    {
        name   = 't1ger_keys',
        client = function(_, plate) exports.t1ger_keys:GiveKeys(plate) end,
        removeClient = function(_, plate) exports.t1ger_keys:RemoveKeys(plate) end,
    },
    {
        name   = 'ak47_vehiclekeys',
        client = function(_, plate) TriggerServerEvent('ak47_vehiclekeys:giveKeys', plate) end,
        server = function(src, _, plate) TriggerClientEvent('ak47_vehiclekeys:setKeys', src, plate) end,
    },
    {
        name   = 'F_RealCarKeysSystem',
        client = function(_, plate) TriggerServerEvent('F_RealCarKeysSystem:server:addKey', plate) end,
    },
    {
        name   = 'xd_locksystem',
        client = function(_, plate) exports.xd_locksystem:GiveKey(plate) end,
        removeClient = function(_, plate) exports.xd_locksystem:RemoveKey(plate) end,
    },
    { -- ESX fallback, last on purpose: most servers run something newer
        name   = 'esx_vehiclelock',
        client = function(_, plate) TriggerServerEvent('esx_vehiclelock:giveKey', plate) end,
    },
}

--[[ 'starting' counts as available: a garage can be used during the tail of a
     server boot or a resource restart, and the export is already registered by
     the time that script's main file has run. ]]
function Integrations.KeyResourceUp(name)
    local state = GetResourceState(name)
    return state == 'started' or state == 'starting'
end

--[[ Which providers to feed. Config.vehicleKeys:
       'auto' (default) -> every detected provider, in table order
       'none'           -> nothing; key handling is fully disabled
       '<resource>'     -> only that one, detection bypassed (pinning also lets
                           you force a provider the state check gets wrong) ]]
function Integrations.SelectKeyProviders()
    local mode = (Config and Config.vehicleKeys) or 'auto'
    if mode == 'none' then return nil, 'disabled by Config.vehicleKeys' end

    if mode ~= 'auto' then
        for _, p in ipairs(Integrations.KeyProviders) do
            if p.name == mode then return { p } end
        end
        -- pinned to a name nothing here knows: do nothing rather than guess
        return nil, ('Config.vehicleKeys is pinned to "%s", which is not in the provider table'):format(tostring(mode))
    end

    local out
    for _, p in ipairs(Integrations.KeyProviders) do
        if Integrations.KeyResourceUp(p.name) then
            out = out or {}
            out[#out + 1] = p
        end
    end
    if not out then return nil, 'no key resource detected' end
    return out
end

--[[ ⚠ apex_dealerships has no Utils.CleanPlate (apex_garage does), and a plate
     with trailing spaces is a DIFFERENT string to every key resource that keys
     its table by plate. Normalised here, once, the way the key resources read a
     plate off the car: TRIMMED, never with the inner spaces removed. GTA pads
     the plate text to 8 characters and qb-vehiclekeys (QBCore.Shared.Trim),
     Qbox and the rest only strip the ends — so stripping EVERY space turned the
     test-drive plate 'APEX TD' into 'APEXTD', a key for a plate no car wears. ]]
local function cleanPlate(p)
    if p == nil then return nil end
    p = tostring(p):upper():gsub('^%s*(.-)%s*$', '%1')
    return p ~= '' and p or nil
end
--[[ The last thing that happened, for /dealerkeys. Kept on both sides because
     a key that fails on the server and a key that fails on the client are two
     different tickets, and until now neither of them said anything at all. ]]
Integrations.KeyLog = { at = 0, side = nil, plate = nil, tried = {}, note = nil }

local function logKeys(side, plate, tried, note)
    Integrations.KeyLog = { at = GetGameTimer(), side = side,
                            plate = plate, tried = tried, note = note }
end

--[[ ⚠ A KEY THAT NEVER ARRIVES USED TO BE COMPLETELY SILENT. The old dispatcher
     sent its failures to Utils.Debug, which is off unless the owner turned it
     on, so "it does not give keys" had nothing behind it to read. Now: the
     first time no provider can be found, or every provider fails, it is said
     once in the server console with the command that explains it. ]]
local warnedNoKeys = false
function Integrations.WarnKeysOnce(msg)
    if warnedNoKeys then return end
    warnedNoKeys = true
    local line = ('vehicle keys: %s. Run /dealerkeys for the full picture.'):format(msg)
    if Utils and Utils.Err then Utils.Err(line) else print('[apex_dealerships] ' .. line) end
end

--[[ One dispatcher, used by both sides. `half` is 'client'/'removeClient' or
     'server'/'removeServer'; `call` applies the provider's function with the
     arguments that side has. Returns the list of provider names tried and how
     many of them actually ran without raising. ]]
function Integrations.DispatchKeys(half, call)
    local list, why = Integrations.SelectKeyProviders()
    if not list then
        if why and why ~= 'disabled by Config.vehicleKeys' then Integrations.WarnKeysOnce(why) end
        return {}, 0, why
    end

    local tried, okCount = {}, 0
    for _, p in ipairs(list) do
        local fn = p[half]
        if fn then
            local ok, err = pcall(call, fn)
            tried[#tried + 1] = p.name .. (ok and ' ok' or ' FAILED')
            if ok then okCount = okCount + 1
            elseif Utils and Utils.Debug then
                Utils.Debug(('key provider %s:%s failed -> %s'):format(p.name, half, tostring(err)))
            end
        else
            tried[#tried + 1] = p.name .. ' (no ' .. half .. ' half)'
        end
    end
    return tried, okCount
end

if not IsDuplicityVersion() then
    -- ==================================================================
    -- CLIENT
    -- ==================================================================

    -- SINGLE notification path: ox_lib. Everything (Lua and the NUI) funnels
    -- through here, so the same message can never be shown twice by two
    -- different systems.
    local lastMsg, lastAt = nil, 0

    function Integrations.Notify(message, kind, duration)
        if not message or message == '' then return end
        kind = kind or 'info'
        duration = duration or Config.notify.duration

        -- de-dupe: the same message fired twice within a second (a double click,
        -- or a client-side check that the server also rejects) shows once
        local now = GetGameTimer()
        if message == lastMsg and (now - lastAt) < 1000 then return end
        lastMsg, lastAt = message, now

        -- ox_lib is the intended path (and a declared dependency), but a server
        -- that does not run it must still SEE its notifications: fall back to
        -- the framework's own notify rather than printing to a console nobody
        -- reads.
        if GetResourceState('ox_lib') == 'started' then
            exports.ox_lib:notify({
                title       = Config.notify.title,
                description = message,
                type        = (kind == 'info' and 'inform') or kind,
                duration    = duration,
                position    = Config.notify.position,
            })
        elseif Bridge.isQB then
            TriggerEvent('QBCore:Notify', message, (kind == 'info' and 'primary') or kind, duration)
        elseif Bridge.isESX then
            TriggerEvent('esx:showNotification', message)
        else
            BeginTextCommandThefeedPost('STRING')
            AddTextComponentSubstringPlayerName(message)
            EndTextCommandThefeedPostTicker(false, true)
        end
    end

    --[[ Give vehicle keys after a purchase or a test drive.

         ⚠ THIS USED TO BE AN if/elseif CHAIN OF FIVE, AND THREE OF ITS BRANCHES
         CALLED SOMEBODY ELSE'S EXPORT WITHOUT A pcall — inside the delivery of
         a car the buyer had already paid for. A renamed export in wasabi,
         Quasar or MrNewb did not fail to give a key, it raised out of the
         middle of the delivery: no colours, no fuel, no props saved. It also
         stopped at the FIRST detected resource, so a server running two never
         fed the second.

         Now it is the same provider table apex_garage uses (top of this file),
         every call is pcall'd, and every detected provider is fed. ]]
    function Integrations.GiveKeys(vehicle, plate)
        plate = cleanPlate(plate)
        if Integrations.CustomGiveKeys then
            pcall(Integrations.CustomGiveKeys, vehicle, plate)
            return
        end

        -- Some providers want the spawn name rather than the plate; resolve it
        -- once, and only if the entity is really there (a dealership set to
        -- deliver straight to the garage never spawns one).
        local model
        if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
            model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
        end

        local tried, okCount = Integrations.DispatchKeys('client', function(fn)
            return fn(vehicle, plate, model)
        end)
        logKeys('client', plate, tried)
        if #tried > 0 and okCount == 0 then
            Integrations.WarnKeysOnce('every detected key resource refused the call on the client')
        end
    end

    function Integrations.RemoveKeys(vehicle, plate)
        plate = cleanPlate(plate)
        if Integrations.CustomRemoveKeys then
            pcall(Integrations.CustomRemoveKeys, vehicle, plate)
            return
        end
        Integrations.DispatchKeys('removeClient', function(fn)
            return fn(vehicle, plate, nil)
        end)
    end

    -- Owner hooks — leave nil to use the auto-detection above.
    -- Integrations.CustomGiveKeys   = function(vehicle, plate) end
    -- Integrations.CustomRemoveKeys = function(vehicle, plate) end

    function Integrations.SetFuel(vehicle, level)
        level = level or 100.0
        if GetResourceState('ox_fuel') == 'started' then
            Entity(vehicle).state.fuel = level
        elseif GetResourceState('LegacyFuel') == 'started' then
            exports['LegacyFuel']:SetFuel(vehicle, level)
        elseif GetResourceState('lc_fuel') == 'started' then
            exports['lc_fuel']:SetFuel(vehicle, level)
        elseif GetResourceState('cdn-fuel') == 'started' then
            exports['cdn-fuel']:SetFuel(vehicle, level)
        else
            SetVehicleFuelLevel(vehicle, level + 0.0)
        end
    end

else
    -- ==================================================================
    -- SERVER — post-purchase hooks (edit freely)
    -- ==================================================================

    --[[ ⚠⚠ THE HALF THAT WAS MISSING, AND THE REASON KEYS DID NOT STICK.

         Most key resources own the key on the SERVER. A client-side grant marks
         it for the session or for one entity, so the car worked until it was
         stored or the buyer relogged, and then the key was gone. And a
         dealership set to deliver straight to the garage never spawned a car
         for the client to ask about at all.

         Called from the purchase handler, AFTER the money has moved and the row
         exists, so the server already knows this player owns this plate. Never
         from a client event: "the client asks the server for a key to plate X"
         is a free key to anybody's car. ]]
    function Integrations.GiveKeysServer(src, vehicle, plate, model)
        if not src or src <= 0 then return end
        plate = cleanPlate(plate)
        if Integrations.CustomGiveKeysServer then
            pcall(Integrations.CustomGiveKeysServer, src, vehicle, plate, model)
            return
        end
        local tried, okCount = Integrations.DispatchKeys('server', function(fn)
            return fn(src, vehicle, plate, model)
        end)
        logKeys('server', plate, tried)
        if #tried > 0 and okCount == 0 then
            Integrations.WarnKeysOnce('every detected key resource refused the call on the server')
        end
    end

    function Integrations.RemoveKeysServer(src, vehicle, plate, model)
        if not src or src <= 0 then return end
        plate = cleanPlate(plate)
        if Integrations.CustomRemoveKeysServer then
            pcall(Integrations.CustomRemoveKeysServer, src, vehicle, plate, model)
            return
        end
        Integrations.DispatchKeys('removeServer', function(fn)
            return fn(src, vehicle, plate, model)
        end)
    end

    -- Owner hooks for the server half. Leave nil to use the auto-detection.
    -- Integrations.CustomGiveKeysServer   = function(src, vehicle, plate, model) end
    -- Integrations.CustomRemoveKeysServer = function(src, vehicle, plate, model) end

    --[[ /dealerkeys — WHY THE KEYS DID OR DID NOT ARRIVE. Console-only. ]]
    RegisterCommand('dealerkeys', function(src)
        if src ~= 0 then return end
        local function say(s) print('[apex_dealerships] ' .. s) end
        say('---- vehicle keys ----')
        say(('Config.vehicleKeys = %s'):format(tostring((Config and Config.vehicleKeys) or 'auto')))

        local running = {}
        for _, p in ipairs(Integrations.KeyProviders) do
            if Integrations.KeyResourceUp(p.name) then running[#running + 1] = p.name end
        end
        say(('key resources running: %s'):format(#running > 0 and table.concat(running, ', ') or 'NONE'))

        local list, why = Integrations.SelectKeyProviders()
        if not list then
            say(('nothing will be fed: %s'):format(tostring(why)))
        else
            for _, p in ipairs(list) do
                say(('  %-22s client=%s  server=%s  revoke=%s'):format(
                    p.name, p.client and 'yes' or 'no', p.server and 'yes' or 'no',
                    (p.removeClient or p.removeServer) and 'yes' or 'no'))
            end
            local noServer = {}
            for _, p in ipairs(list) do if not p.server then noServer[#noServer + 1] = p.name end end
            if #noServer > 0 then
                say(('⚠ no server half: %s — keys from these are given by the CLIENT only, so'):format(table.concat(noServer, ', ')))
                say('  they may not survive a relog. That is the key resource, not this one.')
            end
        end

        local L = Integrations.KeyLog or {}
        if L.side then
            say(('last attempt: %s side, plate %s -> %s'):format(tostring(L.side), tostring(L.plate),
                (L.tried and #L.tried > 0) and table.concat(L.tried, ', ') or 'nothing tried'))
        else
            say('last attempt: none yet on this side (buy a car and run this again)')
        end
        say('----------------------')
    end, true)

    -- Called AFTER a vehicle purchase is fully persisted.
    -- data = { src, identifier, model, plate, price, method, dealership, financed }
    function Integrations.OnVehiclePurchased(data)
        -- e.g. integrate with your garage script here
    end

    -- Called after a financed vehicle is repossessed.
    -- data = { identifier, plate, model, dealership }
    function Integrations.OnVehicleRepossessed(data)
    end

    -- Return false to block a purchase with a custom reason shown to the buyer.
    -- Runs before any money is taken.
    function Integrations.PurchasePreCheck(src, data)
        return true
    end
end
