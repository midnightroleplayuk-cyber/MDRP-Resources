-- bridge/inventory/lj-inventory — Loaf's qb-inventory fork.
--
-- qb-shaped throughout; its item definitions are qb-core's, so the catalogue falls
-- through to InvFrameworkItems(). Some builds spell the count export
-- `GetItemsTotalAmount`, which is already in the family's candidate list.
RegisterInventoryDriver({
    name     = "lj-inventory",
    resource = "lj-inventory",
    priority = 82,
    metadata = true,
    build = InvQbShapedDriver("lj-inventory"),
})
