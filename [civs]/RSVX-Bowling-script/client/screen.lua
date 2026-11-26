-- In-world displays: overhead scoreboards and control panels. Each one is a
-- small browser surface (DUI) drawn as a flat panel wherever it has been placed.
--
-- Keys: 's<laneId>' for a scoreboard, 'p<laneId>' for a control panel.

Screen = {}

local screens = {}
local counter = 0
local drawing = false

local function send(s)
    if s.payload then SendDuiMessage(s.dui, json.encode(s.payload)) end
end

-- The page is laid out 512 px tall; its width follows the display's shape so
-- a wide one is drawn properly instead of being stretched.
local function resolution(def, mode)
    local w = math.floor(512 * def.width / def.height / 2 + 0.5) * 2
    -- A scoresheet needs 1024 px to fit all ten frames.
    return math.max(mode == 'panel' and 512 or 1024, math.min(2048, w))
end

local function corners(def)
    local h = math.rad(def.heading)
    -- "Right" as seen by someone standing in front of the display.
    local rx, ry = -math.cos(h), -math.sin(h)
    local w, hh = def.width / 2, def.height / 2
    local c = def.coords

    -- Tilt leans the top edge towards the viewer (positive) or away (negative).
    local t = math.rad(def.tilt or 0.0)
    local nx, ny = -math.sin(h), math.cos(h)
    local ux, uy, uz = nx * math.sin(t) * hh, ny * math.sin(t) * hh, math.cos(t) * hh

    return {
        tl = vec3(c.x - rx * w + ux, c.y - ry * w + uy, c.z + uz),
        tr = vec3(c.x + rx * w + ux, c.y + ry * w + uy, c.z + uz),
        bl = vec3(c.x - rx * w - ux, c.y - ry * w - uy, c.z - uz),
        br = vec3(c.x + rx * w - ux, c.y + ry * w - uy, c.z - uz),
    }
end

local function tri(a, b, c, ua, va, ub, vb, uc, vc, txd)
    DrawSpritePoly(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z, 255, 255, 255, 255, txd, 'screen',
        ua, va, 1.0, ub, vb, 1.0, uc, vc, 1.0)
end

local function loop()
    if drawing then return end
    drawing = true
    CreateThread(function()
        while next(screens) do
            for _, s in pairs(screens) do
                local q = s.quad
                -- Both windings, so the panel shows whichever way it ends up facing.
                tri(q.tl, q.tr, q.bl, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, s.txd)
                tri(q.tr, q.br, q.bl, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0, s.txd)
                tri(q.tl, q.bl, q.tr, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, s.txd)
                tri(q.tr, q.bl, q.br, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0, s.txd)
            end
            Wait(0)
        end
        drawing = false
    end)
end

---@param mode 'screen'|'panel'
function Screen.create(key, def, mode)
    if screens[key] or not def then return end
    counter = counter + 1
    def.coords = vec3(def.coords.x, def.coords.y, def.coords.z)

    local txd = ('rsvx_bowling_%d'):format(counter)
    local resW = resolution(def, mode)
    local dui = CreateDui(('nui://%s/web/index.html?%s=1'):format(GetCurrentResourceName(), mode), resW, 512)
    local handle = CreateRuntimeTxd(txd)
    CreateRuntimeTextureFromDuiHandle(handle, 'screen', GetDuiHandle(dui))

    local s = { key = key, dui = dui, txd = txd, quad = corners(def), resW = resW, mode = mode }
    screens[key] = s
    loop()

    -- The page takes a moment to load, so repeat the first update.
    SetTimeout(1500, function() if screens[key] == s then send(s) end end)
    SetTimeout(4000, function() if screens[key] == s then send(s) end end)
end

-- Moves, turns or resizes a display. Used live by the in-game editor.
function Screen.place(key, def)
    local s = screens[key]
    if s then s.quad = corners(def) end
end

-- Applies a saved position. Rebuilds the page if the shape changed enough to
-- need a different resolution.
function Screen.apply(key, def, mode)
    local s = screens[key]
    def.coords = vec3(def.coords.x, def.coords.y, def.coords.z)
    if s and s.resW == resolution(def, mode) then
        s.quad = corners(def)
        return
    end
    local payload = s and s.payload
    Screen.remove(key)
    Screen.create(key, def, mode)
    if screens[key] then screens[key].payload = payload end
end

function Screen.exists(key)
    return screens[key] ~= nil
end

function Screen.send(key, payload)
    local s = screens[key]
    if not s then return end
    s.payload = payload
    send(s)
end

function Screen.remove(key)
    local s = screens[key]
    if not s then return end
    DestroyDui(s.dui)
    screens[key] = nil
end
