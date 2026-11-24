NDM.Money = {}

local Busy = {}

AddEventHandler('playerDropped', function()
    Busy[source] = nil
end)

local function locked(src, callback)
    if Busy[src] then return false, 'busy' end
    Busy[src] = true
    local result = table.pack(pcall(callback))
    Busy[src] = nil
    if not result[1] then
        print(('^1[%s] money operation failed: %s^7'):format(NDM.Resource, tostring(result[2])))
        return false, 'error'
    end
    return table.unpack(result, 2, result.n)
end

local function ledger(venueId, kind, amount, citizenId, description)
    MySQL.insert('INSERT INTO `ndm_business_ledger` (`venue_id`, `kind`, `amount`, `citizenid`, `description`) VALUES (?, ?, ?, ?, ?)', {
        venueId,
        kind,
        amount,
        citizenId,
        tostring(description or ''):sub(1, 255),
    })
end

local function prepare(src, venueId, amount, account)
    src = tonumber(src)
    local venue = NDM.Venue.Get(venueId)
    local whole = NDM.WholeMoney(amount)
    if not src or not Bridge.GetPlayer(src) then return nil, 'invalid_player' end
    if not venue then return nil, 'invalid_venue' end
    if not whole then return nil, 'invalid_amount' end
    if not NDM.PlayerAccounts[account] then return nil, 'invalid_account' end
    return { src = src, venue = venue, amount = whole, account = account }
end

-- Player pays the venue. If the society refuses, the player is paid back.
local function moveIn(tx, kind, description)
    return locked(tx.src, function()
        local balance = Bridge.GetMoney(tx.src, tx.account)
        if not balance or balance < tx.amount then return false, 'insufficient_funds' end

        local reason = ('%s: %s'):format(kind, tx.venue.label)
        if not Bridge.RemoveMoney(tx.src, tx.account, tx.amount, reason) then
            return false, 'charge_refused'
        end

        local credited, err = Bridge.AddSocietyMoney(tx.venue.job, tx.amount, reason, Bridge.GetCharacterName(tx.src))
        if not credited then
            if not Bridge.AddMoney(tx.src, tx.account, tx.amount, reason .. ' reversal') then
                print(('^1[%s] CRITICAL: could not return $%d to player %d after society refusal^7')
                    :format(NDM.Resource, tx.amount, tx.src))
            end
            return false, err or 'society_refused'
        end

        ledger(tx.venue.id, kind, tx.amount, Bridge.GetCitizenId(tx.src), description)
        return true
    end)
end

-- The venue pays a player. If the player cannot be paid, the society is restored.
local function moveOut(tx, kind, description)
    return locked(tx.src, function()
        local reason = ('%s: %s'):format(kind, tx.venue.label)
        local actor = Bridge.GetCharacterName(tx.src)
        local debited, err = Bridge.RemoveSocietyMoney(tx.venue.job, tx.amount, reason, actor)
        if not debited then return false, err or 'society_refused' end

        if not Bridge.AddMoney(tx.src, tx.account, tx.amount, reason) then
            if not Bridge.AddSocietyMoney(tx.venue.job, tx.amount, reason .. ' reversal', actor) then
                print(('^1[%s] CRITICAL: could not return $%d to society %s^7')
                    :format(NDM.Resource, tx.amount, tx.venue.job))
            end
            return false, 'payout_refused'
        end

        ledger(tx.venue.id, kind, -tx.amount, Bridge.GetCitizenId(tx.src), description)
        return true
    end)
end

-- Charges a player without paying a venue, such as buying a business from the state.
function NDM.Money.ChargePlayer(src, amount, account, reason)
    src = tonumber(src)
    local whole = NDM.WholeMoney(amount)
    if not src or not Bridge.GetPlayer(src) then return false, 'invalid_player' end
    if not whole then return false, 'invalid_amount' end
    if not NDM.PlayerAccounts[account] then return false, 'invalid_account' end
    return locked(src, function()
        local balance = Bridge.GetMoney(src, account)
        if not balance or balance < whole then return false, 'insufficient_funds' end
        if not Bridge.RemoveMoney(src, account, whole, reason) then return false, 'charge_refused' end
        return true
    end)
end

-- Business spending that pays no player, such as buying supplies.
function NDM.Money.Spend(venueId, amount, kind, description, citizenId, actor)
    local venue = NDM.Venue.Get(venueId)
    local whole = NDM.WholeMoney(amount)
    if not venue then return false, 'invalid_venue' end
    if not whole then return false, 'invalid_amount' end
    local debited, err = Bridge.RemoveSocietyMoney(venue.job, whole, ('%s: %s'):format(kind, venue.label), actor)
    if not debited then return false, err or 'society_refused' end
    ledger(venue.id, kind, -whole, citizenId, description)
    return true
end

function NDM.Money.Reimburse(venueId, amount, kind, description, citizenId, actor)
    local venue = NDM.Venue.Get(venueId)
    local whole = NDM.WholeMoney(amount)
    if not venue then return false, 'invalid_venue' end
    if not whole then return false, 'invalid_amount' end
    local credited, err = Bridge.AddSocietyMoney(venue.job, whole, ('%s: %s'):format(kind, venue.label), actor)
    if not credited then return false, err or 'society_refused' end
    ledger(venue.id, kind, whole, citizenId, description)
    return true
end

function NDM.Money.Note(venueId, kind, description, citizenId)
    ledger(venueId, kind, 0, citizenId, description)
end

function NDM.Money.Balance(venueId)
    local venue = NDM.Venue.Get(venueId)
    return venue and Bridge.GetSocietyBalance(venue.job) or nil
end

-- Sale and Refund do not check staff permissions. Their calling feature must authorise them.
function NDM.Money.Sale(src, venueId, amount, account, description)
    local tx, err = prepare(src, venueId, amount, account)
    if not tx then return false, err end
    return moveIn(tx, 'sale', description)
end

function NDM.Money.Refund(src, venueId, amount, account, description)
    local tx, err = prepare(src, venueId, amount, account)
    if not tx then return false, err end
    return moveOut(tx, 'refund', description)
end

function NDM.Money.PayStaff(src, venueId, amount, kind, description)
    local tx, err = prepare(src, venueId, amount, 'bank')
    if not tx then return false, err end
    return moveOut(tx, kind, description)
end

function NDM.Money.Deposit(src, venueId, amount, account)
    local tx, err = prepare(src, venueId, amount, account)
    if not tx then return false, err end
    if not NDM.Venue.HasPerm(venueId, tx.src, 'manage_finances') then return false, 'no_permission' end
    return moveIn(tx, 'deposit', 'Owner or staff deposit')
end

function NDM.Money.Withdraw(src, venueId, amount, account)
    local tx, err = prepare(src, venueId, amount, account)
    if not tx then return false, err end
    if not NDM.Venue.HasPerm(venueId, tx.src, 'manage_finances') then return false, 'no_permission' end
    return moveOut(tx, 'withdraw', 'Owner or staff withdrawal')
end
