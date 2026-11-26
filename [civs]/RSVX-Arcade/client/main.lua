local Machines = {}
local Spawned  = {}
local myCid, admin
local playing

local function notify(msg, kind)
    lib.notify({ title = 'Arcade', description = msg, type = kind or 'inform' })
end

local function closeUi(silent)
    if not playing then return end
    playing = nil
    SetNuiFocus(false, false)
    if not silent then SendNUIMessage({ action = 'close' }) end
    ClearPedTasks(cache.ped)
    TriggerServerEvent('rsvx_arcade:leave')
end

function ArcadeModel(cfg)
    if cfg.physical and IsModelValid(cfg.physical) then return cfg.physical, true end
    return cfg.model, false
end

local Displays  = {}
local BoardRows = {}

local function play(m)
    if playing or Config.Machines[m.game].display then return end
    if Physical.has(m.id) then return Physical.play(m, Config.Machines[m.game]) end
    local res, err = lib.callback.await('rsvx_arcade:play', false, m.id)
    if not res then return notify(err, 'error') end

    playing = m.id
    local ped, ent = cache.ped, Spawned[m.id]
    if ent then
        TaskTurnPedToFaceEntity(ped, ent, 600)
        Wait(600)
    end
    if lib.requestAnimDict(Config.Anim.dict, 3000) then
        TaskPlayAnim(ped, Config.Anim.dict, Config.Anim.clip, 4.0, 4.0, -1, 49, 0.0, false, false, false)
    end

    SetNuiFocus(true, false)
    SendNUIMessage({
        action = 'open',
        game = res.game,
        label = res.label,
        price = res.price,
        currency = Config.Currency,
        board = res.board,
        tune = res.game == 'strength' and Config.Strength or nil,
    })
end

local function pickup(m)
    local ok, info = lib.callback.await('rsvx_arcade:pickup', false, m.id)
    if not ok then return notify(info, 'error') end
    if m.permanent then
        notify('Permanent machine removed.', 'success')
    elseif info > 0 then
        notify(('Machine packed away. You emptied %s%d from the coin box.'):format(Config.Currency, info), 'success')
    else
        notify('Machine packed away.', 'success')
    end
end

local function collect(m)
    local amount, err = lib.callback.await('rsvx_arcade:collect', false, m.id)
    if not amount then return notify(err, 'error') end
    notify(('You emptied %s%d from the coin box.'):format(Config.Currency, amount), 'success')
end

local function despawn(id)
    local ent = Spawned[id]
    if not ent then return end
    Spawned[id] = nil
    Displays[id] = nil
    ArcadeOwned[ent] = nil
    Physical.detach(id)
    if DoesEntityExist(ent) then DeleteEntity(ent) end
    pcall(function() exports.ox_target:removeLocalEntity(ent) end)
end

local function spawn(m)
    local cfg = Config.Machines[m.game]
    if not cfg then return end
    local model, physical = ArcadeModel(cfg)
    if not IsModelValid(model) then return end
    lib.requestModel(model, 5000)

    ArcadeSweep(cfg.model, m.x, m.y, m.z, 0.6)
    if cfg.physical then ArcadeSweep(cfg.physical, m.x, m.y, m.z, 0.6) end

    local ent = CreateObjectNoOffset(model, m.x, m.y, m.z, false, false, false)
    ArcadeOwned[ent] = true
    SetEntityHeading(ent, m.h)
    FreezeEntityPosition(ent, true)
    SetEntityInvincible(ent, true)
    SetModelAsNoLongerNeeded(model)
    Spawned[m.id] = ent
    if physical then Physical.attach(m, ent) end
    if cfg.display then
        Displays[m.id] = { ent = ent, game = cfg.display, custom = physical }
        if not BoardRows[cfg.display] then
            CreateThread(function()
                BoardRows[cfg.display] = lib.callback.await('rsvx_arcade:board', false, cfg.display) or {}
                if BoardDui and BoardDui[cfg.display] then BoardDui[cfg.display].sent = 0 end
            end)
        end
    end

    local mine = function() return not m.static and m.owner == myCid end
    exports.ox_target:addLocalEntity(ent, {
        {
            name = 'rsvx_arcade_play',
            icon = 'fa-solid fa-gamepad',
            label = cfg.price > 0 and ('Play %s (%s%d)'):format(cfg.label, Config.Currency, cfg.price) or ('Play ' .. cfg.label),
            distance = 2.0,
            canInteract = function() return not cfg.display end,
            onSelect = function() play(m) end,
        },
        {
            name = 'rsvx_arcade_collect',
            icon = 'fa-solid fa-coins',
            label = 'Empty coin box',
            distance = 2.0,
            canInteract = mine,
            onSelect = function() collect(m) end,
        },
        {
            name = 'rsvx_arcade_pickup',
            icon = 'fa-solid fa-box',
            label = 'Pack machine away',
            distance = 2.0,
            canInteract = function() return not m.static and (m.owner == myCid or admin) end,
            onSelect = function() pickup(m) end,
        },
        {
            name = 'rsvx_arcade_remove',
            icon = 'fa-solid fa-trash',
            label = 'Remove permanent machine',
            distance = 2.0,
            canInteract = function() return m.permanent and admin end,
            onSelect = function() pickup(m) end,
        },
    })
end

local function load()
    local list, cid, isAdmin, serverVersion = lib.callback.await('rsvx_arcade:init', false)
    local mine = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    if serverVersion ~= mine then
        print(('[RSVX_Arcade] ^1server script is v%s but the client is v%s. Stop and start the resource (or restart the server) so both halves match.^7')
            :format(serverVersion or 'older than 1.4.0', mine or '?'))
        if isAdmin then notify('Arcade server script is out of date. Stop and start RSVX_Arcade.', 'error') end
    end
    for id in pairs(Spawned) do despawn(id) end
    Machines = {}
    for _, m in ipairs(list or {}) do Machines[m.id] = m end
    myCid, admin = cid, isAdmin
end

RegisterNetEvent('rsvx_arcade:add', function(m)
    Machines[m.id] = m
end)

RegisterNetEvent('rsvx_arcade:prize', function(id, spot, prize)
    local m = Machines[id]
    if not m or not m.prizes then return end
    m.prizes[spot] = prize
    Physical.restock(id)
end)

RegisterNetEvent('rsvx_arcade:remove', function(id)
    if playing == id then closeUi() end
    Machines[id] = nil
    despawn(id)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', load)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    closeUi()
    myCid, admin = nil, nil
end)

CreateThread(function()
    print(('[RSVX_Arcade] client v%s'):format(GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or '?'))
    if LocalPlayer.state.isLoggedIn then load() end
    while true do
        local pos = GetEntityCoords(cache.ped)
        for id, m in pairs(Machines) do
            local close = #(pos - vec3(m.x, m.y, m.z)) < Config.RenderDistance
            if close and not Spawned[id] then
                spawn(m)
            elseif not close and Spawned[id] then
                despawn(id)
            end
        end
        Wait(1000)
    end
end)

local BoardDui = {}
local BOARD_TXD
local DRAW_TEXTURED_POLY = 0x29280002282F1928

local function bellPrize(game)
    local best
    for _, r in ipairs(Config.Machines[game].rewards or {}) do
        if r.money and (not best or r.min > best.min) then best = r end
    end
    return best
end

local function boardPayload(game)
    local prize = bellPrize(game)
    return json.encode({
        rows = BoardRows[game] or {},
        footer = prize and ('Ring the bell and win %s%d'):format(Config.Currency, prize.money) or '',
    })
end

local function boardDui(game)
    local b = BoardDui[game]
    if not b then
        BOARD_TXD = BOARD_TXD or CreateRuntimeTxd('rsvx_arcade_board')
        local dui = CreateDui(('nui://%s/web/board.html'):format(GetCurrentResourceName()), 512, 648)
        CreateRuntimeTextureFromDuiHandle(BOARD_TXD, game, GetDuiHandle(dui))
        b = { dui = dui, sent = 0 }
        BoardDui[game] = b
    end
    if IsDuiAvailable(b.dui) and b.sent < 4 and GetGameTimer() > (b.next or 0) then
        SendDuiMessage(b.dui, boardPayload(game))
        b.sent += 1
        b.next = GetGameTimer() + 700
    end
    return b
end

RegisterNetEvent('rsvx_arcade:board', function(game, rows)
    BoardRows[game] = rows
    if BoardDui[game] then BoardDui[game].sent = 0 end
end)

local function tri(a, b, c, game, ua, va, ub, vb, uc, vc)
    Citizen.InvokeNative(DRAW_TEXTURED_POLY, a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z, 255, 255, 255, 255,
        'rsvx_arcade_board', game, ua, va, 1.0, ub, vb, 1.0, uc, vc, 1.0)
end

CreateThread(function()
    while true do
        local wait = 500
        if next(Displays) then
            local cam = GetFinalRenderedCamCoord()
            for _, d in pairs(Displays) do
                if DoesEntityExist(d.ent) and #(cam - GetEntityCoords(d.ent)) < 25.0 then
                    wait = 0
                    boardDui(d.game)
                    local y, lo, hi = d.custom and -0.039 or -0.1, d.custom and 0.57 or 0.8, d.custom and 1.71 or 1.94
                    local tl = GetOffsetFromEntityInWorldCoords(d.ent, -0.45, y, hi)
                    local tr = GetOffsetFromEntityInWorldCoords(d.ent, 0.45, y, hi)
                    local bl = GetOffsetFromEntityInWorldCoords(d.ent, -0.45, y, lo)
                    local br = GetOffsetFromEntityInWorldCoords(d.ent, 0.45, y, lo)
                    tri(tl, bl, br, d.game, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0)
                    tri(tl, br, tr, d.game, 0.0, 0.0, 1.0, 1.0, 1.0, 0.0)
                    tri(br, bl, tl, d.game, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0)
                    tri(tr, br, tl, d.game, 1.0, 0.0, 1.0, 1.0, 0.0, 0.0)
                end
            end
        end
        Wait(wait)
    end
end)

RegisterNUICallback('gameOver', function(data, cb)
    cb(lib.callback.await('rsvx_arcade:submit', false, tonumber(data.score) or 0) or { rejected = true })
end)

RegisterNUICallback('retry', function(_, cb)
    if not playing then return cb({ ok = false }) end
    local res, err = lib.callback.await('rsvx_arcade:play', false, playing)
    if not res then
        notify(err, 'error')
        return cb({ ok = false, error = err })
    end
    cb({ ok = true, board = res.board })
end)

RegisterNUICallback('close', function(_, cb)
    closeUi(true)
    cb(1)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, bd in pairs(BoardDui) do DestroyDui(bd.dui) end
    closeUi()
    for id in pairs(Spawned) do despawn(id) end
end)
