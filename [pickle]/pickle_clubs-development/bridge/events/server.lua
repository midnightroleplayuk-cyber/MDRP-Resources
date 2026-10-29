function TriggerTargetedEvent(event, targets, ...)
    if type(targets) == "number" or type(targets) == "string" then
        targets = {tonumber(targets)}
    end
    for i=1, #targets do
        local target = targets[i]
        TriggerClientEvent(event, target, ...)
    end
end