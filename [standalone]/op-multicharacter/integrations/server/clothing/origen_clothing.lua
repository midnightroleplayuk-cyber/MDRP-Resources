if Config.Clothing ~= "origen_clothing" then return end

local function decodeSkinField(skinField)
    if type(skinField) == "table" then return skinField end
    if type(skinField) == "string" and skinField ~= "" then
        local ok, decoded = pcall(json.decode, skinField)
        if ok and type(decoded) == "table" then return decoded end
    end
    return nil
end

local function fromOrigenRow(row)
    if type(row) ~= "table" then return nil end

    local appearance = decodeSkinField(row.skin)
    if not appearance then return nil end

    return {
        skin = appearance,
        model = row.model or appearance.model,
    }
end

local function fetchFromOrigenTable(identifier)
    if type(identifier) ~= "string" or identifier == "" then return nil end

    local row = MySQL.single.await(
        "SELECT `model`, `skin` FROM `origen_clothing_skins` WHERE `citizenid` = ? AND `active` = 1 ORDER BY `id` DESC LIMIT 1",
        { identifier }
    )

    if not row and ESX then
        row = MySQL.single.await(
            "SELECT `model`, `skin` FROM `origen_clothing_skins` WHERE `identifier` = ? AND `active` = 1 ORDER BY `id` DESC LIMIT 1",
            { identifier }
        )
    end

    return fromOrigenRow(row)
end

local function fetchFromExport(identifier)
    local ok, skinData = pcall(function()
        return exports.origen_clothing:getAppearance(identifier)
    end)
    if not ok or type(skinData) ~= "table" then return nil end

    if type(skinData.skin) == "table" then
        return {
            skin = skinData.skin,
            model = skinData.model or skinData.skin.model,
        }
    end

    local appearance = decodeSkinField(skinData.skin)
    if appearance then
        return {
            skin = appearance,
            model = skinData.model or appearance.model,
        }
    end

    if skinData.components or skinData.drawables or skinData.headBlend or skinData.props then
        return {
            skin = skinData,
            model = skinData.model,
        }
    end

    return nil
end

function convertSkin(identifier)
    return fetchFromOrigenTable(identifier) or fetchFromExport(identifier)
end
