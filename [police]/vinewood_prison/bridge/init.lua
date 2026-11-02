Bridge = {}

local function detect()
    if Config.Framework ~= 'auto' then return Config.Framework end
    if Prison.isUp('qbx_core') then return 'qbx' end
    if Prison.isUp('qb-core') then return 'qb' end
    if Prison.isUp('es_extended') then return 'esx' end
    return nil
end

Bridge.framework = detect()

if not Bridge.framework then
    Prison.warn('No supported framework found (qbx_core, qb-core, es_extended). Set Config.Framework.')
end
