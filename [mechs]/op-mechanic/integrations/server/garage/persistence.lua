if Config.Framework == 'standalone' then
    return
end

local function trimPlate(plate)
    return tostring(plate or ''):match('^%s*(.-)%s*$') or ''
end

function Fr.SaveVehicleProps(plate, props)
    if not MySQL or type(props) ~= 'table' then
        return false
    end

    plate = trimPlate(plate)
    if plate == '' then
        return false
    end

    props.plate = trimPlate(props.plate) ~= '' and trimPlate(props.plate) or plate

    local tbl = Config.Framework == 'esx' and 'owned_vehicles' or 'player_vehicles'
    local col = Config.Framework == 'esx' and 'vehicle' or 'mods'
    local affected = MySQL.update.await(
        ('UPDATE `%s` SET `%s` = ? WHERE `plate` = ? OR `fakeplate` = ?'):format(tbl, col),
        { json.encode(props), plate, plate }
    )

    local ok = (tonumber(affected) or 0) > 0
    if not ok and OPM and OPM.Utils and OPM.Utils.Debug then
        OPM.Utils.Debug('SaveVehicleProps: no rows updated', plate, tbl, col)
    end
    return ok
end