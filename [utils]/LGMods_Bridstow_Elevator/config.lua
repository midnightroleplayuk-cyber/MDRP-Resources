Config = Config or {}

local coords = ElevatorCoords
assert(coords and coords.floors and coords.floors[1], '[ELEVATOR] elevator_coords.lua missing - load it before config.lua')

local floorHeights, floorDoors, floorList, floorMlos = {}, {}, {}, {}
local floorLabels = { [1] = 'Ground Floor' }

for i = 1, #coords.floors do
    local f = coords.floors[i]
    floorHeights[i] = f.cabinZ
    floorDoors[i] = { coords = f.door1, coords2 = f.door2 }
    floorList[i] = i
    floorMlos[i] = f.mlo
    floorLabels[i] = floorLabels[i] or ('Floor %d'):format(i - 1)
end

Config.Elevator = {
    Debug = false,

    CabinModel = coords.cabinModel,
    DoorModel = coords.doorModel,

    MsPerUnit = 700,
    MinTravelMs = 3000,
    DepartDelayMs = 1000,
    BezierCurve = 'easeInOut',

    DoorSlide = 0.72,
    DoorMs = 1000,
    DoorHoldMs = 5000,
    AutoOpenDistance = 2.5,
    AutoOpenMenu = false,

    UseTarget = true,
    KeyPromptsWithTarget = false,
    CallDistance = 2.0,
    PanelDistance = 1.5,
    CabinRoom = 'foyer',

    StateBagPrefix = 'bridstow_elevator_',

    FloorHeights = floorHeights,
    FloorLabels = floorLabels,
    CabinDoorOffsets = coords.cabinDoorOffsets,
    CabinPanel = coords.cabinPanel,
    FloorDoors = { [1] = floorDoors },
    FloorMlos = floorMlos,

    CabinLight = { offsetZ = 2.35, range = 15.0, color = { 255, 226, 199 } },

    CallButton = {
        model = 'lgmods_bridstow_elev_button',

        offset = vec3(1.00, -0.10, 1.45),
        floorOffsets = {},
        zoneRadius = 0.3,
        drawSprite = false,
        command = 'elevbutton',

        findProps = true,    -- look for the button prop as an entity (false = static map prop: the zone is enough, saves the search)
        searchRadius = 3.0,
        targetDistance = 1.5,
        distance = 1.2,
        keepDoorCall = false,

        -- Lit the same way as the indicator frames: the button face is the emissive
        -- 'lgmods_liftind_arrows' texture embedded in the button's .ydr (UVs on its left half),
        -- swapped for indicator/<litImage>.png when lit and indicator/<offImage>.png when not.
        light = true,
        txd = 'lgmods_bridstow_elev_button', -- the button's .ydr name (like Indicator.txd = the frames' .ydr)
        tex = 'lgmods_liftind_arrows',       -- texture on the button face
        litImage = 'button_lit',
        offImage = 'arrows_none',            -- false = put the model's own texture back instead
    },

    Indicator = {
        txd = 'lgmods_bridstow_frames',
        number = 'lgmods_liftind_num',
        arrows = 'lgmods_liftind_arrows',
    },

    -- Floor buttons on the cabin panel. Each button has a transparent emissive overlay
    -- ('lgmods_liftpanel_lights', embedded in the cabin .ydr) whose UVs sit in their own cell of a
    -- 1024 x 32 strip: floor 1 (G) = cell 0, floor 2 = cell 1 ... The script paints that strip at
    -- runtime, so the floor picked in the cabin lights up until the lift arrives there.
    PanelLights = {
        txd = 'lgmods_bridstow_elev',      -- the cabin's .ydr name
        tex = 'lgmods_liftpanel_lights',   -- overlay texture on the buttons
        width = 1024,
        height = 32,
        cell = 32,                         -- px per button; the button edge is 15 px from the cell centre
        color = { 255, 236, 195 },         -- same cream as the indicator / call button
        ringInner = 0.72,                  -- lit ring = the button's bevel (1.0 = 15 px)
        ringOuter = 0.97,
        fillAlpha = 70,                    -- 0-255 tint over the face inside the ring (0 = ring only)
        pressMs = 1500,                    -- light straight away when picked, before the server answers
        landingCalls = false,              -- true = also light the floor a landing call sends the lift to
    },

    Sounds = {
        move = { set = 'LIFT_NORMAL_SOUNDSET', name = 'move', scriptBank = 'LIFTS' },
        arrive = { set = 'LIFT_NORMAL_SOUNDSET', name = 'Bell' },
        doors = 'MP_PROPERTIES_ELEVATOR_DOORS',
    },

    Elevators = {
        {
            name = 'Bridstow Courts Lift',
            baseCoords = coords.cabin,
            heading = coords.heading,
            floors = floorList,
            motion = 'velocity',
            spawnZone = coords.spawnZone,
            insideZone = coords.insideZone,
        },
    },

    Text = {
        title = 'Elevator',
        goTo = 'Go to %s',
        floor = 'Floor %d',
        selectFloor = '[E] Select floor',
        callKey = '[E] Call elevator',
        panel = 'Select floor',
        openDoors = 'Open doors',
        call = 'Call elevator',
        callTarget = 'Call elevator (%s)',
        moving = 'Elevator is moving…',
        busy = 'Elevator is busy',
    },
}

function ElevatorTravelMs(elevatorId, fromFloor, toFloor)
    local c = Config.Elevator
    local msPerUnit = c.Elevators[elevatorId].msPerUnit or c.MsPerUnit
    local height = math.abs(c.FloorHeights[toFloor] - c.FloorHeights[fromFloor])

    return math.max(c.MinTravelMs, math.floor(height * msPerUnit))
end