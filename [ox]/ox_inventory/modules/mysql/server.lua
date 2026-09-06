if not lib then return end

local Query = {
    SELECT_STASH = 'SELECT data FROM ox_inventory WHERE owner = ? AND name = ?',
    UPDATE_STASH = 'UPDATE ox_inventory SET data = ? WHERE owner = ? AND name = ?',
    UPSERT_STASH =
    'INSERT INTO ox_inventory (data, owner, name) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
    INSERT_STASH = 'INSERT INTO ox_inventory (owner, name) VALUES (?, ?)',
    -- Dynamic, in-game created stashes (definition rows, not item contents).
    SELECT_DYNAMIC_STASHES = 'SELECT * FROM ox_inventory_stashes',
    UPSERT_DYNAMIC_STASH =
    'INSERT INTO ox_inventory_stashes (name, label, owner, slots, maxweight, groups, coords, target, prop, instance, showmarker, createdby) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), owner = VALUES(owner), slots = VALUES(slots), maxweight = VALUES(maxweight), groups = VALUES(groups), coords = VALUES(coords), target = VALUES(target), prop = VALUES(prop), instance = VALUES(instance), showmarker = VALUES(showmarker)',
    DELETE_DYNAMIC_STASH = 'DELETE FROM ox_inventory_stashes WHERE name = ?',
    DELETE_DYNAMIC_STASH_CONTENTS = 'DELETE FROM ox_inventory WHERE name = ? OR name LIKE ?',
    COUNT_DYNAMIC_STASHES = 'SELECT COUNT(*) FROM ox_inventory_stashes',
    COUNT_DYNAMIC_CRAFTING = 'SELECT COUNT(*) FROM ox_inventory_crafting',
    -- Dynamic, in-game created crafting benches.
    SELECT_DYNAMIC_CRAFTING = 'SELECT * FROM ox_inventory_crafting',
    UPSERT_DYNAMIC_CRAFTING =
    'INSERT INTO ox_inventory_crafting (id, label, groups, recipes, coords, target, prop, showmarker, blip, createdby) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), groups = VALUES(groups), recipes = VALUES(recipes), coords = VALUES(coords), target = VALUES(target), prop = VALUES(prop), showmarker = VALUES(showmarker), blip = VALUES(blip)',
    DELETE_DYNAMIC_CRAFTING = 'DELETE FROM ox_inventory_crafting WHERE id = ?',
    -- Dynamic, in-game created shops.
    SELECT_DYNAMIC_SHOPS = 'SELECT * FROM ox_inventory_shops',
    UPSERT_DYNAMIC_SHOP =
    'INSERT INTO ox_inventory_shops (id, label, groups, inventory, coords, prop, ped, showmarker, blip, blipsprite, blipcolor, createdby) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), groups = VALUES(groups), inventory = VALUES(inventory), coords = VALUES(coords), prop = VALUES(prop), ped = VALUES(ped), showmarker = VALUES(showmarker), blip = VALUES(blip), blipsprite = VALUES(blipsprite), blipcolor = VALUES(blipcolor)',
    DELETE_DYNAMIC_SHOP = 'DELETE FROM ox_inventory_shops WHERE id = ?',
    COUNT_DYNAMIC_SHOPS = 'SELECT COUNT(*) FROM ox_inventory_shops',
    -- Global marker / blip appearance (single row).
    SELECT_APPEARANCE = 'SELECT data FROM ox_inventory_appearance WHERE id = 1',
    UPSERT_APPEARANCE =
    'INSERT INTO ox_inventory_appearance (id, data) VALUES (1, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
    SELECT_GLOVEBOX = 'SELECT plate, glovebox FROM `{vehicle_table}` WHERE `{vehicle_column}` = ?',
    SELECT_TRUNK = 'SELECT plate, trunk FROM `{vehicle_table}` WHERE `{vehicle_column}` = ?',
    SELECT_PLAYER = 'SELECT inventory FROM `{user_table}` WHERE `{user_column}` = ?',
    UPDATE_TRUNK = 'UPDATE `{vehicle_table}` SET trunk = ? WHERE `{vehicle_column}` = ?',
    UPDATE_GLOVEBOX = 'UPDATE `{vehicle_table}` SET glovebox = ? WHERE `{vehicle_column}` = ?',
    UPDATE_PLAYER = 'UPDATE `{user_table}` SET inventory = ? WHERE `{user_column}` = ?',
}

Citizen.CreateThreadNow(function()
    local playerTable, playerColumn, vehicleTable, vehicleColumn

    if shared.framework == 'ox' then
        playerTable = 'character_inventory'
        playerColumn = 'charid'
        vehicleTable = 'vehicles'
        vehicleColumn = 'id'
    elseif shared.framework == 'esx' then
        playerTable = 'users'
        playerColumn = 'identifier'
        vehicleTable = 'owned_vehicles'
        vehicleColumn = 'plate'
    elseif shared.framework == 'nd' then
        playerTable = 'nd_characters'
        playerColumn = 'charid'
        vehicleTable = 'nd_vehicles'
        vehicleColumn = 'id'
    elseif shared.framework == 'qbx' then
        playerTable = 'players'
        playerColumn = 'citizenid'
        vehicleTable = 'player_vehicles'
        vehicleColumn = 'id'
    else
        return
    end

    for k, v in pairs(Query) do
        Query[k] = v:gsub('{user_table}', playerTable):gsub('{user_column}', playerColumn):gsub('{vehicle_table}',
            vehicleTable):gsub('{vehicle_column}', vehicleColumn)
    end

    Wait(0)

    local success, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM ox_inventory')

    if not success then
        MySQL.query([[CREATE TABLE `ox_inventory` (
			`owner` varchar(60) DEFAULT NULL,
			`name` varchar(100) NOT NULL,
			`data` longtext DEFAULT NULL,
			`lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
			UNIQUE KEY `owner` (`owner`,`name`)
		)]])
    else
        -- Shouldn't be needed anymore; was used for some data conversion for v2.5.0 (back in March 2022)
        -- result = MySQL.query.await("SELECT owner, name FROM ox_inventory WHERE NOT owner = ''")

        -- if result and next(result) then
        -- 	local parameters = {}
        -- 	local count = 0

        -- 	for i = 1, #result do
        -- 		local data = result[i]
        -- 		local snip = data.name:sub(-#data.owner, #data.name)

        -- 		if data.owner == snip then
        -- 			local name = data.name:sub(0, #data.name - #snip)

        -- 			count += 1
        -- 			parameters[count] = { query = 'UPDATE ox_inventory SET `name` = ? WHERE `owner` = ? AND `name` = ?', values = { name, data.owner, data.name } }
        -- 		end
        -- 	end

        -- 	if #parameters > 0 then
        -- 		MySQL.transaction(parameters)
        -- 	end
        -- end
    end

    result = MySQL.query.await(('SHOW COLUMNS FROM `%s`'):format(vehicleTable))

    if result then
        local glovebox, trunk

        for i = 1, #result do
            local column = result[i]
            if column.Field == 'glovebox' then
                glovebox = true
            elseif column.Field == 'trunk' then
                trunk = true
            end
        end

        if not glovebox then
            MySQL.query(('ALTER TABLE `%s` ADD COLUMN `glovebox` LONGTEXT NULL'):format(vehicleTable))
        end

        if not trunk then
            MySQL.query(('ALTER TABLE `%s` ADD COLUMN `trunk` LONGTEXT NULL'):format(vehicleTable))
        end
    end

    success, result = pcall(MySQL.scalar.await, ('SELECT inventory FROM `%s`'):format(playerTable))

    if not success then
        MySQL.query(('ALTER TABLE `%s` ADD COLUMN `inventory` LONGTEXT NULL'):format(playerTable))
    end

    -- Table that stores in-game created (dynamic) stash definitions.
    local hasDynamicTable = pcall(MySQL.scalar.await, 'SELECT 1 FROM ox_inventory_stashes')

    if not hasDynamicTable then
        MySQL.query([[CREATE TABLE `ox_inventory_stashes` (
			`name` varchar(100) NOT NULL,
			`label` varchar(100) NOT NULL,
			`owner` varchar(16) DEFAULT NULL,
			`slots` int(11) NOT NULL DEFAULT 50,
			`maxweight` int(11) NOT NULL DEFAULT 100000,
			`groups` longtext DEFAULT NULL,
			`coords` longtext DEFAULT NULL,
			`target` longtext DEFAULT NULL,
			`prop` longtext DEFAULT NULL,
			`instance` int(11) DEFAULT NULL,
			`showmarker` tinyint(1) NOT NULL DEFAULT 1,
			`createdby` varchar(60) DEFAULT NULL,
			`createdat` timestamp NULL DEFAULT current_timestamp(),
			PRIMARY KEY (`name`)
		)]])
    else
        pcall(MySQL.query.await, 'ALTER TABLE ox_inventory_stashes ADD COLUMN showmarker tinyint(1) NOT NULL DEFAULT 1')
    end

    -- Table that stores in-game created (dynamic) crafting benches.
    local hasCraftingTable = pcall(MySQL.scalar.await, 'SELECT 1 FROM ox_inventory_crafting')

    if not hasCraftingTable then
        MySQL.query([[CREATE TABLE `ox_inventory_crafting` (
			`id` varchar(100) NOT NULL,
			`label` varchar(100) NOT NULL,
			`groups` longtext DEFAULT NULL,
			`recipes` longtext DEFAULT NULL,
			`coords` longtext DEFAULT NULL,
			`target` longtext DEFAULT NULL,
			`prop` longtext DEFAULT NULL,
			`showmarker` tinyint(1) NOT NULL DEFAULT 1,
			`blip` tinyint(1) NOT NULL DEFAULT 0,
			`createdby` varchar(60) DEFAULT NULL,
			`createdat` timestamp NULL DEFAULT current_timestamp(),
			PRIMARY KEY (`id`)
		)]])
    else
        pcall(MySQL.query.await, 'ALTER TABLE ox_inventory_crafting ADD COLUMN showmarker tinyint(1) NOT NULL DEFAULT 1')
        pcall(MySQL.query.await, 'ALTER TABLE ox_inventory_crafting ADD COLUMN blip tinyint(1) NOT NULL DEFAULT 0')
    end

    -- Table that stores in-game created (dynamic) shops.
    local hasShopsTable = pcall(MySQL.scalar.await, 'SELECT 1 FROM ox_inventory_shops')

    if not hasShopsTable then
        MySQL.query([[CREATE TABLE `ox_inventory_shops` (
			`id` varchar(100) NOT NULL,
			`label` varchar(100) NOT NULL,
			`groups` longtext DEFAULT NULL,
			`inventory` longtext DEFAULT NULL,
			`coords` longtext DEFAULT NULL,
			`prop` longtext DEFAULT NULL,
			`ped` longtext DEFAULT NULL,
			`showmarker` tinyint(1) NOT NULL DEFAULT 1,
			`blip` tinyint(1) NOT NULL DEFAULT 0,
			`blipsprite` int(11) DEFAULT NULL,
			`blipcolor` int(11) DEFAULT NULL,
			`createdby` varchar(60) DEFAULT NULL,
			`createdat` timestamp NULL DEFAULT current_timestamp(),
			PRIMARY KEY (`id`)
		)]])
    else
        pcall(MySQL.query.await, 'ALTER TABLE ox_inventory_shops ADD COLUMN showmarker tinyint(1) NOT NULL DEFAULT 1')
        pcall(MySQL.query.await, 'ALTER TABLE ox_inventory_shops ADD COLUMN blip tinyint(1) NOT NULL DEFAULT 0')
        -- Per-shop map blip sprite/colour (null = fall back to the global appearance).
        pcall(MySQL.query.await, 'ALTER TABLE ox_inventory_shops ADD COLUMN blipsprite int(11) DEFAULT NULL')
        pcall(MySQL.query.await, 'ALTER TABLE ox_inventory_shops ADD COLUMN blipcolor int(11) DEFAULT NULL')
    end

    -- Single-row table that stores the global marker / blip appearance config.
    local hasAppearanceTable = pcall(MySQL.scalar.await, 'SELECT 1 FROM ox_inventory_appearance')

    if not hasAppearanceTable then
        MySQL.query([[CREATE TABLE `ox_inventory_appearance` (
			`id` tinyint(1) NOT NULL DEFAULT 1,
			`data` longtext DEFAULT NULL,
			PRIMARY KEY (`id`)
		)]])
    end

    local clearStashes = GetConvar('inventory:clearstashes', '6 MONTH')

    if clearStashes ~= '' then
        pcall(MySQL.query.await, ('DELETE FROM ox_inventory WHERE lastupdated < (NOW() - INTERVAL %s)'):format(clearStashes))
    end
end)

db = {}

function db.loadPlayer(identifier)
    local inventory = MySQL.prepare.await(Query.SELECT_PLAYER, { identifier }) --[[@as string?]]
    return inventory and json.decode(inventory)
end

function db.savePlayer(owner, inventory)
    return MySQL.prepare(Query.UPDATE_PLAYER, { inventory, owner })
end

function db.saveStash(owner, dbId, inventory)
    return MySQL.prepare(Query.UPSERT_STASH, { inventory, owner and tostring(owner) or '', dbId })
end

function db.loadStash(owner, name)
    return MySQL.prepare.await(Query.SELECT_STASH, { owner and tostring(owner) or '', name })
end

-- Dynamic (in-game created) stash definitions.
function db.loadDynamicStashes()
    return MySQL.query.await(Query.SELECT_DYNAMIC_STASHES) or {}
end

---@param stash table definition row already encoded (groups/coords/target/prop as json strings)
function db.saveDynamicStash(stash)
    return MySQL.prepare.await(Query.UPSERT_DYNAMIC_STASH, {
        stash.name,
        stash.label,
        stash.owner,
        stash.slots,
        stash.maxweight,
        stash.groups,
        stash.coords,
        stash.target,
        stash.prop,
        stash.instance,
        stash.showmarker == false and 0 or 1,
        stash.createdby,
    })
end

function db.deleteDynamicStash(name)
    MySQL.prepare.await(Query.DELETE_DYNAMIC_STASH, { name })
    -- Wipe its stored contents too (shared + every personal `name:owner` row).
    return MySQL.prepare.await(Query.DELETE_DYNAMIC_STASH_CONTENTS, { name, name .. ':%' })
end

function db.countDynamicStashes()
    return MySQL.scalar.await(Query.COUNT_DYNAMIC_STASHES) or 0
end

function db.countDynamicCrafting()
    return MySQL.scalar.await(Query.COUNT_DYNAMIC_CRAFTING) or 0
end

-- Dynamic (in-game created) crafting benches.
function db.loadDynamicCrafting()
    return MySQL.query.await(Query.SELECT_DYNAMIC_CRAFTING) or {}
end

function db.saveDynamicCrafting(bench)
    return MySQL.prepare.await(Query.UPSERT_DYNAMIC_CRAFTING, {
        bench.id,
        bench.label,
        bench.groups,
        bench.recipes,
        bench.coords,
        bench.target,
        bench.prop,
        bench.showmarker == false and 0 or 1,
        bench.blip and 1 or 0,
        bench.createdby,
    })
end

function db.deleteDynamicCrafting(id)
    return MySQL.prepare.await(Query.DELETE_DYNAMIC_CRAFTING, { id })
end

-- Dynamic (in-game created) shops.
function db.loadDynamicShops()
    return MySQL.query.await(Query.SELECT_DYNAMIC_SHOPS) or {}
end

function db.saveDynamicShop(shop)
    return MySQL.prepare.await(Query.UPSERT_DYNAMIC_SHOP, {
        shop.id,
        shop.label,
        shop.groups,
        shop.inventory,
        shop.coords,
        shop.prop,
        shop.ped,
        shop.showmarker == false and 0 or 1,
        shop.blip and 1 or 0,
        shop.blipsprite,
        shop.blipcolor,
        shop.createdby,
    })
end

function db.deleteDynamicShop(id)
    return MySQL.prepare.await(Query.DELETE_DYNAMIC_SHOP, { id })
end

function db.countDynamicShops()
    return MySQL.scalar.await(Query.COUNT_DYNAMIC_SHOPS) or 0
end

-- Global marker / blip appearance (returns the decoded table, or nil if unset).
function db.loadAppearance()
    local data = MySQL.scalar.await(Query.SELECT_APPEARANCE) --[[@as string?]]
    return data and json.decode(data) or nil
end

---@param data table appearance config (marker / blip)
function db.saveAppearance(data)
    return MySQL.prepare.await(Query.UPSERT_APPEARANCE, { json.encode(data) })
end

-- Returns the server's jobs and their grades for the admin UI.
-- ESX reads the `jobs`/`job_grades` tables; QBox/QBCore keep jobs in shared Lua
-- (no DB table), so we pull them from the core export instead. Safe no-op on
-- frameworks we can't enumerate.
function db.getJobsList()
    if shared.framework == 'esx' then
        local ok, jobs = pcall(MySQL.query.await, 'SELECT name, label FROM jobs ORDER BY label')
        if not ok or not jobs then return {} end

        local grades = {}
        local ok2, gradeRows = pcall(MySQL.query.await, 'SELECT job_name, grade, label FROM job_grades ORDER BY job_name, grade')

        if ok2 and gradeRows then
            for i = 1, #gradeRows do
                local g = gradeRows[i]
                grades[g.job_name] = grades[g.job_name] or {}
                grades[g.job_name][#grades[g.job_name] + 1] = { grade = g.grade, label = g.label }
            end
        end

        for i = 1, #jobs do
            jobs[i].grades = grades[jobs[i].name] or {}
        end

        return jobs
    end

    -- QBox / QBCore: jobs live in shared config, exposed via qbx_core:GetJobs()
    -- (or qb-core's Shared.Jobs). Grades are a map keyed by grade number, with the
    -- grade name under `name`.
    if shared.framework == 'qbx' or shared.framework == 'qb' then
        local ok, coreJobs = pcall(function()
            if GetResourceState('qbx_core') == 'started' then return exports.qbx_core:GetJobs() end
            if GetResourceState('qb-core') == 'started' then return exports['qb-core']:GetCoreObject().Shared.Jobs end
            return nil
        end)

        if not ok or type(coreJobs) ~= 'table' then return {} end

        local list, n = {}, 0

        for name, job in pairs(coreJobs) do
            local grades = {}

            if type(job.grades) == 'table' then
                for gradeKey, grade in pairs(job.grades) do
                    grades[#grades + 1] = {
                        grade = tonumber(gradeKey) or 0,
                        label = (type(grade) == 'table' and (grade.name or grade.label)) or tostring(gradeKey),
                    }
                end
                table.sort(grades, function(a, b) return a.grade < b.grade end)
            end

            n += 1
            list[n] = { name = name, label = job.label or name, grades = grades }
        end

        table.sort(list, function(a, b) return (a.label or '') < (b.label or '') end)

        return list
    end

    return {}
end

function db.saveGlovebox(id, inventory)
    return MySQL.prepare(Query.UPDATE_GLOVEBOX, { inventory, id })
end

function db.loadGlovebox(id)
    return MySQL.prepare.await(Query.SELECT_GLOVEBOX, { id })
end

function db.saveTrunk(id, inventory)
    return MySQL.prepare(Query.UPDATE_TRUNK, { inventory, id })
end

function db.loadTrunk(id)
    return MySQL.prepare.await(Query.SELECT_TRUNK, { id })
end

---@param rows number | MySQLQuery | MySQLQuery[]
local function countRows(rows)
    if type(rows) == 'number' then return rows end

    local n = 0

    for i = 1, #rows do
        if rows[i] == 1 then n += 1 end
    end

    return n
end

local function safeQuery(...)
    local ok, resp = pcall(...)

    if not ok then
        return warn(resp)
    end

    return resp
end

---@param players InventorySaveData[]
---@param trunks InventorySaveData[]
---@param gloveboxes InventorySaveData[]
---@param stashes (InventorySaveData | string | number)[]
---@param total number[]
function db.saveInventories(players, trunks, gloveboxes, stashes, total)
    local start = os.nanotime()
    local saveStr = 'Saved %d/%d %s (%.4f ms)'
    local pending = 0

    shared.info(('Saving %s inventories to the database'):format(total[5]))

    if total[1] > 0 then
        pending += 1

        Citizen.CreateThreadNow(function()
            local resp = safeQuery(MySQL.prepare.await, Query.UPDATE_PLAYER, players)
            pending -= 1

            if resp then
                shared.info(saveStr:format(countRows(resp), total[1], 'players', (os.nanotime() - start) / 1e6))
            end
        end)
    end

    if total[2] > 0 then
        pending += 1

        Citizen.CreateThreadNow(function()
            local resp = safeQuery(MySQL.prepare.await, Query.UPDATE_TRUNK, trunks)
            pending -= 1

            if resp then
                shared.info(saveStr:format(countRows(resp), total[2], 'trunks', (os.nanotime() - start) / 1e6))
            end
        end)
    end

    if total[3] > 0 then
        pending += 1

        Citizen.CreateThreadNow(function()
            local resp = safeQuery(MySQL.prepare.await, Query.UPDATE_GLOVEBOX, gloveboxes)
            pending -= 1

            if resp then
                shared.info(saveStr:format(countRows(resp), total[3], 'gloveboxes', (os.nanotime() - start) / 1e6))
            end
        end)
    end

    if total[4] > 0 then
        pending += 1

        if server.bulkstashsave then
            total[4] /= 3

            Citizen.CreateThreadNow(function()
                local query = Query.UPSERT_STASH:gsub('%(%?, %?, %?%)', string.rep('(?, ?, ?)', total[4], ', '))
                local resp = safeQuery(MySQL.query.await, query, stashes)
                pending -= 1

                if resp then
                    local affectedRows = resp.affectedRows

                    if total[4] == 1 then
                        if affectedRows == 2 then affectedRows = 1 end
                    else
                        affectedRows -= tonumber(resp.info:match('Duplicates: (%d+)'), 10) or 0
                    end

                    shared.info(saveStr:format(affectedRows, total[4], 'stashes', (os.nanotime() - start) / 1e6))
                end
            end)
        else
            Citizen.CreateThreadNow(function()
                local resp = safeQuery(MySQL.rawExecute.await, Query.UPSERT_STASH, stashes)
                pending -= 1

                if resp then
                    local affectedRows = 0

                    if table.type(resp) == 'hash' then
                        if resp.affectedRows > 0 then affectedRows = 1 end
                    else
                        for i = 1, #resp do
                            if resp[i].affectedRows > 0 then affectedRows += 1 end
                        end
                    end

                    shared.info(saveStr:format(affectedRows, total[4], 'stashes', (os.nanotime() - start) / 1e6))
                end
            end)
        end
    end

    repeat Wait(0) until pending == 0
end

return db
