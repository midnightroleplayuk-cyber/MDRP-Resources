-- interactive zones while inside shell
local zones = {}

function addInteractions(entry,door,interactions,identifier,hasKeys)
    for k, v in pairs(interactions) do
        local coords = v['coords']
        v['identifier'] = identifier
        v['hasKeys'] = hasKeys
        zones[#zones+1] = lib.points.new({
            coords = vector3(coords.x + entry.x, coords.y + entry.y, coords.z + entry.z),
            heading = coords.heading,
            event = v['event'],
            label = v['label'],
            extraData = v,
            distance = 1.5,
        })
    end
    zones[#zones+1] = lib.points.new({
        coords = vector3(door.x + entry.x, door.y + entry.y, door.z + entry.z),
        heading = door['heading'],
        event = "av_drugs:exit",
        label = Lang['door_text'],
        extraData = {hasKeys = hasKeys, identifier = identifier},
        distance = 1.5,
    })
    for k, v in pairs(zones) do
        function v:nearby()
            if self.currentDistance < 2 then
                if not LocalPlayer.state.busy and not exports['av_laptop']:isTextUIOpen() then
                    exports['av_laptop']:showTextUI(v['label']) 
                end
                if IsControlJustReleased(0, 38) and not LocalPlayer.state.busy then
                    exports['av_laptop']:hideTextUI()
                    TriggerEvent(self.event, self.extraData)
                end
            end
        end
        function v:onExit()
            if exports['av_laptop']:isTextUIOpen() then
                exports['av_laptop']:hideTextUI()
            end
        end
    end
end

function wipeInteractions()
    for k, v in pairs(zones) do
        v:remove()
    end
end