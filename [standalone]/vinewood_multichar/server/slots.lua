Slots = {}

local settings      -- merged settings table
local overrides = {} -- [identifier] = { mode, slots, note, name, set_by, updated_at }

local function defaults()
    return {
        base = Config.Slots.Base,
        max = Config.Slots.Max,
        stack = Config.Slots.Stack,
        showLocked = Config.Slots.ShowLocked,
        lockExcess = Config.Slots.LockExcess,
        lockedText = Config.LockedText,
        lockedLink = Config.LockedLink,
        sceneMode = Config.SceneMode,
        fixedScene = nil,
        aceBonuses = VMC.Copy(Config.AceBonuses),
        discordRoles = VMC.Copy(ServerConfig.Discord.Roles),
        theme = VMC.SanitiseTheme({}),
        allowDelete = Config.Character.AllowDelete,
    }
end

function Slots.Load()
    local saved = DB.GetSetting('settings', nil)
    settings = defaults()
    if type(saved) == 'table' then
        for k, v in pairs(saved) do settings[k] = v end
    end
    settings.theme = VMC.SanitiseTheme(settings.theme)
    overrides = {}
    local rows = MySQL.query.await('SELECT * FROM vinewood_multichar_slots') or {}
    for _, r in ipairs(rows) do overrides[r.identifier] = r end
end

function Slots.GetSettings()
    if not settings then Slots.Load() end
    return settings
end

function Slots.SaveSettings(new)
    local s = Slots.GetSettings()
    s.base = math.floor(VMC.Num(new.base, s.base, 1, 50))
    s.max = math.floor(VMC.Num(new.max, s.max, s.base, 50))
    s.stack = new.stack == true
    s.showLocked = math.floor(VMC.Num(new.showLocked, s.showLocked, 0, 10))
    s.lockExcess = new.lockExcess == true
    s.allowDelete = new.allowDelete == true
    s.lockedText = VMC.Str(new.lockedText, 200, s.lockedText)
    s.lockedLink = VMC.Str(new.lockedLink, 120, s.lockedLink)
    s.sceneMode = (new.sceneMode == 'fixed') and 'fixed' or 'random'
    s.fixedScene = tonumber(new.fixedScene)

    local aces = {}
    if type(new.aceBonuses) == 'table' then
        for _, a in ipairs(new.aceBonuses) do
            local ace = VMC.Str(a.ace, 64)
            if ace and ace ~= '' then
                aces[#aces + 1] = { ace = ace, slots = math.floor(VMC.Num(a.slots, 1, -10, 50)), label = VMC.Str(a.label, 32, ace) }
            end
        end
    end
    s.aceBonuses = aces

    local roles = {}
    if type(new.discordRoles) == 'table' then
        for _, r in ipairs(new.discordRoles) do
            local id = VMC.Str(tostring(r.roleId or ''), 24)
            if id and id:match('^%d+$') then
                roles[#roles + 1] = { roleId = id, slots = math.floor(VMC.Num(r.slots, 1, -10, 50)), label = VMC.Str(r.label, 32, id) }
            end
        end
    end
    s.discordRoles = roles

    if type(new.theme) == 'table' then
        s.theme = VMC.SanitiseTheme(new.theme, s.theme)
        s.theme.rev = os.time()
    end

    DB.SetSetting('settings', s)
    return s
end

-- Overrides -----------------------------------------------------------------------
function Slots.GetOverrides()
    local list = {}
    for _, o in pairs(overrides) do list[#list + 1] = o end
    table.sort(list, function(a, b) return (a.name or a.identifier) < (b.name or b.identifier) end)
    return list
end

function Slots.SetOverride(identifier, mode, amount, note, name, by)
    identifier = VMC.Str(identifier, 80)
    if not identifier or not identifier:match('^%w+:%w+$') then return false, 'Identifier must look like license:abc123 or discord:1234' end
    mode = mode == 'set' and 'set' or 'add'
    amount = math.floor(VMC.Num(amount, 0, -50, 50))
    note = VMC.Str(note, 128)
    name = VMC.Str(name, 64)
    MySQL.query.await([[INSERT INTO vinewood_multichar_slots (identifier, mode, slots, note, name, set_by) VALUES (?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE mode = VALUES(mode), slots = VALUES(slots), note = VALUES(note), name = COALESCE(VALUES(name), name), set_by = VALUES(set_by)]],
        { identifier, mode, amount, note, name, by })
    overrides[identifier] = { identifier = identifier, mode = mode, slots = amount, note = note, name = name or (overrides[identifier] and overrides[identifier].name), set_by = by }
    return true
end

function Slots.RemoveOverride(identifier)
    MySQL.query.await('DELETE FROM vinewood_multichar_slots WHERE identifier = ?', { identifier })
    overrides[identifier] = nil
end

local function findOverride(src)
    for _, id in ipairs(Bridge.GetIdentifiers(src)) do
        if overrides[id] then return overrides[id] end
    end
end

-- Main calculation ------------------------------------------------------------------
-- Returns total slots and a breakdown the admin menu (and player UI) can show
function Slots.GetAllowed(src)
    local s = Slots.GetSettings()
    local breakdown = { { label = 'Base', slots = s.base } }
    local bonuses = {}

    for _, a in ipairs(s.aceBonuses or {}) do
        if IsPlayerAceAllowed(src, a.ace) then
            bonuses[#bonuses + 1] = { label = a.label or a.ace, slots = a.slots, source = 'ace' }
        end
    end

    if Discord.Enabled() and #(s.discordRoles or {}) > 0 then
        local roles = Discord.GetPlayerRoles(src)
        local has = {}
        for _, r in ipairs(roles) do has[r] = true end
        for _, r in ipairs(s.discordRoles) do
            if has[r.roleId] then
                bonuses[#bonuses + 1] = { label = r.label or r.roleId, slots = r.slots, source = 'discord' }
            end
        end
    end

    local o = findOverride(src)
    if o and o.mode == 'add' then
        bonuses[#bonuses + 1] = { label = o.note and ('Personal: ' .. o.note) or 'Personal bonus', slots = o.slots, source = 'personal' }
    end

    local total = s.base
    if s.stack then
        for _, b in ipairs(bonuses) do total = total + b.slots; breakdown[#breakdown + 1] = b end
    else
        local best
        for _, b in ipairs(bonuses) do if not best or b.slots > best.slots then best = b end end
        if best then total = total + best.slots; breakdown[#breakdown + 1] = best end
    end

    if o and o.mode == 'set' then
        total = o.slots
        breakdown = { { label = o.note and ('Set by staff: ' .. o.note) or 'Set by staff', slots = o.slots, source = 'personal' } }
    end

    total = math.floor(VMC.Clamp(total, 1, s.max))
    return total, breakdown
end

CreateThread(function()
    DB.Await()
    Slots.Load()
end)
