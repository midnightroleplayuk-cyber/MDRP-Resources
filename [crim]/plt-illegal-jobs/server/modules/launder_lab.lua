--[[
  Ownable money-laundering lab (server).
  Not a mission — players wash dirty money anytime.
]]

local Inventory = require 'server.modules.inventory'
local SUtils = require 'server.modules.utils'

local Launder = {
    byId = {},
    dirty = {},
    ready = false,
}

local TABLE = 'illegal_launder_props'

local function cfg()
    local job = lib.load('jobs.money_laundering.config')
    return job and job.lab or {}
end

local function notify(src, msg, nType)
    SUtils.server_notify(src, 'Launder Lab', nType or 'inform', msg)
end

local function clamp(v, min, max)
    if v < min then return min end
    if v > max then return max end
    return v
end

local function dist(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    local dz = (a.z or 0.0) - (b.z or 0.0)
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function decodeJson(v, fallback)
    if type(v) == 'string' then
        return json.decode(v) or fallback
    end
    return v or fallback
end

local function publicProp(row)
    return {
        id = tonumber(row.id),
        owner_id = row.owner_id,
        owner_type = row.owner_type,
        prop_type = row.prop_type,
        item_key = row.item_key,
        model = row.model,
        coords = decodeJson(row.coords, {}),
        heading = (row.heading or 0.0) + 0.0,
        parent_id = row.parent_id and tonumber(row.parent_id) or nil,
        money_dirty = row.money_dirty or 0,
        money_clean = row.money_clean or 0,
        chemical_key = row.chemical_key,
        chemical_amt = row.chemical_amt or 0,
        state = decodeJson(row.state, {}),
    }
end

local function defaultState(itemKey)
    local eq = (cfg().equipment or {})[itemKey] or {}
    return {
        -- Always start empty; players must refuel generators after placing
        fuel = 0,
        heat = 0,
        durability = eq.maxDurability or 100,
        is_running = false,
        has_power = false,
        power_load = 0,
        chem_progress = 0,
    }
end

-- Money helpers (uses global Config.DirtyMoney / Config.CleanMoney)
local function getDirty(src)
    if Config.DirtyMoney.isItem then
        return Inventory.getItemCountByName(src, Config.DirtyMoney.itemName)
    end
    return server.getPlayerBalance(src, Config.DirtyMoney.accountName) or 0
end

local function takeDirty(src, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    if Config.DirtyMoney.isItem then
        return Inventory.removeItem(src, Config.DirtyMoney.itemName, amount)
    end
    return server.playerRemoveMoney(src, Config.DirtyMoney.accountName, amount)
end

local function giveDirty(src, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    if Config.DirtyMoney.isItem then
        return Inventory.giveItem(src, Config.DirtyMoney.itemName, amount)
    end
    return server.playerAddMoney(src, Config.DirtyMoney.accountName, amount)
end

local function giveClean(src, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    if Config.CleanMoney.isItem then
        return Inventory.giveItem(src, Config.CleanMoney.itemName, amount)
    end
    return server.playerAddMoney(src, Config.CleanMoney.accountName, amount)
end

-- Ownership
local function jobAllowed(jobName, allowed)
    if not jobName or not allowed then return false end
    if allowed[jobName] == true then return true end
    for i = 1, #allowed do
        if allowed[i] == jobName then return true end
    end
    return false
end

function Launder.getOwnerId(source)
    local own = cfg().ownership or {}
    local mode = own.mode or 'player'
    if mode == 'shared' then return 'shared' end
    if mode == 'player' then
        return server.getPlayerIdentifier(source)
    end
    if mode == 'job' then
        local job = server.getPlayerJob(source)
        if not job or not jobAllowed(job.name, own.allowedJobs) then return nil end
        return 'job:' .. job.name
    end
    if mode == 'group' then
        local ge = own.groupExport or {}
        if not ge.resource or GetResourceState(ge.resource) ~= 'started' then return nil end
        local ok, groupId = pcall(function()
            return exports[ge.resource][ge.export](source)
        end)
        if ok and groupId then return tostring(groupId) end
        return nil
    end
    return server.getPlayerIdentifier(source)
end

function Launder.owns(source, prop)
    local ownerId = Launder.getOwnerId(source)
    return ownerId and prop and prop.owner_id == ownerId
end

--- Same as getOwnerId, but retries briefly if the framework's player lookup
--- comes back empty. A nil identifier here doesn't mean "someone else owns
--- this" — it means the identifier lookup itself failed for a tick — so
--- treating it as a hard ownership mismatch produces false "not yours"
--- errors on a player's own equipment. Only worth the retry on interactive
--- actions a player is actively waiting on (e.g. unitAction).
function Launder.getOwnerIdRetry(source, tries, delayMs)
    tries = tries or 3
    delayMs = delayMs or 150
    for i = 1, tries do
        local ownerId = Launder.getOwnerId(source)
        if ownerId then return ownerId end
        if i < tries then Wait(delayMs) end
    end
    return nil
end

-- Database
local function ensureTable()
    MySQL.query.await(([[
        CREATE TABLE IF NOT EXISTS `%s` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `owner_id` VARCHAR(64) NOT NULL,
            `owner_type` ENUM('player','group') DEFAULT 'player',
            `prop_type` VARCHAR(32) NOT NULL,
            `item_key` VARCHAR(64) NOT NULL,
            `model` VARCHAR(64) NOT NULL,
            `coords` JSON NOT NULL,
            `heading` FLOAT NOT NULL,
            `parent_id` INT DEFAULT NULL,
            `money_dirty` INT NOT NULL DEFAULT 0,
            `money_clean` INT NOT NULL DEFAULT 0,
            `chemical_key` VARCHAR(64) DEFAULT NULL,
            `chemical_amt` INT NOT NULL DEFAULT 0,
            `state` JSON NOT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX `idx_owner` (`owner_id`),
            INDEX `idx_parent` (`parent_id`)
        )
    ]]):format(TABLE))
end

local function loadAll()
    local rows = MySQL.query.await(('SELECT * FROM `%s`'):format(TABLE)) or {}
    Launder.byId = {}
    for i = 1, #rows do
        local row = rows[i]
        row.id = tonumber(row.id)
        row.parent_id = row.parent_id and tonumber(row.parent_id) or nil
        row.money_dirty = tonumber(row.money_dirty) or 0
        row.money_clean = tonumber(row.money_clean) or 0
        row.chemical_amt = tonumber(row.chemical_amt) or 0
        row.coords = decodeJson(row.coords, {})
        row.state = decodeJson(row.state, {}) or {}
        row.state.fuel = tonumber(row.state.fuel) or 0
        row.state.heat = tonumber(row.state.heat) or 0
        row.state.durability = tonumber(row.state.durability) or 100
        row.state.chem_progress = tonumber(row.state.chem_progress) or 0
        row.state.is_running = row.state.is_running == true
        if row.id then Launder.byId[row.id] = row end
    end
end

local function dbInsert(data)
    return MySQL.insert.await(([[
        INSERT INTO `%s`
        (owner_id, owner_type, prop_type, item_key, model, coords, heading, parent_id,
         money_dirty, money_clean, chemical_key, chemical_amt, state)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]]):format(TABLE), {
        data.owner_id, data.owner_type or 'player', data.prop_type, data.item_key, data.model,
        json.encode(data.coords), data.heading, data.parent_id,
        data.money_dirty or 0, data.money_clean or 0, data.chemical_key, data.chemical_amt or 0,
        json.encode(data.state),
    })
end

local function dbSave(row)
    MySQL.update.await(([[
        UPDATE `%s` SET parent_id=?, money_dirty=?, money_clean=?, chemical_key=?, chemical_amt=?,
        state=?, coords=?, heading=? WHERE id=?
    ]]):format(TABLE), {
        row.parent_id, row.money_dirty or 0, row.money_clean or 0, row.chemical_key, row.chemical_amt or 0,
        json.encode(row.state or {}), json.encode(row.coords or {}), row.heading, row.id,
    })
end

local function dbDelete(id)
    MySQL.update.await(('DELETE FROM `%s` WHERE id = ?'):format(TABLE), { id })
end

local function markDirty(id) Launder.dirty[id] = true end

local function flushDirty()
    local changed = {}
    for id in pairs(Launder.dirty) do
        local prop = Launder.byId[id]
        if prop then
            dbSave(prop)
            changed[#changed + 1] = publicProp(prop)
        end
    end
    Launder.dirty = {}
    return changed
end

local function syncAll(target)
    local list = {}
    for _, prop in pairs(Launder.byId) do
        list[#list + 1] = publicProp(prop)
    end
    TriggerClientEvent(_e('client:launder:syncProps'), target or -1, list, true)
end

local function syncChanged(changed)
    if changed and #changed > 0 then
        TriggerClientEvent(_e('client:launder:syncProps'), -1, changed, false)
    end
end

local function getByOwner(ownerId)
    local list = {}
    for _, prop in pairs(Launder.byId) do
        if prop.owner_id == ownerId then list[#list + 1] = prop end
    end
    return list
end

local function findNearestGenerator(ownerId, coords)
    local bestId, bestDist = nil, 999999.0
    for _, prop in pairs(Launder.byId) do
        if prop.owner_id == ownerId and prop.prop_type == 'generator' then
            local d = dist(coords, prop.coords)
            if d < bestDist then bestDist, bestId = d, prop.id end
        end
    end
    return bestId
end

--- Wire any machine/fan/press that has no parent_id to the nearest generator.
local function autoWireOrphans(ownerId)
    if not ownerId or not cfg().autoWireNearest then return {} end
    local changed = {}
    for _, prop in ipairs(getByOwner(ownerId)) do
        local ptype = prop.prop_type
        if (ptype == 'machine' or ptype == 'fan' or ptype == 'collector') and not prop.parent_id then
            local genId = findNearestGenerator(ownerId, prop.coords)
            if genId then
                prop.parent_id = genId
                dbSave(prop)
                changed[#changed + 1] = publicProp(prop)
            end
        end
    end
    return changed
end

local function updatePower(ownerId)
    local generators, machines, fans, collectors = {}, {}, {}, {}
    for _, prop in pairs(Launder.byId) do
        if prop.owner_id == ownerId then
            if prop.prop_type == 'generator' then generators[#generators + 1] = prop
            elseif prop.prop_type == 'machine' then machines[#machines + 1] = prop
            elseif prop.prop_type == 'fan' then fans[#fans + 1] = prop
            elseif prop.prop_type == 'collector' then collectors[#collectors + 1] = prop
            end
        end
    end

    local genPower, genLoad, overload = {}, {}, {}
    local equipment = cfg().equipment or {}

    for i = 1, #generators do
        local g = generators[i]
        local eq = equipment[g.item_key] or {}
        g.state = g.state or {}
        local running = g.state.is_running and (g.state.fuel or 0) > 0
        genPower[g.id] = running and (eq.maxPower or 0) or 0
        genLoad[g.id] = 0
        g.state.has_power = running
    end

    local function addLoad(prop)
        local parent = prop.parent_id and tonumber(prop.parent_id) or nil
        prop.state = prop.state or {}
        if not parent or (genPower[parent] or 0) <= 0 then
            prop.state.has_power = false
            return
        end
        local eq = equipment[prop.item_key] or {}
        if prop.state.is_running then
            genLoad[parent] = (genLoad[parent] or 0) + (eq.powerDraw or 0)
        end
        prop.state.has_power = true
    end

    for i = 1, #machines do addLoad(machines[i]) end
    for i = 1, #fans do addLoad(fans[i]) end
    for i = 1, #collectors do
        local c = collectors[i]
        local parent = c.parent_id and tonumber(c.parent_id) or nil
        c.state = c.state or {}
        c.state.has_power = parent and (genPower[parent] or 0) > 0 or false
    end

    for id, power in pairs(genPower) do
        local load = genLoad[id] or 0
        overload[id] = (power > 0) and (load > power and (power / load) or 1.0) or 0.0
        local g = Launder.byId[id]
        if g then
            g.state = g.state or {}
            g.state.power_load = load
            g.state.has_power = power > 0
            markDirty(id)
        end
    end

    return { generators = generators, machines = machines, fans = fans, collectors = collectors, overload = overload }
end

local function findCollector(machine, collectors)
    local parent = machine.parent_id and tonumber(machine.parent_id) or nil
    if not parent then return nil end
    local best, bestDist = nil, 999999.0
    for i = 1, #collectors do
        local c = collectors[i]
        if tonumber(c.parent_id) == parent then
            local d = dist(machine.coords, c.coords)
            if d < bestDist then bestDist, best = d, c end
        end
    end
    return best
end

local function syncOne(src, prop)
    markDirty(prop.id)
    dbSave(prop)
    Launder.dirty[prop.id] = nil
    syncChanged({ publicProp(prop) })
    TriggerClientEvent(_e('client:launder:syncPropNui'), src, publicProp(prop))
end

-- Actions
local Actions = {}

function Actions.toggle(src, prop)
    prop.state = prop.state or {}
    if prop.prop_type == 'generator' and not prop.state.is_running and (prop.state.fuel or 0) <= 0 then
        notify(src, 'Generator needs fuel.', 'error')
        return
    end
    prop.state.is_running = not prop.state.is_running

    if prop.state.is_running then
        updatePower(prop.owner_id)
        if prop.prop_type == 'machine' then
            local blockers = {}
            if not prop.parent_id then blockers[#blockers + 1] = 'not linked to a generator' end
            if not prop.state.has_power then blockers[#blockers + 1] = 'no power (start generator with fuel)' end
            if (prop.money_dirty or 0) <= 0 then blockers[#blockers + 1] = 'no dirty money loaded' end
            if (prop.chemical_amt or 0) <= 0 then blockers[#blockers + 1] = 'no chemical loaded' end
            if (prop.state.durability or 0) <= 0 then blockers[#blockers + 1] = 'broken (needs repair)' end
            if #blockers > 0 then
                notify(src, ('Washer started but idle: %s.'):format(table.concat(blockers, ', ')), 'inform')
            else
                notify(src, 'Washer started — processing dirty money.', 'success')
            end
        else
            notify(src, 'Unit started.', 'success')
        end
    else
        notify(src, 'Unit stopped.', 'success')
    end
    syncOne(src, prop)
end

function Actions.load_dirty(src, prop, payload)
    if prop.prop_type ~= 'machine' then return end
    local amount = math.floor(tonumber(payload and payload.amount) or 0)
    if amount <= 0 then notify(src, 'Invalid amount.', 'error') return end
    local eq = (cfg().equipment or {})[prop.item_key] or {}
    local space = (eq.maxDirty or 25000) - (prop.money_dirty or 0)
    amount = math.min(amount, space, getDirty(src))
    if amount <= 0 then notify(src, 'Not enough dirty money.', 'error') return end
    if not takeDirty(src, amount) then notify(src, 'Not enough dirty money.', 'error') return end
    prop.money_dirty = (prop.money_dirty or 0) + amount
    notify(src, ('Loaded $%s dirty money.'):format(amount), 'success')
    syncOne(src, prop)
end

function Actions.load_chemical(src, prop, payload)
    if prop.prop_type ~= 'machine' then return end
    local chemicalKey = payload and payload.chemicalKey
    local amount = math.max(1, math.floor(tonumber(payload and payload.amount) or 1))
    local chem = (cfg().chemicals or {})[chemicalKey]
    if not chem then notify(src, 'Missing chemical.', 'error') return end
    if prop.chemical_key and prop.chemical_key ~= chemicalKey and (prop.chemical_amt or 0) > 0 then
        notify(src, 'Empty current chemical first.', 'error')
        return
    end
    if not Inventory.hasItem(src, chemicalKey, amount) then notify(src, 'Missing chemical.', 'error') return end
    if not Inventory.removeItem(src, chemicalKey, amount) then return end
    prop.chemical_key = chemicalKey
    prop.chemical_amt = (prop.chemical_amt or 0) + amount
    prop.state = prop.state or {}
    prop.state.chem_progress = prop.state.chem_progress or 0
    notify(src, 'Loaded chemical.', 'success')
    syncOne(src, prop)
end

function Actions.collect(src, prop)
    if prop.prop_type ~= 'machine' and prop.prop_type ~= 'collector' then return end
    local amount = math.floor(prop.money_clean or 0)
    if amount <= 0 then notify(src, 'Nothing to collect.', 'error') return end
    if not giveClean(src, amount) then notify(src, 'Inventory full.', 'error') return end
    prop.money_clean = 0
    notify(src, ('Collected $%s clean money.'):format(amount), 'success')
    syncOne(src, prop)
end

function Actions.collect_partial(src, prop, payload)
    if prop.prop_type ~= 'machine' and prop.prop_type ~= 'collector' then return end
    local amount = math.floor(tonumber(payload and payload.amount) or 0)
    local available = math.floor(prop.money_clean or 0)
    if amount <= 0 or amount > available then notify(src, 'Invalid amount.', 'error') return end
    if not giveClean(src, amount) then notify(src, 'Inventory full.', 'error') return end
    prop.money_clean = available - amount
    notify(src, ('Collected $%s clean money.'):format(amount), 'success')
    syncOne(src, prop)
end

function Actions.refuel(src, prop)
    if prop.prop_type ~= 'generator' then return end
    local maint = (cfg().maintenance or {}).fuel_can
    if not maint then return end
    if not Inventory.hasItem(src, 'fuel_can', 1) then notify(src, 'Missing fuel can.', 'error') return end
    if not Inventory.removeItem(src, 'fuel_can', 1) then return end
    local eq = (cfg().equipment or {})[prop.item_key] or {}
    prop.state = prop.state or {}
    prop.state.fuel = clamp((prop.state.fuel or 0) + (maint.fuelAmount or 40), 0, eq.maxFuel or 100)
    notify(src, 'Generator refueled.', 'success')
    syncOne(src, prop)
end

function Actions.repair(src, prop)
    local maint = (cfg().maintenance or {}).repair_kit
    if not maint then return end
    if not Inventory.hasItem(src, 'repair_kit', 1) then notify(src, 'Missing repair kit.', 'error') return end
    if not Inventory.removeItem(src, 'repair_kit', 1) then return end
    local eq = (cfg().equipment or {})[prop.item_key] or {}
    prop.state = prop.state or {}
    prop.state.durability = clamp((prop.state.durability or 0) + (maint.repairAmount or 35), 0, eq.maxDurability or 100)
    notify(src, 'Unit repaired.', 'success')
    syncOne(src, prop)
end

function Actions.pickup(src, prop)
    if (prop.money_dirty or 0) > 0 or (prop.money_clean or 0) > 0 or (prop.chemical_amt or 0) > 0 then
        notify(src, 'Empty the unit before packing it.', 'error')
        return
    end
    if prop.state then prop.state.is_running = false end
    if not Inventory.giveItem(src, prop.item_key, 1) then notify(src, 'Inventory full.', 'error') return end
    local id = prop.id
    Launder.byId[id] = nil
    Launder.dirty[id] = nil
    dbDelete(id)
    TriggerClientEvent(_e('client:launder:removeProp'), -1, id)
    notify(src, 'Equipment packed.', 'success')
end

function Launder.init()
    if Launder.ready then return end
    ensureTable()
    loadAll()
    Launder.ready = true

    local lab = cfg()
    for key in pairs(lab.equipment or {}) do
        server.createUseableItem(key, function(source)
            TriggerClientEvent(_e('client:launder:startPlacement'), source, key)
        end)
    end

    CreateThread(function()
        while true do
            -- Re-read config each tick so washScale / tickMs changes apply without restart
            lab = cfg()
            Wait(lab.tickMs or 5000)

            -- Always process owners that have running gear (do NOT require standing in the lab).
            -- Presence-only ticking left machines "Running" overnight with $0 washed.
            local active = {}
            for _, prop in pairs(Launder.byId) do
                if prop.state and prop.state.is_running then
                    active[prop.owner_id] = true
                end
            end

            local equipment = lab.equipment or {}
            local chemicals = lab.chemicals or {}
            local tickSec = (lab.tickMs or 5000) / 1000.0
            -- Amount washed per tick at speed=300, powerMult=1
            -- Default ~$1500 / 5s so progress is visible
            local washScale = lab.washScale or 300

            for ownerId in pairs(active) do
                local wired = autoWireOrphans(ownerId)
                if #wired > 0 then syncChanged(wired) end
                local net = updatePower(ownerId)
                local overload = net.overload or {}

                for i = 1, #net.generators do
                    local g = net.generators[i]
                    local eq = equipment[g.item_key] or {}
                    g.state = g.state or {}
                    if g.state.is_running then
                        g.state.fuel = clamp((tonumber(g.state.fuel) or 0) - (eq.fuelBurnPerTick or 1.0), 0, eq.maxFuel or 100)
                        if g.state.fuel <= 0 then
                            g.state.is_running = false
                            g.state.has_power = false
                            g.state.fuel = 0
                        end
                        g.state.durability = clamp((tonumber(g.state.durability) or 100) - 0.05, 0, eq.maxDurability or 100)
                        markDirty(g.id)
                    end
                end

                -- Refresh power after possible fuel cut-off this tick
                net = updatePower(ownerId)
                overload = net.overload or {}

                local fanZones = {}
                for i = 1, #net.fans do
                    local f = net.fans[i]
                    f.state = f.state or {}
                    local eq = equipment[f.item_key] or {}
                    if f.state.has_power and f.state.is_running and (tonumber(f.state.durability) or 0) > 0 then
                        fanZones[#fanZones + 1] = { coords = f.coords, coolRate = eq.coolRate or 4 }
                        f.state.durability = clamp((tonumber(f.state.durability) or 100) - 0.02, 0, eq.maxDurability or 100)
                        markDirty(f.id)
                    end
                end

                local function coolingAt(coords)
                    local cool = 0
                    for i = 1, #fanZones do
                        if dist(coords, fanZones[i].coords) <= (lab.fanRadius or 10.0) then
                            cool = cool + fanZones[i].coolRate
                        end
                    end
                    return cool
                end

                for i = 1, #net.machines do
                    local m = net.machines[i]
                    local eq = equipment[m.item_key] or {}
                    m.state = m.state or {}
                    m.money_dirty = tonumber(m.money_dirty) or 0
                    m.money_clean = tonumber(m.money_clean) or 0
                    m.chemical_amt = tonumber(m.chemical_amt) or 0

                    local parentId = m.parent_id and tonumber(m.parent_id) or nil
                    local powerMult = parentId and (overload[parentId] or 0.0) or 0.0
                    local canRun = m.state.is_running and m.state.has_power and powerMult > 0
                        and m.money_dirty > 0 and m.chemical_amt > 0 and (tonumber(m.state.durability) or 0) > 0

                    if canRun then
                        local perChem = lab.dirtyPerChemical or 15000
                        local chemProgress = tonumber(m.state.chem_progress) or 0
                        local chemCapacity = math.max(0, (m.chemical_amt * perChem) - chemProgress)
                        local rate = math.floor(((eq.speed or 300) / 300.0) * powerMult * tickSec * washScale)
                        local washAmount = math.min(m.money_dirty, chemCapacity, math.max(0, rate))

                        if washAmount > 0 then
                            local chem = chemicals[m.chemical_key]
                            local efficiency = chem and chem.efficiency or 0.8
                            local cleanGain = math.floor(washAmount * efficiency)
                            m.money_dirty = m.money_dirty - washAmount

                            chemProgress = chemProgress + washAmount
                            local chemUsed = math.floor(chemProgress / perChem)
                            if chemUsed > 0 then
                                chemUsed = math.min(chemUsed, m.chemical_amt)
                                m.chemical_amt = m.chemical_amt - chemUsed
                                chemProgress = chemProgress - (chemUsed * perChem)
                            end
                            m.state.chem_progress = chemProgress
                            if m.chemical_amt <= 0 then
                                m.chemical_key = nil
                                m.chemical_amt = 0
                                m.state.chem_progress = 0
                            end

                            local collector = findCollector(m, net.collectors)
                            if collector then
                                collector.money_clean = tonumber(collector.money_clean) or 0
                                local ceq = equipment[collector.item_key] or {}
                                local space = (ceq.maxClean or 250000) - collector.money_clean
                                local toVault = math.min(cleanGain, math.max(0, space))
                                collector.money_clean = collector.money_clean + toVault
                                local leftover = cleanGain - toVault
                                if leftover > 0 then
                                    m.money_clean = math.min(eq.maxClean or 25000, m.money_clean + leftover)
                                end
                                markDirty(collector.id)
                            else
                                m.money_clean = math.min(eq.maxClean or 25000, m.money_clean + cleanGain)
                            end
                        end

                        local heatGain = (lab.baseHeatRate or 2) * powerMult
                        m.state.heat = clamp((tonumber(m.state.heat) or 0) + heatGain - coolingAt(m.coords), 0, 100)
                        local durabilityLoss = 0.1 * powerMult
                        if (m.state.heat or 0) >= (lab.heatDamageThreshold or 90) then
                            durabilityLoss = durabilityLoss + 0.5
                        end
                        m.state.durability = clamp((tonumber(m.state.durability) or 100) - durabilityLoss, 0, eq.maxDurability or 100)
                        if m.state.durability <= 0 then m.state.is_running = false end
                        markDirty(m.id)
                    elseif m.state.is_running then
                        -- Still "running" in UI but blocked — keep heat cool-down and persist power flag
                        if (tonumber(m.state.heat) or 0) > 0 then
                            m.state.heat = clamp((tonumber(m.state.heat) or 0) - 1 - coolingAt(m.coords), 0, 100)
                        end
                        markDirty(m.id)
                    elseif (tonumber(m.state.heat) or 0) > 0 then
                        m.state.heat = clamp((tonumber(m.state.heat) or 0) - 1 - coolingAt(m.coords), 0, 100)
                        markDirty(m.id)
                    end
                end
            end

            syncChanged(flushDirty())
        end
    end)

    syncAll(-1)
    lib.print.info(('[launder-lab] Ready with %s props'):format(
        (function() local n = 0 for _ in pairs(Launder.byId) do n = n + 1 end return n end)()
    ))
end

-- Events
RegisterNetEvent(_e('server:launder:placeProp'), function(payload)
    local src = source
    payload = payload or {}
    local lab = cfg()
    local itemKey = payload.itemKey
    local eq = (lab.equipment or {})[itemKey]
    if not eq then notify(src, 'Invalid equipment.', 'error') return end

    local ownerId = Launder.getOwnerId(src)
    if not ownerId then notify(src, 'No lab access.', 'error') return end
    if not Inventory.hasItem(src, itemKey, 1) then notify(src, 'Missing item.', 'error') return end

    local coords = payload.coords
    if type(coords) ~= 'table' or not coords.x then notify(src, 'Invalid placement.', 'error') return end
    local interior = lab.interior
    if dist(coords, { x = interior.x, y = interior.y, z = interior.z }) > (lab.activityRadius or 50.0) then
        notify(src, 'Place equipment inside the lab.', 'error')
        return
    end

    if not Inventory.removeItem(src, itemKey, 1) then return end

    local parentId = nil
    if lab.autoWireNearest and (eq.prop_type == 'machine' or eq.prop_type == 'collector' or eq.prop_type == 'fan') then
        parentId = findNearestGenerator(ownerId, coords)
    end

    local data = {
        owner_id = ownerId,
        owner_type = ((lab.ownership or {}).mode == 'player') and 'player' or 'group',
        prop_type = eq.prop_type,
        item_key = itemKey,
        model = eq.model,
        coords = { x = coords.x + 0.0, y = coords.y + 0.0, z = coords.z + 0.0 },
        heading = tonumber(payload.heading) or 0.0,
        parent_id = parentId,
        money_dirty = 0,
        money_clean = 0,
        chemical_key = nil,
        chemical_amt = 0,
        state = defaultState(itemKey),
    }
    local id = dbInsert(data)
    if not id then
        Inventory.giveItem(src, itemKey, 1)
        notify(src, 'Failed to place.', 'error')
        return
    end
    data.id = id
    Launder.byId[id] = data
    local changed = { publicProp(data) }
    if eq.prop_type == 'generator' then
        local wired = autoWireOrphans(ownerId)
        for i = 1, #wired do changed[#changed + 1] = wired[i] end
    end
    notify(src, 'Equipment placed.', 'success')
    syncChanged(changed)
end)

RegisterNetEvent(_e('server:launder:unitAction'), function(payload)
    local src = source
    payload = payload or {}
    local prop = Launder.byId[tonumber(payload.propId)]
    if not prop then
        notify(src, 'This equipment is not yours.', 'error')
        return
    end

    -- Retry the identifier lookup before failing — a nil result here means
    -- the framework player lookup missed for a tick, not that this is
    -- someone else's equipment (see Launder.getOwnerIdRetry).
    local ownerId = Launder.getOwnerIdRetry(src)
    if not ownerId then
        notify(src, 'Player data not ready — try again in a moment.', 'error')
        return
    end
    if prop.owner_id ~= ownerId then
        notify(src, 'This equipment is not yours.', 'error')
        return
    end

    local fn = Actions[payload.action]
    if fn then fn(src, prop, payload.payload or payload) end
end)

RegisterNetEvent(_e('server:launder:saveConnections'), function(connections)
    local src = source
    local ownerId = Launder.getOwnerId(src)
    if not ownerId then return end
    connections = connections or {}
    local changed = {}
    for i = 1, #connections do
        local c = connections[i]
        local fromProp = Launder.byId[tonumber(c.fromId)]
        local toProp = Launder.byId[tonumber(c.toId)]
        -- Accept either consumer→generator or generator→consumer
        local consumer, generator = fromProp, toProp
        if fromProp and toProp then
            if fromProp.prop_type == 'generator' and toProp.prop_type ~= 'generator' then
                consumer, generator = toProp, fromProp
            end
        end
        if consumer and generator and consumer.owner_id == ownerId and generator.owner_id == ownerId
            and generator.prop_type == 'generator' and consumer.prop_type ~= 'generator' then
            consumer.parent_id = generator.id
            dbSave(consumer)
            changed[#changed + 1] = publicProp(consumer)
        end
    end
    if #changed > 0 then
        syncChanged(changed)
        notify(src, 'Power connections saved.', 'success')
    end
end)

RegisterNetEvent(_e('server:launder:requestMonitor'), function()
    local src = source
    local ownerId = Launder.getOwnerId(src)
    if not ownerId then notify(src, 'No lab access.', 'error') return end
    local list = {}
    for _, prop in ipairs(getByOwner(ownerId)) do
        list[#list + 1] = publicProp(prop)
    end
    TriggerClientEvent(_e('client:launder:openMonitor'), src, list)
end)

RegisterNetEvent(_e('server:launder:requestSync'), function()
    syncAll(source)
end)

RegisterNetEvent(_e('server:launder:requestDashboard'), function()
    local src = source
    local ownerId = Launder.getOwnerId(src)
    local lab = cfg()
    local props = {}
    if ownerId then
        local wired = autoWireOrphans(ownerId)
        if #wired > 0 then syncChanged(wired) end
        for _, prop in ipairs(getByOwner(ownerId)) do
            props[#props + 1] = publicProp(prop)
        end
    end
    TriggerClientEvent(_e('client:launder:dashboard'), src, {
        dirtyBalance = getDirty(src),
        props = props,
        entry = lab.entry,
        equipment = lab.equipment,
        chemicals = lab.chemicals,
        maintenance = lab.maintenance,
    })
end)

AddEventHandler('playerJoining', function()
    local src = source
    SetTimeout(5000, function()
        if Launder.ready then syncAll(src) end
    end)
end)

return Launder
