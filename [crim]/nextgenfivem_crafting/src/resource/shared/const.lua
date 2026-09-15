ResourceName = 'nextgenfivem_crafting'
ScriptName = 'crafting'
PlayerStateName = 'nextgenfivem-2_'
VersionResource = 'nextgenfivem_crafting'

AllPermissions = '*'

-- Event Names
EditorQueryEvent = ResourceName .. ':editorQuery:'
EditorMutationEvent = ResourceName .. ':mutationQuery:'

BaseLevel = 0
DefaultXPReward = 25

LevelOptions = {
    XP = 1000,                 -- The base amount of XP required to level up from level 1
    XPMultiplier = 1.1,        -- Multiplier applied to XP requirement for each subsequent level (1.1 = 10% increase per level)
    categoryXP = 500,          -- The base amount of XP required to level up within a specific category
    categoryXPMultiplier = 1.1 -- Multiplier applied to category XP requirement for each subsequent category level
}

AFKTimeout = { -- How many seconds until you get kicked for being AFK
    server = 30 * 60,
    client = 5 * 60
}

ProximityRadius = 80   -- How close you need to be to see the bench
ProximityTickIntervals = {
    nearbyTick = 2500, -- How often to check if players have left the proximity of a bench
    distantTick = 5000 -- How often to check if players have entered the proximity of a bench
}

BenchModels = {
    ["default"] = {
        title = 'Workbench',
        model = `xm3_prop_xm3_bench_04b`,
        centerOffset = vec4(-0.05, 0, 0.805, 0),
        scale = 1
    },
    ["workbench"] = {
        title = 'Workbench 2',
        model = `gr_prop_gr_bench_04a`,
        centerOffset = vec4(-0.05, 0, 0.805, 0),
        scale = 1
    },
    ['tool_bench'] = {
        title = 'Tool Bench',
        model = `prop_tool_bench02_ld`,
        centerOffset = vec4(0.0, -0.2, 0.92, -90),
        scale = 0.8
    },
    ["lab_desk"] = {
        title = 'Lab Desk',
        model = `xm_prop_lab_desk_02`,
        centerOffset = vec4(-0.15, 0, 0.9, 0),
        scale = 1
    },
    ["med_bench"] = {
        title = 'Medical Bench',
        model = `v_med_bench2`,
        centerOffset = vec4(-0.04, 0, 1.01, 0),
        scale = 1
    },
    ["counter"] = {
        title = 'Counter',
        model = `prop_ff_counter_01`,
        centerOffset = vec4(-0.07, -0.02, 0.915, 0),
        scale = 0.9
    },
    ["none"] = {
        title = 'None',
        centerOffset = vec4(0, 0, 0, 0),
        scale = 1
    }
}

BenchAnim = {
    dict = 'anim@amb@board_room@diagram_blueprints@',
    name = 'idle_01_amy_skater_01',
    offset = vec3(-0.85, 0, 0.25)
}

--[[
    Placement modes

    gizmo: The free-camera gizmo. Needs a working mouse cursor.
    ghost: The object hovers in front of the player and is placed by walking
           there. Keyboard only, so it still works when the cursor does not.
]]
PlacementModes = {
    gizmo = 'gizmo',
    ghost = 'ghost'
}

function PlacementModes.resolve(mode)
    return mode == PlacementModes.ghost and PlacementModes.ghost or PlacementModes.gizmo
end

function PlacementModes.toggle(mode)
    return mode == PlacementModes.ghost and PlacementModes.gizmo or PlacementModes.ghost
end

PortableBenchOptions = {
    item = 'crafting_bench',
    needsAccessToPlace = true,
    format = '%s_crafting_bench' -- Format for portable bench items: %s will be replaced with the bench name
}

BlueprintOptions = {
    item = 'blueprint',
    format = '%s_blueprint' -- Format for blueprint items: %s will be replaced with the item name
}

CanUseBench = function(ped) -- Check if the player can use the bench
    return (
        not IsPedDeadOrDying(ped, true) and
        not IsPedInAnyVehicle(ped, false) and
        not IsPedFalling(ped) and
        not IsPedRagdoll(ped)
    )
end

CustomInteraction = {
    enabled = false,
    onEnter = function(bench, funcs) -- Example for qb-target
        local options = {
            {
                num = 1,
                label = 'Use',
                action = function()
                    funcs.use()
                end
            }
        }

        if bench.isPortable then
            table.insert(options, {
                num = 2,
                label = 'Pick Up',
                action = function()
                    funcs.pickup()
                end
            })
        end

        if bench.object then
            exports['qb-target']:AddTargetEntity(bench.object, {
                options = options,
                distance = 1.5
            })
        else
            exports['qb-target']:AddCircleZone(
                bench.uuid,
                bench.coords.xyz,
                0.5,
                {
                    name = bench.uuid,
                    debugPoly = true
                },
                {
                    options = options,
                    distance = 1.5
                }
            )
        end
    end,
    onExit = function(bench) -- Example for qb-target
        if bench.object then
            exports['qb-target']:RemoveTargetEntity(bench.object)
        else
            exports['qb-target']:RemoveZone(bench.uuid)
        end
    end
}

DisableCameraSway = false        -- Disable the camera sway effect when using a bench
DisableProximityCheck = false    -- Disable the proximity check when interacting with the bench
DebugProximityCheck = false      -- Debug the proximity check
DebugAccess = false              -- Debug the access
DebugInteraction = false         -- Debug the interaction with the DUI
DebugCraftClaim = false          -- Debug the craft claim

BenchProximityDistance = 10.0    -- How close you need to be to see the bench (client side)

PlayerCoordUpdateThreshold = 2   -- How far the player needs to move before sending coordinates to the server (in meters)
PlayerCoordUpdateCooldown = 3000 -- How often to send player coordinates to the server (in milliseconds)
