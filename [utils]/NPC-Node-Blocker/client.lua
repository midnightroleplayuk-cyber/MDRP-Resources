local zones = {}
local applied = {}
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

local function fillRects(z)
    local minx, miny, maxx, maxy = math.huge, math.huge, -math.huge, -math.huge
    for _, p in ipairs(z.points) do
        minx, maxx = math.min(minx, p.x), math.max(maxx, p.x)
        miny, maxy = math.min(miny, p.y), math.max(maxy, p.y)
    end

    local cell = Config.CellSize
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
        if #out <= Config.MaxRects then return out end
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

local function removeZone(id)
    local a = applied[id]
    if not a then return end
    local z = a.zone
    local z2 = z.z + z.height
    for _, r in ipairs(a.rects) do
        if z.blockPeds then SetPedPathsBackToOriginal(r[1], r[2], z.z, r[3], r[4], z2, 0, 0) end
        if z.blockVehicles then SetRoadsBackToOriginal(r[1], r[2], z.z, r[3], r[4], z2, false, false) end
    end
    for _, n in ipairs(a.navs) do RemoveNavmeshBlockingObject(n) end
    for _, s in ipairs(a.scens) do RemoveScenarioBlockingArea(s, false) end
    applied[id] = nil
end

local function applyZone(z)
    local a = { zone = z, rects = fillRects(z), navs = {}, scens = {} }
    local h = z.height
    local z2 = z.z + h

    for _, r in ipairs(a.rects) do
        local x1, y1, x2, y2 = r[1], r[2], r[3], r[4]
        if z.blockPeds then
            SetPedPathsInArea(x1, y1, z.z, x2, y2, z2, false, 0)
            a.navs[#a.navs + 1] = AddNavmeshBlockingObject(
                (x1 + x2) / 2, (y1 + y2) / 2, z.z + h / 2,
                x2 - x1, y2 - y1, h, 0.0, false, 7
            )
        end
        if z.blockScenarios then
            a.scens[#a.scens + 1] = AddScenarioBlockingArea(x1, y1, z.z, x2, y2, z2, false, true, true, true)
        end
        if z.blockVehicles then
            SetRoadsInArea(x1, y1, z.z, x2, y2, z2, false, false)
        end
    end

    applied[z.id] = a
end

local function removeAll()
    local ids = {}
    for id in pairs(applied) do ids[#ids + 1] = id end
    for _, id in ipairs(ids) do removeZone(id) end
end

local function applyAll()
    removeAll()
    for _, z in ipairs(zones) do applyZone(z) end
end

RegisterNetEvent('npcblocker:setZones', function(list)
    zones = list or {}
    applyAll()
    if uiOpen then
        SendNUIMessage({ action = 'zones', zones = zones })
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

CreateThread(function()
    TriggerServerEvent('npcblocker:requestZones')
    while true do
        Wait(Config.ReapplyInterval)
        applyAll()
    end
end)

CreateThread(function()
    while true do
        Wait(Config.ClearInterval)

        for _, z in ipairs(zones) do
            if z.clearPeds then
                for _, ped in ipairs(GetGamePool('CPed')) do
                    if not IsPedAPlayer(ped)
                        and not IsPedInAnyVehicle(ped, false)
                        and not IsEntityAMissionEntity(ped)
                        and inside(z, GetEntityCoords(ped))
                        and NetworkHasControlOfEntity(ped) then
                        DeleteEntity(ped)
                    end
                end
            end
            if z.clearVehicles then
                for _, veh in ipairs(GetGamePool('CVehicle')) do
                    if not IsEntityAMissionEntity(veh)
                        and inside(z, GetEntityCoords(veh))
                        and NetworkHasControlOfEntity(veh) then
                        local occupied = false
                        for seat = -1, GetVehicleModelNumberOfSeats(GetEntityModel(veh)) - 2 do
                            local p = GetPedInVehicleSeat(veh, seat)
                            if p ~= 0 and IsPedAPlayer(p) then occupied = true break end
                        end
                        if not occupied then DeleteEntity(veh) end
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        if uiOpen or debugDraw then
            Wait(0)
            for _, z in ipairs(zones) do
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

RegisterNetEvent('npcblocker:openUI', function(list)
    zones = list or zones
    uiOpen = true
    walkMode = false
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', zones = zones })
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
    for _, z in ipairs(zones) do
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
