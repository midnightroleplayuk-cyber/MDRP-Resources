-- =============================================
--  modules/quad | client.lua
--  IMAGE-ON-A-PROP: draw a flat, textured quad in an entity's own local space.
--
--  Some foods have no prop of their own — a soup, a salad, anything made in the
--  TAKEOUT BOX. Rather than modelling one prop per food (and re-modelling for
--  every food a server invents), the made box renders the food's INVENTORY IMAGE
--  as a quad lying inside it. The quad's corners are computed from the entity
--  matrix every frame (GetOffsetFromEntityInWorldCoords), so it follows the box's
--  position and rotation exactly — including a box carried by a drag, tipped on a
--  tray, or riding in a meal.
--
--  The texture comes from a DUI (html/quad.html) turned into a runtime texture.
--  DUIs are EXPENSIVE and finite, so they're POOLED and reference-counted by image
--  url: every takeout box showing the same food shares one texture, and a texture
--  with no attachments left is torn down (LRU, capped at MAX_TEXTURES).
--
--  Gotchas this file is written around:
--    • DrawSpritePoly is BACKFACE-CULLED — the winding below is the one that
--      renders looking DOWN at a box on a table (the only way you ever see it).
--      Both triangles are also drawn in reverse so the quad reads from underneath
--      (a box held at eye level) instead of vanishing.
--    • it must be issued EVERY FRAME, so the draw loop walks the small attached
--      set and skips anything beyond DRAW_DIST / off-screen — never the entity pool.
-- =============================================

-- TUNE IN-GAME.
local DRAW_DIST    = 12.0  -- metres: past this a quad isn't drawn at all
local MAX_TEXTURES = 6     -- concurrent DUI textures (one per distinct image + shape)
local DUI_RES      = 256   -- DUI surface: the LONG edge (the short one follows the aspect)

local Textures = {}   -- [key]  = { dui, txd, tex, refs, seq }   key = url|aspect
local Attached = {}   -- [ent]  = { key, url, w, h, dz }
local texSeq   = 0    -- monotonic id: unique txd/texture names + LRU ordering
local drawing  = false -- is the per-frame draw thread alive?
local ensureDrawThread -- fwd (defined with the draw loop at the bottom)

-- Tear one pooled texture down (its last attachment went away, or it lost the LRU
-- race). SetDuiUrl'ing a live DUI would be cheaper, but a shared texture may still
-- be in use by another box — only a zero-ref entry is ever destroyed.
local function freeTexture(key)
    local t = Textures[key]
    if not t then return end
    Textures[key] = nil
    if t.dui then DestroyDui(t.dui) end
end

-- The DUI SURFACE for a quad of aspect `a` (w/h). The surface is built at the same
-- shape as the rectangle it will be stretched across, so the mapping is 1:1 and the
-- art is never distorted — a 0.295 × 0.2 box quad gets a 256 × 174 surface, not a
-- square one squashed onto it. The long edge is always DUI_RES.
local function surfaceSize(a)
    if a >= 1.0 then return DUI_RES, math.max(16, math.floor(DUI_RES / a + 0.5)) end
    return math.max(16, math.floor(DUI_RES * a + 0.5)), DUI_RES
end

-- The crop as URL query params for the DUI page, or "" for none. A crop is the
-- normalised SOURCE rectangle (0..1) the admin dragged in the panel — the page draws
-- exactly that rect across the whole surface, the same contract html/brand.html
-- honours, so a cropped picture is not re-cropped (or letterboxed) at render time.
local function cropParams(crop)
    if type(crop) ~= "table" then return "" end
    local x, y, w, h = tonumber(crop.x), tonumber(crop.y), tonumber(crop.w), tonumber(crop.h)
    if not (x and y and w and h) or w <= 0 or h <= 0 then return "" end
    return ("&cx=%.5f&cy=%.5f&cw=%.5f&ch=%.5f"):format(x, y, w, h)
end

-- The pooled runtime texture for (image url, quad aspect, crop), creating it on first
-- use. Keyed by ALL THREE: two boxes showing the same picture at different shapes (or
-- cropped differently) can't share one surface without one of them being wrong.
-- Returns txd, texture name, key.
local function acquireTexture(url, aspect, cropQ)
    local key = ("%s|%.3f|%s"):format(url, aspect, cropQ or "")
    local t = Textures[key]
    if t then
        t.refs = t.refs + 1
        return t.txd, t.tex, key
    end
    -- pool full: evict the least recently created entry that nothing is using
    local live = 0
    for _ in pairs(Textures) do live = live + 1 end
    if live >= MAX_TEXTURES then
        local oldest, oldestSeq
        for u, e in pairs(Textures) do
            if e.refs <= 0 and (not oldestSeq or e.seq < oldestSeq) then oldest, oldestSeq = u, e.seq end
        end
        if not oldest then return nil end -- every texture is in use; this box goes bare
        freeTexture(oldest)
    end
    texSeq = texSeq + 1
    local txd = ("pickle_quad_txd_%d"):format(texSeq)
    local tex = ("pickle_quad_tex_%d"):format(texSeq)
    local sw, sh = surfaceSize(aspect)
    local dui = CreateDui(("nui://%s/html/quad.html?img=%s%s"):format(
        GetCurrentResourceName(), url, cropQ or ""), sw, sh)
    if not dui then return nil end
    -- CreateRuntimeTxd returns the txd HANDLE (what CreateRuntimeTextureFromDuiHandle
    -- takes); the draw natives want the txd NAME — keep both straight.
    local txdHandle = CreateRuntimeTxd(txd)
    CreateRuntimeTextureFromDuiHandle(txdHandle, tex, GetDuiHandle(dui))
    Textures[key] = { dui = dui, txd = txd, tex = tex, refs = 1, seq = texSeq }
    return txd, tex, key
end

-- Attach an image to an entity: from now until QuadDetach (or the entity dying),
-- the image is drawn flat inside it, `dz` metres above its origin, at w × h metres.
-- The SURFACE is built at w:h, so the picture keeps its shape however the rectangle
-- is tuned, and `opts.crop` (the admin's normalised source rect) is drawn to fill it.
-- Re-attaching the same picture at the same shape and crop is a no-op; changing any
-- of the three swaps textures cleanly.
function QuadAttach(ent, url, opts)
    if not ent or not DoesEntityExist(ent) or type(url) ~= "string" or url == "" then return false end
    opts = opts or {}
    local w = math.max(0.02, tonumber(opts.w) or 0.2)
    local h = math.max(0.02, tonumber(opts.h) or 0.2)
    local cropQ = cropParams(opts.crop)
    local cur = Attached[ent]
    if cur and cur.url == url and cur.w == w and cur.h == h and cur.cropQ == cropQ then return true end
    if cur then QuadDetach(ent) end
    local txd, _, key = acquireTexture(url, w / h, cropQ)
    if not txd then return false end
    Attached[ent] = { key = key, url = url, w = w, h = h, cropQ = cropQ, dz = tonumber(opts.dz) or 0.01 }
    -- Start drawing on the NEXT frame. The loop used to be one long-lived thread
    -- that idled at Wait(500) while nothing was attached, so a box that spawned
    -- just after an idle tick showed its food up to half a second late — which is
    -- the entire visible delay, the DUI itself paints in a frame or two.
    ensureDrawThread()
    return true
end

-- Detaching drops the reference but KEEPS the texture warm: a DUI that has already
-- loaded its page and painted is instantly reusable, so the next box showing the
-- same food is correct on its first frame instead of loading again. Idle entries
-- are what acquireTexture evicts when the pool fills, oldest first.
function QuadDetach(ent)
    local a = ent and Attached[ent]
    if not a then return end
    Attached[ent] = nil
    local t = Textures[a.key]
    if not t then return end
    t.refs = t.refs - 1
end

-- Is anything attached to this entity? (Lets a caller skip re-resolving an image.)
function QuadAttached(ent) return ent and Attached[ent] ~= nil end

-- Stop/resume DRAWING an attached quad without detaching it. `SetEntityVisible`
-- can't reach a quad — it isn't part of the model, it's drawn from the entity's
-- matrix — so hiding a takeout box (a diner picking it up to eat) would otherwise
-- leave its food picture hanging in mid air. The attachment and its texture
-- reference are kept, so coming back is free and nothing re-loads.
function QuadSetVisible(ent, vis)
    local a = ent and Attached[ent]
    if not a then return end
    a.hidden = (not vis) and true or nil
end

-- Draw one quad in an entity's local frame. The corners come from the entity
-- matrix, so rotation is free; both triangles are drawn twice with reversed
-- winding so the quad is visible from above AND below.
local function drawQuad(ent, txd, tex, w, h, dz)
    local hw, hh = w * 0.5, h * 0.5
    local tl = GetOffsetFromEntityInWorldCoords(ent, -hw,  hh, dz)
    local tr = GetOffsetFromEntityInWorldCoords(ent,  hw,  hh, dz)
    local bl = GetOffsetFromEntityInWorldCoords(ent, -hw, -hh, dz)
    local br = GetOffsetFromEntityInWorldCoords(ent,  hw, -hh, dz)
    -- top-left → top-right → bottom-right
    DrawSpritePoly(tl.x, tl.y, tl.z, tr.x, tr.y, tr.z, br.x, br.y, br.z,
        255, 255, 255, 255, txd, tex, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 0.0)
    DrawSpritePoly(br.x, br.y, br.z, tr.x, tr.y, tr.z, tl.x, tl.y, tl.z,
        255, 255, 255, 255, txd, tex, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    -- top-left → bottom-right → bottom-left
    DrawSpritePoly(tl.x, tl.y, tl.z, br.x, br.y, br.z, bl.x, bl.y, bl.z,
        255, 255, 255, 255, txd, tex, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 1.0, 0.0)
    DrawSpritePoly(bl.x, bl.y, bl.z, br.x, br.y, br.z, tl.x, tl.y, tl.z,
        255, 255, 255, 255, txd, tex, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0)
end

-- The per-frame draw loop. It only EXISTS while something is attached (QuadAttach
-- starts it, and it retires itself once the last quad goes away), so a player who
-- never opens a kitchen pays nothing for this file and the first quad is drawn on
-- the very next frame rather than after an idle tick. Entities that were deleted
-- without a QuadDetach (a prop torn down by the cooking teardown) are reaped here,
-- so a stale handle can never hold a DUI hostage.
ensureDrawThread = function()
    if drawing then return end
    drawing = true
    CreateThread(function()
        while next(Attached) ~= nil do
            local cam = GetGameplayCamCoord()
            for ent, a in pairs(Attached) do
                if not DoesEntityExist(ent) then
                    QuadDetach(ent)
                elseif not a.hidden then
                    local c = GetEntityCoords(ent)
                    if #(c - cam) <= DRAW_DIST then
                        local t = Textures[a.key]
                        if t then drawQuad(ent, t.txd, t.tex, a.w, a.h, a.dz) end
                    end
                end
            end
            Wait(0)
        end
        drawing = false
    end)
end

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    Attached = {}
    for key in pairs(Textures) do freeTexture(key) end
end)
