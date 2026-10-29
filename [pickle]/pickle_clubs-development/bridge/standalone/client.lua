if GetResourceState('es_extended') == 'started' then return end
if GetResourceState('qb-core') == 'started' then return end

print("STANDALONE IS NOT SUPPORTED, PLEASE CODE YOUR OWN BRIDGE.")