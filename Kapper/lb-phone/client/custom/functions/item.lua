local phoneVariation

---@type { [string]: boolean }
local phoneItemNames = {}

if Config.Item.Name then
    phoneItemNames[Config.Item.Name] = true
end

if Config.Item.Names then
    for i = 1, #Config.Item.Names do
        phoneItemNames[Config.Item.Names[i].name] = true
    end
end

---@param itemName string
function IsItemAPhone(itemName)
    return phoneItemNames[itemName] or false
end

---Check if the player has a phone
---@param number? string
---@return boolean
function HasPhoneItem(number)
    if not Config.Item.Require then
        return true
    end

    if Config.Item.Unique then
        local hasNumber, variation = HasPhoneNumber(number)

        if hasNumber and variation then
            SetPhoneVariation(variation)
        end

        return hasNumber
    end

    if Config.Item.Name then
        return HasItem(Config.Item.Name)
    end

    if phoneVariation and HasItem(Config.Item.Names[phoneVariation].name) then
        return true
    end

    if not phoneVariation then
        local storedVariation = GetResourceKvpInt("phone_variation")

        if storedVariation and Config.Item.Names[storedVariation] and HasItem(Config.Item.Names[storedVariation].name) then
            phoneVariation = storedVariation

            SetPhoneVariation(storedVariation)

            return true
        end
    end

    for i = 1, #Config.Item.Names do
        local item = Config.Item.Names[i]

        if HasItem(item.name) then
            phoneVariation = i

            SetPhoneVariation(i)

            return true
        end
    end

    return false
end

exports("HasPhoneItem", HasPhoneItem)

---@param itemName string
---@return number?
function GetPhoneItemVariationIndex(itemName)
    if not Config.Item.Names then
        return
    end

    for i = 1, #Config.Item.Names do
        if itemName == Config.Item.Names[i].name then
            return i
        end
    end
end

---@param variation number | string
RegisterNetEvent("phone:usedPhoneVariation", function(variation)
    local variationIndex

    if type(variation) == "number" then
        variationIndex = variation
    elseif type(variation) == "string" then
        variationIndex = GetPhoneItemVariationIndex(variation)
    end

    if not variationIndex or not Config.Item.Names[variationIndex] then
        return
    end

    if phoneOpen then
        ToggleOpen(false)

        if phoneVariation == variationIndex then
            return
        end

        Wait(1000)
    end

    phoneVariation = variationIndex

    SetPhoneVariation(variationIndex)
    ToggleOpen(true)
end)
