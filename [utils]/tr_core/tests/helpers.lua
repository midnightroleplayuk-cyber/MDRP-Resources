-- TR.player.countJob / getPlayersWithJob, TR.cooldown and TR.stream (stubs from tests/stubs.lua).
local check = T.check

---------------------------------------------------------------------------------------------------
-- Players with a job
---------------------------------------------------------------------------------------------------

local function xPlayer(src, identifier, job, onDuty)
    return {
        source = src,
        getIdentifier = function() return identifier end,
        getJob = function() return { name = job, label = job, grade = src, grade_name = 'g', grade_label = 'G', onDuty = onDuty } end,
    }
end

local players = {
    [1] = xPlayer(1, 'char1:aaa', 'police', true),
    [2] = xPlayer(2, 'char1:bbb', 'police', false),
    [3] = xPlayer(3, 'char1:ccc', 'sheriff', true),
    [4] = xPlayer(4, 'char1:ddd', 'mechanic', true),
}

local function bootServer()
    T.exports.es_extended = { getSharedObject = function() return {
        GetPlayerFromId = function(src) return players[src] end,
        GetExtendedPlayers = function()
            local list = {}
            for _, p in pairs(players) do list[#list + 1] = p end
            return list
        end,
        GetPlayerFromIdentifier = function() end,
    } end }
    T.boot('server', { es_extended = 'started', ox_inventory = 'started' })
end

do
    bootServer()
    check('countJob on duty', TR.player.countJob('police', true) == 1)
    check('countJob any duty', TR.player.countJob('police') == 2)
    check('countJob a list of jobs', TR.player.countJob({ 'police', 'sheriff' }, true) == 2)
    check('countJob minimum grades', TR.player.countJob({ police = 2, sheriff = 0 }) == 2)
    check('countJob nobody', TR.player.countJob('ambulance', true) == 0)
    local cops = TR.player.getPlayersWithJob({ 'police', 'sheriff' }, true)
    table.sort(cops)
    check('getPlayersWithJob sources', #cops == 2 and cops[1] == 1 and cops[2] == 3)
end

---------------------------------------------------------------------------------------------------
-- Cooldowns
---------------------------------------------------------------------------------------------------

local kvp = {}
function SetResourceKvp(key, value) kvp[key] = value end
function GetResourceKvpString(key) return kvp[key] end
function DeleteResourceKvp(key) kvp[key] = nil end
local finds = {}
function StartFindKvp(prefix)
    local list = {}
    for key in pairs(kvp) do if key:sub(1, #prefix) == prefix then list[#list + 1] = key end end
    finds[#finds + 1] = list
    return #finds
end
function FindKvp(handle) return table.remove(finds[handle]) end
function EndFindKvp() end
local licenses = { [7] = 'license:777' }
function GetPlayerIdentifierByType(src, kind) return kind == 'license' and licenses[tonumber(src)] or nil end

local realTime = os.time
local now = 1000000
os.time = function() return now end

do
    bootServer()
    local rob = TR.cooldown.new('store_robbery', { seconds = 60, persist = true })

    local ok, left = rob:take(1)
    check('cooldown take: free, starts it', ok == true and left == nil and rob:left(1) == 60)
    check('cooldown kept by character', kvp['tr_cd:store_robbery:c:char1:aaa'] == tostring(now + 60))
    ok, left = rob:take(1)
    check('cooldown take: running, seconds to go', ok == false and left == 60)
    now = now + 45
    check('cooldown counts down', rob:left(1) == 15 and select(2, rob:take(1)) == 15)
    check('cooldown per owner', rob:take(3) == true and rob:left(3) == 60)
    now = now + 15
    check('cooldown over', rob:left(1) == 0 and kvp['tr_cd:store_robbery:c:char1:aaa'] == nil)
    check('cooldown take after it is over', rob:take(1) == true)

    check('cooldown whole server', rob:take() == true and rob:take() == false and rob:left() == 60)
    check('cooldown string owner', rob:take('fleeca_2') == true and rob:left('fleeca_2') == 60 and rob:left('fleeca_3') == 0)
    rob:start(1, 600)
    check('cooldown start with its own time', rob:left(1) == 600)
    rob:clear(1)
    check('cooldown clear', rob:left(1) == 0 and kvp['tr_cd:store_robbery:c:char1:aaa'] == nil and rob:take(1) == true)
    check('cooldown take with its own time', rob:take(4, 5.2) == true and rob:left(4) == 6)

    check('cooldown player without a character: license', rob:take(7) == true and kvp['tr_cd:store_robbery:l:license:777'] ~= nil)
    check('cooldown player not connected', rob:take(99) == false and select('#', rob:take(99)) == 1 and rob:left(99) == 0)
    check('cooldown float player id', rob:left(1.0) == rob:left(1))
    check('cooldown bad owner', not pcall(rob.take, rob, {}) and not pcall(rob.left, rob, 1.5))

    check('cooldown name once', not pcall(TR.cooldown.new, 'store_robbery', { seconds = 5 }))
    check('cooldown name checked', not pcall(TR.cooldown.new, 'bad name!', { seconds = 5 }) and not pcall(TR.cooldown.new, 'x', { seconds = 0 }))
    check('cooldown time checked', not pcall(rob.take, rob, 'x', 0) and not pcall(rob.start, rob, 'x', -5)
        and not pcall(rob.take, rob, 'x', 0 / 0) and not pcall(TR.cooldown.new, 'y', { seconds = math.huge }) and rob:left('x') == 0)

    local memory = TR.cooldown.new('memory_only', { seconds = 30 })
    memory:take(1)
    check('cooldown without persist keeps no KVP', kvp['tr_cd:memory_only:c:char1:aaa'] == nil and memory:left(1) == 30)

    -- A restart: what persisted comes back, what is over by then is dropped.
    kvp['tr_cd:store_robbery:s:old'] = tostring(now - 1)
    bootServer()
    rob = TR.cooldown.new('store_robbery', { seconds = 60, persist = true })
    check('cooldown persisted across a restart', rob:left(1) == 60 and rob:left(3) == 45 and rob:left() == 60 and rob:left('fleeca_2') == 60)
    check('cooldown over by the restart: dropped', kvp['tr_cd:store_robbery:s:old'] == nil)
    memory = TR.cooldown.new('memory_only', { seconds = 30 })
    check('cooldown without persist: a restart clears it', memory:left(1) == 0)

    -- The ones that are over are swept now and then, so a long-running server doesn't keep them all.
    local many = TR.cooldown.new('many', { seconds = 1, persist = true })
    for i = 1, 255 do many:take('o' .. i) end
    now = now + 5
    many:take('last')
    local n = 0
    for key in pairs(kvp) do if key:find('tr_cd:many:', 1, true) then n = n + 1 end end
    check('cooldown sweep', n == 1)
end

os.time = realTime

---------------------------------------------------------------------------------------------------
-- Streaming assets
---------------------------------------------------------------------------------------------------

do
    T.boot('client', {})
    local game = { ['prop_box'] = true, ['anim@carry'] = true } -- what exists
    local loaded, asked, freed = {}, {}, {}
    local loadAfter = {} -- name -> waits until it loads
    local function joaatOf(name) return ({ prop_box = -1515940233 })[name] end
    joaat = function(name) return joaatOf(name) or 12345 end
    local function nameOf(asset)
        if type(asset) == 'number' then return asset == -1515940233 and 'prop_box' or tostring(asset) end
        return asset
    end
    local function has(asset) return loaded[nameOf(asset)] == true end
    local function ask(asset)
        local name = nameOf(asset)
        asked[name] = (asked[name] or 0) + 1
        if game[name] and not loadAfter[name] then loaded[name] = true end
    end
    local function free(asset)
        local name = nameOf(asset)
        freed[name] = (freed[name] or 0) + 1
        loaded[name] = nil
    end
    IsModelInCdimage = function(hash) return game[nameOf(hash)] == true end
    HasModelLoaded, RequestModel, SetModelAsNoLongerNeeded = has, ask, free
    DoesAnimDictExist = function(dict) return game[dict] == true end
    HasAnimDictLoaded, RequestAnimDict, RemoveAnimDict = has, ask, free
    HasNamedPtfxAssetLoaded, RequestNamedPtfxAsset, RemoveNamedPtfxAsset = has, ask, free
    HasStreamedTextureDictLoaded, RequestStreamedTextureDict, SetStreamedTextureDictAsNoLongerNeeded = has, ask, free
    local waits = 0
    Wait = function()
        waits = waits + 1
        T.timer = T.timer + 100
        for name, n in pairs(loadAfter) do
            if n <= 1 then loadAfter[name], loaded[name] = nil, true else loadAfter[name] = n - 1 end
        end
    end

    T.timer = 0
    local hash = TR.stream.model('prop_box')
    check('stream model: its hash', hash == -1515940233 and loaded.prop_box)
    check('stream model by hash, unsigned too', TR.stream.model(-1515940233) == hash and TR.stream.model(-1515940233 + 0x100000000) == hash)
    TR.stream.release('model', 'prop_box')
    TR.stream.release('model', hash)
    check('stream: held until every load is released', loaded.prop_box and (freed.prop_box or 0) == 0)
    TR.stream.release('model', -1515940233 + 0x100000000)
    check('stream: the last release unloads it', freed.prop_box == 1 and not loaded.prop_box)
    TR.stream.release('model', hash)
    check('stream: releasing more than was loaded does nothing', freed.prop_box == 1)

    loaded.prop_box = true
    local before = asked.prop_box
    TR.stream.model('prop_box')
    check('stream: asked for even when already loaded', asked.prop_box == before + 1)
    TR.stream.release('model', 'prop_box')

    local logs = #T.logs
    check('stream model not in the game', TR.stream.model('nope') == nil and #T.logs == logs + 1 and T.logs[#T.logs]:find('is not in the game', 1, true))
    TR.stream.model('nope')
    check('stream: a failure is logged once', #T.logs == logs + 1)

    game.slow = true
    loadAfter.slow = 3
    waits = 0
    check('stream waits for it', TR.stream.anim('slow') == true and waits == 3)
    TR.stream.release('anim', 'slow')

    game.stuck = true
    loadAfter.stuck = 1000
    T.timer, waits = 0, 0
    check('stream gives up after the timeout', TR.stream.anim('stuck', 1000) == false and waits <= 11 and T.logs[#T.logs]:find('did not load in 1000 ms', 1, true))
    check('stream: a load that gave up takes its request back', freed.stuck == 1)

    game.core = true
    check('stream ptfx and texture', TR.stream.ptfx('core') and TR.stream.texture('anim@carry'))
    TR.stream.release('ptfx', 'core')
    check('stream ptfx released', freed.core == 1)
    check('stream bad input', not pcall(TR.stream.anim, 5) and not pcall(TR.stream.model, {}) and not pcall(TR.stream.release, 'sound', 'x'))

    -- A scene holds each model once, however often it uses it, and lets go of it when destroyed.
    freed.prop_box = 0
    local other = TR.stream.model('prop_box') -- another part of the same resource uses the model too
    local scene = setmetatable({ parts = {}, hashes = {} }, TR.scene)
    scene:preload({ 'prop_box', 'prop_box' })
    scene:destroy()
    check('scene: its models released, the other hold kept', freed.prop_box == 0 and loaded.prop_box)
    scene:destroy()
    TR.stream.release('model', other)
    check('scene: destroyed twice releases once', freed.prop_box == 1)
    check('scene: a model that is missing still errors', not pcall(scene.preload, scene, { 'nope' }))

    -- The resource using it stops: the game drops the models it streams straight after onResourceStop,
    -- so a scene still up loses its props inside the event (a prop left on a dropped model can't be
    -- deleted later, and can crash the game).
    local props, nextProp = {}, 7000
    CreateObjectNoOffset = function()
        nextProp = nextProp + 1
        props[nextProp] = true
        return nextProp
    end
    DoesEntityExist = function(e) return props[e] == true end
    DeleteEntity = function(e) props[e] = nil end
    GetEntityCoords = function() return vec3(0.0, 0.0, 0.0) end
    GetEntityRotation = function() return vec3(0.0, 0.0, 0.0) end
    local function none() end
    SetEntityCollision, FreezeEntityPosition, SetEntityInvincible, SetEntityLodDist, SetEntityMatrix = none, none, none, none, none
    local up = TR.scene.new(1, vec3(0.0, 0.0, 0.0), 0.0, 0.0)
    local box = up:spawn('box', 'prop_box').entity
    local over = TR.scene.new(1, vec3(0.0, 0.0, 0.0), 0.0, 0.0)
    over:spawn('box', 'prop_box')
    over:destroy()
    TriggerEvent('onResourceStop', 'another_resource')
    check('scene: another resource stopping leaves it be', props[box] == true)
    TriggerEvent('onResourceStop', GetCurrentResourceName())
    check('scene: its own resource stopping takes its props, inside the event', props[box] == nil and next(props) == nil
        and freed.prop_box == 2)
end

T.done('helpers')
