local config = require 'config.server'
local sharedConfig = require 'config.shared'
local picked = {}

---@param item string The item that is required by the recipe
---@param requirement integer The amount required by the recipe
---@return boolean callback The value sent back to the client
local function checkForItems(item, requirement)
    local src = source
    local itemCount = exports.ox_inventory:GetItem(src, item, nil, true)
    if itemCount < requirement then
        return false
    end
    exports.ox_inventory:RemoveItem(src, item, requirement)
    return true
end

---@param limit integer Cooldown for netevents
---@return boolean onCooldown If the player is on cooldown from triggering the event
local function onCooldown(limit)
    local time = os.time()
    if picked[source] and time - picked[source] < limit then return true end
    picked[source] = time
    return false
end

---@param item string Item to be added to player inventory
---@param amount integer Amount of item to be added to inventory
local function addItem(item, amount)
    if onCooldown(20) then return end
    local src = source
    exports.ox_inventory:AddItem(src, item, amount)
end

lib.callback.register('qbx_vineyard:server:grapeJuicesNeeded', function()
    return checkForItems('grapejuice', sharedConfig.grapeJuicesNeeded)
end)

lib.callback.register('qbx_vineyard:server:grapesNeeded', function()
    return checkForItems('grape', sharedConfig.grapesNeeded)
end)

RegisterNetEvent('qbx_vineyard:server:getGrapes', function()
    addItem("grape", math.random(config.grapeAmount.min, config.grapeAmount.max))
end)

RegisterNetEvent('qbx_vineyard:server:receiveWine', function()
    addItem("wine", math.random(config.wineAmount.min, config.wineAmount.max))
end)

RegisterNetEvent('qbx_vineyard:server:receiveGrapeJuice', function()
    addItem("grapejuice", math.random(config.grapeJuiceAmount.min, config.grapeJuiceAmount.max))
end)
