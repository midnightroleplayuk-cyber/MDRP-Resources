-- Hardening tests: flag throttling, the Discord queue, exclusive callbacks, checked client answers,
-- vector checks and the mirror's watch loop (stubs from tests/stubs.lua).
local check = T.check

-- Timers run when the test says so.
local timers = {}
SetTimeout = function(ms, fn) timers[#timers + 1] = { ms = ms, fn = fn } end
local function runTimers()
    local list = timers
    timers = {}
    for _, t in ipairs(list) do t.fn() end
    return #list
end

-- A promise that resolves at once; Citizen.Await returns what it was resolved with.
promise = { new = function()
    local p = {}
    function p:resolve(v) if not self.done then self.done, self.value = true, v end end
    function p:reject(e) error(e, 0) end
    return p
end }
Citizen = { Await = function(p)
    assert(p.done, 'awaited a promise nobody resolved')
    return p.value
end }

local function replies(name)
    local out = {}
    for _, e in ipairs(T.clientEvents) do
        if e.name == name then out[#out + 1] = e end
    end
    return out
end

---------------------------------------------------------------------------------------------------
-- validate: vectors and the default string length
---------------------------------------------------------------------------------------------------

T.boot('server', { es_extended = 'started', ox_inventory = 'started' })
local v = TR.validate
local nan = 0 / 0

check('vector3 ok', v.value('vector3', vector3(1, 2, 3)))
check('vector3 NaN', not v.value('vector3', vector3(nan, 2, 3)))
check('vector3 inf', not v.value('vector3', vector3(1, math.huge, 3)))
check('vector3 -inf z', not v.value('vector3', vector3(1, 2, -math.huge)))
check('vector3 in args', not v.args({ 'vector3' }, vector3(1, nan, 3)))
check('vector3 in fields', not v.value({ type = 'table', fields = { at = 'vector3' } }, { at = vector3(nan, 0, 0) }))

local long = ('a'):rep(v.STRING_MAX + 1)
check('string default max', not v.value('string', long) and v.value('string', long:sub(2)))
check('string own max wins', v.value({ type = 'string', max = 10000 }, long))
local _, err = v.value('string', long, 'note')
check('string default max error', err == ('note must be at most %d characters'):format(v.STRING_MAX))

---------------------------------------------------------------------------------------------------
-- guard.flag: the first flag in a window is reported, the rest summed up once
---------------------------------------------------------------------------------------------------

local embeds = {}
T.exports.tr_core = { discord = function(_, channel, embed) embeds[#embeds + 1] = { channel = channel, embed = embed } end }

for i = 1, 5 do TR.guard.flag(4, 'bad payload ' .. i, i == 1 and { amount = -1 } or nil) end
check('flag event every time', T.count('tr:playerFlagged') == 5)
check('flag reported once', #embeds == 1 and embeds[1].channel == 'security' and embeds[1].embed.description == 'bad payload 1')
check('flag details field', embeds[1].embed.fields[3] and embeds[1].embed.fields[3].value:find('^```json\n') ~= nil)
check('flag one window timer', #timers == 1 and timers[1].ms == 60000)

TR.guard.flag(5, 'other player')
check('flag per player', #embeds == 2)

runTimers()
check('flag summary', #embeds == 3 and embeds[3].embed.title == 'Player flagged again'
    and embeds[3].embed.description == '4 more in 60 s; the last: bad payload 5')
check('flag no summary when alone', #embeds == 3)

TR.guard.flag(4, 'later')
check('flag new window after summary', #embeds == 4 and embeds[4].embed.description == 'later')
TR.guard.flag(4, 'again')
T.fromClient(4, 'playerDropped')
check('flag summary on drop', #embeds == 5 and embeds[5].embed.description:find('^1 more') ~= nil)
runTimers()
check('flag window timer after drop is quiet', #embeds == 5)

local huge = {}
for i = 1, 400 do huge[i] = i end
json.encode = function() return ('x'):rep(5000) end
TR.guard.flag(6, 'huge details', huge)
json.encode = function() return '{}' end
local value = embeds[#embeds].embed.fields[3].value
check('flag details cut inside the code block', #value < 1024 and value:sub(-4) == '\n```')
timers = {}

---------------------------------------------------------------------------------------------------
-- Discord queue (tr_core's own server/main.lua)
---------------------------------------------------------------------------------------------------

do
    T.resource = 'tr_core'
    T.exports.es_extended = { getSharedObject = function()
        return { GetExtendedPlayers = function() return {} end, GetPlayerFromId = function() end }
    end }
    T.boot('server', { es_extended = 'started', ox_inventory = 'started', ox_target = 'started' })
    T.serverConfig = { webhooks = { default = 'https://discord.test/hook', money = 'https://discord.test/money' } }
    T.ownExports = {}

    local posts, bodies = {}, {}
    PerformHttpRequest = function(url, cb, method, body) posts[#posts + 1] = { url = url, cb = cb, body = body } end
    json.encode = function(t) bodies[#bodies + 1] = t return tostring(#bodies) end

    load(LoadResourceFile('tr_core', 'server/main.lua'), '@main.lua')()
    local discord = T.ownExports.discord

    local function lastEmbeds() return bodies[#bodies].embeds end

    discord('security', { title = 'one' }, 'tr_test')
    check('discord sends the first at once', #posts == 1 and posts[1].url == 'https://discord.test/hook' and #lastEmbeds() == 1)
    check('discord footer + timestamp', lastEmbeds()[1].footer.text == 'tr_test • security' and lastEmbeds()[1].timestamp ~= nil)
    check('discord no pings', bodies[1].allowed_mentions ~= nil and bodies[1].allowed_mentions.parse == nil)

    for i = 1, 12 do discord('security', { title = 'queued ' .. i }) end
    check('discord waits while one is out', #posts == 1)

    posts[1].cb(204)
    check('discord next after the gap', #posts == 1 and #timers == 1 and timers[1].ms == 2000)
    runTimers()
    check('discord batches 10', #posts == 2 and #lastEmbeds() == 10 and lastEmbeds()[1].title == 'queued 1')

    -- 429: the same batch again, after Discord's wait.
    posts[2].cb(429, '{"retry_after": 1.5, "global": false}', {})
    check('discord 429 waits as told', #timers == 1 and timers[1].ms == 1750)
    runTimers()
    check('discord 429 sends the same batch', #posts == 3 and #lastEmbeds() == 10 and lastEmbeds()[1].title == 'queued 1')
    posts[3].cb(200)
    runTimers()
    check('discord rest', #posts == 4 and #lastEmbeds() == 2 and lastEmbeds()[2].title == 'queued 12')

    -- A server error is sent once more, then given up.
    posts[4].cb(502)
    runTimers()
    check('discord 5xx retried', #posts == 5 and #lastEmbeds() == 2)
    posts[5].cb(503)
    runTimers()
    check('discord 5xx given up after two tries', #posts == 5 and #timers == 0)

    -- Channels with their own webhook have their own queue.
    discord('money', { title = 'paid' })
    check('discord per-webhook queue', #posts == 6 and posts[6].url == 'https://discord.test/money')
    posts[6].cb(204)
    runTimers()

    -- Discord's limits.
    discord('security', {
        title = ('t'):rep(300),
        description = ('é'):rep(5000),
        fields = { { name = '', value = '' }, { name = 'long', value = ('v'):rep(2000) } },
    })
    local e = lastEmbeds()[1]
    check('discord title cut', utf8.len(e.title) == 256)
    check('discord description cut by characters', utf8.len(e.description) == 4096)
    check('discord empty field filled', e.fields[1].name == '-' and e.fields[1].value == '-')
    check('discord field value cut', utf8.len(e.fields[2].value) == 1024)
    posts[#posts].cb(204)
    runTimers()

    -- Big embeds don't go ten to a message past Discord's 6000 characters.
    for i = 1, 3 do discord('security', { description = ('d'):rep(3000) }) end
    local before = #posts
    posts[#posts].cb(204)
    runTimers()
    check('discord message size', #posts == before + 1 and #lastEmbeds() == 1)

    -- The queue is bounded.
    for i = 1, 250 do discord('security', { title = 'flood ' .. i }) end
    local held = 0
    while #posts > 0 do
        local p = posts[#posts]
        posts = {}
        p.cb(204)
        if runTimers() == 0 then break end
        if #posts > 0 then held = held + #lastEmbeds() end
    end
    check('discord queue bounded', held <= 200 and held > 150)
    check('discord embed not a table ignored', pcall(discord, 'security', 'x') and pcall(discord, nil, {}))

    json.encode = function() return '{}' end
    T.resource = 'tr_example'
    timers = {}
end

---------------------------------------------------------------------------------------------------
-- Exclusive callbacks and net events
---------------------------------------------------------------------------------------------------

T.boot('server', { es_extended = 'started', ox_inventory = 'started' })

do
    local runs, nested = 0, nil
    TR.callback.register('tr_test:claim', function(src)
        runs = runs + 1
        -- A second call from the same player arrives while this one waits on something.
        if runs == 1 then T.fromClient(src, '__tr_cb:tr_test:claim', 'tr_test', 2) end
        if runs == 1 then T.fromClient(9, '__tr_cb:tr_test:claim', 'tr_test', 3) end
        return 'done'
    end, { exclusive = true })

    T.fromClient(1, '__tr_cb:tr_test:claim', 'tr_test', 1)
    local r = replies('__tr_cbr:tr_test')
    check('exclusive: second call busy', r[1].args[1] == 2 and r[1].args[2] == false and r[1].args[3] == 'in_progress')
    check('exclusive: other players not blocked', r[2].target == 9 and r[2].args[2] == true)
    check('exclusive: first call answers', r[3].args[1] == 1 and r[3].args[2] == true and r[3].args[3] == 'done')
    check('exclusive: ran twice (player 1 once, player 9 once)', runs == 2)

    T.fromClient(1, '__tr_cb:tr_test:claim', 'tr_test', 4)
    r = replies('__tr_cbr:tr_test')
    check('exclusive: free again after', r[#r].args[1] == 4 and r[#r].args[2] == true and runs == 3)

    TR.callback.register('tr_test:boom', function() error('boom') end, { exclusive = true })
    T.fromClient(1, '__tr_cb:tr_test:boom', 'tr_test', 5)
    T.fromClient(1, '__tr_cb:tr_test:boom', 'tr_test', 6)
    r = replies('__tr_cbr:tr_test')
    check('exclusive: freed after an error', r[#r].args[1] == 6 and r[#r].args[3] == 'error')

    local hits = 0
    TR.callback.register('tr_test:open', function(src)
        hits = hits + 1
        if hits == 1 then T.fromClient(src, '__tr_cb:tr_test:open', 'tr_test', 8) end
    end)
    T.fromClient(1, '__tr_cb:tr_test:open', 'tr_test', 7)
    check('not exclusive by default', hits == 2)

    local events = 0
    TR.net.on('tr_test:use', function(src)
        events = events + 1
        if events == 1 then T.fromClient(src, 'tr_test:use') end
    end, { exclusive = true })
    T.fromClient(1, 'tr_test:use')
    T.fromClient(1, 'tr_test:use')
    check('net exclusive drops while running, then runs', events == 2)
end

---------------------------------------------------------------------------------------------------
-- TR.guard.lock / exclusive: the lock exclusive handlers hold, shared with other ways in
---------------------------------------------------------------------------------------------------

do
    local g = TR.guard
    local release = g.lock(1, 'k')
    check('lock taken', release ~= nil)
    check('lock held', g.lock(1, 'k') == nil)
    check('lock per player', g.lock(2, 'k') ~= nil)
    check('lock per key', g.lock(1, 'other') ~= nil)
    release()
    release() -- twice is harmless
    local again = g.lock(1, 'k')
    check('lock released', again ~= nil)
    again()

    -- A player who leaves holding one: their locks go; the old release doesn't touch a new player's.
    local old = g.lock(3, 'k')
    T.fromClient(3, 'playerDropped')
    local new = g.lock(3, 'k')
    check('lock gone on drop', new ~= nil)
    old()
    check('old release leaves the new lock', g.lock(3, 'k') == nil)
    new()

    check('exclusive returns', select('#', g.exclusive(1, 'x', function(a, b) return a, b end, 1, 2)) == 2)
    local inner
    g.exclusive(1, 'x', function() inner = table.pack(g.exclusive(1, 'x', function() return true end)) end)
    check('exclusive nested busy', inner[1] == false and inner[2] == 'in_progress')
    check('exclusive error raised', not pcall(g.exclusive, 1, 'x', function() error('boom') end))
    check('exclusive released after error', g.exclusive(1, 'x', function() return 'ok' end) == 'ok')

    -- Another way into an exclusive callback (an app on the laptop, say) takes its name and blocks it.
    local ran = 0
    TR.callback.register('tr_test:shared', function() ran = ran + 1 return true end, { exclusive = true })
    local viaApp
    g.exclusive(1, 'tr_test:shared', function()
        T.fromClient(1, '__tr_cb:tr_test:shared', 'tr_test', 50)
        viaApp = replies('__tr_cbr:tr_test')
    end)
    local last = viaApp[#viaApp]
    check('callback blocked by the shared lock', ran == 0 and last.args[1] == 50 and last.args[3] == 'in_progress')
    T.fromClient(1, '__tr_cb:tr_test:shared', 'tr_test', 51)
    check('callback runs once the lock is free', ran == 1)
end

---------------------------------------------------------------------------------------------------
-- guard.isNear / isNearEntity: routing buckets
---------------------------------------------------------------------------------------------------

do
    T.boot('server', { es_extended = 'started', ox_inventory = 'started' })
    T.coords = { [1] = vector3(10, 0, 0), [900] = vector3(11, 0, 0) }
    T.buckets, T.entityBuckets = { [1] = 4 }, { [900] = 4 }

    check('isNear without a bucket ignores buckets', TR.guard.isNear(1, vector3(10, 0, 0), 2.0))
    check('isNear in the given bucket', TR.guard.isNear(1, vector3(10, 0, 0), 2.0, 4))
    check('isNear in another bucket', not TR.guard.isNear(1, vector3(10, 0, 0), 2.0, 0))
    check('isNearEntity same bucket', TR.guard.isNearEntity(1, 900, 2.0))
    check('isNearEntity too far', not TR.guard.isNearEntity(1, 900, 0.5))
    T.entityBuckets[900] = 0
    check('isNearEntity other bucket at the same spot', not TR.guard.isNearEntity(1, 900, 2.0))
    check('isNearEntity no entity', not TR.guard.isNearEntity(1, 0, 2.0) and not TR.guard.isNearEntity(1, nil, 2.0))

    T.coords, T.buckets, T.entityBuckets = nil, nil, nil
end

---------------------------------------------------------------------------------------------------
-- Asking a client: checked answers, players who left
---------------------------------------------------------------------------------------------------

do
    local answer = table.pack(42)
    local realTrigger = TriggerClientEvent
    TriggerClientEvent = function(name, target, ...)
        realTrigger(name, target, ...)
        if name == '__tr_cb:tr_test:ask' then
            local _, id = ...
            if answer == 'drop' then
                T.fromClient(target, 'playerDropped')
            elseif answer.failed then
                T.fromClient(target, '__tr_cbr:tr_example', id, false, answer.failed)
            else
                T.fromClient(target, '__tr_cbr:tr_example', id, true, table.unpack(answer, 1, answer.n))
            end
        end
    end

    local schema = { schema = { { type = 'integer', min = 0, max = 100 } } }
    check('await plain', TR.callback.await('tr_test:ask', 3) == 42)
    check('awaitChecked valid', TR.callback.awaitChecked('tr_test:ask', 3, schema) == 42)
    check('await accepts a string id', TR.callback.await('tr_test:ask', '3') == 42)

    local flagged = T.count('tr:playerFlagged')
    answer = table.pack(5000)
    local value, code = TR.callback.awaitChecked('tr_test:ask', 3, schema)
    check('awaitChecked out of range', value == nil and code == 'invalid_answer' and T.count('tr:playerFlagged') == flagged + 1)

    answer = table.pack(vector3(nan, 0, 0))
    value, code = TR.callback.awaitChecked('tr_test:ask', 3, { schema = { 'vector3' }, flag = false })
    check('awaitChecked NaN vector, not flagged', value == nil and code == 'invalid_answer' and T.count('tr:playerFlagged') == flagged + 1)

    answer = table.pack(1, 2)
    value, code = TR.callback.awaitChecked('tr_test:ask', 3, schema)
    check('awaitChecked extra values', value == nil and code == 'invalid_answer')

    -- A client that says it failed can only say 'error': the code it sends isn't passed on.
    answer = { failed = { huge = string.rep('x', 10000) } }
    value, code = TR.callback.awaitChecked('tr_test:ask', 3, schema)
    check('a failure from the client is just error', value == nil and code == 'error')
    answer = { failed = 'timeout' }
    value, code = TR.callback.await('tr_test:ask', 3)
    check('a client cannot pass for a timeout', value == nil and code == 'error')

    answer = 'drop'
    value, code = TR.callback.await('tr_test:ask', 3)
    check('await ends when the player leaves', value == nil and code == 'offline')

    local realName = GetPlayerName
    GetPlayerName = function() return nil end
    local sent = #T.clientEvents
    value, code = TR.callback.await('tr_test:ask', 3)
    check('await to a player not on the server', value == nil and code == 'offline' and #T.clientEvents == sent)
    GetPlayerName = realName

    check('await bad id', select(2, TR.callback.await('tr_test:ask', 0)) == 'offline' and select(2, TR.callback.await('tr_test:ask', 'x')) == 'offline')

    -- A timeout uses the call's own when given.
    TriggerClientEvent = realTrigger
    timers = {}
    local co = coroutine.wrap(function() return TR.callback.awaitChecked('tr_test:ask', 3, { timeout = 1500 }) end)
    local ok = pcall(co)
    check('awaitChecked own timeout', #timers == 1 and timers[1].ms == 1500)
    timers = {}
end

---------------------------------------------------------------------------------------------------
-- Mirror: a game whose check errors can't stop the watch loop
---------------------------------------------------------------------------------------------------

do
    GetPlayers = function() return { '1', '2' } end
    NetworkGetNetworkIdFromEntity = function(e) return e - 1000 end
    T.boot('server', { es_extended = 'started', ox_inventory = 'started' })
    timers = {}
    local Mirror = TR.mirror
    check('mirror loop armed', #timers == 1 and timers[1].ms == 500)

    check('mirror start needs active', not pcall(Mirror.start, 1, 5000, { maxDuration = 60 }))
    check('mirror start needs maxDuration', not pcall(Mirror.start, 1, 5000, { active = function() return true end }))

    Mirror.start(1, 5000, { active = function() error('game broke') end, maxDuration = 60 })
    Mirror.start(2, 5001, { active = function() return true end, maxDuration = 60 })
    T.timer = 10000 -- past the 3 s grace, so `active` is asked

    local ok = pcall(Mirror.watch)
    check('mirror watch survives an erroring game', ok)
    check('mirror erroring game logged', T.logs[#T.logs]:find('mirror of 1 ended', 1, true) ~= nil)

    -- Player 1's mirror is gone: its packets are ignored. Player 2's still takes them.
    local before = #T.clientEvents
    T.fromClient(1, 'tr_example:mirror', { o = { 'g', 0, 0, 0, 0 } })
    T.fromClient(2, 'tr_example:mirror', { o = { 'g', 0, 0, 0, 0 } })
    check('mirror erroring game ended, other kept', #T.clientEvents == before) -- no viewers yet
    pcall(Mirror.watch)
    local fulls = 0
    for i = before + 1, #T.clientEvents do
        if T.clientEvents[i].name == 'tr_example:mirror' and T.clientEvents[i].args[1] == 2 then fulls = fulls + 1 end
    end
    check('mirror other game still watched', fulls == 1)

    -- Player 1 (the viewer) goes into another routing bucket at the same spot: no longer near, and back again.
    local function sent(name, viewer, from)
        local n = 0
        for i = from + 1, #T.clientEvents do
            local e = T.clientEvents[i]
            if e.name == name and tonumber(e.target) == viewer and e.args[1] == 2 then n = n + 1 end
        end
        return n
    end
    T.buckets = { [1] = 7 }
    local mark = #T.clientEvents
    pcall(Mirror.watch)
    check('mirror viewer in another bucket ended', sent('tr_example:mirrorEnd', 1, mark) == 1)
    T.buckets, mark = nil, #T.clientEvents
    pcall(Mirror.watch)
    check('mirror viewer back in the bucket gets it again', sent('tr_example:mirror', 1, mark) == 1)
    -- The game's entity in a bucket of its own: the viewer in bucket 0 doesn't get it.
    T.entityBuckets, mark = { [5001] = 3 }, #T.clientEvents
    pcall(Mirror.watch)
    check('mirror entity in another bucket', sent('tr_example:mirrorEnd', 1, mark) == 1)
    T.entityBuckets = nil

    -- The loop re-arms before it watches, so even an error inside watch keeps it going.
    local list = timers
    timers = {}
    rawset(Mirror, 'watch', function() error('watch broke') end)
    pcall(list[1].fn)
    check('mirror loop re-armed', #timers == 1)
    T.timer = 0
end

T.done('security')
