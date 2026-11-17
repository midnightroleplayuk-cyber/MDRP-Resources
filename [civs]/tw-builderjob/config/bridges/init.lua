
TworstBridge = TworstBridge or {
    registry = {},
    active = nil,
}

TWI18N = TWI18N or {
    map       = {},   -- produced text -> locale key
    ambiguous = {},   -- text produced by two different keys: never rewritten
    skipField = {
        model = true, models = true, modelName = true, prop = true,
        props = true, dict = true, anim = true, animDict = true,
        item = true, items = true, event = true, command = true,
        id = true, zoneId = true, jobType = true, bone = true,
        key = true, lKey = true, labelKey = true, blipNameKey = true,
        vehicle = true, spawnName = true, scenario = true, sound = true,
        texture = true, particle = true, ptfx = true, dictName = true,
    },
}

if type(Locales) == 'table' and Locales.en then
    for name, tbl in pairs(Locales) do
        if name ~= 'en' and type(tbl) == 'table' and not getmetatable(tbl) then
            setmetatable(tbl, { __index = Locales.en })
        end
    end
end

local function activeLocaleTable()
    if type(Locales) ~= 'table' then return nil end
    local code = Config and Config.Locale
    return (code and Locales[code]) or Locales.en
end

CreateThread(function()
    local code = Config and Config.Locale
    if code and type(Locales) == 'table' and not Locales[code] then
        print(('[tw-builderjob] locale "%s" not found — using "en"'):format(tostring(code)))
        Config.Locale = 'en'
    end
    Config.LocaleDefault = Config.Locale
end)

function TL(key, fallback, ...)
    local tbl = activeLocaleTable()
    local s = (tbl and tbl[key]) or fallback or key
    if select('#', ...) > 0 then
        local ok, out = pcall(string.format, s, ...)
        if ok then return out end
        return s
    end
    TWI18N.Remember(s, key)
    return s
end

function TWI18N.Remember(s, key)
    if type(s) ~= 'string' or s == '' then return end
    local prev = TWI18N.map[s]
    if prev == nil then
        TWI18N.map[s] = key
    elseif prev ~= key then
        TWI18N.ambiguous[s] = true
    end
end

local revCand
local function buildReverse()
    revCand = {}
    if type(Locales) ~= 'table' then return end
    for _, tbl in pairs(Locales) do
        if type(tbl) == 'table' then
            for k, v in pairs(tbl) do
                if type(k) == 'string' and type(v) == 'string' and v ~= '' then
                    local list = revCand[v]
                    if not list then
                        revCand[v] = { k }
                    else
                        local seen = false
                        for _, e in ipairs(list) do
                            if e == k then seen = true break end
                        end
                        if not seen then list[#list + 1] = k end
                    end
                end
            end
        end
    end
end

function TWI18N.KeyOfAny(text)
    if type(text) ~= 'string' or text == '' then return nil end
    if not revCand then buildReverse() end
    local list = revCand[text]
    if not list then return nil end
    if #list == 1 then return list[1] end

    local tbl = activeLocaleTable()
    if not tbl then return nil end
    local first
    for _, k in ipairs(list) do
        local v = tbl[k]
        if v == nil then return nil end
        if first == nil then
            first = v
        elseif v ~= first then
            return nil -- candidates differ: leave the text as it is
        end
    end
    return list[1]
end

function TWI18N.Relocalize(root, seen, stats)
    root  = root  or Config
    seen  = seen  or {}
    stats = stats or { n = 0 }
    if type(root) ~= 'table' or seen[root] then return stats.n end
    seen[root] = true

    local tbl = activeLocaleTable()
    if not tbl then return stats.n end

    for k, v in pairs(root) do
        local t = type(v)
        if t == 'table' then
            TWI18N.Relocalize(v, seen, stats)
        elseif t == 'string' and not (type(k) == 'string' and TWI18N.skipField[k]) then
            local key = TWI18N.map[v]
            if key and not TWI18N.ambiguous[v] then
                local nv = tbl[key]
                if type(nv) == 'string' and nv ~= v then
                    root[k] = nv
                    TWI18N.Remember(nv, key)
                    stats.n = stats.n + 1
                end
            end
        end
    end
    return stats.n
end

function TworstBridge.register(bridge)
    if not (bridge and bridge.name) then
        print('^1[tw-builderjob][bridge]^7 register() called without a name field')
        return
    end
    TworstBridge.registry[bridge.name] = bridge
end

function TworstBridge.find(frameworkName)
    if not frameworkName then return nil end
    local direct = TworstBridge.registry[frameworkName]
    if direct then return direct end
    for _, bridge in pairs(TworstBridge.registry) do
        if bridge.accepts then
            for _, alias in ipairs(bridge.accepts) do
                if alias == frameworkName then return bridge end
            end
        end
    end
    return nil
end
