local function init()
end

local function notify(msg)
    TriggerEvent('ox_lib:notify', { description = msg })
end

return {
    init = init,
    notify = notify
}
