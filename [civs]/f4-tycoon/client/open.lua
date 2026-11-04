--[[
    F4 Tycoon - client side, open file.

    This file is not encrypted: change how the resource talks to the player and to your
    other resources here. Everything in OpenClient is called safely: an error here is
    printed and the resource goes on with the default.
]]

OpenClient = {}

-- Controls that keep working while seated (everything else belongs to the table).
-- 249 push-to-talk, 245 chat. Add e.g. 288 (F1) for a phone or radio resource.
OpenClient.KeepControls = { 249, 245 }

---------------------------------------------------------------------------------------------------
--- Hooks
---------------------------------------------------------------------------------------------------

---Checked before the sit request is sent. Return false to stay standing.
---@param tableId string
---@param seat number 1..4
---@return boolean
function OpenClient.CanSitDown(tableId, seat)
    local ped = PlayerPedId()
    if IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) then return false end
    -- if LocalPlayer.state.isCuffed or LocalPlayer.state.isDead then return false end
    return true
end

---The player sat down and the table UI is open.
---@param tableId string
---@param seat number
function OpenClient.OnSeated(tableId, seat)
    -- hide your own HUD while playing, for example:
    -- exports['my-hud']:SetVisible(false)
    -- TriggerEvent('my-hud:toggle', false)
end

---The player stood up (or was made to).
---@param tableId string
function OpenClient.OnStoodUp(tableId)
    -- exports['my-hud']:SetVisible(true)
end

local promptShown = false

---The player stands next to a free chair. Called once when the prompt should appear.
---@param text string  L('prompt_sit'), contains ~INPUT_PICKUP~ for the native help text
function OpenClient.ShowSitPrompt(text)
    if promptShown then return end
    promptShown = true
    AddTextEntry('F4T_SIT_PROMPT', text)
    CreateThread(function()
        while promptShown do
            BeginTextCommandDisplayHelp('F4T_SIT_PROMPT')
            EndTextCommandDisplayHelp(0, false, false, -1)
            Wait(0)
        end
    end)
    -- ox_lib instead of the native help text:
    -- lib.showTextUI('[E] ' .. L('prompt_sit_plain'))
end

---The prompt should disappear (walked away, sat down, chair taken).
function OpenClient.HideSitPrompt()
    promptShown = false
    -- lib.hideTextUI()
end

---A message for the player while the table UI is closed (the UI shows its own toasts).
---@param text string
---@param kind string 'info' | 'error' | 'success'
function OpenClient.Notify(text, kind)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(false, false)
    -- lib.notify({ description = text, type = kind })
    -- TriggerEvent('QBCore:Notify', text, kind)
end

---------------------------------------------------------------------------------------------------
--- Exports
---------------------------------------------------------------------------------------------------

---@return boolean seated, string|nil tableId, number|nil seat
exports('IsSeated', function()
    local cur = Seat.current
    if not cur then return false, nil, nil end
    return true, cur.t.id, cur.seat
end)

---Stands the player up (leaving a running game).
exports('StandUp', function()
    if Seat.current then Seat.requestLeave() end
end)

---The closest table and its distance in metres.
---@return string|nil tableId, number|nil distance
exports('GetNearestTable', function()
    local pc = GetEntityCoords(PlayerPedId())
    local best, bestDist
    for id, t in pairs(Client.tables) do
        local d = #(vector2(pc.x, pc.y) - vector2(t.x, t.y))
        if not bestDist or d < bestDist then best, bestDist = id, d end
    end
    return best, bestDist
end)

---'auto' | 'seat' | 'top' while seated.
---@param mode string
exports('SetCameraMode', function(mode)
    Camera.setMode(mode)
    if NUI.open then NUI.send({ type = 'camera', mode = Camera.mode }) end
end)

---The last state received for a table nearby (same data as the server export GetGameState).
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
