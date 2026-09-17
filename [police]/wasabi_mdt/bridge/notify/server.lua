local notify = {}

setmetatable(notify, {
    __call = function(_, source, params)
        TriggerClientEvent('wasabi_mdt:Client:notify', source, params)
    end,
})

Modules.register('notify', notify)
