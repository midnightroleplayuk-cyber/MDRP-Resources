local crates = {}

function registerBox(data)
    dbug('registerBox()')
    local coords = data['coords']
    crates[#crates+1] = lib.points.new({
        coords = vector3(coords.x, coords.y, coords.z),
        distance = 2.0,
        warehouse = data['warehouse'],
        identifier = data['identifier']
    })
end

function refreshBoxes()
    dbug('refreshBoxes()')
    for _, crate in pairs(crates) do
        function crate:onEnter()
            if not isOpen() then
                showText("[E] "..Lang['open'])
            end
        end
        function crate:nearby()
            if IsControlJustPressed(0,38) then
                if isOpen() then
                    closeText()
                end
                local opened = openBox(self)
                if opened then
                    crate:remove()
                end
            end
        end
        function crate:onExit()
            if isOpen() then
                closeText()
            end
        end
    end
end

function registerTarget(data)
    if not Config.Target then return end
    if isCop() then return end
    local options = {
        {
            name = data['identifier'],
            num = 1,
            type = "client",
            icon = "fa-solid fa-box",
            label = Lang['open'],
            distance = 1.5,
            warehouse = data['warehouse'],
            box = data['identifier'],
            canInteract = function()
                return not getBusy()
            end,
            action = function()
                openBox(data)
            end,
            onSelect = function()
                openBox(data)
            end,

        }
    }
    if Config.Target == "ox-target" then
        exports[Config.Target]:addLocalEntity(data['entity'], options)
    else
        exports[Config.Target]:AddTargetEntity(data['entity'], {
            options = options,
            distance = 2.5
        })
    end
end

function removeTarget(entity)
    if not Config.Target then return end
    if isCop() then return end
    if Config.Target == "ox-target" then
        exports.ox_target:removeLocalEntity(entity)
    else
        exports[Config.Target]:RemoveTargetEntity(entity, Lang['open'])
    end
end