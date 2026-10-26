--[[
    Target bridge (open file). Supports ox_target, qb-target and qtarget, and falls back to
    a "press E" prompt with a menu when no target script is running.
    To add another target script, add a branch to Target.AddSphere and Target.Remove.

    Options use one format everywhere:
      { name, icon, label, distance, canInteract = function() end, onSelect = function() end }
]]
Target = {}

local system

local function detect()
    if system then return system end
    local want = Config.Target or 'auto'
    if want ~= 'auto' then
        system = want
    elseif GetResourceState('ox_target') == 'started' then
        system = 'ox'
    elseif GetResourceState('qb-target') == 'started' then
        system = 'qb'
    elseif GetResourceState('qtarget') == 'started' then
        system = 'qtarget'
    else
        system = 'keypress'
    end
    return system
end

function Target.System() return detect() end

-- qb-target / qtarget ship Font Awesome 5, which uses 'fas' rather than 'fa-solid'.
local function fa5(icon)
    return (tostring(icon or ''):gsub('^fa%-solid ', 'fas '))
end

local function maxDistance(options)
    local d = 0
    for _, o in ipairs(options) do d = math.max(d, o.distance or Config.InteractDistance or 1.5) end
    return d
end

local function legacyOptions(options)
    local out = {}
    for _, o in ipairs(options) do
        out[#out + 1] = {
            icon = fa5(o.icon),
            label = o.label,
            canInteract = function() return o.canInteract == nil or o.canInteract() end,
            action = function() o.onSelect() end,
        }
    end
    return out
end

-- ── Fallback: press E near the point ──────────────────────────────────────

local points = {}   -- handle -> { coords, options }
local nextId = 0
local showing = nil -- handle whose prompt is on screen

local function available(options)
    local out = {}
    for _, o in ipairs(options) do
        if o.canInteract == nil or o.canInteract() then out[#out + 1] = o end
    end
    return out
end

local function openMenu(opts)
    if #opts == 1 then return opts[1].onSelect() end
    local items = {}
    for _, o in ipairs(opts) do
        items[#items + 1] = { title = o.label, icon = (o.icon or ''):gsub('^fa%-solid fa%-', ''), onSelect = o.onSelect }
    end
    lib.registerContext({ id = 'vwi_target_menu', title = Config.Text.title, options = items })
    lib.showContext('vwi_target_menu')
end

local function keypressLoop()
    CreateThread(function()
        while true do
            local sleep = 500
            local me = GetEntityCoords(cache.ped)
            local best, bestDist, bestOpts
            for handle, p in pairs(points) do
                local dist = #(me - p.coords)
                if dist <= p.reach and (not bestDist or dist < bestDist) then
                    local opts = available(p.options)
                    if #opts > 0 then best, bestDist, bestOpts = handle, dist, opts end
                end
            end

            if best then
                sleep = 0
                local p = points[best]
                DrawMarker(28, p.coords.x, p.coords.y, p.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.06, 0.06, 0.06, 233, 211, 44, 200, false, false, 2, false, nil, nil, false)
                if showing ~= best and not InCamera and not Sitting then
                    showing = best
                    ShowHelp(nil, { { 'E', #bestOpts == 1 and bestOpts[1].label or Config.Text.title } })
                end
                if IsControlJustPressed(0, 38) and not IsNuiFocused() then
                    showing = nil
                    HideHelp()
                    openMenu(bestOpts)
                end
            elseif showing then
                showing = nil
                if not InCamera and not Sitting then HideHelp() end
            end
            Wait(sleep)
        end
    end)
end

-- ── Public API ────────────────────────────────────────────────────────────

--- @param name string unique zone name
--- @param data { coords: vector3, radius: number, debug: boolean, options: table[] }
--- @return any handle for Target.Remove
function Target.AddSphere(name, data)
    local sys = detect()
    if sys == 'ox' then
        return exports.ox_target:addSphereZone({
            coords = data.coords, radius = data.radius, debug = data.debug, options = data.options,
        })
    elseif sys == 'qb' or sys == 'qtarget' then
        local res = sys == 'qb' and 'qb-target' or 'qtarget'
        exports[res]:AddCircleZone(name, data.coords, data.radius,
            { name = name, debugPoly = data.debug, useZ = true },
            { options = legacyOptions(data.options), distance = maxDistance(data.options) })
        return { res = res, name = name }
    else
        if not Target._loop then Target._loop = true keypressLoop() end
        nextId = nextId + 1
        points[nextId] = { coords = data.coords, reach = maxDistance(data.options) + (data.radius or 0), options = data.options }
        return nextId
    end
end

function Target.Remove(handle)
    if handle == nil then return end
    local sys = detect()
    if sys == 'ox' then
        exports.ox_target:removeZone(handle)
    elseif type(handle) == 'table' and handle.res then
        exports[handle.res]:RemoveZone(handle.name)
    else
        if showing == handle then showing = nil HideHelp() end
        points[handle] = nil
    end
end
