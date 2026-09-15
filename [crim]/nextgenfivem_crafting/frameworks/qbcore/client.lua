local QBCore

local function init()
    QBCore = exports['qb-core']:GetCoreObject()
end

local function notify(msg, type)
    QBCore?.Functions.Notify(msg, type)
end

return {
    init = init,
    notify = notify
}
