--[[
    Apex Handling Studio: payload validation
    ────────────────────────────────────────────────────────────
    Everything that arrives from a client and is then STORED or
    APPLIED to a live vehicle passes through here: stock reports,
    model overrides, saved profiles.

    Two jobs:

      1. Whitelist: only real CHandlingData catalog fields survive.
         Junk keys can otherwise be persisted into the JSON store
         forever, and the five f*BiasRear members (which the natives
         do not expose at all) are dropped as the phantoms they are.

      2. Sanity: every value must be finite and physically sane.
         A single NaN reaching json.encode kills the write for the
         WHOLE store file, so one crafted payload could stop every
         profile and override on the server from ever persisting
         again. Non-finite values never get that far now.

    The space-sensitive fields (the ones a wrong-unit value ruins)
    additionally get the same hard accept-ranges the client editor
    enforces, so corrupt data cannot enter through the network
    either. Ranges are deliberately far outside anything a real
    handling.meta uses: legitimate tunes always pass.
]]

Validate = Validate or {}

local MAX_ABS = 1e9        -- nothing in CHandlingData legitimately exceeds this

local HARD_RANGE = {
    fSteeringLock           = { 1.0, 120.0 },   -- degrees
    fTractionCurveLateral   = { 1.0,  90.0 },   -- degrees
    fInitialDriveMaxFlatVel = { 10.0, 800.0 },  -- km/h
    fDriveBiasFront         = { 0.0,   1.0 },
    fBrakeBiasFront         = { 0.0,   1.0 },
    fTractionBiasFront      = { 0.0,   1.0 },
    fSuspensionBiasFront    = { 0.0,   1.0 },
    fAntiRollBarBiasFront   = { 0.0,   1.0 },
    fMass                   = { 1.0, 1e6 },
    nInitialDriveGears      = { 1,    10 },
}

-- Phantom members: the natives have no such parser fields. Older
-- builds recorded them as 0.0, never store or re-apply them.
local REAR_FIELDS = {
    fDriveBiasRear = true, fBrakeBiasRear = true, fTractionBiasRear = true,
    fSuspensionBiasRear = true, fAntiRollBarBiasRear = true,
}

local function finite(v)
    return type(v) == 'number' and v == v and v ~= math.huge and v ~= -math.huge
end

local function inRange(name, v)
    local r = HARD_RANGE[name]
    if not r then return math.abs(v) <= MAX_ABS end
    -- exactly 0 is legitimate on trailers/towed props (no steering, no
    -- drivetrain) and can never be the radian/m-per-second artifact the
    -- low bound exists to catch
    if v == 0 then return true end
    return v >= r[1] and v <= r[2]
end

local function u32(v)
    v = math.floor(v)
    if v < 0 then v = v + 4294967296 end
    return v % 4294967296
end

--- Clean a client-supplied field table.
--- Returns cleanTable, validCount, rejectedCount.
--- cleanTable is nil when the input isn't a table at all.
function Validate.Fields(fields)
    if type(fields) ~= 'table' then return nil, 0, 0 end
    local out, okCount, bad = {}, 0, 0
    for name, value in pairs(fields) do
        local f = (not REAR_FIELDS[name]) and HandlingFieldByName[name] or nil
        if not f then
            bad = bad + 1
        elseif f.type == 'float' then
            local v = tonumber(value)
            if finite(v) and inRange(name, v) then
                out[name] = v + 0.0
                okCount = okCount + 1
            else
                bad = bad + 1
            end
        elseif f.type == 'int' then
            local v = tonumber(value)
            if finite(v) and inRange(name, v) then
                out[name] = math.floor(v)
                okCount = okCount + 1
            else
                bad = bad + 1
            end
        elseif f.type == 'flags' then
            local v = tonumber(value)
            if finite(v) then
                out[name] = u32(v)
                okCount = okCount + 1
            else
                bad = bad + 1
            end
        elseif f.type == 'vec' then
            if type(value) == 'table' then
                local x, y, z = tonumber(value.x), tonumber(value.y), tonumber(value.z)
                if finite(x) and finite(y) and finite(z)
                    and math.abs(x) <= MAX_ABS and math.abs(y) <= MAX_ABS and math.abs(z) <= MAX_ABS then
                    out[name] = { x = x + 0.0, y = y + 0.0, z = z + 0.0 }
                    okCount = okCount + 1
                else
                    bad = bad + 1
                end
            else
                bad = bad + 1
            end
        elseif f.type == 'enum' then
            -- File-only field, written as raw TEXT into someone else's
            -- handling.meta: so it must be one of the catalog options and
            -- nothing else. A free-form string here could close the tag and
            -- inject XML, leaving the file unparseable and the vehicle
            -- without a handling block after the next restart.
            if Validate.EnumOption(name, value) then
                out[name] = value
                okCount = okCount + 1
            else
                bad = bad + 1
            end
        else
            bad = bad + 1
        end
    end
    return out, okCount, bad
end

--- Is `value` one of the catalog options for an enum field? Used for
--- the file-only fields the UI sends separately (AIHandling).
function Validate.EnumOption(fieldName, value)
    if type(value) ~= 'string' then return false end
    local f = HandlingFieldByName[fieldName]
    if not f or f.type ~= 'enum' then return false end
    for _, opt in ipairs(f.options or {}) do
        if opt == value then return true end
    end
    return false
end

--- A model/handling name safe to use as a storage key AND as part of
--- a file path: whitelist only, so '.', '/', '\', ':' and '%' can
--- never survive into SaveResourceFile or a Lua pattern.
function Validate.ModelName(s, maxLen)
    s = tostring(s or ''):sub(1, maxLen or 64)
    return (s:gsub('[^%w_%-]', ''))
end
