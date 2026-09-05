while Framework == nil do Wait(5) end

local DEFAULT_MIN_MISSION_SECONDS = 15
local END_MISSION_MIN_INTERVAL_MS = 750
local missionCreatorPending = {}
local missionCreatorRunning = {}

local lastEndMissionAttempt = {}

local function getMissionDiscordLabel(entry, missionIndex)
    if type(entry) == 'table' and type(entry.UI) == 'table' and entry.UI.missionLabel then
        return tostring(entry.UI.missionLabel)
    end
    return tostring(missionIndex or 'unknown')
end

local function formatMissionWebHook(src, playerObject, playerOrg, missionIndex, entry)
    local playerName = (playerObject and playerObject.name)
        or (src and Fr.GetPlayerName(src))
        or 'Unknown'
    local identificator = (playerObject and playerObject.identificator) or 'Unknown'
    local rank = (playerObject and playerObject.rank) or '?'
    local playerString = playerName .. " (" .. tostring(rank) .. ") [" .. tostring(identificator) .. "]"

    local orgId = (playerObject and playerObject.jobId)
        or (playerOrg and playerOrg.id)
        or '?'
    local orgLabel = (playerOrg and playerOrg.label) or 'Unknown'
    local jobString = orgLabel .. " (" .. tostring(orgId) .. ")"

    local missionLabel = getMissionDiscordLabel(entry, missionIndex)

    return formatWebHook(
        "**Player:** `" .. playerString .. "`",
        "\n**Organisation:** `" .. jobString .. "`",
        "\n**Mission:** `" .. missionLabel .. "`",
        "\n**Mission Id:** `" .. tostring(missionIndex) .. "`"
    )
end

local function logMissionStarted(src, playerObject, playerOrg, missionIndex, entry)
    local message = formatMissionWebHook(src, playerObject, playerOrg, missionIndex, entry)
    SendWebHook("MISSION STARTED.", 706333, message)
end

local function logMissionCompleted(src, playerObject, playerOrg, missionIndex, entry)
    local message = formatMissionWebHook(src, playerObject, playerOrg, missionIndex, entry)
    SendWebHook("MISSION COMPLETED.", 706333, message)
end

AddEventHandler('playerDropped', function()
    local src = source
    lastEndMissionAttempt[src] = nil

    local pending = missionCreatorPending[src]
    if pending then
        resetMissionCreatorSlot(pending.orgId, pending.missionIndex)
        missionCreatorPending[src] = nil
    end

    local running = missionCreatorRunning[src]
    if running then
        resetMissionCreatorSlot(running.orgId, running.missionIndex)
        missionCreatorRunning[src] = nil
    end

    for identifier, job in pairs(playersJobs) do
        if job.playerServerId == src then
            resetPlayerActiveMissions(src, identifier, job.jobId)
            break
        end
    end
end)

-- ──────────────────────────────────────────────────────────────────────────────
-- op-missioncreator bridge state
-- ──────────────────────────────────────────────────────────────────────────────

local function locateMissionCreatorSlot(orgId, missionId)
    local org = organisations[tostring(orgId)]
    if not org or not org.missions then return nil end
    for missionIndex, entry in pairs(org.missions) do
        if entry and entry._source == 'missioncreator'
           and (entry.missionId == missionId or missionIndex == missionId) then
            return entry, missionIndex
        end
    end
    return nil
end

local function resetMissionCreatorSlot(orgId, missionIndex)
    local org = organisations[tostring(orgId)]
    if not org or not org.missions then return end
    local entry = org.missions[missionIndex]
    if not entry then return end
    entry.startedBy = ""
    entry.startedByIdent = nil
    entry.startedAt = nil
    entry.status    = "no-started"
    organisations[tostring(orgId)] = org
end

local function resetLegacyMissionSlot(orgId, missionIndex)
    local org = organisations[tostring(orgId)]
    if not org or not org.missions then return false end
    local entry = org.missions[missionIndex]
    if not entry then return false end

    entry.startedBy = ""
    entry.startedByIdent = nil
    entry.startedAt = nil
    entry.status = "no-started"
    organisations[tostring(orgId)] = org
    return true
end

local function notifyOrgMissionCancel(orgId, missionIndex)
    for _, job in pairs(playersJobs) do
        if tostring(job.jobId) == tostring(orgId) and job.playerServerId then
            TriggerClientEvent('op-crime:cancelMissionClient', job.playerServerId, missionIndex)
        end
    end
end

function resetPlayerActiveMissions(src, identifier, jobId)
    if not identifier or not jobId then return end

    local org = organisations[tostring(jobId)]
    if not org or not org.missions then return end

    for missionIndex, entry in pairs(org.missions) do
        if not entry or entry.status == "done" then goto continue end

        local active = entry.status == "started"
            or (entry.startedBy ~= "" and entry.status ~= "done")

        if not active then goto continue end

        local isStarter = entry.startedByIdent == identifier
        if not isStarter then goto continue end

        if entry._source == 'missioncreator' then
            resetMissionCreatorSlot(jobId, missionIndex)
        else
            resetLegacyMissionSlot(jobId, missionIndex)
        end

        ::continue::
    end
end

function OpCrimeResetOrgMissions(orgId)
    local org = organisations[tostring(orgId)]
    if not org or not org.missions then return 0, org and org.label or nil end

    local resetCount = 0
    for missionIndex, entry in pairs(org.missions) do
        if entry and entry.status ~= "done" and entry.startedBy ~= "" then
            if entry._source == 'missioncreator' then
                resetMissionCreatorSlot(orgId, missionIndex)
            else
                resetLegacyMissionSlot(orgId, missionIndex)
            end
            notifyOrgMissionCancel(orgId, missionIndex)
            resetCount = resetCount + 1
        end
    end

    return resetCount, org.label
end

local function finishMissionCreatorSlot(source, orgId, missionIndex)
    local org = organisations[tostring(orgId)]
    if not org or not org.missions then return end
    local entry = org.missions[missionIndex]
    if not entry then return end

    entry.status = "done"
    organisations[tostring(orgId)] = org

    if type(entry.UI) == 'table' then
        if type(entry.UI.missionReward) == 'table' then
            for _, reward in pairs(entry.UI.missionReward) do
                assignReward(reward, orgId, source)
            end
        end
        if tonumber(entry.UI.missionExp) and entry.UI.missionExp > 0 then
            addOrgExp(orgId, entry.UI.missionExp)
        end
    end
    addOrgDoneMissions(orgId)

    local identifier = Fr.GetIndentifier(source)
    local playerObject = identifier and playersJobs[identifier] or {
        name = Fr.GetPlayerName(source),
        identificator = identifier or 'Unknown',
        rank = '?',
        jobId = orgId,
    }
    logMissionCompleted(source, playerObject, org, missionIndex, entry)
end

Fr.RegisterServerCallback('op-crime:startMission', function(source, cb, missionIndex)
    local identifier   = Fr.GetIndentifier(source)
    local playerObject = playersJobs[identifier]

    if not playerObject then return cb({ ok = false, reason = 'no_player' }) end

    local playerOrg = organisations[tostring(playerObject.jobId)]
    if not playerOrg or not playerOrg.missions then
        return cb({ ok = false, reason = 'no_org' })
    end

    local entry = playerOrg.missions[missionIndex]
    if not entry then return cb({ ok = false, reason = 'mission_not_in_pool' }) end

    if entry.startedBy ~= "" then
        return cb({ ok = false, reason = 'already_taken' })
    end

    if entry._source == 'missioncreator' and GetResourceState('op-missioncreator') == 'started' then
        local missionId = entry.missionId or missionIndex

        entry.startedBy = Fr.GetPlayerName(source)
        entry.status    = "no-started"
        organisations[tostring(playerObject.jobId)] = playerOrg

        local pcallOk, result, detail = pcall(function()
            return exports['op-missioncreator']:OpCrimeStart(source, missionId)
        end)
        if not pcallOk then
            resetMissionCreatorSlot(playerObject.jobId, missionIndex)
            return cb({ ok = false, reason = 'integration_error', detail = tostring(result) })
        end
        if result == false then
            resetMissionCreatorSlot(playerObject.jobId, missionIndex)
            return cb({ ok = false, reason = tostring(detail or 'rejected') })
        end

        missionCreatorPending[source] = {
            orgId        = tostring(playerObject.jobId),
            missionIndex = missionIndex,
            missionId    = missionId,
        }
        -- Discord log fires on op-missioncreator:server:missionStarted
        return cb({
            ok      = true,
            runtime = 'missioncreator',
            state   = type(detail) == 'string' and detail or 'started',
        })
    end

    entry.startedBy = Fr.GetPlayerName(source)
    entry.startedByIdent = identifier
    entry.startedAt = GetGameTimer()
    entry.status    = "started"
    organisations[tostring(playerObject.jobId)] = playerOrg
    logMissionStarted(source, playerObject, playerOrg, missionIndex, entry)
    cb({ ok = true, runtime = 'legacy' })
end)

Fr.RegisterServerCallback('op-crime:sellDrugs', function(source, cb)
    local playerObject = playersJobs[Fr.GetIndentifier(source)]
    local playerOrg = organisations[tostring(playerObject.jobId)]

    if playerObject and playerOrg then
        local xPlayer = Fr.getPlayerFromId(source)
        if xPlayer then
            local inventory = Fr.getInventory(xPlayer)
            local missionCfg = Config.Missions['drug_sell_npc']

            if not missionCfg then return cb(false) end

            local canProceed = false
            for k, v in pairs(inventory) do
                if v.name == missionCfg.ItemName then
                    local count = v.amount or v.count
                    if count >= 50 then
                        canProceed = true
                        Fr.removeItem(xPlayer, missionCfg.ItemName, 50)
                        break;
                    end
                end
            end

            cb(canProceed)
        end
    end
end)

local function rejectEndMission(src, reason, missionIndex)
    print(('[op-crime] Blocked op-crime:endMission from src %s (%s) index=%s'):format(
        tostring(src), tostring(reason), tostring(missionIndex)
    ))
end

RegisterServerEvent('op-crime:endMission')
AddEventHandler('op-crime:endMission', function(missionIndex)
    local src = source

    local now = GetGameTimer()
    local last = lastEndMissionAttempt[src]
    lastEndMissionAttempt[src] = now
    if last and (now - last) < END_MISSION_MIN_INTERVAL_MS then
        return rejectEndMission(src, 'rate_limited', missionIndex)
    end

    if type(missionIndex) ~= 'string' or missionIndex == '' then
        return rejectEndMission(src, 'bad_index', missionIndex)
    end

    local identifier = Fr.GetIndentifier(src)
    local playerObject = identifier and playersJobs[identifier]
    if not playerObject then
        return rejectEndMission(src, 'no_player', missionIndex)
    end

    local playerOrg = organisations[tostring(playerObject.jobId)]
    if not playerOrg or not playerOrg.missions then
        return rejectEndMission(src, 'no_org', missionIndex)
    end

    local entry = playerOrg.missions[missionIndex]
    if not entry then
        return rejectEndMission(src, 'not_in_pool', missionIndex)
    end

    if entry.status ~= "started" then
        return rejectEndMission(src, 'not_started', missionIndex)
    end

    if entry._source == 'missioncreator' then
        return rejectEndMission(src, 'missioncreator_slot', missionIndex)
    end

    if entry.startedByIdent and entry.startedByIdent ~= identifier then
        return rejectEndMission(src, 'not_starter', missionIndex)
    end

    local minSeconds = (entry.UI and tonumber(entry.UI.minCompletionTime))
        or DEFAULT_MIN_MISSION_SECONDS
    if entry.startedAt and (now - entry.startedAt) < (minSeconds * 1000) then
        return rejectEndMission(src, 'too_fast', missionIndex)
    end

    if type(entry.UI) ~= 'table' then
        return rejectEndMission(src, 'no_ui', missionIndex)
    end

    entry.status = "done"
    organisations[tostring(playerObject.jobId)] = playerOrg

    if type(entry.UI.missionReward) == 'table' then
        for _, reward in pairs(entry.UI.missionReward) do
            assignReward(reward, playerObject.jobId, src)
        end
    end

    if tonumber(entry.UI.missionExp) then
        addOrgExp(playerObject.jobId, entry.UI.missionExp)
    end
    addOrgDoneMissions(playerObject.jobId)
    logMissionCompleted(src, playerObject, playerOrg, missionIndex, entry)
end)

AddEventHandler('op-missioncreator:server:missionStarted', function(src, missionId)
    local pending = missionCreatorPending[src]
    if not pending or pending.missionId ~= missionId then return end

    local org = organisations[pending.orgId]
    if not org or not org.missions then
        missionCreatorPending[src] = nil
        return
    end

    local entry = org.missions[pending.missionIndex]
    if not entry then
        missionCreatorPending[src] = nil
        return
    end

    entry.status = "started"
    organisations[pending.orgId] = org

    missionCreatorRunning[src] = pending
    missionCreatorPending[src] = nil

    local identifier = Fr.GetIndentifier(src)
    local playerObject = identifier and playersJobs[identifier] or {
        name = Fr.GetPlayerName(src),
        identificator = identifier or 'Unknown',
        rank = '?',
        jobId = pending.orgId,
    }
    logMissionStarted(src, playerObject, org, pending.missionIndex, entry)
end)

AddEventHandler('op-missioncreator:server:missionEnded', function(src, missionId, status)
    local rec = missionCreatorRunning[src] or missionCreatorPending[src]
    if not rec or rec.missionId ~= missionId then return end

    missionCreatorRunning[src] = nil
    missionCreatorPending[src] = nil

    if status == 'completed' then
        finishMissionCreatorSlot(src, rec.orgId, rec.missionIndex)
    else
        resetMissionCreatorSlot(rec.orgId, rec.missionIndex)
    end
end)
