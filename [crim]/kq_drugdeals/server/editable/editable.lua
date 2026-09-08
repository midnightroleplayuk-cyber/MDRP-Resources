function IsAdmin(player)
    return IsPlayerAceAllowed(player, 'command.' .. Config.editor.command)
end

local function GetPlayerPoliceJob(player)
    local job, grade = exports.kq_link:GetPlayerJob(player)
    local entry = job and Config.police.jobs[job]

    if not entry then
        return nil, 0
    end

    return entry, tonumber(grade) or 0
end

function IsPoliceOfficer(player)
    local entry, grade = GetPlayerPoliceJob(player)

    return entry ~= nil and grade >= entry.view
end

function CanControlSting(player)
    local entry, grade = GetPlayerPoliceJob(player)

    return entry ~= nil and grade >= entry.control
end

function GetPlayerUniqueIdentifier(player)
    local id = exports.kq_link:GetPlayerCharacterId(player)

    if id and type(id) == 'string' then
        return id
    end

    return GetPlayerIdentifierByType(player, 'license')
end

function AddPlayerMoney(player, amount, context, account)
    if account == nil then
        account = Config.accounts.cash
    end

    if Config.accounts.cash == account and Config.accounts.addCashAsItem then
        return exports.kq_link:AddPlayerItem(player, account, amount)
    end

    return exports.kq_link:AddPlayerMoney(player, amount, account or Config.accounts.cash)
end

function RemovePlayerMoney(player, amount, account)
    if Config.accounts.cash == account and Config.accounts.addCashAsItem then
        return exports.kq_link:RemovePlayerItem(player, account, amount)
    end

    if not exports.kq_link:CanPlayerAfford(player, amount, account) then
        return false
    end

    return exports.kq_link:RemovePlayerMoney(player, amount, account)
end

local function OnPlugPhoneUse(player)
    TriggerClientEvent('kq_drugdeals:client:openPhone', player)
end

if Config.app.phoneItem.enabled then
    exports.kq_link:RegisterUsableItem(Config.app.phoneItem.item, function(source)
        OnPlugPhoneUse(source)
    end)

    -- ox_inventory export hook
    exports('UsePlugPhone', function(event, item, inventory)
        if event == 'usingItem' then
            OnPlugPhoneUse(inventory.id)
            return true
        end
    end)
end

local function OnTrapPhoneUse(player)
    TriggerClientEvent('kq_drugdeals:client:openClassicPhone', player)
end

if Config.app.classicPhoneItem.enabled then
    exports.kq_link:RegisterUsableItem(Config.app.classicPhoneItem.item, function(source)
        OnTrapPhoneUse(source)
    end)

    -- ox_inventory export hook
    exports('UseTrapPhone', function(event, item, inventory)
        if event == 'usingItem' then
            OnTrapPhoneUse(inventory.id)
            return true
        end
    end)
end

local function OnStingPhoneUse(player)
    if IsPoliceOfficer(player) then
        TriggerClientEvent('kq_drugdeals:client:openStingPhone', player)
    else
        TriggerClientEvent('kq_drugdeals:client:stingDenied', player)
    end
end

if Config.police.enabled and Config.police.phoneItem.enabled then
    exports.kq_link:RegisterUsableItem(Config.police.phoneItem.item, function(source)
        OnStingPhoneUse(source)
    end)

    -- ox_inventory export hook
    exports('UseStingPhone', function(event, item, inventory)
        if event == 'usingItem' then
            OnStingPhoneUse(inventory.id)
            return true
        end
    end)
end

-- Dummy hooks: the resource calls these when actions occur
-- Useful to add your logging, skill/xp systems etc.
Dummy = {
    StreetDealCompleted = function(player, deal)
        return
    end,

    -- deal: { cornerId, outcome, drugId, quantity, pricePerUnit, total }
    CornerDealCompleted = function(player, deal)
        return
    end,

    CornerPosted = function(player, cornerId)
        return
    end,

    CornerLeft = function(player, cornerId)
        return
    end,

    AppDealCompleted = function(player, deal)
        return
    end,

    OrgSaleCompleted = function(player, sale)
        return
    end,

    OrganizationUnlocked = function(player, orgId)
        return
    end,

    BuyInPaid = function(player, orgId, cost)
        return
    end,

    OrgStandingLevelChanged = function(player, orgId, level, direction)
        return
    end,

    ContactAdded = function(player, contact)
        return
    end,

    ContactBlocked = function(player, contactId)
        return
    end,

    ContactExpired = function(player, contactId)
        return
    end,

    FavourRequested = function(player, orgId, favourType)
        return
    end,

    FavourCompleted = function(player, orgId, favourType)
        return
    end,

    FavourFailed = function(player, orgId, favourType, reason)
        return
    end,

    -- data: { copCharId, dealerCharId, drugId }
    StingStarted = function(copPlayer, data)
        return
    end,

    -- data: { copCharId, dealerCharId, drugId, quantity, price, total, locationId }
    StingAgreed = function(data)
        return
    end,

    StingClosed = function(info, outcome)
        return
    end,

    StarRatingChanged = function(player, stars)
        return
    end,

    MarketPriceChanged = function(drugId, price)
        return
    end,

    -- kind: 'Drug' | 'Hotspot' | 'Organization' | 'DeliveryLocation' | 'VehicleLocation' | 'Corner'
    AdminEntrySaved = function(player, kind, entry)
        return
    end,

    AdminEntryDeleted = function(player, kind, entryId)
        return
    end,
}
