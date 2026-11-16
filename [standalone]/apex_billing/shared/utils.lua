--[[
    Apex Billing — Shared utilities
]]

Utils = Utils or {}

function Utils.money(n)
    n = math.floor(tonumber(n) or 0)
    local cur = (Config and Config.currency) or { symbol = '$', position = 'before' }
    local neg = n < 0; n = math.abs(n)
    local s, k = tostring(n), 0
    s = s:reverse():gsub('(%d%d%d)', function(c) k = k + 1; return k > 0 and (c .. ',') or c end):reverse()
    s = s:gsub('^,', '')
    if cur.position == 'after' then return (neg and '-' or '') .. s .. ' ' .. (cur.symbol or '$') end
    return (neg and '-' or '') .. (cur.symbol or '$') .. s
end

function Utils.now() return os.time() end

function Utils.makeInvoiceNumber()
    local cfg = (Config and Config.invoice) or { prefix = 'INV', digits = 6 }
    local digits = math.max(4, math.min(10, tonumber(cfg.digits) or 6))
    local num = ''
    for _ = 1, digits do num = num .. tostring(math.random(0, 9)) end
    if cfg.yearInNumber then
        return ('%s-%d-%s'):format(cfg.prefix or 'INV', os.date('*t').year, num)
    end
    return (cfg.prefix or 'INV') .. num
end

function Utils.defaultDueAt()
    local days = (Config and Config.invoice and Config.invoice.defaultDueDays) or 7
    return os.time() + days * 86400
end

function Utils.calcTotals(items, vatRate)
    local sub = 0
    for _, it in ipairs(items or {}) do
        local qty = math.max(1, math.floor(tonumber(it.qty) or 1))
        local price = math.max(0, math.floor(tonumber(it.price) or 0))
        sub = sub + (qty * price)
    end
    local tax = math.floor(sub * math.max(0, tonumber(vatRate) or 0))
    return sub, tax, sub + tax
end

function Utils.shortId()
    local s = ''
    for _ = 1, 8 do
        local r = math.random(0, 35)
        s = s .. (r < 10 and tostring(r) or string.char(55 + r))
    end
    return s
end

function Utils.trim(s) return (tostring(s or ''):gsub('^%s*(.-)%s*$', '%1')) end

function Utils.bool(v)
    if v == nil then return false end
    if type(v) == 'boolean' then return v end
    return v == 1 or v == '1' or v == 'true'
end

function Utils.Ok(...)    print('^2[apex_billing]^7', ...) end
function Utils.Info(...)  print('^5[apex_billing]^7', ...) end
function Utils.Warn(...)  print('^3[apex_billing]^7', ...) end
function Utils.Error(...) print('^1[apex_billing]^7', ...) end
