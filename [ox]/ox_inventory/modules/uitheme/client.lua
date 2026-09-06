if not lib then return end

--[[
    Client bridge for the server-wide inventory UI theme.

    See modules/uitheme/server.lua. On UI load we ask the server whether this
    player is an admin and what theme (if any) is currently in force, then relay
    every later admin push straight to the NUI.
]]

local UiTheme = {}

---Player holds `ox_inventory.admin` — gates the NUI callbacks so a tampered UI
---can't reach the server callbacks (which re-check the ace anyway).
local isAdmin = false

local function send(data)
    SendNUIMessage({ action = 'uiTheme', data = data })
end

---Pulls the admin flag + stored theme and hands both to the UI. Called once the
---NUI page reports it has loaded.
function UiTheme.Init()
    CreateThread(function()
        local result = lib.callback.await('ox_inventory:getUiTheme', false)

        if not result then return end

        isAdmin = result.isAdmin == true

        send({ isAdmin = isAdmin, theme = result.theme or false })
    end)
end

-- Broadcast from an admin: apply it, unless we are the admin who sent it (our UI
-- is already showing these values and is mid-edit).
RegisterNetEvent('ox_inventory:uiTheme', function(data)
    if type(data) ~= 'table' then return end
    if data.author == GetPlayerServerId(PlayerId()) then return end

    send(data)
end)

RegisterNUICallback('setUiTheme', function(data, cb)
    if not isAdmin then return cb({ ok = false, error = 'not_allowed' }) end

    local result = lib.callback.await('ox_inventory:setUiTheme', false, data)
    cb(result or { ok = false })
end)

RegisterNUICallback('clearUiTheme', function(_, cb)
    if not isAdmin then return cb({ ok = false, error = 'not_allowed' }) end

    local result = lib.callback.await('ox_inventory:clearUiTheme', false)
    cb(result or { ok = false })
end)

return UiTheme
