if Config.Item.Inventory ~= "ox_inventory" or not Config.Item.Unique or not Config.Item.Require then
    return
end

SetTimeout(1000, function()
    exports.ox_inventory:displayMetadata({
        lbPhoneNumber = "Phone number",
        lbFormattedNumber = "Formatted number",
        lbPhoneName = "Phone name",
    })
end)

---@return table
local function GetPhonesInInventory()
    if Config.Item.Name then
        return exports.ox_inventory:Search("slots", Config.Item.Name) or {}
    end

    local phones = {}

    for i = 1, #Config.Item.Names do
        local items = exports.ox_inventory:Search("slots", Config.Item.Names[i].name) or {}

        for _, phone in pairs(items) do
            phones[#phones+1] = phone
        end
    end

    return phones
end

---Get the first phone number found in the player's inventory
---@return string?
function GetFirstNumber()
    local phones = GetPhonesInInventory()

    for i = 1, #phones do
        local phone = phones[i]

        if phone?.metadata?.lbPhoneNumber then
            return phone.metadata.lbPhoneNumber
        end
    end
end

---Check if the player has a phone with a specific number
---@param phoneNumber string
function HasPhoneNumber(phoneNumber)
    local phones = GetPhonesInInventory()

    for i = 1, #phones do
        local phone = phones[i]

        if phone?.metadata?.lbPhoneNumber == phoneNumber then
            return true, GetPhoneItemVariationIndex(phone.name)
        end
    end

    return false
end

---@param itemName string
---@param slotId number
---@param metadata? table
local function OnUseItem(itemName, slotId, metadata)
    debugprint("used phone item", itemName, slotId, metadata)

    local number = metadata?.lbPhoneNumber
    local variation = Config.Item.Names and GetPhoneItemVariationIndex(itemName)

    if number ~= currentPhone or number == nil then
        SetPhone(number, true)

        if variation then
            SetPhoneVariation(variation)
        end
    end

    ToggleOpen(not phoneOpen)

    if variation then
        SetPhoneVariation(variation)
    end
end

---@param itemName string
---@param slotId number
---@param metadata? table
AddEventHandler("ox_inventory:usedItem", function(itemName, slotId, metadata)
    if not IsItemAPhone(itemName) then
        return
    end

    OnUseItem(itemName, slotId, metadata)
end)

---@param item { name: string, slot: number, metadata?: table }
exports("UsePhoneItem", function(_, item)
    OnUseItem(item.name, item.slot, item.metadata)
end)

---@param itemName string
---@param count number
AddEventHandler("ox_inventory:itemCount", function(itemName, count)
    if not IsItemAPhone(itemName) then
        return
    end

    Wait(500)

    if currentPhone then
        if not HasPhoneItem(currentPhone) then
            SetPhone()
        end
    elseif count > 0 then
        local firstNumber = GetFirstNumber()

        SetPhone(firstNumber, true)
    end
end)
