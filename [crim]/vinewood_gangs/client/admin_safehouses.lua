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

local function camDirection()
    local r = GetGameplayCamRot(2)
    local x, z = math.rad(r.x), math.rad(r.z)
    local n = math.abs(math.cos(x))
    return vector3(-math.sin(z) * n, math.cos(z) * n, math.sin(x))
end

---The door (or other object) the staff member is aiming at, within reach.
local function aimedObject()
    local from = GetGameplayCamCoord()
    local to = from + camDirection() * 8.0
    local ray = StartExpensiveSynchronousShapeTestLosProbe(from.x, from.y, from.z, to.x, to.y, to.z, 16, cache.ped, 7)
    local _, hit, _, _, entity = GetShapeTestResult(ray)
    if hit == 1 and entity and entity ~= 0 and GetEntityType(entity) == 3 then return entity end
end

---Aim at each of the MLO's doors and press E to add it. Returns { model, x, y, z } for each, or nil if cancelled.
local function captureDoors()
    local doors, outlined = {}, nil
    local shown
    while true do
        DisableControlAction(0, 24, true) -- don't shoot
        DisableControlAction(0, 25, true)
        local ent = aimedObject()
        if outlined and outlined ~= ent and DoesEntityExist(outlined) then SetEntityDrawOutline(outlined, false) end
        if ent then
            SetEntityDrawOutlineColor(91, 141, 239, 255)
            SetEntityDrawOutline(ent, true)
        end
        outlined = ent
        -- Mark the doors already added
        for _, d in ipairs(doors) do
            DrawMarker(28, d.x, d.y, d.z, 0, 0, 0, 0, 0, 0, 0.18, 0.18, 0.18, 95, 191, 122, 200, false, false, 2, false, nil, nil, false)
        end
        local help = locale('safehouse_editor_doors', #doors)
        if help ~= shown then lib.showTextUI(help) shown = help end

        if IsControlJustPressed(0, 38) then -- E
            if ent then
                local c = GetEntityCoords(ent)
                local dup = false
                for _, d in ipairs(doors) do if #(vector3(d.x, d.y, d.z) - c) < 0.3 then dup = true end end
                if not dup and #doors < 16 then doors[#doors + 1] = { model = GetEntityModel(ent), x = c.x, y = c.y, z = c.z } end
            else
                lib.notify({ description = locale('safehouse_editor_not_a_door'), type = 'error' })
            end
        elseif IsControlJustPressed(0, 177) then -- Backspace: undo, or cancel when there's nothing to undo
            if #doors > 0 then doors[#doors] = nil else break end
        elseif IsControlJustPressed(0, 191) and #doors > 0 then -- Enter: done
            if outlined and DoesEntityExist(outlined) then SetEntityDrawOutline(outlined, false) end
            lib.hideTextUI()
            return doors
        end
        Wait(0)
    end
    if outlined and DoesEntityExist(outlined) then SetEntityDrawOutline(outlined, false) end
    lib.hideTextUI()
    return nil
end

---Staff set-up. shellModel = nil for an interior on the map, or a shell model from config/safehouses.lua.
---mode = 'walkin' for an MLO entered through its own doors (which the script locks), instead of teleporting in.
function StartSafehouseEditor(shellModel, mode)
    if editing then return end
    editing = true
    CreateThread(function()
        if not shellModel and mode == 'walkin' then
            -- An MLO you walk into: the front door spot, the stash, then its doors
            local captured = captureSteps({ 'walkin_entrance', 'walkin_stash' }, {}, point)
            if captured then
                captured.entrance, captured.stash = captured.walkin_entrance, captured.walkin_stash
                captured.walkin_entrance, captured.walkin_stash = nil, nil
                local doors = captureDoors()
                if doors then
                    captured.doors, captured.mode = doors, 'walkin'
                    editing = false
                    return finish(captured)
                end
            end
            editing = false
            return lib.notify({ description = locale('safehouse_editor_cancelled'), type = 'inform' })
        end
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
