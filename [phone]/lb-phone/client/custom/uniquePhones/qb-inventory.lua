if (Config.Item.Inventory ~= "qb-inventory" and Config.Item.Inventory ~= "lj-inventory") or not Config.Item.Unique or not Config.Item.Require then
    return
end

---@return table
local function GetPhonesInInventory()
    local phones = {}
    local items = PlayerData?.items or {}

    for _, item in pairs(items) do
        if IsItemAPhone(item.name) then
            phones[#phones+1] = item
        end
    end

    return phones
end

function GetFirstNumber()
    local phones = GetPhonesInInventory()

    for i = 1, #phones do
        local phone = phones[i]

        if phone?.info?.lbPhoneNumber then
            return phone.info.lbPhoneNumber
        end
    end
end

function HasPhoneNumber(number)
    local phones = GetPhonesInInventory()

    for i = 1, #phones do
        local phone = phones[i]

        if phone?.info?.lbPhoneNumber == number then
            return true, GetPhoneItemVariationIndex(phone.name)
        end
    end

    return false
end

RegisterNetEvent("lb-phone:usePhoneItem", function(item)
    local number = item.info?.lbPhoneNumber

    if number ~= currentPhone or number == nil then
        SetPhone(number, true)

        if Config.Item.Names then
            local variation = GetPhoneItemVariationIndex(item.name)

            if variation then
                SetPhoneVariation(variation)
            end
        end
    end

    ToggleOpen(not phoneOpen)
end)

local waitingAdded = false

RegisterNetEvent("QBCore:Player:SetPlayerData", function(newData)
    Wait(500)

    if currentPhone then
        if not HasPhoneItem(currentPhone) then
            SetPhone()
        end
    elseif #GetPhonesInInventory() > 0 and not waitingAdded then
        waitingAdded = true

        local firstNumber = GetFirstNumber()

        SetPhone(firstNumber, true)

        waitingAdded = false
    end
end)
