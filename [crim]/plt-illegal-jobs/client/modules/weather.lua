
local Weather = {}

function Weather.disableSync()
    if shared.framework == 'qbx' or shared.framework == 'qb' then
        TriggerEvent('qb-weathersync:client:DisableSync')
    elseif shared.framework == 'esx' then
        TriggerEvent('vSync:toggle', false)
    end
    -- Hook your own weather script here if needed
end

function Weather.enableSync()
    if shared.framework == 'qbx' or shared.framework == 'qb' then
        TriggerEvent('qb-weathersync:client:EnableSync')
    elseif shared.framework == 'esx' then
        TriggerEvent('vSync:toggle', true)
    end
    -- Hook your own weather script here if needed
end

return Weather
