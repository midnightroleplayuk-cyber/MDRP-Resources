---@type TRPlayerShared
local shared = ...
local bridge = TR.bridge('framework')

---Framework-agnostic player API. Every function takes a server id (src).
---@class TRPlayer : TRPlayerShared
local player = setmetatable({}, { __index = shared })

---Raw framework bridge. Only for tr_core internals; scripts should use the functions below.
player.bridge = bridge

local function isValidAmount(amount)
    return math.type(amount) == 'integer' and amount > 0
end

---An account set for 'dirty' in config.lua wins over the framework's item.
---@return { name: string, worth?: string }?
local function dirtyItem(account)
    if account ~= 'dirty' or not bridge.dirtyItem then return end
    local set = type(TR.config.accounts) == 'table' and TR.config.accounts.dirty
    if type(set) == 'string' and set ~= '' and set ~= 'auto' then return end
    return bridge.dirtyItem
end

local function bagWorth(dirty, slot)
    return math.floor(tonumber(slot.metadata[dirty.worth]) or 0)
end

local function countItemMoney(src, dirty)
    if not dirty.worth then return TR.inventory.getCount(src, dirty.name) end

    local total = 0
    for _, slot in ipairs(TR.inventory.getSlots(src, dirty.name)) do
        total = total + slot.count * bagWorth(dirty, slot)
    end
    return total
end

local function addItemMoney(src, dirty, amount)
    if not dirty.worth then return TR.inventory.addItem(src, dirty.name, amount) == true end
    return TR.inventory.addItem(src, dirty.name, 1, { [dirty.worth] = amount }) == true
end

-- Bags go whole, so what is paid over comes back as one bag of the change.
local function removeItemMoney(src, dirty, amount)
    if not dirty.worth then return TR.inventory.removeItem(src, dirty.name, amount) end

    local taken, paid = {}, 0
    for _, slot in ipairs(TR.inventory.getSlots(src, dirty.name)) do
        if paid >= amount then break end
        local worth = bagWorth(dirty, slot)
        if worth > 0 then
            local bags = math.min(slot.count, (amount - paid + worth - 1) // worth)
            if not TR.inventory.removeItem(src, dirty.name, bags, nil, slot.slot) then
                for _, back in ipairs(taken) do TR.inventory.addItem(src, dirty.name, back.bags, back.metadata) end
                return false
            end
            taken[#taken + 1] = { bags = bags, metadata = slot.metadata }
            paid = paid + bags * worth
        end
    end

    if paid > amount then addItemMoney(src, dirty, paid - amount) end
    return true
end

---@param src integer
---@return boolean
function player.isLoaded(src) return bridge.isLoaded(src) end

---@param src integer
---@return string? identifier persistent character identifier
function player.getIdentifier(src) return bridge.getIdentifier(src) end

---@param src integer
---@return string? name character name
function player.getName(src) return bridge.getName(src) end

---@param src integer
---@return TRJob?
function player.getJob(src) return bridge.getJob(src) end

---@param src integer
---@param filter TRJobFilter
---@param requireDuty? boolean
---@return boolean
function player.hasJob(src, filter, requireDuty)
    return shared.matchJob(bridge.getJob(src), filter, requireDuty)
end

---@param src integer
---@return TRGang?
function player.getGang(src) return bridge.getGang(src) end

---@param src integer
---@param filter TRJobFilter
---@return boolean
function player.hasGang(src, filter)
    return shared.matchJob(bridge.getGang(src), filter)
end

---@param src integer
---@return string? group staff group: 'user', 'mod', 'admin', ... (framework dependent)
function player.getGroup(src) return bridge.getGroup(src) end

---True for the framework's admins, or anyone with the `tr.admin` ace.
---@param src integer
---@return boolean
function player.isAdmin(src)
    return IsPlayerAceAllowed(src, 'tr.admin') or bridge.isAdmin(src)
end

---@param src integer
---@param account TRAccount
---@return integer
function player.getMoney(src, account)
    assert(shared.accounts[account], ('invalid account "%s"'):format(account))
    local dirty = dirtyItem(account)
    if dirty then return countItemMoney(src, dirty) end
    return bridge.getMoney(src, account) or 0
end

---@param src integer
---@param account TRAccount
---@param amount integer
---@return boolean
function player.canAfford(src, account, amount)
    return player.getMoney(src, account) >= amount
end

---@param src integer
---@param account TRAccount
---@param amount integer positive integer
---@param reason? string shown in framework logs
---@return boolean success
function player.addMoney(src, account, amount, reason)
    assert(shared.accounts[account], ('invalid account "%s"'):format(account))

    if not isValidAmount(amount) then
        TR.log.error('addMoney: invalid amount %s for %d', amount, src)
        return false
    end

    local dirty = dirtyItem(account)
    if dirty then return addItemMoney(src, dirty, amount) end
    return bridge.addMoney(src, account, amount, reason or TR.resource)
end

---Removes money only when the player has enough.
---@param src integer
---@param account TRAccount
---@param amount integer positive integer
---@param reason? string shown in framework logs
---@return boolean success
function player.removeMoney(src, account, amount, reason)
    assert(shared.accounts[account], ('invalid account "%s"'):format(account))

    if not isValidAmount(amount) then
        TR.log.error('removeMoney: invalid amount %s for %d', amount, src)
        return false
    end

    if not player.canAfford(src, account, amount) then return false end

    local dirty = dirtyItem(account)
    if dirty then return removeItemMoney(src, dirty, amount) end
    return bridge.removeMoney(src, account, amount, reason or TR.resource)
end

---@return integer[] sources of all loaded players
function player.getPlayers() return bridge.getPlayers() end

---Loaded players whose job matches the filter, e.g. the police on duty:
---
---    local cops = TR.player.getPlayersWithJob({ 'police', 'sheriff' }, true)
---
---@param filter TRJobFilter
---@param requireDuty? boolean only those on duty
---@return integer[] sources
function player.getPlayersWithJob(filter, requireDuty)
    local found = {}
    for _, src in ipairs(bridge.getPlayers()) do
        if shared.matchJob(bridge.getJob(src), filter, requireDuty) then found[#found + 1] = src end
    end
    return found
end

---How many loaded players have a matching job, e.g. a robbery that needs police online:
---
---    if TR.player.countJob(Config.police.jobs, true) < Config.police.min then return false, 'no_police' end
---
---@param filter TRJobFilter
---@param requireDuty? boolean only those on duty
---@return integer
function player.countJob(filter, requireDuty)
    return #player.getPlayersWithJob(filter, requireDuty)
end

---@param identifier string
---@return integer? src
function player.getSource(identifier) return bridge.getSource(identifier) end

---Runs `cb(src)` when a player's character is loaded. By default it also runs for players
---who are already loaded, so restarting a resource behaves like a fresh join.
---@param cb fun(src: integer)
---@param skipExisting? boolean
function player.onLoaded(cb, skipExisting)
    AddEventHandler('tr:playerLoaded', cb)

    if not skipExisting then
        for _, src in ipairs(bridge.getPlayers()) do
            CreateThread(function() cb(src) end)
        end
    end
end

---Runs `cb(src)` when a character logs out or the player drops.
---@param cb fun(src: integer)
function player.onUnloaded(cb)
    AddEventHandler('tr:playerUnloaded', cb)
end

---Runs `cb(src, job, lastJob)` when a player's job, grade or duty changes.
---@param cb fun(src: integer, job: TRJob, lastJob: TRJob?)
function player.onJobUpdated(cb)
    AddEventHandler('tr:jobUpdated', cb)
end

return player
