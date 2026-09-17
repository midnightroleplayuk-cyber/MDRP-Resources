if Config.Inventory.inventoryScript ~= 'codem-inventory' then return end

function Fr.OpenStash(stashId, data)
    data = data or {}
    local slots = tonumber(data.slots) or 50
    local weight = tonumber(data.weight) or 100000
    local label = data.label or stashId
    TriggerServerEvent('codem-inventory:server:openstash', stashId, slots, weight, label)
end