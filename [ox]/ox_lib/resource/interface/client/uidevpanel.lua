--[[
    Admin UI preview panel — in-game equivalent of the web dev DevPanel.
    Restricted command (ace): add_ace group.admin command.ox_uidev allow
]]

local panelOpen = false

--- Keep NUI focus while the dev panel session is active (demos call resetNuiFocus on close).
local resetNuiFocus = lib.resetNuiFocus

function lib.resetNuiFocus()
    if panelOpen then
        lib.setNuiFocus(false, false)
        return
    end

    resetNuiFocus()
end

function lib.isDevPanelOpen()
    return panelOpen
end

local function setPanelOpen(open)
    panelOpen = open

    if open then
        lib.setNuiFocus(false, false)
        SendNUIMessage({ action = 'setDevPanelVisible', data = true })
    else
        resetNuiFocus()
        SendNUIMessage({ action = 'setDevPanelVisible', data = false })
    end
end

RegisterCommand('ox_uidev', function()
    setPanelOpen(not panelOpen)
end, true)

RegisterNUICallback('devPanelClose', function(_, cb)
    cb(1)
    setPanelOpen(false)
end)

RegisterNUICallback('devPanelKeepFocus', function(_, cb)
    cb(1)
    if panelOpen then
        lib.setNuiFocus(false, false)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= cache.resource then return end
    if not panelOpen then return end
    panelOpen = false
    resetNuiFocus()
end)
