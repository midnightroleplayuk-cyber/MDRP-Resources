-- ═══════════════════════════════════════════════════════════════════════════
--  rpemotes-reborn — Core Cinematics Anim Provider implementation
--
--  Implements the "Cinematic Anim Provider" contract so Core Cinematics (and
--  any compatible cinematic tool) can record + replay rpemotes-driven emotes
--  and walking styles. Spec lives in core_cinematics/client/modules/
--  anim_providers.lua — keep both files in sync.
--
--  All public names here are neutral on purpose. There is no "rpemotes" in the
--  state-bag key or in the export names: Core Cinematics doesn't care which
--  resource is providing the anims, only that someone is.
-- ═══════════════════════════════════════════════════════════════════════════

CinematicsBridge = {}

local STATE_BAG_KEY = 'cinematics:animProvider'

-- ── State bag plumbing ───────────────────────────────────────────────────────

-- Atomically update one field of the bag (anim | walk) without losing the
-- other. State-bag values are sometimes aliased so we shallow-clone before
-- writing back. When both fields end up nil we clear the bag entirely so
-- consumers can use `bag == nil` as their "nothing playing" check.
local function updateField(field, value)
    local current = LocalPlayer.state[STATE_BAG_KEY]
    local nextBag = {
        providerId = GetCurrentResourceName(),
        anim = current and current.anim or nil,
        walk = current and current.walk or nil,
    }
    nextBag[field] = value
    if nextBag.anim == nil and nextBag.walk == nil then
        LocalPlayer.state:set(STATE_BAG_KEY, nil, true)
    else
        LocalPlayer.state:set(STATE_BAG_KEY, nextBag, true)
    end
end

-- Called by Emote.lua when an emote starts.
function CinematicsBridge.setAnim(name, emoteData, textureVariation)
    if not name or not emoteData then return end
    updateField('anim', {
        name       = name,
        dict       = emoteData.dict,
        anim       = emoteData.anim,
        flag       = (emoteData.AnimationOptions and emoteData.AnimationOptions.Flag) or 0,
        textureVar = textureVariation,
        library    = emoteData.emoteType,
    })
end

-- Called by Emote.lua when an emote stops.
function CinematicsBridge.clearAnim()
    updateField('anim', nil)
end

-- Called by Walk.lua when a walking style is applied.
function CinematicsBridge.setWalk(name, clipset)
    if not name or not clipset then return end
    updateField('walk', { name = name, clipset = clipset })
end

-- Called by Walk.lua when a walk is reset.
function CinematicsBridge.clearWalk()
    updateField('walk', nil)
end

-- ── Anim Provider exports ────────────────────────────────────────────────────

-- GetAnimData(name) — engine info for `name`, or nil. Walks both EmoteData
-- and SharedEmoteData so the caller doesn't have to know which table holds
-- the entry. Library/type is reported back for menu categorisation.
local function getAnimData(name)
    if not name or name == '__cinematics_probe__' then return nil end
    local data = (EmoteData and EmoteData[name]) or (SharedEmoteData and SharedEmoteData[name])
    if not data then return nil end
    local opts = data.AnimationOptions
    return {
        dict       = data.dict,
        anim       = data.anim,
        flag       = (opts and opts.Flag) or 0,
        label      = data.label or name,
        library    = data.emoteType,
        -- Default texture variation surfaces if the emote ships a single
        -- prop variation; the menu UI can override per-call via opts.
        textureVar = (opts and opts.PropTextureVariations) or 0,
    }
end
CreateExport('GetAnimData', getAnimData)

-- PlayAnimOnPed(ped, name, opts) — runs `name` on any ped, attaching props
-- and clearing prior tasks. Mirrors the old PlayEmoteOnPed semantics. Returns
-- true on success, false otherwise.
local function playAnimOnPed(ped, name, opts)
    opts = opts or {}
    local textureVariation = opts.textureVariation
    -- Resolve which library the emote lives in. Caller might pass an
    -- emoteType hint via opts.library; otherwise we fall back to whichever
    -- of EmoteData / SharedEmoteData has the name.
    local emoteType = opts.library
    if not emoteType then
        if SharedEmoteData and SharedEmoteData[name] then
            emoteType = EmoteType.SHARED
        end
    end
    if PlayEmoteOnPed then
        return PlayEmoteOnPed(ped, name, textureVariation, emoteType)
    end
    return false
end
CreateExport('PlayAnimOnPed', playAnimOnPed)

-- CancelAnimOnPed(ped) — clears any anim + props the bridge applied.
CreateExport('CancelAnimOnPed', function(ped)
    if CancelEmoteOnPed then CancelEmoteOnPed(ped) end
end)

-- GetMenuPed() — preview puppet handle (or 0). Lets cinematic tools filter
-- the rpemotes ClonedPed out of recordings so it doesn't end up baked in.
CreateExport('GetMenuPed', function()
    if ClonedPed and DoesEntityExist(ClonedPed) then return ClonedPed end
    return 0
end)

-- GetAllAnims() — flat list of every emote/anim. Skips WALKS / EXPRESSIONS /
-- EMOJI which aren't "play this on a ped" candidates in a cinematic context.
CreateExport('GetAllAnims', function()
    local out = {}
    if EmoteData then
        for name, data in pairs(EmoteData) do
            local etype = data.emoteType
            if etype ~= EmoteType.WALKS
                and etype ~= EmoteType.EXPRESSIONS
                and etype ~= EmoteType.EMOJI then
                out[#out+1] = {
                    name    = name,
                    label   = data.label or name,
                    library = etype or EmoteType.EMOTES,
                }
            end
        end
    end
    if SharedEmoteData then
        for name, data in pairs(SharedEmoteData) do
            out[#out+1] = {
                name    = name,
                label   = data.label or name,
                library = EmoteType.SHARED,
            }
        end
    end
    table.sort(out, function(a, b)
        if a.library == b.library then
            return (a.label or a.name):lower() < (b.label or b.name):lower()
        end
        return tostring(a.library) < tostring(b.library)
    end)
    return out
end)

-- ── Walking styles exports ───────────────────────────────────────────────────

-- GetWalkData(name) — clipset + label for a walking style.
CreateExport('GetWalkData', function(name)
    if not name or name == '__cinematics_probe__' then return nil end
    local data = WalkData and WalkData[name]
    if not data or type(data) ~= 'table' then return nil end
    return {
        clipset = data.anim,
        label   = data.label or name,
    }
end)

-- SetWalkOnPed(ped, name) — applies `name`'s clipset to any ped. The local
-- player path also persists via /walk's KVP store; foreign peds (replay
-- puppets) just get the clipset applied without persistence.
CreateExport('SetWalkOnPed', function(ped, name)
    if not ped or not DoesEntityExist(ped) or not name then return false end
    local data = WalkData and WalkData[name]
    if not data or not data.anim then return false end
    if WalkMenuStart and ped == PlayerPedId() then
        -- Local player → reuse the standard rpemotes path so KVP / permission
        -- checks all fire. The setAnim/setWalk state-bag write happens via
        -- the WalkMenuStart hook below.
        WalkMenuStart(name, true)
        return true
    end
    -- Replay puppet → just slam the clipset on. No KVP, no permission check.
    RequestAnimSet(data.anim)
    local tries = 0
    while not HasAnimSetLoaded(data.anim) and tries < 30 do
        Wait(33); tries = tries + 1
    end
    if not HasAnimSetLoaded(data.anim) then return false end
    SetPedMovementClipset(ped, data.anim, 0.2)
    RemoveAnimSet(data.anim)
    return true
end)

-- ClearWalkOnPed(ped) — drop the custom clipset (back to default move set).
CreateExport('ClearWalkOnPed', function(ped)
    if not ped or not DoesEntityExist(ped) then return end
    if ResetWalk and ped == PlayerPedId() then
        ResetWalk()
        return
    end
    ResetPedMovementClipset(ped, 0.0)
end)

-- GetAllWalks() — flat list for menu rendering.
CreateExport('GetAllWalks', function()
    local out = {}
    if WalkData then
        for name, data in pairs(WalkData) do
            if type(data) == 'table' and data.anim then
                out[#out+1] = { name = name, label = data.label or name }
            end
        end
    end
    table.sort(out, function(a, b)
        return (a.label or a.name):lower() < (b.label or b.name):lower()
    end)
    return out
end)
