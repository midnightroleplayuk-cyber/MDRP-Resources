local ESX

local function init()
    ESX = exports['es_extended']:getSharedObject()
end

local function notify(msg)
    ESX.ShowNotification(msg)
end

return {
    init = init,
    notify = notify
}
