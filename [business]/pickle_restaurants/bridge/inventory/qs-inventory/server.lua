-- bridge/inventory/qs-inventory — Quasar's inventory.
--
-- qb-shaped (metadata is `info` on a slot) with its own names for the count and
-- the item list, and — unusually — its own usable-item registrar, which is why it
-- works on a standalone server where there is no framework hook to fall back on.
--
-- `GetInventory(src)` returns a SLOT-KEYED table, which InvNormalizeSlot already
-- reads, so per-slot metadata comes out of the shared shape unchanged.
RegisterInventoryDriver({
    name     = "qs-inventory",
    resource = "qs-inventory",
    priority = 95,
    metadata = true,
    build = InvQbShapedDriver("qs-inventory", {
        names = {
            items       = { "GetItemList" },
            count       = { "GetItemTotalAmount" },
            setMetadata = { "SetItemMetadata", "SetMetaData" },
            usable      = { "CreateUsableItem" },
        },
    }),
})
