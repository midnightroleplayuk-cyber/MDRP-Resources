-- bridge/inventory/qb-inventory — QBCore's own inventory (the shape its forks copy).
--
-- Documented exports: AddItem(id, item, amount, slot, info, reason),
-- RemoveItem(id, item, amount, slot, reason), GetItemCount(src, items),
-- GetItemsByName(src, item), GetItemBySlot(src, slot), GetInventory(id),
-- SetInventory(src, items), HasItem(src, items, amount).
--
-- Item DEFINITIONS live in qb-core, not here, so the catalogue falls through to
-- InvFrameworkItems() — that is the shared shape's default and needs no naming.
--
-- There is no SetItemMetadata on this build; the shared shape probes for one and
-- reports honestly when it finds none, which makes `Inventory.SetItemMetadata`
-- return false and modules/consume fall back to remove + re-add. That fallback has
-- always been the contract for an inventory without in-place metadata edits.
RegisterInventoryDriver({
    name     = "qb-inventory",
    resource = "qb-inventory",
    priority = 80,
    metadata = true,
    build = InvQbShapedDriver("qb-inventory"),
})
