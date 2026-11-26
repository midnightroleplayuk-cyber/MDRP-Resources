-- Everything that touches the framework lives here, so swapping Qbox for
-- something else means editing this one file.

Framework = {}

local function getPlayer(src)
    return exports.qbx_core:GetPlayer(src)
end

---@return string? citizenid, string? name
function Framework.identity(src)
    local player = getPlayer(src)
    if not player then return end
    local info = player.PlayerData.charinfo
    return player.PlayerData.citizenid, ('%s %s'):format(info.firstname, info.lastname)
end

-- Takes the fee from the first account that can cover it.
function Framework.charge(src, amount, reason)
    if amount <= 0 then return true end
    local player = getPlayer(src)
    if not player then return false end

    for _, account in ipairs(Config.Payment) do
        if (player.PlayerData.money[account] or 0) >= amount then
            if player.Functions.RemoveMoney(account, amount, reason) then
                return true
            end
        end
    end
    return false
end

function Framework.refund(src, amount, reason)
    if amount <= 0 then return end
    local player = getPlayer(src)
    if player then player.Functions.AddMoney(Config.Payment[1], amount, reason) end
end

function Framework.notify(src, text, kind)
    TriggerClientEvent('ox_lib:notify', src, { title = 'Bowling', description = text, type = kind or 'inform' })
end
