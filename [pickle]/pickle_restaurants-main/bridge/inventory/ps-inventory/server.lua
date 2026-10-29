-- bridge/inventory/ps-inventory — Project Sloth's qb-inventory fork.
--
-- Same exports as qb-inventory, and the same qb-core item definitions behind it.
-- It exists as its own file rather than an alias so a server whose fork has
-- drifted has somewhere obvious to say so — add a `names` entry here and nothing
-- else in the resource needs to know.
RegisterInventoryDriver({
    name     = "ps-inventory",
    resource = "ps-inventory",
    priority = 84,
    metadata = true,
    build = InvQbShapedDriver("ps-inventory"),
})
