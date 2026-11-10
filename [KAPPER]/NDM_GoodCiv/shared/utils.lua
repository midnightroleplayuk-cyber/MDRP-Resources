GoodCiv = GoodCiv or {}

local locale = Locales[Config.Locale] or Locales.en

---Translate a locale key, formatting any extra args into it.
function L(key, ...)
    local str = locale[key] or Locales.en[key] or key
    if select('#', ...) > 0 then
        return str:format(...)
    end
    return str
end

function GoodCiv.Debug(...)
    if Config.Debug then
        print('^5[goodciv]^7', ...)
    end
end

function GoodCiv.InList(list, value)
    if not list then return false end
    for i = 1, #list do
        if list[i] == value then return true end
    end
    return false
end

---------------------------------------------------------------------------
-- Down state mode
---------------------------------------------------------------------------
local downMode

---'goodciv' when GoodCiv runs its own down / revive, 'framework' when an ambulance script does.
function GoodCiv.DownMode()
    if downMode then return downMode end
    local mode = Config.Down.Mode
    if mode == 'auto' then
        mode = 'goodciv'
        for _, res in ipairs(Config.Down.MedicalScripts) do
            if GetResourceState(res) == 'started' then
                mode = 'framework'
                break
            end
        end
    end
    downMode = mode
    return mode
end

---------------------------------------------------------------------------
-- Hospitals / check-in points
---------------------------------------------------------------------------
-- The server builds the list from Config.Hospitals plus points made with /goodcivconfig
-- and publishes it in GlobalState as plain tables; both sides convert it here.
GoodCiv.Hospitals = {}

local function defaultHospitals()
    local list = {}
    for i, h in ipairs(Config.Hospitals) do
        list[#list + 1] = {
            id = 'cfg' .. i, label = h.label, custom = false,
            coords = h.coords, drop = h.drop, radius = h.radius, fee = h.fee,
        }
    end
    return list
end

function GoodCiv.SetHospitals(plain)
    if type(plain) ~= 'table' or #plain == 0 then
        GoodCiv.Hospitals = defaultHospitals()
        return
    end
    local list = {}
    for _, h in ipairs(plain) do
        list[#list + 1] = {
            id = h.id, label = h.label, custom = h.custom,
            coords = vector3(h.x, h.y, h.z),
            drop = vector4(h.dx, h.dy, h.dz, h.dh),
            radius = h.radius, fee = h.fee,
        }
    end
    GoodCiv.Hospitals = list
end

GoodCiv.SetHospitals(GlobalState['goodciv:hospitals'])

function GoodCiv.GetHospital(id)
    for _, h in ipairs(GoodCiv.Hospitals) do
        if h.id == id then return h end
    end
end

---Nearest hospital to a position.
function GoodCiv.NearestHospital(coords)
    local best, bestDist
    for _, h in ipairs(GoodCiv.Hospitals) do
        local d = #(coords - h.coords)
        if not bestDist or d < bestDist then
            best, bestDist = h, d
        end
    end
    return best, bestDist
end

---Hospital whose zone contains the position, if any.
function GoodCiv.HospitalAt(coords)
    for _, h in ipairs(GoodCiv.Hospitals) do
        if #(coords - h.coords) <= h.radius then
            return h
        end
    end
end

---Condition labels shown in alerts and the treatment panel.
function GoodCiv.ConditionTags(state)
    local tags = {}
    if not state.conscious then tags[#tags + 1] = 'Unconscious' end
    if not state.breathing then tags[#tags + 1] = 'Not breathing' end
    if state.bleeding == 'major' then tags[#tags + 1] = 'Major bleeding' end
    return tags
end

function GoodCiv.IsLifeThreatening(state)
    return (not state.conscious) or (not state.breathing) or state.bleeding == 'major'
end
