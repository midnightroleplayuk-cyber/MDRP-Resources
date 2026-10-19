-- ============================================================
-- Apex Admin Menu — added server features
-- ------------------------------------------------------------
-- Everything here is framework-agnostic: it routes through the
-- bridge helpers (GetPlayer / GetIdentifier / RemoveMoney /
-- GetPlayerAccountFunds …) which are implemented for ESX, QBCore
-- and QBox. The only direct DB access is the owned-vehicles
-- feature, which branches on the active Framework string and uses
-- table/column names from Config.OwnedVehicles.
-- ============================================================

local function logAction(title, description, fields, logType, color)
    if SendDiscordLog then
        SendDiscordLog(title, description, fields or {}, logType, color)
    end
end

-- ============================================================
-- 1) DIMENSIONS / ROUTING BUCKETS
-- ============================================================
local function clampBucket(bucket)
    bucket = math.floor(tonumber(bucket) or 0)
    if bucket < 0 then bucket = 0 end
    local cap = (Config.Dimensions and Config.Dimensions.max) or 1000
    if bucket > cap then bucket = cap end
    return bucket
end

-- Set the admin's own dimension.
RegisterNetEvent('apex_adminmenu:setSelfDimension', function(bucket)
    local src = source
    if not AdminPerms(src) then return end
    if not Config.Dimensions or not Config.Dimensions.enabled then return end

    bucket = clampBucket(bucket)
    SetPlayerRoutingBucket(src, bucket)

    TriggerClientEvent('apex_adminmenu:notify', src, Strings.notify_dimension,
        Strings.notify_dimension_self_desc:format(bucket), 'success', 'fa-check')

    logAction('Admin Action: Dimension', 'Admin changed their own dimension',
        { { name = 'Dimension', value = tostring(bucket), inline = true } }, 'utilityActions')
end)

-- Set a target player's dimension.
RegisterNetEvent('apex_adminmenu:setPlayerDimension', function(target, bucket)
    local src = source
    if not AdminPerms(src) then return end
    if not Config.Dimensions or not Config.Dimensions.enabled then return end
    target = tonumber(target)
    if not target or not GetPlayer(target) then return end

    bucket = clampBucket(bucket)
    SetPlayerRoutingBucket(target, bucket)

    TriggerClientEvent('apex_adminmenu:notify', src, Strings.notify_dimension,
        Strings.notify_dimension_player_desc:format(GetPlayerName(target), bucket), 'success', 'fa-check')

    logAction('Admin Action: Dimension', 'Admin changed a player\'s dimension', {
        { name = 'Target Player', value = GetPlayerName(target) .. ' (ID: ' .. target .. ')', inline = true },
        { name = 'Dimension', value = tostring(bucket), inline = true }
    }, 'utilityActions')
end)

-- Bring a player into the admin's current dimension, or join theirs.
RegisterNetEvent('apex_adminmenu:dimensionAction', function(target, mode)
    local src = source
    if not AdminPerms(src) then return end
    if not Config.Dimensions or not Config.Dimensions.enabled then return end
    target = tonumber(target)
    if not target or not GetPlayer(target) then return end

    if mode == 'bring' then
        local bucket = GetPlayerRoutingBucket(src)
        SetPlayerRoutingBucket(target, bucket)
        TriggerClientEvent('apex_adminmenu:notify', src, Strings.notify_dimension,
            Strings.notify_dimension_player_desc:format(GetPlayerName(target), bucket), 'success', 'fa-check')
    elseif mode == 'goto' then
        local bucket = GetPlayerRoutingBucket(target)
        SetPlayerRoutingBucket(src, bucket)
        TriggerClientEvent('apex_adminmenu:notify', src, Strings.notify_dimension,
            Strings.notify_dimension_join_desc:format(GetPlayerName(target), bucket), 'success', 'fa-check')
    end
end)

-- ============================================================
-- 2) REMOVE MONEY (take from cash / bank / black money)
-- ============================================================
lib.callback.register('apex_adminmenu:removeMoney', function(source, target, account, amount)
    if not HasActionPermission(source, 'giveMoney') then return false end
    target = tonumber(target)
    if not target or not GetPlayer(target) then return false end

    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end

    -- Never push an account negative — cap to what they actually have.
    local funds = GetPlayerAccountFunds(target, account) or 0
    if amount > funds then amount = funds end
    if amount <= 0 then return false end

    RemoveMoney(target, account, amount)

    logAction('Admin Action: Remove Money', 'Admin removed money from a player', {
        { name = 'Target Player', value = GetPlayerName(target) .. ' (ID: ' .. target .. ')', inline = true },
        { name = 'Account', value = tostring(account), inline = true },
        { name = 'Amount', value = '$' .. amount, inline = true }
    }, 'moneyActions', 15158332)

    return amount
end)

-- ============================================================
-- 3) TELEPORT INTO A PLAYER'S VEHICLE — coordinate lookup
-- ============================================================
lib.callback.register('apex_adminmenu:getPlayerCoords', function(source, target)
    if not AdminPerms(source) then return false end
    target = tonumber(target)
    if not target then return false end
    local ped = GetPlayerPed(target)
    if not ped or ped == 0 then return false end
    local c = GetEntityCoords(ped)
    return { x = c.x, y = c.y, z = c.z }
end)

-- ============================================================
-- 4) GIVE PED MENU TO A PLAYER
-- ============================================================
RegisterNetEvent('apex_adminmenu:givePedMenu', function(target)
    local src = source
    if not AdminPerms(src) then return end
    target = tonumber(target)
    if not target or not GetPlayer(target) then return end

    TriggerClientEvent('apex_adminmenu:openPedMenu', target)
    TriggerClientEvent('apex_adminmenu:notify', src, Strings.pedmenu_given,
        Strings.pedmenu_given_desc:format(GetPlayerName(target)), 'success', 'fa-check')

    logAction('Admin Action: Ped Menu', 'Admin opened a ped menu for a player', {
        { name = 'Target Player', value = GetPlayerName(target) .. ' (ID: ' .. target .. ')', inline = true }
    }, 'playerActions')
end)

-- ============================================================
-- 5) OWNED VEHICLES — view / add / remove (database)
-- ============================================================
local function ownedEnabled()
    return Config.OwnedVehicles and Config.OwnedVehicles.enabled
end

-- Returns { { plate = '...', label = '...' }, ... }
lib.callback.register('apex_adminmenu:getOwnedVehicles', function(source, target)
    if not AdminPerms(source) then return {} end
    if not ownedEnabled() then return {} end
    target = tonumber(target)
    local identifier = target and GetIdentifier(target)
    if not identifier then return {} end

    local result = {}

    if Framework == 'esx' then
        local c = Config.OwnedVehicles.esx
        local query = ('SELECT `%s` AS plate, `%s` AS data FROM `%s` WHERE `%s` = ?')
            :format(c.plateColumn, c.dataColumn, c.table, c.ownerColumn)
        local rows = MySQL.query.await(query, { identifier }) or {}
        for i = 1, #rows do
            local plate = rows[i].plate and tostring(rows[i].plate):gsub('%s+$', '') or 'UNKNOWN'
            local label = plate
            if rows[i].data then
                local ok, props = pcall(json.decode, rows[i].data)
                if ok and type(props) == 'table' and props.model and type(props.model) == 'string' then
                    label = props.model .. ' [' .. plate .. ']'
                end
            end
            result[#result + 1] = { plate = plate, label = label }
        end
    else
        -- QBCore / QBox share the player_vehicles schema.
        local c = Config.OwnedVehicles.qb
        local query = ('SELECT `%s` AS plate, `%s` AS model FROM `%s` WHERE `%s` = ?')
            :format(c.plateColumn, c.modelColumn, c.table, c.ownerColumn)
        local rows = MySQL.query.await(query, { identifier }) or {}
        for i = 1, #rows do
            local plate = rows[i].plate and tostring(rows[i].plate):gsub('%s+$', '') or 'UNKNOWN'
            local label = rows[i].model and (tostring(rows[i].model) .. ' [' .. plate .. ']') or plate
            result[#result + 1] = { plate = plate, label = label }
        end
    end

    return result
end)

lib.callback.register('apex_adminmenu:addOwnedVehicle', function(source, target, model, plate)
    if not AdminPerms(source) then return false end
    if not ownedEnabled() then return false end
    target = tonumber(target)
    local player = target and GetPlayer(target)
    local identifier = target and GetIdentifier(target)
    if not identifier then return false end

    model = tostring(model or ''):gsub('%s+', ''):lower()
    if model == '' then return false end
    plate = (plate and plate ~= '' and tostring(plate):upper():sub(1, 8)) or ('ADM' .. math.random(1000, 9999))
    local hash = joaat(model)

    local success = false

    if Framework == 'esx' then
        local c = Config.OwnedVehicles.esx
        local props = json.encode({ model = hash, plate = plate })
        -- Preferred insert (esx_legacy owned_vehicles has type/stored).
        success = pcall(function()
            MySQL.insert.await(
                ('INSERT INTO `%s` (`%s`, `%s`, `%s`, `type`, `stored`) VALUES (?, ?, ?, ?, ?)')
                    :format(c.table, c.ownerColumn, c.plateColumn, c.dataColumn),
                { identifier, plate, props, 'car', 1 })
        end)
        -- Fallback for slimmer schemas (owner/plate/vehicle only).
        if not success then
            success = pcall(function()
                MySQL.insert.await(
                    ('INSERT INTO `%s` (`%s`, `%s`, `%s`) VALUES (?, ?, ?)')
                        :format(c.table, c.ownerColumn, c.plateColumn, c.dataColumn),
                    { identifier, plate, props })
            end)
        end
    else
        local c = Config.OwnedVehicles.qb
        local license = (player and player.PlayerData and player.PlayerData.license) or identifier
        -- Preferred insert (full QB/QBox player_vehicles row).
        success = pcall(function()
            MySQL.insert.await(
                ('INSERT INTO `%s` (`license`, `%s`, `%s`, `%s`, `mods`, `%s`, `state`, `garage`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)')
                    :format(c.table, c.ownerColumn, c.modelColumn, c.hashColumn, c.plateColumn),
                { license, identifier, model, hash, '{}', plate, 1, 'pillboxgarage' })
        end)
        -- Fallback (minimal columns).
        if not success then
            success = pcall(function()
                MySQL.insert.await(
                    ('INSERT INTO `%s` (`%s`, `%s`, `%s`, `%s`) VALUES (?, ?, ?, ?)')
                        :format(c.table, c.ownerColumn, c.modelColumn, c.hashColumn, c.plateColumn),
                    { identifier, model, hash, plate })
            end)
        end
    end

    if success then
        logAction('Admin Action: Add Vehicle', 'Admin added a vehicle to a player\'s garage', {
            { name = 'Target Player', value = GetPlayerName(target) .. ' (ID: ' .. target .. ')', inline = true },
            { name = 'Model', value = model, inline = true },
            { name = 'Plate', value = plate, inline = true }
        }, 'vehicleActions')
    end

    return success and { model = model, plate = plate } or false
end)

lib.callback.register('apex_adminmenu:removeOwnedVehicle', function(source, target, plate)
    if not AdminPerms(source) then return false end
    if not ownedEnabled() then return false end
    target = tonumber(target)
    local identifier = target and GetIdentifier(target)
    if not identifier or not plate or plate == '' then return false end

    local affected
    if Framework == 'esx' then
        local c = Config.OwnedVehicles.esx
        affected = MySQL.update.await(
            ('DELETE FROM `%s` WHERE `%s` = ? AND `%s` = ?')
                :format(c.table, c.ownerColumn, c.plateColumn),
            { identifier, plate })
    else
        local c = Config.OwnedVehicles.qb
        affected = MySQL.update.await(
            ('DELETE FROM `%s` WHERE `%s` = ? AND `%s` = ?')
                :format(c.table, c.ownerColumn, c.plateColumn),
            { identifier, plate })
    end

    if affected and affected > 0 then
        logAction('Admin Action: Remove Vehicle', 'Admin removed a vehicle from a player\'s garage', {
            { name = 'Target Player', value = GetPlayerName(target) .. ' (ID: ' .. target .. ')', inline = true },
            { name = 'Plate', value = tostring(plate), inline = true }
        }, 'vehicleActions', 15158332)
        return true
    end

    return false
end)
