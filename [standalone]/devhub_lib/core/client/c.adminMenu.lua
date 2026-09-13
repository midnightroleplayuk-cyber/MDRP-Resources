-- ============================================================================
-- DEVHUB LIB - ADMIN MENU (/admindevhub) - CLIENT
-- ============================================================================
-- Opens the admin grid menu. Access is validated server-side against
-- Core.IsPlayerAdmin. Categories navigate inside the same window (fast access).
-- See core/server/s.adminMenu.lua for the registration API.
-- ============================================================================

local currentButtons = {}
local menuOpen = false
local requesting = false

-- Builds a display-only copy of the tree for the UI (no event data, adds isCategory)
local function buildDisplayTree(list)
    local out = {}
    for i = 1, #list do
        local b = list[i]
        local node = {
            id          = b.id,
            label       = b.label,
            description = b.description,
            icon        = b.icon,
            isCategory  = b.children ~= nil,
        }
        if b.children then
            node.children = buildDisplayTree(b.children)
        end
        out[#out + 1] = node
    end
    return out
end

-- Walks a path of ids through the button tree, returns the matching leaf button
local function findButtonByPath(path)
    local list = currentButtons
    for i = 1, #path do
        local found
        for j = 1, #list do
            if list[j].id == path[i] then
                found = list[j]
                break
            end
        end
        if not found then return nil end
        if i == #path then
            return found
        end
        list = found.children
        if type(list) ~= 'table' then return nil end
    end
    return nil
end

local function closeAdminMenu()
    menuOpen = false
    requesting = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'closeAdminMenu' })
end

local function openAdminMenu()
    if menuOpen or requesting then return end
    requesting = true

    Core.TriggerServerCallback('dh_lib:adminMenu:request', function(result)
        requesting = false

        if not result or not result.allowed then
            Core.Notify('You do not have permission to access this menu.', 5000, 'error')
            return
        end

        currentButtons = result.buttons or {}

        menuOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            type     = 'openAdminMenu',
            title    = 'DEVHUB ADMIN',
            subtitle = 'Administration Menu',
            buttons  = buildDisplayTree(currentButtons),
        })
    end)
end

RegisterCommand('admindevhub', function()
    openAdminMenu()
end, false)

RegisterNUICallback('adminMenuClose', function(_, cb)
    closeAdminMenu()
    cb('ok')
end)

RegisterNUICallback('adminMenuSelect', function(data, cb)
    cb('ok')

    local path = data and data.path
    closeAdminMenu()
    if type(path) ~= 'table' or #path == 0 then return end

    local button = findButtonByPath(path)
    if not button or button.children then return end -- not a leaf

    if button.eventType == 'server' then
        TriggerServerEvent(button.event, button.args)
    else
        TriggerEvent(button.event, button.args)
    end
end)

-- ----------------------------------------------------------------------------
-- Development demo handler (only registered when Shared.DevelopmentMode = true)
-- ----------------------------------------------------------------------------
if Shared.DevelopmentMode then
    AddEventHandler('dh_lib:adminMenu:demo', function(message)
        Core.Notify(message or 'Admin menu demo event!', 5000, 'success')
    end)
end
