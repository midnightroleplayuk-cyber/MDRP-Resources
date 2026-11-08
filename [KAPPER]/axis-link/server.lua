-- Axis Link (server): asks AxisPanel for staff commands run in Discord, runs them, reports back.
-- Built for Qbox (qbx_core + ox_inventory).

local headers = function()
    return { ['Content-Type'] = 'application/json', ['X-Game-Key'] = Config.Key }
end

local function online(id)
    id = tonumber(id)
    if not id or GetPlayerName(id) == nil then return nil end
    return id
end

local function nameOf(id) return ('%s [%d]'):format(GetPlayerName(id) or '?', id) end

local handlers = {}

function handlers.teleport(a)
    local src = online(a.player)
    if not src then return false, 'That player is not online.' end
    local x, y, z
    if a.to then
        local target = online(a.to)
        if not target then return false, 'The destination player is not online.' end
        local c = GetEntityCoords(GetPlayerPed(target))
        x, y, z = c.x, c.y, c.z
    else
        x, y, z = a.x + 0.0, a.y + 0.0, a.z + 0.0
    end
    SetEntityCoords(GetPlayerPed(src), x, y, z, false, false, false, false)
    return true, ('Teleported %s to %.1f, %.1f, %.1f.'):format(nameOf(src), x, y, z)
end

function handlers.revive(a)
    local src = online(a.player)
    if not src then return false, 'That player is not online.' end
    TriggerClientEvent('axislink:client:revive', src)
    for _, e in ipairs(Config.ReviveEvents or {}) do TriggerClientEvent(e, src) end
    return true, ('Revived %s.'):format(nameOf(src))
end

function handlers.heal(a)
    local src = online(a.player)
    if not src then return false, 'That player is not online.' end
    TriggerClientEvent('axislink:client:heal', src)
    for _, e in ipairs(Config.HealEvents or {}) do TriggerClientEvent(e, src, 'full') end
    return true, ('Healed %s.'):format(nameOf(src))
end

function handlers.giveitem(a)
    local src = online(a.player)
    if not src then return false, 'That player is not online.' end
    local items = exports.ox_inventory:Items()
    if not items or not items[a.item] then return false, ('There is no item called "%s".'):format(a.item) end
    local ok = exports.ox_inventory:AddItem(src, a.item, tonumber(a.amount) or 1)
    if not ok then return false, ('Could not give the item to %s (inventory full or too heavy?).'):format(nameOf(src)) end
    return true, ('Gave %dx %s to %s.'):format(tonumber(a.amount) or 1, a.item, nameOf(src))
end

function handlers.kick(a)
    local src = online(a.player)
    if not src then return false, 'That player is not online.' end
    local label = nameOf(src)
    DropPlayer(src, a.reason or 'Removed by staff')
    return true, ('Removed %s from the server.'):format(label)
end

handlers.dropplayer = handlers.kick -- older name

function handlers.gameannounce(a)
    TriggerClientEvent('axislink:client:announce', -1, a.message or '')
    return true, 'Announcement sent to everyone in game.'
end

function handlers.setjob(a)
    local src = online(a.player)
    if not src then return false, 'That player is not online.' end
    local ok, err = pcall(function() return exports.qbx_core:SetJob(src, a.job, tonumber(a.grade) or 0) end)
    if not ok then return false, ('Could not set the job: %s'):format(tostring(err)) end
    return true, ('Set %s to %s (grade %d).'):format(nameOf(src), a.job, tonumber(a.grade) or 0)
end

function handlers.dm(a)
    local src = online(a.player)
    if not src then return false, 'That player is not online.' end
    TriggerClientEvent('axislink:client:dm', src, a.message or '')
    return true, ('Message sent to %s.'):format(nameOf(src))
end

function handlers.players()
    local list = {}
    for _, id in ipairs(GetPlayers()) do
        local p = exports.qbx_core:GetPlayer(tonumber(id))
        local job = p and p.PlayerData and p.PlayerData.job and p.PlayerData.job.name or '-'
        list[#list + 1] = ('[%s] %s (%s)'):format(id, GetPlayerName(id) or '?', job)
    end
    if #list == 0 then return true, 'Nobody is online.' end
    return true, ('%d online:\n%s'):format(#list, table.concat(list, '\n'))
end

local function post(path, body, cb)
    PerformHttpRequest(Config.Url .. path, function(status, text)
        if cb then cb(status, text) end
    end, 'POST', json.encode(body or {}), headers())
end

local function get(path, cb)
    PerformHttpRequest(Config.Url .. path, function(status, text)
        if cb then cb(status, text) end
    end, 'GET', '', headers())
end

local function run(job)
    local handler = handlers[job.command]
    local ok, success, message
    if not handler then
        ok, success, message = true, false, 'This resource does not know that command.'
    else
        ok, success, message = pcall(handler, job.args or {})
        if not ok then
            message = tostring(success)
            success = false
        end
    end
    post('/result', { id = job.id, ok = success and true or false, message = message })
end

CreateThread(function()
    if Config.Key == 'PASTE_YOUR_KEY_HERE' or Config.Url:find('https://axis-panel.com/api/game-link-node') then
        print('^1[axis-link] Set Config.Url and Config.Key in config.lua first.^7')
        return
    end
    print('^2[axis-link] Started. Asking AxisPanel for commands every ' .. Config.PollSeconds .. 's.^7')
    while true do
        get('/poll?players=' .. #GetPlayers(), function(status, text)
            if status == 401 then
                print('^1[axis-link] AxisPanel refused the key. Make a new one on the Game Link page.^7')
            elseif status == 200 then
                local data = json.decode(text or '{}') or {}
                for _, job in ipairs(data.commands or {}) do run(job) end
            end
        end)
        Wait((Config.PollSeconds or 2) * 1000)
    end
end)
