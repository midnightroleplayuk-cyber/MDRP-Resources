local RESOURCE = GetCurrentResourceName()
local stands, purchaseCooldown, claimCooldown = {}, {}, {}
local purchaseLimits = {}
local nextStandId = 1

math.randomseed(os.time())

local function notify(src, description, kind)
    TriggerClientEvent('ox_lib:notify', src, { description = description, type = kind or 'inform' })
end

local function discordLog(src, title, description, fields, pingRoleId)
    local cfg = Config.DiscordLogging
    if not cfg or cfg.Enabled ~= true or not cfg.Webhook or cfg.Webhook == '' then return end

    local name = src and GetPlayerName(src) or 'Server'
    local identifiers = src and GetPlayerIdentifiers(src) or {}
    local safeFields = {
        { name = 'Player', value = name or 'Unknown', inline = true },
        { name = 'Server ID', value = src and tostring(src) or 'N/A', inline = true },
    }
    if src then
        safeFields[#safeFields + 1] = { name = 'Identifiers', value = (#identifiers > 0 and table.concat(identifiers, '\n') or 'None'), inline = false }
    end
    for _, field in ipairs(fields or {}) do safeFields[#safeFields + 1] = field end

    local payload = {
        username = cfg.Username or 'HF1 Scratchcards',
        avatar_url = cfg.AvatarUrl or '',
        embeds = {{
            title = title,
            description = description,
            fields = safeFields,
            footer = { text = 'hf1_scratchcard' },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
        }}
    }

    -- Discord pings are opt-in and restricted to the configured role only.
    -- allowed_mentions prevents any metadata/player-controlled text from creating mentions.
    if pingRoleId and tostring(pingRoleId):match('^%d+$') then
        pingRoleId = tostring(pingRoleId)
        payload.content = ('<@&%s> High-value scratchcard win claimed.'):format(pingRoleId)
        payload.allowed_mentions = { parse = {}, roles = { pingRoleId } }
    else
        payload.allowed_mentions = { parse = {} }
    end
    PerformHttpRequest(cfg.Webhook, function() end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

local function isManager(src)
    if Config.ManagerAce and IsPlayerAceAllowed(src, Config.ManagerAce) then return true end
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        for _, allowed in ipairs(Config.AllowedIdentifiers or {}) do
            if identifier == allowed then return true end
        end
    end
    return false
end

local function getPurchaseIdentifier(src)
    -- Tie the limit to the player's Rockstar license, not their temporary server ID.
    -- This means reconnecting does not reset the rolling 24-hour allowance.
    local fallback
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if identifier:sub(1, 8) == 'license:' then return identifier end
        if not fallback and identifier:sub(1, 9) == 'license2:' then fallback = identifier end
    end
    return fallback
end

local function savePurchaseLimits()
    SaveResourceFile(RESOURCE, Config.PurchaseLimitFile or 'purchase_limits.json', json.encode(purchaseLimits), -1)
end

local function loadPurchaseLimits()
    local raw = LoadResourceFile(RESOURCE, Config.PurchaseLimitFile or 'purchase_limits.json')
    if not raw or raw == '' then return end
    local decoded = json.decode(raw)
    if type(decoded) == 'table' then purchaseLimits = decoded end
end

local function prunePurchases(identifier, now)
    local window = math.max(1, tonumber(Config.PurchaseLimitWindowSeconds) or 86400)
    local cutoff = now - window
    local existing = purchaseLimits[identifier]
    local kept = {}
    if type(existing) == 'table' then
        for _, timestamp in ipairs(existing) do
            timestamp = tonumber(timestamp)
            if timestamp and timestamp > cutoff and timestamp <= now then
                kept[#kept + 1] = timestamp
            end
        end
    end
    purchaseLimits[identifier] = kept
    return kept
end

local function canPurchaseCard(src, now)
    local maximum = math.floor(tonumber(Config.MaximumScratchcardsPer24Hours) or 0)
    if maximum <= 0 then return true, nil end
    local identifier = getPurchaseIdentifier(src)
    if not identifier then return false, nil end
    local purchases = prunePurchases(identifier, now)
    return #purchases < maximum, identifier
end

local function recordPurchase(identifier, now)
    if not identifier then return end
    local purchases = prunePurchases(identifier, now)
    purchases[#purchases + 1] = now
    purchaseLimits[identifier] = purchases
    savePurchaseLimits()
end

local function standTable()
    local name = tostring(Config.StandTable or 'hf1_scratchcard_stands')
    -- table names cannot be parameter-bound, so restrict the configurable name to safe SQL identifier chars.
    if not name:match('^[%w_]+$') then name = 'hf1_scratchcard_stands' end
    return name
end

local function saveStands()
    -- Stands are written immediately by place/delete operations. Kept as a no-op for older call sites.
end

local function loadStands()
    if not Config.PersistStands then return end
    local tableName = standTable()
    MySQL.query.await(([=[CREATE TABLE IF NOT EXISTS `%s` (
        `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
        `x` DOUBLE NOT NULL,
        `y` DOUBLE NOT NULL,
        `z` DOUBLE NOT NULL,
        `h` DOUBLE NOT NULL DEFAULT 0,
        `label` VARCHAR(100) NULL,
        `created_by` VARCHAR(100) NULL,
        `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]=]):format(tableName))
    stands = MySQL.query.await(('SELECT id, x, y, z, h, label FROM `%s` ORDER BY id ASC'):format(tableName)) or {}
end

local function broadcastStands(target)
    TriggerClientEvent('hf1_scratchcard:client:setStands', target or -1, stands)
end

local function getStand(id)
    id = tonumber(id)
    for _, stand in ipairs(stands) do
        if tonumber(stand.id) == id then return stand end
    end
end

local function nearStand(src, id)
    local stand = getStand(id)
    if not stand then return false end
    local ped = GetPlayerPed(src)
    if not ped or ped <= 0 then return false end
    local p = GetEntityCoords(ped)
    return #(p - vector3(stand.x, stand.y, stand.z)) <= Config.ClaimDistance
end

local function shuffledCopy(t)
    local copy = {}
    for i = 1, #t do copy[i] = t[i] end
    for i = #copy, 2, -1 do
        local j = math.random(i)
        copy[i], copy[j] = copy[j], copy[i]
    end
    return copy
end

local function weightedPrize()
    local pool, total = {}, 0.0
    for _, entry in ipairs(Config.Prizes or {}) do
        local amount = math.min(tonumber(entry.amount) or 0, Config.MaximumWin)
        local weight = tonumber(entry.weight) or 0
        if amount > 0 and weight > 0 then
            total = total + weight
            pool[#pool + 1] = { amount = amount, upto = total }
        end
    end
    if total <= 0 then return math.min(100, Config.MaximumWin) end
    local roll = math.random() * total
    for _, entry in ipairs(pool) do if roll <= entry.upto then return entry.amount end end
    return pool[#pool].amount
end

local function makeLosingGrid()
    local values = shuffledCopy(Config.DisplayAmounts)
    local grid, index = {}, 1
    while #grid < 9 do
        local value = values[index]
        index = index + 1
        if not value then values, index = shuffledCopy(Config.DisplayAmounts), 2; value = values[1] end
        local count = math.min(2, 9 - #grid)
        for _ = 1, count do grid[#grid + 1] = value end
    end
    return shuffledCopy(grid)
end

local function makeWinningGrid(prize)
    local clean = {}
    for _, value in ipairs(makeLosingGrid()) do
        if value ~= prize and #clean < 6 then clean[#clean + 1] = value end
    end
    while #clean < 6 do
        local value = Config.DisplayAmounts[math.random(#Config.DisplayAmounts)]
        local count = 0
        for _, existing in ipairs(clean) do if existing == value then count = count + 1 end end
        if value ~= prize and count < 2 then clean[#clean + 1] = value end
    end
    clean[#clean + 1], clean[#clean + 1], clean[#clean + 1] = prize, prize, prize
    return shuffledCopy(clean)
end

local function makeCardMetadata()
    local mainWin = math.random() < Config.WinChance
    local mainPrize = mainWin and weightedPrize() or 0

    -- Bonus is independent: a crown always adds Config.BonusPrize, whether or not
    -- the main 3-match game also won.
    local bonusWin = math.random() < Config.BonusWinShare
    local bonusPrize = bonusWin and math.max(0, tonumber(Config.BonusPrize) or 2000) or 0
    local totalPrize = math.min(mainPrize + bonusPrize, tonumber(Config.MaximumTotalWin) or (Config.MaximumWin + bonusPrize))
    local bonus = bonusWin and Config.BonusSymbol or Config.LosingBonusSymbols[math.random(#Config.LosingBonusSymbols)]

    return {
        label = 'Scratchcard',
        description = 'A UK-style scratchcard. Use it to scratch the panels, then claim it at a scratchcard stand.',
        cardId = ('SC-%s-%06d-%06d'):format(os.time(), math.random(0, 999999), math.random(0, 999999)),
        grid = mainWin and makeWinningGrid(mainPrize) or makeLosingGrid(),
        bonus = bonus,
        winner = totalPrize > 0,
        prize = totalPrize, -- backwards-compatible total used by redemption
        mainPrize = mainPrize,
        bonusPrize = bonusPrize,
        bonusWin = bonusWin,
        generatedBy = RESOURCE,
        scratched = false
    }
end

local function payout(src, amount)
    amount = math.floor(math.min(tonumber(amount) or 0, tonumber(Config.MaximumTotalWin) or Config.MaximumWin))
    if amount <= 0 then return false end

    -- LGMods_Banking's public store page does not document a player-credit export.
    -- On Qbox its personal bank is framework-backed, so qbx_core bank money is the
    -- safe integration path and is reflected by LGMods_Banking.
    return exports.qbx_core:AddMoney(src, Config.PayoutAccount, amount, 'scratchcard-win') == true
end

RegisterNetEvent('hf1_scratchcard:server:requestStands', function() broadcastStands(source) end)

RegisterNetEvent('hf1_scratchcard:server:requestManageStands', function()
    local src = source
    if not isManager(src) then return notify(src, 'You are not authorised to manage scratchcard stands.', 'error') end
    TriggerClientEvent('hf1_scratchcard:client:showPlacedStands', src, stands)
end)

RegisterNetEvent('hf1_scratchcard:server:placeStand', function(data)
    local src = source
    if not isManager(src) then return notify(src, 'You are not authorised to place scratchcard stands.', 'error') end
    if type(data) ~= 'table' then return end
    local x, y, z, h = tonumber(data.x), tonumber(data.y), tonumber(data.z), tonumber(data.h)
    if not x or not y or not z or not h then return notify(src, 'Invalid stand position.', 'error') end

    -- Never trust placement coordinates supplied by the client. Managers may only
    -- save a stand close to their actual server-side ped position.
    local ped = GetPlayerPed(src)
    if ped == 0 then return notify(src, 'Could not verify your position.', 'error') end
    local pcoords = GetEntityCoords(ped)
    local maxPlacementDistance = (tonumber(Config.PlacementMaxDistance) or 12.0) + 2.0
    local dx, dy, dz = x - pcoords.x, y - pcoords.y, z - pcoords.z
    if math.sqrt(dx * dx + dy * dy + dz * dz) > maxPlacementDistance then
        return notify(src, 'That placement is too far away.', 'error')
    end

    local tableName = standTable()
    local creator = getPurchaseIdentifier(src) or 'unknown'
    local id = MySQL.insert.await(('INSERT INTO `%s` (x, y, z, h, created_by) VALUES (?, ?, ?, ?, ?)'):format(tableName), { x, y, z, h, creator })
    if not id then return notify(src, 'Could not save the scratchcard stand to the database.', 'error') end

    stands[#stands + 1] = { id = id, x = x, y = y, z = z, h = h }
    broadcastStands()
    if Config.DiscordLogging and Config.DiscordLogging.LogStandChanges then
        discordLog(src, 'Scratchcard Stand Placed', ('Stand #%s was placed.'):format(id), {{ name = 'Coordinates', value = ('%.2f, %.2f, %.2f'):format(x, y, z), inline = false }})
    end
    notify(src, ('Scratchcard stand #%s placed and saved to the database.'):format(id), 'success')
end)

RegisterNetEvent('hf1_scratchcard:server:deleteStand', function(id)
    local src = source
    if not isManager(src) then return notify(src, 'You are not authorised to remove scratchcard stands.', 'error') end
    id = tonumber(id)
    if not id then return end

    local found
    for i = #stands, 1, -1 do
        if tonumber(stands[i].id) == id then found = stands[i]; table.remove(stands, i); break end
    end
    if not found then return notify(src, 'That scratchcard stand no longer exists.', 'error') end

    local affected = MySQL.update.await(('DELETE FROM `%s` WHERE id = ?'):format(standTable()), { id })
    if not affected or affected < 1 then
        stands[#stands + 1] = found
        return notify(src, 'Could not remove the stand from the database.', 'error')
    end
    broadcastStands()
    if Config.DiscordLogging and Config.DiscordLogging.LogStandChanges then
        discordLog(src, 'Scratchcard Stand Removed', ('Stand #%s was removed.'):format(id), {})
    end
    notify(src, ('Scratchcard stand #%s removed.'):format(id), 'success')
end)

RegisterNetEvent('hf1_scratchcard:server:buyCard', function(standId)
    local src = source
    if not nearStand(src, standId) then return end
    local now = os.time()
    if purchaseCooldown[src] and purchaseCooldown[src] >= now then return end
    purchaseCooldown[src] = now + 2

    local allowed, purchaseIdentifier = canPurchaseCard(src, now)
    if not allowed then
        return notify(src, Config.PurchaseLimitMessage or 'Sorry, we are out of stock, please visit later.', 'error')
    end
    if (tonumber(Config.MaximumScratchcardsPer24Hours) or 0) > 0 and not purchaseIdentifier then
        return notify(src, 'Unable to verify your scratchcard purchase allowance.', 'error')
    end

    local money = exports.qbx_core:GetMoney(src, Config.PaymentAccount)
    if not money or money < Config.CardPrice then
        return notify(src, ('You need £%s to buy a scratchcard.'):format(Config.CardPrice), 'error')
    end

    if not exports.ox_inventory:CanCarryItem(src, Config.ItemName, 1) then
        return notify(src, 'You do not have enough inventory space.', 'error')
    end

    if not exports.qbx_core:RemoveMoney(src, Config.PaymentAccount, Config.CardPrice, 'scratchcard-purchase') then
        return notify(src, 'Payment failed.', 'error')
    end

    local metadata = makeCardMetadata()
    local success = exports.ox_inventory:AddItem(src, Config.ItemName, 1, metadata)
    if not success then
        exports.qbx_core:AddMoney(src, Config.PaymentAccount, Config.CardPrice, 'scratchcard-refund')
        return notify(src, 'Could not give you the scratchcard. Your payment was refunded.', 'error')
    end
    recordPurchase(purchaseIdentifier, now)
    if Config.DiscordLogging and Config.DiscordLogging.LogPurchases then
        discordLog(src, 'Scratchcard Purchased', ('A player purchased a scratchcard for £%s.'):format(Config.CardPrice), {
            { name = 'Card ID', value = tostring(metadata.cardId or 'Unknown'), inline = true },
            { name = 'Payment Account', value = tostring(Config.PaymentAccount), inline = true },
        })
    end
    notify(src, 'Scratchcard purchased. Check your inventory to scratch it.', 'success')
end)

RegisterNetEvent('hf1_scratchcard:server:markScratched', function(slotId, cardId)
    local src = source
    slotId = tonumber(slotId)
    cardId = tostring(cardId or '')
    if not slotId or cardId == '' then return end

    local slot = exports.ox_inventory:GetSlot(src, slotId)
    if not slot or slot.name ~= Config.ItemName then return end

    local meta = slot.metadata or {}
    if meta.generatedBy ~= RESOURCE or tostring(meta.cardId or '') ~= cardId then return end
    if meta.scratched == true then return end

    -- The client only sends this after all 9 amount panels and the bonus panel
    -- have independently reached the configured 58% reveal threshold.
    meta.scratched = true
    meta.scratchedAt = os.time()
    exports.ox_inventory:SetMetadata(src, slotId, meta)
    notify(src, 'Scratchcard fully revealed. You can now claim it at a scratchcard stand.', 'success')
end)

RegisterNetEvent('hf1_scratchcard:server:claimWinnings', function(standId)
    local src = source
    if not nearStand(src, standId) then return end
    local now = os.time()
    if claimCooldown[src] and claimCooldown[src] >= now then return end
    claimCooldown[src] = now + 2

    local slots = exports.ox_inventory:Search(src, 'slots', Config.ItemName)
    if type(slots) ~= 'table' or next(slots) == nil then
        return notify(src, 'Error: You do not have a scratchcard.', 'error')
    end

    local winnerSlot, loserSlot, hasUnscratched
    for _, slot in pairs(slots) do
        local meta = slot.metadata or {}
        if meta.generatedBy == RESOURCE then
            if meta.scratched == true then
                if meta.winner == true and tonumber(meta.prize) and tonumber(meta.prize) > 0 then
                    winnerSlot = slot
                    break
                elseif not loserSlot then
                    loserSlot = slot
                end
            else
                hasUnscratched = true
            end
        end
    end

    -- Never consume an unopened/partially scratched ticket. This applies to
    -- winners and losers alike, so Claim Winnings cannot be used to reveal a result.
    if not winnerSlot and not loserSlot and hasUnscratched then
        return notify(src, 'Error: You must scratch the card before claiming winnings.', 'error')
    end

    if winnerSlot then
        local meta = winnerSlot.metadata
        local amount = math.floor(math.min(tonumber(meta.prize) or 0, tonumber(Config.MaximumTotalWin) or Config.MaximumWin))
        if amount <= 0 then return end

        -- Remove first. The physical item is the bearer ticket: whoever currently
        -- possesses it can redeem it, and the same card can never be paid twice.
        local removed = exports.ox_inventory:RemoveItem(src, Config.ItemName, 1, nil, winnerSlot.slot)
        if not removed then return notify(src, 'Unable to redeem that scratchcard.', 'error') end

        if not payout(src, amount) then
            -- Restore the exact ticket if the banking/framework payout failed.
            exports.ox_inventory:AddItem(src, Config.ItemName, 1, meta)
            return notify(src, 'The payout failed. Your winning scratchcard was returned.', 'error')
        end

        if Config.DiscordLogging and Config.DiscordLogging.LogWins then
            local pingRoleId
            local highValue = Config.DiscordLogging.HighValueWinPing
            if highValue and highValue.Enabled == true
                and amount >= math.max(0, tonumber(highValue.Threshold) or 2000)
                and highValue.RoleId and tostring(highValue.RoleId) ~= '' then
                pingRoleId = tostring(highValue.RoleId)
            end

            discordLog(src, 'Scratchcard Winner Claimed', ('A winning scratchcard was redeemed for £%s.'):format(amount), {
                { name = 'Card ID', value = tostring(meta.cardId or 'Unknown'), inline = true },
                { name = 'Main Prize', value = ('£%s'):format(tonumber(meta.mainPrize) or 0), inline = true },
                { name = 'Bonus Prize', value = ('£%s'):format(tonumber(meta.bonusPrize) or 0), inline = true },
                { name = 'Total Payout', value = ('£%s'):format(amount), inline = true },
                { name = 'Payout Account', value = tostring(Config.PayoutAccount), inline = true },
                { name = 'High Value Alert', value = pingRoleId and 'Yes - role ping sent' or 'No', inline = true },
            }, pingRoleId)
        end
        return notify(src, ('Winner! £%s has been paid into your %s account.'):format(amount, Config.PayoutAccount), 'success')
    end

    if loserSlot then
        exports.ox_inventory:RemoveItem(src, Config.ItemName, 1, nil, loserSlot.slot)
        if Config.DiscordLogging and Config.DiscordLogging.LogLosingClaims then
            discordLog(src, 'Losing Scratchcard Submitted', 'A player attempted to claim a losing scratchcard; the losing card was deleted.', {
                { name = 'Card ID', value = tostring((loserSlot.metadata or {}).cardId or 'Unknown'), inline = true },
            })
        end
    end
    notify(src, 'Error: You do not have a winner.', 'error')
end)

RegisterCommand('scard', function(src)
    if src == 0 then return end
    if not isManager(src) then return notify(src, 'You are not authorised to use /scard.', 'error') end
    TriggerClientEvent('hf1_scratchcard:client:managerMenu', src)
end, false)

AddEventHandler('playerDropped', function()
    purchaseCooldown[source], claimCooldown[source] = nil, nil
end)

MySQL.ready(function()
    loadStands()
    broadcastStands()
end)
loadPurchaseLimits()
