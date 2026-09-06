if not lib then return end

--[[
    Server-wide inventory UI theme.

    An admin (ace `ox_inventory.admin`, same as the stash/shop/craft managers)
    flips "Modo Admin" on in the inventory settings page. From then on every
    visual change they make is broadcast to every connected player and stored,
    so players who connect later get the same look.

    A theme may be `locked`, in which case players cannot change the appearance
    at all; an unlocked theme is applied to everyone once and remains editable.
]]

local UiTheme = {}

local ACE_PERMISSION = 'ox_inventory.admin'
local KVP_KEY = 'ox_inventory:uiTheme'

local function isAdmin(source)
    if source == 0 then return true end -- console
    return IsPlayerAceAllowed(source --[[@as string]], ACE_PERMISSION)
end

-- Whatever an admin sends ends up written into every client's CSS custom
-- properties, so only the exact known keys/shapes are allowed through and an
-- invalid payload is rejected wholesale rather than partially applied.
local SLOT_SHAPES = { rounded = true, square = true }
local TITLE_SHAPES = { rounded = true, square = true, circle = true, hexagon = true, diamond = true }
local UI_SIZES = { small = true, medium = true, large = true }

local BOOLEAN_KEYS = {
    'showWeight', 'showStats', 'showProfileCard', 'showItemNames',
    'showClock', 'showTemp', 'showLocation', 'showEscHint',
    'gridSpatial', 'rarityColors',
}

local function isHex(value)
    return type(value) == 'string' and value:match('^#%x%x%x%x%x%x$') ~= nil
end

---Validates a settings payload, returning a clean copy or nil when malformed.
---@param settings any
---@return table?
local function sanitise(settings)
    if type(settings) ~= 'table' then return end
    if not isHex(settings.themeColor) or not isHex(settings.bgColor) then return end
    if not SLOT_SHAPES[settings.slotShape] then return end
    if not TITLE_SHAPES[settings.titleShape] then return end
    if not UI_SIZES[settings.uiSize] then return end

    local opacity = tonumber(settings.bgOpacity)
    if not opacity then return end

    local clean = {
        themeColor = settings.themeColor,
        bgColor = settings.bgColor,
        bgOpacity = math.floor(math.max(20, math.min(100, opacity))),
        slotShape = settings.slotShape,
        titleShape = settings.titleShape,
        uiSize = settings.uiSize,
    }

    for i = 1, #BOOLEAN_KEYS do
        local key = BOOLEAN_KEYS[i]
        if type(settings[key]) ~= 'boolean' then return end
        clean[key] = settings[key]
    end

    return clean
end

---@type { settings: table, locked: boolean }?
local theme

do
    local raw = GetResourceKvpString(KVP_KEY)

    if raw then
        local ok, stored = pcall(json.decode, raw)
        local settings = ok and type(stored) == 'table' and sanitise(stored.settings) or nil

        if settings then
            theme = { settings = settings, locked = stored.locked == true }
        else
            -- Corrupt or written by an older schema — drop it rather than push it.
            DeleteResourceKvp(KVP_KEY)
        end
    end
end

-- ── NUI callbacks ──────────────────────────────────────────────

lib.callback.register('ox_inventory:getUiTheme', function(source)
    return {
        isAdmin = isAdmin(source),
        theme = theme or false,
    }
end)

lib.callback.register('ox_inventory:setUiTheme', function(source, data)
    if not isAdmin(source) then return { ok = false, error = 'not_allowed' } end
    if type(data) ~= 'table' then return { ok = false, error = 'invalid' } end

    local settings = sanitise(data.settings)

    if not settings then return { ok = false, error = 'invalid' } end

    theme = { settings = settings, locked = data.locked == true }

    SetResourceKvp(KVP_KEY, json.encode(theme))

    -- `author` lets the admin's own client skip the echo — they already hold
    -- these values locally and re-applying would fight their next keystroke.
    TriggerClientEvent('ox_inventory:uiTheme', -1, {
        settings = settings,
        locked = theme.locked,
        author = source,
    })

    return { ok = true }
end)

lib.callback.register('ox_inventory:clearUiTheme', function(source)
    if not isAdmin(source) then return { ok = false, error = 'not_allowed' } end

    theme = nil

    DeleteResourceKvp(KVP_KEY)
    TriggerClientEvent('ox_inventory:uiTheme', -1, { cleared = true, author = source })

    return { ok = true }
end)

---@return table? theme
function UiTheme.Get()
    return theme
end

return UiTheme
