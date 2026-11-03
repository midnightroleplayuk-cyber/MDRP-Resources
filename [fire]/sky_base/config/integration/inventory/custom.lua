---@diagnostic disable: duplicate-set-field
-- Set Config.inventory = "custom" to enable this server-side template.
if Sky.Config.inventory ~= "custom" then return end
if not IsDuplicityVersion() then return end

function Sky.FW.RegisterUsableItem(name, callback)
    -- Register the item and invoke callback(source, item) when it is used.
    error("Custom inventory integration: RegisterUsableItem is not implemented")
end

function Sky.FW.AddItem(source, item, amount, slot, metadata)
    -- Return whether the requested amount was added.
    error("Custom inventory integration: AddItem is not implemented")
end

function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    -- Return the number of items actually removed.
    error("Custom inventory integration: RemoveItem is not implemented")
end

function Sky.FW.CanCarryItem(source, item, amount, metadata)
    error("Custom inventory integration: CanCarryItem is not implemented")
end

function Sky.FW.HasItem(source, item, amount, metadata)
    error("Custom inventory integration: HasItem is not implemented")
end

function Sky.FW.GetInventoryItems(source)
    -- Return normalized { name, label, amount, count?, slot?, metadata? } entries.
    error("Custom inventory integration: GetInventoryItems is not implemented")
end

function Sky.FW.GetInventoryItem(source, item, metadata)
    -- Return the first normalized matching item or nil.
    error("Custom inventory integration: GetInventoryItem is not implemented")
end

function Sky.FW.GetInventorySlotsWithItem(source, item_name, metadata)
    -- Return normalized matching slot entries or an empty array.
    error("Custom inventory integration: GetInventorySlotsWithItem is not implemented")
end

function Sky.FW.GetInventorySlot(source, slot_id)
    -- Return the normalized slot entry or nil.
    error("Custom inventory integration: GetInventorySlot is not implemented")
end

function Sky.FW.SetInventorySlotMetadata(source, slot_id, metadata)
    error("Custom inventory integration: SetInventorySlotMetadata is not implemented")
end

function Sky.FW.GetItems()
    -- Return the provider's item catalog.
    error("Custom inventory integration: GetItems is not implemented")
end

function Sky.FW.GetItemLabel(item)
    error("Custom inventory integration: GetItemLabel is not implemented")
end

function Sky.FW.GetItemInfo(item)
    -- Return { name, label, stack?, weight, description?, image? }.
    error("Custom inventory integration: GetItemInfo is not implemented")
end

function Sky.FW.GetItemBySlot(source, slot)
    error("Custom inventory integration: GetItemBySlot is not implemented")
end

function Sky.FW.GetResourceName()
    -- Return the exact resource name of the custom inventory.
    error("Custom inventory integration: GetResourceName is not implemented")
end

function Sky.FW.CanCarryWeapon(source, weapon_name, metadata)
    error("Custom inventory integration: CanCarryWeapon is not implemented")
end

function Sky.FW.AddWeapon(source, weapon_name, ammo, metadata)
    error("Custom inventory integration: AddWeapon is not implemented")
end

function Sky.FW.RemoveWeapon(source, weapon_name, metadata)
    error("Custom inventory integration: RemoveWeapon is not implemented")
end

function Sky.FW.GetWeapons(source)
    -- Return normalized { name, label, ammo?, components?, tintIndex? } entries.
    error("Custom inventory integration: GetWeapons is not implemented")
end

function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    -- Return success followed by the stash id.
    error("Custom inventory integration: RegisterStash is not implemented")
end

function Sky.FW.OpenStash(source, inventory_type, id)
    error("Custom inventory integration: OpenStash is not implemented")
end

function Sky.FW.AddStashItems(id, items)
    error("Custom inventory integration: AddStashItems is not implemented")
end

function Sky.FW.ClearStash(id, inventory_type)
    error("Custom inventory integration: ClearStash is not implemented")
end

function Sky.FW.OpenPlayerInventory(source, target)
    error("Custom inventory integration: OpenPlayerInventory is not implemented")
end

function Sky.FW.OpenShop(source, shop_title)
    error("Custom inventory integration: OpenShop is not implemented")
end

function Sky.FW.RegisterShop(shop_title, shop_inventory, shop_coords, shop_groups)
    error("Custom inventory integration: RegisterShop is not implemented")
end

function Sky.FW.AddTrunkItems(identifier, items)
    error("Custom inventory integration: AddTrunkItems is not implemented")
end

function Sky.FW.UpdatePlate(old_plate, new_plate)
    error("Custom inventory integration: UpdatePlate is not implemented")
end
