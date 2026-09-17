local function isEsx()
    return Config.Framework == 'esx'
end

local function vehiclesTable()
    return isEsx() and 'owned_vehicles' or 'player_vehicles'
end

local function propsColumn()
    return isEsx() and 'vehicle' or 'mods'
end

local function garageScript()
    return Config.GarageScript or 'none'
end

local function encodeProps(model, plate)
    local hash = joaat(model)
    return json.encode({ model = hash, plate = plate })
end

local function catalogEntryFor(jobName, modelOrConfig)
    local want = tostring(modelOrConfig or ''):lower()
    local fleet = Config.VehicleFleet or {}
    local list = (fleet.catalogByJob and fleet.catalogByJob[jobName]) or fleet.catalog or {}
    for i = 1, #list do
        local row = list[i]
        if row and tostring(row.model or ''):lower() == want then
            return row
        end
    end
    return nil
end

local function imageFor(_model, fallback)
    if type(fallback) == 'string' and fallback ~= '' then
        return fallback
    end
    return ''
end

---@param jobName string
---@return table[]
function Fr.GetJobVehicles(jobName)
    jobName = tostring(jobName or '')
    if jobName == '' or not MySQL then
        return {}
    end

    local tableName = vehiclesTable()
    local okQuery, rows = pcall(function()
        return MySQL.query.await(('SELECT * FROM `%s` WHERE `job` = ?'):format(tableName), { jobName })
    end)
    if not okQuery then
        return {}
    end
    rows = rows or {}
    local out = {}
    local resellPct = math.max(0, math.min(100, tonumber((Config.VehicleFleet or {}).resellPercent) or 50))

    for i = 1, #rows do
        local row = rows[i]
        local configName = tostring(row.configName or ''):lower()
        local props = nil
        local rawProps = row[propsColumn()]
        if type(rawProps) == 'string' and rawProps ~= '' then
            local ok, decoded = pcall(json.decode, rawProps)
            if ok then
                props = decoded
            end
        elseif type(rawProps) == 'table' then
            props = rawProps
        end

        local entry = catalogEntryFor(jobName, configName)
        local model = (entry and entry.model) or configName
        if model == '' and props and props.model then
            -- hash only - keep empty model string for UI fallback
            model = tostring(props.model)
        end
        local price = entry and math.floor(tonumber(entry.price) or 0) or 0
        local resell = entry and math.floor(tonumber(entry.resellPrice) or (price * resellPct / 100)) or 0

        local inGarage = true
        if row.stored ~= nil then
            inGarage = tonumber(row.stored) == 1
        elseif row.state ~= nil then
            inGarage = tonumber(row.state) == 1
        end

        out[#out + 1] = {
            plate = tostring(row.plate or ''),
            model = tostring((entry and entry.model) or configName or ''),
            label = (entry and entry.label) or configName or tostring(row.plate or 'Vehicle'),
            price = price,
            resellPrice = resell,
            image = imageFor((entry and entry.model) or configName, entry and entry.image),
            state = inGarage and 0 or 1,
            props = props,
        }
    end

    table.sort(out, function(a, b)
        return tostring(a.plate) < tostring(b.plate)
    end)
    return out
end

---@param plate string
---@return boolean
function Fr.IsPlateTaken(plate)
    plate = tostring(plate or ''):upper():gsub('%s+', '')
    if plate == '' or not MySQL then
        return true
    end
    local tableName = vehiclesTable()
    local result = MySQL.scalar.await(('SELECT plate FROM `%s` WHERE plate = ? LIMIT 1'):format(tableName), { plate })
    return result ~= nil
end

--- Insert job vehicle into framework garage table (owned_vehicles / player_vehicles).
---@param model string spawn name
---@param jobName string
---@param plate string
---@param mods string|nil json props
---@return boolean
function Fr.VehiclePurchased(model, jobName, plate, mods)
    model = tostring(model or ''):lower()
    jobName = tostring(jobName or '')
    plate = tostring(plate or ''):upper():gsub('%s+', '')
    if model == '' or jobName == '' or plate == '' or not MySQL then
        return false
    end

    local hash = joaat(model)
    local propsJson = mods or encodeProps(model, plate)
    local script = garageScript()

    if isEsx() then
        if script == 'jg-advancedgarages' then
            local id = MySQL.insert.await([[
                INSERT INTO `owned_vehicles`
                (`owner`, `plate`, `vehicle`, `job`, `configName`, `job_vehicle`, `job_vehicle_rank`)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ]], {
                'job_' .. jobName,
                plate,
                propsJson,
                jobName,
                model,
                1,
                0,
            })
            return id ~= nil
        end

        local okIns, id = pcall(function()
            return MySQL.insert.await([[
                INSERT INTO `owned_vehicles`
                (`owner`, `plate`, `vehicle`, `job`, `configName`, `stored`)
                VALUES (?, ?, ?, ?, ?, ?)
            ]], {
                nil,
                plate,
                propsJson,
                jobName,
                model,
                1,
            })
        end)
        if okIns and id then
            return true
        end
        -- Schema without `stored` column.
        id = MySQL.insert.await([[
            INSERT INTO `owned_vehicles`
            (`owner`, `plate`, `vehicle`, `job`, `configName`)
            VALUES (?, ?, ?, ?, ?)
        ]], {
            nil,
            plate,
            propsJson,
            jobName,
            model,
        })
        return id ~= nil
    end

    -- QB / Qbox -> player_vehicles
    if script == 'jg-advancedgarages' then
        local id = MySQL.insert.await([[
            INSERT INTO `player_vehicles`
            (`license`, `vehicle`, `hash`, `citizenid`, `plate`, `mods`, `job`, `configName`, `job_vehicle`, `job_vehicle_rank`)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]], {
            nil,
            model,
            hash,
            'job_' .. jobName,
            plate,
            propsJson,
            jobName,
            model,
            1,
            0,
        })
        return id ~= nil
    end

    local okIns, id = pcall(function()
        return MySQL.insert.await([[
            INSERT INTO `player_vehicles`
            (`license`, `vehicle`, `hash`, `citizenid`, `plate`, `mods`, `job`, `configName`, `state`)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]], {
            nil,
            model,
            hash,
            nil,
            plate,
            propsJson,
            jobName,
            model,
            1,
        })
    end)
    if okIns and id then
        return true
    end
    id = MySQL.insert.await([[
        INSERT INTO `player_vehicles`
        (`license`, `vehicle`, `hash`, `citizenid`, `plate`, `mods`, `job`, `configName`)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        nil,
        model,
        hash,
        nil,
        plate,
        propsJson,
        jobName,
        model,
    })
    return id ~= nil
end

---@param plate string
---@param stored boolean true = in garage / parked
---@param props table|nil optional vehicle props to persist
---@return boolean
function Fr.SetJobVehicleStored(plate, stored, props)
    plate = tostring(plate or ''):upper():gsub('%s+', '')
    if plate == '' or not MySQL then
        return false
    end

    local flag = stored and 1 or 0
    local tableName = vehiclesTable()
    local propsCol = propsColumn()
    local propsJson = nil
    if type(props) == 'table' then
        propsJson = json.encode(props)
    end

    local ok = pcall(function()
        if isEsx() then
            if propsJson then
                MySQL.update.await(
                    ('UPDATE `%s` SET `stored` = ?, `%s` = ? WHERE `plate` = ?'):format(tableName, propsCol),
                    { flag, propsJson, plate }
                )
            else
                MySQL.update.await(
                    ('UPDATE `%s` SET `stored` = ? WHERE `plate` = ?'):format(tableName),
                    { flag, plate }
                )
            end
        else
            if propsJson then
                MySQL.update.await(
                    ('UPDATE `%s` SET `state` = ?, `%s` = ? WHERE `plate` = ?'):format(tableName, propsCol),
                    { flag, propsJson, plate }
                )
            else
                MySQL.update.await(
                    ('UPDATE `%s` SET `state` = ? WHERE `plate` = ?'):format(tableName),
                    { flag, plate }
                )
            end
        end
    end)
    return ok == true
end

---@param plate string
---@return boolean
function Fr.VehicleSold(plate)
    plate = tostring(plate or ''):upper():gsub('%s+', '')
    if plate == '' or not MySQL then
        return false
    end
    local tableName = vehiclesTable()
    MySQL.update.await(('DELETE FROM `%s` WHERE plate = ?'):format(tableName), { plate })
    return true
end

local function decodeProps(raw)
    if type(raw) == 'table' then
        return raw
    end
    if type(raw) ~= 'string' or raw == '' then
        return nil
    end
    local ok, decoded = pcall(json.decode, raw)
    if ok and type(decoded) == 'table' then
        return decoded
    end
    return nil
end

local function modelFromGarageRow(row)
    local configName = tostring(row.configName or ''):lower()
    if configName ~= '' then
        return configName
    end
    -- QB/Qbox store spawn name in `vehicle`; ESX stores props JSON there.
    local vehicleCol = row.vehicle
    if type(vehicleCol) == 'string' and vehicleCol ~= '' and not vehicleCol:find('{', 1, true) then
        return vehicleCol:lower()
    end
    local props = decodeProps(isEsx() and row.vehicle or row.mods) or decodeProps(row.vehicle)
    if props then
        if type(props.model) == 'string' and props.model ~= '' then
            return props.model:lower()
        end
    end
    return ''
end

local function ownerName(first, last, fallback)
    local name = (tostring(first or '') .. ' ' .. tostring(last or '')):gsub('^%s+', ''):gsub('%s+$', '')
    if name ~= '' then
        return name
    end
    fallback = tostring(fallback or '')
    if fallback == '' or fallback:find('^job_') then
        return ''
    end
    return fallback
end

--- List player/job vehicles from framework garage DB (owned_vehicles / player_vehicles).
---@param query string|nil
---@param limit number|nil
---@return table[] { plate, model, label, owner, ownerIdentifier }
function Fr.ListOwnedVehicles(query, limit, offset)
    limit = math.min(math.max(1, math.floor(tonumber(limit) or 80)), 200)
    offset = math.max(0, math.floor(tonumber(offset) or 0))
    if not MySQL then
        return {}, 0
    end

    local q = tostring(query or ''):gsub('^%s+', ''):gsub('%s+$', '')
    local ok, pack = pcall(function()
        local rows, total
        if isEsx() then
            if q ~= '' then
                local like = '%' .. q .. '%'
                local likePlate = '%' .. q:upper():gsub('%s+', '') .. '%'
                local where = [[
                    WHERE REPLACE(UPPER(ov.plate), ' ', '') LIKE ?
                       OR u.firstname LIKE ?
                       OR u.lastname LIKE ?
                       OR CONCAT(IFNULL(u.firstname,''), ' ', IFNULL(u.lastname,'')) LIKE ?
                ]]
                total = MySQL.scalar.await([[
                    SELECT COUNT(*)
                    FROM owned_vehicles ov
                    LEFT JOIN users u ON u.identifier = ov.owner
                ]] .. where, { likePlate, like, like, like }) or 0
                rows = MySQL.query.await([[
                    SELECT ov.*, u.firstname, u.lastname
                    FROM owned_vehicles ov
                    LEFT JOIN users u ON u.identifier = ov.owner
                ]] .. where .. [[
                    ORDER BY ov.plate ASC
                    LIMIT ? OFFSET ?
                ]], { likePlate, like, like, like, limit, offset }) or {}
            else
                total = MySQL.scalar.await('SELECT COUNT(*) FROM owned_vehicles') or 0
                rows = MySQL.query.await([[
                    SELECT ov.*, u.firstname, u.lastname
                    FROM owned_vehicles ov
                    LEFT JOIN users u ON u.identifier = ov.owner
                    ORDER BY ov.plate ASC
                    LIMIT ? OFFSET ?
                ]], { limit, offset }) or {}
            end
        elseif q ~= '' then
            -- QB / Qbox
            local like = '%' .. q .. '%'
            local likePlate = '%' .. q:upper():gsub('%s+', '') .. '%'
            local where = [[
                WHERE REPLACE(UPPER(pv.plate), ' ', '') LIKE ?
                   OR pv.vehicle LIKE ?
                   OR JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.firstname')) LIKE ?
                   OR JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.lastname')) LIKE ?
            ]]
            total = MySQL.scalar.await([[
                SELECT COUNT(*)
                FROM player_vehicles pv
                LEFT JOIN players p ON p.citizenid = pv.citizenid
            ]] .. where, { likePlate, like, like, like }) or 0
            rows = MySQL.query.await([[
                SELECT pv.*,
                       JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.firstname')) AS firstname,
                       JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.lastname')) AS lastname
                FROM player_vehicles pv
                LEFT JOIN players p ON p.citizenid = pv.citizenid
            ]] .. where .. [[
                ORDER BY pv.plate ASC
                LIMIT ? OFFSET ?
            ]], { likePlate, like, like, like, limit, offset }) or {}
        else
            total = MySQL.scalar.await('SELECT COUNT(*) FROM player_vehicles') or 0
            rows = MySQL.query.await([[
                SELECT pv.*,
                       JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.firstname')) AS firstname,
                       JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.lastname')) AS lastname
                FROM player_vehicles pv
                LEFT JOIN players p ON p.citizenid = pv.citizenid
                ORDER BY pv.plate ASC
                LIMIT ? OFFSET ?
            ]], { limit, offset }) or {}
        end
        return { rows = rows or {}, total = tonumber(total) or 0 }
    end)

    if not ok then
        if OPM and OPM.Utils and OPM.Utils.Debug then
            OPM.Utils.Debug('ListOwnedVehicles SQL failed', pack)
        end
        return {}, 0
    end

    local rows = pack and pack.rows or {}
    local total = pack and pack.total or 0
    local out = {}
    for i = 1, #rows do
        local row = rows[i]
        local plate = tostring(row.plate or '')
        if plate ~= '' then
            local model = modelFromGarageRow(row)
            local ownerId = isEsx() and tostring(row.owner or '') or tostring(row.citizenid or '')
            out[#out + 1] = {
                plate = plate,
                model = model,
                label = model ~= '' and model or plate,
                owner = ownerName(row.firstname, row.lastname, ownerId),
                ownerIdentifier = ownerId,
            }
        end
    end
    return out, total
end

if OPM and OPM.Utils and OPM.Utils.Debug then
    OPM.Utils.Debug(('Job vehicles table: %s (garage=%s)'):format(vehiclesTable(), garageScript()))
end