-- bridge/inventory/codem-inventory — CodeM's mInventory.
--
-- Documented exports: AddItem(src, item, amount, slot, info),
-- RemoveItem(src, item, amount, slot), GetItemsTotalAmount(src, item),
-- GetInventory(identifier, source), GetItemList(), SetItemMetadata(src, slot, meta).
--
-- Note `GetInventory` takes (identifier, source) rather than (source): the shared
-- shape calls it with the source alone, which CodeM reads as the identifier and
-- answers nothing useful for. That costs nothing — the by-name lookup answers the
-- per-slot questions first, and the inventory LIST is only ever the client's
-- display mirror. `GetItemsTotalAmount` is the count either way.
RegisterInventoryDriver({
    name     = "codem-inventory",
    resource = "codem-inventory",
    priority = 90,
    metadata = true,
    build = InvQbShapedDriver("codem-inventory", {
        names = {
            count       = { "GetItemsTotalAmount" },
            items       = { "GetItemList" },
            setMetadata = { "SetItemMetadata" },
        },
    }),
})
