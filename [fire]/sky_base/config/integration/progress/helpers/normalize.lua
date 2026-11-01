-- Internal helpers for the export-based progress adapters below.
Sky._ProgressAdapter = {}
local helpers = Sky._ProgressAdapter

function helpers.Copy(value)
    local result = {}
    for key, item in pairs(value or {}) do result[key] = item end
    return result
end

function helpers.Normalize(label_or_data, duration, options, callback)
    local data
    if type(label_or_data) == "table" then
        data, callback = helpers.Copy(label_or_data), duration
    else
        if type(options) == "function"
            or (type(options) == "table" and rawget(options, "__cfx_functionReference") ~= nil) then
            callback, options = options, nil
        end
        data = helpers.Copy(options)
        data.label = data.label or data.text or label_or_data
        data.duration = data.duration or data.length or duration
    end
    data.label = data.label or data.text or "Progress"
    data.duration = data.duration or data.length or 5000
    data.name = data.name or "sky_progress"
    data.canCancel = data.canCancel ~= false
    data.useWhileDead = data.useWhileDead or false
    return data, callback
end

local function first(...)
    for index = 1, select("#", ...) do
        local value = select(index, ...)
        if value ~= nil then return value end
    end
    return false
end

function helpers.Disable(data, format)
    local source = data.disable or data.controlDisables
    if not source then return nil end
    local move = first(source.move, source.disableMovement)
    local car = first(source.car, source.vehicle, source.disableCarMovement)
    local mouse = first(source.mouse, source.disableMouse)
    local combat = first(source.combat, source.disableCombat)
    if format == "qb" then
        return { disableMovement = move, disableCarMovement = car, disableMouse = mouse, disableCombat = combat }
    end
    return { move = move, car = car, mouse = mouse, combat = combat, sprint = source.sprint or false }
end

local function text(value)
    if type(value) ~= "string" then return nil end
    value = value:match("^%s*(.-)%s*$")
    return value ~= "" and value or nil
end

function helpers.Animation(data, format)
    local source = data.anim or data.animation
    if not source then return nil end
    local scenario = text(source.scenario) or text(source.task)
    if scenario then
        if format == "qb" then return { task = scenario } end
        if format == "ox" then
            return { scenario = scenario, duration = source.duration, playEnter = source.playEnter }
        end
        return nil -- This provider does not document scenario support.
    end
    local dict = text(source.dict) or text(source.animDict)
    local clip = text(source.clip) or text(source.anim) or text(source.lib) or text(source.name)
    if not dict or not clip then return nil end
    local flag = source.flag or source.flags
    if format == "qb" then return { animDict = dict, anim = clip, flags = flag } end
    if format == "aty" then return { dict = dict, name = clip, flag = flag } end
    if format == "risk" then return { dict = dict, lib = clip } end
    return {
        dict = dict, clip = clip, flag = flag,
        blendIn = source.blendIn, blendOut = source.blendOut,
        duration = source.duration, playbackRate = source.playbackRate,
        lockX = source.lockX, lockY = source.lockY, lockZ = source.lockZ,
        playEnter = source.playEnter,
    }
end

function helpers.Prop(source, format)
    if not source then return nil end
    if source[1] then
        local result = {}
        for index, prop in ipairs(source) do result[index] = helpers.Prop(prop, format) end
        return result
    end
    local prop = helpers.Copy(source)
    if format == "qb" then
        prop.coords, prop.rotation = source.coords or source.pos, source.rotation or source.rot
        prop.pos, prop.rot = nil, nil
    else
        prop.pos, prop.rot = source.pos or source.coords, source.rot or source.rotation
        prop.coords, prop.rotation = nil, nil
    end
    return prop
end

function helpers.Completion(callback)
    local finished = false
    return function(cancelled)
        if finished then return end
        finished = true
        if callback then callback(cancelled and true or false) end
    end
end
