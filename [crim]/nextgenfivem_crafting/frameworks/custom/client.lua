local function init()
end

local function notify(msg)
    -- Notify the player

    print(msg)
end

return {
    init = init,
    notify = notify
}
