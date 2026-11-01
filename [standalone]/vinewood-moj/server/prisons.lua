-- Prison script adapters. Each one hands a prisoner to another resource and takes them back.
-- vinewood-moj still decides the sentence, counts time served and decides release; the prison
-- script holds the prisoner (cells, jobs, outfits, breakouts).
--
-- Fields:
--   resource        resource name to detect
--   jail(src, minutes, info)      put an online player in prison for this many minutes
--   release(src)                  let an online player out
--   isJailed(src)    optional     true while the script holds them (used to notice early exits)
--   setTime(src, minutes)  optional  change the time left without releasing
--   releaseOffline(cid)    optional  let out someone who isn't in the city
--
-- ownsTime adapters (Vinewood HMP) take the whole sentence and run it themselves: time served,
-- release point, remand credit, relogs, escapes. They work by citizen id, online or not, and tell
-- us when someone is released. Fields: imprison(cid, minutes, info), discharge(cid, reason),
-- inCustody(cid), summary(cid), recapture(cid).
-- info: { kind = 'remand'|'sentence'|'recall', reason, caseRef, name }
PrisonScripts = {}

local function cfg(name) return (Config.Prison.Scripts or {})[name] or {} end
local function scaled(name, minutes) return math.max(1, math.ceil(minutes * (cfg(name).timeScale or 1))) end

PrisonScripts.list = {
    -- Vinewood HMP (vinewood_prison). Calls back through the OnCustodyReleased export and its
    -- vinewood_prison:escaped / recaptured events (see server/prison.lua).
    vinewood_prison = {
        resource = 'vinewood_prison',
        ownsTime = true,
        imprison = function(cid, minutes, info)
            local remand = info.kind == 'remand'
            return exports.vinewood_prison:Imprison(cid, {
                termSeconds = remand and 0 or math.max(1, math.ceil(minutes * 60 * (cfg('vinewood_prison').timeScale or 1))),
                remand = remand,
                releasePoint = info.kind == 'recall' and 1.0 or Config.Prison.ReleasePoint,
                caseRef = info.caseRef,
                offences = info.offences,
                category = info.category,
                prison = cfg('vinewood_prison').prison,
                name = info.name,
            })
        end,
        discharge = function(cid, reason) return exports.vinewood_prison:Release(cid, reason) end,
        inCustody = function(cid) return exports.vinewood_prison:IsInCustody(cid) == true end,
        summary = function(cid) return exports.vinewood_prison:GetPrisoner(cid) end,
        recapture = function(cid) return exports.vinewood_prison:Recapture(cid) end,
    },

    -- https://documentation.rcore.cz/paid-resources/rcore_prison/api/server  (time in minutes)
    rcore_prison = {
        resource = 'rcore_prison',
        jail = function(src, minutes, info)
            exports.rcore_prison:Jail(src, scaled('rcore_prison', minutes), info.reason)
        end,
        release = function(src) exports.rcore_prison:Unjail(src, false) end,
        isJailed = function(src) return exports.rcore_prison:IsPrisoner(src) == true end,
        setTime = function(src, minutes) exports.rcore_prison:EditPrisonerSentence(src, scaled('rcore_prison', minutes)) end,
        releaseOffline = function(cid) exports.rcore_prison:UnjailOffline(cid) end,
    },

    -- https://docs.picklemods.com/free-resources/pickle-prisons/exports
    pickle_prisons = {
        resource = 'pickle_prisons',
        jail = function(src, minutes)
            exports.pickle_prisons:JailPlayer(src, scaled('pickle_prisons', minutes), cfg('pickle_prisons').prison or 'default')
        end,
        release = function(src) exports.pickle_prisons:UnjailPlayer(src) end,
    },

    -- https://docs.wasabiscripts.com/advanced-series/wasabi-police-v2/exports
    wasabi_police_v2 = {
        resource = 'wasabi_police_v2',
        jail = function(src, minutes, info)
            exports.wasabi_police_v2:jailPlayer(src, scaled('wasabi_police_v2', minutes), info.reason)
        end,
        release = function(src) exports.wasabi_police_v2:releasePlayer(src) end,
        isJailed = function(src) return (tonumber(exports.wasabi_police_v2:getJailTime(src)) or 0) > 0 end,
    },

    -- Your own: fill in the hooks in config.lua (Config.Prison.Custom).
    custom = {
        jail = function(src, minutes, info) return Config.Prison.Custom.Jail(src, minutes, info) end,
        release = function(src) return Config.Prison.Custom.Release(src) end,
        isJailed = function(src)
            if Config.Prison.Custom.IsJailed then return Config.Prison.Custom.IsJailed(src) end
            return nil
        end,
    },
}

-- Detected in this order when Config.Prison.Script = 'auto' (Vinewood HMP first). wasabi_police_v2 is a police job
-- with a jail built in, so it's only used when you choose it.
local AUTO = { 'vinewood_prison', 'rcore_prison', 'pickle_prisons' }

--- The adapter in use and its name, or nil for the built-in prison.
function PrisonScripts.Active()
    local choice = Config.Prison.Script or 'auto'
    if choice == 'builtin' then return nil end
    if choice == 'custom' then return PrisonScripts.list.custom, 'custom' end
    if choice == 'auto' then
        for _, name in ipairs(AUTO) do
            if GetResourceState(name) == 'started' then return PrisonScripts.list[name], name end
        end
        return nil
    end
    local a = PrisonScripts.list[choice]
    if a and GetResourceState(a.resource) == 'started' then return a, choice end
    if a then print(('[vinewood-moj] Config.Prison.Script is %s but it is not running: using the built-in prison.'):format(choice)) end
    return nil
end

--- Calls an adapter function safely. Returns ok, then everything the function returned.
function PrisonScripts.Call(a, fn, ...)
    if not a or not a[fn] then return false end
    local res = table.pack(pcall(a[fn], ...))
    if not res[1] then print(('[vinewood-moj] prison script %s failed: %s'):format(fn, tostring(res[2]))) end
    return table.unpack(res, 1, res.n)
end
