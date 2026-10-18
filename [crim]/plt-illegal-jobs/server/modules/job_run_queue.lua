--[[
  Global run queue: only one lobby may run a given job key at a time.
  Waiters are queued FIFO and notified when the active run ends.

  Exempt by default: money_laundering + all corner_* jobs.
  Toggle / extend via Config.JobRunQueue.
]]

local Utils = require 'server.modules.utils'

local JobRunQueue = {}

---@type table<string, { lobbyId: string|number, startedAt: number }>
local active = {}

---@type table<string, { source: number, lobbyId: string|number|nil, joinedAt: number }[]>
local waiting = {}

local function now()
    return os.time()
end

local function cfg()
    return Config.JobRunQueue or {}
end

function JobRunQueue.isEnabled()
    return cfg().Enabled ~= false
end

---@param jobKey string
---@return boolean
function JobRunQueue.isExempt(jobKey)
    if not jobKey or jobKey == '' then return true end
    if jobKey == 'money_laundering' then return true end
    if jobKey:sub(1, 7) == 'corner_' then return true end

    local exempt = cfg().Exempt
    if type(exempt) == 'table' then
        for i = 1, #exempt do
            if exempt[i] == jobKey then return true end
        end
    end
    return false
end

---@param jobKey string
---@return table
local function ensureWaitList(jobKey)
    waiting[jobKey] = waiting[jobKey] or {}
    return waiting[jobKey]
end

---@param jobKey string
---@param source number
---@return number|nil 1-based position
local function findWaitIndex(jobKey, source)
    local list = waiting[jobKey]
    if not list then return nil end
    source = tonumber(source)
    for i = 1, #list do
        if tonumber(list[i].source) == source then
            return i
        end
    end
    return nil
end

---@param jobKey string
---@param source number
local function removeWaiter(jobKey, source)
    local list = waiting[jobKey]
    if not list then return end
    source = tonumber(source)
    for i = #list, 1, -1 do
        if tonumber(list[i].source) == source then
            table.remove(list, i)
        end
    end
    if #list == 0 then waiting[jobKey] = nil end
end

---@param jobKey string
---@param source number
---@param lobbyId string|number|nil
---@return number position
local function enqueue(jobKey, source, lobbyId)
    local list = ensureWaitList(jobKey)
    local existing = findWaitIndex(jobKey, source)
    if existing then
        list[existing].lobbyId = lobbyId or list[existing].lobbyId
        list[existing].joinedAt = list[existing].joinedAt or now()
        return existing
    end
    list[#list + 1] = {
        source = tonumber(source),
        lobbyId = lobbyId,
        joinedAt = now(),
    }
    return #list
end

---@param jobKey string
---@param source number|nil
---@return table
function JobRunQueue.getStatus(jobKey, source)
    if not JobRunQueue.isEnabled() or JobRunQueue.isExempt(jobKey) then
        return {
            applies = false,
            busy = false,
            position = 0,
            queueLength = 0,
            active = false,
        }
    end

    local act = active[jobKey]
    local list = waiting[jobKey] or {}
    local position = source and findWaitIndex(jobKey, source) or 0

    return {
        applies = true,
        busy = act ~= nil,
        active = act ~= nil,
        activeLobbyId = act and act.lobbyId or nil,
        position = position or 0,
        queueLength = #list,
    }
end

---@param jobKey string
---@param source number
---@param lobbyId string|number|nil
---@return number position
function JobRunQueue.joinWait(jobKey, source, lobbyId)
    if not JobRunQueue.isEnabled() or JobRunQueue.isExempt(jobKey) then
        return 0
    end
    if not active[jobKey] then
        return 0
    end
    return enqueue(jobKey, source, lobbyId)
end

--- Try to take the active slot. If busy, enqueue the player and return false.
---@param jobKey string
---@param lobbyId string|number
---@param source number
---@return boolean ok, table info
function JobRunQueue.tryAcquire(jobKey, lobbyId, source)
    if not JobRunQueue.isEnabled() or JobRunQueue.isExempt(jobKey) then
        return true, { skipped = true }
    end

    local act = active[jobKey]
    if act and tostring(act.lobbyId) == tostring(lobbyId) then
        removeWaiter(jobKey, source)
        return true, { already = true }
    end

    if not act then
        active[jobKey] = { lobbyId = lobbyId, startedAt = now() }
        removeWaiter(jobKey, source)
        return true, { acquired = true }
    end

    local position = enqueue(jobKey, source, lobbyId)
    local queueLength = #(waiting[jobKey] or {})
    return false, {
        busy = true,
        position = position,
        queueLength = queueLength,
        activeLobbyId = act.lobbyId,
    }
end

---@param jobKey string
---@param lobbyId string|number|nil
function JobRunQueue.release(jobKey, lobbyId)
    if not jobKey then return end
    if JobRunQueue.isExempt(jobKey) then return end

    local act = active[jobKey]
    if not act then return end
    if lobbyId ~= nil and tostring(act.lobbyId) ~= tostring(lobbyId) then
        return
    end

    active[jobKey] = nil

    local list = waiting[jobKey] or {}
    -- Notify everyone still waiting that a slot opened (FIFO — first should start)
    for i = 1, #list do
        local entry = list[i]
        local src = entry and entry.source
        if src and GetPlayerPed(src) ~= 0 then
            local pos = i
            Utils.server_notify(
                src,
                'Job Queue',
                'inform',
                locale('jobs.queue_ready', pos) or ('Job slot free — you are #%s in queue. Start when ready.'):format(pos)
            )
            TriggerClientEvent(_e('client:jobs:queueReady'), src, jobKey, {
                position = pos,
                queueLength = #list,
            })
        end
    end
end

---@param source number
function JobRunQueue.leaveAll(source)
    source = tonumber(source)
    if not source then return end
    for jobKey, list in pairs(waiting) do
        for i = #list, 1, -1 do
            if tonumber(list[i].source) == source then
                table.remove(list, i)
            end
        end
        if #list == 0 then waiting[jobKey] = nil end
    end
end

---@param lobbyId string|number
function JobRunQueue.releaseLobby(lobbyId)
    if lobbyId == nil then return end
    for jobKey, act in pairs(active) do
        if tostring(act.lobbyId) == tostring(lobbyId) then
            JobRunQueue.release(jobKey, lobbyId)
        end
    end
end

AddEventHandler('playerDropped', function()
    JobRunQueue.leaveAll(source)
end)

return JobRunQueue
