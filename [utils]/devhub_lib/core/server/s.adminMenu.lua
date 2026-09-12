-- ============================================================================
-- DEVHUB LIB - ADMIN MENU (/admindevhub) - SERVER
-- ============================================================================
-- Other resources register grid buttons here. When an admin runs /admindevhub
-- a grid of every registered entry is shown.
--
-- A registered entry is either:
--   * a BUTTON   - has an "event"; clicking it triggers that event and closes the menu.
--   * a CATEGORY - has "children"; clicking it reveals the children inside the SAME
--                  window (fast access, no second window opens). Categories can be
--                  nested - a child may itself be a category.
--
-- USAGE (call from the SERVER side of your resource, after devhub_lib started):
--
--   -- a simple button
--   exports.dh_lib:RegisterAdminMenuButton({
--       id = 'gym_business', label = 'Business', icon = 'fas fa-briefcase',
--       event = 'gym:business:open', eventType = 'client',
--   })
--
--   -- ONE category that groups a whole script (so it adds a single block, not many)
--   exports.dh_lib:RegisterAdminMenuButton({
--       id = 'gym', label = 'Gym', icon = 'fas fa-dumbbell',
--       children = {
--           { id = 'gym_business', label = 'Business', icon = 'fas fa-briefcase',
--             event = 'gym:business:open', eventType = 'client' },
--           { id = 'gym_creator',  label = 'Gym Creator', icon = 'fas fa-hammer',
--             event = 'gym:creator:open', eventType = 'client' },
--       },
--   })
--
-- Entry fields:
--   id          string (optional) unique id within its level, defaults to label
--   label       string (required) text shown on the grid button
--   description string (optional) small subtitle under the label
--   icon        string (optional) FontAwesome class (default 'fas fa-cube', categories 'fas fa-folder')
--   children    table  (optional) list of child entries -> turns this entry into a category
--   event       string (required for buttons) event triggered when the button is clicked
--   eventType   string (optional) 'client' | 'server', default 'client'
--   args        any    (optional) single argument passed with the event
--
-- eventType = 'client' -> devhub_lib runs TriggerEvent(event, args)       on the admin's client
-- eventType = 'server' -> devhub_lib runs TriggerServerEvent(event, args) from the admin's client
--                         (always re-check Core.IsPlayerAdmin(source) in that handler).
--
-- Entries registered by a resource are removed automatically when it stops.
-- ============================================================================

local MAX_DEPTH = 5
local adminButtons = {}

local function findButtonIndex(id)
    for i = 1, #adminButtons do
        if adminButtons[i].id == id then
            return i
        end
    end
    return nil
end

-- Validates & normalizes one entry (recursively for categories).
-- Returns the normalized node, or nil + an error message.
local function normalizeButton(data, depth)
    if type(data) ~= 'table' then
        return nil, 'entry must be a table'
    end
    if type(data.label) ~= 'string' or data.label == '' then
        return nil, '"label" is required and must be a string'
    end

    local node = {
        id          = tostring(data.id or data.label),
        label       = data.label,
        description = data.description,
        icon        = data.icon or 'fas fa-cube',
    }

    if type(data.children) == 'table' and #data.children > 0 then
        -- CATEGORY
        if depth >= MAX_DEPTH then
            return nil, 'category nesting is too deep (max ' .. MAX_DEPTH .. ' levels)'
        end
        node.icon = data.icon or 'fas fa-folder'
        node.children = {}
        for i = 1, #data.children do
            local child, err = normalizeButton(data.children[i], depth + 1)
            if not child then
                return nil, 'child #' .. i .. ': ' .. err
            end
            node.children[#node.children + 1] = child
        end
    else
        -- BUTTON (leaf)
        if type(data.event) ~= 'string' or data.event == '' then
            return nil, '"event" is required (or provide "children" to make it a category)'
        end
        local eventType = data.eventType or 'client'
        if eventType ~= 'client' and eventType ~= 'server' then
            return nil, '"eventType" must be "client" or "server"'
        end
        node.event = data.event
        node.eventType = eventType
        node.args = data.args
    end

    return node
end

local function registerAdminMenuButton(data)
    local node, err = normalizeButton(data, 0)
    if not node then
        print('^1[devhub_lib] RegisterAdminMenuButton: ' .. err .. '^7')
        return false
    end

    node.resource = GetInvokingResource() or GetCurrentResourceName()

    local idx = findButtonIndex(node.id)
    if idx then
        adminButtons[idx] = node
    else
        adminButtons[#adminButtons + 1] = node
    end
    return true
end

Core.RegisterAdminMenuButton = registerAdminMenuButton
createExport('RegisterAdminMenuButton', registerAdminMenuButton)

-- Builds a clean copy of the tree for the client (drops internal fields)
local function serializeButtons(list)
    local out = {}
    for i = 1, #list do
        local b = list[i]
        local node = {
            id          = b.id,
            label       = b.label,
            description = b.description,
            icon        = b.icon,
        }
        if b.children then
            node.children = serializeButtons(b.children)
        else
            node.event     = b.event
            node.eventType = b.eventType
            node.args      = b.args
        end
        out[#out + 1] = node
    end
    return out
end

-- Remove every entry registered by a resource once that resource stops
AddEventHandler('onResourceStop', function(resourceName)
    for i = #adminButtons, 1, -1 do
        if adminButtons[i].resource == resourceName then
            table.remove(adminButtons, i)
        end
    end
end)

-- Server callback: validates admin access and returns the current button tree
CreateThread(function()
    while not Core.RegisterServerCallback do
        Wait(50)
    end

    Core.RegisterServerCallback('dh_lib:adminMenu:request', function(source, cb)
        if not Core.IsPlayerAdmin or not Core.IsPlayerAdmin(source) then
            cb({ allowed = false })
            return
        end
        cb({ allowed = true, buttons = serializeButtons(adminButtons) })
    end)
end)

-- ----------------------------------------------------------------------------
-- Development demo entries (only registered when Shared.DevelopmentMode = true)
-- ----------------------------------------------------------------------------
if Shared.DevelopmentMode then
    CreateThread(function()
        Wait(2000)
        -- a simple button
        registerAdminMenuButton({
            id          = 'dh_demo_notify',
            label       = 'Demo Notify',
            description = 'Single client-event button',
            icon        = 'fas fa-bell',
            event       = 'dh_lib:adminMenu:demo',
            eventType   = 'client',
            args        = 'Admin menu demo button works!',
        })
        -- a category that groups sub-actions (fast access)
        registerAdminMenuButton({
            id          = 'dh_demo_category',
            label       = 'Demo Category',
            description = 'Opens sub-options',
            icon        = 'fas fa-folder',
            children    = {
                {
                    id          = 'dh_demo_sub_client',
                    label       = 'Client Sub-Action',
                    description = 'Triggers a client event',
                    icon        = 'fas fa-desktop',
                    event       = 'dh_lib:adminMenu:demo',
                    eventType   = 'client',
                    args        = 'Sub-category client action works!',
                },
                {
                    id          = 'dh_demo_sub_server',
                    label       = 'Server Sub-Action',
                    description = 'Triggers a server event',
                    icon        = 'fas fa-server',
                    event       = 'dh_lib:adminMenu:demoServer',
                    eventType   = 'server',
                },
            },
        })
    end)

    RegisterNetEvent('dh_lib:adminMenu:demoServer', function()
        local src = source
        if not Core.IsPlayerAdmin or not Core.IsPlayerAdmin(src) then return end
        print(('^3[devhub_lib]^7 admin menu demo server event triggered by player %s'):format(src))
        Core.Notify(src, 'Admin menu server demo received!', 5000, 'success')
    end)
end
