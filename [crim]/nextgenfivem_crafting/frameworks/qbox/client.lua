local function init()
end

local function notify(msg)
    exports.qbx_core:Notify(msg)
end

return {
    init = init,
    notify = notify
}
