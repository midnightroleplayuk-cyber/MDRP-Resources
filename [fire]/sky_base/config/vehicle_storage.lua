-- Server-only adapter for existing framework vehicle records. Callers authorize the operation.
-- Keep failure returns dense: Cfx function references can drop nil-leading return tuples.
Sky.VehicleStorage = {}

-- One SQL schema for tuning persistence and the shared vehicle register.
-- Custom garage schemas belong here; Qbox property writes still use qbx_vehicles.
function Sky.VehicleStorage.GetSchema()
    local framework = Sky.Config.framework
    if framework == "esx" then
        return { tableName = "owned_vehicles", ownerColumn = "owner", propertiesColumn = "vehicle", modelColumn = "vehicle" }
    elseif framework == "qb" or framework == "qbox" then
        return { tableName = "player_vehicles", ownerColumn = "citizenid", propertiesColumn = "mods",
            modelColumn = framework == "qb" and "hash" or "vehicle" }
    end
    return false, "unsupported_vehicle_storage"
end

function Sky.VehicleStorage.Read(plate, vehicle)
    local framework = Sky.Config.framework
    if framework == "qbox" then
        local vehicle_id = vehicle and Entity(vehicle).state.vehicleid
            or exports.qbx_vehicles:GetVehicleIdByPlate(plate)
        if not vehicle_id then return false, "not_owned" end
        local row = exports.qbx_vehicles:GetPlayerVehicle(vehicle_id)
        if not row then return false, "not_owned" end
        local properties = row.props
        local needs_initialization = properties == nil or (type(properties) == "table" and next(properties) == nil)
        if needs_initialization then
            -- Ownership may exist before the first complete property save. Verify its plate
            -- independently of props before allowing the caller to initialize that snapshot.
            if exports.qbx_vehicles:GetVehicleIdByPlate(plate) ~= vehicle_id then
                Sky.Debug("error", "[Sky.VehicleStorage.Read] Qbox vehicle id %s does not match plate %s", tostring(vehicle_id), plate)
                return false, "plate_mismatch"
            end
        elseif type(properties) ~= "table" or type(properties.plate) ~= "string" or not properties.plate:find("%S") then
            Sky.Debug("error", "[Sky.VehicleStorage.Read] Invalid Qbox vehicle properties for vehicle id %s: propsType=%s plate=%s",
                tostring(vehicle_id), type(properties), type(properties) == "table" and tostring(properties.plate) or "<missing>")
            return false, "invalid_vehicle_properties"
        end
        return { id = vehicle_id, plate = needs_initialization and plate or properties.plate, model = joaat(row.modelName),
            properties = properties, codec = "ox", needsInitialization = needs_initialization }
    end
    local schema, reason = Sky.VehicleStorage.GetSchema()
    if not schema then return false, reason end
    local model_column = schema.modelColumn == schema.propertiesColumn and "NULL" or ("`%s`"):format(schema.modelColumn)
    local query = ("SELECT plate, `%s` AS owner_id, %s AS model, `%s` AS properties FROM `%s` WHERE plate = ? OR TRIM(plate) = ?")
        :format(schema.ownerColumn, model_column, schema.propertiesColumn, schema.tableName)
    local rows = Sky.DB.Select(query, { plate, plate })
    if not rows then return false, "load_failed" end
    if #rows == 0 then return false, "not_owned" end
    if #rows ~= 1 then return false, "ambiguous_vehicle" end
    local row = rows[1]
    local decoded, properties = pcall(json.decode, row.properties or "{}")
    if not decoded or type(properties) ~= "table" then return false, "invalid_vehicle_properties" end
    row.encoded = row.properties
    row.properties = properties
    row.model = tonumber(row.model) or tonumber(properties.model)
    row.codec = framework
    return row
end

function Sky.VehicleStorage.Save(record, properties, vehicle)
    if record.codec == "ox" then
        if not vehicle then return false, "vehicle_required" end
        local vehicle_id = Entity(vehicle).state.vehicleid or exports.qbx_vehicles:GetVehicleIdByPlate(record.plate)
        if vehicle_id ~= record.id then
            Sky.Debug("error", "[Sky.VehicleStorage.Save] Qbox vehicle identity changed: expected id %s, current id %s",
                tostring(record.id), tostring(vehicle_id))
            return false, "vehicle_changed"
        end
        local saved, reason = exports.qbx_vehicles:SaveVehicle(vehicle, { props = properties })
        if not saved then return false, reason and reason.code or "save_failed" end
    else
        local schema, reason = Sky.VehicleStorage.GetSchema()
        if not schema then return false, reason end
        local query = ("UPDATE `%s` SET `%s` = ? WHERE plate = ? AND COALESCE(`%s`, '') = ? AND COALESCE(`%s`, '') = ?")
            :format(schema.tableName, schema.propertiesColumn, schema.ownerColumn, schema.propertiesColumn)
        local encoded = json.encode(properties)
        if encoded ~= record.encoded then
            local changed = Sky.DB.Update(query, { encoded, record.plate, record.owner_id or "", record.encoded or "" })
            if changed ~= 1 then return false, changed == nil and "save_failed" or "vehicle_changed" end
        end
    end
    -- Current ESX persistence may also retain its properties on the live entity.
    if vehicle and Entity(vehicle).state.VehicleProperties ~= nil then
        Entity(vehicle).state:set("VehicleProperties", properties, true)
    end
    if Sky.Config.garage == "quasar" then
        exports["qs-advancedgarages"]:updatePersistentVehicleProps(record.plate, properties)
    end
    return true
end
