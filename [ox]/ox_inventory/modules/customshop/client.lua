if not lib then return end

--[[
    Client side of dynamic shops:
      • builds the interaction zone(s) + blip for each DB shop
      • spawns either the optional prop (prop_till_01) OR an NPC ped
      • opens the shop on interact
]]

local createBlip = require 'modules.utils.client'.CreateBlip
local Appearance = require 'modules.customappearance.client'

local CustomShop = {}

---@type table<string, table> id -> { shop, entries = { {zone/zoneId, prop/ped, blip} } }
local active = {}

local DEFAULT_PROP = 'prop_till_01'
local DEFAULT_PED = 'mp_m_shopkeep_01'

-- Returns an array of { x,y,z,heading } from a shop's coords (single or array).
local function getLocations(shop)
    local out = {}
    local c = shop.coords
    if not c then return out end

    if c[1] then
        for i = 1, #c do out[#out + 1] = c[i] end
    else
        out[#out + 1] = c
    end
    return out
end

local function destroyShop(id)
    local entry = active[id]
    if not entry then return end

    for i = 1, #(entry.entries or {}) do
        local e = entry.entries[i]
        if e.zoneId then exports.ox_target:removeZone(e.zoneId) end
        if e.zone then e.zone:remove() end
        if e.entity and DoesEntityExist(e.entity) then DeleteEntity(e.entity) end
        if e.blip then RemoveBlip(e.blip) end
    end

    active[id] = nil
end

local function spawnEntity(shop, loc)
    -- Prop takes priority; otherwise an NPC ped if enabled.
    if shop.prop and shop.prop.enabled then
        local model = joaat(shop.prop.model or DEFAULT_PROP)
        lib.requestModel(model, 5000)
        local obj = CreateObject(model, loc.x + 0.0, loc.y + 0.0, loc.z + 0.0, false, false, false)
        SetEntityCoordsNoOffset(obj, loc.x + 0.0, loc.y + 0.0, loc.z + 0.0, false, false, false)
        SetEntityHeading(obj, loc.heading or 0.0)
        FreezeEntityPosition(obj, true)
        SetEntityInvincible(obj, true)
        SetModelAsNoLongerNeeded(model)
        return obj, 'prop'
    elseif shop.ped and shop.ped.enabled then
        local model = joaat(shop.ped.model or DEFAULT_PED)
        lib.requestModel(model, 5000)
        local ped = CreatePed(0, model, loc.x + 0.0, loc.y + 0.0, loc.z - 1.0, loc.heading or 0.0, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetModelAsNoLongerNeeded(model)
        return ped, 'ped'
    end
    return nil
end

local function buildShop(shop)
    destroyShop(shop.id)

    if shop.groups and not client.hasGroup(shop.groups) then
        active[shop.id] = { shop = shop, entries = {} }
        return
    end

    local locations = getLocations(shop)
    if #locations == 0 then
        active[shop.id] = { shop = shop, entries = {} }
        return
    end

    local entry = { shop = shop, entries = {} }
    local label = 'Browse ' .. (shop.label or shop.id)
    local markerEnabled = shop.showMarker ~= false
    local hasEntity = (shop.prop and shop.prop.enabled) or (shop.ped and shop.ped.enabled)
    -- A physical prop/ped takes up space, so widen the interaction zone slightly.
    local zoneSize = hasEntity and vec3(2.2, 2.2, 2.4) or vec3(1.6, 1.6, 2.0)

    for i = 1, #locations do
        local loc = locations[i]
        local coords = vec3(loc.x + 0.0, loc.y + 0.0, loc.z + 0.0)
        -- Raise the marker only when there's a prop/ped (so it isn't hidden
        -- inside it); a plain zone marker stays at ground level.
        local markerZ = coords.z + (hasEntity and 1.05 or 0.0)
        local e = {}

        e.entity = spawnEntity(shop, loc)

        if shop.blip then
            -- Start from the global shop blip appearance, then apply this shop's own
            -- sprite/colour overrides (null = keep the global default) so each shop
            -- can show a distinct map icon.
            local blipSettings = Appearance.BlipSettings('shop', shop.label or shop.id)

            if shop.blipSprite or shop.blipColor then
                local override = {}
                for k, v in pairs(blipSettings) do override[k] = v end
                if shop.blipSprite then override.id = shop.blipSprite end
                if shop.blipColor then override.colour = shop.blipColor end
                blipSettings = override
            end

            e.blip = createBlip(blipSettings, coords)
        end

        if shared.target then
            e.zoneId = exports.ox_target:addBoxZone({
                coords = coords,
                size = zoneSize,
                rotation = loc.heading or 0.0,
                debug = false,
                options = {
                    {
                        icon = 'fas fa-basket-shopping',
                        label = label,
                        groups = shop.groups,
                        onSelect = function()
                            client.openInventory('shop', { type = shop.id, id = i })
                        end,
                    },
                },
            })
        else
            e.zone = lib.zones.box({
                coords = coords,
                size = zoneSize,
                rotation = loc.heading or 0.0,
                debug = false,
                inside = function()
                    if markerEnabled then
                        Appearance.DrawMarker('shop', coords.x, coords.y, markerZ)
                    end

                    if IsControlJustReleased(0, 38) then -- E
                        client.openInventory('shop', { type = shop.id, id = i })
                    end
                end,
                onEnter = function() lib.showTextUI('[E] ' .. label) end,
                onExit = function() lib.hideTextUI() end,
            })
        end

        entry.entries[#entry.entries + 1] = e
    end

    active[shop.id] = entry
end

RegisterNetEvent('ox_inventory:setCustomShops', function(list)
    for i = 1, #list do buildShop(list[i]) end
end)

-- Blip appearance changed: rebuild shops so their blips pick up the new settings.
AddEventHandler('ox_inventory:appearanceChanged', function()
    for _, entry in pairs(active) do
        if entry.shop then buildShop(entry.shop) end
    end
end)

RegisterNetEvent('ox_inventory:registerCustomShop', function(shop)
    buildShop(shop)
end)

RegisterNetEvent('ox_inventory:removeCustomShop', function(id)
    destroyShop(id)
end)

-- Hide the spawned entity while repositioning it (rebuilt at the final spot).
function CustomShop.HideProp(id)
    local entry = active[id]
    if not entry then return end
    for i = 1, #(entry.entries or {}) do
        local e = entry.entries[i]
        if e.entity and DoesEntityExist(e.entity) then
            DeleteEntity(e.entity)
            e.entity = nil
        end
    end
end

exports('hideCustomShopProp', CustomShop.HideProp)

CreateThread(function()
    while not LocalPlayer.state.loaded and not PlayerData?.loaded do Wait(250) end
    Wait(700)
    TriggerServerEvent('ox_inventory:requestCustomShops')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for id in pairs(active) do destroyShop(id) end
end)

return CustomShop
