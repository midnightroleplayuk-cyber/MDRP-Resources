if GetResourceState('es_extended') == 'started' then return end
if GetResourceState('qb-core') == 'started' then return end

function AddAlcohol(source, amount)
    -- No-op when no framework; implement in custom bridge if needed.
end

function IsPlayerJobBoss(source, jobName)
    return false
end

print("STANDALONE IS NOT SUPPORTED, PLEASE CODE YOUR OWN BRIDGE.")