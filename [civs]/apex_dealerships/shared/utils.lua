--[[ apex_dealerships — shared/utils.lua (open source) ]]

Utils = Utils or {}

function Utils.Debug(...)
    if not Config.debug then return end
    print(('[apex_dealerships] %s'):format(table.concat({ ... }, ' ')))
end

function Utils.Err(...)
    print(('^1[apex_dealerships] %s^0'):format(table.concat({ ... }, ' ')))
end

function Utils.Round(n, dp)
    local mult = 10 ^ (dp or 0)
    return math.floor((tonumber(n) or 0) * mult + 0.5) / mult
end

function Utils.Money(n)
    n = math.floor(tonumber(n) or 0)
    local s = tostring(n):reverse():gsub('(%d%d%d)', '%1,'):reverse():gsub('^,', '')
    if Config.currency.position == 'after' then
        return s .. Config.currency.symbol
    end
    return Config.currency.symbol .. s
end

function Utils.Clamp(n, lo, hi)
    n = tonumber(n) or lo
    if n < lo then return lo end
    if n > hi then return hi end
    return n
end

-- Sanitize an amount coming from the NUI/client: positive integer or nil
function Utils.SafeAmount(n)
    n = math.floor(tonumber(n) or 0)
    if n <= 0 then return nil end
    return n
end

-- oxmysql returns TINYINT(1) columns as booleans — treat 1/true alike
function Utils.IsTrue(v)
    return v == 1 or v == true
end

function Utils.TableContains(tbl, value)
    if not tbl then return false end
    for _, v in pairs(tbl) do
        if v == value then return true end
    end
    return false
end

function Utils.CategoryLabel(key)
    for _, c in ipairs(Config.categories) do
        if c.key == key then return c.label end
    end
    return key
end

-- Permissions resolved from Config.roles. ADMIN implies everything.
function Utils.RoleHasPermission(role, permission)
    local perms = Config.roles[role]
    if not perms then return false end
    for _, p in ipairs(perms) do
        if p == 'ADMIN' or p == permission then return true end
    end
    return false
end

Locales = Locales or {}
Locales.dict = Locales.dict or {}

function Locales.t(key, ...)
    local lang = Locales.dict[Config.locale] or Locales.dict['en'] or {}
    local str = lang[key] or (Locales.dict['en'] and Locales.dict['en'][key]) or key
    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, str, ...)
        if ok then return formatted end
    end
    return str
end
