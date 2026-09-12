local bussy = false

local lumihud = GetResourceState("tgiann-lumihud") ~= "missing"
local tgiannProgressbar = GetResourceState("tgiann-progressbar") ~= "missing"

tgiCore.Progressbar = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if bussy then
        Notify("ALREADY_ERROR", "error")
        if onCancel then onCancel() end
        return false
    end

    if prop and not next(prop) then prop = nil end
    if propTwo and not next(propTwo) then propTwo = nil end
    if animation and not next(animation) then animation = nil end

    bussy = true

    if lumihud then
        local success = exports['tgiann-lumihud']:Progress({
            name = name:lower(),
            duration = duration,
            label = label,
            useWhileDead = useWhileDead,
            canCancel = canCancel,
            controlDisables = disableControls,
            animation = animation and animation or {},
            prop = prop and prop or {},
            propTwo = propTwo and propTwo or {},
        })
        bussy = false
        if success then
            if onFinish then onFinish() end
        else
            if onCancel then onCancel() end
        end
        return success
    elseif tgiannProgressbar then
        local p = promise.new()
        exports['tgiann-progressbar']:Progress({
            name = name:lower(),
            duration = duration,
            label = label,
            useWhileDead = useWhileDead,
            canCancel = canCancel,
            controlDisables = disableControls,
            animation = animation and animation or {},
            prop = prop and prop or {},
            propTwo = propTwo and propTwo or {},
        }, function(cancelled)
            if not cancelled then
                p:resolve(true)
            else
                p:resolve(false)
            end
        end)
        local success = Citizen.Await(p)
        bussy = false
        if success then
            if onFinish then onFinish() end
        else
            if onCancel then onCancel() end
        end
        return success
    elseif config.framework == "qb" and not config.qbx then -- QB Framework
        local p = promise.new()
        tgiCore.core.Functions.Progressbar(
            name:lower(),
            label,
            duration,
            useWhileDead,
            canCancel,
            disableControls,
            animation or {},
            prop or {},
            propTwo or {},
            function()
                p:resolve(true)
            end,
            function()
                p:resolve(false)
            end)

        local success = Citizen.Await(p)

        bussy = false
        if success then
            if onFinish then onFinish() end
        else
            if onCancel then onCancel() end
        end
        return success
    else
        local propData = {}
        local firstPropData = prop and {
            model = prop.model,
            pos = prop.coords,
            rot = prop.rotation,
            bone = prop.bone
        } or nil

        local secondPropData = propTwo and {
            model = propTwo.model,
            pos = propTwo.coords,
            rot = propTwo.rotation,
            bone = propTwo.bone
        } or nil

        if firstPropData then propData[#propData + 1] = firstPropData end
        if secondPropData then propData[#propData + 1] = secondPropData end

        local propLength = #propData

        local success = lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = useWhileDead,
            canCancel = canCancel,
            disable = {
                car = disableControls.disableCarMovement,
                move = disableControls.disableMovement,
                combat = disableControls.disableCombat,
                mouse = disableControls.disableMouse,
            },
            anim = animation and {
                dict = animation.animDict,
                clip = animation.anim,
                flag = animation.flags
            } or nil,
            prop = propLength > 0 and propData or nil
        })
        bussy = false
        if success then
            if onFinish then onFinish() end
        else
            if onCancel then onCancel() end
        end
        return success
    end
end
