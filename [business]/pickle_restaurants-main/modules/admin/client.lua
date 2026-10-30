-- =============================================
--  modules/admin | client.lua
--  Opens the admin NUI and relays its actions to the server callbacks.
-- =============================================

RegisterNetEvent("pickle_restaurants:openAdmin", function(data)
    OpenNUI("admin", data)
end)

-- Generic relay: forward a NUI action straight to a server callback and
-- return the result to the NUI.
local function relay(callbackName)
    return function(d, cb)
        local res = lib.callback.await(callbackName, false, d)
        cb(res or {})
    end
end

-- Model validity can only be checked client-side (it's a game native), so we
-- annotate each recipe's invalid models on the way back from the server.
local function modelInvalid(model)
    if not model or model == "" then return false end
    return not IsModelInCdimage(GetHashKey(model))
end

-- Collect every prop model an entry references, flagging the ones that aren't in
-- the game's cdimage (a typo'd model fails silently in-world, so surface it in the
-- panel). Walks the three authored kinds' shapes: a food's steps, a tool's mode
-- payload, an ingredient's behavior props.
local function foodModels(f)
    local out = {}
    for _, st in ipairs(type(f.steps) == "table" and f.steps or {}) do
        for _, m in ipairs({ st.raw_model, st.cooked_model, st.burnt_model, st.container_model,
                             st.serving_model, st.serving_burnt_model, st.model }) do
            out[#out + 1] = m
        end
    end
    return out
end

local function toolModels(t)
    local out = { t.tool_model, t.applied_model }
    for _, tg in ipairs(type(t.targets) == "table" and t.targets or {}) do
        for _, fl in ipairs(type(tg.flavors) == "table" and tg.flavors or {}) do
            out[#out + 1] = fl.model
        end
    end
    for _, tr in ipairs(type(t.trays) == "table" and t.trays or {}) do
        out[#out + 1] = tr.tray_model
        out[#out + 1] = tr.raw_model
    end
    return out
end

local function ingredientModels(ing)
    local out = { ing.model }
    if type(ing.halves) == "table" then out[#out + 1] = ing.halves.top_model; out[#out + 1] = ing.halves.bottom_model end
    if type(ing.melts) == "table" then out[#out + 1] = ing.melts.applied_model; out[#out + 1] = ing.melts.melted_model end
    return out
end

local function annotateModels(res)
    if type(res) ~= "table" then return res end
    local function flag(list, modelsOf)
        for _, e in ipairs(type(list) == "table" and list or {}) do
            local bad = {}
            for _, m in ipairs(modelsOf(e)) do
                if modelInvalid(m) then bad[#bad + 1] = m end
            end
            e.invalid_models = bad
        end
    end
    flag(res.foods, foodModels)
    flag(res.tools, toolModels)
    flag(res.ingredients, ingredientModels)
    return res
end

-- Re-fetch the admin dataset and reopen the panel — used after a placement/gizmo
-- flow hands control back, so the admin lands back in the menu (with the just-
-- placed prop/seat already in the fresh data) instead of a closed screen. `focus`
-- (restaurant id + section) tells the NUI to reopen that restaurant and scroll to
-- its stations/seating so another can be placed immediately.
local function ReopenAdmin(restaurantId, section)
    local res = annotateModels(lib.callback.await("pickle_restaurants:admin:getData", false, {}))
    if type(res) == "table" and res.ok ~= false then
        if restaurantId then res.focus = { restaurant = restaurantId, section = section } end
        OpenNUI("admin", res)
    end
end

RegisterNUICallback("admin:getData", function(d, cb)
    cb(annotateModels(lib.callback.await("pickle_restaurants:admin:getData", false, d)) or {})
end)
RegisterNUICallback("admin:create",       relay("pickle_restaurants:admin:create"))
RegisterNUICallback("admin:delete",       relay("pickle_restaurants:admin:delete"))
RegisterNUICallback("admin:setOwner",     relay("pickle_restaurants:admin:setOwner"))
-- The JOB a restaurant employs through. Every restaurant needs one: employment,
-- permissions, commission and wages all hang off the grade a player holds in it.
RegisterNUICallback("admin:setJob",       relay("pickle_restaurants:admin:setJob"))
RegisterNUICallback("admin:setGroups",    relay("pickle_restaurants:admin:setGroups"))
-- The per-restaurant MAP BLIP. Every admin:* action the panel fetchNui's needs a relay
-- here — a missing one is silent on both ends: the POST resolves to nothing, the auto-save
-- still reports "Saved", and the edit never leaves the browser. This one was missing, which
-- is why a blip edit appeared to save and then did nothing in the world.
RegisterNUICallback("admin:setBlip",      relay("pickle_restaurants:admin:setBlip"))
RegisterNUICallback("admin:setBrandImage", relay("pickle_restaurants:admin:setBrandImage"))
-- Same missing-relay bug as setBlip: the Menu tab's item-art thumbnails posted into
-- nothing, so a custom item image never reached ItemImageCache.
RegisterNUICallback("admin:setItemImage", relay("pickle_restaurants:admin:setItemImage"))
RegisterNUICallback("admin:setTheme",     relay("pickle_restaurants:admin:setTheme"))
-- Rename auto-saves as you type: relay only, NO panel refresh — re-fetching getData
-- would remount the detail and yank the cursor out of the field mid-edit. The React
-- side mirrors the new label optimistically (like the theme edits).
RegisterNUICallback("admin:setName",      relay("pickle_restaurants:admin:setName"))
RegisterNUICallback("admin:setAppTheme",  relay("pickle_restaurants:admin:setAppTheme"))
RegisterNUICallback("admin:setPhoneTheme", relay("pickle_restaurants:admin:setPhoneTheme"))
RegisterNUICallback("admin:saveSetting",  relay("pickle_restaurants:admin:saveSetting"))
RegisterNUICallback("admin:saveSettings", relay("pickle_restaurants:admin:saveSettings"))
RegisterNUICallback("admin:resetRecipes", relay("pickle_restaurants:admin:resetRecipes"))

-- Admins resolve to full permissions, so the placement remove callback accepts
-- them; this keeps the panel open and lets the React side refresh in place.
RegisterNUICallback("admin:removeProp", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:placement:removeProp", false, { id = d.propId })
    cb(res or {})
end)

-- These close the NUI and hand off to the (blocking) gizmo placement flow, then
-- reopen the admin panel with fresh data so another entity can be placed without
-- reopening the menu by hand — on both a successful placement and a cancel.
RegisterNUICallback("admin:placeProp", function(d, cb)
    CloseNUI()
    cb({})
    StartPropPlacement(d.id, d.prop_type)
    ReopenAdmin(d.id, "stations")
end)

RegisterNUICallback("admin:setCounter", function(d, cb)
    CloseNUI()
    cb({})
    StartCounterPlacement(d.id)
    ReopenAdmin(d.id, "counters")
end)

-- A virtual register anchor (invisible; opens the fullscreen NUI register, no DUI).
RegisterNUICallback("admin:setVirtualRegister", function(d, cb)
    CloseNUI()
    cb({})
    StartVirtualRegisterPlacement(d.id)
    ReopenAdmin(d.id, "counters")
end)

-- Reposition an existing placed prop (station / counter / seat / virtual point):
-- hand off to the gizmo seeded at its current spot, then reopen to its section.
RegisterNUICallback("admin:editProp", function(d, cb)
    CloseNUI()
    cb({})
    StartPropReposition(d.propId)
    ReopenAdmin(d.restaurantId, d.section)
end)

-- Purely visual: while a prop's card is hovered in the panel, beam its world point
-- so the admin can tell which placed thing the card refers to. No server round-trip.
RegisterNUICallback("admin:highlightProp", function(d, cb)
    if SetPropHighlight then SetPropHighlight(d.propId, d.on) end
    cb({})
end)

RegisterNUICallback("admin:placeSeat", function(d, cb)
    CloseNUI()
    cb({})
    StartSeatPlacement(d.id)
    ReopenAdmin(d.id, "seating")
end)

RegisterNUICallback("admin:placeDeliveryDoor", function(d, cb)
    CloseNUI()
    cb({})
    StartDeliveryDoorPlacement(d.id)
    ReopenAdmin(d.id, "seating")
end)

RegisterNUICallback("admin:placeNpcSpawn", function(d, cb)
    CloseNUI()
    cb({})
    StartNpcSpawnPlacement(d.id)
    ReopenAdmin(d.id, "stations")
end)

-- Virtual kitchen: the shell height/facing view and virtual point anchors.
RegisterNUICallback("admin:placeShell", function(d, cb)
    CloseNUI()
    cb({})
    StartShellPlacement(d.id)
    ReopenAdmin(d.id, "virtual")
end)

RegisterNUICallback("admin:placeVirtualPoint", function(d, cb)
    CloseNUI()
    cb({})
    StartVirtualPointPlacement(d.id, d.target)
    ReopenAdmin(d.id, "virtual")
end)

-- ─── supplier depots (modules/supply) ────────────────────────────────────────
-- Server-wide, so these are NOT restaurant-scoped like the placements above. Placing is
-- the ONE way a depot or a bay is created (the seat pattern): no depot argument means a
-- new depot, and the flow asks for its name in-game before the gizmo.
RegisterNUICallback("admin:setDepot",    relay("pickle_restaurants:supply:setDepot"))
RegisterNUICallback("admin:removeDepot", relay("pickle_restaurants:supply:removeDepot"))
RegisterNUICallback("admin:removeSupplyZone", relay("pickle_restaurants:supply:removeZone"))

RegisterNUICallback("admin:placeSupplyShop", function(d, cb)
    CloseNUI()
    cb({})
    StartSupplyShopPlacement(d.depot)
    ReopenAdmin()
end)

RegisterNUICallback("admin:placeSupplyZone", function(d, cb)
    CloseNUI()
    cb({})
    StartSupplyZonePlacement(d.depot, d.zone, d.boxModel, d.trailerModel)
    ReopenAdmin()
end)
