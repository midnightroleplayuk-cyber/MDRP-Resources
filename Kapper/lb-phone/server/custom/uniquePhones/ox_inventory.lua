if Config.Item.Inventory ~= "ox_inventory" or not Config.Item.Unique or not Config.Item.Require then
    return
end

---@param source number
---@return table
local function GetPhonesInInventory(source)
    if Config.Item.Name then
        return exports.ox_inventory:Search(source, "slots", Config.Item.Name) or {}
    end

    local phones = {}

    for i = 1, #Config.Item.Names do
        local items = exports.ox_inventory:Search(source, "slots", Config.Item.Names[i].name) or {}

        for _, phone in pairs(items) do
            phones[#phones+1] = phone
        end
    end

    return phones
end

---Check if a player has a phone with a specific number
---@param source any
---@param phoneNumber string
---@return boolean
function HasPhoneNumber(source, phoneNumber)
    debugprint("checking if " .. source .. " has a phone item with number", phoneNumber)

    local phones = GetPhonesInInventory(source)

    for i = 1, #phones do
        if phones[i]?.metadata?.lbPhoneNumber == phoneNumber then
            debugprint("they do")

            return true
        end
    end

    return false
end

---<b>Key:</b> source
---<br><b>Value:</b> slotId
---@type { [number]: number }
local usedPhoneSlots = {}

---@param source number
---@param itemName string
---@param slotId number
---@param metadata? table
AddEventHandler("ox_inventory:usedItem", function(source, itemName, slotId, metadata)
    if not IsItemAPhone(itemName) then
        return
    end

    usedPhoneSlots[source] = slotId

    SetTimeout(10000, function()
        if usedPhoneSlots[source] == slotId then
            usedPhoneSlots[source] = nil
        end
    end)
end)

---Assign a phone number to a player's empty phone item
---@param source number
---@param phoneNumber string
---@return boolean success
function SetPhoneNumber(source, phoneNumber)
    debugprint("setting phone number to", phoneNumber, "for", source)

    local slot = usedPhoneSlots[source]

    if slot then
        debugprint("Used slot:", slot)

        local phone = exports.ox_inventory:GetSlot(source, slot)

        if phone and phone.metadata?.lbPhoneNumber == nil then
            phone.metadata = {
                lbPhoneNumber = phoneNumber,
                lbFormattedNumber = FormatNumber(phoneNumber)
            }

            exports.ox_inventory:SetMetadata(source, phone.slot, phone.metadata)
            debugprint("set phone number to", phoneNumber, "for", source, "using slot", slot)

            return true
        end
    end

    local phones = GetPhonesInInventory(source)

    for i = 1, #phones do
        local phone = phones[i]

        if phone and phone.metadata?.lbPhoneNumber == nil then
            phone.metadata = {
                lbPhoneNumber = phoneNumber,
                lbFormattedNumber = FormatNumber(phoneNumber)
            }

            exports.ox_inventory:SetMetadata(source, phone.slot, phone.metadata)
            debugprint("set phone number to", phoneNumber, "for", source)

            return true
        end
    end

    return false
end

---@param source number
---@param phoneNumber string
---@param name string
function SetItemName(source, phoneNumber, name)
    local phones = exports.ox_inventory:Search(source, "slots", Config.Item.Name)

    if not phones then
        return false
    end

    for i = 1, #phones do
        local phone = phones[i]

        if phone?.metadata?.lbPhoneNumber == phoneNumber then
            phone.metadata.lbPhoneName = name
            phone.metadata.lbFormattedNumber = FormatNumber(phoneNumber)

            exports.ox_inventory:SetMetadata(source, phone.slot, phone.metadata)

            return true
        end
    end

    return false
end
