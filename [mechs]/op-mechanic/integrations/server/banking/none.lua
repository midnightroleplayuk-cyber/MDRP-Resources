if Config.Banking ~= 'none' then return end

local balances = {}

local function jobKey(jobName)
    return tostring(jobName or ''):gsub('^society_', '')
end

local function getBalance(job)
    if balances[job] ~= nil then
        return balances[job]
    end

    local row = MySQL.single.await('SELECT balance FROM opm_society_balances WHERE job = ? LIMIT 1', { job })
    balances[job] = math.floor(tonumber(row and row.balance) or 0)
    return balances[job]
end

local function setBalance(job, amount)
    amount = math.max(0, math.floor(amount))
    balances[job] = amount
    MySQL.update.await([[
        INSERT INTO opm_society_balances (job, balance, updated_at)
        VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE balance = VALUES(balance), updated_at = VALUES(updated_at)
    ]], { job, amount, os.time() })
end

function getAccountMoney(jobName)
    return getBalance(jobKey(jobName))
end

function addAccountMoney(jobName, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return end
    local job = jobKey(jobName)
    setBalance(job, getBalance(job) + amount)
end

function removeAccountMoney(jobName, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return end
    local job = jobKey(jobName)
    local current = getBalance(job)
    if current < amount then return false end
    setBalance(job, current - amount)
end