-- Staff area editor (/gangadmin > Areas > Draw new area) and area outlines.

local editing = false
local showOutlines = false
local FLOOR_OFFSET = 1.0

local function groundZ(x, y, fallback)
    local found, z = GetGroundZFor_3dCoord(x, y, fallback + 50.0, false)
    return found and z or fallback
end

local function drawPolygon(points, z, r, g, b, closed)
    for i = 1, #points do
        local a = points[i]
        local nb = points[i + 1] or (closed and points[1])
        if nb then
            local az, bz = a.z or groundZ(a.x, a.y, z), nb.z or groundZ(nb.x, nb.y, z)
            -- A short wall rather than a single line, so it reads from a distance
            for h = 0.0, 3.0, 1.5 do
                DrawLine(a.x, a.y, az + h, nb.x, nb.y, bz + h, r, g, b, 220)
            end
        end
        local pz = a.z or groundZ(a.x, a.y, z)
        DrawLine(a.x, a.y, pz, a.x, a.y, pz + 3.0, r, g, b, 255)
    end
end

-------------------------------------------------------------------------------
-- Outlines of every area, for staff checking their layout
-------------------------------------------------------------------------------

function ToggleZoneOutlines()
    showOutlines = not showOutlines
    if showOutlines then
        CreateThread(function()
            -- Cache ground heights once per corner
            local shapes = {}
            local z = GetEntityCoords(cache.ped).z
            for key, zone in pairs(Config.Zones) do
                local pts = {}
                for i, p in ipairs(zone.points) do pts[i] = { x = p.x, y = p.y, z = groundZ(p.x, p.y, z) } end
                shapes[#shapes + 1] = { label = zone.label, points = pts }
            end
            while showOutlines do
                local pos = GetEntityCoords(cache.ped)
                for _, s in ipairs(shapes) do
                    local near = false
                    for _, p in ipairs(s.points) do
                        if #(vector2(pos.x, pos.y) - vector2(p.x, p.y)) < 600.0 then near = true break end
                    end
                    if near then drawPolygon(s.points, pos.z, 242, 169, 59, true) end
                end
                Wait(0)
            end
        end)
        lib.notify({ description = locale('outlines_on'), type = 'inform' })
    end
    return showOutlines
end

-------------------------------------------------------------------------------
-- Drawing a new area by walking its corners
-------------------------------------------------------------------------------

local function finish(points)
    local input = lib.inputDialog(locale('zone_name_title'), {
        { type = 'input', label = locale('zone_name_label'), required = true, min = 2, max = 64 },
        { type = 'number', label = locale('zone_value_label'), description = locale('zone_value_help'), default = 1.0, min = 0.25, max = 3.0, step = 0.05, precision = 2 },
    })
    if not input then return lib.notify({ description = locale('zone_cancelled'), type = 'inform' }) end

    local flat = {}
    for i, p in ipairs(points) do flat[i] = { x = p.x, y = p.y } end
    local ok, res, extra = lib.callback.await('vinewood_gangs:admin:saveZone', false, input[1], input[2], flat)
    if ok then
        lib.notify({ description = locale('zone_saved', input[1]), type = 'success' })
    else
        lib.notify({ description = locale(res or 'failed', extra or ''), type = 'error' })
    end
end

function StartZoneEditor()
    if editing then return end
    editing = true
    local points = {}
    lib.showTextUI(locale('zone_editor_help'))

    CreateThread(function()
        while editing do
            local pos = GetEntityCoords(cache.ped)
            local preview = {}
            for i, p in ipairs(points) do preview[i] = p end
            preview[#preview + 1] = { x = pos.x, y = pos.y, z = pos.z - FLOOR_OFFSET }

            if #points > 0 then drawPolygon(preview, pos.z, 95, 191, 122, #points >= 2) end
            DrawMarker(1, pos.x, pos.y, pos.z - FLOOR_OFFSET, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 2.0, 95, 191, 122, 120, false, false, 2, false, nil, nil, false)

            if IsControlJustPressed(0, 38) then -- E: add corner
                points[#points + 1] = { x = pos.x, y = pos.y, z = pos.z - FLOOR_OFFSET }
                lib.notify({ description = locale('zone_corner_added', #points), type = 'inform' })
            elseif IsControlJustPressed(0, 20) and #points > 0 then -- Z: undo
                table.remove(points)
            elseif IsControlJustPressed(0, 191) then -- Enter: finish
                if #points < 3 then
                    lib.notify({ description = locale('zone_points'), type = 'error' })
                else
                    editing = false
                    lib.hideTextUI()
                    finish(points)
                    return
                end
            elseif IsControlJustPressed(0, 177) then -- Backspace: cancel
                editing = false
                lib.notify({ description = locale('zone_cancelled'), type = 'inform' })
            end
            Wait(0)
        end
        lib.hideTextUI()
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and editing then lib.hideTextUI() end
end)
