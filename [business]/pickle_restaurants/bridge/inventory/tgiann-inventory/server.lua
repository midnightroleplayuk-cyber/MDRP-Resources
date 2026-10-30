-- bridge/inventory/tgiann-inventory — TGIANN's inventory.
--
-- qb-shaped in its data (metadata is stored as `info`, exactly like qb), but its
-- ARGUMENT LISTS differ in two places that matter, and both would fail silently
-- rather than loudly:
--
--   • AddItem's sixth argument is `isClotheSlot`, not a log reason, and
--     RemoveItem's fifth is METADATA, not a log reason. Passing qb's reason string
--     into either would mark every meal as clothing and turn every plain removal
--     into a filtered one — hence `reason = false`.
--   • SetItemMetadata is (src, item, slot, metadata); the family default is
--     (src, slot, metadata). One extra argument in the middle, so it is overridden
--     outright rather than named.
RegisterInventoryDriver({
    name     = "tgiann-inventory",
    resource = "tgiann-inventory",
    priority = 86,
    metadata = true,
    build = InvQbShapedDriver("tgiann-inventory", {
        reason = false,
        names  = {
            inventory = { "GetPlayerItems" },
            items     = { "GetItemList", "Items" },
        },
        extend = function(P)
            P.setMetadata = function(src, name, slot, metadata)
                local ok, ret = InvExportAny("tgiann-inventory", "setMetadataTg",
                    { "SetItemMetadata", "UpdateItemMetadata" }, src, name, slot, metadata)
                return ok and ret ~= false
            end
        end,
    }),
})
