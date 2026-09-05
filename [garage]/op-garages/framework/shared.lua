Locales = {}

function trim(s)
    if s then
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    else
        return nil
    end
end

function capitalizeWords(str)
    return str:gsub("(%a)(%w*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

TranslateIt = function(...)
    return Translate(...)
end

function Translate(str, ...) -- Translate string
    if not str then
        print(("[^1ERROR^7] Resource ^5%s^7 You did not specify a parameter for the Translate function or the value is nil!"):format(GetInvokingResource() or GetCurrentResourceName()))
        return "Given translate function parameter is nil!"
    end
    local loc = string.lower(Config.Locale)
    if Locales[loc] then
        if Locales[loc][str] then
            return string.format(Locales[loc][str], ...)
        elseif loc ~= "en" and Locales["en"] and Locales["en"][str] then
            return string.format(Locales["en"][str], ...)
        else
            return "Translation [" .. loc .. "][" .. str .. "] does not exist"
        end
    elseif loc ~= "en" and Locales["en"] and Locales["en"][str] then
        return string.format(Locales["en"][str], ...)
    else
        return "Locale [" .. loc .. "] does not exist"
    end
end

function tableContains(tbl, element)
    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

function correctGrade(entryGrade, neededGrade)
    if type(entryGrade) ~= "number" or type(neededGrade) ~= "number" then
        print("^1[correctGrade]^0 Invalid grade types! entryGrade:", entryGrade, "neededGrade:", neededGrade)
        return false
    end

    if Config.Misc.ReverseGradeCheck then
        return entryGrade >= neededGrade
    else
        return entryGrade <= neededGrade
    end
end

-------------------------------------------------
-- Custom vehicle labels (admin Vehicles tab)
-- Labels are often saved as spawn names ("suzukipolice"),
-- while garage props store joaat hashes. Index both.
-------------------------------------------------

function NormalizeVehicleHash(hash)
    hash = tonumber(hash)
    if not hash then return nil end
    if hash < 0 then
        return hash + 4294967296
    end
    return hash
end

function ToSignedVehicleHash(hash)
    hash = tonumber(hash)
    if not hash then return nil end
    if hash > 2147483647 then
        return hash - 4294967296
    end
    return hash
end

function IndexVehicleLabel(tbl, model, data)
    if type(tbl) ~= "table" or model == nil then return end
    data = data or { model = model }

    local asNumber = tonumber(model)
    if asNumber then
        local signed = ToSignedVehicleHash(asNumber)
        local unsigned = NormalizeVehicleHash(asNumber)
        if signed ~= nil then tbl[tostring(signed)] = data end
        if unsigned ~= nil then tbl[tostring(unsigned)] = data end
        tbl[tostring(model)] = data
    else
        local name = tostring(model)
        tbl[name] = data
        tbl[string.lower(name)] = data

        local hash = joaat(name)
        local signed = ToSignedVehicleHash(hash)
        local unsigned = NormalizeVehicleHash(hash)
        if signed ~= nil then tbl[tostring(signed)] = data end
        if unsigned ~= nil then tbl[tostring(unsigned)] = data end
    end
end

function UnindexVehicleLabel(tbl, model)
    if type(tbl) ~= "table" or model == nil then return end

    local asNumber = tonumber(model)
    if asNumber then
        local signed = ToSignedVehicleHash(asNumber)
        local unsigned = NormalizeVehicleHash(asNumber)
        if signed ~= nil then tbl[tostring(signed)] = nil end
        if unsigned ~= nil then tbl[tostring(unsigned)] = nil end
        tbl[tostring(model)] = nil
    else
        local name = tostring(model)
        tbl[name] = nil
        tbl[string.lower(name)] = nil

        local hash = joaat(name)
        local signed = ToSignedVehicleHash(hash)
        local unsigned = NormalizeVehicleHash(hash)
        if signed ~= nil then tbl[tostring(signed)] = nil end
        if unsigned ~= nil then tbl[tostring(unsigned)] = nil end
    end
end

--- Decode garage props column (JSON string or already-decoded table).
function DecodeVehicleProps(raw)
    if type(raw) == 'table' then
        return raw
    end
    if type(raw) == 'string' and raw ~= '' then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == 'table' then
            return decoded
        end
    end
    return {}
end

--- Compare spawn name / signed hash / unsigned hash safely.
function VehicleModelHashesMatch(a, b)
    if a == nil or b == nil then
        return true
    end

    local function hashOf(model)
        local n = tonumber(model)
        if n then
            return NormalizeVehicleHash(n)
        end
        if type(model) == 'string' and model ~= '' then
            return NormalizeVehicleHash(joaat(model))
        end
        return nil
    end

    local ha, hb = hashOf(a), hashOf(b)
    if not ha or not hb then
        return true
    end
    return ha == hb
end

--- Resolve custom label entry by spawn name or hash (signed/unsigned).
function ResolveVehicleLabelEntry(tbl, model)
    if type(tbl) ~= "table" or model == nil then return nil end

    if type(model) == "string" then
        local byName = tbl[model] or tbl[string.lower(model)] or tbl[string.upper(model)]
        if byName then return byName end
        local asNumber = tonumber(model)
        if asNumber then
            model = asNumber
        else
            model = joaat(model)
        end
    end

    model = tonumber(model)
    if not model then return nil end

    local signed = ToSignedVehicleHash(model)
    local unsigned = NormalizeVehicleHash(model)

    local found = (signed and tbl[tostring(signed)])
        or (unsigned and tbl[tostring(unsigned)])
        or tbl[tostring(model)]

    if found then return found end

    -- Fallback: scan spawn-name keys (covers labels added before dual-index)
    for k, v in pairs(tbl) do
        if type(k) == "string" and tonumber(k) == nil then
            local h = joaat(k)
            if h == model or h == signed or NormalizeVehicleHash(h) == unsigned then
                return v
            end
        end
    end

    return nil
end

