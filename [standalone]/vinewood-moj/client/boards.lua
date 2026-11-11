-- Listing boards: the day's court list on TVs in hallways and foyers.
-- Each nearby board gets its own browser (web/board.html), fed by the server every 20 seconds.
local CR = Config.Courtrooms or {}
if CR.enabled == false then return end

local PAGE = ('https://cfx-nui-%s/web/board.html'):format(GetCurrentResourceName())
local NEAR, FAR, MAX = 22.0, 32.0, 3       -- start showing / stop showing / most boards at once
local boards = {}
local live = {}       -- [boardId] = { dui, txd, tex, nextFeed }
local props = {}
local serial = 0

local function clearProps()
    for _, e in ipairs(props) do if DoesEntityExist(e) then DeleteEntity(e) end end
    props = {}
end

local function buildProps()
    clearProps()
    for _, b in ipairs(boards) do
        local p = b.point
        if p and p.mode == 'spawn' then
            local m = (CR.ScreenModels or {})[p.model or 1]
            local hash = m and joaat(m.model)
            if hash and IsModelInCdimage(hash) then
                RequestModel(hash)
                local t = GetGameTimer() + 3000
                while not HasModelLoaded(hash) and GetGameTimer() < t do Wait(10) end
                local e = CreateObjectNoOffset(hash, p.x, p.y, p.z, false, false, false)
                SetEntityHeading(e, p.h or 0.0)
                FreezeEntityPosition(e, true)
                SetEntityInvincible(e, true)
                SetModelAsNoLongerNeeded(hash)
                props[#props + 1] = e
            end
        end
    end
end

local function stop(id)
    local l = live[id]
    if l and l.dui then DestroyDui(l.dui) end
    live[id] = nil
end

local function start(b)
    local res = CR.ScreenResolution or { 1280, 720 }
    local dui = CreateDui(PAGE, res[1], res[2])
    local t = GetGameTimer() + 5000
    while not IsDuiAvailable(dui) and GetGameTimer() < t do Wait(50) end
    serial = serial + 1
    local txd, tex = ('vwmoj_brd_txd_%d'):format(serial), ('vwmoj_brd_tex_%d'):format(serial)
    CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd(txd), tex, GetDuiHandle(dui))
    live[b.id] = { dui = dui, txd = txd, tex = tex, nextFeed = 0 }
end

-- A room or court was renamed: fetch fresh lists for the boards in view straight away.
RegisterNetEvent('vinewood-moj:client:boardsRefresh', function()
    for _, l in pairs(live) do l.nextFeed = 0 end
end)

RegisterNetEvent('vinewood-moj:client:boards', function(list)
    boards = list or {}
    for id in pairs(live) do stop(id) end
    buildProps()
end)

CreateThread(function()
    Wait(3000)
    boards = lib.callback.await('vinewood-moj:server:boards', false) or {}
    buildProps()
end)

-- Which boards are close enough to show, and keeping their lists fresh.
CreateThread(function()
    while true do
        local here = GetEntityCoords(PlayerPedId())
        local near = {}
        for _, b in ipairs(boards) do
            local p = b.point
            if p and p.x then
                local d = #(here - vec3(p.x, p.y, p.z))
                if live[b.id] and d > FAR then stop(b.id)
                elseif d <= NEAR then near[#near + 1] = { b = b, d = d } end
            end
        end
        table.sort(near, function(a, c) return a.d < c.d end)
        for i, n in ipairs(near) do
            if i <= MAX and not live[n.b.id] then start(n.b) end
        end
        local now = GetGameTimer()
        for _, n in ipairs(near) do
            local l = live[n.b.id]
            if l and now >= l.nextFeed then
                l.nextFeed = now + 20000
                local feed = lib.callback.await('vinewood-moj:server:boardFeed', false, n.b.id)
                if feed and live[n.b.id] then
                    feed.action = 'feed'
                    feed.serverOffset = feed.now - GetCloudTimeAsInt()
                    SendDuiMessage(l.dui, json.encode(feed))
                end
            end
        end
        Wait(next(live) and 1000 or 2500)
    end
end)

-- Draw every frame.
CreateThread(function()
    while true do
        if next(live) and MoJScreens then
            for _, b in ipairs(boards) do
                local l = live[b.id]
                if l and b.point then
                    local g = MoJScreens.GeoOf(b.point)
                    if g then MoJScreens.DrawPanel(b.point, g, l.txd, l.tex) end
                end
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

---------------------------------------------------------------------------
-- Placing boards (admins, from /courtrooms)
---------------------------------------------------------------------------
RegisterNUICallback('boardPlace', function(d, cb)
    cb('ok')
    MoJUI.Suspend()
    CreateThread(function()
        local mode = d.mode == 'pick' and 'pick' or 'spawn'
        local at
        if mode == 'pick' then at = MoJPlace.pick('screen') else at = MoJPlace.place('screen', true, tonumber(d.model)) end
        if at then
            local point = { kind = 'screen', mode = mode, model = tonumber(d.model) }
            for k, v in pairs(at) do point[k] = v end
            local m = (CR.ScreenModels or {})[point.model or 1]
            point.geo = MoJScreens.Adjust(point, mode == 'spawn' and m and m.model or nil, d.label, true)
            local r = lib.callback.await('vinewood-moj:server:roomsAdmin', false, 'boardAdd', { label = d.label, courts = d.courts, names = d.names, point = point })
            if r and r.error then lib.notify({ title = 'Listing board', description = r.error, type = 'error' })
            else lib.notify({ title = 'Listing board', description = 'Placed.', type = 'success' }) end
        end
        Wait(150)
        MoJUI.Open('rooms', nil, {})
    end)
end)

RegisterNUICallback('boardAdjust', function(d, cb)
    cb('ok')
    local board
    for _, b in ipairs(boards) do if b.id == tonumber(d.boardId) then board = b end end
    if not board then return end
    MoJUI.Suspend()
    CreateThread(function()
        local copy = {}
        for k, v in pairs(board.point) do copy[k] = v end
        stop(board.id)
        local geo = MoJScreens.Adjust(copy, nil, board.label, true)
        if geo then lib.callback.await('vinewood-moj:server:roomsAdmin', false, 'boardUpdate', { boardId = board.id, geo = geo }) end
        Wait(150)
        MoJUI.Open('rooms', nil, {})
    end)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id in pairs(live) do stop(id) end
    clearProps()
end)
