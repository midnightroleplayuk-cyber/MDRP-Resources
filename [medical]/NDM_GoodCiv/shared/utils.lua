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

---Nearest configured hospital to a position.
function GoodCiv.NearestHospital(coords)
    local best, bestDist
    for i = 1, #Config.Hospitals do
        local h = Config.Hospitals[i]
        local d = #(coords - h.coords)
        if not bestDist or d < bestDist then
            best, bestDist = h, d
        end
    end
    return best, bestDist
end

---Hospital whose zone contains the position, if any.
function GoodCiv.HospitalAt(coords)
    for i = 1, #Config.Hospitals do
        local h = Config.Hospitals[i]
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
