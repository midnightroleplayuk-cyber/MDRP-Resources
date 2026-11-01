-- IMPORTANT DISCLAIMER:
-- This file contains critical functions for elevator operation.
-- DO NOT modify anything unless you know exactly what you are doing.
-- Any incorrect changes can break the entire elevator system.

-- Global system variables
isInsideElevator = false
currentTextUI = nil

-- Function to update screen text
-- @param newText - New text to display (nil to hide)
function updateTextUI(newText)
    if currentTextUI ~= newText then
        if newText then
            lib.showTextUI(newText)
        else
            lib.hideTextUI()
        end
        currentTextUI = newText
    end
end

-- Function to get floor menu options
-- @returns table - Menu options for available floors
function getFloorMenu()
    local options = {}
    local currentFloor = GlobalState.elevator.currentFloor
    
    -- If elevator is moving, show disabled option
    if GlobalState.elevator.isMoving then
        return {
            {
                title = Config.Messages.elevatorMoving,
                disabled = true
            }
        }
    end
    
    -- Create options for each floor
    for floor, floorData in ipairs(Config.Elevator.floors) do
        -- Don't show current floor as an option
        if floor ~= currentFloor then
            table.insert(options, {
                title = floorData.label,
                description = floorData.description,
                icon = 'building',
                onSelect = function()
                    SelectFloor(floor,currentFloor) -- Execute this function to select the floor (this move the elevator and plays the animation)
                end
            })
        end
    end
    
    return options
end

-- Inside elevator zone
-- This zone handles all interactions when player is inside the elevator
local insideZone = lib.zones.box({
    -- Zone position and size from config
    coords = Config.Elevator.insideZone.coords,
    size = Config.Elevator.insideZone.size,
    rotation = Config.Elevator.insideZone.rotation,

    -- Called when player enters elevator
    onEnter = function()
        isInsideElevator = true
        SetInteriorProbeLength(50.0) -- Prevents texture loss in interior (CRITICAL, MAKE SURE TO KEEP THIS)
    end,

    -- Called when player exits elevator
    onExit = function()
        isInsideElevator = false
        updateTextUI(nil) -- Hide any UI text
        SetInteriorProbeLength(0.0) -- Reset interior probe length
    end,

    -- Called every frame while player is inside elevator
    inside = function()
        -- Only allow floor selection if elevator is not moving
        if not GlobalState.elevator.isMoving then
            -- Show floor selection prompt
            updateTextUI('[E] ' .. Config.Messages.selectFloor)

            -- Check if player pressed the interaction key (E)
            if IsControlJustPressed(0, 38) then
                -- Register and show the floor selection menu
                lib.registerContext({
                    id = 'elevator_floor_menu',
                    title = Config.Messages.elevatorTitle,
                    options = getFloorMenu() -- Get available floor options
                })
                lib.showContext('elevator_floor_menu')
            end
        else
            updateTextUI(nil) -- Hide UI text while elevator is moving
        end
    end
})

-- Elevator call zone
-- This zone handles calling the elevator from outside
local callZone = lib.zones.box({
    -- Zone position and size from config
    coords = Config.Elevator.callZone.coords,
    size = Config.Elevator.callZone.size,
    rotation = Config.Elevator.callZone.rotation,

    -- Called when player exits the call zone
    onExit = function()
        updateTextUI(nil) -- Hide any UI text
    end,

    -- Called every frame while player is in call zone
    inside = function()
        local state = GlobalState.elevator
        
        -- Show "elevator moving" text if elevator is in motion
        if state.isMoving then
            updateTextUI(Config.Messages.elevatorMoving)
        else
            -- Get player position and nearest floor
            local playerCoords = GetEntityCoords(cache.ped)
            local nearestFloor = getNearestFloor(playerCoords.z)
            
            -- Only show call prompt if elevator is on a different floor
            if nearestFloor ~= state.currentFloor then
                updateTextUI('[E] ' .. Config.Messages.callElevator)
                
                -- Check if player pressed interaction key and is not inside elevator
                if IsControlJustPressed(0, 38) and not isInsideElevator then
                    CallElevator(playerCoords,nearestFloor) -- Call elevator to player's floor                    
                end
            else
                updateTextUI(nil) -- Hide UI text if elevator is already on this floor
            end
        end
    end
})