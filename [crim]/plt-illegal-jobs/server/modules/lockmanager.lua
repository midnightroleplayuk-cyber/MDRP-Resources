
local LockManager = {}
local locks = {}

function LockManager.lock(key)
    if locks[key] then return false end
    locks[key] = true
    return true
end

function LockManager.unlock(key)
    locks[key] = nil
end

function LockManager.isLocked(key)
    return locks[key] ~= nil
end

return LockManager
