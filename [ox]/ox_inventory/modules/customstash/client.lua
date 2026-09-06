if not lib then return end

--[[
    Client side of dynamic stashes:
      • builds interaction zones / markers for each DB stash
      • spawns the optional prop (prop_drop_crate_01 by default)
      • the /oxinventory admin command + NUI bridge
      • the in-world placement editor (move / rotate / resize)
]]

local Appearance = require 'modules.customappearance.client'

local CustomStash = {}

---@type table<string, table> name -> { stash, zone, prop }
local active = {}

local DEFAULT_PROP = 'prop_drop_crate_01'

-- ── zone / prop construction ───────────────────────────────────

local function resolveCoords(stash)
    if stash.prop and stash.prop.enabled and stash.prop.coords then
        local c = stash.prop.coords
        return vec3(c.x + 0.0, c.y + 0.0, c.z + 0.0)
    end

    if stash.target and stash.target.coords then
        local c = stash.target.coords
        return vec3(c.x + 0.0, c.y + 0.0, c.z + 0.0)
    end

    if stash.coords then
        local c = stash.coords
        return vec3(c.x + 0.0, c.y + 0.0, c.z + 0.0)
    end

    return nil
end

local function destroyStash(name)
    local entry = active[name]
    if not entry then return end

    if entry.zoneId then exports.ox_target:removeZone(entry.zoneId) end
    if entry.zone then entry.zone:remove() end
    if entry.prop and DoesEntityExist(entry.prop) then
        DeleteEntity(entry.prop)
    end

    active[name] = nil
end

local function spawnProp(stash)
    local p = stash.prop
    if not (p and p.enabled and p.coords) then return nil end

    local model = joaat(p.model or DEFAULT_PROP)
    lib.requestModel(model, 5000)

    -- Spawn at the EXACT saved coords (no ground snap) and apply the same
    -- heading-only rotation the placement preview used, so the final prop sits
    -- pixel-perfectly where the preview was.
    local obj = CreateObject(model, p.coords.x + 0.0, p.coords.y + 0.0, p.coords.z + 0.0, false, false, false)
    SetEntityCoordsNoOffset(obj, p.coords.x + 0.0, p.coords.y + 0.0, p.coords.z + 0.0, false, false, false)
    SetEntityHeading(obj, (p.rotation and p.rotation.z) or 0.0)
    FreezeEntityPosition(obj, true)
    SetEntityInvincible(obj, true)
    SetModelAsNoLongerNeeded(model)

    return obj
end

local function buildStash(stash)
    destroyStash(stash.name)

    -- Hide stashes the player can't access (group gating handled server-side too).
    if stash.groups and not client.hasGroup(stash.groups) then
        active[stash.name] = { stash = stash }
        return
    end

    local coords = resolveCoords(stash)
    if not coords then
        active[stash.name] = { stash = stash }
        return
    end

    local entry = { stash = stash }
    entry.prop = spawnProp(stash)

    local label = (stash.target and stash.target.label) or ('Open ' .. (stash.label or stash.name))
    local size = stash.target and stash.target.size
    local hasProp = stash.prop and stash.prop.enabled
    -- Respect an explicit target size; otherwise use a default that's a bit
    -- wider when a physical prop is present (it takes up space).
    local defaultSize = hasProp and vec3(2.2, 2.2, 2.4) or vec3(1.5, 1.5, 2.0)
    local boxSize = size and vec3(size.x or 1.5, size.y or 1.5, size.z or 2.0) or defaultSize
    local rotation = (stash.target and stash.target.heading) or 0.0

    if shared.target then
        entry.zoneId = exports.ox_target:addBoxZone({
            coords = coords,
            size = boxSize,
            rotation = rotation,
            debug = false,
            options = {
                {
                    icon = 'fas fa-box-open',
                    label = label,
                    groups = stash.groups,
                    onSelect = function()
                        exports.ox_inventory:openInventory('stash', stash.name)
                    end,
                },
            },
        })
    else
        -- Marker floats above the object so it isn't hidden inside the prop.
        local markerEnabled = stash.showMarker ~= false
        -- Raise the marker only when there's a prop (so it isn't hidden inside
        -- it); a plain zone marker stays at ground level.
        local markerZ = coords.z + ((stash.prop and stash.prop.enabled) and 1.05 or 0.0)

        entry.zone = lib.zones.box({
            coords = coords,
            size = boxSize,
            rotation = rotation,
            debug = false,
            inside = function()
                if markerEnabled then
                    Appearance.DrawMarker('stash', coords.x, coords.y, markerZ)
                end

                if IsControlJustReleased(0, 38) then -- E
                    exports.ox_inventory:openInventory('stash', stash.name)
                end
            end,
            onEnter = function()
                lib.showTextUI('[E] ' .. label)
            end,
            onExit = function()
                lib.hideTextUI()
            end,
        })
    end

    active[stash.name] = entry
end

-- ── server sync events ─────────────────────────────────────────

RegisterNetEvent('ox_inventory:setCustomStashes', function(list)
    for i = 1, #list do buildStash(list[i]) end
end)

RegisterNetEvent('ox_inventory:registerCustomStash', function(stash)
    buildStash(stash)
end)

RegisterNetEvent('ox_inventory:removeCustomStash', function(name)
    destroyStash(name)
end)

-- While the placement editor is repositioning a prop, temporarily remove the
-- already-spawned real prop so the admin only sees (and moves) the preview.
-- The next sync / save rebuilds it at the final position.
function CustomStash.HideProp(name)
    local entry = active[name]
    if entry and entry.prop and DoesEntityExist(entry.prop) then
        DeleteEntity(entry.prop)
        entry.prop = nil
    end
end

exports('hideCustomStashProp', CustomStash.HideProp)

-- request definitions once the player has loaded in
CreateThread(function()
    while not LocalPlayer.state.loaded and not PlayerData?.loaded do Wait(250) end
    Wait(500)
    TriggerServerEvent('ox_inventory:requestCustomStashes')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for name in pairs(active) do destroyStash(name) end
end)

return CustomStash
