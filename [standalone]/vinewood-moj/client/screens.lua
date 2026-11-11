-- Courtroom screens: a browser (DUI) running web/screen.html, drawn onto the TV props' render
-- targets. Created only while you're inside a courtroom that has screens, so footage (and its
-- sound) is only seen and heard in that room.
local CR = Config.Courtrooms or {}
if CR.enabled == false then return end

local PAGE = ('https://cfx-nui-%s/web/screen.html'):format(GetCurrentResourceName())
local TXD, TEX            -- texture names for the current browser instance
local serial = 0

local playing = {}      -- [roomId] = what's showing (from the server)
local dui
local curRoom, curKey
local targets = {}      -- [targetName] = render target id

local function send(msg) if dui then SendDuiMessage(dui, json.encode(msg)) end end

local function ensureDui()
    if dui then return end
    local res = CR.ScreenResolution or { 1280, 720 }
    dui = CreateDui(PAGE, res[1], res[2])
    local t = GetGameTimer() + 5000
    while not IsDuiAvailable(dui) and GetGameTimer() < t do Wait(50) end
    -- A new name each time: a runtime texture stays bound to the browser it was made from.
    serial = serial + 1
    TXD, TEX = ('vwmoj_scr_txd_%d'):format(serial), ('vwmoj_scr_tex_%d'):format(serial)
    CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd(TXD), TEX, GetDuiHandle(dui))
    Wait(600) -- let the page finish loading before the first message
end

local function destroyDui()
    if dui then DestroyDui(dui) end
    dui, curKey = nil, nil
end

local linked = {}   -- [modelHash] = true once linked

--- model: a model name, or a hash (a TV picked from the MLO). Several models can share one target.
local function renderTarget(name, model)
    local hash = type(model) == 'number' and model or joaat(model)
    if not targets[name] then
        if not IsNamedRendertargetRegistered(name) then RegisterNamedRendertarget(name, false) end
        targets[name] = GetNamedRendertargetRenderId(name)
    end
    if not linked[hash] then
        if not IsNamedRendertargetLinked(hash) then LinkNamedRendertarget(hash) end
        linked[hash] = true
    end
    return targets[name]
end

--- The render target and model of a screen point, placed or picked from the map.
local function screenOf(s)
    if s.mode == 'pick' and s.mapModel then
        local m = s.model and (CR.ScreenModels or {})[s.model]
        return s.target or (m and m.target) or 'tvscreen', s.mapModel
    end
    local m = (CR.ScreenModels or {})[s.model or 1]
    if m then return m.target, m.model end
end

local function releaseTargets()
    for name in pairs(targets) do
        if IsNamedRendertargetRegistered(name) then ReleaseNamedRendertarget(name) end
    end
    targets, linked = {}, {}
end

--- The courtroom with screens you're standing in, and its screen points.
local function roomHere()
    local here = GetEntityCoords(PlayerPedId())
    for _, r in ipairs(MoJRooms and MoJRooms() or {}) do
        local c = r.centre
        if c and c.x and #(here - vec3(c.x, c.y, c.z)) <= (r.radius or 20.0) + 3.0 then
            local screens = {}
            for _, p in ipairs(r.points or {}) do if p.kind == 'screen' then screens[#screens + 1] = p end end
            if #screens > 0 then return r, screens end
        end
    end
end

local function stateKey(roomId)
    local p = playing[roomId] or playing[tostring(roomId)]
    return p and (roomId .. ':' .. p.startedAt .. ':' .. p.src) or (roomId .. ':slate'), p
end

RegisterNetEvent('vinewood-moj:client:screens', function(list) playing = list or {} end)
CreateThread(function()
    Wait(2500)
    playing = lib.callback.await('vinewood-moj:server:screens', false) or {}
end)

-- Room changes, what's playing, and volume.
CreateThread(function()
    while true do
        local r, screens = roomHere()
        if r then
            ensureDui()
            if curRoom ~= r.id then
                curRoom, curKey = r.id, nil
                releaseTargets()
            end
            local k, p = stateKey(r.id)
            if k ~= curKey then
                curKey = k
                if p then
                    send({ action = 'play', kind = p.kind, src = p.src, label = p.label, control = p.control, fallback = p.fallback,
                        offset = p.offset or 0, elapsed = math.max(0, GetCloudTimeAsInt() - p.startedAt) })
                else
                    send({ action = 'slate', room = r.label, court = Config.CourtsName })
                end
            end
            -- Volume falls off with distance from the nearest screen (direct files and YouTube).
            if p and (p.kind == 'file' or p.control) then
                local here, best = GetEntityCoords(PlayerPedId()), 1e9
                for _, s in ipairs(screens) do best = math.min(best, #(here - vec3(s.x, s.y, s.z))) end
                local falloff = math.max(4.0, r.radius or 20.0)
                send({ action = 'volume', v = (CR.ScreenVolume or 0.8) * math.max(0.15, 1.0 - best / falloff) })
            end
            Wait(500)
        else
            if dui then destroyDui() releaseTargets() end
            curRoom = nil
            Wait(1000)
        end
    end
end)

-- Draw the browser onto every screen model used in the room, every frame.
CreateThread(function()
    while true do
        if dui and curRoom and TXD then
            local r, screens = roomHere()
            if r then
                local done = {}
                for _, s in ipairs(screens) do
                    local target, model = screenOf(s)
                    if target and not done[target] then
                        done[target] = true
                        local id = renderTarget(target, model)
                        -- Link every other model in the room that uses this target too.
                        for _, o in ipairs(screens) do
                            local t2, m2 = screenOf(o)
                            if t2 == target and m2 ~= model then renderTarget(t2, m2) end
                        end
                        SetTextRenderId(id)
                        SetScriptGfxDrawOrder(4)
                        SetScriptGfxDrawBehindPausemenu(true)
                        DrawSprite(TXD, TEX, 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                        SetTextRenderId(GetDefaultScriptRendertargetRenderId())
                    end
                end
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    destroyDui()
    releaseTargets()
end)
