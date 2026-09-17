if not GetResourceState('ox_core'):find('start') then return end

local bridge = {}

bridge.framework = 'ox'

function bridge.getGender()
    return 'male'
end

function bridge.getJob()
    local group = LocalPlayer.state.activeGroup
    if not group then return nil end
    return {
        name = group.name or group,
        label = group.label or group.name or 'Group',
        grade = group.grade or 0,
        gradeLabel = 'Grade ' .. (group.grade or 0),
        onDuty = true,
    }
end

function bridge.hasGroup(filter)
    local group = LocalPlayer.state.activeGroup
    local name = type(group) == 'table' and group.name or group
    if type(filter) == 'string' then return name == filter end
    if type(filter) == 'table' then
        for i = 1, #filter do
            if name == filter[i] then return true end
        end
    end
    return false
end

AddEventHandler('ox:playerLoaded', function()
    TriggerEvent('wasabi_mdt:playerLoaded')
end)

AddEventHandler('ox:setGroup', function()
    local job = bridge.getJob()
    if job then TriggerEvent('wasabi_mdt:setJob', job) end
end)

Modules.register('bridge', bridge)
