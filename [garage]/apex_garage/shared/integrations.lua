--[[============================================================================
    apex_garage — shared/integrations.lua   (open source, edit freely)
    ----------------------------------------------------------------------------
    Every optional integration is auto-detected. Override any function here to
    plug in your own notify / keys / fuel resource, or to wire ESX gangs.
============================================================================]]

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
    /garagekeys and fix the two lines — this file ships open.
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
      -- The client event is what this resource has always exposed. The current
      -- qb-vehiclekeys also has server exports GiveKeys / RemoveKeys (id, plate)
      -- that write the key into the player's metadata, and a client event that
      -- forgets a key; both are read from its own server.lua / client.lua. An
      -- older qb-vehiclekeys without the export raises on the index, which the
      -- inner pcall turns into the event path. Sent from the SERVER to the
      -- owning client as well, because a client that fires it at itself is
      -- trusting a client to decide it owns a car.
        name   = 'qb-vehiclekeys',
        client = function(_, plate) TriggerEvent('vehiclekeys:client:SetOwner', plate) end,
        server = function(src, _, plate)
            if not pcall(function() exports['qb-vehiclekeys']:GiveKeys(src, plate) end) then
                TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
            end
        end,
        removeClient = function(_, plate) TriggerEvent('qb-vehiclekeys:client:RemoveKeys', plate) end,
        removeServer = function(src, _, plate) exports['qb-vehiclekeys']:RemoveKeys(src, plate) end,
    },
    { -- Wasabi ------------------------------------------------- VERIFIED
        name   = 'wasabi_carlock',
        client = function(_, plate) exports.wasabi_carlock:GiveKey(plate) end,
        server = function(src, _, plate) exports.wasabi_carlock:GiveKey(src, plate) end,
        removeClient = function(_, plate) exports.wasabi_carlock:RemoveKey(plate) end,
        removeServer = function(src, _, plate) exports.wasabi_carlock:RemoveKey(src, plate) end,
    },
    { -- Quasar --------------------------------------------------- VERIFIED
      -- Client exports: GiveKeys(plate, model, bypassKeyCheck) and
      -- RemoveKeys(plate, model). Server exports: GiveServerKeys(src, plate,
      -- model) and RemoveServerKeys(src, plate, model). ⚠ `model` is NOT
      -- optional in Quasar, on either side: a remove sent without it is refused
      -- with "You did not declare * MODEL * in the trigger
      -- vehiclekeys:server:removekey" and the key item STAYS in the inventory
      -- after the car is stored. `needsModel` makes the dispatcher skip this
      -- provider (and say so in /garagekeys) rather than send a call Quasar
      -- will refuse; the model itself is resolved from the entity, or from the
      -- name remembered when the key was given.
        name   = 'qs-vehiclekeys',
        needsModel = true,
        client = function(_, plate, model) exports['qs-vehiclekeys']:GiveKeys(plate, model, true) end,
        server = function(src, _, plate, model) exports['qs-vehiclekeys']:GiveServerKeys(src, plate, model) end,
        removeClient = function(_, plate, model) exports['qs-vehiclekeys']:RemoveKeys(plate, model) end,
        removeServer = function(src, _, plate, model) exports['qs-vehiclekeys']:RemoveServerKeys(src, plate, model) end,
    },
    { -- MrNewb works on the ENTITY, not the plate ---------------- VERIFIED
        name   = 'MrNewbVehicleKeys',
        client = function(vehicle) exports.MrNewbVehicleKeys:GiveKeys(vehicle) end,
        server = function(src, vehicle) exports.MrNewbVehicleKeys:GiveKeys(src, vehicle) end,
        removeClient = function(vehicle) exports.MrNewbVehicleKeys:RemoveKeys(vehicle) end,
        removeServer = function(src, vehicle) exports.MrNewbVehicleKeys:RemoveKeys(src, vehicle) end,
    },
    { -- Renewed ------------------------------------------------- VERIFIED
        name   = 'Renewed-Vehiclekeys',
        client = function(_, plate) exports['Renewed-Vehiclekeys']:addKey(plate) end,
        server = function(src, _, plate) exports['Renewed-Vehiclekeys']:addKey(src, plate) end,
        removeClient = function(_, plate) exports['Renewed-Vehiclekeys']:removeKey(plate) end,
        removeServer = function(src, _, plate) exports['Renewed-Vehiclekeys']:removeKey(src, plate) end,
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
    -- ---- call is pcall'd. /garagekeys says which of these were tried.
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

--[[ The last thing that happened, for /garagekeys. Kept on both sides because
     a key that fails on the server and a key that fails on the client are two
     different tickets, and until now neither of them said anything at all. ]]
Integrations.KeyLog = { at = 0, side = nil, plate = nil, tried = {}, note = nil }

local function logKeys(side, plate, tried, note)
    -- client Lua has no `os` at all, so even `os.time and ...` raises there.
    -- (1.1.3/1.1.4 raised on exactly this line, in the middle of a take-out,
    -- and left the player invisible: a diagnostic log must never be able to
    -- abort the thing it is logging, so the clock read is pcall'd as well.)
    local ok, at = pcall(function()
        return (os and os.time) and os.time() or GetGameTimer()
    end)
    Integrations.KeyLog = { at = ok and at or 0, side = side,
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
    local line = ('vehicle keys: %s. Run /garagekeys for the full picture.'):format(msg)
    if Utils and Utils.Err then Utils.Err(line) else print('[apex_garage] ' .. line) end
end

--[[ One dispatcher, used by both sides. `half` is 'client'/'removeClient' or
     'server'/'removeServer'; `call` applies the provider's function with the
     arguments that side has. Returns the list of provider names tried and how
     many of them actually ran without raising. ]]
function Integrations.DispatchKeys(half, call, ctx)
    ctx = ctx or {}
    local list, why = Integrations.SelectKeyProviders()
    if not list then
        if why and why ~= 'disabled by Config.vehicleKeys' then Integrations.WarnKeysOnce(why) end
        return {}, 0, why
    end

    local tried, okCount = {}, 0
    for _, p in ipairs(list) do
        local fn = p[half]
        if fn and p.needsModel and not ctx.model then
            -- A call this provider would refuse (and the key would stay where
            -- it is) is not made; /garagekeys shows why.
            tried[#tried + 1] = p.name .. ' (skipped: no model name)'
        elseif fn then
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

--[[ MODEL NAMES, FOR THE PROVIDER THAT KEYS BY THEM (Quasar).

     The client reads the spawn name off the entity. The server cannot: the
     native that turns a hash into a name is client-only. So the client sends
     the name along on the two paths the server already authenticates
     (confirmSpawn and store), and the server accepts it ONLY when it hashes to
     the model it has in hand: a name that does not match is dropped, never
     trusted. The client also remembers the name it gave a key under, so the
     key can be taken back after the car is gone. ]]
Integrations.KeyModels = {}   -- client: plate -> model name used when the key was given

function Integrations.ModelName(vehicle)
    if IsDuplicityVersion() then return nil end
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return nil end
    local ok, name = pcall(function() return GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) end)
    if not ok or type(name) ~= 'string' or name == '' or name == 'CARNOTFOUND' or name == 'NULL' then return nil end
    return name:lower()
end

local function modelU32(n)
    n = tonumber(n)
    if not n then return nil end
    return math.floor(n) % 4294967296
end

--- `name` when joaat(name) is `hash` (sign-safe), otherwise nil.
function Integrations.VerifiedModelName(name, hash)
    if type(name) ~= 'string' or name == '' or #name > 64 then return nil end
    name = name:lower()
    local ok, h = pcall(joaat, name)
    if not ok or not h then return nil end
    local a, b = modelU32(h), modelU32(hash)
    if not a or not b or a ~= b then return nil end
    return name
end

if not IsDuplicityVersion() then
    -- ======================================================================
    -- CLIENT
    -- ======================================================================

    -- SINGLE notification path. Lua and the NUI both funnel through here, so a
    -- message can't be shown twice by two systems.
    local lastMsg, lastAt = nil, 0

    function Integrations.Notify(message, kind, duration)
        if not message or message == '' then return end
        kind     = kind or 'info'
        duration = duration or Config.notify.duration

        local now = GetGameTimer()
        if message == lastMsg and (now - lastAt) < 1000 then return end
        lastMsg, lastAt = message, now

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

    -- ----------------------------------------------------------------------
    -- VEHICLE KEYS (client half)
    -- ----------------------------------------------------------------------
    -- The provider table and the dispatcher live at the top of this file, so
    -- the server half uses exactly the same list. Adding a key resource is
    -- still one row up there and nothing down here.

    -- Keys after a vehicle is pulled out, bought or unparked.
    function Integrations.GiveKeys(vehicle, plate)
        plate = plate and Utils.CleanPlate(plate) or plate
        -- Owner override wins outright: if you define this, we assume you know
        -- exactly what your key system needs and we stay out of the way.
        if Integrations.CustomGiveKeys then
            pcall(Integrations.CustomGiveKeys, vehicle, plate)
            return
        end

        -- Some providers want the spawn name rather than the plate; resolve it
        -- from the entity when it is still there (it can have been deleted
        -- between the request and this call), else from the name this plate
        -- was last keyed under. Remembered either way for the remove.
        local model = Integrations.ModelName(vehicle) or (plate and Integrations.KeyModels[plate]) or nil
        if plate and model then Integrations.KeyModels[plate] = model end

        local tried, okCount = Integrations.DispatchKeys('client', function(fn)
            return fn(vehicle, plate, model)
        end, { model = model })
        logKeys('client', plate, tried)
        if #tried > 0 and okCount == 0 then
            Integrations.WarnKeysOnce('every detected key resource refused the call on the client')
        end
    end

    -- Revoke keys when a vehicle is stored or parked.
    function Integrations.RemoveKeys(vehicle, plate)
        plate = plate and Utils.CleanPlate(plate) or plate
        if Integrations.CustomRemoveKeys then
            pcall(Integrations.CustomRemoveKeys, vehicle, plate)
            return
        end
        -- ⚠ Quasar refuses a remove without the model and the key item stays
        -- in the inventory: the entity first, the remembered name otherwise.
        local model = Integrations.ModelName(vehicle) or (plate and Integrations.KeyModels[plate]) or nil
        local tried = Integrations.DispatchKeys('removeClient', function(fn)
            return fn(vehicle, plate, model)
        end, { model = model })
        logKeys('client', plate, tried, 'remove')
        if plate then Integrations.KeyModels[plate] = nil end
    end

    -- Owner hooks — leave nil to use the auto-detection above.
    -- Integrations.CustomGiveKeys   = function(vehicle, plate) end
    -- Integrations.CustomRemoveKeys = function(vehicle, plate) end

    function Integrations.GetFuel(vehicle)
        if GetResourceState('ox_fuel') == 'started' then
            return Entity(vehicle).state.fuel or 100.0
        elseif GetResourceState('LegacyFuel') == 'started' then
            return exports['LegacyFuel']:GetFuel(vehicle)
        elseif GetResourceState('cdn-fuel') == 'started' then
            return exports['cdn-fuel']:GetFuel(vehicle)
        elseif GetResourceState('ps-fuel') == 'started' then
            return exports['ps-fuel']:GetFuel(vehicle)
        end
        return GetVehicleFuelLevel(vehicle)
    end

    function Integrations.SetFuel(vehicle, level)
        level = level or 100.0
        if GetResourceState('ox_fuel') == 'started' then
            Entity(vehicle).state.fuel = level + 0.0
        elseif GetResourceState('LegacyFuel') == 'started' then
            exports['LegacyFuel']:SetFuel(vehicle, level + 0.0)
        elseif GetResourceState('cdn-fuel') == 'started' then
            exports['cdn-fuel']:SetFuel(vehicle, level + 0.0)
        elseif GetResourceState('ps-fuel') == 'started' then
            exports['ps-fuel']:SetFuel(vehicle, level + 0.0)
        else
            SetVehicleFuelLevel(vehicle, level + 0.0)
        end
    end

else
    -- ======================================================================
    -- SERVER — extension hooks (edit freely)
    -- ======================================================================

    --[[ ⚠⚠ THE HALF THAT WAS MISSING, AND THE REASON KEYS DID NOT STICK.

         Most key resources own the key on the SERVER. A client-side grant marks
         it for the session or for that one entity, so the car worked until it
         was stored, or until the player relogged, and then the key was gone —
         "I have to lockpick my own car every time".

         This is called from the paths the server has ALREADY authenticated:
         confirmSpawn for a take-out (token-checked) and the purchase handler in
         apex_dealerships. Deliberately NOT from a client event, because "the
         client asks the server for a key to plate X" is a free key to anybody's
         car.

         `vehicle` is the server-side entity handle, which is what the
         entity-based providers want; `plate` and `model` cover the rest. Any of
         them may be nil and every call is pcall'd, so a provider that wants
         something we could not resolve is a no-op rather than a raise inside a
         take-out. ]]
    function Integrations.GiveKeysServer(src, vehicle, plate, model)
        if not src or src <= 0 then return end
        plate = plate and Utils.CleanPlate(plate) or plate
        if Integrations.CustomGiveKeysServer then
            pcall(Integrations.CustomGiveKeysServer, src, vehicle, plate, model)
            return
        end
        local tried, okCount = Integrations.DispatchKeys('server', function(fn)
            return fn(src, vehicle, plate, model)
        end, { model = model })
        logKeys('server', plate, tried)
        if #tried > 0 and okCount == 0 then
            Integrations.WarnKeysOnce('every detected key resource refused the call on the server')
        end
    end

    function Integrations.RemoveKeysServer(src, vehicle, plate, model)
        if not src or src <= 0 then return end
        plate = plate and Utils.CleanPlate(plate) or plate
        if Integrations.CustomRemoveKeysServer then
            pcall(Integrations.CustomRemoveKeysServer, src, vehicle, plate, model)
            return
        end
        local tried = Integrations.DispatchKeys('removeServer', function(fn)
            return fn(src, vehicle, plate, model)
        end, { model = model })
        logKeys('server', plate, tried, 'remove')
    end

    -- Owner hooks for the server half. Leave nil to use the auto-detection.
    -- Integrations.CustomGiveKeysServer   = function(src, vehicle, plate, model) end
    -- Integrations.CustomRemoveKeysServer = function(src, vehicle, plate, model) end

    --[[ /garagekeys — WHY THE KEYS DID OR DID NOT ARRIVE.

         Until now a key that never arrived was completely silent: the failures
         went to Utils.Debug, which is off unless the owner turned it on. This
         says, in one command, which key resources are running, which ones this
         resource would feed, which halves they have, and what the last attempt
         actually did. Console-only. ]]
    RegisterCommand('garagekeys', function(src)
        if src ~= 0 then return end
        local function say(s) print('[apex_garage] ' .. s) end
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
                    p.name,
                    p.client and 'yes' or 'no',
                    p.server and 'yes' or 'no',
                    (p.removeClient or p.removeServer) and 'yes' or 'no'))
            end
            local noServer = {}
            for _, p in ipairs(list) do if not p.server then noServer[#noServer + 1] = p.name end end
            if #noServer > 0 then
                say(('⚠ no server half: %s — keys from these are given by the CLIENT only, so'):format(table.concat(noServer, ', ')))
                say('  they may not survive a store or a relog. That is the resource, not this one.')
            end
        end

        local L = Integrations.KeyLog or {}
        if L.side then
            say(('last attempt: %s side, plate %s -> %s'):format(
                tostring(L.side), tostring(L.plate),
                (L.tried and #L.tried > 0) and table.concat(L.tried, ', ') or 'nothing tried'))
        else
            say('last attempt: none yet on this side (take a car out and run this again)')
        end
        say('----------------------')
    end, true)

    -- Custom ESX gang resolver. Return { name = string, grade = number } or nil.
    -- Wire your gang resource here to enable gang garages on ESX.
    Integrations.GetGang = nil

    -- Called after a vehicle is stored. data = { src, identifier, plate, garage }
    function Integrations.OnVehicleStored(data) end

    -- Called after a vehicle is pulled out. data = { src, identifier, plate, garage }
    function Integrations.OnVehicleTakenOut(data) end

    -- Called after a vehicle is impounded. data = { plate, owner, garage, officer, fee, reason }
    function Integrations.OnVehicleImpounded(data) end
end
