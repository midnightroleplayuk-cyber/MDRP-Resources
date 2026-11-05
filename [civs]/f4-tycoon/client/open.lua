
--[[
    F4 Tycoon - Client Side
    ox_lib Integration

    Uses:
    - ox_lib TextUI for sitting prompts
    - ox_lib notifications
    - Original F4 Tycoon seating, camera and exports
]]

OpenClient = {}

-- Controls allowed while seated
OpenClient.KeepControls = { 249, 245 }

---------------------------------------------------------------------------------------------------
-- Hooks
---------------------------------------------------------------------------------------------------

---@param tableId string
---@param seat number
---@return boolean
function OpenClient.CanSitDown(tableId, seat)
    local ped = PlayerPedId()

    if IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) then
        return false
    end

    return true
end

---@param tableId string
---@param seat number
function OpenClient.OnSeated(tableId, seat)
    OpenClient.HideSitPrompt()

    -- Optional: Hide your HUD here
    -- exports['my-hud']:SetVisible(false)
end

---@param tableId string
function OpenClient.OnStoodUp(tableId)
    -- Optional: Restore your HUD here
    -- exports['my-hud']:SetVisible(true)
end

---------------------------------------------------------------------------------------------------
-- ox_lib TextUI
---------------------------------------------------------------------------------------------------

local promptShown = false

---@param text string
function OpenClient.ShowSitPrompt(text)
    if promptShown then return end

    promptShown = true

    lib.showTextUI('[E] ' .. L('prompt_sit_plain'), {
        position = 'right-center',
        icon = 'chair',
        iconColor = '#FFFFFF',
        style = {
            borderRadius = 6,
            backgroundColor = '#18181b',
            color = '#FFFFFF',
            border = '1px solid #3f3f46',
            padding = '10px 15px'
        }
    })
end

function OpenClient.HideSitPrompt()
    if not promptShown then return end

    promptShown = false
    lib.hideTextUI()
end

---------------------------------------------------------------------------------------------------
-- ox_lib Notifications
---------------------------------------------------------------------------------------------------

---@param text string
---@param kind string 'info' | 'error' | 'success'
function OpenClient.Notify(text, kind)
    lib.notify({
        title = 'F4 Tycoon',
        description = text,
        type = kind or 'info',
        position = 'top-right',
        duration = 4000
    })
end

---------------------------------------------------------------------------------------------------
-- Exports
---------------------------------------------------------------------------------------------------

---@return boolean seated, string|nil tableId, number|nil seat
exports('IsSeated', function()
    local cur = Seat.current

    if not cur then
        return false, nil, nil
    end

    return true, cur.t.id, cur.seat
end)

exports('StandUp', function()
    if Seat.current then
        Seat.requestLeave()
    end
end)

---@return string|nil tableId, number|nil distance
exports('GetNearestTable', function()
    local pc = GetEntityCoords(PlayerPedId())
    local best, bestDist

    for id, t in pairs(Client.tables) do
        local d = #(
            vector2(pc.x, pc.y) -
            vector2(t.x, t.y)
        )

        if not bestDist or d < bestDist then
            best, bestDist = id, d
        end
    end

    return best, bestDist
end)

---@param mode string
exports('SetCameraMode', function(mode)
    Camera.setMode(mode)

    if NUI.open then
        NUI.send({
            type = 'camera',
            mode = Camera.mode
        })
    end
end)

---@param tableId string
---@return table|nil
exports('GetTableState', function(tableId)
    local t = Client.tables[tableId]
    return t and t.state or nil
end)

---@return boolean
exports('IsUiOpen', function()
    return NUI.open == true
end)
