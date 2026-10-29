-- =============================================
--  modules/consume | server.lua
--  EATING what leaves the kitchen. Two vessels, two experiences:
--
--    • RESTAURANT BAG — takeaway. Its build-stack metadata lists every food and
--      drink packed into it. Using the bag anywhere opens an ox_lib context menu
--      of its contents; picking one consumes THAT item, rewrites the bag's
--      metadata without it, and the bag itself disappears once it's empty.
--    • MEAL — eat-in. Only usable while SEATED at one of the restaurant's placed
--      seat anchors: it lays the tray out on the table in front of the customer
--      as an interactive view (modules/dining) where they click what to eat.
--    • TAKEOUT BOX / RESTAURANT ITEM — one food, one serving: no contents list,
--      just the bite-or-finish pair. A box lays out on the table when seated; a
--      Restaurant Item is always consumed from the hand — a drink out of the
--      restaurant's own branded cup, a pocketed burger as its own bun/patty tower.
--
--  Both paths share this file's authority: the slot is re-read here on every
--  action (never trusted from the client), the layer is removed server-side, and
--  the item is only re-stamped/removed by the bridge afterwards.
--
--  ITEM USE plumbing. There is no single cross-framework "usable item" hook:
--    • ESX / QBCore register a callback per item name (RegisterUsableItem).
--    • ox_inventory owns item use itself and calls an EXPORT named in the item
--      definition — `server.export = 'pickle_restaurants.useItem'` (see
--      __INSTALL/items/ox_inventory.lua), which lands in the export below.
--  Item names are ADMIN-CONFIGURABLE (bag_item / meal_item / serving_item), so registration is
--  re-run whenever the settings change; already-registered names are remembered
--  so re-registering is a no-op.
-- =============================================

local Registered = {}   -- [item] = true, names already handed to the framework

-- What kind of vessel an item is, by the CURRENT settings (never cached — an admin
-- can rename either item at any time).
local function vesselKind(item)
    if not item or item == "" then return nil end
    if item == BagItemName() then return "bag" end
    if item == GetSetting("meal_item", "meal") then return "meal" end
    -- A TAKEOUT BOX is takeaway like a bag, but it holds exactly ONE food, so it
    -- has no contents list to choose from. Seated it lays out on the table like a
    -- meal (modules/dining) and is eaten by clicking it; on your feet it is eaten
    -- where you stand. Both go through the same eat callback.
    if item == BoxItemName() then return "box" end
    -- THE RESTAURANT ITEM: one serving of anything the kitchen makes — a poured
    -- drink OR a cooked product a cook pocketed — told apart by the one key on its
    -- build stack. Using one has to come through here rather than through an
    -- inventory's own "eat this" behaviour, which knows nothing of the flavor, the
    -- restaurant's branded cup, the food's own props or what it says it feeds. Like
    -- a box it holds exactly ONE thing, so there is no contents list to choose from:
    -- it is eaten (or sipped) where you stand.
    if item == ServingItemName() then return "serving" end
    return nil
end

-- The build stack recorded on one inventory slot (BuildInvMeta wrote it as
-- `stack`). Returns the layer list, or an empty list for a slot with no metadata
-- (a framework that strips it, or a hand-spawned item).
local function slotStack(meta)
    if type(meta) ~= "table" then return {} end
    local st = meta.stack
    return (type(st) == "table") and st or {}
end

-- The slot the player is acting on. `slot` comes from ox_inventory's use event; on
-- ESX/QB (no slot in the hook) we fall back to the first slot holding the item —
-- which is also the one the inventory UI used. Returns slot, metadata, count.
local function findSlot(src, item, slot)
    if not (Inventory and Inventory.GetItemSlots) then return nil end
    local slots = Inventory.GetItemSlots(src, item) or {}
    if slot then
        for _, s in ipairs(slots) do
            if s.slot == slot then return s.slot, s.metadata, s.count end
        end
    end
    local first = slots[1]
    if first then return first.slot, first.metadata, first.count end
end

-- The contents of a vessel slot, as a consumer-facing list. Index is the LAYER
-- index in the recorded stack — that's what the eat callback addresses, so the
-- list the player sees and the layer the server removes are the same thing even
-- when two identical foods sit in one bag.
local function describeContents(stack)
    local out = {}
    for i, l in ipairs(stack) do
        local d = LayerDisplay and LayerDisplay(l) or nil
        -- How much of THIS serving is left, so a menu can offer "take a sip" or
        -- "finish it" and say how many are to go. Read from the layer's recorded
        -- progress, never from anything the client remembers.
        local spec = ConsumeSpecFor(l.item, l.stack)
        local total = spec.bites or 1
        local eaten = math.max(0, math.floor(tonumber(l.eaten) or 0))
        out[#out + 1] = {
            index = i,
            item  = l.item,
            label = (d and d.label) or GetItemLabel(l.item),
            image = d and d.image or nil,
            drink = d and d.drink or nil,
            -- Not everything in a bag is food. A thing that relieves stress and
            -- feeds nothing (a DLC toy that came with the kid's meal) is USED, not
            -- eaten — the flag rides along so the menu offers the right verb.
            play  = spec.play or nil,
            bitesTotal = total,
            bitesLeft  = math.max(1, total - eaten),
        }
    end
    return out
end

-- Write a vessel's REMAINING contents back to its slot — or destroy the vessel
-- when nothing is left. Rewriting in place keeps the item where the player had it;
-- a framework with no slot-metadata support (bare ESX) can't rewrite, so the
-- vessel is consumed whole on the first bite rather than silently duplicating.
local function writeBack(src, item, slot, stack)
    if #stack == 0 then
        if Inventory.RemoveItemSlot then Inventory.RemoveItemSlot(src, item, 1, slot)
        else Inventory.RemoveItem(src, item, 1) end
        return true, true -- rewrote, emptied
    end
    local meta = BuildInvMeta(stack, item)
    if Inventory.SetItemMetadata and Inventory.SetItemMetadata(src, item, slot, meta) then
        return true, false
    end
    if Inventory.RemoveItemSlot then Inventory.RemoveItemSlot(src, item, 1, slot)
    else Inventory.RemoveItem(src, item, 1) end
    return false, true -- couldn't rewrite: the whole vessel went with the bite
end

-- ─── the use hook ────────────────────────────────────────────────────────────

-- Using a vessel. A BAG opens its contents menu wherever the player stands; a MEAL
-- is eat-in only — the client checks it's seated at a restaurant and refuses (with
-- a notification) otherwise, then lays the tray out in front of them.
local function useVessel(src, item, slot)
    local kind = vesselKind(item)
    if not kind then return end
    local s, meta = findSlot(src, item, slot)
    if not s then return end
    local stack = slotStack(meta)
    if #stack == 0 and kind ~= "serving" then
        -- a vessel with no readable contents (a framework that strips slot
        -- metadata, or an item spawned by hand): nothing to choose from
        return ShowNotification(src, _L("consume_empty"))
    end
    local payload = { kind = kind, item = item, slot = s, contents = describeContents(stack) }
    -- A BOX and a DRINK have no contents list to choose from (one food / one flavor,
    -- however many layers describe it), so they carry their own identity + progress
    -- instead — that's what the bite/sip menu is built from. A drink with NO readable
    -- flavor is still a drink: it names itself off the item and is drunk plain, rather
    -- than being refused as an empty vessel.
    if kind == "box" or kind == "serving" then
        local disp  = LayerDisplay and LayerDisplay({ item = item, stack = stack }) or nil
        local spec  = ConsumeSpecFor(item, stack)
        local eaten = math.max(0, math.floor(tonumber(stack[1] and stack[1].eaten) or 0))
        payload.food = {
            label = (disp and disp.label) or GetItemLabel(item),
            image = disp and disp.image or nil,
            drink = disp and disp.drink or nil,
            play  = spec.play or nil,
            bitesLeft = math.max(1, (spec.bites or 1) - eaten),
        }
    end
    TriggerClientEvent("pickle_restaurants:consume:open", src, payload)
end

-- Consume ONE thing out of a vessel. Everything is re-validated here: the slot
-- still holds the item, the layer still exists, and the layer index still points at
-- what the player picked. Returns what was eaten so the client can play the right
-- animation and name it.
lib.callback.register("pickle_restaurants:consume:eat", function(src, d)
    local item = d and d.item
    local kind = vesselKind(item)
    if not kind then return { ok = false } end
    local slot, meta = findSlot(src, item, tonumber(d and d.slot))
    if not slot then return { ok = false } end
    local stack = slotStack(meta)
    -- A bag eats ONE layer; a meal eats one PILE, which may be several layers that
    -- were arranged together (a burger's bun/patty). Both arrive as indices into the
    -- recorded stack, removed high-to-low so earlier removals can't shift later ones.
    local idxs = {}
    -- A TAKEOUT BOX is one food, however many component layers were recorded to
    -- describe it: eating it eats the whole box, so the client's indices are
    -- irrelevant and eating "part of a soup" is not a thing.
    -- A DRINK is the same story: one flavor, however it was recorded.
    if kind == "box" or kind == "serving" then
        for i = 1, #stack do idxs[i] = i end
    elseif type(d.indices) == "table" then
        for _, v in ipairs(d.indices) do
            local n = tonumber(v)
            if n and stack[n] then idxs[#idxs + 1] = n end
        end
    elseif tonumber(d and d.index) then
        local n = tonumber(d.index)
        if stack[n] then idxs[1] = n end
    end
    -- A metadata-less DRINK has no layers at all and is still perfectly drinkable —
    -- it is the item itself. Every other vessel needs something to act on.
    if #idxs == 0 and kind ~= "serving" then return { ok = false, error = _L("consume_gone") } end
    table.sort(idxs, function(a, b) return a > b end)
    local layer = stack[idxs[#idxs]] -- the lowest index names the mouthful
    -- A box or a drink is named and nourishes as its FOOD / FLAVOR, resolved from the
    -- vessel + its whole stack — never as whichever layer happens to sit at the bottom.
    local subject = (kind == "box" or kind == "serving") and { item = item, stack = stack } or layer
    local disp = LayerDisplay and LayerDisplay(subject) or nil
    -- What THIS food does when eaten + which clip it's eaten with, authored on the
    -- food itself and filled in from the global `consume` fallback. Resolved BEFORE
    -- the layer is dropped, since it reads that layer's metadata.
    local spec = ConsumeSpecFor(subject.item, subject.stack)

    -- WHAT GOES IN THE HAND. Resolved BEFORE the layers are dropped, since it reads
    -- them. `LayerDisplay` already answers for the things whose prop IS their
    -- identity (a drink's capped cup, a toy), and everything else is rendered by the
    -- kitchen's own resolver — so a burger is eaten as its bun/patty/cheese tower and
    -- a boxed soup as its box, instead of the `consume_anims` clip's generic prop
    -- (which had the whole restaurant eating a doughnut).
    --
    -- A MEAL PILE may be several layers stacked at one spot: they are rebuilt in the
    -- hand bottom-to-top (idxs is sorted high-to-low for removal, so it's walked
    -- backwards), which is the same order they stood in on the tray.
    local props = disp and disp.props or nil
    if not props then
        if kind == "box" or kind == "serving" then
            props = LayerHeldProps and LayerHeldProps({ item = item, stack = stack }) or nil
        elseif LayerHeldProps then
            local out = {}
            for i = #idxs, 1, -1 do
                for _, m in ipairs(LayerHeldProps(stack[idxs[i]]) or {}) do out[#out + 1] = m end
            end
            props = (#out > 0) and out or nil
        end
    end

    -- ── bites / sips ─────────────────────────────────────────────────────────
    -- A serving is eaten over `spec.bites` mouthfuls unless the player asked to
    -- finish it (`whole`). Progress is recorded ON THE LAYER (`eaten`) and written
    -- back to the slot, so it is server state that survives closing the menu, the
    -- meal going back in a pocket, and a reconnect — a half-eaten burger stays
    -- half-eaten. The BOX tracks on its first layer, since it is consumed whole.
    local total = spec.bites or 1
    local track = (kind == "box" or kind == "serving") and stack[1] or layer
    local done  = math.max(0, math.floor(tonumber(track and track.eaten) or 0))
    local whole = (d and d.whole) and true or false
    -- Nothing to record progress ON (a hand-spawned drink with no metadata): there is
    -- no slot to write a sip count back to, so it goes down in one rather than
    -- silently resetting to full on every sip.
    if not track then whole = true end
    local take  = whole and (total - done) or 1
    if take < 1 then take = 1 end
    local left  = total - done - take

    -- Each mouthful restores its SHARE, and the remainder is settled on the last
    -- one, so N bites always add up to exactly one serving however it's divided.
    local function share(v)
        if left > 0 then return math.floor((tonumber(v) or 0) / total * take) end
        return math.max(0, (tonumber(v) or 0) - math.floor((tonumber(v) or 0) / total) * done)
    end
    local gainH, gainT, gainS = share(spec.hunger), share(spec.thirst), share(spec.stress)

    local emptied = false
    if left > 0 then
        -- still something on the plate: record the progress, keep the food
        track.eaten = done + take
        local _, gone = writeBack(src, item, slot, stack)
        emptied = gone
    else
        for _, n in ipairs(idxs) do table.remove(stack, n) end
        local _, gone = writeBack(src, item, slot, stack)
        emptied = gone
    end
    Nourish(src, gainH, gainT)
    -- Calm as well as fed. Split from Nourish because it DRAINS a bar instead of
    -- filling one; a serving may well do both (a comfort food), so this is never an
    -- either/or with the call above. `Relax` is a no-op below 1, so a normal
    -- mouthful costs nothing here.
    if Relax then Relax(src, gainS) end

    return { ok = true, emptied = emptied,
             -- USED rather than eaten (a toy): picks the verb, the notification and
             -- the icon on the client. Derived server-side from what the entry
             -- actually does, so nothing authors it twice.
             play = spec.play or nil,
             -- what's left of THIS serving, for the "2 bites left" read-out and so
             -- a client knows whether the pile stays on the table
             bites = { total = total, taken = done + take, left = math.max(0, left),
                       drink = spec.drink },
             finished = (left <= 0) or nil,
             label = (disp and disp.label) or GetItemLabel(subject.item),
             drink = disp and disp.drink or nil,
             -- the full clip spec (dict/clip/prop/ms), so the client needs no
             -- catalogue of its own and an admin's retune applies immediately
             anim = spec.anim,
             -- What goes IN THE HAND: the food's OWN props (see above) — a drink's
             -- branded capped cup, a burger's whole tower, a box. The cup's texture
             -- is a brand render target, so it arrives branded with nothing extra
             -- here. Only a layer that resolves to no prop at all falls back to the
             -- animation catalogue's own.
             props = props,
             -- what's left, so an open menu can refresh itself without a round trip
             contents = describeContents(stack) }
end)

-- ─── registration ────────────────────────────────────────────────────────────

-- Hand one item name to the framework's usable-item hook (ESX / QB / QBox). This is
-- the PRIMARY path and must always be wired: the ox-style per-item export below is
-- specific to ox_inventory, and most other inventories have no equivalent — they
-- route item use through the framework core instead. Registering both costs nothing
-- (ox bypasses the core hook, the core hook fires on everything else) and means the
-- vessel is usable whichever the server runs.
--
-- The INVENTORY's own registrar is the second route, tried only when the framework
-- has none: several inventories (Quasar, CodeM, core_inventory) own item-use
-- themselves, which is the difference between a meal being usable and doing
-- nothing at all on a standalone server. It is deliberately not tried in ADDITION
-- to a working framework hook — those inventories route use through the framework
-- when there is one, so wiring both would eat two bites per click.
local function register(item)
    if not item or item == "" or Registered[item] then return end
    Registered[item] = true
    local use = function(source) useVessel(source, item, nil) end

    -- ESX/QB return nothing from their registrar; only an explicit `false` (the
    -- standalone bridge saying "there is no core here") means it didn't take.
    local wired = RegisterUsableItem and RegisterUsableItem(item, use) ~= false
    if not wired and Inventory and Inventory.RegisterUsable then
        wired = Inventory.RegisterUsable(item, use)
    end
    if not wired then
        -- No core hook AND no ox export means using the item does nothing at all,
        -- which is invisible from in-game — say so once, at boot, by name.
        print(("[pickle_restaurants] ^3no usable-item hook for '%s': neither this framework "
            .. "nor this inventory exposes one, so it can only be used through ox_inventory's "
            .. "item export.^7"):format(item))
    end
end

function RegisterConsumables()
    register(BagItemName())
    register(GetSetting("meal_item", "meal"))
    register(BoxItemName())
    register(ServingItemName())
end

-- ox_inventory's per-item server export. ox calls it twice around a use
-- ("usingItem" before, "usedItem" after); we act on the FIRST and cancel ox's own
-- consumption by returning false, because the vessel is only emptied once the
-- player actually picks something out of it.
-- ox hands us the INVENTORY, which across versions is either the player's server id
-- or the inventory table itself ({ id, owner, … }). Passing that table on as `source`
-- made every bridge lookup miss and the use silently do nothing — the item's export
-- was wired up correctly and still "didn't work". Same story for `slot`, which may
-- arrive as the slot number or as the whole slot table.
local function useSource(inventory)
    if type(inventory) == "table" then
        return tonumber(inventory.id) or tonumber(inventory.owner) or tonumber(inventory.source)
    end
    return tonumber(inventory) or inventory
end

local function useSlot(slot)
    if type(slot) == "table" then return tonumber(slot.slot) end
    return tonumber(slot)
end

exports("useItem", function(event, item, inventory, slot)
    if event ~= "usingItem" then return end
    local src = useSource(inventory)
    if not src then return false end
    useVessel(src, (type(item) == "table" and item.name) or item, useSlot(slot))
    return false -- never let ox eat the vessel itself
end)

CreateThread(function()
    while not RestaurantsReady do Wait(250) end
    RegisterConsumables()
end)

-- An admin renaming bag_item / meal_item re-registers the new names (the old ones
-- stay registered and harmlessly inert).
AddEventHandler("pickle_restaurants:settingChanged", function(key)
    if RestaurantsReady and (key == "bag_item" or key == "meal_item" or key == "box_item"
        or key == "serving_item") then RegisterConsumables() end
end)
