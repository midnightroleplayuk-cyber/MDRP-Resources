--[[ ─────────────────────────────────────────────────────────────
    GANGS (open file)
    Shows each character's gang on the selection screen.

    Mode:
      'auto'           vinewood_gangs if running, then any SQL mapping
                       below whose resource is running, then the
                       framework's own gang (Qbox / QBCore)
      'framework'      Qbox / QBCore players.gang column only
      'vinewood_gangs' Vinewood gangs export only
      'sql'            your SQL mapping only
      'none'           hide gangs
───────────────────────────────────────────────────────────── ]]
GangConfig = {
    Mode = 'auto',

    -- Labels treated as "not in a gang"
    NoGang = { none = true, [''] = true, unemployed = true },

    --[[ Third-party gang scripts keep members in their own tables, and
        every script (and version) names them differently. Map yours here.
        Characters are offline on the selection screen, so this reads the
        database rather than calling the script's online-only exports.

        resource    the gang resource name (only used while it's running)
        members     table holding gang members
        idColumn    column holding the citizenid / ESX identifier
        gangColumn  column holding the gang name/id
        rankColumn  column holding the rank label or number (optional)
        gangs       table holding gang info (optional, for nice labels)
        gangKey     column in `gangs` matching gangColumn
        gangLabel   column in `gangs` with the display name

      Example:
        {
            resource = 'my_gangs',
            members = 'gang_members', idColumn = 'citizenid', gangColumn = 'gang', rankColumn = 'rank',
            gangs = 'gangs', gangKey = 'name', gangLabel = 'label',
        },
    ]]
    Sql = {},

    -- Gang resources we look out for. If one is running without a mapping
    -- above, the console tells you, and the framework gang is used meanwhile.
    Known = {
        'rcore_gangs', 'brutal_gangs', 'cb-gangsystem', 'op-crime', 'ak47_gangs', 'ak47_qb_gangs',
        'qs-gangs', 'codem-gangs', 'lation_gangs', 'kartik-gangs', 'vanishdev_gangs', 'mt-gangs',
    },
}

Gangs = {}

local function started(r) return GetResourceState(r) == 'started' end
local function ident(n) return type(n) == 'string' and n:match('^[%w_]+$') ~= nil end

local function isNone(label)
    return not label or GangConfig.NoGang[tostring(label):lower()] or tostring(label):lower():find('^no gang') ~= nil
end

-- Vinewood gangs: exports.vinewood_gangs:GetCharacterGangs({ ids }) -> { [id] = { label, rank, colour, logo } }
local function fromVinewood(chars, ids)
    local ok, map = pcall(function() return exports.vinewood_gangs:GetCharacterGangs(ids) end)
    if not ok or type(map) ~= 'table' then
        map = {}
        for _, id in ipairs(ids) do
            local ok2, g = pcall(function() return exports.vinewood_gangs:GetCharacterGang(id) end)
            if ok2 and g then map[id] = g end
        end
    end
    for _, c in ipairs(chars) do
        local g = map[c.id]
        if g then
            c.gang, c.gangRank = g.label or g.name, g.rank or g.rankLabel
            c.gangColour = type(g.colour) == 'string' and g.colour:match('^#%x%x%x%x%x%x$') and g.colour or nil
            c.gangLogo = type(g.logo) == 'string' and g.logo:match('^https://[^%s"\'<>]+$') and g.logo or nil
        else
            c.gang, c.gangRank = nil, nil -- vinewood_gangs is the source of truth when it's running
        end
    end
    return true
end

local function fromSql(m, chars, ids)
    if not (ident(m.members) and ident(m.idColumn) and ident(m.gangColumn)) then return false end
    local rankSel = ident(m.rankColumn) and (', m.`%s` AS r'):format(m.rankColumn) or ''
    local q
    if ident(m.gangs) and ident(m.gangKey) and ident(m.gangLabel) then
        q = ('SELECT m.`%s` AS id, m.`%s` AS g, g.`%s` AS l%s FROM `%s` m LEFT JOIN `%s` g ON g.`%s` = m.`%s` WHERE m.`%s` IN (?)')
            :format(m.idColumn, m.gangColumn, m.gangLabel, rankSel, m.members, m.gangs, m.gangKey, m.gangColumn, m.idColumn)
    else
        q = ('SELECT m.`%s` AS id, m.`%s` AS g%s FROM `%s` m WHERE m.`%s` IN (?)')
            :format(m.idColumn, m.gangColumn, rankSel, m.members, m.idColumn)
    end
    local ok, rows = pcall(MySQL.query.await, q, { ids })
    if not ok then
        print(('^1[vinewood_multichar]^7 gang mapping for %s failed: %s'):format(tostring(m.resource), tostring(rows)))
        return false
    end
    local map = {}
    for _, r in ipairs(rows or {}) do map[r.id] = r end
    for _, c in ipairs(chars) do
        local r = map[c.id]
        c.gang, c.gangRank = nil, nil
        if r then c.gang, c.gangRank = r.l or r.g, r.r and tostring(r.r) or nil end
    end
    return true
end

-- Framework gang is already on the character from bridge.lua (Qbox / QBCore)
local function fromFramework() return true end

function Gangs.Attach(chars)
    local mode = GangConfig.Mode
    if mode == 'none' then
        for _, c in ipairs(chars) do c.gang, c.gangRank = nil, nil end
        return
    end
    if #chars == 0 then return end
    local ids = {}
    for _, c in ipairs(chars) do ids[#ids + 1] = c.id end

    local done = false
    if (mode == 'auto' or mode == 'vinewood_gangs') and started('vinewood_gangs') then
        done = fromVinewood(chars, ids)
    end
    if not done and (mode == 'auto' or mode == 'sql') then
        for _, m in ipairs(GangConfig.Sql) do
            if not m.resource or started(m.resource) then
                done = fromSql(m, chars, ids)
                if done then break end
            end
        end
    end
    if not done then fromFramework() end

    for _, c in ipairs(chars) do
        if isNone(c.gang) then c.gang, c.gangRank, c.gangColour, c.gangLogo = nil, nil, nil, nil end
    end
end

CreateThread(function()
    Wait(2000)
    local mapped = {}
    for _, m in ipairs(GangConfig.Sql) do if m.resource then mapped[m.resource] = true end end
    for _, r in ipairs(GangConfig.Known) do
        if started(r) and not mapped[r] then
            print(('^3[vinewood_multichar]^7 Found gang resource ^5%s^7. Add a mapping in server/gangs.lua to show its gangs; using the framework gang for now.'):format(r))
        end
    end
    if started('vinewood_gangs') then print('^2[vinewood_multichar]^7 Using vinewood_gangs for gang info.') end
end)
