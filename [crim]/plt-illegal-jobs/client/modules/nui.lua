local Nui = {}

local pending = {}
local requestSeq = 0
local minigameActive = false

local DISABLE_CONTROLS = {
    move   = { 30, 31, 36, 21, 22, 44 },
    car    = { 63, 64, 71, 72, 75, 76 },
    combat = { 24, 25, 47, 58, 140, 141, 142, 143, 257, 263, 264 },
    sprint = { 21 },
}

local function nextId(prefix)
    requestSeq = requestSeq + 1
    return ('%s-%d-%d'):format(prefix, requestSeq, GetGameTimer())
end

local function send(action, data)
    SendNUIMessage({ action = action, data = data })
end

local function restoreFocus()
    local uiOpen = client and client.uiOpen == true
    SetNuiFocus(uiOpen, uiOpen)
end

local function awaitResult(id, timeoutMs)
    local p = promise.new()
    pending[id] = p

    SetTimeout(timeoutMs or 120000, function()
        if not pending[id] then return end
        local waiter = pending[id]
        pending[id] = nil
        waiter:resolve({ success = false, cancelled = true })
    end)

    return Citizen.Await(p)
end

local function applyDisableFlags(flags)
    if not flags then return end
    for key, controls in pairs(DISABLE_CONTROLS) do
        if flags[key] then
            for i = 1, #controls do
                DisableControlAction(0, controls[i], true)
            end
        end
    end
end

---@param title string
---@param ntype 'inform'|'error'|'success'|'warning'
---@param duration number|nil
---@param description string|nil
function Nui.notify(title, ntype, duration, description)
    send('hud:notify', {
        title       = title,
        type        = ntype or 'inform',
        duration    = duration or 4000,
        description = description,
    })
end

function Nui.showTextUI(text, options)
    options = options or {}
    send('hud:textUI', {
        visible  = true,
        text     = text,
        position = options.position or 'bottom-center',
    })
end

function Nui.hideTextUI()
    send('hud:textUI', { visible = false, text = '' })
end

---@param data table
---@return boolean
function Nui.progressBar(data)
    data = data or {}
    local pb = (Config.UI or {}).ProgressBar or {}
    local duration = math.max(100, tonumber(data.duration) or tonumber(pb.DefaultDuration) or 5000)
    local id = nextId('progress')
    local ped = cache.ped

    send('hud:progress', {
        id        = id,
        visible   = true,
        label     = data.label or 'Progress',
        duration  = duration,
        canCancel = data.canCancel == true,
    })

    local anim = data.anim
    local animPlaying = false
    if anim and anim.dict and anim.clip then
        lib.requestAnimDict(anim.dict)
        TaskPlayAnim(ped, anim.dict, anim.clip, 8.0, -8.0, -1, anim.flag or 49, 0.0, false, false, false)
        animPlaying = true
    end

    local endTime = GetGameTimer() + duration
    local success = true

    while GetGameTimer() < endTime do
        Wait(0)
        applyDisableFlags(data.disable or pb.Disable)

        if not data.useWhileDead and IsEntityDead(ped) then
            success = false
            break
        end

        if data.canCancel and (IsControlJustPressed(0, 200) or IsControlJustPressed(0, 177)) then
            success = false
            break
        end
    end

    if animPlaying then
        StopAnimTask(ped, anim.dict, anim.clip, 1.0)
        RemoveAnimDict(anim.dict)
    end

    send('hud:progress', { id = id, visible = false })
    return success
end

---@param game string
---@param opts table|nil
---@return boolean
function Nui.playMinigame(game, opts)
    if minigameActive then
        if Config.debug then lib.print.error('Nui.playMinigame failed: minigame already active') end
        return false
    end
    opts = opts or {}
    local UiConfig = require 'client.modules.ui'
    local resolvedGame, merged = UiConfig.applyMinigame(game, opts)
    local id = nextId('mg')
    minigameActive = true
    SetNuiFocus(true, true)

    if Config.debug then lib.print.info(('Starting minigame: %s (id: %s)'):format(resolvedGame, id)) end

    send('hud:minigame', {
        id          = id,
        visible     = true,
        game        = string.lower(resolvedGame or ''),
        difficulty  = merged.difficulty or 2,
        rounds      = merged.rounds,
        pins        = merged.pins,
        parts       = merged.parts,
        packets     = merged.packets,
        length      = merged.length,
        tumblers    = merged.tumblers,
        shots       = merged.shots,
        hands       = merged.hands,
        allowCancel = merged.allowCancel,
        sound       = merged.sound,
        volume      = merged.volume,
    })

    local result = awaitResult(id, 180000)
    if Config.debug then
        lib.print.info(('Minigame result id: %s, success: %s, cancelled: %s'):format(id, tostring(result.success), tostring(result.cancelled)))
    end

    minigameActive = false
    -- Always drop focus first so players never get stuck if tablet state is stale
    SetNuiFocus(false, false)
    pcall(SetNuiFocusKeepInput, false)
    restoreFocus()
    send('hud:minigame', { visible = false })

    return result.success == true
end

---@param games table
---@param opts table|nil
---@return boolean success, number completed, number total
function Nui.playMinigameChain(games, opts)
    opts = opts or {}
    local stopOnFail = opts.stopOnFail ~= false
    local total = #(games or {})
    local completed = 0

    for i = 1, total do
        local stage = games[i]
        local gameId, stageOpts

        if type(stage) == 'table' then
            gameId = stage.game or stage[1]
            stageOpts = stage
        else
            gameId = stage
            stageOpts = { difficulty = opts.difficulty or 2 }
        end

        local ok = Nui.playMinigame(gameId, stageOpts)
        if ok then
            completed = completed + 1
        elseif stopOnFail then
            return false, completed, total
        end

        if i < total then Wait(opts.delay or 250) end
    end

    return completed == total, completed, total
end

--- Legacy ox_lib-style skill check → skillcheck minigame
---@param difficulty string[]
---@param inputs string[]|nil
---@return boolean
function Nui.skillCheck(difficulty, inputs)
    local mg = (Config.UI or {}).Minigame or {}
    local diff = mg.DefaultDifficulty or 2
    local rounds = #(difficulty or {})
    for _, level in ipairs(difficulty or {}) do
        level = string.lower(tostring(level))
        if level == 'hard' then
            diff = math.max(diff, 4)
        elseif level == 'medium' then
            diff = math.max(diff, 3)
        else
            diff = math.max(diff, 2)
        end
    end
    if rounds < 1 then rounds = (mg.Games and mg.Games.skillcheck and mg.Games.skillcheck.rounds) or 2 end
    local skillDefaults = (mg.Games or {}).skillcheck or {}
    return Nui.playMinigame('skillcheck', {
        difficulty = diff,
        rounds = rounds,
        allowCancel = skillDefaults.allowCancel,
    })
end

---@param heading string
---@param fields table[]
---@return table|nil
function Nui.inputDialog(heading, fields)
    local id = nextId('input')
    SetNuiFocus(true, true)

    send('hud:inputDialog', {
        id      = id,
        visible = true,
        heading = heading,
        fields  = fields or {},
    })

    local result = awaitResult(id, 300000)
    send('hud:inputDialog', { visible = false })
    restoreFocus()

    if result.cancelled or result.success == false then return nil end
    return result.values
end

---@param opts table
---@return boolean
function Nui.alertDialog(opts)
    opts = opts or {}
    local id = nextId('alert')
    SetNuiFocus(true, true)

    send('hud:alertDialog', {
        id       = id,
        visible  = true,
        header   = opts.header or opts.title,
        content  = opts.content or opts.description,
        labels   = opts.labels,
        cancel   = opts.cancel ~= false,
    })

    local result = awaitResult(id, 120000)
    send('hud:alertDialog', { visible = false })
    restoreFocus()
    return result.confirmed == true
end

--- NPC choice dialogue (mouse UI). Returns selected choice id, or nil if cancelled.
---@param opts { ped?: number|nil, text: string, choices: { id: string, label: string, style?: string }[], style?: 'bubble'|'panel', timeout?: number }
---@return string|nil
function Nui.npcDialogue(opts)
    opts = opts or {}
    local choices = opts.choices or {}
    if #choices == 0 then return nil end

    local id = nextId('dlg')
    local ped = opts.ped
    local tracking = true

    Nui.hideTextUI()
    SetNuiFocus(true, true)

    send('hud:dialogue', {
        id      = id,
        visible = true,
        text    = opts.text or '',
        choices = choices,
        style   = opts.style or (ped and 'bubble' or 'panel'),
    })

    CreateThread(function()
        while tracking do
            if ped and DoesEntityExist(ped) then
                local coords = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.15)
                local onScreen, sx, sy = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
                send('hud:dialoguePos', {
                    onScreen = onScreen == true or onScreen == 1,
                    x = sx or 0.5,
                    y = sy or 0.35,
                })
            else
                send('hud:dialoguePos', { onScreen = false })
            end
            Wait(0)
        end
    end)

    local result = awaitResult(id, opts.timeout or 180000)
    tracking = false
    send('hud:dialogue', { visible = false })
    send('hud:dialoguePos', { onScreen = false })
    restoreFocus()

    if result.cancelled or result.success == false or not result.choice then
        return nil
    end
    return result.choice
end

RegisterNUICallback('hud:result', function(body, cb)
    local id = body and body.id
    if Config.debug then
        lib.print.info(('Received minigame result for id: %s, success: %s'):format(tostring(id), tostring(body and body.success)))
    end
    if id and pending[id] then
        local waiter = pending[id]
        pending[id] = nil
        waiter:resolve(body)
    end
    cb('ok')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for id, waiter in pairs(pending) do
        pending[id] = nil
        waiter:resolve({ success = false, cancelled = true })
    end
    send('hud:textUI', { visible = false, text = '' })
    send('hud:progress', { visible = false })
    send('hud:minigame', { visible = false })
    send('hud:inputDialog', { visible = false })
    send('hud:alertDialog', { visible = false })
    send('hud:dialogue', { visible = false })
end)

return Nui
