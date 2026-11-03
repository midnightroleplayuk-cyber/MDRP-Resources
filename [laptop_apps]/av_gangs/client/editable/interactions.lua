local interactions = {}
local hideUI = false

function setInteractions(data,coords,propertyIdentifier,gang,interiorType)
    if not data then
        warn('setInteractions received null instead of data (?)')
        return
    end
    if data and next(data) then
        for _, v in pairs(data) do
            v['label'] = v['label'] or "Interact"
            interactions[#interactions+1] = lib.points.new({
                coords = {x = coords['x'] + v['x'], y = coords['y'] + v['y'], z = coords['z'] + v['z']},
                distance = v['dist'] or 2.0,
                label = Config.InteractionPrefix.." "..v['label'],
                identifier = v['identifier'],
                propertyIdentifier = propertyIdentifier,
                event = v['event'],
                type = v['type'],
                gang = gang,
                interiorType = interiorType,
            })
        end
    end
end

function addInteraction(data, coords, propertyIdentifier, gang, interiorType) -- door is added to interactions after setInteractions
    if not data or not coords then return end
    data['label'] = data['label'] or "Interact"
    interactions[#interactions+1] = lib.points.new({
        coords = {x = coords['x'] + data['x'], y = coords['y'] + data['y'], z = coords['z'] + data['z']},
        distance = data['dist'] or 2.0,
        label = Config.InteractionPrefix.." "..data['label'],
        identifier = data['identifier'],
        propertyIdentifier = propertyIdentifier,
        event = data['event'],
        gang = gang,
        interiorType = interiorType
    })
    refreshInteractions()
end

function refreshInteractions()
    for _, v in pairs(interactions) do
        function v:nearby()
            if self.currentDistance <= self.distance then
                if not exports['av_laptop']:isTextUIOpen() and not hideUI then
                    exports['av_laptop']:showTextUI(self.label)
                end
                if IsControlJustReleased(0, Config.InteractionKey) then
                    if exports['av_laptop']:isTextUIOpen() then
                        hideUI = true
                        exports['av_laptop']:hideTextUI()
                    end
                    dbug('Triggering ', self.event)
                    if self.event then
                        TriggerEvent(self.event, {
                            identifier = self['identifier'],
                            propertyIdentifier = self['propertyIdentifier'],
                            event = self['event'],
                            type = self['type'],
                            gang = self['gang'],
                            interiorType = self['interiorType'],
                        })
                    else
                        warn("Oops seems like this interaction doesn't trigger anything, verify your zone with the Shells Manager")
                    end
                end
            end
        end
        function v:onExit()
            hideUI = false
            if exports['av_laptop']:isTextUIOpen() then
                exports['av_laptop']:hideTextUI()
            end
        end
    end
end

function wipeInteractions()
    for _, v in pairs(interactions) do
        v:remove()
    end
end