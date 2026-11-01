-- ox handles consume=0 itself and skips the framework usable-item callback.
-- Dispatch that path after ox has validated and completed use of the actual slot.
if Sky.Config.inventory ~= "ox" and Sky.Config.inventory ~= "qbox" then return end
if not IsDuplicityVersion() then return end

local register_framework_item = Sky.FW.RegisterUsableItem
local callbacks = {}

function Sky.FW.RegisterUsableItem(name, callback)
    callbacks[name] = callback
    local definition = exports.ox_inventory:Items(name)
    if definition and definition.consume == 0 then return true end
    local result = register_framework_item(name, callback)
    if result == false then callbacks[name] = nil; return false end
    return true
end

-- Deliberately local-only: clients cannot submit an item-use event to this bridge.
AddEventHandler("ox_inventory:usedItem", function(source, name, slot)
    local callback = callbacks[name]
    if not callback then return end
    local definition = exports.ox_inventory:Items(name)
    if not definition or definition.consume ~= 0 then return end
    local item = SkyInventoryHelpers.NormalizeSlotItem(exports.ox_inventory:GetSlot(source, slot), slot, { amountOrder = "count_first" })
    if not item or item.name ~= name or item.count < 1 then return end
    callback(source, item)
end)
