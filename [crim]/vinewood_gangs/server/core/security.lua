Security = {}

local last = {}

---Returns false if the player called this action again within `ms`.
function Security.Throttle(src, key, ms)
    local now = GetGameTimer()
    local id = ('%s:%s'):format(src, key)
    if last[id] and now - last[id] < ms then
        return false
    end
    last[id] = now
    return true
end

AddEventHandler('playerDropped', function()
    local prefix = tostring(source) .. ':'
    for id in pairs(last) do
        if id:sub(1, #prefix) == prefix then
            last[id] = nil
        end
    end
end)
