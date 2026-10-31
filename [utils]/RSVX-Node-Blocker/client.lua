local zones = {}   -- every zone the server sent, near or far
local saved = {}
local meta = {}    -- zone id -> { sig, cx, cy, r, rects, roadRects }; rects are built once, on first apply
local applied = {} -- zone id -> what is live on this client right now
local usedPed, usedRoad = 0, 0
local warned = {}
local uiOpen = false
local walkMode = false
local debugDraw = false
local draft = nil

local function inPoly(pts, x, y)
    local isIn = false
    local j = #pts
    for i = 1, #pts do
        local a, b = pts[i], pts[j]
        if (a.y > y) ~= (b.y > y) and x < (b.x - a.x) * (y - a.y) / (b.y - a.y) + a.x then
            isIn = not isIn
        end
        j = i
    end
    return isIn
end

local function inside(z, c)
    return inPoly(z.points, c.x, c.y) and c.z >= z.z - 1.0 and c.z <= z.z + z.height
end

local function fillRects(z, maxRects)
    maxRects = math.max(1, maxRects)
    local minx, miny, maxx, maxy = math.huge, math.huge, -math.huge, -math.huge
    for _, p in ipairs(z.points) do
        minx, maxx = math.min(minx, p.x), math.max(maxx, p.x)
        miny, maxy = math.min(miny, p.y), math.max(maxy, p.y)
    end

    local cell = math.max(Config.CellSize, math.max(maxx - minx, maxy - miny) / (Config.MaxGrid or 100))
    while true do
        local out = {}
        local y = miny
        while y < maxy do
            local run
            local x = minx
            while x < maxx do
                if inPoly(z.points, x + cell / 2, y + cell / 2) then
                    if run then run[3] = x + cell else run = { x, y, x + cell, y + cell } end
                elseif run then
                    out[#out + 1] = run
                    run = nil
                end
                x = x + cell
            end
            if run then out[#out + 1] = run end
            y = y + cell
        end
        if #out == 0 then out[1] = { minx, miny, maxx, maxy } end
        if #out <= maxRects then return out end
        cell = cell * 1.5
    end
end

local function drawZone(z, r, g, b)
    local pts, n = z.points, #z.points
    local top = z.z + z.height
    for i = 1, n do
        local p = pts[i]
        DrawMarker(28, p.x, p.y, z.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, r, g, b, 200,
            false, false, 2, false, nil, nil, false)
        DrawLine(p.x, p.y, z.z, p.x, p.y, top, r, g, b, 255)
        local q = pts[i + 1] or (n >= 3 and pts[1])
        if q then
            DrawLine(p.x, p.y, z.z, q.x, q.y, z.z, r, g, b, 255)
            DrawLine(p.x, p.y, top, q.x, q.y, top, r, g, b, 255)
        end
    end
end

local function sig(z)
    local s = ('%s|%s|%s|%s|%s'):format(z.z, z.height, z.blockPeds, z.blockScenarios, z.blockVehicles)
    for _, p in ipairs(z.points) do s = s .. ('|%s,%s'):format(p.x, p.y) end
    return s
end

-- centre + radius of the pins, so the distance gate is a couple of multiplications instead of a polygon test
local function describe(z)
    local minx, miny, maxx, maxy = math.huge, math.huge, -math.huge, -math.huge
    for _, p in ipairs(z.points) do
        minx, maxx = math.min(minx, p.x), math.max(maxx, p.x)
        miny, maxy = math.min(miny, p.y), math.max(maxy, p.y)
    end
    local cx, cy = (minx + maxx) / 2, (miny + maxy) / 2
    local r = 0.0
    for _, p in ipairs(z.points) do
        local dx, dy = p.x - cx, p.y - cy
        r = math.max(r, math.sqrt(dx * dx + dy * dy))
    end
    return { sig = sig(z), cx = cx, cy = cy, r = r }
end

local function edgeDist(m, p)
    local dx, dy = p.x - m.cx, p.y - m.cy
    return math.sqrt(dx * dx + dy * dy) - m.r
end

local function removeZone(id)
    local a = applied[id]
    if not a then return end
    -- everything is undone with the exact numbers it was applied with, otherwise the slot leaks
    for _, r in ipairs(a.rects) do
        if a.blockPeds then SetPedPathsBackToOriginal(r[1], r[2], a.z1, r[3], r[4], a.z2, 0, 0) end
    end
    for _, r in ipairs(a.roadRects) do
        SetRoadsBackToOriginal(r[1], r[2], a.z1, r[3], r[4], a.z2, false, false)
    end
    for _, n in ipairs(a.navs) do RemoveNavmeshBlockingObject(n) end
    for _, s in ipairs(a.scens) do RemoveScenarioBlockingArea(s, false) end
    usedPed = usedPed - a.pedCost
    usedRoad = usedRoad - a.roadCost
    applied[id] = nil
end

local function applyZone(z, m)
    local wantPed = z.blockPeds or z.blockScenarios
    local wantRoad = z.blockVehicles and Config.RoadNodes

    m.rects = m.rects or (wantPed and fillRects(z, Config.MaxRects)) or {}
    m.roadRects = m.roadRects or (wantRoad and fillRects(z, Config.MaxRoadRects)) or {}

    local pedCost, roadCost = #m.rects, #m.roadRects
    if usedPed + pedCost > Config.MaxActivePedRects or usedRoad + roadCost > Config.MaxActiveRoadRects then
        -- over budget: skip it, a nearer zone got the slots. It is retried every gate pass.
        if not warned[z.id] then
            warned[z.id] = true
            print(('^3[%s] zone %s "%s" not applied, area budget is full (%d/%d ped, %d/%d road)^7'):format(
                GetCurrentResourceName(), tostring(z.id), tostring(z.name), usedPed, Config.MaxActivePedRects,
                usedRoad, Config.MaxActiveRoadRects))
        end
        return false
    end
    warned[z.id] = nil

    local z1 = z.z
    local h = z.height
    local z2 = z1 + h
    local a = {
        sig = m.sig, z1 = z1, z2 = z2, blockPeds = z.blockPeds,
        rects = m.rects, roadRects = m.roadRects, navs = {}, scens = {},
        pedCost = pedCost, roadCost = roadCost,
    }

    for _, r in ipairs(m.rects) do
        local x1, y1, x2, y2 = r[1], r[2], r[3], r[4]
        if z.blockPeds then
            SetPedPathsInArea(x1, y1, z1, x2, y2, z2, false, 0)
            a.navs[#a.navs + 1] = AddNavmeshBlockingObject(
                (x1 + x2) / 2, (y1 + y2) / 2, z1 + h / 2,
                x2 - x1, y2 - y1, h, 0.0, false, 7
            )
        end
        if z.blockScenarios then
            a.scens[#a.scens + 1] = AddScenarioBlockingArea(x1, y1, z1, x2, y2, z2, false, true, true, true)
        end
    end

    for _, r in ipairs(m.roadRects) do
        SetRoadsInArea(r[1], r[2], z1, r[3], r[4], z2, false, false)
    end

    usedPed = usedPed + pedCost
    usedRoad = usedRoad + roadCost
    applied[z.id] = a
    return true
end

local function removeAll()
    local ids = {}
    for id in pairs(applied) do ids[#ids + 1] = id end
    for _, id in ipairs(ids) do removeZone(id) end
end

-- Takes the new zone list but applies nothing: the gate loop does that, only near the player.
-- Unchanged zones keep what they have (and their cached rects); edited or deleted ones are removed.
local function setZones(list)
    zones = list or {}
    local old = meta
    meta = {}
    for _, z in ipairs(zones) do
        local m = describe(z)
        local o = old[z.id]
        meta[z.id] = (o and o.sig == m.sig) and o or m
    end
    for id, a in pairs(applied) do
        if not meta[id] or meta[id].sig ~= a.sig then removeZone(id) end
    end
end

RegisterNetEvent('npcblocker:setZones', function(list)
    setZones(list)
    saved = zones
    if uiOpen then
        SendNUIMessage({ action = 'zones', zones = saved })
    end
end)

RegisterNetEvent('npcblocker:zoneList', function(list)
    saved = list or {}
    if uiOpen then
        SendNUIMessage({ action = 'zones', zones = saved })
    end
end)

RegisterNetEvent('npcblocker:notify', function(msg)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        removeAll()
        if uiOpen then SetNuiFocus(false, false) end
    end
end)

-- don't ask for zones (or touch any world state) until this player is fully in the session
CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(250) end
    TriggerServerEvent('npcblocker:requestZones')
end)

-- the distance gate
CreateThread(function()
    while true do
        Wait(Config.GateInterval)
        local p = GetEntityCoords(PlayerPedId())
        local want = {}

        for _, z in ipairs(zones) do
            local m = meta[z.id]
            local d = edgeDist(m, p)
            if applied[z.id] then
                if d > Config.UnloadDistance then removeZone(z.id) end
            elseif d <= Config.LoadDistance then
                want[#want + 1] = { z = z, m = m, d = d }
            end
        end

        -- removals above free budget first, then the nearest zones win whatever is left
        table.sort(want, function(a, b) return a.d < b.d end)
        for _, w in ipairs(want) do
            if meta[w.z.id] == w.m then applyZone(w.z, w.m) end -- skip if the list changed mid-pass
            Wait(50)
        end
    end
end)

local function inAny(list, c)
    for _, z in ipairs(list) do
        if inside(z, c) then return true end
    end
    return false
end

CreateThread(function()
    while true do
        Wait(Config.ClearInterval)

        local p = GetEntityCoords(PlayerPedId())
        local pedZones, vehZones = {}, {}
        for _, z in ipairs(zones) do
            if edgeDist(meta[z.id], p) <= Config.LoadDistance then
                if z.clearPeds then pedZones[#pedZones + 1] = z end
                if z.clearVehicles or (z.blockVehicles and not Config.RoadNodes) then
                    vehZones[#vehZones + 1] = z
                end
            end
        end

        if #pedZones > 0 then
            for _, ped in ipairs(GetGamePool('CPed')) do
                if not IsPedAPlayer(ped)
                    and not IsPedInAnyVehicle(ped, false)
                    and not IsEntityAMissionEntity(ped)
                    and inAny(pedZones, GetEntityCoords(ped))
                    and NetworkHasControlOfEntity(ped) then
                    DeleteEntity(ped)
                end
            end
        end

        if #vehZones > 0 then
            for _, veh in ipairs(GetGamePool('CVehicle')) do
                if not IsEntityAMissionEntity(veh)
                    and inAny(vehZones, GetEntityCoords(veh))
                    and NetworkHasControlOfEntity(veh) then
                    local occupied = false
                    for seat = -1, GetVehicleModelNumberOfSeats(GetEntityModel(veh)) - 2 do
                        local s = GetPedInVehicleSeat(veh, seat)
                        if s ~= 0 and IsPedAPlayer(s) then occupied = true break end
                    end
                    if not occupied then DeleteEntity(veh) end
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        if uiOpen or debugDraw then
            Wait(0)
            for _, z in ipairs(saved) do
                if not (draft and draft.id and draft.id == z.id) then
                    drawZone(z, 255, 60, 60)
                end
            end
            if uiOpen and draft and draft.points then
                drawZone(draft, 60, 255, 100)
            end
        else
            Wait(500)
        end
    end
end)

RegisterCommand(Config.Command, function()
    TriggerServerEvent('npcblocker:requestOpen')
end, false)

RegisterCommand(Config.DebugCommand, function()
    debugDraw = not debugDraw
    TriggerEvent('npcblocker:notify', debugDraw and '~g~Zone outlines on' or '~y~Zone outlines off')
end, false)

RegisterCommand(Config.StatusCommand, function()
    local n = 0
    for _ in pairs(applied) do n = n + 1 end
    TriggerEvent('npcblocker:notify', ('~b~%d/%d zones live, ped areas %d/%d, road areas %d/%d'):format(
        n, #zones, usedPed, Config.MaxActivePedRects, usedRoad, Config.MaxActiveRoadRects))
end, false)

RegisterNetEvent('npcblocker:openUI', function(list)
    saved = list or saved
    uiOpen = true
    walkMode = false
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', zones = saved })
end)

local function closeUI()
    uiOpen = false
    walkMode = false
    draft = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

RegisterNUICallback('close', function(_, cb)
    closeUI()
    cb({})
end)

RegisterNUICallback('preview', function(data, cb)
    draft = data
    cb({})
end)

RegisterNUICallback('save', function(data, cb)
    TriggerServerEvent('npcblocker:saveZone', data)
    cb({})
end)

RegisterNUICallback('delete', function(data, cb)
    TriggerServerEvent('npcblocker:deleteZone', data.id)
    cb({})
end)

RegisterNUICallback('teleport', function(data, cb)
    for _, z in ipairs(saved) do
        if z.id == data.id and z.points[1] then
            SetEntityCoords(PlayerPedId(), z.points[1].x, z.points[1].y, z.z + 1.0, false, false, false, false)
            break
        end
    end
    cb({})
end)

local function crosshairCoords()
    local camPos = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(2)
    local rz, rx = math.rad(rot.z), math.rad(rot.x)
    local dist = 200.0
    local dx = -math.sin(rz) * math.abs(math.cos(rx))
    local dy = math.cos(rz) * math.abs(math.cos(rx))
    local dz = math.sin(rx)

    local ray = StartExpensiveSynchronousShapeTestLosProbe(
        camPos.x, camPos.y, camPos.z,
        camPos.x + dx * dist, camPos.y + dy * dist, camPos.z + dz * dist,
        1 | 16 | 256, PlayerPedId(), 4
    )
    local _, hit, endCoords = GetShapeTestResult(ray)
    if hit == 1 then return endCoords end
    return nil
end

RegisterNUICallback('place', function(data, cb)
    if data.mode == 'crosshair' then
        local c = crosshairCoords()
        if c then
            cb({ ok = true, x = c.x, y = c.y, z = c.z })
        else
            TriggerEvent('npcblocker:notify', '~r~Nothing under the crosshair')
            cb({ ok = false })
        end
    else
        local c = GetEntityCoords(PlayerPedId())
        cb({ ok = true, x = c.x, y = c.y, z = c.z - 1.0 })
    end
end)

RegisterNUICallback('walk', function(_, cb)
    walkMode = true
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hide' })
    cb({})
end)

CreateThread(function()
    while true do
        if walkMode then
            Wait(0)
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName(
                '~INPUT_PICKUP~ pin at feet   ~INPUT_DETONATE~ pin at crosshair~n~' ..
                '~INPUT_FRONTEND_RRIGHT~ undo last pin   ~INPUT_FRONTEND_ACCEPT~ back to menu')
            EndTextCommandDisplayHelp(0, false, false, -1)

            if IsControlJustPressed(0, 38) then
                local c = GetEntityCoords(PlayerPedId())
                SendNUIMessage({ action = 'pin', x = c.x, y = c.y, z = c.z - 1.0 })
            elseif IsControlJustPressed(0, 47) then
                local c = crosshairCoords()
                if c then SendNUIMessage({ action = 'pin', x = c.x, y = c.y, z = c.z }) end
            elseif IsControlJustPressed(0, 177) then
                SendNUIMessage({ action = 'undo' })
            elseif IsControlJustPressed(0, 191) then
                walkMode = false
                SetNuiFocus(true, true)
                SendNUIMessage({ action = 'show' })
            end
        else
            Wait(250)
        end
    end
end)
