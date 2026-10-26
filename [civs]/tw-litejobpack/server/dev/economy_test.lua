-- =============================================================================
--  Economy editor test harness
-- =============================================================================
--
--  WHAT: simulates the full admin-panel economy save pipeline against EVERY
--  rate of EVERY job, in memory, without touching disk. Verifies that:
--
--    1. Saving a rate with its CURRENT value succeeds (regex matches) — proves
--       Bug B1 (false "not found" on same-value save) is fixed.
--    2. Saving a rate with a NEW value (current+1) actually changes exactly one
--       number in the file content, and that number is the one we wanted —
--       proves Bug B2 (hunting animalIndex) is fixed and Bug B8 (substring
--       collisions) doesn't bite.
--    3. qualityTiers / levelPayBonus / levelChanceBonus paths also work.
--
--  HOW TO RUN: server console: `econ_test`
--  (or set Config.Dev.economyTestOnStart = true to run on resource start)
--
--  Output is per-rate [OK] / [FAIL] lines plus a final summary count.
-- =============================================================================

local function getInternals()
    return _G.__EconomyAdminInternals
end

-- Count how many distinct numeric tokens differ between old and new content.
-- Used to catch substring-collision bugs where a regex changes more than one
-- value (e.g. saving `perKg` accidentally also changes `pricePerKg`).
local function countNumberDiffs(oldContent, newContent)
    if oldContent == newContent then return 0 end
    -- Walk both strings in lockstep, collect mismatching number tokens.
    local oldNums, newNums = {}, {}
    for n in oldContent:gmatch('%d+%.?%d*') do oldNums[#oldNums+1] = n end
    for n in newContent:gmatch('%d+%.?%d*') do newNums[#newNums+1] = n end

    local diffs = 0
    local len = math.max(#oldNums, #newNums)
    for i = 1, len do
        if oldNums[i] ~= newNums[i] then diffs = diffs + 1 end
    end
    return diffs
end

-- Apply a single rate to in-memory content. Mirrors the production save logic
-- but isolated to one rate for testing. Returns (newContent, n) where n>0
-- means the regex matched.
local function applyRateInMemory(content, rate, jobId, newValue)
    local I = getInternals()
    local valueStr = I.FormatLuaNumber(newValue)
    local safeKey = I.EscapePattern(rate.key)

    if rate.source == 'animalPrice' and rate.areaIndex and rate.animalIndex then
        local targetOccurrence = 0
        local job = Config.Jobs and Config.Jobs[jobId]
        for ai = 1, rate.areaIndex do
            local areaAnimals = job and job.runtime and job.runtime.areas
                and job.runtime.areas[ai] and job.runtime.areas[ai].animals
            if areaAnimals then
                if ai < rate.areaIndex then
                    targetOccurrence = targetOccurrence + #areaAnimals
                else
                    targetOccurrence = targetOccurrence + rate.animalIndex
                end
            end
        end
        if targetOccurrence == 0 then return content, 0 end
        local count = 0
        local replaced = false
        local newContent = content:gsub('(pricePerKg%s*=%s*)(%d+%.?%d*)', function(prefix, oldVal)
            count = count + 1
            if count == targetOccurrence then
                replaced = true
                return prefix .. valueStr
            end
            return prefix .. oldVal
        end)
        return newContent, replaced and 1 or 0
    end

    local pattern, repl = I.BuildPattern(rate, safeKey, valueStr, jobId)
    return I.applyRegex(content, pattern, repl)
end

-- Apply a single qualityTier in memory.
local function applyTierInMemory(content, tier)
    local I = getInternals()
    local escapedName = I.EscapePattern(tier.name)
    local chanceStr = I.FormatLuaNumber(tier.chance)
    local multStr = I.FormatLuaNumber(tier.multiplier)
    local newContent, n = content:gsub(
        '(name%s*=%s*"' .. escapedName .. '"%s*,%s*chance%s*=%s*)(%d+%.?%d*)(%s*,%s*multiplier%s*=%s*)(%d+%.?%d*)',
        '%1' .. chanceStr .. '%3' .. multStr, 1
    )
    return newContent, n
end

-- Apply runtime-level levelPayBonus / levelChanceBonus.
local function applyLevelBonusInMemory(content, key, value)
    local I = getInternals()
    local valueStr = I.FormatLuaNumber(value)
    local newContent, n = content:gsub('([^%w_]' .. key .. '%s*=%s*)(%d+%.?%d*)', '%1' .. valueStr, 1)
    return newContent, n
end

local function fmtRate(jobId, rate)
    return ('%s / %s (%s)'):format(jobId, rate.key, rate.source)
end

local function testOneRate(jobId, rate, originalContent, fail)
    -- Test 1: same-value save must NOT report "not found" (Bug B1).
    local _, n0 = applyRateInMemory(originalContent, rate, jobId, rate.value)
    if n0 == 0 then
        fail[#fail+1] = ('[FAIL] %s — same-value save: regex did not match'):format(fmtRate(jobId, rate))
        return false
    end

    -- Test 2: change value to value+1, must change exactly one number.
    local newVal = (type(rate.value) == 'number') and (rate.value + 1) or rate.value
    local newContent, n1 = applyRateInMemory(originalContent, rate, jobId, newVal)
    if n1 == 0 then
        fail[#fail+1] = ('[FAIL] %s — change-value save: regex did not match'):format(fmtRate(jobId, rate))
        return false
    end

    local diffs = countNumberDiffs(originalContent, newContent)
    if diffs == 0 then
        fail[#fail+1] = ('[FAIL] %s — change-value save: file unchanged (silent no-op)'):format(fmtRate(jobId, rate))
        return false
    elseif diffs > 1 then
        fail[#fail+1] = ('[FAIL] %s — change-value save: %d numbers changed (expected 1, regex collision)'):format(fmtRate(jobId, rate), diffs)
        return false
    end

    -- Verify the new value actually appears in the new content
    local newValStr = tostring(newVal):gsub('%.0+$', '')
    if not newContent:find(tostring(newVal), 1, true) and not newContent:find(newValStr, 1, true) then
        fail[#fail+1] = ('[FAIL] %s — change-value save: new value %s not found in result'):format(fmtRate(jobId, rate), tostring(newVal))
        return false
    end

    return true
end

local function testOneTier(jobId, tier, originalContent, fail)
    local _, n0 = applyTierInMemory(originalContent, tier)
    if n0 == 0 then
        fail[#fail+1] = ('[FAIL] %s / qualityTier "%s": regex did not match'):format(jobId, tier.name)
        return false
    end
    -- Change-test: bump chance by +1 (and keep totals close — pure regex test, doesn't validate sum)
    local bumped = { name = tier.name, chance = tier.chance + 0.1, multiplier = tier.multiplier }
    local newContent, n1 = applyTierInMemory(originalContent, bumped)
    if n1 == 0 then
        fail[#fail+1] = ('[FAIL] %s / qualityTier "%s": change save did not match'):format(jobId, tier.name)
        return false
    end
    if newContent == originalContent then
        fail[#fail+1] = ('[FAIL] %s / qualityTier "%s": file unchanged after bump'):format(jobId, tier.name)
        return false
    end
    return true
end

local function testLevelBonus(jobId, key, value, originalContent, fail)
    if value == 0 or value == nil then return true end -- nothing to test
    local _, n0 = applyLevelBonusInMemory(originalContent, key, value)
    if n0 == 0 then
        fail[#fail+1] = ('[FAIL] %s / %s: regex did not match (value=%s)'):format(jobId, key, tostring(value))
        return false
    end
    local newContent, n1 = applyLevelBonusInMemory(originalContent, key, value + 0.01)
    if n1 == 0 or newContent == originalContent then
        fail[#fail+1] = ('[FAIL] %s / %s: change save failed'):format(jobId, key)
        return false
    end
    return true
end

local function runFullTest()
    local I = getInternals()
    if not I or not I.CollectJobEconomyData then
        print('[econ_test] ^1ERROR^7 admin internals not exposed (server/admin.lua not loaded?)')
        return
    end

    print('[econ_test] ===== START =====')
    local resName = GetCurrentResourceName()
    local pass, totalFail, jobsTested, jobsSkipped = 0, 0, 0, 0
    local fail = {}

    -- Sort jobs alphabetically for deterministic output.
    local jobIds = {}
    for jobId, _ in pairs(Config.Jobs or {}) do
        if Config.Jobs[jobId].enabled ~= false then
            jobIds[#jobIds+1] = jobId
        end
    end
    table.sort(jobIds)

    for _, jobId in ipairs(jobIds) do
        local job = Config.Jobs[jobId]
        local fileName = (job._sourceFile or jobId) .. '.lua'
        local content = LoadResourceFile(resName, 'shared/jobs/' .. fileName)
        if not content then
            print(('[econ_test] [SKIP] %s: cannot load shared/jobs/%s'):format(jobId, fileName))
            jobsSkipped = jobsSkipped + 1
        else
            jobsTested = jobsTested + 1
            local data = I.CollectJobEconomyData(jobId, job)
            local jobPass, jobFail = 0, 0

            for _, rate in ipairs(data.payRates or {}) do
                if testOneRate(jobId, rate, content, fail) then
                    pass = pass + 1
                    jobPass = jobPass + 1
                else
                    totalFail = totalFail + 1
                    jobFail = jobFail + 1
                end
            end
            if data.qualityTiers then
                for _, tier in ipairs(data.qualityTiers) do
                    if testOneTier(jobId, tier, content, fail) then
                        pass = pass + 1
                        jobPass = jobPass + 1
                    else
                        totalFail = totalFail + 1
                        jobFail = jobFail + 1
                    end
                end
            end
            if testLevelBonus(jobId, 'levelPayBonus', data.levelPayBonus, content, fail) then
                if data.levelPayBonus and data.levelPayBonus ~= 0 then pass = pass + 1; jobPass = jobPass + 1 end
            else totalFail = totalFail + 1; jobFail = jobFail + 1 end
            if testLevelBonus(jobId, 'levelChanceBonus', data.levelChanceBonus, content, fail) then
                if data.levelChanceBonus and data.levelChanceBonus ~= 0 then pass = pass + 1; jobPass = jobPass + 1 end
            else totalFail = totalFail + 1; jobFail = jobFail + 1 end

            local marker = (jobFail == 0) and '^2OK^7' or '^1FAIL^7'
            print(('[econ_test]   [%s] %-20s pass=%d fail=%d'):format(marker, jobId, jobPass, jobFail))
        end
    end

    if #fail > 0 then
        print('[econ_test] --- failures ---')
        for _, line in ipairs(fail) do print('[econ_test] ' .. line) end
    end
    print(('[econ_test] ===== DONE: tested %d jobs (%d skipped) | %d pass, %d fail ====='):format(
        jobsTested, jobsSkipped, pass, totalFail))
end

RegisterCommand('econ_test', function(src)
    -- Server console only (src == 0); allow ACE-permitted admins from RCON too.
    if src ~= 0 and not (Config.AdminPanel and IsPlayerAceAllowed(src, Config.AdminPanel.acePermission)) then
        return
    end
    runFullTest()
end, true)

-- =============================================================================
--  econ_verify — does the admin panel show the SAME numbers that are
--  literally in the source files?
--
--  For every rate the panel collects, we re-run the same regex pattern in
--  read-only mode to grab the value straight out of the .lua file content,
--  then compare it to what CollectJobEconomyData reported. Any drift means
--  Config.Jobs[id] in memory diverged from disk (Test mode override, hot
--  edit, missed restart after save, etc.).
-- =============================================================================

local function readValueFromFile(content, rate, jobId)
    local I = getInternals()
    local safeKey = I.EscapePattern(rate.key)

    -- animalPrice: counter-based, walk Nth `pricePerKg` occurrence
    if rate.source == 'animalPrice' and rate.areaIndex and rate.animalIndex then
        local job = Config.Jobs and Config.Jobs[jobId]
        local target = 0
        for ai = 1, rate.areaIndex do
            local areaAnimals = job and job.runtime and job.runtime.areas
                and job.runtime.areas[ai] and job.runtime.areas[ai].animals
            if areaAnimals then
                if ai < rate.areaIndex then target = target + #areaAnimals
                else target = target + rate.animalIndex end
            end
        end
        local count, found = 0, nil
        for valStr in content:gmatch('pricePerKg%s*=%s*(%d+%.?%d*)') do
            count = count + 1
            if count == target then found = valStr; break end
        end
        return tonumber(found)
    end

    -- For everything else, use BuildPattern's anchor and capture the trailing number.
    local pattern = I.BuildPattern(rate, safeKey, '0', jobId)  -- valueStr unused for read
    -- BuildPattern returns (pattern, replacement). Pattern has 1 captured group
    -- BEFORE the value group `(%d+%.?%d*)`. We need to capture both to get the value.
    -- Strategy: take the pattern as-is, find first match, then extract via the
    -- 2nd captured group with a reformulated capture.
    local _, _, prefix, valStr = content:find(pattern)
    if not valStr then return nil end
    return tonumber(valStr)
end

local function approxEqual(a, b)
    if a == b then return true end
    if type(a) ~= 'number' or type(b) ~= 'number' then return false end
    return math.abs(a - b) < 0.0001
end

local function runVerify()
    local I = getInternals()
    if not I or not I.CollectJobEconomyData then
        print('[econ_verify] ^1ERROR^7 admin internals not exposed')
        return
    end

    print('[econ_verify] ===== START =====')
    local resName = GetCurrentResourceName()
    local pass, mismatch, missing = 0, 0, 0
    local issues = {}

    local jobIds = {}
    for jobId, _ in pairs(Config.Jobs or {}) do
        if Config.Jobs[jobId].enabled ~= false then jobIds[#jobIds+1] = jobId end
    end
    table.sort(jobIds)

    for _, jobId in ipairs(jobIds) do
        local job = Config.Jobs[jobId]
        local fileName = (job._sourceFile or jobId) .. '.lua'
        local content = LoadResourceFile(resName, 'shared/jobs/' .. fileName)
        if content then
            local data = I.CollectJobEconomyData(jobId, job)
            for _, rate in ipairs(data.payRates or {}) do
                local fileVal = readValueFromFile(content, rate, jobId)
                if fileVal == nil then
                    missing = missing + 1
                    issues[#issues+1] = ('[MISSING] %s / %s (%s) — could not read from file'):format(jobId, rate.key, rate.source)
                elseif not approxEqual(rate.value, fileVal) then
                    mismatch = mismatch + 1
                    issues[#issues+1] = ('[MISMATCH] %s / %s (%s) — panel=%s, file=%s'):format(
                        jobId, rate.key, rate.source, tostring(rate.value), tostring(fileVal))
                else
                    pass = pass + 1
                end
            end
        end
    end

    if #issues > 0 then
        for _, line in ipairs(issues) do print('[econ_verify] ' .. line) end
    end
    local marker = (mismatch == 0 and missing == 0) and '^2ALL VALUES MATCH SOURCE FILES^7' or '^1DRIFT DETECTED^7'
    print(('[econ_verify] ===== %s | pass=%d mismatch=%d missing=%d ====='):format(marker, pass, mismatch, missing))
end

RegisterCommand('econ_verify', function(src)
    if src ~= 0 and not (Config.AdminPanel and IsPlayerAceAllowed(src, Config.AdminPanel.acePermission)) then
        return
    end
    runVerify()
end, true)

CreateThread(function()
    Wait(5000)  -- allow Config.Jobs / admin internals to load
    if Config.Dev and Config.Dev.economyTestOnStart then
        runFullTest()
    end
end)
