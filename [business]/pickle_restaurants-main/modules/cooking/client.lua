-- =============================================
--  modules/cooking | client.lua
--  The interactive station experience: a full-width bottom NUI bar of
--  ingredients you drag out into the 3D world (spawns the real food prop,
--  which cooks 01->02->03), plus draggable on-screen chips over each world
--  food prop that you drag back onto the bar to collect into your inventory.
--
--  Both placing a new ingredient and re-dragging an already-placed prop move
--  the *real* world prop live under the cursor (collision off, so the cursor
--  ray passes through it).
--
--  Dual-sided items (beef patties…) are one logical item rendered as two stacked
--  props (the down face rolled 180 so it faces the pan). Only the down face cooks;
--  clicking the item flips it to cook the other side. Each side's cook state
--  is independent.
-- =============================================

local CookObjects = {} -- [uid] = entity (single items; for dual = the up-facing prop)
local CookState   = {} -- [uid] = state string (single items)
local CookCoords  = {} -- [uid] = { x, y, z }
local CookYaw     = {} -- [uid] = heading of the station the item sits on (its props face it)

-- Dual-sided patties: two props per uid, one per face.
local CookDual      = {} -- [uid] = { ent = {[1],[2]}, modelName = {}, sides = {}, flipped, input }
local CookEntityUid = {} -- [entity] = uid (reverse lookup for hover/click hit-testing)
local DualTween     = {} -- [uid] = tween token (cancels an in-flight flip animation)

cookingOpen      = false
currentCookProp  = nil

local placing = nil -- live drag-to-place preview: { entity, kind, item, hit, coords }
local moving  = nil -- live drag of an already-placed prop: { uid, hit, coords, origin }
-- live finish-tool (frosting…) drag: the tube prop follows the cursor and is
-- rubbed over a placed prep part; the result prop fades in with tool travel.
-- { tube, cfg, flavor, ghosts = {[pid] = {ent, sid, idx}}, coverage = {[pid] = m}, last, applying }
local finishing = nil
-- live condiment-bottle drag: the container follows the cursor, flips 180° over a
-- build stack and squeezes down-and-up once to lay a sauce layer on top.
-- { container, cfg, ch, lift, flip, targetSid, sqStart, ghost, applying }
local condimenting = nil
-- live baking-mix drag: the mix bowl follows the cursor and is rubbed over a placed
-- EMPTY baking tray; the raw sheet/dough fades in with travel, and at full coverage
-- the tray fills (server consumes 1 mix). { prop, ghosts = {[tid]={ent}}, coverage =
-- {[tid]=m}, last, applying }
local bakeMixing = nil

-- Stacked-face framing for dual patties. Two face props stacked back-to-back:
-- the BOTTOM face sits on the grill and is the one that cooks; the TOP face is
-- the visible side and doesn't cook until you flip it down.
local DUAL = {
    -- Roll (deg) of each face. If the patty looks upside-down, swap these two.
    top_roll    = 180.0,   -- the visible (not-cooking) face on top
    bottom_roll = 0.0, -- the grill-facing (cooking) face below
    -- The top face sits this far ABOVE the bottom (cooking) face. Set it to
    -- roughly the patty's thickness so the two don't overlap / z-fight.
    face_gap    = 0.0075,
    -- The whole patty is raised by this so the bottom (cooking) face rests ON the
    -- grill instead of sinking through it (we drop on the surface point, but the
    -- bottom face has its own height below that). Tune up until it sits flush.
    -- NOTE: this ONLY affects the patty on the GRILL now — the prep table cancels it
    -- with a -base_lift sink (patty rests on the bun) and toppings seat off top_seat,
    -- so tune this purely for how the patty sits on the hotplate.
    base_lift   = 0.0075,
    -- Height of the patty's TOP SURFACE above the part's seat — i.e. how high the
    -- cooking face's origin plus the patty's rendered thickness reaches. This is the
    -- ONE knob for anything that RESTS on the patty: a flat topping (applied/melted
    -- cheese, pickle slices), or the next stack layer (the top bun). face_gap only
    -- spaces the two rendered faces (visual thickness); base_lift only lifts the whole
    -- patty off the surface below. If a topping sinks INTO the patty, raise this; if it
    -- floats, lower it. Must be > base_lift (the top is above the cooking face).
    -- TUNE IN-GAME.
    top_seat    = 0.025,
    tween_ms    = 250,
}

-- Where a flat melting topping (a cheese slice…) seats on a dual item's up-face:
-- a hair above the top face; the model comes from the ingredient's melts config
-- (applied -> melted). TUNE IN-GAME.
local MELT_SEAT = { z = 0.01, roll = 180.0 }

-- Interactive prep build. The STACK is the first-class object: an ordered array
-- of parts sharing one (x,y) anchor and a table-surface z0. A part's z is never
-- stored — it's always z0 + the sum of the heights below it. modelHeight() gives
-- each part's flush height, so relayout() assigns every z and stacks are flush by
-- construction.
--   PrepStacks[sid] = { x, y, z0, parts = { part, part, ... } }  -- parts[1] on table
--   part = { pid, ents = {…}, height, item, half, source, top, id,
--            dual?, faces = {e1,e2}, meltEnt?, meltModel? }
-- Most parts are one prop on their centre-bottom origin. A dual-sided item (beef
-- patty) is a `dual` part: the same two-faced item (+ melt topping) the stovetop
-- renders, so it looks identical in a burger. A halves ingredient (a bun) is
-- dragged as a bottom+top PAIR; a lone top half sits flipped.
local PrepStacks = {}
local prepSid = 0        -- monotonic stack id
local prepPid = 0        -- monotonic part id (stable handle for NUI hover/grab)
local prepHovered = nil  -- pid under the cursor (for grabbing)
local prepDrag = nil     -- { parts = {…}, fromSid?, hit, coords, targetSid, targetTid, tray?, piles? } while placing/moving

-- ── drag lifecycle serialization ─────────────────────────────────────────────
-- A begin* handler YIELDS before it publishes its drag: EnsureModel waits up to a
-- second for a prop model to stream, and a decompose preview waits on a server
-- callback. The NUI's release is a separate message, so a quick flick used to land
-- its end* handler FIRST — the end found no drag and returned, then the begin
-- published one that nothing would ever release. That's the "drag won't let go"
-- bug: a prop stuck to the cursor until the next drag deleted it (and, for a
-- decompose, the product it previewed was never consumed).
--
-- So every begin/end of a drag runs inside this gate: only one at a time, and an
-- end that arrives mid-begin WAITS for the drag to exist instead of missing it.
-- `busy` holds the START TIME of the handler that owns the gate (nil = free), so a
-- handler that errors out without releasing it only stalls the next one until
-- `ms` — never forever. (One table, not four locals: this file is close to Lua's
-- 200-local limit for a chunk.)
--
-- ANSWERING THE NUI IS WHAT ENDS THE CRITICAL SECTION — not the handler returning.
-- The gate protects one thing: that an `end` can't run before its `begin` published the
-- drag. By the time a handler replies it has claimed the drag and decided its outcome, so
-- everything it does afterwards (refreshing the bar, refreshing the tray — a server round
-- trip each) needs no lock. Holding the gate across those is what made a released drag hang
-- on the cursor: the reply the NUI clears its ghost on came only after 3-4 SEQUENTIAL server
-- callbacks, and the next drag's `begin` couldn't even start until they finished. Under load
-- that reads as seconds of the item refusing to let go.
--
-- Releases are TOKENED. Without that, a handler that replied early would, on returning, clear
-- a claim a LATER handler had since taken — the gate would be silently open with a drag
-- mid-flight, which is the exact bug it exists to prevent.
local DragGate = { ms = 2000, busy = nil, owner = 0, seq = 0 }
function DragGate.wait()
    local t0 = GetGameTimer()
    while DragGate.busy and GetGameTimer() - DragGate.busy < DragGate.ms
        and GetGameTimer() - t0 < DragGate.ms do Wait(0) end
    DragGate.seq = DragGate.seq + 1
    DragGate.busy, DragGate.owner = GetGameTimer(), DragGate.seq
    return DragGate.seq
end
function DragGate.release(token)
    -- only the holder may open it; a late release from a handler that already replied is a
    -- no-op rather than a door left open for someone else's drag
    if DragGate.owner == token then DragGate.busy = nil end
end
-- Register an NUI callback that takes part in a drag's lifecycle (any begin*/end*
-- that spawns, publishes or releases a carried prop). Identical to
-- RegisterNUICallback except its handlers can never overlap each other.
function DragGate.callback(name, fn)
    RegisterNUICallback(name, function(d, cb)
        local token = DragGate.wait()
        -- replying frees the gate, so a handler gets this for free wherever it already
        -- answers early — and any post-reply work runs unlocked
        local function reply(res)
            DragGate.release(token)
            return cb(res)
        end
        local res = fn(d, reply)
        DragGate.release(token) -- returned without replying (shouldn't happen; belt and braces)
        return res
    end)
end

-- The SERVING TRAY: a tray + paper liner placed on the prep table. Food dropped
-- over it anchors WHERE you drop it on the paper (a free 2D arrangement inside
-- the rim — piles still stack), and the whole arrangement becomes ONE meal item
-- whose metadata records every layer with its (dx, dy) offset from the tray
-- centre, so a meal set back down re-renders 1:1: tray, paper, and each item
-- exactly where it was. A stack sitting on a tray is a normal PrepStack that
-- additionally carries `tid` + its offset.
local TRAYP = {
    tray_model  = "pickle_tray_01",
    paper_model = "pickle_tray_paper_01",
    paper_dz  = 0.012, -- tray-bed height: paper liner above the tray's mesh BASE. TUNE IN-GAME.
    rim_inset = 0.05,  -- shrink the droppable area vs the model bounds (rim + physics margin)
    pick_pad  = 0.03,  -- extra grab margin (m) around the tray's footprint
    pick_dz   = 0.4,   -- max height difference between the cursor's surface hit and the tray
}
-- The PIZZA BOX: the serving tray's sibling (kind "box") — a base + hinged-lid
-- pair placed on the prep table. Clicking the lid swings it open/closed (a
-- smooth hinged rotation, never a pop); only a BOXABLE pile goes inside (the
-- carried pile's BOTTOM layer must render one of the synced BoxBaseModels, any
-- cook state), ONE per box, and boxing it up makes the same meal item a serving
-- tray does — flagged so it sets back down as its box.
local BOXP = {
    base_model = "pickle_pizza_box_01",
    lid_model  = "pickle_pizza_box_02",
    -- Where the food SEATS inside the box: height of the pile's base above the
    -- surface the box sits on. This is THE food-in-box offset — raise it if the
    -- contents clip the bed, lower it (negative allowed) if they float/ride the
    -- rim. Applies to drops, moves, set-down meals and previews alike (all food
    -- z's come through trayFoodDz). TUNE IN-GAME.
    food_dz   = 0.0,
    rim_inset = 0.06,  -- shrink the droppable area vs the model bounds
    pick_pad  = 0.03,  -- extra grab margin (m) around the box's footprint
    pick_dz   = 0.4,   -- max height difference between the cursor's surface hit and the box
    -- Lid: the lid model's ORIGIN is authored on its hinge edge, so it seats a
    -- fixed step forward of the base's origin (lid_fwd, set ONCE at placement)
    -- and the whole open/close swing is ROTATION only — the box's heading plus
    -- the opening pitch. TUNE IN-GAME.
    open_deg  = 100.0, -- how far the lid swings open (pitch; boxLidSwing negates it)
    open_ms   = 350,   -- open/close swing duration
    lid_fwd   = 0.1535,   -- lid origin's forward offset from the base's origin (m)
}
-- The RESTAURANT BAG: the serving tray's sibling (kind "bag") — a SINGLE vessel
-- prop placed on the prep table (no paper liner). Drop a craft's components into it
-- (each seats as its 3D prop, or — when the item has NO prop model — shows as a 2D
-- pill anchored over the bag) and "Bag It Up" turns the contents into ONE
-- restaurant_bag tagged with the matched craft. Free equipment like the tray; only
-- → inventory needs the bag item installed. Accepts loose food like a serving tray
-- (free 2D drop), never gated on a pizza crust like the box. `base_model` is synced
-- (BagModel) and resolved live in trayBaseModel. TUNE IN-GAME.
local BAGP = {
    food_dz   = 0.02,  -- how high contents seat above the surface the bag sits on
    rim_inset = 0.05,  -- shrink the droppable area vs the model bounds
    pick_pad  = 0.03,  -- extra grab margin (m) around the bag's footprint
    pick_dz   = 0.4,   -- FLOOR for the vertical grab window; trayPickDz grows it to the
                       -- bag's full model height so aiming up its body (not just the
                       -- base) still targets it. Raise only if a hit BELOW the base needs room.
}
-- The TAKEOUT BOX: where every bag-KIND food (soup, salad — the non-stack
-- miscellaneous foods) is created. Mechanically the pizza box's twin — a base +
-- hinged-lid pair with the same seat/swing maths — but it accepts loose food like
-- a serving tray (no crust gate) and its make button CREATES the matched food
-- rather than boxing a meal. `base_model`/`lid_model` are SYNCED (BoxBaseModel /
-- BoxLidModel) and resolved live in trayBaseModel/trayLidModel. TUNE IN-GAME.
-- (a resource GLOBAL, not a local, only because of this file's 200-local ceiling —
-- see the note by makePart; BOXP/TRAYP/BAGP above are its exact siblings.)
TAKEP = {
    food_dz   = 0.0,   -- how high contents seat above the surface the box sits on
    rim_inset = 0.05,  -- shrink the droppable area vs the model bounds
    pick_pad  = 0.03,  -- extra grab margin (m) around the box's footprint
    pick_dz   = 0.4,   -- max height difference between the cursor's surface hit and the box
    open_deg  = 100.0, -- how far the lid swings open (pitch; lidSwing negates it)
    open_ms   = 350,   -- open/close swing duration
    lid_fwd   = 0.1135, -- lid origin's forward offset from the base's origin (m)
    lid_dz    = 0.035,  -- lid origin's HEIGHT above the base's origin (m): the takeout box
                        -- is a deep tub, so its hinge rides up the wall instead of sitting
                        -- level with the base. The pizza box has no entry and keeps
                        -- boxLidSeat's -0.005 default.
    -- (The food picture's rectangle inside the box is NOT here: it's `Config.BoxQuad`
    -- in core/shared.lua, so the drawn quad, the DUI surface's aspect and the admin
    -- panel's "Inside the box" cropper all read ONE embedded constant.)
}
local function isBagKind(kind) return kind == "bag" end
-- NOTE: the next three are resource GLOBALS, not file-locals, purely because this
-- file sits at Lua's 200-local ceiling for its main chunk (see the note by
-- makePart). They are internal to the cooking client either way.
function IsTakeoutKind(kind) return kind == "takeout" end
-- Kinds whose vessel is a base + HINGED LID pair (pizza box, takeout box): they
-- share the seat/swing maths, the click-to-toggle lid, and the close-before-make
-- sequence. Returns the kind's lid config, or nil.
function LidCfg(kind)
    if kind == "box" then return BOXP end
    if IsTakeoutKind(kind) then return TAKEP end
end
local PrepTrays = {}    -- [tid] = { x, y, z, kind, ents, open?, openT?, animSeq? }
                        -- kind "tray": ents = { trayEnt, paperEnt }; kind "box":
                        -- ents = { baseEnt, lidEnt } + lid open state/progress
local prepTid = 0       -- monotonic tray id
local trayHovered = nil -- tid under the cursor (grab / make-meal tooltip / lid click)

-- ─── world food props (synced for everyone) ──────────────────────────────────

-- Food props are local, non-mission objects (CreateProp -> CreateObject(...,
-- false, false, false)). DeleteEntity silently no-ops on those unless we first
-- take ownership by flagging them as a mission entity, otherwise removed/
-- collected food lingers in the world.
--
-- Even after that, DeleteEntity can STILL no-op on a handle that was created only a
-- moment ago and hasn't finished streaming in / become script-controlled yet — the
-- object lingers visibly with nothing referencing its handle. That's how a flipped
-- patty could leave "half" behind: RebuildDual deletes a face and immediately
-- overwrites its table slot, so a failed delete orphans the old handle forever. To
-- cover it, any handle we can't confirm gone is queued and retried until it dies.
local PendingDelete = {}
local function SafeDeleteEntity(ent)
    if not ent or not DoesEntityExist(ent) then return end
    SetEntityAsMissionEntity(ent, true, true)
    DeleteEntity(ent)
    if DoesEntityExist(ent) then PendingDelete[#PendingDelete + 1] = { ent = ent, tries = 0 } end
end

-- Reaper for handles whose first delete didn't take (see SafeDeleteEntity). Retries
-- each — re-asserting ownership — until it's gone or we give up (~5s), so an orphan
-- can never outlive its session even when the caller has already dropped the handle.
CreateThread(function()
    while true do
        if #PendingDelete > 0 then
            local keep = {}
            for _, d in ipairs(PendingDelete) do
                if DoesEntityExist(d.ent) then
                    SetEntityAsMissionEntity(d.ent, true, true)
                    DeleteEntity(d.ent)
                    d.tries = d.tries + 1
                    if DoesEntityExist(d.ent) and d.tries < 50 then keep[#keep + 1] = d end
                end
            end
            PendingDelete = keep
        end
        Wait(100)
    end
end)

-- ─── shared prop primitives (every station + the prep table go through these) ──

-- Stream a model in (bounded wait) and return its hash. CreateProp and
-- GetModelDimensions both silently fall back to the error prop on an un-loaded
-- model, so everything that spawns or measures a model goes through here first.
-- Stream a model in, and SAY WHETHER IT ARRIVED. The 1s budget is what it always
-- was for the warm case, but a cold model on a slow disk misses it — and the caller
-- then hands `CreateProp` an unloaded model, gets 0 back, and the food is simply
-- GONE: the caller already deleted the prop it was replacing. That is the "item
-- disappears after cooking finishes" report — a cook state change is exactly when a
-- model nothing has streamed yet is asked for.
--
-- So: keep asking (RequestModel is idempotent, but re-issuing survives a request the
-- engine dropped under load) up to a real budget, and report failure rather than
-- letting it read as success. An INVALID model can never load, so it fails at once
-- instead of stalling the caller for seconds on a typo in the recipe editor.
-- (The budget is written INSIDE the function on purpose: this file sits exactly at
-- Lua's 200-local ceiling, where a new top-level local is a hard compile error.)
local function EnsureModel(model)
    local WAIT_MS, ATTEMPTS = 1000, 5 -- ≈5s total, only ever spent when it isn't there
    local hash = (type(model) == "string") and GetHashKey(model) or model
    if HasModelLoaded(hash) then return hash, true end
    if not IsModelValid(hash) then return hash, false end
    for _ = 1, ATTEMPTS do
        RequestModel(hash)
        local started = GetGameTimer()
        while not HasModelLoaded(hash) and GetGameTimer() - started < WAIT_MS do Wait(0) end
        if HasModelLoaded(hash) then return hash, true end
    end
    return hash, false
end

-- Flush stacking height = how far a model's visible TOP sits above its centre-bottom
-- origin. GetModelDimensions returns the PHYSICS box, which carries the engine's
-- uniform ~0.04 collision margin on every side: it dips `margin` below the origin
-- (mn.z ≈ -margin) and overshoots the mesh top by the same margin, so the true top
-- is mx.z + mn.z — the margin cancels. (mx.z alone left a one-margin gap; mx.z - mn.z
-- double-counted it.)
local function modelHeight(model)
    local mn, mx = GetModelDimensions((EnsureModel(model)))
    if mn and mx then return math.max(mx.z + mn.z, 0.0) end
    return 0.0
end

-- Minimum vertical gap between two stacked layers. Flat toppings (pizza sauce/cheese)
-- are near-zero-height decals, so their modelHeight is ~0 and consecutive ones would
-- land at the SAME z, z-fight, and hide each other (the cheese vanishing under the
-- sauce). Enforcing a small floor guarantees each layer sits visibly above the one
-- below while still reading as a flat pizza. Tune in-game if layers look too spaced.
local STACK_MIN_GAP = 0.008

-- Manual per-model stacking corrections, applied on top of the measured model
-- heights — modelHeight/stackLayerHeight are ALWAYS the baseline. The map is the
-- SYNCED `stack_tweaks` setting (client global StackTweaks, edited in the admin
-- panel, seeded server-side with the pizza values), empty until the first sync.
--   sink = shift THIS layer's seat by this much (negative sinks it into the layer
--          below); everything stacked on top of it follows it down/up. Clamped so
--          a layer can never sink to (or below) the seat of the one under it —
--          a flat topping only rises STACK_MIN_GAP, so keep sinks smaller than
--          that or the clamp eats the difference.
--   rise = REPLACE the model's measured layer height (how far the NEXT layer sits
--          above this one) instead of the computed value.
local function tweakFor(model)
    return model and StackTweaks and StackTweaks[model] or nil
end
local function stackSink(model)
    local t = tweakFor(model)
    return (t and t.sink) or 0.0
end

-- Half the visible height of a spawned entity's model, for CURSOR HIT-TESTING against
-- the middle of an item rather than the floor of it (these models are bottom-origin).
-- Memoized per model: the hover loop runs every frame over every item on a station, and
-- a model's dimensions never change.
-- The cache is a CLOSURE upvalue, not a file-local: this chunk is already at Lua's
-- 200-local ceiling for a main function, so one more `local` at the top level stops the
-- file compiling. (That is also why the helpers around here are globals.)
hoverHalfHeight = (function()
    local cache = {}
    return function(ent)
        if not ent or not DoesEntityExist(ent) then return 0.0 end
        local model = GetEntityModel(ent)
        local h = cache[model]
        if not h then
            h = modelHeight(model) * 0.5
            cache[model] = h
        end
        return h
    end
end)()

local function stackLayerHeight(model)
    local t = tweakFor(model)
    if t and t.rise then return t.rise end
    -- The side-serving container (fries box) holds its food at its OWN base — both
    -- are bottom-origin, so the serving sits INSIDE the box, not stacked on top of
    -- it. Zero stacking height means the next layer keeps the same base Z.
    if SideContainerModel and SideContainerModel ~= "" and model == SideContainerModel then return 0.03 end
    return math.max(modelHeight(model), STACK_MIN_GAP)
end

-- The seat of each layer of a build stack HELD IN A HAND (modules/consume attaches
-- every layer to the entity below it, never to the bone), measured with the exact
-- maths the kitchen stacks props with — modelHeight's margin cancellation, the
-- STACK_MIN_GAP floor, the model's own STACK_TWEAKS sink and layoutParts' clamp.
-- Entry [1] is 0 (the bottom layer IS what the hand holds); every later entry is
-- relative to the layer below it.
--
-- Global because the alternative was a second, wronger measurement: consume's own
-- `mx.z - mn.z` double-counted the physics box's ~0.04 collision margin on both
-- ends, which is a small error on a burger layer and a wild one on a drink lid —
-- the cup's whole margin-inflated height lifted the lid clear off it.
function HeldStackOffsets(models)
    local out = {}
    for i, m in ipairs(models or {}) do
        if i == 1 then
            out[1] = 0.0
        else
            out[i] = math.max(stackLayerHeight(models[i - 1]) + stackSink(m), 0.001)
        end
    end
    return out
end

-- ─── synced ingredient config lookups ─────────────────────────────────────────
-- `Ingredients` / `IngredientsByModel` / `BoxBaseModels` are client globals filled
-- by the sync (modules/main). ALL food-specific behavior — halves pairs (buns),
-- melt toppings (cheese), boxable bases (pizza crusts) — is data resolved through
-- these; item and model names are never hardcoded here.
-- The halves pair of an ingredient dragged as bottom+top (nil for single-prop items).
local function halvesFor(item)
    local ing = item and Ingredients and Ingredients[item]
    return ing and ing.halves or nil
end
-- The model one half of a halves ingredient renders as; falls back to the
-- ingredient's base model for non-halves items.
local function halfModel(item, half)
    local hv = halvesFor(item)
    if hv then return (half == "top") and hv.top_model or hv.bottom_model end
    local ing = Ingredients and Ingredients[item]
    return ing and ing.model or nil
end
-- The model a melt topping renders as: `top` = { item, state } ("applied"|"melted"),
-- resolved via the ingredient's melts config; a payload-resolved `top.model` is the
-- fallback when the config entry is missing (e.g. the item was uninstalled).
local function toppingModel(top)
    if type(top) ~= "table" then return nil end
    local ing = top.item and Ingredients and Ingredients[top.item]
    local melts = ing and ing.melts
    if melts then
        if top.state == "melted" then return melts.melted_model or melts.applied_model end
        return melts.applied_model
    end
    return top.model
end

-- Recipe containers (cake tin…) are authored like the serving tray: their origin
-- isn't reliably at the mesh bottom, so seating the ORIGIN on the oven rack / prep
-- table sinks the tin through the surface (food props like pizza dough are
-- centre-bottom and unaffected). When a stack's base layer is some recipe's
-- container prop, lift the WHOLE stack so the container's mesh bottom rests at the
-- anchor — the same physics-margin correction the serving tray's modelBaseLift
-- uses. For a true centre-bottom model this computes ~0, so nothing else moves.
local STACK_PHYS_MARGIN = 0.04
local function stackBaseLift(model)
    if not model then return 0.0 end
    local isContainer = SideContainerModel and SideContainerModel ~= "" and model == SideContainerModel
    if not isContainer then
        for _, r in pairs(RecipesByInput or {}) do
            if r.container_model == model then isContainer = true break end
        end
    end
    if not isContainer then return 0.0 end
    local mn = GetModelDimensions((EnsureModel(model)))
    return mn and math.max(-(mn.z + STACK_PHYS_MARGIN), 0.0) or 0.0
end

-- Is `model` a recipe container tray (cake tin / cookie tray) or the side box? Used
-- to recognise a containered BATCH bake so its many servings lay out as a grid ON the
-- tray instead of a vertical tower.
local function isContainerModel(model)
    if not model then return false end
    if SideContainerModel and SideContainerModel ~= "" and model == SideContainerModel then return true end
    for _, r in pairs(RecipesByInput or {}) do
        if r.container_model == model then return true end
    end
    return false
end

-- Even (dx, dy) tray positions for `n` servings inside a container of half-extents
-- (hx, hy): up to 3 columns, rows as needed, centred on the tray. Tray-local metres
-- (the caller rotates them to the tray's heading). Used by the oven batch render and
-- the prep baking tray so both show the same six-cookie layout.
local function batchGridOffsets(n, hx, hy)
    if n <= 1 then return { { dx = 0.0, dy = 0.0 } } end
    local cols = math.min(n, 3)
    local rows = math.ceil(n / cols)
    -- keep servings inside the rim: span ~70% of the usable half-extent
    local spanx, spany = hx * 0.7, hy * 0.7
    local offs = {}
    for i = 0, n - 1 do
        local r = math.floor(i / cols)
        local c = i % cols
        local rowN = math.min(cols, n - r * cols) -- last row may hold fewer, still centred
        local dx = (rowN == 1) and 0.0 or (-1.0 + 2.0 * (c / (rowN - 1))) * spanx
        local dy = (rows == 1) and 0.0 or (-1.0 + 2.0 * (r / (rows - 1))) * spany
        offs[#offs + 1] = { dx = dx, dy = dy }
    end
    return offs
end

-- THE grid for a containered BATCH bake (the six-cookie tray) — the ONE place the
-- (dx, dy) of each serving comes from, wherever it is drawn: the prep tray as the
-- mix is rubbed in, that same tray picked up and moved, and the batch baking inside
-- the oven. There used to be TWO of these — the prep tray insetting the container's
-- bounds by its own rim setting, this one insetting by a flat 3cm and flooring the
-- pitch by the serving's footprint — so the same six cookies sat at visibly
-- different offsets depending on which surface happened to draw them.
--
-- Start from the container prop's own footprint, but never let the span get so tight
-- that the servings overlap. A container model that reports small bounds — or hasn't
-- finished streaming when the slot spawns — would otherwise clamp the grid to a few
-- centimetres and pile every cookie onto the same point ("all in the middle / one
-- prop"). Flooring each column/row pitch by the serving prop's measured footprint is
-- what keeps them spread out. Models may be names or hashes (a placed tray measures
-- its serving off the spawned entity).
-- The authored well PITCH of a baking container, or nil for one nobody has measured.
-- Reads the synced `bake_slots` setting and normalises it ONCE per config generation:
-- a caller may hand us either a model NAME or a hash (a placed tray measures itself off
-- the spawned entity), so both key the same entry. An entry with no spread on either
-- axis says nothing and is dropped, so it reads as "not authored" rather than stacking
-- every serving on one point.
-- A CLOSURE upvalue rather than a file-local, and a global rather than a local, for the
-- 200-local reason documented on hoverHalfHeight.
BakeSlotsFor = (function()
    local cache, gen = {}, -1
    return function(containerModel)
        if not containerModel then return nil end
        if gen ~= (ConfigGen or 0) then
            cache, gen = {}, (ConfigGen or 0)
            for model, c in pairs(BakeSlots or {}) do
                if type(c) == "table" then
                    local e = { cols = math.max(math.floor(tonumber(c.cols) or 3), 1),
                                sx = tonumber(c.spread_x) or 0.0, sy = tonumber(c.spread_y) or 0.0,
                                ox = tonumber(c.offset_x) or 0.0, oy = tonumber(c.offset_y) or 0.0 }
                    if e.sx ~= 0.0 or e.sy ~= 0.0 then
                        cache[model] = e
                        cache[GetHashKey(model)] = e
                    end
                end
            end
        end
        return cache[containerModel]
    end
end)()

--
-- THE AUTHORED PITCH WINS. `BakeSlots[containerModel]` (the synced `bake_slots`
-- setting) gives a tray's wells as `cols` across and a centre-to-centre gap on each
-- axis, and a tray that has one is laid out from that alone — a cookie tray's wells are
-- where the artist put them, and no formula over a bounding box finds them. A pitch
-- rather than a seat list because a tray's wells are evenly spaced by construction:
-- authoring twelve numbers to say "0.119 apart" is twelve chances to typo one.
-- The measured grid below is what a container with no authored pitch falls back to.
local function bakeGridOffsets(n, containerModel, servingModel)
    n = math.max(math.floor(tonumber(n) or 1), 1)
    local cfg = BakeSlotsFor(containerModel)
    if cfg then
        -- Rows are however many the batch needs, and each row centres itself — so a
        -- final short row sits under the middle of the one above rather than left-packed.
        local cols = math.min(cfg.cols, n)
        local rows = math.ceil(n / cols)
        local offs = {}
        for i = 0, n - 1 do
            local r, c = math.floor(i / cols), i % cols
            local rowN = math.min(cols, n - r * cols)
            offs[#offs + 1] = { dx = (c - (rowN - 1) * 0.5) * cfg.sx + cfg.ox,
                                dy = (r - (rows - 1) * 0.5) * cfg.sy + cfg.oy }
        end
        return offs
    end
    if n <= 1 then return { { dx = 0.0, dy = 0.0 } } end
    local cn, cx = GetModelDimensions((EnsureModel(containerModel)))
    local hx = (cn and cx) and math.max((cx.x - cn.x) * 0.5 - 0.03, 0.05) or 0.12
    local hy = (cn and cx) and math.max((cx.y - cn.y) * 0.5 - 0.03, 0.05) or 0.08
    -- a tray with nothing in it yet has no serving to measure (nil is fine)
    local sn, sx
    if servingModel then sn, sx = GetModelDimensions((EnsureModel(servingModel))) end
    local sw = (sn and sx) and math.max(sx.x - sn.x, 0.03) or 0.05
    local sd = (sn and sx) and math.max(sx.y - sn.y, 0.03) or 0.05
    local cols = math.min(math.max(n, 1), 3)
    local rows = math.ceil(math.max(n, 1) / cols)
    -- batchGridOffsets spreads columns across -hx*0.7..+hx*0.7 (so (cols-1) gaps of
    -- 2*hx*0.7/(cols-1)); require each gap >= a serving width plus a hair of clearance
    if cols > 1 then hx = math.max(hx, (sw * 1.1 * (cols - 1)) / (2 * 0.7)) end
    if rows > 1 then hy = math.max(hy, (sd * 1.1 * (rows - 1)) / (2 * 0.7)) end
    return batchGridOffsets(n, hx, hy)
end

-- Does this EXPANDED model list describe a containered BATCH bake — a container base
-- with two or more IDENTICAL serving layers on top (the six-cookie tray)? If so return
-- the per-layer (dx, dy) grid (container centred) and zero the servings' rises so they
-- all share the tray-top z; nil for any other stack, which keeps stacking vertically.
-- `same` alone proves the top layers are uniform servings (a dual patty would break
-- it), so the layer count is never compared against the unexpanded stack.
-- ONE definition: the oven seat, the drag-in preview and the drag-out all read it, so
-- a tray can't lay its cookies out one way in the hand and another on the rack.
-- A GLOBAL because this file sits at Lua's 200-local ceiling.
function BakeStackOffsets(mdls, heights)
    if type(mdls) ~= "table" or #mdls < 3 or not isContainerModel(mdls[1]) then return nil end
    for i = 3, #mdls do if mdls[i] ~= mdls[2] then return nil end end
    local grid = bakeGridOffsets(#mdls - 1, mdls[1], mdls[2])
    local offs = { { dx = 0.0, dy = 0.0 } } -- container centred
    for i = 1, #grid do offs[#offs + 1] = grid[i] end
    if heights then for i = 2, #heights do heights[i] = 0.0 end end
    return offs
end

-- A stacked topping (pizza cheese/pepperoni) that has a cooked look follows the
-- _01/_02/_03 (raw/cooked/burnt) model convention. When the bake is cooked/burnt, swap
-- a raw (_01) layer to its cooked (_02) / burnt (_03) variant — but only if that model
-- actually exists in the game index, so toppings without one (e.g. sauce has only _01)
-- and a missing burnt look safely stay put instead of showing an error prop. The crust
-- is already the recipe's cooked/burnt model (not _01), so it passes through untouched.
local function cookedVariant(model, state)
    if type(model) ~= "string" or (state ~= "cooked" and state ~= "burnt") then return model end
    local function variant(suffix)
        local m = (model:gsub("_01$", suffix))
        if m ~= model and IsModelInCdimage(GetHashKey(m)) then return m end
        return nil
    end
    if state == "burnt" then return variant("_03") or variant("_02") or model end
    return variant("_02") or model
end

-- Is this model one of a dual-sided (beef patty) recipe's face props? Matched by
-- the raw / cooked / burnt model of any dual_sided recipe.
local function dualModelRecipe(model)
    if type(model) ~= "string" then return nil end
    for _, r in pairs(RecipesByInput or {}) do
        if (r.dual_sided == true or tonumber(r.dual_sided) == 1)
            and (r.raw_model == model or r.cooked_model == model or r.burnt_model == model) then
            return r
        end
    end
end

-- Expand a bottom-to-top MODEL list into the props that actually render it, so a
-- dual-sided patty ANYWHERE in a build stack (a pizza topping, a bake) shows the
-- SAME full two-faced patty as one on the grill instead of a lone half. A normal
-- model stays one prop; a patty model becomes TWO stacked faces (bottom/grill dome
-- then the visible dome a hair above, matching orientPair's unflipped patty).
-- Returns three parallel arrays: models, incremental heights (rise to the next
-- layer), and per-prop roll in degrees (0 for everything that isn't a patty face).
-- `state` swaps toppings to their cooked/burnt look, same as before.
local function expandStackLayers(models, state)
    local mdls, heights, rolls = {}, {}, {}
    for _, m0 in ipairs(models or {}) do
        local m = cookedVariant(m0, state)
        -- manual seat correction (STACK_TWEAKS.sink): shift this layer — and
        -- everything riding on it — by folding the offset into the rise below
        -- it, clamped so the layer never sinks to/below the previous layer's
        -- seat (a hair of rise always survives — it can't vanish underneath).
        -- The tower's base layer has nothing below it, so its sink is moot.
        local s = stackSink(m0)
        if s == 0.0 then s = stackSink(m) end
        if s ~= 0.0 and #heights > 0 then heights[#heights] = math.max(heights[#heights] + s, 0.001) end
        if dualModelRecipe(m0) then
            -- A dual (two-faced patty) is a stovetop COOK prop, not a centre-bottom
            -- stack prop, so its measured modelHeight is bogus — using it as the rise
            -- floats the whole tower above the patty (the cheese/bun gap). Mirror the
            -- prep path (part.height for a dual, ~line 1761): the cook face sits at the
            -- base, the visible face a face_gap above it, and the NEXT layer rests where
            -- patty rests where a topping/next layer seats — the patty TOP SURFACE. Here
            -- there's no base_lift (the cook face sits at the running height directly), so
            -- the two faces' rises sum to top_seat - base_lift (the patty thickness above
            -- the cook face): face_gap between the faces, the remainder up to the top.
            local topRise = math.max(DUAL.top_seat - DUAL.base_lift - DUAL.face_gap, 0.001)
            mdls[#mdls + 1] = m; heights[#heights + 1] = DUAL.face_gap;   rolls[#rolls + 1] = DUAL.bottom_roll
            mdls[#mdls + 1] = m; heights[#heights + 1] = topRise;         rolls[#rolls + 1] = DUAL.top_roll
        else
            mdls[#mdls + 1] = m; heights[#heights + 1] = stackLayerHeight(m);  rolls[#rolls + 1] = 0.0
        end
    end
    return mdls, heights, rolls
end

-- Spawn one frozen, collision-off local prop — the shape every food / topping /
-- stack prop needs. Collision off so the cursor ray passes through it. Returns the
-- entity or nil.
local function SpawnProp(model, x, y, z)
    -- Never hand CreateProp a model that isn't in memory: it answers 0, and a caller
    -- that has already deleted what it was replacing is left with nothing in the
    -- world and no way to notice. EnsureModel now says whether it made it.
    local _, loaded = EnsureModel(model)
    if not loaded then
        print(("[pickle_restaurants] model '%s' failed to stream — prop not spawned"):format(tostring(model)))
        return nil
    end
    local ent = CreateProp(model, x or 0.0, y or 0.0, z or 0.0, false, false, false)
    if not ent or not DoesEntityExist(ent) then return nil end
    SetEntityCollision(ent, false, false)
    FreezeEntityPosition(ent, true)
    -- a branded packaging prop now EXISTS — re-assert its brand texture replacement so
    -- it actually takes (the replacement is set at startup before any prop exists)
    if ReassertBrandFor then ReassertBrandFor(model) end
    return ent
end

-- Heading (yaw) of a station's world entity, so everything interactive placed on
-- it — food, patties, prep parts, trays, previews — faces the station instead of
-- the world axes. Falls back to the stored prop heading before the station entity
-- has streamed in.
local function stationHeadingZ(propId, prop)
    local ent = GetStationEntity and GetStationEntity(propId)
    if ent and DoesEntityExist(ent) then return GetEntityRotation(ent, 2).z end
    return (prop and prop.heading) or 0.0
end

-- EXTERNAL RENDER ANCHOR. The prep-table render machinery below (makePart /
-- layoutParts / spawnTrayEnts) is written around "the station the cook has open":
-- props spawn at the station's coords and face its heading. modules/dining reuses
-- the exact same machinery to lay a MEAL out on a table in front of a seated
-- customer — no station involved — so it sets this anchor for the duration of a
-- spawn/layout call (see SpawnMealRender at the bottom of this file). Nothing else
-- ever writes it, and it is always cleared again.
local extAnchor = nil -- { x, y, z, yaw } while an external layout is running

-- The open station's heading — the yaw every interactive object spawned from this
-- UI (prep parts, serving trays, drag previews, toppings, finish tools) adopts.
local function curYaw()
    if extAnchor then return extAnchor.yaw end
    local p = currentCookProp
    return p and stationHeadingZ(p.id, p) or 0.0
end

-- SPAWNING A COOK ITEM YIELDS, SO EVERY SPAWNER NEEDS A TOKEN. `SpawnProp` waits on
-- the model streaming in (EnsureModel + CreateProp both Wait(0)), which is instant on a
-- warm client and hundreds of ms on a cold one — a first join. In that window another
-- payload for the SAME uid (a flip, a phase timeout, the join's own cooking:bulk replay)
-- can run to completion, and the slow pass then overwrites the live entity handle with
-- its own: the overwritten prop is referenced by nothing, so no remove/cleanup path
-- (which all iterate the tracked tables) ever deletes it. That orphan is the patty half
-- left stuck on the stovetop. Every spawner bumps its uid's generation on entry and
-- drops what it spawned if the token moved while it was streaming. A global, not a
-- local: this file sits at Lua's 200-local ceiling.
CookSpawnGen = CookSpawnGen or {} -- [uid] = monotonic spawn token

function BumpSpawnGen(uid)
    local g = (CookSpawnGen[uid] or 0) + 1
    CookSpawnGen[uid] = g
    return g
end

local function SpawnCookObject(uid, model, x, y, z, state, propId)
    local token = BumpSpawnGen(uid)
    if CookObjects[uid] then SafeDeleteEntity(CookObjects[uid]); CookObjects[uid] = nil end
    local ent = SpawnProp(model, x, y, z)
    if not ent then return end
    if CookSpawnGen[uid] ~= token then SafeDeleteEntity(ent); return end
    -- CreateProp seats the model's bounds at z; the drag preview and live-move
    -- both place the raw origin with SetEntityCoordsNoOffset, so match them here
    -- or the synced prop lands at a slightly different (nearby) spot than dragged.
    SetEntityCoordsNoOffset(ent, x, y, z, false, false, false)
    -- the item faces the station it sits on, not the world axes
    if propId then CookYaw[uid] = stationHeadingZ(propId) end
    SetEntityRotation(ent, 0.0, 0.0, CookYaw[uid] or 0.0, 2, true)
    CookObjects[uid] = ent
    CookState[uid]   = state
    CookCoords[uid]  = { x = x, y = y, z = z }
end

-- ─── oven / fryer slot items ─────────────────────────────────────────────────
--  Oven bakes and fryer fries are seated at fixed slots inside the station mesh
--  (not free-placed). The oven's cavity slots live in modules/stovetop (SeatOvenSlot);
--  the fryer basket slots live here. Cooking only advances while the door is closed /
--  the basket is lowered — the server owns that gate; we just render.

local CookSlot   = {} -- [uid] = { propId, method, door, slot }
local CookSlotStack = {} -- [uid] = { ents = {…}, heights = {…} } full build stack (bottom-to-top) for an uncooked assembled slot item
local CookProg   = {} -- [uid] = last server progress payload { prog, give, … , start }
local FryerDown  = {} -- [propId] = { [slot] = basket lowered? } (per-basket, like oven doors)
local FryerBaskets = {} -- [propId] = { [slot] = ent } always-visible basket props
local FryerBasketDown = {} -- [propId .. ":" .. slot] = that basket currently rendered lowered?
local SlotBasketTween = {} -- [propId .. ":" .. slot] = per-basket tween token
local updateSlotBasket, spawnFryerBaskets -- fwd: defined after slotOccupied below

local function slotDown(propId, slot)
    local t = FryerDown[propId]
    return t ~= nil and t[slot] == true
end

-- Fryer basket slots, LOCAL to the fryer prop (x,y); z is raised_z, or lowered_z when
-- the basket is dunked. pickle_fryer_01 has TWO basket wells (left/right). TUNE IN-GAME.
local FRYER = {
    slots     = { { x = -0.11, y = 0.0 }, { x = 0.11, y = 0.0 } },
    raised_z  = 1.0,
    lowered_z = 0.90,
    dip_ms    = 400,
    basket_model = "pickle_fryer_basket_01",
    basket_dz    = 0.0, -- basket origin offset vs the fry-item seat. TUNE IN-GAME.
}

local function fryerSlotWorld(propId, slot, lowered)
    local station = GetStationEntity and GetStationEntity(propId)
    local o = FRYER.slots[slot]
    if not station or not DoesEntityExist(station) or not o then return nil end
    return GetOffsetFromEntityInWorldCoords(station, o.x, o.y, lowered and FRYER.lowered_z or FRYER.raised_z)
end

-- Soda fountain taps, LOCAL to pickle_soda_fountain_01 (x = right, y = front,
-- z = up): SEVEN nozzles left-to-right. The MIDDLE one (ice_slot) dispenses ice,
-- with three drink taps to each side. The tap X positions are COMPUTED, not
-- hard-listed: `ice_gap` is the central ice area's half-width (centre → the
-- innermost drink tap on either side) and `gap` is the spacing between adjacent
-- drink taps, so the three left taps sit at -ice_gap, -ice_gap-gap, -ice_gap-2·gap
-- and the three right ones mirror them. A cup seats on the drip tray at cup_z;
-- the clickable nozzle / push-button hover point sits tap_dz above that. The
-- DISPENSE mouth — where ice/liquid visually leaves the machine — is a separate
-- point from the click target: pour_dy/pour_dz offset it from the cup seat so
-- the render origin can be tuned without moving where clicks land. TUNE
-- IN-GAME.
local SODA = {
    slots    = 7,
    ice_slot = 4,
    ice_gap  = 0.078, -- centre → innermost drink tap (= the ice area's half-width)
    gap      = 0.0665, -- spacing between adjacent drink taps
    cup_y    = -0.155,
    cup_z    = 1.121,
    tap_dz   = 0.231, -- clickable nozzle point above the cup seat
    tap_click_r = 0.035, -- click radius (normalised screen) around the push button ONLY —
                         -- deliberately much tighter than SLOT_SNAP_R so a click registers
                         -- on the tap/ice button, not anywhere in the cup's vertical column
    pour_dy  = 0.018,   -- dispense mouth Y offset from the cup seat (render origin only)
    pour_dz  = 0.22,  -- dispense mouth height above the cup seat (render origin only)
}

-- Local X of a tap slot: 0 at the ice nozzle, else stepped out from the ice
-- area's edge by `gap` per tap (negative = left of centre, positive = right).
-- nil for an out-of-range slot (keeps the seat/world guards working).
local function sodaSlotX(slot)
    if type(slot) ~= "number" or slot < 1 or slot > SODA.slots then return nil end
    if slot == SODA.ice_slot then return 0.0 end
    local step = math.abs(slot - SODA.ice_slot) -- 1 = nearest the ice, up to 3
    local mag  = SODA.ice_gap + (step - 1) * SODA.gap
    return (slot < SODA.ice_slot) and -mag or mag
end

-- The drink a tap pours (nil for the ice nozzle / a tap with no valid drink).
-- Each synced drink carries `tap` — its RAW config position, stamped by
-- BuildSyncPayload — so tap positions stay stable even when some flavors are
-- filtered out (missing items) and mirror the server's flavorForSlot exactly.
local function sodaFlavorForSlot(slot)
    if slot == SODA.ice_slot then return nil end
    local idx = (slot < SODA.ice_slot) and slot or (slot - 1)
    for _, d in ipairs(Drinks or {}) do
        if d.tap == idx then return d end
    end
end

-- A tap slot is live when it's the ice nozzle or has a drink on it.
local function sodaSlotLive(slot)
    return slot == SODA.ice_slot or sodaFlavorForSlot(slot) ~= nil
end

-- World position of a tap's cup seat (drip tray), or of its clickable nozzle
-- when `tap` is set.
local function sodaSlotWorld(propId, slot, tap)
    local station = GetStationEntity and GetStationEntity(propId)
    local x = sodaSlotX(slot)
    if not station or not DoesEntityExist(station) or not x then return nil end
    return GetOffsetFromEntityInWorldCoords(station, x, SODA.cup_y, SODA.cup_z + (tap and SODA.tap_dz or 0.0))
end

-- World position of a tap's DISPENSE mouth — where ice/liquid visually leaves
-- the machine. Deliberately separate from the clickable nozzle point (tap_dz):
-- SODA.pour_dy/pour_dz move the render origin without moving the click target.
local function sodaDispenseWorld(propId, slot)
    local station = GetStationEntity and GetStationEntity(propId)
    local x = sodaSlotX(slot)
    if not station or not DoesEntityExist(station) or not x then return nil end
    return GetOffsetFromEntityInWorldCoords(station, x, SODA.cup_y + SODA.pour_dy, SODA.cup_z + SODA.pour_dz)
end

-- Loose ice cubes shown in the cup while it has ice (the vanilla bar-cube props —
-- visual only, like the fryer baskets / cheese slices). The cubes share ONE xy —
-- `dx`/`dy` off the cup's seat point, i.e. the cup's CENTRE — and stack upward in
-- Z (`base_dz` for the first, `step` for each one after), so filling a cup reads
-- as ice piling up in it rather than cubes scattered around the rim. `base_dz` is
-- relative to the cup's measured TOP and negative so the bottom cube sits sunk
-- inside. Each cube keeps its own yaw so the stack isn't one extruded shape.
-- Hidden again once the lid goes on (the ice is inside). TUNE IN-GAME.
local ICE = {
    dx = 0.0, dy = 0.0,   -- the cup's centre (its seat point IS its centre)
    base_dz = -0.030,     -- first cube, off the cup's measured top
    step    =  0.022,     -- each further cube sits this much higher
    -- TWO cubes: the third sat proud of the rim (base_dz + 2*step) and read as
    -- overfilled. The two kept are the first two entries, so their Z is unchanged —
    -- the ladder is computed from the index (ICE.seat), not listed per cube.
    cubes = {
        { model = "prop_ice_cube_01", yaw = 0.0 },
        { model = "prop_ice_cube_02", yaw = 55.0 },
    },
}
local SodaIce = {} -- [uid] = { ents = { {ent, c, i}, … }, topZ } ice cubes in a cup

-- Where the Nth cube sits in the cup's local space: one shared xy, stacked in Z.
-- The dz is still relative to the cup's measured top (added by the callers), so
-- the pile hugs whatever cup prop the drink is configured with. A FIELD on ICE,
-- not a `local function`: this file sits at Lua's 200-locals-per-function ceiling,
-- so one more main-scope local stops the whole module from loading.
function ICE.seat(i)
    return ICE.dx, ICE.dy, ICE.base_dz + ((i or 1) - 1) * ICE.step
end

-- Seat a cup's ice cubes: (x, y, z) is the cup's seat point, the shared local
-- (dx, dy) rotated by the station heading, each cube's dz off the cup top.
local function seatSodaIce(uid, x, y, z, headingZ)
    local rec = SodaIce[uid]; if not rec then return end
    local h = math.rad(headingZ or 0.0)
    local cosH, sinH = math.cos(h), math.sin(h)
    for idx, it in ipairs(rec.ents) do
        local e, c = it.ent, it.c
        -- a cube still mid-fall owns its own position until it lands
        if e and DoesEntityExist(e) and not it.falling then
            local dx, dy, dz = ICE.seat(it.i or idx)
            SetEntityCoordsNoOffset(e,
                x + dx * cosH - dy * sinH,
                y + dx * sinH + dy * cosH,
                z + rec.topZ + dz, false, false, false)
            SetEntityRotation(e, 0.0, 0.0, (headingZ or 0.0) + (c.yaw or 0.0), 2, true)
        end
    end
end

local function removeSodaIce(uid)
    local rec = SodaIce[uid]; if not rec then return end
    for _, it in ipairs(rec.ents) do SafeDeleteEntity(it.ent) end
    SodaIce[uid] = nil
end

local function alignToStation(propId, ent)
    local station = GetStationEntity and GetStationEntity(propId)
    if station and DoesEntityExist(station) and ent and DoesEntityExist(ent) then
        local sr = GetEntityRotation(station, 2)
        SetEntityRotation(ent, sr.x, sr.y, sr.z, 2, true)
    end
end

-- Delete a slot item's extra build-stack props (the base prop lives in CookObjects
-- and is handled by the caller).
local function clearSlotStack(uid)
    local st = CookSlotStack[uid]
    if not st then return end
    for _, e in ipairs(st.ents) do CookEntityUid[e] = nil; SafeDeleteEntity(e) end
    CookSlotStack[uid] = nil
end

-- Seat a slot item at its cavity/basket position (oven via stovetop module; fryer
-- here). An uncooked assembled item (e.g. a topped pizza) carries a full build stack
-- — every component prop, seated bottom-to-top so it renders exactly as it was built,
-- not just the base model. `fryerZ` overrides the basket height mid-dip tween.
local function seatSlotItem(uid, fryerZ)
    local s, ent = CookSlot[uid], CookObjects[uid]
    if not s or not (ent and DoesEntityExist(ent)) then return end
    local st = CookSlotStack[uid]
    if s.method == "oven" then
        if st then
            if SeatOvenSlotStack then SeatOvenSlotStack(s.propId, s.door, s.slot, st.ents, st.heights, st.baseDz, st.rolls, st.offsets) end
        elseif SeatOvenSlot then SeatOvenSlot(s.propId, s.door, s.slot, ent) end
    else
        local station = GetStationEntity and GetStationEntity(s.propId)
        if not station or not DoesEntityExist(station) then return end
        local o, z
        if s.method == "soda" then -- cup on the fountain's drip tray under its tap
            local x = sodaSlotX(s.slot)
            if not x then return end
            o, z = { x = x, y = SODA.cup_y }, SODA.cup_z
        else
            o = FRYER.slots[s.slot]
            if not o then return end
            z = fryerZ or (slotDown(s.propId, s.slot) and FRYER.lowered_z or FRYER.raised_z)
        end
        local sr = GetEntityRotation(station, 2)
        local function seatAt(e, lift, roll)
            if not (e and DoesEntityExist(e)) then return end
            local pos = GetOffsetFromEntityInWorldCoords(station, o.x, o.y, z + lift)
            SetEntityCoordsNoOffset(e, pos.x, pos.y, pos.z, false, false, false)
            -- add the layer's own roll (a patty face's flip) to the station's roll
            SetEntityRotation(e, sr.x, sr.y + (roll or 0.0), sr.z, 2, true)
        end
        if st then
            local lift = st.baseDz or 0.0
            for i, e in ipairs(st.ents) do
                seatAt(e, lift, st.rolls and st.rolls[i])
                lift = lift + (st.heights[i] or 0.0)
            end
        else
            seatAt(ent, 0.0)
        end
        -- a cup's rim ice rides with it (soda only; no-op without a cluster)
        if s.method == "soda" and SodaIce[uid] then
            local base = GetOffsetFromEntityInWorldCoords(station, o.x, o.y, z)
            seatSodaIce(uid, base.x, base.y, base.z, sr.z)
        end
    end
end

-- (Re)spawn or remove a cup's rim-ice cubes to match its synced state: visible
-- while the cup has ice and no lid (capped ice is inside, under the lid). The
-- cubes' dz rides on the cup model's measured top so they hug whatever cup prop
-- the drink is configured with.
local function updateSodaIce(uid, hasIce, state)
    if not hasIce or state == "capped" then return removeSodaIce(uid) end
    if SodaIce[uid] then return end -- already rendered; seatSlotItem keeps it placed
    local cup = CookObjects[uid]
    local topZ = (cup and DoesEntityExist(cup)) and modelHeight(GetEntityModel(cup)) or 0.12
    local ents = {}
    for i, c in ipairs(ICE.cubes) do
        local e = SpawnProp(c.model, 0.0, 0.0, 0.0)
        if e then ents[#ents + 1] = { ent = e, c = c, i = i } end
    end
    if #ents == 0 then return end
    SodaIce[uid] = { ents = ents, topZ = topZ }
    seatSlotItem(uid) -- seat the fresh cubes at the cup's current spot
end

-- Ice DISPENSING: the cubes drop out of the nozzle one at a time and free-fall
-- (0.5·g·t²) into their rim seats — gravity, not a teleport. Runs while the
-- middle tap pours; by the time the server's ice-complete sync lands the cluster
-- already exists, so updateSodaIce is a no-op and nothing pops.
local ICE_FALL = { g = 9.8, stagger_ms = 240 }
local function dropSodaIce(uid)
    if SodaIce[uid] then return end -- already iced / already falling
    local s = CookSlot[uid]
    if not s or s.method ~= "soda" then return end
    local cup = CookObjects[uid]
    local topZ = (cup and DoesEntityExist(cup)) and modelHeight(GetEntityModel(cup)) or 0.12
    local rec = { ents = {}, topZ = topZ }
    SodaIce[uid] = rec
    CreateThread(function()
        for i, c in ipairs(ICE.cubes) do
            if SodaIce[uid] ~= rec then return end -- cup removed mid-pour
            local nozzle = sodaDispenseWorld(s.propId, s.slot)
            local seat   = sodaSlotWorld(s.propId, s.slot)
            if not nozzle or not seat then break end
            local station = GetStationEntity and GetStationEntity(s.propId)
            local headingZ = (station and DoesEntityExist(station)) and GetEntityRotation(station, 2).z or 0.0
            local h = math.rad(headingZ)
            local cosH, sinH = math.cos(h), math.sin(h)
            -- Same seat the settled cluster uses: one xy (the cup's centre), each
            -- cube landing on top of the one before it — they fall in stack order.
            local dx, dy, dz = ICE.seat(i)
            local tx = seat.x + dx * cosH - dy * sinH
            local ty = seat.y + dx * sinH + dy * cosH
            local tz = seat.z + topZ + dz
            local e = SpawnProp(c.model, tx, ty, nozzle.z)
            if e then
                local entry = { ent = e, c = c, i = i, falling = true }
                rec.ents[#rec.ents + 1] = entry
                SetEntityRotation(e, 0.0, 0.0, headingZ + (c.yaw or 0.0), 2, true)
                CreateThread(function()
                    local z0 = nozzle.z
                    local started = GetGameTimer()
                    while SodaIce[uid] == rec and DoesEntityExist(e) do
                        local t = (GetGameTimer() - started) / 1000.0
                        local z = z0 - 0.5 * ICE_FALL.g * t * t
                        if z <= tz then break end
                        SetEntityCoordsNoOffset(e, tx, ty, z, false, false, false)
                        Wait(0)
                    end
                    entry.falling = nil
                    if SodaIce[uid] == rec and DoesEntityExist(e) then
                        SetEntityCoordsNoOffset(e, tx, ty, tz, false, false, false) -- settle in the seat
                    end
                end)
            end
            Wait(ICE_FALL.stagger_ms)
        end
    end)
end

-- ─── soda pour stream (marker droplets) ──────────────────────────────────────
-- A colored liquid stream from the dispense mouth (SODA.pour_dy/pour_dz) into
-- the cup while a drink pours, drawn as a column of small sphere markers that
-- free-fall (fake gravity) and recycle, so it reads as a continuous flowing
-- stream — and each drink pours in its OWN color (synced `drinks[].color`,
-- sampled from the fountain's flavor art). While it pours, a liquid SURFACE
-- disc rises inside the cup with the fill's progress, from the cup bottom up to
-- `fill_to` of the cup model's height. Drawn each frame for the fill's
-- duration; the state sync also stops it. Markers, not ptfx, so the color is
-- ours and it never fizzles out early. TUNE IN-GAME.
local POUR = {
    droplets    = 7,     -- droplets visible along the stream at once
    radius      = 0.009, -- droplet marker radius (m)
    pool_r0     = 0.022, -- liquid surface radius at the cup BOTTOM (cups taper: narrow base…)
    pool_r1     = 0.034, -- …lerped up to this radius at the top of the fill (fill_to height)
    fill_to     = 0.9,   -- the surface tops out at this fraction of the cup model's height
    cycle_ms    = 220,   -- time a droplet takes to fall the stream (visual speed)
    min_fall    = 0.03,  -- skip drawing the stream if the mouth-to-surface gap is tiny
}
local SodaPour = {} -- [uid] = token (nil = not pouring)

-- The pour color for a cup's tap: its drink's config `color`, else a pale default.
local function pourColor(uid)
    local s = CookSlot[uid]
    local d = s and sodaFlavorForSlot(s.slot)
    local c = d and d.color
    if type(c) == "table" then return c[1] or 200, c[2] or 200, c[3] or 210 end
    return 200, 200, 210
end

local function stopSodaPour(uid)
    SodaPour[uid] = nil -- the running thread checks its token and exits
end

-- The poured liquid itself, PERSISTENT: unlike the pour stream, the surface
-- must outlive the pour — a filled cup keeps its drink visible until the lid
-- caps it or the cup leaves. One shared per-frame loop draws every cup's
-- surface disc at its current level, riding the cup ENTITY (so it follows a
-- reslot drag between taps too).
local SodaFill = {} -- [uid] = { f = 0..1 fill fraction, r, g, b }
local sodaFillLoop = false
-- The cup a dragged lid is currently snapped onto: a lid on the rim — preview
-- or applied — hides the liquid, so the surface is suppressed while snapped and
-- comes back if the drag moves off. Set by the lid drag, read by the loop.
local SodaLidPreviewUid = nil

local function drawSodaFillLoop()
    if sodaFillLoop then return end
    sodaFillLoop = true
    CreateThread(function()
        while next(SodaFill) do
            local ped = GetEntityCoords(PlayerPedId())
            for uid, rec in pairs(SodaFill) do
                local cup = CookObjects[uid]
                if uid ~= SodaLidPreviewUid and cup and DoesEntityExist(cup) then
                    local pos = GetEntityCoords(cup)
                    if #(pos - ped) < 30.0 then
                        local cupH = modelHeight(GetEntityModel(cup)) or 0.12
                        local f = rec.f or 0.0
                        -- the surface widens as it rises, tracking the cup's taper
                        local pr = POUR.pool_r0 + (POUR.pool_r1 - POUR.pool_r0) * f
                        DrawMarker(28, pos.x, pos.y, pos.z + f * cupH * POUR.fill_to,
                            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                            pr, pr, pr * 0.35,
                            rec.r, rec.g, rec.b, 200,
                            false, false, 2, false, nil, nil, false)
                    end
                end
            end
            Wait(0)
        end
        sodaFillLoop = false
    end)
end

-- Keep a cup's liquid surface in sync with its synced state: pinned full once
-- "filled", removed when the lid caps it (the drink is hidden inside), when
-- the cup is empty, or when it leaves. "filling" is a no-op — the pour thread
-- drives the level up itself, and an ICE fill on an already-poured cup must
-- not wipe the drink that's in it.
local function updateSodaFill(uid, state)
    if state == "filled" then
        local rec = SodaFill[uid]
        if rec then
            rec.f = 1.0
        else -- synced in already-filled (reconnect / station open): appear full
            local r, g, b = pourColor(uid)
            SodaFill[uid] = { f = 1.0, r = r, g = g, b = b }
        end
        drawSodaFillLoop()
    elseif state ~= "filling" then -- empty / capped / removed
        SodaFill[uid] = nil
    end
end

local function startSodaPour(uid, totalMs, elapsedMs)
    local s = CookSlot[uid]
    if not s or s.method ~= "soda" then return end
    SodaPour[uid] = (SodaPour[uid] or 0) + 1
    local token = SodaPour[uid]
    local r, g, b = pourColor(uid)
    -- fill fraction picks up mid-pour on a resync: elapsed0/total is where the
    -- surface already sits when this thread starts
    local total    = math.max(tonumber(totalMs) or 3000, 250)
    local elapsed0 = math.min(math.max(tonumber(elapsedMs) or 0, 0), total)
    local started  = GetGameTimer()
    local endAt    = started + (total - elapsed0)
    -- the rising surface lives in SodaFill (drawn by the shared loop, so it
    -- persists after the pour); this thread only pushes its level up
    SodaFill[uid] = { f = elapsed0 / total, r = r, g = g, b = b }
    drawSodaFillLoop()
    CreateThread(function()
        while SodaPour[uid] == token do
            if GetGameTimer() > endAt then break end -- backstop; the state sync also stops us
            local seat  = sodaSlotWorld(s.propId, s.slot) -- cup seat, directly under the tap
            local mouth = sodaDispenseWorld(s.propId, s.slot)
            if seat and mouth then
                local cup  = CookObjects[uid]
                local cupH = (cup and DoesEntityExist(cup)) and modelHeight(GetEntityModel(cup)) or 0.12
                local now  = GetGameTimer()
                -- the liquid surface rises with fill progress, cup bottom → fill_to of its height
                local f = math.min((elapsed0 + (now - started)) / total, 1.0)
                local rec = SodaFill[uid]
                if rec then rec.f = f end
                local surface = seat.z + f * cupH * POUR.fill_to
                local fall = mouth.z - surface
                if fall > POUR.min_fall then
                    for i = 1, POUR.droplets do
                        -- staggered phase 0..1; quadratic = accelerating fall (fake
                        -- gravity), STRAIGHT down from the dispense mouth
                        local phase = ((now / POUR.cycle_ms) + (i / POUR.droplets)) % 1.0
                        DrawMarker(28, mouth.x, mouth.y,
                            mouth.z - fall * phase * phase, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                            POUR.radius, POUR.radius, POUR.radius, r, g, b, 210,
                            false, false, 2, false, nil, nil, false)
                    end
                end
            end
            Wait(0)
        end
        if SodaPour[uid] == token then SodaPour[uid] = nil end
    end)
end

-- (Re)spawn a slot item's prop at its seat. Registered in CookEntityUid so the hover
-- projection can hit-test it like a dual patty. `stack` (optional, bottom-to-top model
-- list) renders an uncooked assembled item as its whole build stack.
local function SpawnSlotObject(uid, model, propId, method, door, slot, state, stack)
    local token = BumpSpawnGen(uid)
    if CookObjects[uid] then CookEntityUid[CookObjects[uid]] = nil; SafeDeleteEntity(CookObjects[uid]) end
    CookObjects[uid] = nil
    clearSlotStack(uid)
    CookState[uid] = state
    CookSlot[uid]  = { propId = propId, method = method, door = door, slot = slot }

    if type(stack) == "table" and #stack > 1 then
        -- expand a dual patty layer into its two faces; cookedVariant already applied
        local mdls, heights, rolls = expandStackLayers(stack, state)
        -- A containered BATCH bake (the six-cookie tray) is a container base with two or
        -- more identical servings on top: lay them out as a grid ON the tray (all at the
        -- tray-top height, spread in xy) instead of a vertical tower. Any other stack
        -- (pizza, a single-serving cake) keeps the normal vertical stacking.
        -- Detect on the EXPANDED models (cookedVariant applied): as it bakes the server
        -- only swaps the one stackBase layer, so the raw `stack` array has mixed models,
        -- but every serving normalises to the same cook variant here.
        local offs = BakeStackOffsets(mdls, heights)
        local ents, hs, rl, of = {}, {}, {}, {}
        for i, mdl in ipairs(mdls) do
            local e = SpawnProp(mdl, 0.0, 0.0, 0.0)
            -- a newer pass owns this uid now: drop the WHOLE tower we were building,
            -- nothing is published to CookSlotStack yet so nothing else can free it
            if CookSpawnGen[uid] ~= token then
                if e then SafeDeleteEntity(e) end
                for _, prev in ipairs(ents) do CookEntityUid[prev] = nil; SafeDeleteEntity(prev) end
                return
            end
            if e then
                ents[#ents + 1] = e
                hs[#hs + 1] = heights[i]
                rl[#rl + 1] = rolls[i]
                of[#of + 1] = offs and offs[i] or nil
                CookEntityUid[e] = uid
            end
        end
        if #ents > 0 then
            CookObjects[uid] = ents[1] -- base prop drives the hover chip projection
            CookSlotStack[uid] = { ents = ents, heights = hs, rolls = rl,
                                   offsets = offs and of or nil, baseDz = stackBaseLift(stack[1]) }
            seatSlotItem(uid)
            return
        end
    end

    local ent = SpawnProp(model, 0.0, 0.0, 0.0)
    if not ent then return end
    if CookSpawnGen[uid] ~= token then SafeDeleteEntity(ent); return end
    CookObjects[uid] = ent
    CookEntityUid[ent] = uid
    seatSlotItem(uid)
end

-- Called by main/client when a station prop (re)spawns: adopt the fryer baskets'
-- synced up/down states and re-seat any slot items that spawned before the station
-- entity (or its oven doors) existed.
function OnStationSpawned(prop)
    if not prop then return end
    if prop.prop_type == "fryer" then
        local down = {}
        for k, v in pairs((prop.metadata and prop.metadata.basketsDown) or {}) do
            if v == true then down[tonumber(k) or k] = true end
        end
        FryerDown[prop.id] = down
        spawnFryerBaskets(prop.id)
    end
    for uid, s in pairs(CookSlot) do
        if s.propId == prop.id then seatSlotItem(uid) end
    end
end

-- The uid of the cup already on a soda fountain (any tap) — a fountain holds
-- ONE cup at a time, so a second cup gets no seat offered.
local function sodaCupUid(propId)
    for uid, s in pairs(CookSlot) do
        if s.method == "soda" and s.propId == propId then return uid end
    end
end

-- Is a slot on this station already taken (by any live slot item)?
local function slotOccupied(method, propId, door, slot)
    for _, s in pairs(CookSlot) do
        if s.method == method and s.propId == propId and s.slot == slot
            and (method ~= "oven" or s.door == door) then return true end
    end
    return false
end

-- ─── always-visible fryer baskets ─────────────────────────────────────────────
-- Every fryer carries one basket prop per slot, spawned with the station so the
-- baskets show whether or not anyone is using it. Each basket is lowered/raised
-- INDIVIDUALLY (click it in-world, like an oven door); its fry item rides along.

local function seatBasket(propId, slot, z)
    local ent = FryerBaskets[propId] and FryerBaskets[propId][slot]
    local station = GetStationEntity and GetStationEntity(propId)
    local o = FRYER.slots[slot]
    if not (ent and DoesEntityExist(ent)) or not (station and DoesEntityExist(station)) or not o then return end
    z = z or (slotDown(propId, slot) and FRYER.lowered_z or FRYER.raised_z)
    local pos = GetOffsetFromEntityInWorldCoords(station, o.x, o.y, z + FRYER.basket_dz)
    SetEntityCoordsNoOffset(ent, pos.x, pos.y, pos.z, false, false, false)
    alignToStation(propId, ent)
end

-- Re-seat one basket AND the fry item riding in it after its state changed; tweens
-- between raised/lowered when the state flipped (animate), else snaps into place.
updateSlotBasket = function(propId, slot, animate)
    local key = propId .. ":" .. slot
    local want = slotDown(propId, slot)
    local function seatAll(z)
        seatBasket(propId, slot, z)
        for uid, s in pairs(CookSlot) do
            if s.method == "fry" and s.propId == propId and s.slot == slot then seatSlotItem(uid, z) end
        end
    end
    if FryerBasketDown[key] == want or not animate then
        FryerBasketDown[key] = want
        return seatAll(nil)
    end
    FryerBasketDown[key] = want
    SlotBasketTween[key] = (SlotBasketTween[key] or 0) + 1
    local token = SlotBasketTween[key]
    local from = want and FRYER.raised_z or FRYER.lowered_z
    local to   = want and FRYER.lowered_z or FRYER.raised_z
    CreateThread(function()
        local started = GetGameTimer()
        while SlotBasketTween[key] == token do
            local t = math.min((GetGameTimer() - started) / FRYER.dip_ms, 1.0)
            seatAll(from + (to - from) * t)
            if t >= 1.0 then return end
            Wait(0)
        end
    end)
end

-- Called by main/client when a fryer station is removed / the world resyncs.
function DespawnFryerBaskets(propId)
    for _, e in pairs(FryerBaskets[propId] or {}) do SafeDeleteEntity(e) end
    FryerBaskets[propId] = nil
    for slot in ipairs(FRYER.slots) do
        local key = propId .. ":" .. slot
        FryerBasketDown[key] = nil
        SlotBasketTween[key] = nil -- also stops any in-flight tween
    end
end

spawnFryerBaskets = function(propId)
    DespawnFryerBaskets(propId)
    FryerBaskets[propId] = {}
    for slot in ipairs(FRYER.slots) do
        local e = SpawnProp(FRYER.basket_model, 0.0, 0.0, 0.0)
        if e then
            FryerBaskets[propId][slot] = e
            FryerBasketDown[propId .. ":" .. slot] = slotDown(propId, slot)
            seatBasket(propId, slot)
        end
    end
end

-- The open slot the cursor is CLOSE TO (within SLOT_SNAP_R normalized-screen radius),
-- for a placement preview: { door?, slot, w }, or nil when the cursor isn't near any
-- slot (so the preview follows the cursor instead of pre-locking onto a slot).
-- Oven only offers slots whose door is open; fryer offers any free basket slot.
local SLOT_SNAP_R = 0.2 -- ~ how near the cursor must be to a slot to snap onto it
-- `anyDistance` drops the radius gate: the preview LOCKS to the nearest free
-- slot no matter where the cursor is (soda taps — the cup always sits in a
-- seat rather than trailing the cursor around the machine). `ignoreUid` names
-- a slot item being re-slotted, so its own presence doesn't block it (the
-- one-cup-per-fountain rule would otherwise pin a cup to its tap).
local function nearestOpenSlot(method, anyDistance, ignoreUid)
    local prop = currentCookProp; if not prop then return nil end
    local cx, cy = GetNuiCursorPosition()
    local sw, sh = GetActiveScreenResolution()
    local cnx = (sw > 0) and (cx / sw) or 0.0
    local cny = (sh > 0) and (cy / sh) or 0.0
    local best
    local function consider(door, slot, w)
        local on, sx, sy = GetScreenCoordFromWorldCoord(w.x, w.y, w.z)
        if not on then return end
        local dx, dy = sx - cnx, sy - cny
        local d2 = dx * dx + dy * dy
        if not anyDistance and d2 > SLOT_SNAP_R * SLOT_SNAP_R then return end -- too far — don't snap
        if not best or d2 < best.d2 then best = { door = door, slot = slot, w = w, d2 = d2 } end
    end
    if method == "oven" then
        local n = OvenSlotCount and OvenSlotCount() or 0
        for door = 1, 2 do
            if IsOvenDoorOpen and IsOvenDoorOpen(prop.id, door) then
                for slot = 1, n do
                    if not slotOccupied("oven", prop.id, door, slot) then
                        local w = OvenSlotWorld and OvenSlotWorld(prop.id, door, slot)
                        if w then consider(door, slot, w) end
                    end
                end
            end
        end
    elseif method == "soda" then
        -- one cup per fountain: a machine already holding a cup (other than the
        -- one being moved between taps) offers no seat at all
        local cupUid = sodaCupUid(prop.id)
        if cupUid and cupUid ~= ignoreUid then return nil end
        for slot = 1, SODA.slots do
            if sodaSlotLive(slot) and not slotOccupied("soda", prop.id, nil, slot) then
                local w = sodaSlotWorld(prop.id, slot)
                if w then consider(nil, slot, w) end
            end
        end
    else
        for slot = 1, #FRYER.slots do
            if not slotOccupied("fry", prop.id, nil, slot) then
                local w = fryerSlotWorld(prop.id, slot, slotDown(prop.id, slot))
                if w then consider(nil, slot, w) end
            end
        end
    end
    return best
end

-- The fryer basket the cursor is over (screen-projected, same snap radius as
-- placement) — click-to-dip targets one basket, like clicking an oven door.
local function hoveredBasketSlot(propId)
    local cx, cy = GetNuiCursorPosition()
    local sw, sh = GetActiveScreenResolution()
    local cnx = (sw > 0) and (cx / sw) or 0.0
    local cny = (sh > 0) and (cy / sh) or 0.0
    local best, bestD
    for slot in ipairs(FRYER.slots) do
        local w = fryerSlotWorld(propId, slot, slotDown(propId, slot))
        if w then
            local on, sx, sy = GetScreenCoordFromWorldCoord(w.x, w.y, w.z)
            if on then
                local dx, dy = sx - cnx, sy - cny
                local d = dx * dx + dy * dy
                if d <= SLOT_SNAP_R * SLOT_SNAP_R and (not bestD or d < bestD) then best, bestD = slot, d end
            end
        end
    end
    return best
end

-- The soda tap nozzle the cursor is over (screen-projected, same convention as
-- the fryer baskets) — click = pour that tap into the cup seated under it.
local function hoveredTapSlot(propId)
    local cx, cy = GetNuiCursorPosition()
    local sw, sh = GetActiveScreenResolution()
    local cnx = (sw > 0) and (cx / sw) or 0.0
    local cny = (sh > 0) and (cy / sh) or 0.0
    local best, bestD
    local r = SODA.tap_click_r -- tight: the push button only, not the cup's whole column
    for slot = 1, SODA.slots do
        if sodaSlotLive(slot) then
            local w = sodaSlotWorld(propId, slot, true)
            if w then
                local on, sx, sy = GetScreenCoordFromWorldCoord(w.x, w.y, w.z)
                if on then
                    local dx, dy = sx - cnx, sy - cny
                    local d = dx * dx + dy * dy
                    if d <= r * r and (not bestD or d < bestD) then best, bestD = slot, d end
                end
            end
        end
    end
    return best
end

-- ─── dual-sided patties ──────────────────────────────────────────────────────

local function modelForSide(input, state)
    local r = RecipesByInput and RecipesByInput[input]
    if not r then return nil end
    if state == "cooked" then return r.cooked_model
    elseif state == "burnt" then return r.burnt_model
    else return r.raw_model end
end

-- Which side is the cooking side (server `down`) — it sits on the grill (bottom,
-- hidden); the OTHER side faces up where you can see it.
local function cookSide(flipped) return flipped and 2 or 1 end

-- The roll a given face sits at: the cooking face is the grill-facing bottom one.
local function dualTargetRoll(rec, side)
    return (side == cookSide(rec.flipped)) and DUAL.bottom_roll or DUAL.top_roll
end

-- The vertical offset a face sits at: the whole patty is raised by base_lift so
-- the bottom (cooking) face clears the grill; within that, the cooking face is on
-- the bottom and the visible face sits face_gap above it.
local function dualTargetZ(rec, side)
    return DUAL.base_lift + ((side == cookSide(rec.flipped)) and 0.0 or DUAL.face_gap)
end

-- Position a pair of face entities at coords: the cooking face on the grill, the
-- visible face stacked on top. Used for both the live placement preview and
-- placed/dragged patties so they look identical throughout.
local function orientPair(ents, x, y, z, flipped, yaw)
    local cook = cookSide(flipped)
    for s = 1, 2 do
        local ent = ents[s]
        if ent and DoesEntityExist(ent) then
            local isCook = s == cook
            local roll   = isCook and DUAL.bottom_roll or DUAL.top_roll
            local dz     = DUAL.base_lift + (isCook and 0.0 or DUAL.face_gap)
            SetEntityCoordsNoOffset(ent, x, y, z + dz, false, false, false)
            SetEntityRotation(ent, 0.0, roll, yaw or 0.0, 2, true)
        end
    end
end

-- Seat a melt-topping slice on a dual item's visible (up) face, given the item's
-- base (x,y,z). Pure + shared by the stovetop and the prep table; no-op without one.
local function placeMeltAt(ent, x, y, z, yaw)
    if not ent or not DoesEntityExist(ent) then return end
    -- Rest the topping's bottom on the patty's top surface (DUAL.top_seat) — the same
    -- height the next stack layer uses, so cheese/pickle and the top bun agree.
    SetEntityCoordsNoOffset(ent, x, y, z + DUAL.top_seat, false, false, false)
    SetEntityRotation(ent, 0.0, DUAL.top_roll + MELT_SEAT.roll, yaw or 0.0, 2, true)
end

-- Keep the stovetop dual item's melt topping (if any) sitting on its visible face.
local function placeMelt(uid)
    local rec, c = CookDual[uid], CookCoords[uid]
    if not rec or not c then return end
    placeMeltAt(rec.meltEnt, c.x, c.y, c.z, CookYaw[uid])
end

local function orientDualSnap(uid)
    local rec, c = CookDual[uid], CookCoords[uid]
    if not rec or not c then return end
    orientPair(rec.ent, c.x, c.y, c.z, rec.flipped, CookYaw[uid])
    placeMelt(uid)
end

-- Animate a flip: the patty turns over as one rigid body, so BOTH faces rotate
-- the SAME way (each +180 from its pre-flip roll) rather than toward each other.
-- Their heights cross over at the same time (cooking face <-> visible face).
local function tweenDualFlip(uid)
    local rec = CookDual[uid]; if not rec then return end
    DualTween[uid] = (DualTween[uid] or 0) + 1
    local token = DualTween[uid]
    -- a flip swapped which side is on the grill, so each face starts at the
    -- opposite side's resting roll/height
    local fromRoll, fromZ = {}, {}
    for s = 1, 2 do
        fromRoll[s] = (dualTargetRoll(rec, s) == DUAL.bottom_roll) and DUAL.top_roll or DUAL.bottom_roll
        fromZ[s]    = (dualTargetZ(rec, s) == DUAL.base_lift) and (DUAL.base_lift + DUAL.face_gap) or DUAL.base_lift
    end
    CreateThread(function()
        local started = GetGameTimer()
        while true do
            local r, c = CookDual[uid], CookCoords[uid]
            if not r or not c or DualTween[uid] ~= token then return end
            local t = math.min((GetGameTimer() - started) / DUAL.tween_ms, 1.0)
            for s = 1, 2 do
                local ent = r.ent[s]
                if ent and DoesEntityExist(ent) then
                    local roll = fromRoll[s] + 180.0 * t -- same direction for both faces
                    local dz   = fromZ[s] + (dualTargetZ(r, s) - fromZ[s]) * t
                    SetEntityCoordsNoOffset(ent, c.x, c.y, c.z + dz, false, false, false)
                    SetEntityRotation(ent, 0.0, roll, CookYaw[uid] or 0.0, 2, true)
                end
            end
            if t >= 1.0 then
                orientDualSnap(uid) -- normalise to the exact resting rolls/heights
                return
            end
            Wait(0)
        end
    end)
end

-- Spawn or update a dual item from a server payload: (re)create each face prop
-- whose model changed, keep both at the shared coords, orient (animating on
-- flip), and stash the live cook-progress so the hover panel can count up.
local function RebuildDual(p)
    local uid = p.uid
    local x, y, z = p.x, p.y, p.z
    CookCoords[uid] = { x = x, y = y, z = z }
    if p.prop_id then CookYaw[uid] = stationHeadingZ(p.prop_id) end -- face the stove
    local flipped = p.flipped and true or false
    local input = p.input
    local ps = p.sides or {}
    local sides = { (ps[1] and ps[1].state) or "raw", (ps[2] and ps[2].state) or "raw" }
    local rec = CookDual[uid]
    if not rec then
        rec = { ent = {}, modelName = {}, sides = sides, flipped = flipped, input = input }
        CookDual[uid] = rec
    end
    -- see CookSpawnGen: the face spawns below YIELD on a cold model, and a flip/melt/
    -- bulk-replay payload for this same patty arriving in that window would otherwise
    -- leave one of the two faces orphaned on the stovetop forever
    local token = BumpSpawnGen(uid)

    for s = 1, 2 do
        local model = modelForSide(input, sides[s])
        local ent = rec.ent[s]
        if (not ent) or (not DoesEntityExist(ent)) or rec.modelName[s] ~= model then
            if ent then CookEntityUid[ent] = nil; SafeDeleteEntity(ent) end
            -- empty the slot BEFORE yielding: a remove arriving mid-stream must not
            -- find a stale handle here and think it already freed this face
            rec.ent[s], rec.modelName[s] = nil, nil
            ent = model and SpawnProp(model, x, y, z) or nil
            -- `CookDual[uid] ~= rec` catches removal too: a cooking:remove mid-stream
            -- nils the table, and writing onto the discarded rec is the same orphan
            if CookSpawnGen[uid] ~= token or CookDual[uid] ~= rec then
                if ent then SafeDeleteEntity(ent) end
                return
            end
            if ent then
                rec.ent[s] = ent
                rec.modelName[s] = model
                CookEntityUid[ent] = uid
            end
        end
    end

    -- melted/applied topping on the visible face (spawn/swap/remove as needed):
    -- `topping` = { item, state = "applied"|"melted", model } | nil, the model
    -- server-resolved (toppingModel re-derives it from the ingredient config).
    local topping = p.topping
    if topping and topping.item then
        local model = topping.model or toppingModel(topping)
        if model and ((not rec.meltEnt) or (not DoesEntityExist(rec.meltEnt)) or rec.meltModel ~= model) then
            if rec.meltEnt then SafeDeleteEntity(rec.meltEnt) end
            rec.meltEnt, rec.meltModel = nil, nil
            local melt = SpawnProp(model, x, y, z) -- yields; same token rule as the faces
            if CookSpawnGen[uid] ~= token or CookDual[uid] ~= rec then
                if melt then SafeDeleteEntity(melt) end
                return
            end
            rec.meltEnt, rec.meltModel = melt, melt and model or nil
        end
    elseif rec.meltEnt then
        SafeDeleteEntity(rec.meltEnt); rec.meltEnt, rec.meltModel = nil, nil
    end

    local flipChanged = rec.flipped ~= flipped
    rec.sides, rec.input, rec.flipped, rec.topping = sides, input, flipped, topping
    -- live cook progress per face, timestamped against our own clock so the grill
    -- side's % counts up smoothly between server messages (the other is frozen).
    rec.prog = {
        cooking = p.cooking or 1, start = GetGameTimer(),
        sides = { ps[1] or {}, ps[2] or {} }, topping = topping,
        give = p.give, giveLabel = p.giveLabel, giveImage = p.giveImage,
    }
    -- chips project from the visible top face (the side NOT on the grill)
    local visible = (cookSide(flipped) == 1) and 2 or 1
    CookObjects[uid] = rec.ent[visible] or rec.ent[1] or rec.ent[2]
    CookState[uid]   = sides[1]

    if flipChanged then tweenDualFlip(uid) else orientDualSnap(uid) end
end

local function RemoveDual(uid)
    BumpSpawnGen(uid) -- a spawn still streaming for this uid must drop what it makes
    local rec = CookDual[uid]; if not rec then return false end
    for s = 1, 2 do
        local ent = rec.ent[s]
        if ent then CookEntityUid[ent] = nil; SafeDeleteEntity(ent) end
    end
    if rec.meltEnt then SafeDeleteEntity(rec.meltEnt) end
    CookDual[uid], DualTween[uid] = nil, nil
    return true
end

-- Move all entities for a uid (single prop or both dual faces) and remember the
-- new coords so a state/flip re-spawn lands in the right place.
local function MoveCookObjectLocal(uid, x, y, z)
    CookCoords[uid] = { x = x, y = y, z = z }
    local rec = CookDual[uid]
    if rec then
        for s = 1, 2 do
            local ent = rec.ent[s]
            if ent and DoesEntityExist(ent) then
                SetEntityCoordsNoOffset(ent, x, y, z + dualTargetZ(rec, s), false, false, false)
                SetEntityRotation(ent, 0.0, dualTargetRoll(rec, s), CookYaw[uid] or 0.0, 2, true)
            end
        end
        placeMelt(uid)
    else
        local ent = CookObjects[uid]
        if ent and DoesEntityExist(ent) then
            SetEntityCoordsNoOffset(ent, x, y, z, false, false, false)
        end
    end
end

-- ─── live drag-to-place ──────────────────────────────────────────────────────

-- The world model to preview for a dragged bar item (raw food / drink / recipe).
local function previewModel(kind, item)
    if kind == "cook" then
        local r = RecipesByInput and RecipesByInput[item]
        return r and r.raw_model
    elseif kind == "drink" then
        for _, dd in ipairs(Drinks or {}) do if dd.input == item then return dd.model end end
    elseif kind == "assembly" then
        for _, a in ipairs(Assembly or {}) do if a.output == item then return a.model end end
    end
    return nil
end

-- The build stack (ordered component models) of an uncooked assembled tray item,
-- keyed "item|sig" (sig = the entry's build-variation signature), refreshed
-- from the tray payload. Lets the drag-to-oven preview render the whole stack
-- (matching what gets placed), not just the base model.
local PreviewStacks = {}
local function previewStackKey(item, sig)
    return tostring(item) .. "|" .. tostring(sig or "")
end
local function previewStackFor(item, sig)
    return PreviewStacks[previewStackKey(item, sig)]
end

-- Lay an ordered set of props flush bottom-to-top at (x,y,z), all facing `headingZ`
-- (the station's heading) so the preview, the seated stack, and a dragged-out stack
-- share one consistent rotation.
-- `offsets` (optional, per layer) spreads layers across the plane instead of stacking
-- them: a containered BATCH bake's servings sit side by side ON the tray. Rotated to
-- `headingZ`, exactly as SeatOvenSlotStack does, so a dragged tray and a seated one
-- lay the same six cookies in the same six places.
local function layoutPreviewStack(ents, heights, x, y, z, headingZ, baseDz, rolls, offsets)
    local lift = baseDz or 0.0
    local hr = math.rad(headingZ or 0.0)
    for i, e in ipairs(ents) do
        if e and DoesEntityExist(e) then
            local wx, wy = x, y
            local ofs = offsets and offsets[i]
            if ofs then
                wx = wx + ofs.dx * math.cos(hr) - ofs.dy * math.sin(hr)
                wy = wy + ofs.dx * math.sin(hr) + ofs.dy * math.cos(hr)
            end
            SetEntityCoordsNoOffset(e, wx, wy, z + lift, false, false, false)
            -- a patty face carries its own roll; everything else is flat (0)
            SetEntityRotation(e, 0.0, (rolls and rolls[i]) or 0.0, headingZ or 0.0, 2, true)
        end
        lift = lift + (heights[i] or 0.0)
    end
end

-- Lift a seated slot item (single prop or full stack) out to follow the cursor while
-- the player drags it toward the bar to collect — the same feel as dragging it in.
-- Keeps the flush layer spacing and the station facing so nothing pops.
local function moveSlotStackTo(uid, x, y, z)
    local s = CookSlot[uid]
    local headingZ = s and stationHeadingZ(s.propId) or 0.0
    local st = CookSlotStack[uid]
    if st then
        layoutPreviewStack(st.ents, st.heights, x, y, z, headingZ, st.baseDz, st.rolls, st.offsets)
    else
        local ent = CookObjects[uid]
        if ent and DoesEntityExist(ent) then
            SetEntityCoordsNoOffset(ent, x, y, z, false, false, false)
            SetEntityRotation(ent, 0.0, 0.0, headingZ, 2, true)
        end
    end
    seatSodaIce(uid, x, y, z, headingZ) -- a cup's rim ice rides the drag
end

-- Delete a placement preview's entity/entities (dual + stack previews carry several).
local function deletePreview(p)
    if not p then return end
    if p.dual then
        for _, e in ipairs(p.ent) do SafeDeleteEntity(e) end
    elseif p.stackEnts then
        for _, e in ipairs(p.stackEnts) do SafeDeleteEntity(e) end
    else
        SafeDeleteEntity(p.entity)
    end
    if p.meltEnt then SafeDeleteEntity(p.meltEnt) end
end

local function cancelPlace()
    local p = placing; placing = nil
    deletePreview(p)
end

local function cancelMove()
    moving = nil
end

-- ─── virtual point render gate ───────────────────────────────────────────────
-- Items cooking at a VIRTUAL point live inside a kitchen shell that only exists
-- on the client currently in a session at that exact point — everyone else must
-- not materialize their props (the state still broadcasts to all, so it survives
-- sessions and keeps cooking unattended, same as physical stations).
local CookPropId = {} -- [uid] = prop id the item belongs to (only spawned items)

local function renderableProp(propId)
    local p = GetClientProp and GetClientProp(tonumber(propId) or propId)
    -- fail CLOSED on an unknown prop: a broadcast landing before this client's
    -- first sync fills propsById could be a virtual item (which must never
    -- materialize outside its session), and everything skipped here is replayed
    -- by the post-sync cooking:bulk anyway
    if not p then return false end
    if p.prop_type ~= "virtual_point" then return true end
    return cookingOpen and currentCookProp and currentCookProp.virtual
        and currentCookProp.id == p.id
end

-- gate + remember which prop a spawned item belongs to, so a closing virtual
-- session can drop exactly its own items again
local function gateSpawn(uid, propId)
    if not renderableProp(propId) then return false end
    CookPropId[uid] = tonumber(propId) or propId
    return true
end

RegisterNetEvent("pickle_restaurants:cooking:spawn", function(uid, model, x, y, z, state, propId)
    if not gateSpawn(uid, propId) then return end
    SpawnCookObject(uid, model, x, y, z, state, propId)
end)

RegisterNetEvent("pickle_restaurants:cooking:update", function(uid, model, state)
    local s = CookSlot[uid]
    if s then return SpawnSlotObject(uid, model, s.propId, s.method, s.door, s.slot, state) end
    local c = CookCoords[uid]; if not c then return end
    SpawnCookObject(uid, model, c.x, c.y, c.z, state)
end)

-- spawn or update a dual-sided item (both faces + live status in one payload)
RegisterNetEvent("pickle_restaurants:cooking:dual", function(p)
    if not p or not gateSpawn(p.uid, p.prop_id) then return end
    RebuildDual(p)
end)

-- spawn an oven/fryer/soda item at its station slot
RegisterNetEvent("pickle_restaurants:cooking:slotSpawn", function(p)
    if not p or not gateSpawn(p.uid, p.prop_id) then return end
    SpawnSlotObject(p.uid, p.model, p.prop_id, p.method, p.door, p.slot, p.state, p.stack)
    if p.method == "soda" then
        updateSodaIce(p.uid, p.ice, p.state)
        updateSodaFill(p.uid, p.state)
    end
end)

-- live cook progress for an oven/fryer/soda item's hover panel
RegisterNetEvent("pickle_restaurants:cooking:progress", function(p)
    if not (p and p.uid) then return end
    p.start = GetGameTimer()
    CookProg[p.uid] = p
    -- soda dispensing: pour visuals while the tap runs — cubes free-fall from the
    -- ice nozzle, a drink pours a liquid stream — instead of contents appearing
    -- from nowhere at completion.
    if p.method == "soda" then
        local pg = p.prog or {}
        if pg.state == "filling" then
            if pg.fillKind == "ice" then
                dropSodaIce(p.uid)
            else
                startSodaPour(p.uid, pg.total, pg.elapsed)
            end
        else
            stopSodaPour(p.uid)
        end
        updateSodaFill(p.uid, pg.state)
    end
end)

-- one fryer basket lowered/raised for everyone -> animate that basket + its item
RegisterNetEvent("pickle_restaurants:fryer:dip", function(propId, slot, lowered)
    slot = tonumber(slot); if not slot then return end
    FryerDown[propId] = FryerDown[propId] or {}
    FryerDown[propId][slot] = lowered and true or false
    updateSlotBasket(propId, slot, true)
end)

RegisterNetEvent("pickle_restaurants:cooking:move", function(uid, x, y, z, propId)
    -- gate like the spawn events: recording coords for a gated-off virtual item
    -- would let a later update event materialize it outside its session. For
    -- PHYSICAL items the unconditional record stays — it's the recovery seed
    -- that lets an update respawn an item whose model failed to stream.
    if not renderableProp(propId) then return end
    MoveCookObjectLocal(uid, x, y, z)
end)

-- drop one item's local props/visuals (shared by the remove broadcast and a
-- closing virtual session dropping its own renders — the server state lives on)
local function dropItemLocal(uid)
    BumpSpawnGen(uid) -- invalidate any spawn still streaming for this uid
    if CookObjects[uid] then CookEntityUid[CookObjects[uid]] = nil end
    if not RemoveDual(uid) then
        SafeDeleteEntity(CookObjects[uid])
    end
    clearSlotStack(uid)
    removeSodaIce(uid)
    stopSodaPour(uid)
    SodaFill[uid] = nil
    CookPropId[uid] = nil
    CookObjects[uid], CookState[uid], CookCoords[uid], CookSlot[uid], CookProg[uid], CookYaw[uid] = nil, nil, nil, nil, nil, nil
    -- safe to forget the token: server uids are monotonic (cookUid) and never reused, and
    -- a pass still streaming compares against nil, which can never match its token
    CookSpawnGen[uid] = nil
end

RegisterNetEvent("pickle_restaurants:cooking:remove", dropItemLocal)

local function ApplyBulkList(list)
    for _, it in ipairs(list or {}) do
        if not gateSpawn(it.uid, it.prop_id) then goto continue end
        if it.dual then
            RebuildDual(it)
        elseif it.method == "oven" or it.method == "fry" or it.method == "soda" then
            SpawnSlotObject(it.uid, it.model, it.prop_id, it.method, it.door, it.slot, it.state, it.stack)
            if it.method == "soda" then
                updateSodaIce(it.uid, it.ice, it.state)
                updateSodaFill(it.uid, it.state) -- a filled cup shows its drink again
                -- resynced mid-pour: pick the dispensing visuals back up
                local pg = it.prog or {}
                if pg.state == "filling" then
                    if pg.fillKind == "ice" then dropSodaIce(it.uid)
                    else startSodaPour(it.uid, pg.total, pg.elapsed) end
                end
            end
            it.start = GetGameTimer(); CookProg[it.uid] = it
        else
            SpawnCookObject(it.uid, it.model, it.x, it.y, it.z, it.state, it.prop_id)
        end
        ::continue::
    end
end

RegisterNetEvent("pickle_restaurants:cooking:bulk", ApplyBulkList)

-- A virtual session opening: render THIS point's in-progress items inside the
-- freshly built shell (they were gated off while no session was open here).
function ReplayActiveItemsFor(propId)
    local list = lib.callback.await("pickle_restaurants:cooking:getActive", false, { prop_id = propId })
    ApplyBulkList(list or {})
end

-- A virtual session closing: un-render exactly this point's items.
function DropItemsFor(propId)
    for uid, pid in pairs(CookPropId) do
        if pid == propId then dropItemLocal(uid) end
    end
end

-- ─── station range watcher (what makes scoped sends safe) ─────────────────────
--
-- The server no longer broadcasts cooking events to the world — it sends them to the
-- players near the station (SendNearProp, ScopeRadius.PROP). That alone would leave a
-- player who walks up from further out staring at an empty grill, because the spawn
-- they missed is never re-sent. So range is a SUBSCRIPTION with two edges, and the two
-- functions above already are the edges: entering a station's range re-hydrates its
-- items from `cooking:getActive` (filtered by prop server-side), leaving it drops
-- exactly that station's props again.
--
-- This is also a straight win on its own: before, every client in the city spawned a
-- real entity for every item on every grill on the server — one CreateObject per stack
-- layer, per client, per restaurant. Now a client only holds the kitchens it is in.
--
-- VIRTUAL points are skipped entirely: their items are gated on being in a session at
-- that exact point (renderableProp), which is a stricter rule than distance and is
-- already driven by ReplayActiveItemsFor/DropItemsFor at session open/close. Adding a
-- distance edge on top would drop a session's items the moment the shell put the player
-- a little further from the anchor than the radius.
-- A GLOBAL, and ONE table rather than a field per tunable: this file is exactly AT Lua's
-- 200-local ceiling, where a 201st top-level local is a hard compile error, not a warning.
-- That is also why the functions below are globals. Prefixed to keep it out of the way of
-- the other modules sharing this client.
-- `in`/`out` are tighter than the server's ScopeRadius.PROP on purpose — the server must
-- already be sending us a station's events BEFORE we ask for its state, or a change
-- landing between the getActive reply and our arrival in the server's audience is lost.
-- That gap is the hysteresis that guarantees the ordering; `out` > `in` so pacing the
-- boundary doesn't thrash subscribe/unsubscribe.
CookRange = {
    subbed = {},  -- [propId] = true while we hold this station's items
    ms     = 1000, -- range poll (TUNE IN-GAME)
    ["in"] = 70.0,
    out    = 85.0,
}

CreateThread(function()
    while true do
        Wait(CookRange.ms)
        local props = GetClientProps and GetClientProps() or nil
        if props then
            local pc = GetEntityCoords(PlayerPedId())
            -- Prune subscriptions to stations that no longer exist. A deleted prop already
            -- drops its items through propRemoved, but the SUBSCRIPTION would linger as a
            -- stale `true` — and if that prop id ever came back, the loop below would think
            -- we already held it and never re-hydrate.
            for pid in pairs(CookRange.subbed) do
                if not props[pid] then CookRange.subbed[pid] = nil end
            end
            for _, p in pairs(props) do
                if p.prop_type ~= "virtual_point" and p.x and StationCooks(p) then
                    local d = #(pc - vector3(p.x, p.y, p.z))
                    if CookRange.subbed[p.id] then
                        if d > CookRange.out then
                            CookRange.subbed[p.id] = nil
                            DropItemsFor(p.id)
                        end
                    elseif d < CookRange["in"] then
                        -- claim BEFORE the await: ReplayActiveItemsFor yields on the
                        -- callback (and on every model it streams), and a second pass
                        -- of this loop meanwhile would ask again and double-spawn
                        CookRange.subbed[p.id] = true
                        ReplayActiveItemsFor(p.id)
                        pc = GetEntityCoords(PlayerPedId()) -- may have moved while we waited
                    end
                end
            end
        end
    end
end)

-- A station whose items this watcher is responsible for. Anything a cooking item can
-- sit on; other prop types (seats, doors, counters, registers) hold none.
function StationCooks(p)
    local t = p.prop_type
    return t == "stovetop" or t == "fryer" or t == "kitchen_prep" or t == "soda_machine"
end

-- Force a re-hydration of every station we hold. Nothing calls this on a normal sync (a
-- sync leaves cooking items standing — see the note in main's DoApplySync); it exists for
-- a caller that has genuinely invalidated our items and wants them rebuilt from the server.
function ResubscribeStations()
    local held = {}
    for pid in pairs(CookRange.subbed) do held[#held + 1] = pid end
    CookRange.subbed = {}
    for _, pid in ipairs(held) do DropItemsFor(pid) end
    -- left empty on purpose: the range loop re-enters each within CookRange.ms and
    -- re-hydrates through the normal subscribe edge, so there is one code path, not two
end

-- ─── click-to-flip hover ─────────────────────────────────────────────────────

local hoveredDual = nil

local function setDualOutline(uid, on)
    local rec = CookDual[uid]; if not rec then return end
    for s = 1, 2 do
        local ent = rec.ent[s]
        if ent and DoesEntityExist(ent) then
            SetEntityDrawOutline(ent, on)
            if on then SetEntityDrawOutlineColor(255, 180, 40, 255) end
        end
    end
end

local function HoverDual(uid)
    if hoveredDual == uid then return end
    if hoveredDual then setDualOutline(hoveredDual, false) end
    hoveredDual = uid
    if uid then setDualOutline(uid, true) end
end

-- ─── open / close ────────────────────────────────────────────────────────────

-- PRE-WARM WHAT THE BAR OFFERS. A drag's `begin` spawns its preview prop, and SpawnProp
-- waits on EnsureModel — up to a second for a cold model, INSIDE the drag gate. That hold
-- delays the release that follows (and the next drag's begin), which is the other half of
-- "the item stayed on my cursor and then placed". Every one of these models is something the
-- player can drag within seconds of the bar appearing, so requesting them up front turns
-- that wait into nothing on the very first drag rather than the second.
--
-- Bounded by construction: only the open station's own bar, requested once per model (the
-- HasModelLoaded check makes a re-open free), and never held — these are ordinary
-- RequestModel refs the engine is free to evict, exactly as before. Off-thread so opening
-- the station doesn't block on it.
-- A global, not a local: this file is AT Lua's 200-local ceiling for a chunk.
function WarmBarModels(ing)
    CreateThread(function()
        local seen = {}
        for _, e in ipairs(ing or {}) do
            for _, m in ipairs({ e.model, e.tool_model, e.container_model, e.applied_model, e.lidModel }) do
                if type(m) == "string" and m ~= "" and not seen[m] then
                    seen[m] = true
                    local hash = GetHashKey(m)
                    if not HasModelLoaded(hash) then RequestModel(hash) end
                    Wait(0) -- one per frame: a burst of RequestModel is a frame hitch
                end
            end
            for _, f in ipairs(e.flavors or {}) do
                if type(f.model) == "string" and f.model ~= "" and not seen[f.model] then
                    seen[f.model] = true
                    local hash = GetHashKey(f.model)
                    if not HasModelLoaded(hash) then RequestModel(hash) end
                    Wait(0)
                end
            end
        end
    end)
end

local function RefreshBar()
    if not cookingOpen or not currentCookProp then return end
    local ing = lib.callback.await("pickle_restaurants:cooking:getIngredients", false, { prop_id = currentCookProp.id })
    SendNUIMessage({ action = "cookingIngredients", ingredients = ing })
    WarmBarModels(ing)
end

local function RefreshTray()
    if not cookingOpen or not currentCookProp then return end
    local tray = lib.callback.await("pickle_restaurants:cooking:getTray", false, { prop_id = currentCookProp.id })
    -- Cache each uncooked item's build stack so a drag into the oven can preview the
    -- whole stack, exactly what placement will render.
    PreviewStacks = {}
    for _, e in ipairs(tray or {}) do
        if e.stack then PreviewStacks[previewStackKey(e.item, e.sig)] = e.stack end
    end
    SendNUIMessage({ action = "cookingTray", tray = tray })
end

-- the server swept spoiled items from our tray -> re-pull it so the NUI drops them.
-- Registered here (after RefreshTray is defined) so the local is in scope.
RegisterNetEvent("pickle_restaurants:cooking:trayDirty", function()
    if cookingOpen and currentCookProp then RefreshTray() end
end)

-- The shared restaurant stock pool (raw ingredients) changed — another cook
-- consumed, a decompose refunded, or a manager restocked. Refresh the bottom
-- ingredient bar so its counts stay live.
RegisterNetEvent("pickle_restaurants:cooking:stockDirty", function(_rid)
    if cookingOpen and currentCookProp then RefreshBar() end
end)

-- the NUI's live countdown hit 0 on an item -> re-pull the tray immediately (getTray
-- purges spoiled rows server-side) so it drops without waiting for the periodic sweep.
RegisterNUICallback("cooking:refreshTray", function(_, cb)
    cb({ ok = true }) -- reply first; the refresh arrives as its own NUI message
    if cookingOpen and currentCookProp then RefreshTray() end
end)

-- ─── interactive prep build (free-form stacking) ─────────────────────────────

-- Spawn one part and cache its stacking height. Most parts are a SINGLE prop on
-- their centre-bottom origin. A dual-sided item (beef patty) is a `dual` part: two
-- face props (the same two-faced item the stovetop renders, via orientPair) plus,
-- if topped, a melt slice seated on the visible face by placeMeltAt — one code
-- path, so a patty in a burger looks identical to one on the grill. Every prop
-- spawns at the prep prop and is positioned later by layoutParts.
-- NOTE: the takeout box's render (seatTakeoutPart) and the tray base-lift
-- correction (modelBaseLift) are defined with the tray helpers further down but
-- called from orientPart just below, so both are resource GLOBALS rather than
-- file-locals — this file is already at Lua's 200-local ceiling for its main
-- chunk, and a forward-declared local pair would push it over.
local function makePart(spec)
    local base = currentCookProp or extAnchor; if not base then return nil end
    prepPid = prepPid + 1
    -- The spec is KEPT on the part: a pile dropped into a takeout box has its props
    -- DELETED (ApplyStackConceal — the contents of a packed box aren't rendered at
    -- all), and taking it back out rebuilds the part from this exact spec.
    local part = { pid = prepPid, item = spec.item, half = spec.half,
                   source = spec.source, sig = spec.sig, spec = spec,
                   -- which FACE of a multi-faced ingredient this is (which toy). Kept
                   -- on the part so the reservation on release records it, and so a
                   -- part rebuilt from a decompose spec re-reserves the same one.
                   variant = spec.variant,
                   top = spec.top, finishTool = spec.finishTool, ents = {} }

    -- A MADE TAKEOUT BOX (a bag-kind food: soup, salad…). It has no build tower to
    -- render — its components were consumed into one product — so it renders as the
    -- box PAIR with the food's image lying inside it: base, hinged lid swung open on
    -- its authored hinge (the exact seat/swing maths the placed box uses), and a
    -- textured quad (modules/quad) drawn in the base's local space, so it follows the
    -- box wherever it goes. The quad is dropped with the part in deleteParts.
    if spec.takeout then
        local baseModel = spec.model or BoxBaseModel
        local e1 = SpawnProp(baseModel, base.x, base.y, base.z)
        if not e1 then return nil end
        local e2 = SpawnProp(spec.lidModel or BoxLidModel, base.x, base.y, base.z)
        part.ents = e2 and { e1, e2 } or { e1 }
        part.takeout = true
        part.quad = spec.image
        part.quadCrop = spec.imageCrop -- the exact source rect the admin cropped
        -- what the box IS, for the hover tooltip: a made box is one opaque product
        -- (a soup, a salad), so there's no build tower to read it off
        part.label     = spec.label
        part.itemImage = spec.itemImage or spec.image
        part.height = modelHeight(baseModel)
        return part
    end

    if type(spec.stack) == "table" and #spec.stack > 1 then
        -- A product that carries a build stack (e.g. a cooked pizza) is ONE logical
        -- part rendered as its whole layer tower — crust + sauce + cheese + toppings
        -- — so it never collapses to a bare base prop on the prep table. `state`
        -- (cooked/burnt) swaps each topping to its cooked look, same as the oven.
        -- a container base layer (cake tin) starts the tower at its mesh-bottom
        -- correction so the tin rests ON the table instead of sinking through it
        -- expand a dual patty layer into its two faces; cookedVariant already applied
        local mdls, heights, rolls = expandStackLayers(spec.stack, spec.state)
        -- a containered BATCH bake (a filled cookie tray dragged off the bar) spreads
        -- its servings across the tray instead of towering them — the same grid the
        -- oven and the drag preview lay out, so the tray never rearranges itself
        local allOffs = BakeStackOffsets(mdls, heights)
        local lifts, prolls, lift = {}, {}, stackBaseLift(spec.stack[1])
        local offsets = allOffs and {} or nil
        for i, mdl in ipairs(mdls) do
            local e = SpawnProp(mdl, base.x, base.y, base.z)
            if e then
                part.ents[#part.ents + 1] = e
                lifts[#lifts + 1] = lift
                prolls[#prolls + 1] = rolls[i]
                if offsets then offsets[#offsets + 1] = allOffs[i] end
                lift = lift + heights[i]
            end
        end
        if #part.ents == 0 then return nil end
        part.stacked = true
        part.lifts   = lifts
        part.rolls   = prolls
        part.offsets = offsets
        part.height  = lift
        return part
    end

    -- A component with NO prop model (and no build stack) seats as an ent-less
    -- "pill" part: tracked and reservable like any part, but shown as a 2D chip
    -- anchored over the Restaurant Bag instead of a 3D prop. height 0 so it never
    -- lifts anything sharing its pile.
    if not spec.model or spec.model == "" then
        part.pill   = true
        part.item   = spec.item
        part.label  = spec.label
        part.image  = spec.image
        part.height = 0.0
        return part
    end

    if spec.dual then
        local e1 = SpawnProp(spec.model, base.x, base.y, base.z)
        local e2 = SpawnProp(spec.model, base.x, base.y, base.z)
        if not e1 or not e2 then SafeDeleteEntity(e1); SafeDeleteEntity(e2); return nil end
        part.dual   = true
        part.faces  = { e1, e2 }
        part.ents   = { e1, e2 }
        -- Seat correction. A dual patty carries DUAL.base_lift as GRILL clearance
        -- (orientPair seats its cook face base_lift above the anchor, keeping it off
        -- the hotplate). In a prep pile the patty rests on a bun, where that clearance
        -- reads as a fixed ~7.5mm gap UNDER the patty. Neutralise it by default so the
        -- patty seats flush on whatever's below; a configured STACK_TWEAKS.sink stacks
        -- on top for further tuning. (layoutParts shifts this part — and everything
        -- above it — by part.sink when it isn't the base of its pile. The dual branch
        -- used to skip stackSink entirely, so a patty-keyed sink did nothing.)
        local ds = -DUAL.base_lift + stackSink(spec.model)
        if ds ~= 0.0 then part.sink = ds end
        -- Where the NEXT part rests: the patty's TOP SURFACE (DUAL.top_seat above the
        -- seat) — the SAME height placeMeltAt seats a flat topping (cheese/pickle), so a
        -- bare top bun and a topping-then-bun agree. We do NOT use modelHeight(the dual
        -- model): the two-faced item is a stovetop cook prop, not a centre-bottom stack
        -- prop, so its measured height is bogus. (A melt slice riding the patty bumps
        -- this up by the slice's own height in the melt branch below.)
        part.height = DUAL.top_seat
        -- A melt topping riding the visible face carries `top` ({ item, state },
        -- model server-resolved on `topModel`).
        local meltModel = spec.topModel or toppingModel(spec.top)
        if meltModel then
            local ce = SpawnProp(meltModel, base.x, base.y, base.z)
            if ce then
                part.meltEnt   = ce
                part.meltModel = meltModel
                part.ents[#part.ents + 1] = ce
                -- next layer (top bun) rests on the slice: patty top + the slice height
                part.height = math.max(part.height, DUAL.top_seat + modelHeight(meltModel))
            end
        end
    else
        local e = SpawnProp(spec.model, base.x, base.y, base.z)
        if not e then return nil end
        part.ents   = { e }
        -- floor near-zero (flat decal) layers so stacked pizza toppings stay visible
        part.height = stackLayerHeight(spec.model)
        -- manual seat correction: layoutParts shifts this part (and everything
        -- stacked above it) by this much when it isn't the base of its pile
        local s = stackSink(spec.model)
        if s ~= 0.0 then part.sink = s end
    end
    return part
end

local function deleteParts(parts)
    for _, p in ipairs(parts or {}) do
        for _, e in ipairs(p.ents or {}) do
            if QuadDetach then QuadDetach(e) end -- drop any image quad riding this prop
            SafeDeleteEntity(e)
        end
    end
end

-- Place a part so its BASE sits at world (x,y,z). A dual item is laid flat
-- (unflipped — fully cooked, both faces shown) via the shared stovetop orientPair,
-- with its melt topping seated by placeMeltAt, so it matches the grill exactly.
-- Other parts are a single prop on their centre-bottom origin (z is the origin
-- directly); `flip` renders a lone top half upturned — flipping 180° about the
-- bottom origin would sink it, so it's raised by its own height to keep resting
-- on the surface.
local function orientPart(part, x, y, z, flip)
    local yaw = curYaw() -- parts face the prep station, not the world axes
    -- a made takeout box seats as the box PAIR (base + open lid + image quad) —
    -- defined with the tray/lid helpers further down, which own the hinge maths
    if part.takeout then return SeatTakeoutPart(part, x, y, z, yaw) end
    if part.dual then
        orientPair(part.faces, x, y, z, false, yaw)
        placeMeltAt(part.meltEnt, x, y, z, yaw)
        return
    end
    if part.stacked then
        -- a build-stack part lays its layers flush bottom-to-top from the base z;
        -- a dual face in the tower keeps its own roll (the two-faced flip).
        -- `offsets` (a batch bake's tray grid) spreads a layer in the tray plane,
        -- rotated to the station heading like every other surface draws it.
        local hr = math.rad(yaw)
        for i, e in ipairs(part.ents) do
            if e and DoesEntityExist(e) then
                local wx, wy = x, y
                local ofs = part.offsets and part.offsets[i]
                if ofs then
                    wx = wx + ofs.dx * math.cos(hr) - ofs.dy * math.sin(hr)
                    wy = wy + ofs.dx * math.sin(hr) + ofs.dy * math.cos(hr)
                end
                SetEntityCoordsNoOffset(e, wx, wy, z + (part.lifts[i] or 0.0), false, false, false)
                SetEntityRotation(e, 0.0, (part.rolls and part.rolls[i]) or 0.0, yaw, 2, true)
            end
        end
        return
    end
    local e = part.ents[1]
    if e and DoesEntityExist(e) then
        if flip then
            SetEntityCoordsNoOffset(e, x, y, z + part.height, false, false, false)
            SetEntityRotation(e, 0.0, 180.0, yaw, 2, true)
        else
            SetEntityCoordsNoOffset(e, x, y, z, false, false, false)
            SetEntityRotation(e, 0.0, 0.0, yaw, 2, true)
        end
    end
end

-- THE single source of truth for every part's z: walk bottom→top from z0, summing
-- heights so each part sits flush on the one below. `lone` (stack has one part)
-- makes a lone top half render flipped. A part's manual seat correction (part.sink,
-- from the synced stack tweaks) shifts it and everything above it.
local function layoutParts(parts, x, y, z0, lone)
    local z, prevSeat = z0, nil
    for i, part in ipairs(parts) do
        -- the base part rests on the surface; a sunk part is clamped so it never
        -- drops to/below the seat of the part under it (it would vanish inside)
        if i > 1 then z = math.max(z + (part.sink or 0.0), prevSeat + 0.001) end
        local flip = lone and part.half == "top" -- only halves ingredients carry half
        orientPart(part, x, y, z, flip)
        prevSeat = z
        z = z + (part.height or 0.0)
    end
end
-- A pile released INSIDE a TAKEOUT BOX or a RESTAURANT BAG is CONCEALED. Both are
-- packed containers of loose food (a soup, a salad, a takeaway order), not open
-- trays you arrange things on: once things are in, they read from the container's
-- tooltip contents list, never as props sitting in/behind it. A bag used to leave
-- every prop dropped into it standing in the open, which read as the drop having
-- failed. The SERVING TRAY and the PIZZA BOX are untouched — arranging food you
-- can see IS the point of those two.
--
-- The props are DELETED, not merely made invisible. An invisible entity still draws
-- its hover/selection OUTLINE, so hiding left a glowing ghost of the food floating in
-- the box. Deleting is also the honest model: a packed box has no contents to render.
-- The PARTS survive — still reserved server-side, still counted, still what the box's
-- food is made from — and each one kept the spec it was built from, so taking the box
-- apart rebuilds them exactly (same pid, same reservation id, same props).
-- pickPart skips a concealed stack, so there is nothing invisible to hover or grab;
-- the tooltip's Take Out is how the contents come back out. A serving tray / pizza box
-- is unaffected: arranging food on those IS the point.
-- A resource GLOBAL, not a file-local: this chunk sits at Lua's 200-local ceiling.
function ApplyStackConceal(stack)
    local t = stack.tid and PrepTrays[stack.tid]
    local hide = (t and (IsTakeoutKind(t.kind) or t.kind == "bag")) and true or false
    stack.concealed = hide or nil
    -- per PART, not per stack: a stack can gain parts while already concealed, and a
    -- rebuild has to be driven off what each part is actually holding right now
    for i, p in ipairs(stack.parts or {}) do
        if hide and not p.concealed then
            for _, e in ipairs(p.ents or {}) do
                if QuadDetach then QuadDetach(e) end -- drop any image quad riding this prop
                SafeDeleteEntity(e)
            end
            p.ents, p.faces, p.meltEnt = {}, nil, nil
            p.concealed = true
        elseif (not hide) and p.concealed then
            -- rebuild from the spec, carrying over the identity the NUI and the server
            -- know this part by (its puid and its reservation id)
            local fresh = p.spec and makePart(p.spec)
            if fresh then
                fresh.pid, fresh.id = p.pid, p.id
                stack.parts[i] = fresh
            else
                p.concealed = nil -- nothing to rebuild from; leave it prop-less
            end
        end
    end
end

local function relayout(stack)
    ApplyStackConceal(stack)
    layoutParts(stack.parts, stack.x, stack.y, stack.z0, #stack.parts == 1)
end

-- Walk a stack bottom→top with the EXACT maths layoutParts commits — each part's
-- height AND its manual sink (STACK_TWEAKS), clamp included — so anything derived
-- from a stack's top (snap previews, tooltip anchors) matches the placed result.
-- Returns the top z (where the next part rests) and the top part's actual seat.
local function stackWalkTop(stack)
    local z, prevSeat = stack.z0, nil
    for i, p in ipairs(stack.parts) do
        if i > 1 then z = math.max(z + (p.sink or 0.0), prevSeat + 0.001) end
        prevSeat = z
        z = z + (p.height or 0.0)
    end
    return z, prevSeat
end

-- World z of the top of a stack (where the next part rests).
local function stackTopZ(stack)
    local z = stackWalkTop(stack)
    return z
end

-- Where a carried pile's FIRST part seats when snapped onto stack `s`: the
-- stack's (sink-aware) top adjusted by that part's own manual sink, with the same
-- never-below-the-layer-under-it clamp layoutParts applies on commit — so the
-- drag preview sits exactly where release puts it, no hop.
local function stackSnapZ(s, first)
    local z0, prevSeat = stackWalkTop(s)
    local sink = first and first.sink or 0.0
    if sink == 0.0 or not prevSeat then return z0 end
    return math.max(z0 + sink, prevSeat + 0.001)
end

-- What a stack provides, as a component multiset (mirrors the server's
-- buildProvides): halves count as half their ingredient (rounded up), and a melt
-- topping riding a dual part counts as one component of its OWN item. The NUI
-- ranks recipes against this.
local function stackProvides(stack)
    local units = {}
    for _, p in ipairs(stack.parts) do
        local u = p.half and 0.5 or 1.0
        units[p.item] = (units[p.item] or 0) + u
        -- new parts carry `top` = { item, state }; a LEGACY part (numeric-only
        -- reservation) resolves its topping item from its rendered melt model
        local mi = p.top and p.top.item
        if not mi and p.meltModel then
            local ing = IngredientsByModel and IngredientsByModel[p.meltModel]
            mi = ing and ing.item
        end
        if mi then units[mi] = (units[mi] or 0) + 1 end
    end
    local out = {}
    for k, v in pairs(units) do out[k] = math.ceil(v) end
    return out
end

-- The Restaurant Bag's contents, aggregated across every pile sitting in it: a
-- compact list for its tooltip ({ item, label, image, qty }, insertion order) PLUS a
-- provides multiset ({ item = count }) the NUI ranks the craft catalogue against —
-- exactly like a stack's stackProvides drives the recipe guide. Labels/images ride
-- along when the part has them (pills do); the NUI fills the rest from its catalogue.
local function bagContents(tid)
    local order, byItem, provides = {}, {}, {}
    for _, stack in pairs(PrepStacks) do
        if stack.tid == tid then
            for _, p in ipairs(stack.parts) do
                provides[p.item] = (provides[p.item] or 0) + 1
                local row = byItem[p.item]
                if not row then
                    row = { item = p.item, label = p.label, image = p.image, qty = 0 }
                    byItem[p.item] = row
                    order[#order + 1] = row
                end
                row.qty = row.qty + 1
            end
        end
    end
    return order, provides
end

-- ─── serving tray helpers ────────────────────────────────────────────────────

-- The tray + paper models do NOT share the food props' centre-bottom origin, so
-- placing their raw origin on the surface sinks the tray below the drop point and
-- leaves the paper (offset from the origin, not the tray's real base) floating
-- above it. The physics box dips one ~0.04 margin below the true mesh bottom (see
-- modelHeight), so the true bottom sits at mn.z + margin — lifting the origin by
-- -(mn.z + margin) rests the mesh exactly ON the surface, whatever its origin.
local TRAY_PHYS_MARGIN = 0.04
local trayLiftCache = {}
-- (assigns the forward-declared local above — orientPart needs it)
function modelBaseLift(model)
    local v = trayLiftCache[model]
    if v then return v end
    local mn = GetModelDimensions((EnsureModel(model)))
    v = mn and -(mn.z + TRAY_PHYS_MARGIN) or 0.0
    trayLiftCache[model] = v
    return v
end

-- The serving tray and the pizza box share all the placement/pick machinery —
-- `kind` ("tray" | "box", nil = "tray") picks which pair of props and which
-- config drives the footprint maths.
-- Baking trays (cake tin / cookie tray) are FREE prep equipment like the serving
-- tray: a single container prop you drag onto the table, rub its baking mix
-- into (coverage accrues, the raw sheet fades in), then drag into the hotbar
-- to collect its oven-ready output. They live in PrepTrays keyed by their config
-- `kind` (from the synced Baking list's per-tool trays), so placement, hover,
-- outline and grab all reuse the tray machinery; food-drop and meal-making are
-- gated off (a bake tray never accepts loose food and never makes a meal — see
-- runDragThread / prepDrop).
local BAKEP = {
    food_dz   = 0.0,   -- raw sheet/dough lift above the tray bed. TUNE IN-GAME.
    rim_inset = 0.05,  -- (unused for food-drop, kept for trayCfg parity)
    pick_pad  = 0.03,  -- extra grab margin (m) around the tray footprint
    pick_dz   = 0.4,   -- max height diff between the cursor's surface hit and the tray
}
-- The synced tray entry for a kind, searched across EVERY fill tool (`Baking` is
-- a LIST of { mix_item, mix_model, rub_dist, trays }). Returns the tray entry
-- plus its owning tool; nil if it isn't a baking-tray kind.
local function bakeEntryFor(kind)
    if not kind then return nil end
    for _, b in ipairs(Baking or {}) do
        for _, t in ipairs(b.trays or {}) do
            if t.kind == kind then return t, b end
        end
    end
end
local function isBakeKind(kind) return bakeEntryFor(kind) ~= nil end
-- How many servings a baking tray holds: its config `slots`, else the bake recipe's
-- output_count (a cookie tray bakes into six), else one (a cake tin).
local function bakeSlotCount(kind)
    local be = bakeEntryFor(kind)
    if be and tonumber(be.slots) then return math.max(1, math.floor(tonumber(be.slots))) end
    local rec = be and be.output and RecipesByInput and RecipesByInput[be.output]
    if rec and tonumber(rec.output_count) then return math.max(1, math.floor(tonumber(rec.output_count))) end
    return 1
end

local function trayCfg(kind)
    if isBakeKind(kind) then return BAKEP end
    if isBagKind(kind) then return BAGP end
    if IsTakeoutKind(kind) then return TAKEP end
    return kind == "box" and BOXP or TRAYP
end
local function trayBaseModel(kind)
    local be = bakeEntryFor(kind)
    if be then return be.tray_model end
    if isBagKind(kind) then return BagModel or "pickle_restaurant_bag_01" end
    if IsTakeoutKind(kind) then return BoxBaseModel or "pickle_takeout_box_01" end
    return kind == "box" and BOXP.base_model or TRAYP.tray_model
end
-- The hinged LID model of a lid kind (nil for everything else).
function TrayLidModel(kind)
    if kind == "box" then return BOXP.lid_model end
    if IsTakeoutKind(kind) then return BoxLidModel or "pickle_takeout_box_02" end
end

-- Food rests on the paper liner (tray) / the box bed / the bag: bed height + a hair
-- so it doesn't z-fight the surface under it.
local function trayFoodDz(kind)
    local lc = LidCfg(kind)
    if lc then return lc.food_dz end
    if isBagKind(kind) then return BAGP.food_dz end
    if isBakeKind(kind) then
        -- A serving sits ON the container, not at the table: a tin/tray has a floor
        -- and walls of its own, so the container's height is part of the offset. The
        -- oven's batch render already worked this way (the container is the stack's
        -- base layer and the servings sit a container-height above it) while the prep
        -- tray seated them at the bare surface — which sank the cake batter inside
        -- the tin (it "filled" and showed nothing) and the cookies into the tray.
        -- `BAKEP.food_dz` stays the in-game trim on top of the measurement.
        local m = trayBaseModel(kind)
        return modelBaseLift(m) + modelHeight(m) + BAKEP.food_dz
    end
    return TRAYP.paper_dz + 0.002
end

-- Droppable half-extents from the tray/box model's bounds, inset past the rim so
-- anchored food reads as ON the paper / INSIDE the box (drop offsets are clamped
-- into this area).
local function trayHalfExtents(kind)
    local mn, mx = GetModelDimensions((EnsureModel(trayBaseModel(kind))))
    if not (mn and mx) then return 0.15, 0.10 end
    local inset = trayCfg(kind).rim_inset
    return math.max((mx.x - mn.x) * 0.5 - inset, 0.05),
           math.max((mx.y - mn.y) * 0.5 - inset, 0.05)
end

-- A pile's (dx, dy) on a tray is TRAY-LOCAL, and this turns it into world space
-- around the tray's own heading. It used to be recorded and applied in WORLD axes,
-- which worked by accident everywhere it was authored — a prep tray always sits at
-- the station's heading, so the frame never changed — and broke the moment the same
-- arrangement was drawn on another surface at another heading. Eating in was exactly
-- that: the meal was laid out on the diner's table in the PREP STATION's frame, so
-- the whole arrangement came out rotated by (diner - station), i.e. usually back to
-- front — the drink the cook set at the near-left showing up at the far-right.
-- A GLOBAL, not a `local function`: this chunk sits at Lua's 200-locals ceiling
-- (see ICE.seat), and modules/dining reads the pile anchors through here too.
-- `kind` (optional) CLAMPS the offset inside that tray's rim first. Pass it wherever
-- the numbers come from stored metadata rather than from a live drag: a meal crafted
-- before offsets became tray-local holds world-axis deltas, and read in the new frame
-- those can land a pile off the edge of the tray entirely. Clamping can't un-rotate
-- them, but it keeps every serving on the surface it belongs to.
function TrayOffsetWorld(x, y, dx, dy, yaw, kind)
    local hr = math.rad(yaw or 0.0)
    local cosH, sinH = math.cos(hr), math.sin(hr)
    dx, dy = dx or 0.0, dy or 0.0
    if kind then
        local hx, hy = trayHalfExtents(kind)
        dx = math.min(math.max(dx, -hx), hx)
        dy = math.min(math.max(dy, -hy), hy)
    end
    return x + dx * cosH - dy * sinH, y + dx * sinH + dy * cosH
end

-- Seat a hinged lid's ORIGIN (authored on its hinge edge): a fixed step forward
-- of the base's origin (cfg.lid_fwd) and cfg.lid_dz above it (the hinge sits on the
-- base's RIM, not its floor), along the BASE's yaw-only forward — never
-- the lid's own forward vector, which tips with its pitch mid-swing and would
-- drift the hinge. Position is set ONLY here, when the box is placed/moved;
-- opening and closing never touch it. Shared by the pizza box and the takeout box.
local function boxLidSeat(cfg, baseEnt, ent)
    cfg = cfg or BOXP
    if not (baseEnt and ent and DoesEntityExist(baseEnt) and DoesEntityExist(ent)) then return end
    local h = math.rad(GetEntityHeading(baseEnt))
    local dz = cfg.lid_dz or -0.005
    local coords = GetEntityCoords(baseEnt) + vector3(-math.sin(h) * cfg.lid_fwd, math.cos(h) * cfg.lid_fwd, dz)
    SetEntityCoordsNoOffset(ent, coords.x, coords.y, coords.z, false, false, false)
end

-- The lid's swing is ROTATION ONLY: the box's heading plus the opening pitch
-- (-open_deg * openT) about the lid's authored hinge origin.
local function boxLidSwing(cfg, baseEnt, ent, openT)
    cfg = cfg or BOXP
    if not (ent and DoesEntityExist(ent)) then return end
    local yaw = (baseEnt and DoesEntityExist(baseEnt)) and GetEntityHeading(baseEnt) or curYaw()
    SetEntityRotation(ent, cfg.open_deg * (openT or 0.0) * -1, 0.0, yaw, 2, true)
end

-- Seat a MADE takeout box (a prep part, not a placed vessel): base resting on the
-- surface, lid on its authored hinge held OPEN — the food image inside is the whole
-- point of the render — and the image quad (modules/quad) re-asserted on the base,
-- which follows it through every move, drag and tray layout. Attaching is
-- idempotent per url, so calling this each layout is free.
function SeatTakeoutPart(part, x, y, z, yaw)
    local b, lid = part.ents[1], part.ents[2]
    if b and DoesEntityExist(b) then
        SetEntityCoordsNoOffset(b, x, y, z + modelBaseLift(trayBaseModel("takeout")), false, false, false)
        SetEntityRotation(b, 0.0, 0.0, yaw or curYaw(), 2, true)
    end
    boxLidSeat(TAKEP, b, lid)
    boxLidSwing(TAKEP, b, lid, 1.0)
    if part.quad and b and QuadAttach then
        local q = Config.BoxQuad or {}
        QuadAttach(b, part.quad, { w = q.w or 0.295, h = q.h or 0.2, dz = q.dz or 0.012,
                                   crop = part.quadCrop })
    end
end

-- Seat a tray/box pair at surface point (x, y, z): the base's mesh bottom rests
-- ON the surface; a tray's paper lies on the tray bed (paper_dz above the base),
-- a box's lid seats on its hinge anchor and swings to opening fraction openT —
-- each prop corrected for its own origin offset.
-- `storedOffs` (optional) is the per-serving (dx, dy) list captured ONCE when the tray
-- was filled — reuse it so a grabbed/moved cookie tray keeps every cookie exactly where
-- it was, instead of re-deriving the grid each render (which drifts when the model's
-- bounds haven't streamed in yet, or the surviving prop count differs from the slot
-- count). Falls back to a fresh grid only for a tray that has no stored offsets.
local function layoutTrayAt(ents, x, y, z, kind, openT, storedOffs)
    local yaw = curYaw() -- faces the prep station, not the world axes
    if isBakeKind(kind) then
        -- container prop (ents[1]) + one serving prop per slot (ents[2..], present once
        -- filled) laid out as a grid ON the tray bed. All face the station.
        local base = ents and ents[1]
        if base and DoesEntityExist(base) then
            SetEntityCoordsNoOffset(base, x, y, z + modelBaseLift(trayBaseModel(kind)), false, false, false)
            SetEntityRotation(base, 0.0, 0.0, yaw, 2, true)
        end
        -- The stored offsets are the ones captured when the tray was filled; with
        -- none, derive them from the SAME function every other surface uses, measuring
        -- the serving off the prop actually being laid out.
        -- AUTHORED SEATS SKIP THE SNAPSHOT ENTIRELY: storedOffs exists because a DERIVED
        -- grid drifts (bounds that hadn't streamed, a differing prop count), and an
        -- authored list can't drift — so re-reading it is free, and it's what makes a
        -- seat edited in-game show up on the tray already sitting on the table.
        local baseModel = trayBaseModel(kind)
        local offs = (storedOffs and not BakeSlotsFor(baseModel)) and storedOffs
            or bakeGridOffsets(bakeSlotCount(kind), baseModel,
                (ents and ents[2] and DoesEntityExist(ents[2])) and GetEntityModel(ents[2]) or nil)
        local hr, fz = math.rad(yaw), z + trayFoodDz(kind)
        for i = 2, #(ents or {}) do
            local e = ents[i]
            local ofs = offs[i - 1] or { dx = 0.0, dy = 0.0 }
            if e and DoesEntityExist(e) then
                SetEntityCoordsNoOffset(e, x + ofs.dx * math.cos(hr) - ofs.dy * math.sin(hr),
                                           y + ofs.dx * math.sin(hr) + ofs.dy * math.cos(hr),
                                           fz, false, false, false)
                SetEntityRotation(e, 0.0, 0.0, yaw, 2, true)
            end
        end
        return
    end
    local lc = LidCfg(kind)
    if lc then
        local base = ents and ents[1]
        if base and DoesEntityExist(base) then
            SetEntityCoordsNoOffset(base, x, y, z + modelBaseLift(trayBaseModel(kind)), false, false, false)
            SetEntityRotation(base, 0.0, 0.0, yaw, 2, true)
        end
        boxLidSeat(lc, base, ents and ents[2])
        boxLidSwing(lc, base, ents and ents[2], openT)
        return
    end
    if isBagKind(kind) then
        -- one vessel prop; contents are ordinary PrepStacks piles seated on top
        local base = ents and ents[1]
        if base and DoesEntityExist(base) then
            SetEntityCoordsNoOffset(base, x, y, z + modelBaseLift(trayBaseModel(kind)), false, false, false)
            SetEntityRotation(base, 0.0, 0.0, yaw, 2, true)
        end
        return
    end
    local zs = {
        z + modelBaseLift(TRAYP.tray_model),
        z + TRAYP.paper_dz + modelBaseLift(TRAYP.paper_model),
    }
    for i, e in ipairs(ents or {}) do
        if e and DoesEntityExist(e) then
            SetEntityCoordsNoOffset(e, x, y, zs[i] or z, false, false, false)
            SetEntityRotation(e, 0.0, 0.0, yaw, 2, true)
        end
    end
end

local function spawnTrayEnts(x, y, z, kind, openT)
    if isBakeKind(kind) or isBagKind(kind) then
        local base = SpawnProp(trayBaseModel(kind), x, y, z)
        if not base then return nil end
        local ents = { base }
        layoutTrayAt(ents, x, y, z, kind, openT)
        return ents
    end
    local m1, m2 = TRAYP.tray_model, TRAYP.paper_model
    if LidCfg(kind) then m1, m2 = trayBaseModel(kind), TrayLidModel(kind) end
    local t = SpawnProp(m1, x, y, z)
    local p = SpawnProp(m2, x, y, z)
    if not t or not p then SafeDeleteEntity(t); SafeDeleteEntity(p); return nil end
    local ents = { t, p }
    layoutTrayAt(ents, x, y, z, kind, openT)
    return ents
end

-- Pickable half-extents: the WHOLE tray/box incl. the rim (physics margin
-- trimmed), plus a little grab padding — unlike trayHalfExtents, which is the
-- inner droppable area only.
local function trayPickExtents(kind)
    local mn, mx = GetModelDimensions((EnsureModel(trayBaseModel(kind))))
    if not (mn and mx) then return 0.25, 0.18 end
    local pad = trayCfg(kind).pick_pad
    return (mx.x - mn.x) * 0.5 - TRAY_PHYS_MARGIN + pad,
           (mx.y - mn.y) * 0.5 - TRAY_PHYS_MARGIN + pad
end

-- Vertical grab window: how far the cursor's surface hit may sit from the tray's
-- BASE z and still count as "over" it. Flat trays/boxes use their tuned pick_dz. The
-- Restaurant Bag is a TALL standing vessel, so its window must span the whole bag
-- height (base → mouth); with only the flat 0.4 window, aiming anywhere up the bag's
-- body lands the cursor ray on a surface well above the base and only the very bottom
-- registers. Derived from the live model so a swapped bag_model self-tunes.
local function trayPickDz(kind)
    local dz = trayCfg(kind).pick_dz
    if isBagKind(kind) then
        local mn, mx = GetModelDimensions((EnsureModel(trayBaseModel(kind))))
        if mn and mx then
            local h = (mx.z - mn.z) + 0.15   -- full bag height + a little reach past the mouth
            if h > dz then return h end
        end
    end
    return dz
end

-- The tray under the cursor: raycast the cursor to the surface (tray props have
-- collision off, so the ray lands right under the cursor) and test that world
-- point against each tray's rectangular footprint. A screen-radius test around
-- the centre only ever covered the middle of the tray (the paper), leaving the
-- rim un-grabbable. `coords` (optional) reuses a raycast the caller already did.
-- Parts win over trays — only consulted when no part is hovered.
local function pickTray(coords)
    if not coords then
        local hit, c = CursorToWorld()
        if not hit or not c then return nil end
        coords = c
    end
    local best, bd
    for tid, t in pairs(PrepTrays) do
        if math.abs(coords.z - t.z) <= trayPickDz(t.kind) then
            local hx, hy = trayPickExtents(t.kind)
            local dx, dy = coords.x - t.x, coords.y - t.y
            if math.abs(dx) <= hx and math.abs(dy) <= hy then
                local d2 = dx * dx + dy * dy
                if not bd or d2 < bd then best, bd = tid, d2 end
            end
        end
    end
    return best
end

-- Outline a tray (amber for hover, green for a drop target). nil clears.
local outlinedTid, outlinedTidRGB = nil, nil
local function setTrayOutline(tid, r, g, b)
    local rgb = tid and ((r or 80) .. "," .. (g or 200) .. "," .. (b or 120)) or nil
    if outlinedTid == tid and outlinedTidRGB == rgb then return end
    local old = outlinedTid and PrepTrays[outlinedTid]
    if old then for _, e in ipairs(old.ents) do
        if DoesEntityExist(e) then SetEntityDrawOutline(e, false) end end end
    outlinedTid, outlinedTidRGB = tid, rgb
    local new = tid and PrepTrays[tid]
    if new then for _, e in ipairs(new.ents) do
        if DoesEntityExist(e) then SetEntityDrawOutline(e, true); SetEntityDrawOutlineColor(r or 80, g or 200, b or 120, 255) end end end
end

-- Size-aware part picking: instead of one generous fixed screen radius, each
-- part is targeted within ITS OWN projected footprint — half its model's
-- horizontal extent (GetModelDimensions), projected at the part's distance from
-- the camera — so a small topping can't steal the cursor from half a table
-- away. pad/min are normalized-screen slack for thin/tiny props. TUNE IN-GAME.
local PART_PICK = { pad = 0.012, min = 0.025 }
local ModelHalfXY = {} -- [model hash] = half the larger horizontal extent (m)

local function modelHalfXY(hash)
    local r = ModelHalfXY[hash]
    if not r then
        local mn, mx = GetModelDimensions(hash)
        r = math.max(mx.x - mn.x, mx.y - mn.y) * 0.5
        ModelHalfXY[hash] = r
    end
    return r
end

-- A part's world pick radius: the widest of its rendered entities (a stacked
-- tower picks by its broadest layer). Cached on the part — its props never
-- change model after spawn.
local function partHalfXY(part)
    local r = part.pickR
    if r then return r end
    r = 0.03
    for _, e in ipairs(part.ents or {}) do
        if DoesEntityExist(e) then r = math.max(r, modelHalfXY(GetEntityModel(e))) end
    end
    part.pickR = r
    return r
end

-- A pile inside a CLOSED lidded box (pizza / takeout) is out of reach — the lid
-- has to swing open before its contents can be hovered, grabbed, or stacked onto.
local function stackSealed(stack)
    local t = stack.tid and PrepTrays[stack.tid]
    return (t and LidCfg(t.kind) and not t.open) and true or false
end

-- The placed part under the cursor, by screen proximity to each part's rendered
-- CENTRE (same projection the stovetop hover uses → lines up with the station
-- cam), within that part's own projected size. Returns sid, index, part.
-- `exceptSid` skips one stack (rarely needed).
local function pickPart(exceptSid)
    local cx, cy = GetNuiCursorPosition()
    local sw, sh = GetActiveScreenResolution()
    local cnx = (sw > 0) and (cx / sw) or 0.0
    local cny = (sh > 0) and (cy / sh) or 0.0
    local bsid, bidx, bpart, bd
    for sid, stack in pairs(PrepStacks) do
        -- concealed = inside a takeout box, so its props aren't drawn: never let the
        -- cursor pick something the player can't see (the box itself picks instead)
        if sid ~= exceptSid and not stackSealed(stack) and not stack.concealed then
            local z = stack.z0
            for i, part in ipairs(stack.parts) do
                local mz = z + (part.height or 0.0) * 0.5
                local on, sx, sy = GetScreenCoordFromWorldCoord(stack.x, stack.y, mz)
                if on then
                    -- project the part's world radius to a screen radius: how far
                    -- (on screen) a point one radius above the centre lands
                    local rw = partHalfXY(part)
                    local R = PART_PICK.min
                    local on2, sx2, sy2 = GetScreenCoordFromWorldCoord(stack.x, stack.y, mz + rw)
                    if on2 then
                        local rx, ry = sx2 - sx, sy2 - sy
                        R = math.max(math.sqrt(rx * rx + ry * ry) + PART_PICK.pad, PART_PICK.min)
                    end
                    local dx, dy = sx - cnx, sy - cny
                    local d2 = dx * dx + dy * dy
                    if d2 <= R * R and (not bd or d2 < bd) then bd, bsid, bidx, bpart = d2, sid, i, part end
                end
                z = z + (part.height or 0.0)
            end
        end
    end
    return bsid, bidx, bpart
end

-- Locate a part by its stable id: returns sid, index, part.
local function findPart(pid)
    for sid, stack in pairs(PrepStacks) do
        for i, part in ipairs(stack.parts) do
            if part.pid == pid then return sid, i, part end
        end
    end
end

-- Outline a whole stack (amber for hover, green for a drop target). nil clears.
local outlinedSid, outlinedRGB = nil, nil
local function setOutline(sid, r, g, b)
    local rgb = sid and ((r or 80) .. "," .. (g or 200) .. "," .. (b or 120)) or nil
    if outlinedSid == sid and outlinedRGB == rgb then return end
    local old = outlinedSid and PrepStacks[outlinedSid]
    if old then for _, p in ipairs(old.parts) do for _, e in ipairs(p.ents) do
        if DoesEntityExist(e) then SetEntityDrawOutline(e, false) end end end end
    outlinedSid, outlinedRGB = sid, rgb
    local new = sid and PrepStacks[sid]
    if new then for _, p in ipairs(new.parts) do for _, e in ipairs(p.ents) do
        if DoesEntityExist(e) then SetEntityDrawOutline(e, true); SetEntityDrawOutlineColor(r or 80, g or 200, b or 120, 255) end end end end
end

local function removePrepStack(sid)
    local stack = PrepStacks[sid]; if not stack then return end
    deleteParts(stack.parts)
    PrepStacks[sid] = nil
end

local function removePrepTray(tid)
    local t = PrepTrays[tid]; if not t then return end
    for _, e in ipairs(t.ents) do SafeDeleteEntity(e) end
    PrepTrays[tid] = nil
end

-- Swing a placed lidded box's lid open/closed (pizza box / takeout box): eased
-- hinge rotation over the kind's open_ms (never a pop). Re-toggling mid-swing bumps
-- animSeq so the old thread yields and the new swing picks up from the current
-- angle; grabbing or removing the box kills the thread via the PrepTrays identity
-- check.
local function setBoxOpen(tid, open)
    local t = PrepTrays[tid]
    local cfg = t and LidCfg(t.kind)
    if not cfg or t.open == open then return end
    t.open = open
    t.animSeq = (t.animSeq or 0) + 1
    local seq = t.animSeq
    CreateThread(function()
        local from = t.openT or (open and 0.0 or 1.0)
        local to = open and 1.0 or 0.0
        local t0 = GetGameTimer()
        while PrepTrays[tid] == t and t.animSeq == seq do
            local k = math.min((GetGameTimer() - t0) / cfg.open_ms, 1.0)
            k = k * k * (3.0 - 2.0 * k) -- smoothstep ease in-out
            t.openT = from + (to - from) * k
            boxLidSwing(cfg, t.ents and t.ents[1], t.ents and t.ents[2], t.openT)
            if k >= 1.0 then break end
            Wait(0)
        end
    end)
end

-- How many parts sit on a tray / inside a box (the tooltip count and the box's
-- one-pizza occupancy check).
local function trayPileCount(tid)
    local n = 0
    for _, s in pairs(PrepStacks) do if s.tid == tid then n = n + #s.parts end end
    return n
end

-- What the box accepts: the carried pile's BOTTOM layer must render one of the
-- synced BoxBaseModels (box_base ingredients + their linked recipes' raw/cooked/
-- burnt models). Matched by MODEL so every cook state qualifies — the raw base
-- component, an assembled uncooked pile, and a cooked/burnt one all base on a
-- boxable prop (the server re-validates by item on make). The hash set is built
-- lazily and rebuilt whenever the sync bumps ConfigGen.
local boxable = { set = nil, gen = nil } -- cached hash set + the ConfigGen it was built at
local function partsAreBoxable(parts)
    if not boxable.set or boxable.gen ~= ConfigGen then
        boxable.set, boxable.gen = {}, ConfigGen
        for _, m in ipairs(BoxBaseModels or {}) do boxable.set[GetHashKey(m)] = true end
    end
    local p = parts and parts[1]
    local e = p and p.ents and p.ents[1]
    return (e and DoesEntityExist(e) and boxable.set[GetEntityModel(e)]) and true or false
end

-- Delete a prep drag's props — the carried parts plus, for a tray drag (a grabbed
-- tray / a meal being set down), the tray + paper pair riding along.
local function deleteDrag(drag)
    if not drag then return end
    deleteParts(drag.parts)
    for _, e in ipairs(drag.tray or {}) do SafeDeleteEntity(e) end
end

-- Drop an in-progress finish-tool drag: the tube and every partially-faded result
-- ghost go away. Nothing was consumed (consumption only happens at full coverage),
-- so coverage simply resets with the drag.
local function cancelFinish()
    local f = finishing; finishing = nil
    if not f then return end
    SafeDeleteEntity(f.tube)
    for _, g in pairs(f.ghosts or {}) do SafeDeleteEntity(g.ent) end
end

-- Drop an in-progress baking-mix drag: the mix bowl and every partially-faded raw
-- sheet ghost go away. Nothing was consumed (a tray only fills at full coverage), so
-- the target trays stay empty.
local function cancelBakeMix()
    local f = bakeMixing; bakeMixing = nil
    if not f then return end
    SafeDeleteEntity(f.prop)
    for _, g in pairs(f.ghosts or {}) do
        for _, e in ipairs(g.ents or {}) do SafeDeleteEntity(e) end
    end
    setTrayOutline(nil)
end

-- Drop an in-progress condiment-bottle drag: the container and any faded sauce ghost
-- go away. Nothing was reserved until the squeeze completes, so this is a clean reset.
local function cancelCondiment()
    local c = condimenting; condimenting = nil
    if not c then return end
    SafeDeleteEntity(c.container)
    if c.ghost then SafeDeleteEntity(c.ghost) end
    setOutline(nil)
end

-- Group carried parts into piles by their (dx, dy) tray offset — consecutive
-- parts at the same spot stack bottom-to-top, mirroring how the meal was built.
local function groupPiles(parts)
    local piles = {}
    for _, p in ipairs(parts) do
        local dx, dy = tonumber(p.dx) or 0.0, tonumber(p.dy) or 0.0
        local last = piles[#piles]
        if last and math.abs(last.dx - dx) < 0.001 and math.abs(last.dy - dy) < 0.001 then
            last.parts[#last.parts + 1] = p
        else
            piles[#piles + 1] = { dx = dx, dy = dy, parts = { p } }
        end
    end
    return piles
end

-- Lay a carried tray/box (+ its piles) at a world point — the live preview while
-- a meal / a grabbed tray follows the cursor.
local function layoutTrayGroup(drag, x, y, z)
    layoutTrayAt(drag.tray, x, y, z, drag.trayKind, drag.openT, drag.trayOffs)
    local fz = z + trayFoodDz(drag.trayKind)
    for _, pile in ipairs(drag.piles or {}) do
        local px, py = TrayOffsetWorld(x, y, pile.dx, pile.dy, curYaw())
        layoutParts(pile.parts, px, py, fz, false)
    end
end

-- Commit a carried tray/box group: (re)create it at (x, y, z) and one stack per
-- pile, anchored at its offset. Used by the meal un-make drop and a tray move.
local function commitTrayGroup(x, y, z, ents, piles, kind, open, extra)
    prepTid = prepTid + 1
    local tid = prepTid
    kind = kind or "tray"
    local isBox = LidCfg(kind) ~= nil -- a lidded vessel remembers its lid state
    PrepTrays[tid] = { x = x, y = y, z = z, kind = kind, ents = ents,
                       open = isBox and (open and true or false) or nil,
                       openT = isBox and (open and 1.0 or 0.0) or nil }
    -- Baking trays carry their fill state + output item so a move preserves them and
    -- a grab knows whether there's anything to collect. A fresh placement has none.
    if isBakeKind(kind) then
        local be = bakeEntryFor(kind)
        PrepTrays[tid].output   = (extra and extra.output) or (be and be.output)
        PrepTrays[tid].rawModel = be and be.raw_model
        PrepTrays[tid].filled   = (extra and extra.filled) and true or false
        -- carry the persisted per-cookie offsets across the move so nothing re-grids
        PrepTrays[tid].offs     = extra and extra.offs or nil
    end
    layoutTrayAt(ents, x, y, z, kind, open and 1.0 or 0.0, extra and extra.offs)
    local fz = z + trayFoodDz(kind)
    for _, pile in ipairs(piles or {}) do
        prepSid = prepSid + 1
        local sx, sy = TrayOffsetWorld(x, y, pile.dx, pile.dy, curYaw(), kind)
        local stack = { x = sx, y = sy, z0 = fz,
                        tid = tid, dx = pile.dx, dy = pile.dy, parts = pile.parts }
        PrepStacks[prepSid] = stack
        relayout(stack)
    end
    return tid
end

-- The stacks sitting on a tray, as the make-meal payload: each pile's reserved
-- part ids (bottom-to-top) + its offset, sorted deterministically so the same
-- arrangement always produces the same meal signature.
local function collectTrayPiles(tid)
    local piles = {}
    for sid, s in pairs(PrepStacks) do
        if s.tid == tid then
            local ids = {}
            for _, p in ipairs(s.parts) do if p.id then ids[#ids + 1] = p.id end end
            if #ids > 0 then piles[#piles + 1] = { sid = sid, ids = ids, dx = s.dx or 0.0, dy = s.dy or 0.0 } end
        end
    end
    table.sort(piles, function(a, b)
        if math.abs(a.dx - b.dx) > 0.0005 then return a.dx < b.dx end
        return a.dy < b.dy
    end)
    return piles
end

-- Turn a placed tray's / box's arrangement into ONE meal item (the server
-- consumes the reserved parts and records each layer's offset; a box flags the
-- meal so it sets back down as its box). On success the tray and its stacks are
-- torn down. Returns the server result, or nil for an empty tray.
-- The make callback for a piece of equipment: a TAKEOUT BOX creates the bag-kind
-- food its contents match (server-side); a RESTAURANT BAG packs its contents into
-- ONE takeaway bag; a serving tray / pizza box makes a meal. All take the same
-- { items } payload of reserved pile ids.
local function trayMakeCallback(kind)
    if IsTakeoutKind(kind) then return "pickle_restaurants:cooking:prepMakeBox" end
    if isBagKind(kind) then return "pickle_restaurants:cooking:prepMakeBag" end
    return "pickle_restaurants:cooking:prepMakeMeal"
end

local function makeMealFromTray(tid, silent)
    local t = PrepTrays[tid]; if not t then return nil end
    local piles = collectTrayPiles(tid)
    if #piles == 0 then return nil end
    local items = {}
    for _, p in ipairs(piles) do items[#items + 1] = { ids = p.ids, dx = p.dx, dy = p.dy } end
    local res = lib.callback.await(trayMakeCallback(t.kind), false,
        { items = items, box = (t.kind == "box") or nil })
    if res and res.ok then
        for _, p in ipairs(piles) do removePrepStack(p.sid) end
        removePrepTray(tid)
        if not silent and res.label then ShowNotification(_L("cook_made", res.label)) end
    elseif not silent and res and res.error then
        ShowNotification(res.error)
    end
    return res
end

local function clearPrepStacks()
    setOutline(nil)
    setTrayOutline(nil)
    if prepDrag then deleteDrag(prepDrag); prepDrag = nil end
    for sid in pairs(PrepStacks) do removePrepStack(sid) end
    for tid in pairs(PrepTrays) do removePrepTray(tid) end
    PrepStacks = {}
    prepHovered = nil
    trayHovered = nil
end

-- The drag loop shared by placing (new parts from the bar) and moving (parts
-- lifted off a stack): follow the cursor — snap onto the stack under it, anchor
-- onto the serving tray under it (free 2D placement on the paper), else a new
-- stack at the cursor world point — and lay the carried parts flush on top.
-- A tray drag (drag.tray: a grabbed tray or a meal being set down) is free
-- placement only: trays never stack onto piles or other trays.
local function runDragThread(drag)
    -- A DRINK is a finished serving, not a build layer: it never stacks onto a pile
    -- and nothing ever stacks onto it. Without this a capped cup could be dropped
    -- on top of a burger and be recorded as one of ITS layers when the meal was
    -- made — a burger "containing" a cola. Blocked here, in the ONE place the drop
    -- target is decided, so every release path (place / decompose / restack) reads
    -- an already-refused target rather than each re-checking. Drinks still go down
    -- beside a build, and onto a tray or into a bag, as their own pile.
    local carryDrink = false
    for _, p in ipairs(drag.parts or {}) do
        if p.item == ServingItem then carryDrink = true break end
    end
    local function stackHasDrink(stack)
        for _, p in ipairs((stack and stack.parts) or {}) do
            if p.item == ServingItem then return true end
        end
        return false
    end
    CreateThread(function()
        while prepDrag == drag do
            local hit, coords = CursorToWorld()
            if drag.tray then
                if hit and coords then
                    drag.hit, drag.coords = true, { x = coords.x, y = coords.y, z = coords.z }
                    layoutTrayGroup(drag, coords.x, coords.y, coords.z)
                else
                    drag.hit = false
                end
                Wait(0)
            else
                -- Over a SERVING TRAY or a BAG, every drop is its OWN pile — never an
                -- addition to whatever is already sitting there. Arranging a meal is
                -- laying things out side by side, but the pile pick is a generous
                -- screen-space radius (deliberately, so a build reads as one target),
                -- and on a tray with anything on it that radius swallowed nearly
                -- every drop into the nearest existing pile. So the pile pick is
                -- SKIPPED over those two surfaces and the tray branch below seats the
                -- drop at the cursor's own offset. Boxes are unaffected — they seat
                -- their single item centrally and gate on their own rules.
                local overTid = (hit and coords) and pickTray(coords) or nil
                local loose = overTid and PrepTrays[overTid]
                    and (PrepTrays[overTid].kind == "tray" or PrepTrays[overTid].kind == "bag")
                local sid = (not loose) and pickPart(nil) or nil
                -- a drink in either hand kills the stack target (see carryDrink above)
                if sid and (carryDrink or stackHasDrink(PrepStacks[sid])) then sid = nil end
                local tid = (not sid) and overTid or nil
                drag.boxBlock = nil
                if sid then
                    local s = PrepStacks[sid]
                    local z0 = stackSnapZ(s, drag.parts[1]) -- sink applies in the preview too
                    drag.hit, drag.targetSid, drag.targetTid, drag.coords = true, sid, nil, { x = s.x, y = s.y, z = z0 }
                    setOutline(sid, 80, 200, 120)
                    setTrayOutline(nil)
                    layoutParts(drag.parts, s.x, s.y, z0, false)
                elseif tid and hit and coords and PrepTrays[tid].kind == "box" then
                    -- over a box: it takes exactly ONE boxable pile — lid open, box
                    -- empty, and the carried pile sitting on a boxable base (any cook
                    -- state). A qualifying drop seats it in the CENTRE of the box;
                    -- anything else outlines the box red and refuses on release.
                    local t = PrepTrays[tid]
                    local block
                    if not t.open then block = _L("cook_open_box_first")
                    elseif trayPileCount(tid) > 0 then block = _L("cook_box_occupied")
                    elseif not partsAreBoxable(drag.parts) then block = _L("cook_only_boxable_in_box")
                    end
                    if block then
                        drag.hit, drag.targetSid, drag.targetTid = true, nil, nil
                        drag.coords = { x = coords.x, y = coords.y, z = coords.z }
                        drag.boxBlock = block
                        setOutline(nil)
                        setTrayOutline(tid, 230, 70, 70)
                        layoutParts(drag.parts, coords.x, coords.y, coords.z, false)
                    else
                        local fz = t.z + trayFoodDz("box")
                        drag.hit, drag.targetSid, drag.targetTid = true, nil, tid
                        drag.coords = { x = t.x, y = t.y, z = fz, dx = 0.0, dy = 0.0 }
                        setOutline(nil)
                        setTrayOutline(tid, 80, 200, 120)
                        layoutParts(drag.parts, t.x, t.y, fz, false)
                    end
                elseif tid and hit and coords and (PrepTrays[tid].kind == "tray" or PrepTrays[tid].kind == "bag"
                                                   or IsTakeoutKind(PrepTrays[tid].kind)) then
                    -- over a SERVING tray, a RESTAURANT BAG or a TAKEOUT BOX: anchor to
                    -- it where the cursor points, clamped inside the rim; release starts
                    -- a new pile at that exact offset. (Baking trays never accept loose
                    -- food — they fall through to plain table placement below.) A takeout
                    -- box only accepts food through an OPEN lid, like the pizza box.
                    local t = PrepTrays[tid]
                    if IsTakeoutKind(t.kind) and not t.open then
                        -- closed takeout box: nothing gets in — refuse (red) like the
                        -- pizza box does, and drop on the table instead of into it
                        drag.hit, drag.targetSid, drag.targetTid = true, nil, nil
                        drag.coords = { x = coords.x, y = coords.y, z = coords.z }
                        drag.boxBlock = _L("cook_open_box_first")
                        setOutline(nil)
                        setTrayOutline(tid, 230, 70, 70)
                        layoutParts(drag.parts, coords.x, coords.y, coords.z, false)
                    else
                        -- Offsets are TRAY-LOCAL (see TrayOffsetWorld): rotate the
                        -- cursor's world delta into the tray's frame, clamp it against
                        -- the tray's own half-extents there (which is what those
                        -- extents describe), then rotate back for the world position.
                        local hx, hy = trayHalfExtents(t.kind)
                        local hr = math.rad(curYaw())
                        local wx, wy = coords.x - t.x, coords.y - t.y
                        local dx = math.min(math.max(wx * math.cos(hr) + wy * math.sin(hr), -hx), hx)
                        local dy = math.min(math.max(-wx * math.sin(hr) + wy * math.cos(hr), -hy), hy)
                        local fz = t.z + trayFoodDz(t.kind)
                        local px, py = TrayOffsetWorld(t.x, t.y, dx, dy, curYaw())
                        drag.hit, drag.targetSid, drag.targetTid = true, nil, tid
                        drag.coords = { x = px, y = py, z = fz, dx = dx, dy = dy }
                        setOutline(nil)
                        setTrayOutline(tid, 80, 200, 120)
                        layoutParts(drag.parts, drag.coords.x, drag.coords.y, fz, false)
                    end
                elseif hit and coords then
                    drag.hit, drag.targetSid, drag.targetTid, drag.coords = true, nil, nil, { x = coords.x, y = coords.y, z = coords.z }
                    setOutline(nil)
                    setTrayOutline(nil)
                    layoutParts(drag.parts, coords.x, coords.y, coords.z, #drag.parts == 1)
                else
                    drag.hit = false
                end
                Wait(0)
            end
        end
        setOutline(nil)
        setTrayOutline(nil)
    end)
end

local stoppingCooking = false -- re-entrancy latch: the teardown below yields

local function StopCooking()
    -- The fade wait and the prep auto-save awards below all yield with
    -- cookingOpen still true — a second close (double ESC, a force-close event
    -- landing mid-fade) must not run the teardown concurrently.
    if stoppingCooking then return end
    stoppingCooking = true
    local closedProp = currentCookProp
    local wasVirtual = closedProp and closedProp.virtual
    local wasPrep = currentCookProp and currentCookProp.prop_type == "kitchen_prep"
    -- Leaving a virtual point: everything below (prep auto-save roundtrips, the
    -- camera easing back to the player) happens behind a faded screen; the
    -- virtual module tears the shell down and fades back in when it's gone.
    if wasVirtual then
        DoScreenFadeOut(VirtualFadeMs and VirtualFadeMs() or 400)
        while not IsScreenFadedOut() do Wait(0) end
    end
    -- Deliver completed work on the way out: each stack still on the table is saved as
    -- its closest product (the exact variation preserved). Stacks that form no product
    -- fall through to prepClose below, which drops their reservations — parts stay in
    -- the player's holdings, so nothing is lost either way.
    if wasPrep then
        -- Serving trays first: each arrangement becomes its meal (a failed make
        -- leaves its stacks behind for the per-stack save below; empty trays are
        -- just put away by clearPrepStacks).
        for tid in pairs(PrepTrays) do makeMealFromTray(tid, true) end
        for _, stack in pairs(PrepStacks) do
            local ids = {}
            for _, p in ipairs(stack.parts) do if p.id then ids[#ids + 1] = p.id end end
            if #ids > 0 then
                lib.callback.await("pickle_restaurants:cooking:prepSaveStack", false, { ids = ids })
            end
        end
    end
    cookingOpen = false
    currentCookProp = nil
    cancelPlace() -- drop any in-progress placement preview
    cancelMove()  -- drop any in-progress drag of a placed prop
    cancelFinish() -- drop any in-progress finish-tool (frosting) drag
    cancelBakeMix() -- drop any in-progress baking-mix drag
    cancelCondiment() -- drop any in-progress condiment-bottle drag
    HoverDual(nil)
    if HoverOvenDoor then HoverOvenDoor(nil, nil) end -- clear any door outline
    clearPrepStacks()
    if wasPrep then TriggerServerEvent("pickle_restaurants:cooking:prepClose") end -- drop unfinished build
    StopStationCamera()
    -- Unconditional: it is a no-op when nothing is posed, so no exit path (ESC, a
    -- fire ejecting the cook, a virtual shell changing) has to know whether this
    -- station had one — and every one of them has to take the scenario's props away.
    if StopStovetopPose then StopStovetopPose() end
    CloseNUI()
    SendNUIMessage({ action = "cookingItems", items = {} })
    -- free the exclusive station claim (physical and virtual alike)
    if closedProp then TriggerServerEvent("pickle_restaurants:cooking:closeStation", closedProp.id) end
    if wasVirtual and OnVirtualStationClosed then OnVirtualStationClosed(closedProp) end
    stoppingCooking = false
end

-- for other modules (virtual points force-close when their point/shell changes)
function ForceStopCooking() if cookingOpen then StopCooking() end end

-- Which station is open right now (nil = none). Lets another module close THIS
-- station without closing whatever the player happens to be at — modules/cookfx
-- throws the cook out when the station they're standing at catches fire.
function CookingStationId()
    return (cookingOpen and currentCookProp) and currentCookProp.id or nil
end

-- ESC/Backspace out of the station. Read by the shared per-frame reader in
-- modules/interactive (which also keeps the key away from the pause menu), so the
-- station's own slower hover tick can't swallow the press. Registered a frame late:
-- the module glob loads `cooking` before `interactive`, so the setter doesn't exist
-- yet at chunk time.
CreateThread(function()
    Wait(0)
    SetEscapeHandler("cooking", function() if cookingOpen then StopCooking() end end)
end)
function IsCookingOpen() return cookingOpen end

function OpenCookingStation(prop)
    if cookingOpen then return end
    -- Exclusive use: one player per station entity at a time, server-arbitrated.
    -- Virtual sessions already hold their claim (OpenVirtualStation takes it
    -- before fading), so don't spend a second roundtrip re-claiming.
    if not prop.virtual then
        local claim = lib.callback.await("pickle_restaurants:cooking:openStation", false, { prop_id = prop.id })
        if not (claim and claim.ok) then
            return ShowNotification((claim and claim.error) or _L("cook_station_busy"))
        end
        if cookingOpen then -- re-check: the await yielded, another open may have won
            if not (currentCookProp and currentCookProp.id == prop.id) then
                TriggerServerEvent("pickle_restaurants:cooking:closeStation", prop.id)
            end
            return
        end
    end
    currentCookProp = prop
    cookingOpen = true
    StartStationCamera(prop)
    -- The cook is hidden in their OWN shot but not in anyone else's: pose them at the
    -- cooktop (modules/stovetop) so the kitchen looks worked rather than stood in.
    -- Physical stations only — a virtual session leaves the ped standing wherever it
    -- really is, and a BBQ mimed in the street is worse than no pose at all.
    if prop.prop_type == "stovetop" and not prop.virtual and StartStovetopPose then
        StartStovetopPose()
    end
    -- We may already be holding a MIRROR of this prep table (we were standing near it
    -- while someone else worked it, and a station is handed on the moment they leave).
    -- Ours are about to be the real props, so drop the picture or the two sets sit in
    -- the same place fighting each other. Same on the seat side when a diner sits.
    if DropMirror then DropMirror(prop.id) end
    local ing = lib.callback.await("pickle_restaurants:cooking:getIngredients", false, { prop_id = prop.id })
    local rest = Restaurants[prop.restaurant_id]
    OpenNUI("cooking", { station = prop.prop_type, restaurantId = prop.restaurant_id, ingredients = ing, theme = rest and rest.theme or nil })
    RefreshTray()

    -- The prep tooltip ranks the player's stacks against the full recipe
    -- catalogue (output + component labels/images), fetched once on open.
    if prop.prop_type == "kitchen_prep" then
        local recipes = lib.callback.await("pickle_restaurants:cooking:getRecipes", false, { prop_id = prop.id })
        SendNUIMessage({ action = "cookingRecipes", recipes = recipes or {} })
        -- The Restaurant Bag tooltip ranks its contents against the CRAFT catalogue
        -- the same way stacks rank against recipes — fetched once on open.
        local crafts = lib.callback.await("pickle_restaurants:cooking:getCrafts", false, { prop_id = prop.id })
        SendNUIMessage({ action = "cookingCrafts", crafts = crafts or {} })
    end

    -- per-frame projection of every world food prop -> NUI chip positions, the
    -- live cook-status for each, and which one the cursor is hovering (so the NUI
    -- can show its status panel and start a drag on it).
    CreateThread(function()
        local HOVER_R = 0.06 -- normalized-screen radius that counts as hovering an item
        while cookingOpen do
            local items = {}
            local now = GetGameTimer()
            -- cursor in normalized (0-1) screen space, for proximity hit-testing
            local cx, cy = GetNuiCursorPosition()
            local sw, sh = GetActiveScreenResolution()
            local cnx = (sw > 0) and (cx / sw) or 0.0
            local cny = (sh > 0) and (cy / sh) or 0.0
            local nearUid, nearDist = nil, nil
            for uid, ent in pairs(CookObjects) do
                if DoesEntityExist(ent) then
                    local coords = GetEntityCoords(ent)
                    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
                    local rec = CookDual[uid]
                    if rec then
                        local prog  = rec.prog or {}
                        local cookS = prog.cooking or 1
                        local psides = prog.sides or {}
                        local function sideOut(s)
                            local sd = psides[s] or {}
                            local state = sd.state or rec.sides[s] or "raw"
                            local total = sd.total or 0
                            -- only the grill side keeps counting up; the other is frozen
                            local elapsed = (sd.elapsed or 0) + ((s == cookS) and (now - (prog.start or now)) or 0)
                            local percent = 0.0
                            if state == "burnt" then percent = 1.0
                            elseif total > 0 then percent = math.min(1.0, elapsed / total) end
                            return { state = state, percent = percent, cooking = (s == cookS) }
                        end
                        items[#items + 1] = {
                            uid = uid, dual = true, onScreen = onScreen, x = sx, y = sy,
                            sides = { sideOut(1), sideOut(2) }, cooking = cookS,
                            topping = prog.topping,
                            give = prog.give, giveLabel = prog.giveLabel, giveImage = prog.giveImage,
                        }
                    elseif CookSlot[uid] then
                        -- oven/fryer/soda item: single gated timeline; count up locally
                        -- only while the gate is open (door closed / basket down / tap
                        -- pouring).
                        local pr = CookProg[uid]
                        local pg = (pr and pr.prog) or {}
                        local st = pg.state or CookState[uid] or "raw"
                        local total = pg.total or 0
                        local elapsed = (pg.elapsed or 0) + ((pg.gate and pr and pr.start) and (now - pr.start) or 0)
                        local percent = 0.0
                        if st == "burnt" then percent = 1.0 elseif total > 0 then percent = math.min(1.0, elapsed / total) end
                        local slot = CookSlot[uid]
                        -- a poured cup's bar reads full even though no timer is running
                        if slot.method == "soda" and (st == "filled" or st == "capped") then percent = 1.0 end
                        items[#items + 1] = {
                            uid = uid, single = true, onScreen = onScreen, x = sx, y = sy,
                            method = slot.method, state = st, percent = percent,
                            gate = pg.gate and true or false,
                            ice = pg.ice or nil, needLid = pg.needLid or nil,
                            burningSoon = (slot.method ~= "soda" and st == "cooked" and percent > 0.66),
                            -- a fry in a lowered basket / a cup mid-pour can't be
                            -- grabbed — the NUI refuses to even start the drag
                            locked = ((slot.method == "fry" and slotDown(slot.propId, slot.slot))
                                   or (slot.method == "soda" and st == "filling")) or nil,
                            give = pr and pr.give, giveLabel = pr and pr.giveLabel, giveImage = pr and pr.giveImage,
                        }
                    else
                        items[#items + 1] = { uid = uid, onScreen = onScreen, x = sx, y = sy,
                                              state = CookState[uid] or "raw" }
                    end
                    -- props have collision off, so a shape-test ray can't hit them;
                    -- pick the item nearest the cursor on screen.
                    --
                    -- HIT-TEST THE ITEM'S MIDDLE, not its origin. These models are
                    -- bottom-origin, so projecting `coords` puts the target on the FLOOR
                    -- of the item: fine for a flat patty, wrong for anything tall — a
                    -- fountain cup only answered the cursor down at its base while the
                    -- body of it read as empty space. The chip anchor below deliberately
                    -- keeps the origin projection (`sx`,`sy`); only the pick moves.
                    local hz = coords.z + hoverHalfHeight(ent)
                    local onHit, hx, hy = GetScreenCoordFromWorldCoord(coords.x, coords.y, hz)
                    if onHit then
                        local dx, dy = hx - cnx, hy - cny
                        local d2 = dx * dx + dy * dy
                        if not nearDist or d2 < nearDist then nearDist, nearUid = d2, uid end
                    end
                end
            end
            local hoveredUid = (nearDist and nearDist <= HOVER_R * HOVER_R) and nearUid or nil

            -- Kitchen prep: find the placed part under the cursor (to grab + restack)
            -- and outline its stack (amber). Suppressed while dragging. The hovered
            -- stack also drives the recipe tooltip: its provides multiset + a screen
            -- anchor at the top of the pile.
            local prepHoverPid = nil
            local prepTip = nil
            local prepHoverTid = nil
            local prepHoverBox = false -- the hovered tray is a pizza box (click = lid toggle)
            if currentCookProp and currentCookProp.prop_type == "kitchen_prep" and not prepDrag and not finishing and not bakeMixing then
                local sid, _, part = pickPart(nil)
                local stack = sid and PrepStacks[sid]
                -- A pile sitting ON a serving tray offers only the tray-level "Make
                -- Meal", never a per-stack product make — so hovering it shows the
                -- tray tooltip, not the recipe-make one.
                local onTrayTid = (stack and stack.tid and PrepTrays[stack.tid]) and stack.tid or nil
                -- A pile INSIDE a pizza box belongs to the BOX: hovering it hovers
                -- the box (click = lid toggle, drag = the whole box; the tooltip's
                -- Take Out is how the pizza leaves) — so the part-grab is
                -- suppressed. Serving-tray piles stay directly grabbable.
                local inBox = onTrayTid and PrepTrays[onTrayTid].kind == "box"
                if part and not inBox then prepHoverPid = part.pid end
                setOutline((not inBox) and sid or nil, 255, 180, 40)
                if stack and not onTrayTid then
                    local on, sx, sy = GetScreenCoordFromWorldCoord(stack.x, stack.y, stackTopZ(stack))
                    prepTip = { sid = sid, onScreen = on, x = sx, y = sy, provides = stackProvides(stack) }
                    -- A MADE takeout box set back down on the prep table is one opaque
                    -- PRODUCT, not a build: it satisfies no recipe, so the recipe guide
                    -- had nothing to rank and the tooltip never appeared at all. Name it
                    -- instead — the food it holds, with its own art — so a box on the
                    -- table can still be identified before it's picked up.
                    if part and part.takeout then
                        prepTip.product = { label = part.label, image = part.itemImage }
                    elseif part then
                        -- ANY made product has the same problem, not just a boxed one: a
                        -- finished sandwich standing on the table is a component of
                        -- nothing, so the recipe guide ranks zero recipes and the tooltip
                        -- stays hidden — the food goes silent the moment it's made. Send
                        -- the hovered part's item and let the NUI name it from the recipe
                        -- catalogue it already holds (labels + art + what it's made of).
                        -- the pid too: the cursor leaves the prop to reach the tooltip,
                        -- so its Disassemble button has to address the part by id
                        -- rather than by whatever happens to be hovered when it's clicked
                        prepTip.item, prepTip.puid = part.item, part.pid
                    end
                end
                -- The serving tray's "Make Meal" / pizza box's "Box It Up" tooltip:
                -- shown when the cursor is over the tray/box itself OR over any pile
                -- arranged on it. Counts everything on/in it; a box also reports its
                -- lid state (the NUI turns a click on it into a lid toggle).
                prepHoverTid = onTrayTid or ((not sid) and pickTray()) or nil
                setTrayOutline(prepHoverTid, 255, 180, 40)
                if prepHoverTid then
                    local t = PrepTrays[prepHoverTid]
                    local isBox = t.kind == "box"
                    local isBake = isBakeKind(t.kind)
                    local isBag = isBagKind(t.kind)
                    local isTake = IsTakeoutKind(t.kind)
                    -- a click on ANY lidded vessel toggles its lid (the NUI decides
                    -- click-vs-drag); the takeout box's tooltip owns its own make button
                    prepHoverBox = isBox or isTake
                    local on, sx, sy = GetScreenCoordFromWorldCoord(t.x, t.y, t.z + trayFoodDz(t.kind) + 0.06)
                    prepTip = { tray = true, box = isBox or nil, bag = isBag or nil, takeout = isTake or nil,
                                open = (isBox or isTake) and (t.open and true or false) or nil,
                                boxing = ((isBox or isTake) and t.boxing) and true or nil,
                                -- a baking tray shows a rub/collect hint (never a Make Meal)
                                bake = isBake or nil, filled = (isBake and t.filled) or nil,
                                tid = prepHoverTid, onScreen = on, x = sx, y = sy, count = trayPileCount(prepHoverTid) }
                    -- Both takeaway vessels list their contents in the tooltip (no
                    -- floating pills). The takeout box additionally ranks the bag-kind
                    -- FOODS its contents form, so "Create <food>" can appear the moment
                    -- they match — the same guide a build stack gets for recipes.
                    if isBag or isTake then
                        prepTip.contents, prepTip.provides = bagContents(prepHoverTid)
                    end
                end
            end
            prepHovered = prepHoverPid
            trayHovered = prepHoverTid

            -- (Model-less bag contents used to float as 2D pills over the bag; they now
            -- live in the bag's tooltip alongside its craft-match ranking — see the
            -- bag prepTip.contents above.)

            -- (Soda taps carry no on-screen label: the fountain model already
            -- prints each flavor, so clicking the printed nozzle — resolved
            -- world-side by hoveredTapSlot on worldClick — is all that's needed.)

            SendNUIMessage({ action = "cookingItems", items = items, hovered = hoveredUid,
                             prepHovered = prepHoverPid, prepTrayHovered = prepHoverTid,
                             prepTrayBox = prepHoverBox, prepTip = prepTip })

            -- Stovetop: outline the hovered dual item (click flips it); otherwise
            -- highlight the oven door under the cursor (click toggles it).
            if not placing and not moving and currentCookProp and currentCookProp.prop_type == "stovetop" then
                if hoveredUid and CookDual[hoveredUid] then
                    HoverDual(hoveredUid)
                    if HoverOvenDoor then HoverOvenDoor(currentCookProp.id, nil) end
                else
                    HoverDual(nil)
                    local hit, _, entity = CursorToWorld()
                    local door
                    if hit and entity and entity ~= 0 and GetOvenDoorIndexByEntity then
                        door = GetOvenDoorIndexByEntity(currentCookProp.id, entity)
                    end
                    if HoverOvenDoor then HoverOvenDoor(currentCookProp.id, door) end
                end
            end

            Wait(50)
        end
    end)
end

-- ─── NUI callbacks ───────────────────────────────────────────────────────────

-- drag a bar item out: spawn the real prop right away and have it follow the
-- cursor in the world. Collision is off so the cursor ray passes through it
-- (otherwise it would track its own surface).
DragGate.callback("cooking:beginPlace", function(d, cb)
    if not currentCookProp then return cb({ ok = false }) end
    cancelPlace()
    local base = currentCookProp

    -- Dual-sided recipe -> preview BOTH faces so it reads as one two-sided patty
    -- for the entire drag, identical to what spawns on release.
    local recipe = (d.kind == "cook") and RecipesByInput and RecipesByInput[d.item] or nil
    if recipe and (recipe.dual_sided == true or tonumber(recipe.dual_sided) == 1) then
        local model = recipe.raw_model
        local e1 = model and SpawnProp(model, base.x, base.y, base.z) or nil
        local e2 = model and SpawnProp(model, base.x, base.y, base.z) or nil
        if not e1 or not e2 then
            SafeDeleteEntity(e1); SafeDeleteEntity(e2)
            return cb({ ok = false })
        end
        local p = { dual = true, ent = { e1, e2 }, kind = d.kind, item = d.item, source = d.source, hit = false }
        placing = p
        CreateThread(function()
            while placing == p do
                local hit, coords = CursorToWorld()
                if hit and coords then
                    p.hit, p.coords = true, coords
                    orientPair(p.ent, coords.x, coords.y, coords.z, false, curYaw())
                else
                    p.hit = false
                end
                Wait(0)
            end
        end)
        return cb({ ok = true })
    end

    -- Oven / fryer: the preview snaps to the nearest OPEN slot (not a free raycast);
    -- release drops it into that cavity/basket seat.
    local method = recipe and recipe.method or nil
    if recipe and (method == "oven" or method == "fry") then
        -- An uncooked assembled item (topped pizza) previews its WHOLE build stack, so
        -- the drag reads the same as what placement renders — not just the base model.
        local stackModels = (d.source == "tray") and previewStackFor(d.item, d.sig) or nil
        -- A containered bake (cake tin, cookie tray…) previews as container + food,
        -- mirroring what the server folds into the placed stack — INCLUDING the batch
        -- case: a cookie tray holds output_count servings, so previewing it as a single
        -- serving made the drag read as one lone cookie and then land as six.
        if recipe.container_model and recipe.container_model ~= "" then
            local n = math.max(math.floor(tonumber(recipe.output_count) or 1), 1)
            if n > 1 and not (stackModels and #stackModels > 1) then
                stackModels = { recipe.container_model }
                for _ = 1, n do stackModels[#stackModels + 1] = recipe.raw_model end
            else
                stackModels = stackModels or { recipe.raw_model }
                if stackModels[1] ~= recipe.container_model then
                    table.insert(stackModels, 1, recipe.container_model)
                end
            end
        end
        if stackModels and #stackModels > 1 then
            -- expand a dual patty layer into its two faces (uncooked preview → no state)
            local mdls, hs, rls = expandStackLayers(stackModels, nil)
            -- the batch grid, resolved off the SAME helper the oven seat uses (it also
            -- zeroes the servings' rises), so the tray in the hand is the tray on the rack
            local allOffs = BakeStackOffsets(mdls, hs)
            local ents, heights, rolls, offsets = {}, {}, {}, allOffs and {} or nil
            for i, m in ipairs(mdls) do
                local e = SpawnProp(m, base.x, base.y, base.z)
                if e then
                    ents[#ents + 1] = e; heights[#heights + 1] = hs[i]; rolls[#rolls + 1] = rls[i]
                    if offsets then offsets[#offsets + 1] = allOffs[i] end
                end
            end
            if #ents == 0 then return cb({ ok = false }) end
            local headingZ = stationHeadingZ(base.id, base)
            local baseDz = stackBaseLift(stackModels[1]) -- container mesh-bottom correction
            local p = { stackEnts = ents, stackHeights = heights, kind = d.kind, item = d.item,
                        slotmode = method, source = d.source, sig = d.sig, hit = false }
            placing = p
            CreateThread(function()
                while placing == p do
                    local best = nearestOpenSlot(method)
                    if best then
                        p.hit, p.door, p.slot = true, best.door, best.slot
                        layoutPreviewStack(ents, heights, best.w.x, best.w.y, best.w.z, headingZ, baseDz, rolls, offsets)
                    else
                        p.hit = false
                        local hit, coords = CursorToWorld()
                        if hit and coords then layoutPreviewStack(ents, heights, coords.x, coords.y, coords.z, headingZ, baseDz, rolls, offsets) end
                    end
                    Wait(0)
                end
            end)
            return cb({ ok = true })
        end

        local model = recipe.raw_model
        local ent = model and SpawnProp(model, base.x, base.y, base.z) or nil
        if not ent then return cb({ ok = false }) end
        SetEntityRotation(ent, 0.0, 0.0, curYaw(), 2, true) -- face the station while dragging
        local p = { entity = ent, kind = d.kind, item = d.item, slotmode = method, source = d.source, sig = d.sig, hit = false }
        placing = p
        CreateThread(function()
            while placing == p do
                local best = nearestOpenSlot(method)
                if best then
                    -- cursor is near an open slot: snap the preview onto it (droppable)
                    p.hit, p.door, p.slot = true, best.door, best.slot
                    SetEntityCoordsNoOffset(ent, best.w.x, best.w.y, best.w.z, false, false, false)
                    alignToStation(base.id, ent)
                else
                    -- not near a slot: follow the cursor (but it can't be dropped here)
                    p.hit = false
                    local hit, coords = CursorToWorld()
                    if hit and coords then
                        SetEntityCoordsNoOffset(ent, coords.x, coords.y, coords.z, false, false, false)
                    end
                end
                Wait(0)
            end
        end)
        return cb({ ok = true })
    end

    -- Soda machine: the cup snaps under the nearest free tap (slot placement,
    -- like the fryer baskets); release seats it on the drip tray.
    if d.kind == "drink" then
        local model = previewModel("drink", d.item)
        local ent = model and SpawnProp(model, base.x, base.y, base.z) or nil
        if not ent then return cb({ ok = false }) end
        SetEntityRotation(ent, 0.0, 0.0, curYaw(), 2, true)
        local p = { entity = ent, kind = d.kind, item = d.item, slotmode = "soda", source = d.source, hit = false }
        placing = p
        CreateThread(function()
            while placing == p do
                -- always LOCK onto the nearest free tap — the cup never trails
                -- the cursor loosely around the machine
                local best = nearestOpenSlot("soda", true)
                if best then
                    p.hit, p.door, p.slot = true, nil, best.slot
                    SetEntityCoordsNoOffset(ent, best.w.x, best.w.y, best.w.z, false, false, false)
                    alignToStation(base.id, ent)
                else
                    p.hit = false
                    local hit, coords = CursorToWorld()
                    if hit and coords then
                        SetEntityCoordsNoOffset(ent, coords.x, coords.y, coords.z, false, false, false)
                    end
                end
                Wait(0)
            end
        end)
        return cb({ ok = true })
    end

    local model = previewModel(d.kind, d.item)
    if not model then return cb({ ok = false, error = _L("cook_nothing_to_place") }) end
    local ent = SpawnProp(model, base.x, base.y, base.z)
    if not ent then return cb({ ok = false }) end
    SetEntityRotation(ent, 0.0, 0.0, curYaw(), 2, true) -- face the station while dragging
    local p = { entity = ent, kind = d.kind, item = d.item, source = d.source, hit = false }
    placing = p
    CreateThread(function()
        while placing == p do
            local hit, coords = CursorToWorld()
            if hit and coords then
                p.hit, p.coords = true, coords
                SetEntityCoordsNoOffset(ent, coords.x, coords.y, coords.z, false, false, false)
            else
                p.hit = false
            end
            Wait(0)
        end
    end)
    cb({ ok = true })
end)

-- release: drop the local preview and ask the server to spawn the real, synced
-- (cooking) prop at the final spot — unless cancelled (released over the bar) or
-- never over a valid surface.
DragGate.callback("cooking:endPlace", function(d, cb)
    local p = placing; placing = nil
    if not p then return cb({ ok = false }) end
    if (d and d.cancel) or not p.hit or (not p.slotmode and not p.coords) then
        deletePreview(p)
        return cb({ ok = false })
    end
    local payload = { prop_id = currentCookProp and currentCookProp.id, kind = p.kind, item = p.item,
                      source = p.source, sig = p.sig } -- source "tray" cooks a tray item (of that exact build variation)
    if p.slotmode then
        payload.door, payload.slot = p.door, p.slot   -- oven/fryer: seat into a slot
    else
        payload.x, payload.y, payload.z = p.coords.x, p.coords.y, p.coords.z
    end
    local res = lib.callback.await("pickle_restaurants:cooking:place", false, payload)
    -- Delete the preview only after the server's synced prop has ACTUALLY spawned
    -- (its spawn event can be dispatched a frame or two after this callback resolves),
    -- so the preview and the real prop overlap and there's no gap where nothing exists.
    -- Bounded so a dropped spawn event can't strand the preview forever.
    if res and res.ok and res.uid then
        local uid, tries = res.uid, 0
        while not (CookObjects[uid] or CookDual[uid]) and tries < 60 do Wait(0); tries = tries + 1 end
    end
    deletePreview(p)
    if res and res.error then ShowNotification(res.error) end
    cb(res or { ok = false })
    if res and res.ok then RefreshBar(); RefreshTray() end -- after the reply, never before
end)

-- chip grabbed: drag the *real* placed prop live under the cursor, the same way
-- a fresh ingredient places. Collision is off so the ray passes through it.
DragGate.callback("cooking:beginMove", function(d, cb)
    local uid = d and d.uid
    if not uid or not CookObjects[uid] then return cb({ ok = false }) end
    cancelPlace()
    cancelMove()
    -- Oven/fryer items live in a fixed slot. The drag is only a gesture to collect
    -- (drop on the bar), but lift the item out to follow the cursor while dragging —
    -- same feel as dragging it in — and snap it back into the slot on a world release.
    if CookSlot[uid] then
        local method = CookSlot[uid].method
        -- An EMPTY soda cup LOCKs to a tap seat (no loose trailing between nozzles) so
        -- it stays positionable under the ice/flavor buttons. Once it's been POURED
        -- ("filled"/"capped"), it drags freely on the cursor like any other item — you're
        -- past pouring and want to pull it to the bar / reposition it, not re-snap taps.
        local sodaLock = method == "soda"
            and CookState[uid] ~= "filled" and CookState[uid] ~= "capped"
        local m = { uid = uid, slot = true, hit = false }
        moving = m
        CreateThread(function()
            while moving == m do
                if not CookObjects[uid] then break end -- collected / removed mid-drag
                -- Snap onto the nearest OPEN slot (any other rack), exactly like placing a
                -- fresh item — release there re-slots it. Otherwise trail the cursor; a
                -- release off any slot just snaps it back to where it was.
                local best = nearestOpenSlot(method, sodaLock, uid)
                if best then
                    m.hit, m.targetDoor, m.targetSlot = true, best.door, best.slot
                    moveSlotStackTo(uid, best.w.x, best.w.y, best.w.z)
                else
                    m.hit, m.targetDoor, m.targetSlot = false, nil, nil
                    local hit, coords = CursorToWorld()
                    if hit and coords then moveSlotStackTo(uid, coords.x, coords.y, coords.z) end
                end
                Wait(0)
            end
        end)
        return cb({ ok = true })
    end
    local m = { uid = uid, hit = false, origin = CookCoords[uid] }
    moving = m
    CreateThread(function()
        while moving == m do
            if not CookObjects[uid] then break end -- collected / removed mid-drag
            local hit, coords = CursorToWorld()
            if hit and coords then
                m.hit, m.coords = true, coords
                MoveCookObjectLocal(uid, coords.x, coords.y, coords.z)
            else
                m.hit = false
            end
            Wait(0)
        end
    end)
    cb({ ok = true })
end)

-- release a dragged prop in the world -> commit the final spot to the server
-- (it validates perms + syncs everyone). With no valid surface, snap it back.
DragGate.callback("cooking:endMove", function(d, cb)
    local m = moving; moving = nil
    if not m then return cb({ ok = false }) end
    -- Slot item: dropped onto another open rack -> move it there (cook progress carries
    -- over); dropped anywhere else (and not collected on the bar) -> snap back to its seat.
    if m.slot then
        if not (d and d.cancel) and m.hit and m.targetSlot and CookObjects[m.uid] then
            local res = lib.callback.await("pickle_restaurants:cooking:reslot", false, {
                uid = m.uid, door = m.targetDoor, slot = m.targetSlot,
            })
            if res and res.ok then return cb(res) end          -- server re-seated it at the new rack
            if res and res.error then ShowNotification(res.error) end
        end
        if CookObjects[m.uid] then seatSlotItem(m.uid) end      -- rejected / no target / cancelled
        return cb({ ok = false })
    end
    if (d and d.cancel) or not m.hit or not m.coords then
        if m.origin then MoveCookObjectLocal(m.uid, m.origin.x, m.origin.y, m.origin.z) end
        return cb({ ok = false })
    end
    local res = lib.callback.await("pickle_restaurants:cooking:move", false, {
        uid = m.uid, x = m.coords.x, y = m.coords.y, z = m.coords.z,
    })
    cb(res or { ok = false })
end)

-- chip dragged back onto the bar -> collect into the Cooked Items tray
--
-- EITHER THE WITHDRAWAL LANDS OR THE ITEM GOES BACK. Every refusal here is something
-- the cook can then fix — open the oven door, raise the basket, press the lid onto a
-- poured cup — so the item has to stay exactly as reachable as it was. The drag thread
-- is stopped BEFORE the round-trip (the server deletes the prop on success, and a live
-- drag would fight that), which used to mean a refused collect left the prop wherever
-- the cursor let go of it: a filled cup dragged at the hotbar ended up floating off the
-- fountain, outside the station camera, where it could no longer be hovered, lidded or
-- dragged back — the drink was stuck, with the slot still claimed for it.
RegisterNUICallback("cooking:collect", function(d, cb)
    cancelMove() -- stop the live drag; the server will remove the prop
    local uid = d and d.uid
    local res = lib.callback.await("pickle_restaurants:cooking:collect", false, { uid = uid })
    if res and res.ok then
        if res.label then ShowNotification(_L("cook_collected", res.label)) end
        RefreshBar()
        RefreshTray()
    else
        -- Refused (or the callback failed): put it back where it lives — its slot seat
        -- for a slotted item (oven/fryer/soda), its last committed spot for a
        -- free-placed one. Same restore endMove does when a reslot is rejected, and a
        -- no-op when collect was pressed from the tooltip rather than dragged.
        if uid and CookObjects[uid] then
            if CookSlot[uid] then
                seatSlotItem(uid)
            else
                local c = CookCoords[uid]
                if c then MoveCookObjectLocal(uid, c.x, c.y, c.z) end
            end
        end
        if res and res.error then ShowNotification(res.error) end
    end
    cb(res or { ok = false })
end)

-- take a Cooked Items tray entry out into the real inventory
RegisterNUICallback("cooking:trayToInventory", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:cooking:trayToInventory", false, {
        prop_id = currentCookProp and currentCookProp.id, item = d.item, count = d.count, sig = d.sig,
    })
    if res and res.ok then
        if res.label then ShowNotification(_L("cook_took", res.label)) end
        RefreshTray(); RefreshBar()
    elseif res and res.error then
        ShowNotification(res.error)
    end
    cb(res or { ok = false })
end)

-- put a POCKETED SERVING (the Restaurant Item holding a cooked product) back on
-- this restaurant's kitchen tray, where it is an ordinary cooked item again. The
-- item itself is never named here — the server reads what a slot holds off the
-- slot, so a forged payload can only ever pick which of YOUR servings moves.
RegisterNUICallback("cooking:invToTray", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:cooking:invToTray", false, {
        prop_id = currentCookProp and currentCookProp.id, count = d.count, sig = d.sig,
    })
    if res and res.ok then
        if res.label then ShowNotification(_L("cook_stowed", res.label)) end
        RefreshTray(); RefreshBar()
    elseif res and res.error then
        ShowNotification(res.error)
    end
    cb(res or { ok = false })
end)

-- throw a tray entry (or, with burnt_only, everything burnt) in the bin
RegisterNUICallback("cooking:trayDiscard", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:cooking:trayDiscard", false, {
        prop_id = currentCookProp and currentCookProp.id, item = d.item,
        count = d.count, sig = d.sig, burnt_only = d.burnt_only,
    })
    if res and res.ok then
        if res.label then
            ShowNotification(_L("cook_threw", res.label, res.count or 1))
        else
            ShowNotification(_L("cook_threw_burnt", res.count or 0, (res.count or 0) == 1 and "" or "s"))
        end
        RefreshTray()
    elseif res and res.error then
        ShowNotification(res.error)
    end
    cb(res or { ok = false })
end)

-- ─── interactive prep build (free-form stacking) ─────────────────────────────

-- Drag from the bar. A halves ingredient spawns as a bottom+top PAIR; everything
-- else is one part. The carried parts follow the cursor and stack onto the pile
-- under it, or start a new pile on empty table (runDragThread).
DragGate.callback("cooking:beginPrepPlace", function(d, cb)
    cancelPlace(); cancelMove()
    if prepDrag then deleteDrag(prepDrag); prepDrag = nil end
    if not currentCookProp then return cb({ ok = false }) end
    -- a packed carrier is not a part: refuse the drag before it starts rather than let
    -- it follow the cursor to a drop prepAdd will only reject (see IsCarrierItem)
    if IsCarrierItem(d.item) then
        ShowNotification(_L("cook_no_nested_vessel"))
        return cb({ ok = false })
    end

    local dual      = (d.dual == 1 or d.dual == true)

    local specs = {}
    local hv = halvesFor(d.item)
    if hv then
        specs[1] = { item = d.item, half = "bottom", model = hv.bottom_model, source = d.source }
        specs[2] = { item = d.item, half = "top",    model = hv.top_model,    source = d.source }
    else
        local stack = (type(d.stack) == "table" and #d.stack > 1) and d.stack or nil
        -- a model-less component (no prop, no stack) is allowed: makePart builds an
        -- ent-less "pill" part for it, which only lands in the Restaurant Bag (guarded
        -- on release in endPrepPlace) and shows as a 2D chip anchored over the bag.
        -- a melt topping only rides a two-faced dual item, matching the stovetop. A
        -- product with a build stack renders as its whole layer tower; `sig` keeps
        -- the reservation pinned to that exact build variation.
        specs[1] = { item = d.item, model = d.model, source = d.source, half = d.half,
                     dual = dual, sig = d.sig, variant = d.variant,
                     stack = stack, state = d.state, finishTool = d.finishTool,
                     label = d.label, image = d.image, -- carried for a model-less pill chip
                     -- a made takeout box renders as the box pair + its food image quad;
                     -- `label`/`itemImage` are the FOOD's name and card art (distinct from
                     -- `image`, which is the picture painted inside the box), for the
                     -- hover tooltip that identifies a box standing on the table
                     takeout = (d.takeout == true or d.takeout == 1) or nil, lidModel = d.lidModel,
                     imageCrop = d.imageCrop, itemImage = d.itemImage,
                     top = dual and d.top or nil, topModel = dual and d.topModel or nil }
    end

    local parts = {}
    for i, spec in ipairs(specs) do
        local p = makePart(spec)
        if not p then deleteParts(parts); return cb({ ok = false }) end
        parts[i] = p
    end
    prepDrag = { parts = parts, hit = false }
    runDragThread(prepDrag)
    cb({ ok = true })
end)

-- Release new parts: reserve each server-side, then commit into a stack (append
-- to the targeted pile, or start a new one). Cancel / over-bar discards.
DragGate.callback("cooking:endPrepPlace", function(d, cb)
    local drag = prepDrag; prepDrag = nil
    setOutline(nil); setTrayOutline(nil)
    if not drag then return cb({ ok = false }) end
    if (d and d.cancel) or not drag.hit then
        deleteParts(drag.parts)
        return cb({ ok = false })
    end
    -- released over a pizza box that can't take this (closed / occupied / not a
    -- pizza): nothing was reserved yet, so it's just a refused drop
    if drag.boxBlock then
        deleteParts(drag.parts)
        ShowNotification(drag.boxBlock)
        return cb({ ok = false })
    end
    -- a model-less pill part only belongs dropped INTO a takeaway vessel (the takeout
    -- box it's a component of, or the bag) as its own new pile — anywhere else it
    -- would be an invisible, meaningless drop, so refuse it.
    for _, p in ipairs(drag.parts) do
        if p.pill then
            local tk = drag.targetTid and PrepTrays[drag.targetTid] and PrepTrays[drag.targetTid].kind
            local ontoBag = tk == "bag" or IsTakeoutKind(tk)
            if not ontoBag then
                deleteParts(drag.parts)
                ShowNotification(_L("cook_pill_bag_only"))
                return cb({ ok = false })
            end
            break
        end
    end
    -- The authoritative source ("inv"/"tray") arrives on release, so stamp it onto
    -- each carried part before reserving (a bun's two halves share it).
    local res, failed = nil, nil
    for _, p in ipairs(drag.parts) do
        p.source = d and d.source
        res = lib.callback.await("pickle_restaurants:cooking:prepAdd", false, {
            prop_id = currentCookProp and currentCookProp.id, source = p.source,
            item = p.item, half = p.half, sig = p.sig, variant = p.variant,
        })
        if not (res and res.ok) then failed = res; break end
        p.id = res.id
    end
    if failed then
        for _, p in ipairs(drag.parts) do
            if p.id then lib.callback.await("pickle_restaurants:cooking:prepRemove", false, { id = p.id }) end
        end
        deleteParts(drag.parts)
        if failed.error then ShowNotification(failed.error) end
        return cb(failed or { ok = false })
    end
    local stack = drag.targetSid and PrepStacks[drag.targetSid]
    if stack then
        for _, p in ipairs(drag.parts) do stack.parts[#stack.parts + 1] = p end
    else
        prepSid = prepSid + 1
        stack = { x = drag.coords.x, y = drag.coords.y, z0 = drag.coords.z, parts = drag.parts }
        -- dropped onto a serving tray: the new pile anchors to it at this offset
        if drag.targetTid and PrepTrays[drag.targetTid] then
            stack.tid, stack.dx, stack.dy = drag.targetTid, drag.coords.dx, drag.coords.dy
        end
        PrepStacks[prepSid] = stack
    end
    relayout(stack)
    -- Reply BEFORE the refreshes. The pile is committed and laid out, so the drop's outcome
    -- is already known; RefreshTray/RefreshBar are two more server round trips whose results
    -- arrive as their own NUI messages. Waiting for them here is what kept the dragged item
    -- stuck to the cursor after release.
    cb(res or { ok = false })
    RefreshTray(); RefreshBar()
end)

-- Spawn one prep part per decompose spec (a halves layer picks its bottom/top prop,
-- as when built). Reservation ids ride along on committed specs and are nil on a
-- preview. A meal layer's (dx, dy) tray offset rides onto the part for pile grouping.
local function partsFromDecomposeSpecs(specs)
    local parts = {}
    for _, spec in ipairs(specs or {}) do
        -- Pass the spec through WHOLE (a shallow copy, plus the halves model override)
        -- instead of re-listing the fields makePart wants. This used to be a hand-kept
        -- whitelist, and anything the server added to a spec afterwards was silently
        -- dropped on the floor here — which is how a made takeout box lost its `label`
        -- and rendered as an anonymous "Takeout Box" while its picture came through.
        local s = {}
        for k, v in pairs(spec) do s[k] = v end
        if spec.half then s.model = halfModel(spec.item, spec.half) or spec.model end
        local p = makePart(s)
        if p then p.id = spec.id; p.dx, p.dy = spec.dx, spec.dy; parts[#parts + 1] = p end
    end
    return parts
end


-- Begin a decompose drag: preview the WHOLE component stack (peeked read-only, so
-- nothing is consumed yet) following the cursor — not just the product's single prop.
-- A MEAL previews as its full tray: tray + paper + every pile at its exact offset.
DragGate.callback("cooking:beginPrepDecompose", function(d, cb)
    cancelPlace(); cancelMove()
    if prepDrag then deleteDrag(prepDrag); prepDrag = nil end
    if not currentCookProp then return cb({ ok = false }) end
    local res = lib.callback.await("pickle_restaurants:cooking:prepDecomposePeek", false, {
        prop_id = currentCookProp.id, item = d and d.item, sig = d and d.sig, source = d and d.source,
    })
    if not (res and res.ok) then return cb({ ok = false }) end
    local parts = partsFromDecomposeSpecs(res.parts)
    if #parts == 0 then return cb({ ok = false }) end
    if res.meal then
        -- a boxed meal previews as its pizza box, lid open so the pizza shows
        local base = currentCookProp
        local kind = res.box and "box" or "tray"
        local openT = res.box and 1.0 or nil
        local ents = spawnTrayEnts(base.x, base.y, base.z, kind, openT)
        if not ents then deleteParts(parts); return cb({ ok = false }) end
        prepDrag = { tray = ents, trayKind = kind, open = res.box and true or nil, openT = openT,
                     piles = groupPiles(parts), parts = parts, hit = false, decompose = true, meal = true }
    else
        prepDrag = { parts = parts, hit = false, decompose = true }
    end
    runDragThread(prepDrag)
    cb({ ok = true })
end)

-- Release a decompose drag: the server un-makes the product (consume + refund +
-- reserve) and the previewed stack — the props already under the cursor — is what
-- sets down, adopted rather than rebuilt.
DragGate.callback("cooking:endPrepDecompose", function(d, cb)
    -- Adopt the committed result onto the props ALREADY BEING CARRIED. The preview
    -- (peek) and the commit are the same component list read off the same instance,
    -- so the parts under the cursor are exactly what the server just reserved — all
    -- they're missing is the reservation ids. Stamping them beats deleting the
    -- preview and spawning an identical set: the food never blinks. False = the two
    -- lists don't line up (a config changed mid-drag) and the caller rebuilds.
    local function adopt(parts, specs)
        specs = specs or {}
        if #parts == 0 or #parts ~= #specs then return false end
        for i, p in ipairs(parts) do
            if p.item ~= specs[i].item or p.half ~= specs[i].half then return false end
        end
        for i, p in ipairs(parts) do
            p.id = specs[i].id
            p.dx, p.dy = specs[i].dx, specs[i].dy
            if p.spec then p.spec.id = specs[i].id end
        end
        return true
    end
    local drag = prepDrag; prepDrag = nil
    setOutline(nil); setTrayOutline(nil)
    if not drag then return cb({ ok = false }) end
    -- capture the drop target; the carried preview STAYS in the world (see below)
    local targetSid, targetTid, coords, hit, boxBlock = drag.targetSid, drag.targetTid, drag.coords, drag.hit, drag.boxBlock
    if (d and d.cancel) or not hit then deleteDrag(drag); return cb({ ok = false }) end
    -- refused by a pizza box (closed / occupied / not a pizza): nothing consumed
    if boxBlock then deleteDrag(drag); ShowNotification(boxBlock); return cb({ ok = false }) end

    local res = lib.callback.await("pickle_restaurants:cooking:prepDecompose", false, {
        prop_id = currentCookProp and currentCookProp.id, item = d and d.item, sig = d and d.sig, source = d and d.source,
    })
    if not (res and res.ok) then
        deleteDrag(drag)
        if res and res.error then ShowNotification(res.error) end
        return cb(res or { ok = false })
    end

    -- The props the cursor is already carrying ARE the result — adopt them (stamp
    -- the reservation ids on) instead of deleting the preview and spawning an
    -- identical set, so nothing pops out of and back into existence on release.
    -- A mismatch (config changed mid-drag) falls back to a rebuild.
    local parts = drag.parts
    local trayEnts = drag.tray
    if not adopt(parts, res.parts) then
        deleteParts(parts)
        parts = partsFromDecomposeSpecs(res.parts)
    end
    if #parts == 0 then
        for _, e in ipairs(trayEnts or {}) do SafeDeleteEntity(e) end
        cb({ ok = false }); RefreshTray(); RefreshBar(); return
    end

    -- A meal sets down as its whole tray (or its pizza box, lid open): the pair
    -- it was carried as, put down at the drop point, one editable pile per
    -- recorded offset — exactly the arrangement it was made as.
    if res.meal then
        local kind = res.box and "box" or "tray"
        local ents = (drag.trayKind == kind) and trayEnts or nil
        if not ents then
            for _, e in ipairs(trayEnts or {}) do SafeDeleteEntity(e) end
            ents = spawnTrayEnts(coords.x, coords.y, coords.z, kind, res.box and 1.0 or nil)
        end
        if ents then
            commitTrayGroup(coords.x, coords.y, coords.z, ents, groupPiles(parts), kind, res.box and true or false)
            cb(res); RefreshTray(); RefreshBar(); return
        end
        -- tray prop failed to spawn: fall through and keep the parts as a plain stack
    else
        -- not a meal after all: the carried tray (if any) has nothing to hold
        for _, e in ipairs(trayEnts or {}) do SafeDeleteEntity(e) end
    end

    local stack = targetSid and PrepStacks[targetSid]
    if stack then
        for _, p in ipairs(parts) do stack.parts[#stack.parts + 1] = p end
    else
        prepSid = prepSid + 1
        stack = { x = coords.x, y = coords.y, z0 = coords.z, parts = parts }
        if targetTid and PrepTrays[targetTid] then
            stack.tid, stack.dx, stack.dy = targetTid, coords.dx, coords.dy
        end
        PrepStacks[prepSid] = stack
    end
    relayout(stack)
    cb(res or { ok = true })
    RefreshTray(); RefreshBar() -- display refresh, after the reply
end)

-- Grab a placed part: lift it and everything above it off its stack (grab the top
-- → one part; grab a lower member → that part and the rest above it). Reuses the
-- same drag loop as placing.
DragGate.callback("cooking:prepGrab", function(d, cb)
    cancelPlace(); cancelMove()
    if prepDrag then return cb({ ok = false }) end
    local sid, idx = findPart(d and d.puid)
    if not sid then return cb({ ok = false }) end
    local stack = PrepStacks[sid]
    local lifted = {}
    for i = idx, #stack.parts do lifted[#lifted + 1] = stack.parts[i] end
    for i = #stack.parts, idx, -1 do table.remove(stack.parts, i) end
    -- home keeps the tray anchor too, so a fizzled drag re-homes ONTO the tray
    local home = { x = stack.x, y = stack.y, z0 = stack.z0, tid = stack.tid, dx = stack.dx, dy = stack.dy }
    if #stack.parts == 0 then PrepStacks[sid] = nil else relayout(stack) end
    setOutline(nil); prepHovered = nil
    prepDrag = { parts = lifted, home = home,
                 fromSid = (PrepStacks[sid] and sid) or nil, hit = false }
    runDragThread(prepDrag)
    cb({ ok = true })
end)

-- Release moved parts: over the bar removes them (un-reserves); on a pile/table
-- re-homes them; nowhere valid snaps them back to their source.
DragGate.callback("cooking:prepDrop", function(d, cb)
    local drag = prepDrag; prepDrag = nil
    setOutline(nil); setTrayOutline(nil)
    if not drag then return cb({ ok = false }) end
    -- A carried tray (grab-drag): dropped on the bar the arrangement becomes ONE
    -- meal; dropped in the world the tray moves there (piles keep their offsets);
    -- anywhere else it snaps back home.
    if drag.tray then
        -- A carried BAKING tray: on the bar a FILLED one is collected into the hotbar
        -- (its output item); an empty one just goes away. In the world it moves like
        -- any tray, keeping its fill state + raw sheet.
        if drag.bake then
            if d and d.cancel then
                if drag.bakeFilled then
                    local res = lib.callback.await("pickle_restaurants:cooking:bakeTrayToInv", false,
                        { prop_id = currentCookProp and currentCookProp.id, output = drag.bakeOutput })
                    if res and res.ok then
                        deleteDrag(drag)
                        if res.label then ShowNotification(_L("cook_made", res.label)) end
                        -- the bake collects into the cooked-items tray (a tray-only
                        -- uncooked intermediate), so re-pull the tray too — otherwise
                        -- the "Uncooked Items" tab stays empty until the station is
                        -- reopened (why it only showed up at the oven before)
                        cb(res); RefreshTray(); RefreshBar(); return
                    end
                    if res and res.error then ShowNotification(res.error) end
                    -- fall through: set the tray back down
                else
                    deleteDrag(drag) -- empty baking tray dropped on the bar: put it away
                    return cb({ ok = true })
                end
            end
            local c = (drag.hit and drag.coords) or drag.home
            commitTrayGroup(c.x, c.y, c.z, drag.tray, nil, drag.trayKind, false,
                            { filled = drag.bakeFilled, output = drag.bakeOutput, offs = drag.trayOffs })
            return cb({ ok = true })
        end
        if d and d.cancel then
            local items = {}
            for _, pile in ipairs(drag.piles or {}) do
                local pids = {}
                for _, p in ipairs(pile.parts) do if p.id then pids[#pids + 1] = p.id end end
                if #pids > 0 then items[#items + 1] = { ids = pids, dx = pile.dx, dy = pile.dy } end
            end
            if #items == 0 then -- empty tray/box dropped on the bar: just put it away
                deleteDrag(drag)
                return cb({ ok = true })
            end
            -- a lidded box (pizza / takeout) closes before it's sent off: swing the
            -- carried lid shut where it hovers, give it a beat to settle, then make
            -- (instant when it was carried closed)
            local dragLid = LidCfg(drag.trayKind)
            if dragLid and drag.open then
                local t0 = GetGameTimer()
                while GetGameTimer() - t0 < dragLid.open_ms do
                    local k = (GetGameTimer() - t0) / dragLid.open_ms
                    k = k * k * (3.0 - 2.0 * k)
                    boxLidSwing(dragLid, drag.tray[1], drag.tray[2], 1.0 - k)
                    Wait(0)
                end
                boxLidSwing(dragLid, drag.tray[1], drag.tray[2], 0.0)
                drag.open, drag.openT = false, 0.0
                Wait(1000)
            end
            local res = lib.callback.await(trayMakeCallback(drag.trayKind), false,
                { items = items, box = (drag.trayKind == "box") or nil })
            if res and res.ok then
                deleteDrag(drag)
                if res.label then ShowNotification(_L("cook_made", res.label)) end
                cb(res); RefreshTray(); RefreshBar(); return
            end
            if res and res.error then ShowNotification(res.error) end
            -- fall through: put the tray (and everything on it) back down
        end
        local c = (drag.hit and drag.coords) or drag.home
        commitTrayGroup(c.x, c.y, c.z, drag.tray, drag.piles, drag.trayKind, drag.open)
        return cb({ ok = true })
    end
    -- refused by a pizza box (closed / occupied / not a pizza): snap the carried
    -- parts back to where they came from instead of committing into the box
    -- (a drop on the bar still wins — that's the remove/save path below)
    if drag.boxBlock and not (d and d.cancel) then
        ShowNotification(drag.boxBlock)
        drag.hit = false
    end
    if d and d.cancel then
        -- A WHOLE stack dragged to the hotbar (grab emptied its source → no fromSid)
        -- is saved as its closest product; a grabbed part/sub-stack, or a stack that
        -- forms no product, just returns its parts to holdings.
        if not drag.fromSid then
            local ids = {}
            for _, p in ipairs(drag.parts) do if p.id then ids[#ids + 1] = p.id end end
            if #ids > 0 then
                local res = lib.callback.await("pickle_restaurants:cooking:prepSaveStack", false, { ids = ids })
                if res and res.ok then
                    deleteParts(drag.parts)
                    if res.label then ShowNotification(_L("cook_saved", res.label)) end
                    cb(res); RefreshTray(); RefreshBar(); return
                end
            end
        end
        local res
        for _, p in ipairs(drag.parts) do
            if p.id then res = lib.callback.await("pickle_restaurants:cooking:prepRemove", false, { id = p.id }) end
        end
        deleteParts(drag.parts)
        cb(res or { ok = true }); RefreshTray(); RefreshBar(); return
    end
    local stack
    if drag.hit and drag.targetSid and PrepStacks[drag.targetSid] then
        stack = PrepStacks[drag.targetSid]
        for _, p in ipairs(drag.parts) do stack.parts[#stack.parts + 1] = p end
    elseif drag.hit then
        prepSid = prepSid + 1
        stack = { x = drag.coords.x, y = drag.coords.y, z0 = drag.coords.z, parts = drag.parts }
        -- dropped onto a serving tray: the pile anchors to it at this offset
        if drag.targetTid and PrepTrays[drag.targetTid] then
            stack.tid, stack.dx, stack.dy = drag.targetTid, drag.coords.dx, drag.coords.dy
        end
        PrepStacks[prepSid] = stack
    elseif drag.fromSid and PrepStacks[drag.fromSid] then -- snap back onto the source
        stack = PrepStacks[drag.fromSid]
        for _, p in ipairs(drag.parts) do stack.parts[#stack.parts + 1] = p end
    else -- source is gone: recreate the stack where it came from
        prepSid = prepSid + 1
        stack = { x = drag.home.x, y = drag.home.y, z0 = drag.home.z0, parts = drag.parts }
        -- it came off a tray: keep it anchored there if the tray still exists
        if drag.home.tid and PrepTrays[drag.home.tid] then
            stack.tid, stack.dx, stack.dy = drag.home.tid, drag.home.dx, drag.home.dy
        end
        PrepStacks[prepSid] = stack
    end
    relayout(stack)
    cb({ ok = true })
end)

-- No-model fallback: a component without a world model can't be rendered or
-- stacked, so it can't take part in the per-stack build — it's only reserved (which
-- still updates the bar counts). Default configs give every component a model.
RegisterNUICallback("cooking:prepAdd", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:cooking:prepAdd", false, {
        prop_id = currentCookProp and currentCookProp.id, source = d.source, item = d.item, sig = d.sig,
    })
    if res and res.ok then
        RefreshTray(); RefreshBar()
    elseif res and res.error then
        ShowNotification(res.error)
    end
    cb(res or { ok = false })
end)

RegisterNUICallback("cooking:prepClear", function(_, cb)
    local res = lib.callback.await("pickle_restaurants:cooking:prepClear", false, {})
    clearPrepStacks()
    cb(res or { ok = true })
    RefreshTray(); RefreshBar() -- display refresh, after the reply
end)

-- Build a single stack into the chosen recipe. The stack's reserved part ids go up
-- with the output; on success the server has consumed them, so we tear that stack
-- down (other stacks stay) and refresh the bar/tray counts.
RegisterNUICallback("cooking:prepMakeStack", function(d, cb)
    local sid = tonumber(d and d.sid)
    local stack = sid and PrepStacks[sid]
    if not stack then return cb({ ok = false }) end
    local ids = {}
    for _, p in ipairs(stack.parts) do if p.id then ids[#ids + 1] = p.id end end
    local res = lib.callback.await("pickle_restaurants:cooking:prepMakeStack", false, { output = d.output, ids = ids })
    if res and res.ok then
        local tid, dx, dy = stack.tid, stack.dx, stack.dy
        local hx, hy, hz = stack.x, stack.y, stack.z0
        removePrepStack(sid)
        -- A pile made into a product STAYS WHERE IT WAS BUILT: reserve the freshly
        -- made product (res.sig addresses it) and seat its prop at the same spot —
        -- on the serving tray it was arranged on, or, off-tray, on the bare table
        -- where the components stood. Only the ITEM is exchanged; the cook keeps
        -- working on the same patch of table instead of having the burger snatched
        -- off it into the holdings and needing to drag it back out of the bar.
        if res.spec then
            local add = lib.callback.await("pickle_restaurants:cooking:prepAdd", false, {
                prop_id = currentCookProp and currentCookProp.id, source = res.spec.source,
                item = res.spec.item, sig = res.spec.sig,
            })
            if add and add.ok then
                local spec = res.spec; spec.id = add.id
                local parts = partsFromDecomposeSpecs({ spec })
                if #parts > 0 then
                    local t = tid and PrepTrays[tid]
                    local s
                    if t then
                        local rx, ry = TrayOffsetWorld(t.x, t.y, dx, dy, curYaw())
                        s = { x = rx, y = ry, z0 = t.z + trayFoodDz(t.kind),
                              tid = tid, dx = dx, dy = dy, parts = parts }
                    else
                        s = { x = hx, y = hy, z0 = hz, parts = parts }
                    end
                    prepSid = prepSid + 1
                    PrepStacks[prepSid] = s
                    relayout(s)
                end
            end
        end
        if res.label then ShowNotification(_L("cook_made", res.label)) end
        RefreshTray(); RefreshBar()
    elseif res and res.error then
        ShowNotification(res.error)
    end
    cb(res or { ok = false })
end)

-- Take a PLACED product apart where it stands (its tooltip's Disassemble). A product
-- reaches the table whole now — dragged out of the bar, or left there by the make —
-- so this is the un-make: the components land in its exact place in the pile, which
-- is why the offer lives on the placed item and not on a bar card (a card has nowhere
-- to put them).
--
-- The part is a RESERVED layer, and prepDecompose works off the STORE (item+sig+source),
-- so the reservation is released first — that returns the instance to the tray/inventory
-- it was reserved out of, un-consumed — and the decompose then takes it from there. If
-- the un-make refuses (a frosted instance is terminal, or the config changed), the
-- reservation is taken straight back out so the prop on the table still owns its
-- instance and nothing has quietly moved.
RegisterNUICallback("cooking:prepDisassemble", function(d, cb)
    local sid, idx, part = findPart(tonumber(d and d.puid))
    if not part or not part.id then return cb({ ok = false }) end
    local stack = PrepStacks[sid]

    lib.callback.await("pickle_restaurants:cooking:prepRemove", false, { id = part.id })
    local res = lib.callback.await("pickle_restaurants:cooking:prepDecompose", false, {
        prop_id = currentCookProp and currentCookProp.id,
        item = part.item, sig = part.sig, source = part.source,
    })
    if not (res and res.ok) then
        -- put the reservation back on the same instance; if even that fails the item
        -- is still safe in holdings, so drop the orphaned prop rather than leave a
        -- part on the table that no longer stands for anything
        local add = lib.callback.await("pickle_restaurants:cooking:prepAdd", false, {
            prop_id = currentCookProp and currentCookProp.id,
            source = part.source, item = part.item, sig = part.sig, variant = part.variant,
        })
        if add and add.ok then
            part.id = add.id
            if part.spec then part.spec.id = add.id end
        else
            table.remove(stack.parts, idx)
            deleteParts({ part })
            if #stack.parts == 0 then removePrepStack(sid) else relayout(stack) end
        end
        if res and res.error then ShowNotification(res.error) end
        cb(res or { ok = false }); RefreshTray(); RefreshBar(); return
    end

    local parts = partsFromDecomposeSpecs(res.parts)
    if #parts == 0 then
        -- nothing rendered (a config with no models): the components are reserved
        -- either way, so just take the product's prop away
        table.remove(stack.parts, idx)
        deleteParts({ part })
        if #stack.parts == 0 then removePrepStack(sid) else relayout(stack) end
        cb(res); RefreshTray(); RefreshBar(); return
    end
    -- swap the one product layer for its components, IN PLACE: anything stacked on
    -- top of it stays on top, exactly as with a drop-in decompose
    table.remove(stack.parts, idx)
    deleteParts({ part })
    for i, p in ipairs(parts) do table.insert(stack.parts, idx + i - 1, p) end
    relayout(stack)
    cb(res)
    RefreshTray(); RefreshBar() -- display refresh, after the reply
end)

-- ─── serving tray & pizza box (kitchen_prep) ─────────────────────────────────

-- Drag a fresh serving tray (or pizza box, kind "box") out of the bar: the prop
-- pair previews under the cursor; drop on the table places it, ready to arrange
-- food on (a box places closed — click the lid to swing it open).
DragGate.callback("cooking:beginTrayPlace", function(d, cb)
    cancelPlace(); cancelMove()
    if prepDrag then deleteDrag(prepDrag); prepDrag = nil end
    setOutline(nil); setTrayOutline(nil)
    local base = currentCookProp
    if not base or base.prop_type ~= "kitchen_prep" then return cb({ ok = false }) end
    local kind = "tray"
    if d and d.kind == "box" then kind = "box"
    elseif d and d.kind == "bag" then kind = "bag"
    elseif d and d.kind == "takeout" then kind = "takeout"
    elseif d and isBakeKind(d.kind) then kind = d.kind
    elseif d and d.kind then return cb({ ok = false }) end -- an unknown (e.g. unsynced bake) kind: refuse, never a stray serving tray
    local ents = spawnTrayEnts(base.x, base.y, base.z, kind, 0.0)
    if not ents then return cb({ ok = false }) end
    prepDrag = { tray = ents, trayKind = kind, openT = 0.0, parts = {}, piles = {}, hit = false,
                 bake = isBakeKind(kind) or nil, bakeFilled = false }
    runDragThread(prepDrag)
    cb({ ok = true })
end)

DragGate.callback("cooking:endTrayPlace", function(d, cb)
    local drag = prepDrag; prepDrag = nil
    setOutline(nil); setTrayOutline(nil)
    if not drag then return cb({ ok = false }) end
    if (d and d.cancel) or not drag.hit or not drag.coords then
        deleteDrag(drag)
        return cb({ ok = false })
    end
    commitTrayGroup(drag.coords.x, drag.coords.y, drag.coords.z, drag.tray, nil, drag.trayKind, false)
    cb({ ok = true })
end)

-- Click the pizza box's lid: swing it open / closed (smooth hinge, setBoxOpen).
-- Locked while the box is closing to be sent off (boxing).
RegisterNUICallback("cooking:boxToggle", function(d, cb)
    local tid = tonumber(d and d.tid)
    local t = tid and PrepTrays[tid]
    if not t or not LidCfg(t.kind) or t.boxing then return cb({ ok = false }) end
    setBoxOpen(tid, not t.open)
    cb({ ok = true })
end)

-- Grab a placed tray: lift it AND everything arranged on it as one carried group.
-- Released via cooking:prepDrop — back on the table it moves; on the bar the whole
-- arrangement becomes a meal.
DragGate.callback("cooking:trayGrab", function(d, cb)
    cancelPlace(); cancelMove()
    if prepDrag then return cb({ ok = false }) end
    local tid = tonumber(d and d.tid)
    local t = tid and PrepTrays[tid]
    if not t then return cb({ ok = false }) end
    if t.boxing then return cb({ ok = false }) end -- mid-close, being boxed up
    setOutline(nil); setTrayOutline(nil); trayHovered = nil
    local piles, parts = {}, {}
    for sid, s in pairs(PrepStacks) do
        if s.tid == tid then
            piles[#piles + 1] = { dx = s.dx or 0.0, dy = s.dy or 0.0, parts = s.parts }
            for _, p in ipairs(s.parts) do parts[#parts + 1] = p end
            PrepStacks[sid] = nil
        end
    end
    -- deterministic pile order so identical arrangements share a meal signature
    table.sort(piles, function(a, b)
        if math.abs(a.dx - b.dx) > 0.0005 then return a.dx < b.dx end
        return a.dy < b.dy
    end)
    PrepTrays[tid] = nil
    -- a box carries its lid state along (settled, so a mid-swing grab can't
    -- freeze the lid half-open) and puts back down in that same state
    local isBox = LidCfg(t.kind) ~= nil
    prepDrag = { tray = t.ents, trayKind = t.kind, open = isBox and (t.open and true or false) or nil,
                 openT = isBox and (t.open and 1.0 or 0.0) or nil, piles = piles, parts = parts,
                 home = { x = t.x, y = t.y, z = t.z }, hit = false,
                 -- a baking tray carries its fill state + output so the drop can collect
                 -- it (bar) or set it back down (world) with the raw sheet intact, plus its
                 -- persisted per-cookie offsets so a move never re-grids the contents
                 bake = isBakeKind(t.kind) or nil, bakeFilled = t.filled or nil, bakeOutput = t.output,
                 trayOffs = t.offs }
    runDragThread(prepDrag)
    cb({ ok = true })
end)

-- The tray tooltip's Make Meal / the box tooltip's Box It Up: everything arranged
-- on tray/box `tid` becomes one meal item, exact layout preserved. A pizza box
-- CLOSES first: the lid swings shut, settles for a second, and only then is the
-- meal made — instantly when it's already closed. Grabbing/clearing the box
-- mid-close cancels the send.
RegisterNUICallback("cooking:prepMakeMeal", function(d, cb)
    local tid = tonumber(d and d.tid)
    local t = tid and PrepTrays[tid]
    if not t then return cb({ ok = false }) end
    local mkLid = LidCfg(t.kind)
    if mkLid then
        if t.boxing then return cb({ ok = false }) end
        if trayPileCount(tid) == 0 then
            ShowNotification(_L("cook_box_empty"))
            return cb({ ok = false })
        end
        if t.open then
            t.boxing = true
            setBoxOpen(tid, false)
            Wait(mkLid.open_ms + 1000)
            if PrepTrays[tid] ~= t then return cb({ ok = false }) end -- grabbed/cleared mid-close
            t.boxing = nil
        end
    end
    local res = makeMealFromTray(tid, false)
    if not res then
        ShowNotification(mkLid and _L("cook_box_empty") or _L("cook_tray_empty"))
        return cb({ ok = false })
    end
    cb(res or { ok = false })
    if res.ok then RefreshTray(); RefreshBar() end -- after the reply, never before
end)

-- The lidded box tooltip's Take Out: empty the box back onto the table — each pile
-- slides from the box bed to a spot beside it (animated, never a pop) and becomes a
-- free, grabbable stack again. A closed lid swings open first.
--
-- The PIZZA box holds exactly one pile, so this is just "the pizza comes out". The
-- TAKEOUT box holds several, and its contents are CONCEALED while inside (see
-- ApplyStackConceal) — so this is the ONLY way they come back out, and every pile has
-- to move: they're laid out in a row along the box's local right, each one clear of
-- the last. Clearing `tid` un-conceals them (relayout at the end of the slide).
RegisterNUICallback("cooking:boxTakeOut", function(d, cb)
    local tid = tonumber(d and d.tid)
    local t = tid and PrepTrays[tid]
    -- The RESTAURANT BAG conceals its contents the same way, so it needs the same way
    -- back out — it just has no lid to swing first (every `cfg` step below is guarded).
    if not t or not (LidCfg(t.kind) or t.kind == "bag") or t.boxing then return cb({ ok = false }) end
    local piles = {}
    for id2, s in pairs(PrepStacks) do
        if s.tid == tid and #s.parts > 0 then piles[#piles + 1] = { sid = id2, stack = s } end
    end
    if #piles == 0 then return cb({ ok = false }) end
    -- deterministic order so the row reads the same as the arrangement inside
    table.sort(piles, function(a, b)
        if math.abs((a.stack.dx or 0.0) - (b.stack.dx or 0.0)) > 0.0005 then
            return (a.stack.dx or 0.0) < (b.stack.dx or 0.0)
        end
        return (a.stack.dy or 0.0) < (b.stack.dy or 0.0)
    end)
    local cfg = LidCfg(t.kind)
    local wasClosed = cfg and not t.open
    if wasClosed then setBoxOpen(tid, true) end -- can't reach through the lid
    -- start clear of the box's own footprint, then step out by each pile's size
    -- (trayHalfExtents resolves the SYNCED base model for either box kind)
    local hx = trayHalfExtents(t.kind)
    local hr = math.rad(curYaw())
    local off = hx + TRAY_PHYS_MARGIN
    for _, p in ipairs(piles) do
        local stack, sid = p.stack, p.sid
        -- Un-conceal FIRST: a takeout box's contents have no props at all while
        -- packed, so they have to be rebuilt before anything can be measured off
        -- them — and before the slide, so it's actually seen.
        stack.tid, stack.dx, stack.dy = nil, nil, nil
        ApplyStackConceal(stack)
        local r = partHalfXY(stack.parts[1]) or 0.15
        off = off + r + 0.05
        local fx, fy, fz = stack.x, stack.y, stack.z0
        local tx, ty, tz = t.x + math.cos(hr) * off, t.y + math.sin(hr) * off, t.z
        off = off + r
        stack.x, stack.y, stack.z0 = tx, ty, tz
        CreateThread(function()
            if wasClosed and cfg then Wait(cfg.open_ms) end -- let the lid clear the opening
            local t0, dur = GetGameTimer(), 250
            while true do
                local k = math.min((GetGameTimer() - t0) / dur, 1.0)
                k = k * k * (3.0 - 2.0 * k) -- eased slide out
                if PrepStacks[sid] ~= stack then return end -- re-grabbed/consumed mid-slide
                layoutParts(stack.parts, fx + (tx - fx) * k, fy + (ty - fy) * k, fz + (tz - fz) * k, #stack.parts == 1)
                if k >= 1.0 then break end
                Wait(0)
            end
        end)
    end
    cb({ ok = true })
end)

-- switch the scripted camera between the cooktop and either oven door
RegisterNUICallback("cooking:setView", function(d, cb)
    if currentCookProp and SetStationView then SetStationView(currentCookProp, d.view) end
    -- The cook's BBQ pose belongs to the COOKTOP, not to the whole stove: an oven
    -- door view is a different part of the same entity, and someone crouched at an
    -- open oven isn't flipping anything. Dropping the pose here also takes the
    -- scenario's props with it, so they never outlive the part they belong to.
    if currentCookProp and currentCookProp.prop_type == "stovetop" and not currentCookProp.virtual then
        if d and (d.view == "door1" or d.view == "door2") then
            if StopStovetopPose then StopStovetopPose() end
        elseif StartStovetopPose then
            StartStovetopPose()
        end
    end
    cb({ ok = true })
end)

-- lower / raise the fryer basket (starts / pauses frying for its items)
RegisterNUICallback("cooking:fryerDip", function(d, cb)
    if not currentCookProp or currentCookProp.prop_type ~= "fryer" then return cb({ ok = false }) end
    local res = lib.callback.await("pickle_restaurants:cooking:fryerDip", false, {
        prop_id = currentCookProp.id, lowered = d and d.lowered and true or false,
    })
    if res and res.error then ShowNotification(res.error) end
    cb(res or { ok = false })
end)

-- click a dual patty -> flip it to cook the other side (server validates + syncs)
RegisterNUICallback("cooking:flip", function(d, cb)
    local uid = d and d.uid
    if uid and CookDual[uid] then
        lib.callback.await("pickle_restaurants:cooking:flip", false, { uid = uid })
    end
    cb({ ok = true })
end)

-- The dual item under the cursor that can still take a melt topping (none yet),
-- within the slot snap radius — so a dragged slice previews seated on its face,
-- exactly like the soda lid snapping onto a cup. Screen-projects each item's melt
-- seat and picks the nearest; restricted to items at the station being worked so a
-- second grill's items can't steal the snap.
local function meltSnapTarget()
    local prop = currentCookProp; if not prop then return nil end
    local cxp, cyp = GetNuiCursorPosition()
    local sw, sh = GetActiveScreenResolution()
    local curx = (sw > 0) and (cxp / sw) or 0.0
    local cury = (sh > 0) and (cyp / sh) or 0.0
    local bestUid, bestD
    for uid, rec in pairs(CookDual) do
        local c = CookCoords[uid]
        if c and rec and not rec.meltEnt and not rec.topping then
            local dx0, dy0 = c.x - prop.x, c.y - prop.y
            if dx0 * dx0 + dy0 * dy0 <= 6.25 then -- within ~2.5m of the station
                local sz = c.z + DUAL.top_seat
                local on, sx, sy = GetScreenCoordFromWorldCoord(c.x, c.y, sz)
                if on then
                    local dx, dy = sx - curx, sy - cury
                    local d2 = dx * dx + dy * dy
                    if d2 <= SLOT_SNAP_R * SLOT_SNAP_R and (not bestD or d2 < bestD) then
                        bestD, bestUid = d2, uid
                    end
                end
            end
        end
    end
    return bestUid
end

-- begin dragging a melt-topping slice: spawn the real slice prop and follow the
-- cursor in 3D (no 2D pill), exactly like placing a dual item. TARGETING an item
-- snaps the slice onto its visible face right away (previews seated, not only on
-- release), matching the soda lid. Release over the snapped item applies it.
DragGate.callback("cooking:beginTopping", function(d, cb)
    cancelPlace()
    cancelMove()
    local model, base = d.model, currentCookProp
    if not model or not base then return cb({ ok = false }) end
    local ent = SpawnProp(model, base.x, base.y, base.z)
    if not ent then return cb({ ok = false }) end
    SetEntityRotation(ent, 0.0, 0.0, curYaw(), 2, true) -- face the station while dragging
    local p = { entity = ent, topping = true, item = d.item, hit = false }
    placing = p
    CreateThread(function()
        while placing == p do
            local uid = meltSnapTarget()
            if uid then
                -- hovering a topping-able dual item: seat the slice on its face exactly
                -- where the melted topping renders (placeMeltAt), so it previews on top
                p.hit, p.snapUid = true, uid
                local c = CookCoords[uid]
                placeMeltAt(ent, c.x, c.y, c.z, CookYaw[uid])
            else
                p.snapUid = nil
                local hit, coords = CursorToWorld()
                if hit and coords then
                    p.hit, p.coords = true, coords
                    SetEntityCoordsNoOffset(ent, coords.x, coords.y, coords.z, false, false, false)
                else
                    p.hit = false
                end
            end
            Wait(0)
        end
    end)
    cb({ ok = true })
end)

-- release a topping drag: drop the preview slice and, if it was snapped onto a dual
-- item (or the NUI reports one hovered), apply it — the server spawns the stuck-on
-- slice. The client's snapped item wins so the apply matches exactly what previewed.
DragGate.callback("cooking:endTopping", function(d, cb)
    local p = placing; placing = nil
    deletePreview(p)
    local uid = (p and p.snapUid) or (d and d.uid)
    if not (d and d.cancel) and uid and CookDual[uid] then
        local res = lib.callback.await("pickle_restaurants:cooking:applyTopping", false,
            { uid = uid, item = (p and p.item) or (d and d.item) })
        if res and res.error then ShowNotification(res.error) end
        cb(res or { ok = false })
        if res and res.ok then RefreshBar() end -- after the reply
        return
    end
    cb({ ok = false })
end)

-- ─── soda machine lid ────────────────────────────────────────────────────────

-- The fountain's cup when the cursor is over it AND it can take a lid (filled,
-- not yet capped) — the lid drag snaps onto it. Screen-projected against the
-- cup's mid-height, same snap radius as the slot seats.
local function lidSnapCup()
    local prop = currentCookProp; if not prop then return nil end
    local uid = sodaCupUid(prop.id)
    if not uid or CookState[uid] ~= "filled" then return nil end
    local cup = CookObjects[uid]
    if not (cup and DoesEntityExist(cup)) then return nil end
    local pos = GetEntityCoords(cup)
    local cupH = modelHeight(GetEntityModel(cup)) or 0.12
    local on, sx, sy = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z + cupH * 0.5)
    if not on then return nil end
    local cx, cy = GetNuiCursorPosition()
    local sw, sh = GetActiveScreenResolution()
    local dx = sx - ((sw > 0) and (cx / sw) or 0.0)
    local dy = sy - ((sh > 0) and (cy / sh) or 0.0)
    if dx * dx + dy * dy > SLOT_SNAP_R * SLOT_SNAP_R then return nil end
    return uid, cup, pos, cupH
end

-- begin dragging a lid: the real lid prop follows the cursor in 3D (exactly like
-- a cheese slice) — but TARGETING the cup snaps it onto the rim right away, so
-- it previews attached, not only on release. Releasing while snapped presses it on.
DragGate.callback("cooking:beginLid", function(d, cb)
    cancelPlace()
    cancelMove()
    local model, base = d.model, currentCookProp
    if not model or not base then return cb({ ok = false }) end
    local ent = SpawnProp(model, base.x, base.y, base.z)
    if not ent then return cb({ ok = false }) end
    SetEntityRotation(ent, 0.0, 0.0, curYaw(), 2, true) -- face the station while dragging
    local p = { entity = ent, lid = true, item = d.item, hit = false }
    placing = p
    CreateThread(function()
        while placing == p do
            local uid, cup, pos, cupH = lidSnapCup()
            if uid then
                -- hovering the (filled) cup: seat the lid on its rim, aligned to
                -- it — and hide the liquid underneath while the lid covers it
                p.hit, p.snapUid = true, uid
                SodaLidPreviewUid = uid
                SetEntityCoordsNoOffset(ent, pos.x, pos.y, pos.z + cupH, false, false, false)
                local cr = GetEntityRotation(cup, 2)
                SetEntityRotation(ent, cr.x, cr.y, cr.z, 2, true)
            else
                p.snapUid = nil
                SodaLidPreviewUid = nil
                local hit, coords = CursorToWorld()
                if hit and coords then
                    p.hit, p.coords = true, coords
                    SetEntityCoordsNoOffset(ent, coords.x, coords.y, coords.z, false, false, false)
                else
                    p.hit = false
                end
            end
            Wait(0)
        end
        SodaLidPreviewUid = nil -- drag over (released / cancelled): liquid shows again
    end)
    cb({ ok = true })
end)

-- release a lid drag: drop the preview and, if snapped onto (or released over) a
-- soda cup, press it on (the server validates + consumes the lid and re-renders
-- the capped cup for everyone).
DragGate.callback("cooking:endLid", function(d, cb)
    local p = placing; placing = nil
    deletePreview(p)
    local uid = (d and d.uid) or (p and p.snapUid)
    if not (d and d.cancel) and uid and CookSlot[uid] and CookSlot[uid].method == "soda" then
        local res = lib.callback.await("pickle_restaurants:cooking:applyLid", false, { uid = uid })
        if res and res.error then ShowNotification(res.error) end
        -- drop the liquid right away — don't let it flash back in the gap
        -- before the capped-cup sync lands. This one stays BEFORE the reply: it's a local
        -- render flag, not a round trip, and its whole point is the ordering.
        if res and res.ok then SodaFill[uid] = nil end
        cb(res or { ok = false })
        if res and res.ok then RefreshBar() end -- the round trip goes after
        return
    end
    cb({ ok = false })
end)

-- drop a melt topping on a dual item's cooked up-face (server validates + consumes it)
RegisterNUICallback("cooking:applyTopping", function(d, cb)
    local uid = d and d.uid
    if uid and CookDual[uid] then
        local res = lib.callback.await("pickle_restaurants:cooking:applyTopping", false,
            { uid = uid, item = d.item })
        if res and res.error then ShowNotification(res.error) end
        if res and res.ok then cb({ ok = true }); RefreshBar(); return end
    end
    cb({ ok = true })
end)

-- ─── finish tools (frosting …) ───────────────────────────────────────────────
-- A finish tool (synced `Finishes` config) is dragged out of the bar as its real
-- tube prop and RUBBED over a placed prep part: coverage accrues with the tool's
-- travel over the target, the flavored result prop fades in (alpha 0→255), and at
-- full coverage the server consumes target + 1 tool item and the finished product
-- is seated exactly where the target sat (a cake's container + batter sheet are
-- deleted; a doughnut keeps its topping overlay).

local FINISH = {
    tool_lift = 0.01, -- extra clearance above the cursor's surface hit (the tube's
                      -- mesh bottom is seated at the hit point via its measured
                      -- origin offset, so this is just a hair of breathing room)
    max_step  = 0.15, -- per-frame travel clamp (m) so a camera jump can't insta-fill
}

-- How far a model's mesh bottom sits below its origin (the serving tray's
-- physics-margin correction) — seats the tube ON the ray hit instead of floating.
local function meshBottomLift(model)
    local mn = GetModelDimensions((EnsureModel(model)))
    return mn and math.max(-(mn.z + STACK_PHYS_MARGIN), 0.0) or 0.0
end

-- The (target, flavor) config a hovered part matches for this tool + chosen
-- flavor. nil when the part isn't a valid target (raw/burnt items are never
-- configured targets), the flavor doesn't apply to it (glazed on a cake), or the
-- target requires a prior finish the part doesn't carry (sprinkles need frosting —
-- checked on the part's recorded finishTool, since a frosted doughnut is the same
-- cooked_doughnut item now). Server re-validates on apply regardless.
local function finishTargetFor(cfg, part, flavorId)
    for _, t in ipairs(cfg.targets or {}) do
        if t.item == part.item then
            if t.requires_finish and part.finishTool ~= t.requires_finish then return nil end
            for _, fl in ipairs(t.flavors or {}) do
                if fl.id == flavorId then return t, fl end
            end
            return nil
        end
    end
end

-- World z a stack part's BASE sits at (z0 + every height below it) — where a
-- replace-mode result spawns; an overlay-mode one goes on the part's top.
local function partBaseZ(stack, idx)
    local z = stack.z0
    for i = 1, idx - 1 do z = z + (stack.parts[i].height or 0.0) end
    return z
end

-- Swap a finished part in place: the old part's props (container + batter sheet
-- for a cake) are deleted and the freshly made output is re-reserved (res.sig
-- addresses it) and seated at the same spot in its stack — mirrors how
-- prepMakeStack re-seats a product made on a serving tray.
local function replacePartWithFinished(sid, idx, res)
    local stack = PrepStacks[sid]
    if not stack or not stack.parts[idx] then RefreshTray(); RefreshBar(); return end
    deleteParts({ stack.parts[idx] })
    table.remove(stack.parts, idx)
    if res.spec then
        local add = lib.callback.await("pickle_restaurants:cooking:prepAdd", false, {
            prop_id = currentCookProp and currentCookProp.id, source = res.spec.source,
            item = res.spec.item, sig = res.spec.sig,
        })
        if add and add.ok then
            local spec = res.spec; spec.id = add.id
            local parts = partsFromDecomposeSpecs({ spec })
            if #parts > 0 then table.insert(stack.parts, idx, parts[1]) end
        end
    end
    -- fizzled re-reserve: the output is safely in the tray either way
    if #stack.parts == 0 then PrepStacks[sid] = nil else relayout(stack) end
end

-- Full coverage reached: commit with the server (it re-validates and consumes),
-- tear the drag down, and seat the finished prop in place of the target.
local function applyFinishAt(f, sid, idx, part, _, _)
    local res = lib.callback.await("pickle_restaurants:cooking:applyFinish", false, {
        prop_id = currentCookProp and currentCookProp.id,
        id = part.id, tool = f.cfg.tool, flavor = f.flavor,
    })
    if finishing == f then finishing = nil end
    SafeDeleteEntity(f.tube)
    for _, g in pairs(f.ghosts or {}) do SafeDeleteEntity(g.ent) end
    setOutline(nil)
    if res and res.ok then
        replacePartWithFinished(sid, idx, res)
        if res.label then ShowNotification(_L("cook_made", res.label)) end
        RefreshTray(); RefreshBar()
    elseif res and res.error then
        ShowNotification(res.error)
    end
    SendNUIMessage({ action = "cookingFinishDone" })
end

-- begin dragging a finish tool: spawn the real tube prop following the cursor;
-- coverage/ghost state lives per hovered part for the drag's lifetime.
DragGate.callback("cooking:beginFinish", function(d, cb)
    cancelPlace(); cancelMove(); cancelFinish(); cancelCondiment()
    if prepDrag then deleteDrag(prepDrag); prepDrag = nil end
    local base = currentCookProp
    if not base or base.prop_type ~= "kitchen_prep" then return cb({ ok = false }) end
    local cfg
    for _, fc in ipairs(Finishes or {}) do
        if fc.tool == (d and d.item) then cfg = fc break end
    end
    if not cfg or not cfg.tool_model or not d.flavor then return cb({ ok = false }) end
    local tube = SpawnProp(cfg.tool_model, base.x, base.y, base.z)
    if not tube then return cb({ ok = false }) end
    SetEntityRotation(tube, 0.0, 0.0, curYaw(), 2, true) -- face the station
    -- seat the tube's MESH bottom at the cursor's surface hit (its origin isn't
    -- reliably at the mesh bottom, so a flat lift floated it too high)
    local tubeLift = meshBottomLift(cfg.tool_model) + FINISH.tool_lift
    local f = { tube = tube, cfg = cfg, flavor = d.flavor, ghosts = {}, coverage = {}, applying = false }
    finishing = f
    CreateThread(function()
        while finishing == f do
            local hit, coords = CursorToWorld()
            local sid, idx, part = pickPart(nil)
            if hit and coords then
                -- Food props have collision off, so the cursor ray passes through
                -- them and hits the TABLE underneath — seat the tube on top of the
                -- pile under the cursor (its summed model heights), not the ray hit,
                -- so it rides over the cake instead of intersecting it.
                local z = coords.z
                local stack = sid and PrepStacks[sid]
                if stack then z = math.max(z, stackTopZ(stack)) end
                SetEntityCoordsNoOffset(tube, coords.x, coords.y, z + tubeLift, false, false, false)
            end
            local target, flavor
            if part and part.id and hit and coords then
                target, flavor = finishTargetFor(cfg, part, f.flavor)
            end
            if target then
                setOutline(sid, 80, 200, 120)
                -- coverage accrues with the tool's travel while over the target
                if f.last then
                    local dx, dy = coords.x - f.last.x, coords.y - f.last.y
                    f.coverage[part.pid] = (f.coverage[part.pid] or 0.0)
                        + math.min(math.sqrt(dx * dx + dy * dy), FINISH.max_step)
                end
                -- the flavored result fades in over the target as coverage builds
                local g = f.ghosts[part.pid]
                if not g and flavor.model then
                    local stack = PrepStacks[sid]
                    local gz = partBaseZ(stack, idx)
                    if (target.mode or "replace") == "overlay" then gz = gz + (part.height or 0.0) end
                    local ent = SpawnProp(flavor.model, stack.x, stack.y, gz)
                    if ent then
                        SetEntityCoordsNoOffset(ent, stack.x, stack.y, gz, false, false, false)
                        SetEntityRotation(ent, 0.0, 0.0, curYaw(), 2, true) -- match the target's facing
                        SetEntityAlpha(ent, 0, false)
                        g = { ent = ent }
                        f.ghosts[part.pid] = g
                    end
                end
                local progress = math.min((f.coverage[part.pid] or 0.0) / (tonumber(cfg.rub_dist) or 1.2), 1.0)
                if g and g.ent and DoesEntityExist(g.ent) then
                    SetEntityAlpha(g.ent, math.floor(progress * 255 + 0.5), false)
                end
                if progress >= 1.0 and not f.applying then
                    f.applying = true
                    applyFinishAt(f, sid, idx, part, target, flavor)
                    break
                end
            else
                setOutline(nil)
            end
            f.last = (hit and coords) and { x = coords.x, y = coords.y } or nil
            Wait(0)
        end
        setOutline(nil)
    end)
    cb({ ok = true })
end)

-- release a finish drag before full coverage: everything resets, nothing consumed
DragGate.callback("cooking:endFinish", function(_, cb)
    cancelFinish()
    cb({ ok = true })
end)

-- ─── condiments (ketchup / mustard / mayo) ───────────────────────────────────
-- A condiment bottle (synced `Condiments` config) is dragged out of the bar and held
-- OVER a build stack. It flips 180° (nozzle down) as it moves above the stack, then
-- squeezes DOWN-and-UP once — the sauce (`applied_model`) fades in on the stack top and
-- is committed as a NEW build-stack layer (reserved via prepAdd, consumed at Make). A
-- condiment can never be a stack's FIRST layer (nothing under it to sauce), so the
-- applicator only engages over a stack that already has ≥1 part. TUNE IN-GAME.
local CONDIMENT = {
    hover_gap  = 0.02,  -- clearance between the bottle nozzle and the stack top while hovering
    flip_ms    = 220,   -- time to swing the bottle 180° once it moves over a valid stack
    squeeze_ms = 420,   -- one full down-and-up squeeze that lays the sauce
    dip        = 0.03,  -- how far the nozzle presses toward the food at the squeeze bottom
}

-- Squeeze complete: commit the sauce as a new top layer. Mirrors replacePartWithFinished
-- but INSERTS on top instead of replacing. We clear `condimenting` BEFORE the server
-- round-trip so a pointer-up cancel firing on another coroutine becomes a no-op and this
-- function alone owns the props from here (same guard as applyBakeMixAt).
local function applyCondimentAt(c, sid)
    if condimenting == c then condimenting = nil end
    local stack = PrepStacks[sid]
    local res = stack and lib.callback.await("pickle_restaurants:cooking:prepAdd", false, {
        prop_id = currentCookProp and currentCookProp.id, item = c.cfg.item,
    }) or nil
    SafeDeleteEntity(c.container)
    if c.ghost then SafeDeleteEntity(c.ghost); c.ghost = nil end
    setOutline(nil)
    if res and res.ok then
        stack = PrepStacks[sid] -- re-fetch: the stack may have changed during the await
        local part = stack and makePart({ item = c.cfg.item, model = c.cfg.applied_model })
        if part then
            part.id = res.id
            stack.parts[#stack.parts + 1] = part
            relayout(stack)
        else
            -- the stack vanished mid-commit: drop the orphan reservation so the pool
            -- figure and any later Make stay correct
            lib.callback.await("pickle_restaurants:cooking:prepRemove", false, { id = res.id })
        end
        RefreshBar()
    elseif res and res.error then
        ShowNotification(res.error)
    end
    SendNUIMessage({ action = "cookingCondimentDone" })
end

-- begin dragging a condiment bottle: spawn the real container prop following the cursor;
-- it rides upright over the table and flips over a valid stack to squeeze.
DragGate.callback("cooking:beginCondiment", function(d, cb)
    cancelPlace(); cancelMove(); cancelFinish(); cancelBakeMix(); cancelCondiment()
    if prepDrag then deleteDrag(prepDrag); prepDrag = nil end
    local base = currentCookProp
    if not base or base.prop_type ~= "kitchen_prep" then return cb({ ok = false }) end
    local cfg
    for _, cc in ipairs(Condiments or {}) do
        if cc.item == (d and d.item) then cfg = cc break end
    end
    if not cfg or not cfg.container_model or not cfg.applied_model then return cb({ ok = false }) end
    local container = SpawnProp(cfg.container_model, base.x, base.y, base.z)
    if not container then return cb({ ok = false }) end
    SetEntityRotation(container, 0.0, 0.0, curYaw(), 2, true) -- upright, facing the station
    local c = {
        container = container, cfg = cfg,
        ch   = modelHeight(cfg.container_model),      -- bottle height (origin → its top)
        lift = meshBottomLift(cfg.container_model),    -- seat the mesh bottom on the table
        flip = 0.0, targetSid = nil, sqStart = nil, ghost = nil, applying = false,
    }
    condimenting = c
    CreateThread(function()
        local lastT = GetGameTimer()
        while condimenting == c do
            local now = GetGameTimer()
            local dt = now - lastT; lastT = now
            local hit, coords = CursorToWorld()
            local sid = pickPart(nil)
            local stack = sid and PrepStacks[sid]
            -- a condiment can't be the first layer: the stack must already carry a part
            local valid = stack and #stack.parts >= 1 and hit and coords and true or false

            -- flip toward upside-down over a valid stack, back upright otherwise
            local dir = valid and 1.0 or -1.0
            c.flip = math.max(0.0, math.min(1.0, c.flip + dir * (dt / CONDIMENT.flip_ms)))

            if valid then
                setOutline(sid, 80, 200, 120)
                local topZ = stackTopZ(stack)
                local dip = 0.0
                if c.flip >= 1.0 then
                    -- fully flipped (nozzle down): run the one-shot squeeze
                    c.sqStart = c.sqStart or now
                    local sq = math.min((now - c.sqStart) / CONDIMENT.squeeze_ms, 1.0)
                    dip = math.sin(sq * math.pi) * CONDIMENT.dip -- 0 → dip → 0 (down then up)
                    -- the sauce fades in on the stack top as the bottle presses down
                    if not c.ghost then
                        local g = SpawnProp(cfg.applied_model, stack.x, stack.y, topZ)
                        if g then
                            SetEntityCoordsNoOffset(g, stack.x, stack.y, topZ, false, false, false)
                            SetEntityRotation(g, 0.0, 0.0, curYaw(), 2, true)
                            SetEntityAlpha(g, 0, false)
                            c.ghost = g
                        end
                    end
                    if c.ghost and DoesEntityExist(c.ghost) then
                        SetEntityAlpha(c.ghost, math.floor(math.min(sq * 1.6, 1.0) * 255 + 0.5), false)
                    end
                    if sq >= 1.0 and not c.applying then
                        c.applying = true
                        applyCondimentAt(c, sid)
                        break
                    end
                else
                    c.sqStart = nil -- still flipping in; don't start the squeeze yet
                end
                -- origin sits above the stack; flipped, the origin rides a bottle-height
                -- above the nozzle, so the nozzle hovers (hover_gap - dip) over the top
                local originZ = topZ + CONDIMENT.hover_gap + c.ch * c.flip - dip
                SetEntityCoordsNoOffset(container, stack.x, stack.y, originZ, false, false, false)
            else
                setOutline(nil)
                c.sqStart = nil
                if c.ghost then SafeDeleteEntity(c.ghost); c.ghost = nil end
                if hit and coords then
                    SetEntityCoordsNoOffset(container, coords.x, coords.y, coords.z + c.lift, false, false, false)
                end
            end
            -- the flip is a 180° pitch about the centre-bottom origin (nozzle swings down)
            SetEntityRotation(container, 180.0 * c.flip, 0.0, curYaw(), 2, true)
            Wait(0)
        end
        setOutline(nil)
    end)
    cb({ ok = true })
end)

-- release a condiment drag before the squeeze completes: everything resets, nothing
-- reserved or consumed
DragGate.callback("cooking:endCondiment", function(_, cb)
    cancelCondiment()
    cb({ ok = true })
end)

-- Full coverage reached on a baking tray: the server consumes 1 mix and credits the
-- tray's output. Keep the raw sheet ghost as the tray's (opaque) contents so it moves
-- and collects with the tray; drop the mix bowl and any other partial ghosts.
local function applyBakeMixAt(f, tid)
    local t = PrepTrays[tid]
    -- Retire the drag BEFORE the server round-trip: releasing the mouse the instant a
    -- tray auto-fills fires cooking:endBakeMix → cancelBakeMix on another coroutine,
    -- which would delete the raw-sheet ghost we mean to keep. Clearing bakeMixing now
    -- makes that cancel a no-op, so this function alone owns the props from here.
    if bakeMixing == f then bakeMixing = nil end
    local res = t and lib.callback.await("pickle_restaurants:cooking:fillBakeTray", false,
        { prop_id = currentCookProp and currentCookProp.id, kind = t.kind }) or nil
    SafeDeleteEntity(f.prop)
    setTrayOutline(nil)
    if res and res.ok and PrepTrays[tid] then
        local keep = f.ghosts[tid]
        for k, g in pairs(f.ghosts) do
            if k ~= tid then for _, e in ipairs(g.ents or {}) do SafeDeleteEntity(e) end end
        end
        -- the gridded serving props become the tray's contents (ents[2..]): opaque now,
        -- and they ride, move and delete with the tray. Persist each one's (dx, dy) so a
        -- later grab/move re-seats it exactly here instead of recomputing the grid —
        -- keeping `offs` PARALLEL to the appended contents (skip any despawned prop).
        PrepTrays[tid].offs = PrepTrays[tid].offs or {}
        local keepOffs = (keep and keep.offs) or {}
        for i, e in ipairs((keep and keep.ents) or {}) do
            if DoesEntityExist(e) then
                SetEntityAlpha(e, 255, false)
                PrepTrays[tid].ents[#PrepTrays[tid].ents + 1] = e
                PrepTrays[tid].offs[#PrepTrays[tid].offs + 1] = keepOffs[i] or { dx = 0.0, dy = 0.0 }
            end
        end
        PrepTrays[tid].filled = true
        PrepTrays[tid].output = res.output or PrepTrays[tid].output
        if res.label then ShowNotification(_L("cook_made", res.label)) end
        RefreshBar()
    else
        for _, g in pairs(f.ghosts) do
            for _, e in ipairs(g.ents or {}) do SafeDeleteEntity(e) end
        end
        if res and res.error then ShowNotification(res.error) end
    end
    SendNUIMessage({ action = "cookingBakeDone" })
end

-- begin dragging the baking mix: the mix bowl follows the cursor and is rubbed over a
-- placed EMPTY baking tray; the raw sheet/dough fades in with travel, and at full
-- coverage the tray fills (server consumes 1 mix). Mirrors the finish-tool loop but
-- targets a tray, not a stacked part.
DragGate.callback("cooking:beginBakeMix", function(d, cb)
    cancelPlace(); cancelMove(); cancelFinish(); cancelBakeMix(); cancelCondiment()
    if prepDrag then deleteDrag(prepDrag); prepDrag = nil end
    local base = currentCookProp
    if not base or base.prop_type ~= "kitchen_prep" then return cb({ ok = false }) end
    -- `Baking` is a LIST of fill tools; the dragged card names its own mix_item — find
    -- that tool's gesture config (mix_model + rub_dist), falling back to the card's model.
    local tool
    for _, b in ipairs(Baking or {}) do
        if b.mix_item == (d and d.item) then tool = b break end
    end
    local mixModel = (tool and tool.mix_model) or (d and d.model)
    if not mixModel then return cb({ ok = false }) end
    local rubDist = tonumber(tool and tool.rub_dist) or 1.2
    local mix = SpawnProp(mixModel, base.x, base.y, base.z)
    if not mix then return cb({ ok = false }) end
    SetEntityRotation(mix, 0.0, 0.0, curYaw(), 2, true)
    local mixLift = meshBottomLift(mixModel) + FINISH.tool_lift
    local f = { prop = mix, ghosts = {}, coverage = {}, applying = false }
    bakeMixing = f
    CreateThread(function()
        while bakeMixing == f do
            local hit, coords = CursorToWorld()
            local tid = (hit and coords) and pickTray(coords) or nil
            local t = tid and PrepTrays[tid]
            local valid = t and isBakeKind(t.kind) and not t.filled
            if hit and coords then
                -- ride the mix bowl above the tray bed (or the surface hit otherwise)
                local z = coords.z
                if t then z = math.max(z, t.z + trayFoodDz(t.kind) + 0.05) end
                SetEntityCoordsNoOffset(mix, coords.x, coords.y, z + mixLift, false, false, false)
            end
            if valid then
                setTrayOutline(tid, 80, 200, 120)
                if f.last then
                    local dx, dy = coords.x - f.last.x, coords.y - f.last.y
                    f.coverage[tid] = (f.coverage[tid] or 0.0)
                        + math.min(math.sqrt(dx * dx + dy * dy), FINISH.max_step)
                end
                local g = f.ghosts[tid]
                if not g and t.rawModel then
                    -- one serving prop per slot, gridded on the tray (a cookie tray fades
                    -- in six dough balls); all rise together as the mix is rubbed in
                    local offs = bakeGridOffsets(bakeSlotCount(t.kind), trayBaseModel(t.kind), t.rawModel)
                    local hr, fz = math.rad(curYaw()), t.z + trayFoodDz(t.kind)
                    -- keep each serving prop's (dx, dy) PARALLEL to `ents` (a SpawnProp
                    -- can fail, so grid index ≠ ents index) — this list becomes the
                    -- tray's persistent offsets so the cookies never re-grid on a move
                    local ents, entOffs = {}, {}
                    for _, ofs in ipairs(offs) do
                        local sx = t.x + ofs.dx * math.cos(hr) - ofs.dy * math.sin(hr)
                        local sy = t.y + ofs.dx * math.sin(hr) + ofs.dy * math.cos(hr)
                        local ent = SpawnProp(t.rawModel, sx, sy, fz)
                        if ent then
                            -- CreateProp seats the model's BOUNDS at z, while every
                            -- later layout of these same props (layoutTrayAt, on the
                            -- first drag or move) sets the raw ORIGIN. For a prop whose
                            -- origin isn't its mesh bottom — the cake batter sheet — the
                            -- two differ by that offset, so the sheet visibly jumped in Z
                            -- the moment the tin was picked up. Re-seat on the origin now,
                            -- the same correction SpawnCookObject makes, so the fill and
                            -- every render after it are the same placement.
                            SetEntityCoordsNoOffset(ent, sx, sy, fz, false, false, false)
                            SetEntityRotation(ent, 0.0, 0.0, curYaw(), 2, true)
                            SetEntityAlpha(ent, 0, false)
                            ents[#ents + 1] = ent
                            entOffs[#entOffs + 1] = { dx = ofs.dx, dy = ofs.dy }
                        end
                    end
                    if #ents > 0 then g = { ents = ents, offs = entOffs }; f.ghosts[tid] = g end
                end
                local progress = math.min((f.coverage[tid] or 0.0) / rubDist, 1.0)
                if g and g.ents then
                    local a = math.floor(progress * 255 + 0.5)
                    for _, e in ipairs(g.ents) do if DoesEntityExist(e) then SetEntityAlpha(e, a, false) end end
                end
                if progress >= 1.0 and not f.applying then
                    f.applying = true
                    applyBakeMixAt(f, tid)
                    break
                end
            else
                setTrayOutline(nil)
            end
            f.last = (hit and coords) and { x = coords.x, y = coords.y } or nil
            Wait(0)
        end
        setTrayOutline(nil)
    end)
    cb({ ok = true })
end)

-- release a baking-mix drag before full coverage: everything resets, nothing consumed
DragGate.callback("cooking:endBakeMix", function(_, cb)
    cancelBakeMix()
    cb({ ok = true })
end)

-- click empty grill -> toggle the oven door under the cursor (tracked per-frame).
RegisterNUICallback("cooking:worldClick", function(_, cb)
    if currentCookProp and currentCookProp.prop_type == "stovetop" and GetHoveredOvenDoor then
        local door = GetHoveredOvenDoor(currentCookProp.id)
        if door then
            local res = lib.callback.await("pickle_restaurants:doors:toggle", false, {
                prop_id = currentCookProp.id, door = door,
            })
            if res and res.error then ShowNotification(res.error) end
        end
    elseif currentCookProp and currentCookProp.prop_type == "fryer" then
        -- clicking a basket toggles THAT basket, same convention as oven doors
        local slot = hoveredBasketSlot(currentCookProp.id)
        if slot then
            local res = lib.callback.await("pickle_restaurants:cooking:fryerDip", false, {
                prop_id = currentCookProp.id, slot = slot,
                lowered = not slotDown(currentCookProp.id, slot),
            })
            if res and res.error then ShowNotification(res.error) end
        end
    elseif currentCookProp and currentCookProp.prop_type == "soda_machine" then
        -- clicking a tap pours it into the cup seated under it (middle = ice)
        local slot = hoveredTapSlot(currentCookProp.id)
        if slot then
            local res = lib.callback.await("pickle_restaurants:cooking:sodaTap", false, {
                prop_id = currentCookProp.id, slot = slot,
            })
            if res and res.error then ShowNotification(res.error) end
        end
    end
    cb({ ok = true })
end)

RegisterNUICallback("cooking:close", function(_, cb)
    StopCooking()
    cb({})
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    for uid in pairs(CookDual) do RemoveDual(uid) end
    for uid in pairs(CookSlotStack) do clearSlotStack(uid) end
    for uid in pairs(SodaIce) do removeSodaIce(uid) end
    for uid in pairs(SodaPour) do stopSodaPour(uid) end
    for uid in pairs(SodaFill) do SodaFill[uid] = nil end
    for _, ent in pairs(CookObjects) do
        SafeDeleteEntity(ent)
    end
    -- prep build parts + any in-flight placement/topping/finish previews
    clearPrepStacks()
    deletePreview(placing); placing = nil
    cancelFinish()
    cancelBakeMix()
    cancelCondiment()
end)
-- ─── external render: a meal laid out away from the kitchen (modules/dining) ──
-- A meal in a customer's hands is the SAME arrangement a cook built: one pile per
-- recorded layer group, each at its (dx, dy) offset on the tray (or in the box it
-- was packed in). Rather than a second renderer that would drift from the kitchen's,
-- modules/dining borrows this one through the two functions below — they set the
-- external anchor (extAnchor) so every prop spawns at the table, facing the
-- diner, instead of at a station.

-- Lay `specs` (compSpec layers, each carrying its dx/dy) out at a world point.
-- Returns a handle: the vessel entities, the piles (each with the parts it owns and
-- the meta index the server addresses it by) and the anchor, for hover + teardown.
function SpawnMealRender(specs, trayKind, x, y, z, yaw)
    trayKind = trayKind or "tray"
    extAnchor = { x = x, y = y, z = z, yaw = yaw or 0.0 }
    local ents = spawnTrayEnts(x, y, z, trayKind, LidCfg(trayKind) and 1.0 or 0.0)
    local parts = partsFromDecomposeSpecs(specs)
    local piles = groupPiles(parts)
    local fz = z + trayFoodDz(trayKind)
    for _, pile in ipairs(piles) do
        local px, py = TrayOffsetWorld(x, y, pile.dx, pile.dy, yaw, trayKind)
        layoutParts(pile.parts, px, py, fz, #pile.parts == 1)
    end
    extAnchor = nil
    return { ents = ents, piles = piles, kind = trayKind, x = x, y = y, z = z, yaw = yaw }
end

function DeleteMealRender(h)
    if not h then return end
    for _, pile in ipairs(h.piles or {}) do deleteParts(pile.parts) end
    for _, e in ipairs(h.ents or {}) do SafeDeleteEntity(e) end
    h.piles, h.ents = {}, {}
end

-- Where a rendered pile reads on screen (its top, so a tooltip clears the food) and
-- what it is — everything the dining hover loop needs without touching internals.
function MealRenderPileAnchor(h, i)
    local pile = h and h.piles and h.piles[i]
    if not pile then return nil end
    local z = h.z + trayFoodDz(h.kind)
    for _, p in ipairs(pile.parts) do z = z + (p.height or 0.0) end
    -- the handle's OWN yaw: this runs from the dining hover loop, outside the
    -- extAnchor window, so curYaw() would answer for whatever station is open
    local x, y = TrayOffsetWorld(h.x, h.y, pile.dx, pile.dy, h.yaw, h.kind)
    return x, y, z
end

-- The SIZE of one rendered pile, for picking it with the cursor: its base z, the
-- full height of the tower, and the widest half-extent of its props (the same
-- measurement the prep table's part pick uses). Returns nil for an unknown pile.
--
-- The anchor above is the pile's TOP, which is the right place to hang a tooltip
-- and the WRONG place to hover from: a capped drink is nearly all cup with a thin
-- lid on it, so a target centred at the top of the stack sat on the lid and the
-- cup itself read as un-clickable. Hovering goes by the pile's CENTRE and its own
-- projected size instead — a tall drink and a flat burger both pick where they
-- actually are.
function MealRenderPileSpan(h, i)
    local pile = h and h.piles and h.piles[i]
    if not pile then return nil end
    local z0 = h.z + trayFoodDz(h.kind)
    local total, r = 0.0, 0.0
    for _, p in ipairs(pile.parts) do
        total = total + (p.height or 0.0)
        r = math.max(r, partHalfXY(p) or 0.0)
    end
    return z0, total, math.max(r, 0.03)
end

-- Outline one rendered pile (nil clears every pile) — the same amber hover the
-- prep table uses, so hovering food reads identically wherever you are.
function OutlineMealPile(h, idx)
    for i, pile in ipairs((h and h.piles) or {}) do
        for _, part in ipairs(pile.parts) do
            for _, e in ipairs(part.ents or {}) do
                if DoesEntityExist(e) then
                    SetEntityDrawOutline(e, i == idx)
                    if i == idx then SetEntityDrawOutlineColor(255, 180, 40, 255) end
                end
            end
        end
    end
end

-- Hide (or bring back) ONE rendered pile. A mouthful puts that serving in the
-- diner's hand — the branded cup, the burger, whatever it is — so the copy standing
-- on the tray has to go for the length of the clip, or the same drink is in two
-- places at once. Visibility only: the props are still laid out, still measured, and
-- still holding their pooled box-quad textures, so nothing flashes when they return
-- (a delete/respawn is exactly the flicker RefreshMealView avoids mid-serving).
function SetMealPileVisible(h, idx, vis)
    local pile = h and h.piles and h.piles[idx]
    if not pile then return end
    for _, part in ipairs(pile.parts) do
        for _, e in ipairs(part.ents or {}) do
            if DoesEntityExist(e) then
                SetEntityVisible(e, vis and true or false, false)
                -- a hidden prop must not keep its outline: the amber edge would
                -- still draw around thin air
                if not vis then SetEntityDrawOutline(e, false) end
                -- A takeout box's food PICTURE is a quad drawn from the entity's
                -- matrix, not part of its model, so SetEntityVisible can't reach it —
                -- hiding the box alone would leave a soup's image hanging in the air.
                if QuadSetVisible then QuadSetVisible(e, vis) end
            end
        end
    end
end

-- The meta-layer indices one rendered pile is made of (partsFromDecomposeSpecs
-- carries each spec's id through onto its part) — what the server removes when the
-- diner eats that pile.
function MealRenderPileIndices(h, i)
    local pile = h and h.piles and h.piles[i]
    if not pile then return nil end
    local out = {}
    for _, p in ipairs(pile.parts) do if p.id then out[#out + 1] = p.id end end
    return out
end

-- ─── cooking FX hooks (modules/cookfx) ───────────────────────────────────────
-- The particle layer keeps NO cooking state of its own: it asks here what is on a
-- station right now, so there is exactly one bookkeeping of cooking items (and no
-- second copy of the spawn/remove/bulk event plumbing to drift out of sync).
--
-- One entry per rendered item: { uid, ent, propId, method, state, active } where
--   `method` — "grill" (dual-sided, on the stovetop plate) | "oven" | "fry" | "soda"
--   `state`  — "raw" | "cooked" | "burnt" (a burnt item smokes instead of sizzling)
--   `active` — is it TRANSFORMING this instant: a face on the plate, a basket
--              lowered, a door shut. That, not merely "present", is what sizzles.
function CookFxItems()
    local out, seen = {}, {}
    local function add(uid, ent)
        if seen[uid] then return end
        seen[uid] = true
        if not (ent and DoesEntityExist(ent)) then return end
        local dual, slot, prog = CookDual[uid], CookSlot[uid], CookProg[uid]
        local pg = prog and prog.prog or nil
        local state, active, method
        if dual then
            -- A patty on the plate is always cooking one face; burnt wins for the
            -- look (that's the face making the smoke), matching the hand-back rule.
            local s = dual.sides or {}
            state  = (s[1] == "burnt" or s[2] == "burnt") and "burnt"
                  or (s[1] == "raw" or s[2] == "raw") and "raw" or "cooked"
            active = true
            method = "grill"
        else
            method = slot and slot.method or nil
            state  = (pg and pg.state) or CookState[uid]
            -- oven/fryer only advance while their gate is shut/lowered
            active = pg and pg.gate and true or false
        end
        out[#out + 1] = { uid = uid, ent = ent, propId = CookPropId[uid],
                          method = method, state = state, active = active }
    end
    for uid, ent in pairs(CookObjects) do add(uid, ent) end
    for uid, d in pairs(CookDual) do add(uid, d.ent and (d.ent[1] or d.ent[2])) end
    return out
end

-- ─── what the ROOM sees: mirror snapshots (modules/mirror) ───────────────────
-- Everything else this resource renders in a kitchen is world-visible: a patty on a
-- grill, a tray in an oven, a cup under a tap all come from SERVER state, so every
-- client near the station spawns its own copy. The prep table was the one exception —
-- its build lives only in the cook's client — so from the outside a cook stood at an
-- empty counter miming a burger.
--
-- A prep build is INHERENTLY client-authored: free 2D placement under a cursor,
-- per-part offsets, a lid caught mid-swing. The server holds RESERVATIONS, not
-- geometry, and teaching it the layout would be a second copy of the maths in this
-- file that could only ever drift from it. So the cook publishes WHAT THEY SEE — one
-- row per live prop — and the other clients spawn ordinary local props from it,
-- exactly as they do for a grill. The station claim is exclusive, so there is only
-- ever ONE author and nothing to reconcile between two of them.
--
-- Returns propId, rows (nil when this client isn't working a physical prep table).
-- A VIRTUAL session is deliberately excluded: its shell is somewhere else entirely
-- (underground, in the sky), so there is nobody standing at that table to see it, and
-- the props would land in a room the cook isn't in.
-- ONE row builder for everything that gets mirrored (modules/mirror): a live prop as
-- model hash + transform, plus a takeout box's food PICTURE — that is drawn from the
-- entity matrix rather than being part of the model, so without it a mirrored box
-- would be an open box with nothing in it, which is the exact "nothing is there" all
-- of this exists to fix.
--
-- Rounded on the way out, not on arrival: the publisher diffs against these same
-- numbers to decide whether anything actually moved, so a prop resting still can
-- never jitter its way into a re-send.
function MirrorAddRow(rows, ent, quad, crop)
    if not (ent and DoesEntityExist(ent)) then return end
    -- HIDDEN IS HIDDEN, for the room as much as for the owner. A pile is hidden for
    -- the length of a mouthful (the serving is in the diner's hand, and the held props
    -- ARE networked) and a concealed stack is hidden inside a closed box — mirroring
    -- either would put the same food in two places at once.
    if not IsEntityVisible(ent) then return end
    local c = GetEntityCoords(ent)
    local r = GetEntityRotation(ent, 2)
    rows[#rows + 1] = {
        m  = GetEntityModel(ent),
        x  = math.floor(c.x * 1000 + 0.5) / 1000,
        y  = math.floor(c.y * 1000 + 0.5) / 1000,
        z  = math.floor(c.z * 1000 + 0.5) / 1000,
        rx = math.floor(r.x * 10 + 0.5) / 10,
        ry = math.floor(r.y * 10 + 0.5) / 10,
        rz = math.floor(r.z * 10 + 0.5) / 10,
        q  = quad, qc = crop,
    }
end

-- `parts[].ents` is the whole entity list of a part (deleteParts iterates exactly
-- this, so anything not in it wouldn't be cleaned up either). The picture rides the
-- BASE prop of a takeout box, exactly as SeatTakeoutPart attaches it.
function MirrorAddParts(rows, parts)
    for _, p in ipairs(parts or {}) do
        for i, e in ipairs(p.ents or {}) do
            MirrorAddRow(rows, e, (i == 1) and p.quad or nil, (i == 1) and p.quadCrop or nil)
        end
    end
end

-- The PREP TABLE's props, for the cook to publish. Returns propId, rows (nil when
-- this client isn't working a physical prep table). A VIRTUAL session is deliberately
-- excluded: its shell is somewhere else entirely (underground, in the sky), so there
-- is nobody standing at that table to see it, and the props would land in a room the
-- cook isn't in.
function PrepMirrorSnapshot()
    if not (cookingOpen and currentCookProp) then return nil end
    if currentCookProp.prop_type ~= "kitchen_prep" or currentCookProp.virtual then return nil end
    local rows = {}
    for _, t in pairs(PrepTrays) do
        for _, e in ipairs(t.ents or {}) do MirrorAddRow(rows, e) end
    end
    for _, s in pairs(PrepStacks) do MirrorAddParts(rows, s.parts) end
    -- the carried drag too: a burger travelling under the cook's cursor is the most
    -- legible thing they do, and it is exactly what looked like miming
    if prepDrag then
        MirrorAddParts(rows, prepDrag.parts)
        for _, e in ipairs(prepDrag.tray or {}) do MirrorAddRow(rows, e) end
    end
    return currentCookProp.id, rows
end

-- A laid-out MEAL (the handle SpawnMealRender returned), as mirror rows. The eat-in
-- view owns the handle; walking it here keeps the one description of "what a render
-- is made of" next to the code that builds it.
function MealMirrorRows(h)
    local rows = {}
    if type(h) ~= "table" then return rows end
    for _, e in ipairs(h.ents or {}) do MirrorAddRow(rows, e) end
    for _, pile in ipairs(h.piles or {}) do MirrorAddParts(rows, pile.parts) end
    return rows
end
