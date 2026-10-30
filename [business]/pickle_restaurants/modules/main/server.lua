-- =============================================
--  modules/main | server.lua
--  Re-syncs returning players. (Most core data lives in core/server.lua.)
-- =============================================

-- May this player work this restaurant? Asked once per restaurant the client walks
-- into, so the world can decline to draw a "Use the Grill" prompt for someone who
-- does not hold the job — the station callbacks were always gated, but a prompt on
-- equipment nobody can use reads as no gate at all.
--
-- It answers about the CALLER only and carries no roster, no rank and no job name:
-- two booleans that are already observable by trying the station. Anything richer
-- belongs behind the management payload's own permission checks.
lib.callback.register("pickle_restaurants:main:workPerms", function(src, d)
    local id = tonumber(d and d.id)
    if not id or not GetRestaurant(id) then return { cook = false, sell = false } end
    return { cook = HasPerm(id, src, "cook"), sell = HasPerm(id, src, "sell") }
end)

AddEventHandler("playerJoining", function()
    -- give the client a moment to register net events
    local src = source
    SetTimeout(2000, function()
        if RestaurantsReady then SyncToClient(src) end
    end)
end)
