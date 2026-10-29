--[[
    Loading game assets: models, animation dictionaries, particle assets and texture dictionaries.

        local hash = TR.stream.model('prop_cs_cardbox_01')    -- nil if the game hasn't got it or it didn't load
        if not hash then return end
        local box = CreateObject(hash, coords.x, coords.y, coords.z, false, false, false)
        TR.stream.release('model', hash)                      -- the object keeps its model

        if not TR.stream.anim('anim@heists@box_carry@') then return end
        TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 49, 0.0, false, false, false)
        ...
        TR.stream.release('anim', 'anim@heists@box_carry@')

    Each call waits until the asset is loaded, up to `timeout` ms (default 5000), so call it from a
    thread; one already loaded comes back at once. A load that fails is logged once per asset.

    Every load holds the asset, and release() lets it go once every hold on it in this resource is
    released: one part of a script can't unload what another part still uses.
]]

---@alias TRStreamKind 'model' | 'anim' | 'ptfx' | 'texture'

---@class TRStream
local stream = {}

local TIMEOUT = 5000

local kinds = {
    model = {
        label = 'model',
        exists = function(hash) return IsModelInCdimage(hash) end,
        has = function(hash) return HasModelLoaded(hash) end,
        ask = function(hash) RequestModel(hash) end,
        free = function(hash) SetModelAsNoLongerNeeded(hash) end,
    },
    anim = {
        label = 'animation dictionary',
        exists = function(dict) return DoesAnimDictExist(dict) end,
        has = function(dict) return HasAnimDictLoaded(dict) end,
        ask = function(dict) RequestAnimDict(dict) end,
        free = function(dict) RemoveAnimDict(dict) end,
    },
    ptfx = {
        label = 'particle asset',
        has = function(asset) return HasNamedPtfxAssetLoaded(asset) end,
        ask = function(asset) RequestNamedPtfxAsset(asset) end,
        free = function(asset) RemoveNamedPtfxAsset(asset) end,
    },
    texture = {
        label = 'texture dictionary',
        has = function(dict) return HasStreamedTextureDictLoaded(dict) end,
        ask = function(dict) RequestStreamedTextureDict(dict, false) end,
        free = function(dict) SetStreamedTextureDictAsNoLongerNeeded(dict) end,
    },
}

local holds = {} ---@type table<string, integer> kind:name -> loads not released yet
local warned = {} ---@type table<string, true>

---Model names become hashes, kept as one 32-bit signed number (a hash may come either way); the
---rest are names.
local function key(kind, name)
    if kind == 'model' then
        if type(name) == 'string' then name = joaat(name) end
        name = name & 0xFFFFFFFF
        if name > 0x7FFFFFFF then name = name - 0x100000000 end
    end
    return kind .. ':' .. tostring(name), name
end

local function fail(id, label, shown, why)
    if warned[id] then return end
    warned[id] = true
    TR.log.warn('%s %s %s', label, tostring(shown), why)
end

---@return boolean loaded
local function load(kind, name, timeout)
    local k = kinds[kind]
    local id, asset = key(kind, name)
    if k.exists and not k.exists(asset) then
        fail(id, k.label, name, 'is not in the game')
        return false
    end

    -- Asked for even when it's loaded already: something else may let it go.
    k.ask(asset)
    if not k.has(asset) then
        local deadline = GetGameTimer() + (timeout or TIMEOUT)
        repeat
            if GetGameTimer() > deadline then
                fail(id, k.label, name, ('did not load in %d ms'):format(timeout or TIMEOUT))
                -- Not wanted any more: unless something here still holds it, take the request back.
                if not holds[id] then k.free(asset) end
                return false
            end
            Wait(0)
        until k.has(asset)
    end

    holds[id] = (holds[id] or 0) + 1
    return true
end

---@param model string|integer name or hash
---@param timeout? integer ms
---@return integer? hash
function stream.model(model, timeout)
    assert(type(model) == 'string' or math.type(model) == 'integer', 'model must be a name or a hash')
    if not load('model', model, timeout) then return end
    return (select(2, key('model', model)))
end

---@param dict string
---@param timeout? integer ms
---@return boolean
function stream.anim(dict, timeout)
    assert(type(dict) == 'string', 'anim dict must be a string')
    return load('anim', dict, timeout)
end

---@param asset string e.g. 'core'
---@param timeout? integer ms
---@return boolean
function stream.ptfx(asset, timeout)
    assert(type(asset) == 'string', 'ptfx asset must be a string')
    return load('ptfx', asset, timeout)
end

---@param dict string
---@param timeout? integer ms
---@return boolean
function stream.texture(dict, timeout)
    assert(type(dict) == 'string', 'texture dict must be a string')
    return load('texture', dict, timeout)
end

---Lets go of one load. The asset is unloaded when every load of it is released.
---@param kind TRStreamKind
---@param name string|integer
function stream.release(kind, name)
    local k = assert(kinds[kind], 'kind is model, anim, ptfx or texture')
    local id, asset = key(kind, name)
    local n = holds[id]
    if not n then return end

    if n > 1 then
        holds[id] = n - 1
    else
        holds[id] = nil
        k.free(asset)
    end
end

return stream
