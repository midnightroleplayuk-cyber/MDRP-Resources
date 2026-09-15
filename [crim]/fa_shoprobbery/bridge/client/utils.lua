Bridge = Bridge or {}

function ResourceStarted(name)
    return GetResourceState(name) == 'started'
end