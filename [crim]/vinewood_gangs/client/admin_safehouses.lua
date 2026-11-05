-- Staff safehouse set-up: /gangadmin > Safehouses > Set up a safehouse

local STEPS = { 'entrance', 'spawn', 'stash', 'exit' }
local editing = false

local function point()
    local p = GetEntityCoords(cache.ped)
    return { x = p.x, y = p.y, z = p.z, w = GetEntityHeading(cache.ped) }
end

---Waits for E (capture) or Backspace (cancel) at each step, drawing markers. Returns the points, or nil if cancelled.
local function captureSteps(steps, captured, toPoint)
    local step = 1
    lib.showTextUI(locale('safehouse_editor_' .. steps[step]))
    while true do
        local pos = GetEntityCoords(cache.ped)
        DrawMarker(1, pos.x, pos.y, pos.z - 1.0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.4, 95, 191, 122, 120, false, false, 2, false, nil, nil, false)
        if IsControlJustPressed(0, 38) then -- E
            captured[steps[step]] = toPoint()
            step = step + 1
            lib.hideTextUI()
            if step > #steps then return captured end
            lib.showTextUI(locale('safehouse_editor_' .. steps[step]))
        elseif IsControlJustPressed(0, 177) then -- Backspace
            lib.hideTextUI()
            return nil
        end
        Wait(0)
    end
end

local function moveTo(p)
    DoScreenFadeOut(300)
    while not IsScreenFadedOut() do Wait(10) end
    FreezeEntityPosition(cache.ped, true)
    SetEntityCoords(cache.ped, p.x, p.y, p.z, false, false, false, false)
    Wait(700)
    FreezeEntityPosition(cache.ped, false)
    DoScreenFadeIn(300)
end

local function finish(captured)
    local input = lib.inputDialog(locale('safehouse_editor_title'), {
        { type = 'input', label = locale('safehouse_editor_name'), required = true, min = 2, max = 64 },
        { type = 'input', label = locale('safehouse_editor_address'), description = locale('safehouse_editor_address_help'), required = true, min = 3, max = 128 },
        { type = 'number', label = locale('safehouse_editor_price'), default = 75000, min = 0 },
        { type = 'number', label = locale('safehouse_editor_upkeep'), default = 1500, min = 0 },
    })
    if not input then
        return lib.notify({ description = locale('safehouse_editor_cancelled'), type = 'inform' })
    end
    captured.label, captured.address, captured.price, captured.upkeep = input[1], input[2], input[3], input[4]
    local ok, res = lib.callback.await('vinewood_gangs:admin:createSafehouse', false, captured)
    if ok then
        lib.notify({ description = locale('safehouse_editor_saved', input[1]), type = 'success' })
    else
        lib.notify({ description = locale(res or 'failed'), type = 'error' })
    end
end

---Staff set-up. shellModel = nil for an interior on the map, or a shell model from config/safehouses.lua.
function StartSafehouseEditor(shellModel)
    if editing then return end
    editing = true
    CreateThread(function()
        if not shellModel then
            -- An interior on the map: four points, all in the world
            local captured = captureSteps(STEPS, {}, point)
            editing = false
            if not captured then return lib.notify({ description = locale('safehouse_editor_cancelled'), type = 'inform' }) end
            return finish(captured)
        end

        -- A shell: the outside door in the world, then the inside points in a private copy of the shell
        local captured = captureSteps({ 'entrance' }, {}, point)
        if not captured then
            editing = false
            return lib.notify({ description = locale('safehouse_editor_cancelled'), type = 'inform' })
        end
        local preview, err = lib.callback.await('vinewood_gangs:admin:shellPreview', false, shellModel)
        if not preview then
            editing = false
            return lib.notify({ description = locale(err or 'failed'), type = 'error' })
        end
        local o = preview.origin
        if not SpawnSafehouseShell({ model = preview.model, x = o.x, y = o.y, z = o.z }) then
            lib.callback.await('vinewood_gangs:admin:shellPreviewEnd', false)
            editing = false
            return
        end
        moveTo({ x = o.x + preview.start.x, y = o.y + preview.start.y, z = o.z + preview.start.z })
        lib.notify({ description = locale('safehouse_editor_in_shell'), type = 'inform' })

        -- Inside points are saved relative to the shell
        local relative = function()
            local p = GetEntityCoords(cache.ped)
            local r = function(n) return math.floor(n * 100 + 0.5) / 100 end
            return { x = r(p.x - o.x), y = r(p.y - o.y), z = r(p.z - o.z), w = r(GetEntityHeading(cache.ped)) }
        end
        local inside = captureSteps({ 'spawn', 'stash', 'exit' }, captured, relative)

        -- Back outside either way
        moveTo(captured.entrance)
        RemoveSafehouseShell()
        lib.callback.await('vinewood_gangs:admin:shellPreviewEnd', false)
        editing = false
        if not inside then return lib.notify({ description = locale('safehouse_editor_cancelled'), type = 'inform' }) end
        captured.shell = shellModel
        finish(captured)
    end)
end
