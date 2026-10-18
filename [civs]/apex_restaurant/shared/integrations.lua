--[[
═══════════════════════════════════════════════════════════════
    Apex Restaurant — Integrations (OPEN SOURCE)
═══════════════════════════════════════════════════════════════

    This file is the **only** part of the resource that ships
    unencrypted on purpose. Edit it freely to plug Apex Restaurant
    into your own framework: custom notifications, third-party
    billing, society / banking systems, custom inventory, etc.

    Every other Lua file calls into this single `Integrations`
    table — so you can swap any backend WITHOUT touching the
    encrypted core.

    All callbacks have a sensible default that uses the built-in
    `Bridge`. Comment out a default or replace it inline.

    Anatomy:
        Integrations.Notify          on-screen toast
        Integrations.Money           cash / bank reads + writes
        Integrations.Society         society funds (gov contract,
                                     boss treasury, …)
        Integrations.Inventory       hand-held inventory I/O
        Integrations.Logger          server-side activity log /
                                     Discord / webhooks / audit
        Integrations.Phone           dispatch / delivery phone UI
        Integrations.Webhooks        Discord destinations
        Integrations.Time            game-time / payday clock

    NOTE: This file is loaded BEFORE the encrypted modules, so
    any helper you stick on the `Integrations` table is available
    from anywhere in the resource.

═══════════════════════════════════════════════════════════════
]]

Integrations = Integrations or {}

-- ════════════════════════════════════════════════════════════
-- 1) NOTIFICATIONS
-- ════════════════════════════════════════════════════════════
-- Called every time the resource wants to show a toast.
--   `src`      server-side: target player id.   client-side: nil
--   `message`  pre-translated string (already passed through L())
--   `type`     'info' | 'success' | 'warning' | 'error'
--   `duration` milliseconds
--
-- Default: routes through the built-in apex_notify NUI toast.
-- Swap this for ox_lib, qb-notify, okok, ps-ui — whatever you use.
--
-- Examples are commented out. Uncomment ONE and remove the default.
function Integrations.Notify(src, message, type, duration)
    -- ── DEFAULT (built-in apex_notify NUI) ──────────────────
    type     = type or 'info'
    duration = duration or 5000
    if IsDuplicityVersion() then
        if not src then return end
        TriggerClientEvent('apex_restaurant:notify', src, message, type, duration)
    else
        TriggerEvent('apex_restaurant:notify', message, type, duration)
    end

    -- ── ox_lib ──────────────────────────────────────────────
    -- if IsDuplicityVersion() then
    --     TriggerClientEvent('ox_lib:notify', src, { title = message, type = type, duration = duration })
    -- else
    --     lib.notify({ title = message, type = type, duration = duration })
    -- end

    -- ── ESX native ──────────────────────────────────────────
    -- if IsDuplicityVersion() then
    --     TriggerClientEvent('esx:showNotification', src, message)
    -- else
    --     ESX.ShowNotification(message)
    -- end

    -- ── QBCore native ───────────────────────────────────────
    -- if IsDuplicityVersion() then
    --     TriggerClientEvent('QBCore:Notify', src, message, type, duration)
    -- else
    --     QBCore.Functions.Notify(message, type, duration)
    -- end

    -- ── okokNotify ──────────────────────────────────────────
    -- if IsDuplicityVersion() then
    --     TriggerClientEvent('okokNotify:Alert', src, 'Restaurant', message, duration, type)
    -- else
    --     exports['okokNotify']:Alert('Restaurant', message, duration, type)
    -- end
end


-- ════════════════════════════════════════════════════════════
-- 2) MONEY  (player wallet — cash + bank)
-- ════════════════════════════════════════════════════════════
-- All three are SERVER-side. `account` is 'cash' | 'bank' | 'money'.
-- 'money' = 'cash' for ESX, 'cash' for QB. Return true on success.

Integrations.Money = IsDuplicityVersion() and {

    Add = function(src, account, amount)
        return Bridge:AddMoney(src, account, amount)

        -- Renewed Banking:
        -- return exports['Renewed-Banking']:addAccountMoney(src, account, amount)

        -- qb-banking:
        -- return exports['qb-banking']:AddMoney(account, amount)
    end,

    Remove = function(src, account, amount)
        return Bridge:RemoveMoney(src, account, amount)
    end,

    Get = function(src, account)
        return Bridge:GetMoney(src, account)
    end,
} or {
    Add    = function() return false end,
    Remove = function() return false end,
    Get    = function() return 0 end,
}


-- ════════════════════════════════════════════════════════════
-- 3) SOCIETY  (boss treasury / company funds)
-- ════════════════════════════════════════════════════════════
-- Used by:
--   • the boss menu Withdraw / Deposit buttons
--   • supplier purchases (subtract from society funds)
--   • register charges (add to society funds)
--   • the dashboard "Society funds" stat
--
-- Default talks to ESX `addon_account_data` directly via oxmysql.
-- Swap this if you use boii_management, Renewed-Banking, OKOK, etc.

-- Society helpers run server-side. Wrapped in IsDuplicityVersion()
-- so requiring this file from a client script never crashes — the
-- functions exist on both sides but return safe defaults on client.
Integrations.Society = IsDuplicityVersion() and {

    -- Returns the current balance for the given job
    Get = function(jobName)
        if Bridge.isQB then
            -- QB: try qb-management exports first
            if GetResourceState('qb-management') == 'started' then
                return exports['qb-management']:GetAccount(jobName) or 0
            end
            if GetResourceState('Renewed-Banking') == 'started' then
                return exports['Renewed-Banking']:getAccountMoney(jobName) or 0
            end
        end
        -- ESX society fallback (addon_account_data table)
        local accName = 'society_' .. jobName
        local row = MySQL.single.await(
            'SELECT money FROM addon_account_data WHERE account_name = ? LIMIT 1',
            { accName })
        return row and tonumber(row.money) or 0
    end,

    -- Adds funds. Returns true/false.
    Add = function(jobName, amount)
        if Bridge.isQB then
            if GetResourceState('qb-management') == 'started' then
                exports['qb-management']:AddMoney(jobName, amount); return true
            end
            if GetResourceState('Renewed-Banking') == 'started' then
                exports['Renewed-Banking']:addAccountMoney(jobName, amount); return true
            end
        end
        local accName = 'society_' .. jobName
        MySQL.update.await(
            'UPDATE addon_account_data SET money = money + ? WHERE account_name = ?',
            { amount, accName })
        return true
    end,

    -- Removes funds. Returns true on success, false if balance was
    -- insufficient (the caller handles the error reply).
    Remove = function(jobName, amount)
        local cur = Integrations.Society.Get(jobName)
        if cur < amount then return false end
        if Bridge.isQB then
            if GetResourceState('qb-management') == 'started' then
                exports['qb-management']:RemoveMoney(jobName, amount); return true
            end
            if GetResourceState('Renewed-Banking') == 'started' then
                exports['Renewed-Banking']:removeAccountMoney(jobName, amount); return true
            end
        end
        local accName = 'society_' .. jobName
        MySQL.update.await(
            'UPDATE addon_account_data SET money = money - ? WHERE account_name = ? AND money >= ?',
            { amount, accName, amount })
        return true
    end,
} or {
    Get    = function() return 0 end,
    Add    = function() return false end,
    Remove = function() return false end,
}


-- ════════════════════════════════════════════════════════════
-- 4) INVENTORY  (player-held items)
-- ════════════════════════════════════════════════════════════
-- Used for cooked dishes, take-away boxes, supplier purchases, etc.
-- The encrypted core auto-detects ox_inventory and routes through
-- its exports when present. This integration block lets you OVERRIDE
-- that routing — e.g. force qs-inventory even when ox_inventory is
-- also started.
--
-- All four return true on success.

Integrations.Inventory = {
    -- If you have a third-party inventory you want to FORCE-route
    -- through, set this to its resource name. nil → auto-detect.
    forceResource = nil,

    -- Hand the player `count` of `item`. Returns true on success.
    AddItem = function(src, item, count, meta)
        if GetResourceState('ox_inventory') == 'started' then
            return exports.ox_inventory:AddItem(src, item, count, meta) ~= false
        end
        if GetResourceState('qs-inventory') == 'started' then
            return exports['qs-inventory']:AddItem(src, item, count, nil, meta) ~= false
        end
        -- ESX/QB fallback
        if Bridge.isQB then
            local p = Bridge:GetPlayer(src)
            return p and p.Functions.AddItem(item, count, false, meta) or false
        end
        local p = Bridge:GetPlayer(src)
        return p and p.addInventoryItem(item, count) or false
    end,

    -- Take `count` of `item` away from the player. Returns true on
    -- success, false if they didn't have enough.
    RemoveItem = function(src, item, count)
        if GetResourceState('ox_inventory') == 'started' then
            return exports.ox_inventory:RemoveItem(src, item, count) ~= false
        end
        if GetResourceState('qs-inventory') == 'started' then
            return exports['qs-inventory']:RemoveItem(src, item, count)
        end
        if Bridge.isQB then
            local p = Bridge:GetPlayer(src)
            return p and p.Functions.RemoveItem(item, count) or false
        end
        local p = Bridge:GetPlayer(src)
        return p and p.removeInventoryItem(item, count) or false
    end,

    -- Number of `item` the player has on them.
    GetItemCount = function(src, item)
        if GetResourceState('ox_inventory') == 'started' then
            return exports.ox_inventory:GetItemCount(src, item) or 0
        end
        if Bridge.isQB then
            local p = Bridge:GetPlayer(src); if not p then return 0 end
            local it = p.Functions.GetItemByName(item)
            return it and it.amount or 0
        end
        local p = Bridge:GetPlayer(src); if not p then return 0 end
        local it = p.getInventoryItem(item)
        return it and it.count or 0
    end,

    -- Does the player have room for `count` of `item`? Used before
    -- handing out a cooked dish so we don't dupe items into a full
    -- bag. Return true if you don't want to enforce capacity.
    CanCarry = function(src, item, count)
        if GetResourceState('ox_inventory') == 'started' then
            return exports.ox_inventory:CanCarryItem(src, item, count)
        end
        return true
    end,
}


-- ════════════════════════════════════════════════════════════
-- 5) LOGGER  (per-restaurant activity log, audit trail, Discord)
-- ════════════════════════════════════════════════════════════
-- Called by the boss menu Logs tab, the player profile drawer,
-- and the Recent Revenue / Expenses panels. The default writes
-- to the `apex_restaurant_activity` MySQL table; this integration
-- block lets you ALSO push to Discord, Sentry, your own audit
-- service, or wherever else.

Integrations.Logger = {

    -- Called every time activity is logged. Default: no-op (the
    -- encrypted core already persists to MySQL). Add custom sinks
    -- here:
    --
    --   kind     'sale' | 'register' | 'delivery' | 'cook' | ...
    --   actor    { id, identifier, name } of the player who acted
    --   detail   pre-formatted human string
    --   amount   number — money / units involved (optional)
    --
    OnLog = function(jobName, kind, actor, detail, amount)
        -- Example: ship every HR action to a Discord webhook
        -- if kind == 'hire' or kind == 'fire' or kind == 'promote' or kind == 'demote' then
        --     Integrations.Webhooks.Send('hr',
        --         ('[%s] %s — %s'):format(jobName, actor.name or '?', detail))
        -- end
    end,

    -- Called when society funds change. Useful for paying out
    -- payroll, syncing to an accountant resource, etc.
    OnFundsChange = function(jobName, delta, newBalance, reason, actor)
        -- e.g. payroll log:
        -- if delta < 0 and reason == 'payroll' then ... end
    end,
}


-- ════════════════════════════════════════════════════════════
-- 6) PHONE  (delivery dispatch caller-id)
-- ════════════════════════════════════════════════════════════
-- The delivery flow opens a faux phone-call UI ("Dispatch") to
-- pick a vehicle. If you want it to integrate with a real phone
-- (lb-phone, qb-phone, gks-phone, …) override these.

Integrations.Phone = {

    -- Returns the contact name / number shown on the call header.
    -- Default: localised "Dispatch" label.
    DispatchContact = function(jobName)
        return L('ui.phone.default_contact')
    end,

    -- Called BEFORE the built-in dispatch popup opens. Return
    -- `true` to suppress the built-in UI (i.e. you're handling
    -- the call entirely on your own phone resource).
    OnIncomingDispatch = function(jobName, vehicles)
        -- Example: route to lb-phone instead of the built-in UI
        -- exports['lb-phone']:IncomingCall({ contact = 'Dispatch', ... })
        -- return true
        return false
    end,
}


-- ════════════════════════════════════════════════════════════
-- 7) WEBHOOKS  (Discord)
-- ════════════════════════════════════════════════════════════
-- Where audit-style events should be posted. Empty string ('')
-- disables that channel. Hook URLs go in shared/config.lua under
-- `Config.logs.*` — these are the FALLBACK destinations and the
-- per-event router below.

Integrations.Webhooks = {
    -- Default Discord username + avatar for posts
    username  = 'Apex Restaurant',
    avatarUrl = '',     -- optional png URL

    -- Map of event-kind → webhook URL. Anything not listed falls
    -- through to Config.logs[kind] from shared/config.lua.
    routes = {
        -- editorSave  = 'https://discord.com/api/webhooks/.../...',
        -- supplierBuy = '',
        -- delivery    = '',
        -- register    = '',
        -- treasury    = '',
        -- hr          = '',     -- hire/fire/promote/demote
    },

    -- Helper: post a simple text line to a named channel.
    Send = function(routeName, content, embed)
        local url = Integrations.Webhooks.routes[routeName]
                 or (Config.logs and Config.logs[routeName])
        if not url or url == '' then return end
        local body = {
            username   = Integrations.Webhooks.username,
            avatar_url = Integrations.Webhooks.avatarUrl,
            content    = content,
            embeds     = embed and { embed } or nil,
        }
        PerformHttpRequest(url, function() end, 'POST',
            json.encode(body), { ['Content-Type'] = 'application/json' })
    end,
}


-- ════════════════════════════════════════════════════════════
-- 8) TIME  (real-clock vs game-clock, payday cadence)
-- ════════════════════════════════════════════════════════════
-- Used by the worktime tracker on the boss dashboard and the
-- weekly revenue chart. Default: real seconds. Override if you
-- want to bill in game-time minutes or sync to a custom paycheck
-- cycle.

Integrations.Time = {
    -- Number of REAL seconds elapsed (monotonic, used for diffs).
    NowSeconds = function() return os.time() end,

    -- Day of week (1 = Monday … 7 = Sunday). Used by the 7-day
    -- revenue chart axis. Override if your server uses a custom
    -- calendar (e.g. accelerated week).
    DayOfWeek = function() return tonumber(os.date('%u')) end,
}


-- ════════════════════════════════════════════════════════════
-- 9) BILLING  (invoices, receipts, third-party charge engines)
-- ════════════════════════════════════════════════════════════
-- The register charges a customer instantly by default. If your
-- server uses a billing / invoice resource (esx_billing, qb-bills,
-- okokBilling, lation_billing, brutal_invoices…) plug it in here.
-- Return true when YOU handled the charge — the encrypted core
-- will skip its built-in cash/bank deduction.

Integrations.Billing = {

    -- Called when an employee uses the register to charge a
    -- customer. Return:
    --   true   → "I handled the charge (invoice/bill sent)" —
    --             skip native cash/bank deduction
    --   false  → "Use the native deduction" — default
    --
    --   src          server id of the EMPLOYEE running the register
    --   targetSrc    server id of the CUSTOMER being charged
    --   jobName      the restaurant's job
    --   amount       total in dollars
    --   payment      'cash' | 'bank'
    --   note         optional free-text reason (e.g. "Order #42")
    OnRegisterCharge = function(src, targetSrc, jobName, amount, payment, note)
        return false

        -- ── Example: esx_billing ─────────────────────────────
        -- if payment ~= 'bank' then return false end          -- only bills for bank
        -- TriggerEvent('esx_billing:sendBill', targetSrc, 'society_' .. jobName,
        --     ('Restaurant — %s'):format(note or 'Order'), amount)
        -- return true

        -- ── Example: qb-bills ────────────────────────────────
        -- exports['qb-bills']:CreateBill(targetSrc, src, jobName, amount, note)
        -- return true

        -- ── Example: okokBilling ─────────────────────────────
        -- exports['okokBilling']:CreateInvoice(targetSrc, src, jobName, amount, note)
        -- return true
    end,

    -- Called when a player BUYS supplies from the NPC supplier.
    -- Hook this if you want supplier purchases to generate an
    -- accountancy document (corporate expense receipt, etc.).
    OnSupplierPurchase = function(src, jobName, items, totalCost)
        -- no-op by default
    end,

    -- Called when payroll runs. Hook this if your server uses an
    -- external paycheck system (e.g. pma-paycheck, esx_addonaccount
    -- audit, your own boii_management contract). Return true to
    -- suppress the built-in paycheck transfer.
    OnPayroll = function(jobName, src, grade, baseAmount)
        return false
    end,
}


-- ════════════════════════════════════════════════════════════
-- 10) ADMIN / PERMISSIONS  (who can open the creator)
-- ════════════════════════════════════════════════════════════
-- The "/restaurantcreator" command (and every editor / job-create /
-- wipe callback) runs through Apex.IsAdmin → Integrations.Admin.
-- IsAuthorised. The default supports FOUR ways to grant access, all
-- driven by Config.creatorAccess and all working on ESX / QBCore / Qbox:
--     1) ACE permission          (framework-independent)
--     2) Admin group             (framework group OR ace group.<name>)
--     3) Job (+ min grade)       (give an owner/management job access)
--     4) Specific identifier      (license / steam / discord / …)
-- ANY match grants access. Edit freely — this file is open source.

Integrations.Admin = {

    -- Returns true if the player may open the editor / wipe data /
    -- create jobs / delete restaurants.
    IsAuthorised = function(src)
        local cfg = (Config and Config.creatorAccess) or {}

        -- 1) ACE permission ────────────────────────────────────
        local ace = cfg.ace
        if (ace == nil) or ace.enabled ~= false then
            local perm = (ace and ace.permission) or Config.adminAce or 'apex_restaurant.admin'
            if IsPlayerAceAllowed(src, perm) then return true end
        end

        -- 2) Admin groups ──────────────────────────────────────
        if type(cfg.groups) == 'table' then
            for _, g in ipairs(cfg.groups) do
                if Bridge and Bridge.HasGroup and Bridge:HasGroup(src, g) then return true end
            end
        end

        -- 3) Job (+ optional minimum grade) ─────────────────────
        if type(cfg.jobs) == 'table' and Bridge and Bridge.GetJob then
            local j = Bridge:GetJob(src) or {}
            local minGrade = cfg.jobs[j.name]
            if minGrade ~= nil and (tonumber(j.grade) or 0) >= (tonumber(minGrade) or 0) then
                return true
            end
        end

        -- 4) Specific identifiers ──────────────────────────────
        if type(cfg.identifiers) == 'table' and #cfg.identifiers > 0 then
            local mine = GetPlayerIdentifiers(src) or {}
            for _, have in ipairs(mine) do
                for _, want in ipairs(cfg.identifiers) do
                    if have == want then return true end
                end
            end
        end

        return false
    end,
}


-- ════════════════════════════════════════════════════════════
-- 11) JOB / GRADE LOOKUP
-- ════════════════════════════════════════════════════════════
-- Useful if your server stores ranks outside the standard
-- ESX/QB tables (e.g. clan/gang management, custom company
-- hierarchy). Default: read straight from the Bridge.

Integrations.Jobs = {

    GetPlayerJob = function(src) return Bridge:GetJob(src) end,

    -- Return true if `src` works at `jobName` AT OR ABOVE `minGrade`.
    HasGrade = function(src, jobName, minGrade)
        local j = Bridge:GetJob(src)
        return j and j.name == jobName and (j.grade or 0) >= (minGrade or 0)
    end,
}


-- ════════════════════════════════════════════════════════════
-- 12) HOOKS / EVENT BROADCAST
-- ════════════════════════════════════════════════════════════
-- Generic "something happened" hooks you can subscribe to from
-- other resources via TriggerEvent / AddEventHandler.
--
-- Every event in this list is fired both LOCAL (TriggerEvent) and
-- NETWORK (TriggerClientEvent / TriggerServerEvent) so your other
-- resources can listen wherever they live.

Integrations.Events = {
    -- Event names. Rename them if they collide with something else
    -- on your server.
    OrderPlaced       = 'apex_restaurant:event:orderPlaced',       -- customer bought from a shop
    DeliveryComplete  = 'apex_restaurant:event:deliveryComplete',  -- delivery finished
    EmployeeHired     = 'apex_restaurant:event:employeeHired',
    EmployeeFired     = 'apex_restaurant:event:employeeFired',
    EmployeePromoted  = 'apex_restaurant:event:employeePromoted',
    EmployeeDemoted   = 'apex_restaurant:event:employeeDemoted',
    SocietyDeposit    = 'apex_restaurant:event:societyDeposit',
    SocietyWithdraw   = 'apex_restaurant:event:societyWithdraw',
    MenuUpdated       = 'apex_restaurant:event:menuUpdated',
    RecipesUpdated    = 'apex_restaurant:event:recipesUpdated',
    LayoutSaved       = 'apex_restaurant:event:layoutSaved',
    RestaurantDeleted = 'apex_restaurant:event:restaurantDeleted',
    RestaurantWiped   = 'apex_restaurant:event:restaurantWiped',
}

-- Tiny helper: broadcast a hook to LOCAL + NETWORK simultaneously
function Integrations.Emit(eventName, payload)
    if IsDuplicityVersion() then
        TriggerEvent(eventName, payload)
        TriggerClientEvent(eventName, -1, payload)
    else
        TriggerEvent(eventName, payload)
        TriggerServerEvent(eventName, payload)
    end
end


-- ════════════════════════════════════════════════════════════
-- END OF FILE — happy hacking 💜
-- ════════════════════════════════════════════════════════════
