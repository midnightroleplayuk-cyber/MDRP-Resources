-- RSVX bowling alley (v0.6). The building, its props and the doors are placed by stream/rsvx_bowling.ymap;
-- the old club, its junk, the poles/bushes on the car park and the grass there are removed by the edited
-- vanilla cs4_04 / cs4_roads ymaps in stream/. Nothing needs spawning from script any more.

-- the power lines over the site are hidden in the map data only: the edited cs4_roads ymaps swap them to
-- rsvx_empty at their spans over the site only (no script, no global model override)

-- /bowling teleports you to the car park aisle, facing the building
RegisterCommand('bowling', function()
    local ped = PlayerPedId()
    SetEntityCoords(ped, 1471.89, 3740.41, 34.0, false, false, false, false)
    SetEntityHeading(ped, 305.1)
end, false)

-- sitting on the modelled lane sofas and lounge booths (BowlingSeats, generated into seats.lua):
-- walk up to a seat and press E to sit, E again to stand up
local SIT_SCENARIO = 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER'
local SIT_RANGE = 1.2
local seated = nil

local function help(text)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

local function seatTaken(seat, me)
    for _, p in ipairs(GetGamePool('CPed')) do
        if p ~= me and #(GetEntityCoords(p) - seat.xyz) < 0.45 then
            return true
        end
    end
    return false
end

CreateThread(function()
    while true do
        local wait = 750
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        if seated then
            wait = 0
            help('Press ~INPUT_CONTEXT~ to stand up')
            if IsControlJustReleased(0, 38) or #(pos - seated.xyz) > 1.5 then
                ClearPedTasks(ped)
                seated = nil
            end
        elseif not IsPedInAnyVehicle(ped, false) then
            local best, bestDist = nil, SIT_RANGE
            for _, seat in ipairs(BowlingSeats) do
                local d = #(pos - seat.xyz)
                if d < bestDist then
                    best, bestDist = seat, d
                end
            end
            if best then
                wait = 0
                help('Press ~INPUT_CONTEXT~ to sit')
                if IsControlJustReleased(0, 38) and not seatTaken(best, ped) then
                    TaskStartScenarioAtPosition(ped, SIT_SCENARIO, best.x, best.y, best.z, best.w, 0, true, true)
                    seated = best
                end
            elseif #(pos - BowlingSeats[1].xyz) > 60.0 then
                wait = 2000   -- nowhere near the bowling alley
            end
        end
        Wait(wait)
    end
end)

-- v0.7.14: keep ambient (random) peds out of the building. The vanilla navmesh still has 330 walkable polys of the old
-- boat club under our footprint, so wandering peds spawned and walked "inside" as outside entities and flickered when
-- seen from the interior. A navmesh tile can't be rebuilt safely from our tools, so this blocks ONLY the building
-- footprint (66 x 44 m incl. 2 m margin, turned with the building): no new ambient peds path or spawn there and no
-- scenarios run in it. Players and script-spawned peds are not affected. Nothing map-wide.
local BLOCK = { x = 1542.21, y = 3796.88, z = 38.0, w = 66.0, l = 44.0, h = 14.0, heading = 0.6127851 }
local navBlock, scenBlock
CreateThread(function()
    navBlock = AddNavmeshBlockingObject(BLOCK.x, BLOCK.y, BLOCK.z, BLOCK.w, BLOCK.l, BLOCK.h, BLOCK.heading, false, 7)
    scenBlock = AddScenarioBlockingArea(1502.8, 3760.3, 28.0, 1581.6, 3833.4, 48.0, false, true, true, true)
end)
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if navBlock then RemoveNavmeshBlockingObject(navBlock) end
    if scenBlock then RemoveScenarioBlockingArea(scenBlock, false) end
end)

-- other resources (a server sit script, target menus) can read the same points
exports('GetSeats', function()
    return BowlingSeats
end)
