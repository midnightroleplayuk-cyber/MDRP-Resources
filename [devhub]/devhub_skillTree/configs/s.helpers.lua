Helpers = {}

--- Check if player has a specific job and optionally a minimum grade
--- @param source number
--- @param job string
--- @param grade number|nil - minimum grade required (optional)
--- @return boolean
function Helpers.CheckJob(source, job, grade)
    local playerJob = Core.GetJob(source)
    if not playerJob then return false end
    if playerJob.name ~= job then return false end
    if grade and playerJob.grade < grade then return false end
    return true
end

--- Check if player has enough of an item
--- @param source number
--- @param item string
--- @param amount number|nil - defaults to 1
--- @return boolean
function Helpers.HasItem(source, item, amount)
    amount = amount or 1
    local count = Core.GetItemCount(source, item)
    return count >= amount
end

--- Check if player matches a specific identifier
--- @param source number
--- @param identifier string
--- @return boolean
function Helpers.CheckIdentifier(source, identifier)
    local playerIdentifier = Core.GetIdentifier(source)
    if not playerIdentifier then return false end
    return playerIdentifier == identifier
end

--- Check if player has admin permissions
--- @param source number
--- @return boolean
function Helpers.IsAdmin(source)
    return Core.IsPlayerAdmin(source)
end

--- Check if player has enough money (cash)
--- @param source number
--- @param amount number
--- @return boolean
function Helpers.HasEnoughMoney(source, amount)
    local cash = Core.GetCash(source)
    return cash >= amount
end

--- Check if player has a specific skill unlocked
--- @param source number
--- @param categoryUid string
--- @param skillUid string
--- @return boolean
function Helpers.CheckUnlockedSkill(source, categoryUid, skillUid)
    local player = getPlayer(source)
    if not player then return false end
    return player:hasUnlockedSkill(categoryUid, skillUid)
end

--- Remove an item from the player
--- @param source number
--- @param item string
--- @param amount number|nil - defaults to 1
function Helpers.RemoveItem(source, item, amount)
    amount = amount or 1
    Core.RemoveItem(source, item, amount)
end

--- Remove cash from the player
--- @param source number
--- @param amount number
function Helpers.RemoveMoney(source, amount)
    Core.RemoveCash(source, amount)
end
