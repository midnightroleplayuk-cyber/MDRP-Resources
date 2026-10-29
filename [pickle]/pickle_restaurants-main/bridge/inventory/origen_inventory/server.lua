-- bridge/inventory/origen_inventory — Origen's inventory.
--
-- Ships a qb-compatible export surface (AddItem/RemoveItem with `info`, plus a
-- `GetItemsTotalAmount` count), which is why it rides the shared shape. It runs on
-- both ESX and QB installs, so the catalogue can come from either: its own item
-- list export when it publishes one, otherwise qb-core's definitions.
RegisterInventoryDriver({
    name     = "origen_inventory",
    resource = "origen_inventory",
    priority = 88,
    metadata = true,
    build = InvQbShapedDriver("origen_inventory", {
        names = {
            count = { "GetItemsTotalAmount", "getItemsTotalAmount" },
            items = { "GetItemList", "getItemList", "GetItems" },
        },
    }),
})
