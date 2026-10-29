-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/inventory (client) — the client-side item MIRROR.
--
-- There is no driver layer on this side and there should not be: the client never
-- moves an item (every add/remove is a server decision — the NUI is untrusted), so
-- the only thing it needs is the catalogue the cooking bar and the POS render
-- names and pictures from. The server sends that once per sync, whichever
-- inventory it happens to be talking to.
--
-- The three framework client bridges each carried an identical copy of this. It is
-- one file now for the same reason the server side is: one answer per question.
-- ─────────────────────────────────────────────────────────────────────────────

local initialized = false

function InitializeInventory()
    if initialized then return true end
    initialized = true

    Inventory = {}
    Inventory.Items = {}
    Inventory.Ready = false

    RegisterNetEvent("pickle_restaurants:setupInventory", function(data)
        Inventory.Items = (data and data.items) or {}
        Inventory.Ready = true
    end)

    -- The server pushes this after every add/remove so a resource that wants to
    -- mirror the player's holdings can. Nothing in this resource reads it — the
    -- kitchen asks the server for counts when it needs them, because a client-side
    -- copy of what you're carrying is a copy that can be wrong at the moment it
    -- matters. Kept as the documented hook it has always been.
    RegisterNetEvent("pickle_restaurants:updateInventory", function(_items) end)

    return true
end
