if not lib then return end

--[[
    Client side of the per-type marker / blip appearance.

    Holds the config (one block per type: stash / craft / shop) the dynamic
    modules read when drawing their markers and creating their blips. The server
    pushes the config on spawn and whenever an admin saves; on change we fire
    `ox_inventory:appearanceChanged` so each module can rebuild its blips.

    Also runs the in-world live preview shown while the admin tweaks values in
    the Settings panel.
]]

local CustomAppearance = {}

local DEFAULT_BLOCK = {
    marker = {
        type = 21,
        color = { r = 31, g = 94, b = 255 },
        alpha = 180,
        scale = 0.4,
        bob = true,
    },
    blip = {
        sprite = 566,
        color = 31,
        scale = 0.7,
        alpha = 255,
        shortRange = true,
        display = 2,
        name = '',
    },
}

---@type table per-type config currently in effect (starts on defaults)
local config = { stash = DEFAULT_BLOCK, craft = DEFAULT_BLOCK, shop = DEFAULT_BLOCK }

-- Resolve a type's block, tolerating a legacy flat config or a missing type.
local function block(kind)
    if config[kind] then return config[kind] end
    if config.marker or config.blip then return config end -- legacy flat
    return DEFAULT_BLOCK
end

function CustomAppearance.Get()
    return config
end

-- Draws the configured marker for `kind` at the given ground coords. `lift`
-- raises it above the object (props sit higher than bare zones).
function CustomAppearance.DrawMarker(kind, x, y, z, lift)
    local m = block(kind).marker
    local s = m.scale
    DrawMarker(m.type, x, y, z + (lift or 0.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        s, s, s * 0.75,
        m.color.r, m.color.g, m.color.b, m.alpha,
        m.bob ~= false, false, 0, true, false, false, false)
end

-- Blip settings for `kind`, shaped for utils.CreateBlip. A custom blip name
-- configured in the settings panel overrides the per-location label when set.
function CustomAppearance.BlipSettings(kind, name)
    local b = block(kind).blip
    return {
        id = b.sprite,
        colour = b.color,
        scale = b.scale,
        alpha = b.alpha,
        shortRange = b.shortRange ~= false,
        display = b.display,
        name = (b.name and b.name ~= '') and b.name or name,
    }
end

RegisterNetEvent('ox_inventory:setAppearance', function(data)
    if type(data) == 'table' then
        config = data
        TriggerEvent('ox_inventory:appearanceChanged', config)
    end
end)

CreateThread(function()
    while not LocalPlayer.state.loaded and not PlayerData?.loaded do Wait(250) end
    Wait(500)
    TriggerServerEvent('ox_inventory:requestAppearance')
end)

-- ── live preview ───────────────────────────────────────────────
-- A floating marker drawn in front of the player while editing, updated live as
-- the panel posts new values. The panel hides itself; this only draws.

local previewActive = false
local previewMarker = nil ---@type table?

local function previewLoop()
    if previewActive then return end
    previewActive = true

    CreateThread(function()
        while previewActive do
            Wait(0)
            local m = previewMarker
            if m then
                -- Place it slightly forward and to the RIGHT of the player so it
                -- shows on the right side of the screen, clear of the editor panel
                -- which is docked to the left while previewing.
                local ped = cache.ped
                local base = GetEntityCoords(ped)
                local h = math.rad(GetEntityHeading(ped))
                local fx, fy = -math.sin(h), math.cos(h) -- forward
                local rx, ry = math.cos(h), math.sin(h)  -- right
                local x = base.x + fx * 2.2 + rx * 1.1
                local y = base.y + fy * 2.2 + ry * 1.1
                local z = base.z - 0.9
                local s = m.scale or 0.4
                DrawMarker(m.type or 21, x, y, z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    s, s, s * 0.75,
                    m.color.r, m.color.g, m.color.b, m.alpha or 180,
                    m.bob ~= false, false, 0, true, false, false, false)
            end
        end
    end)
end

function CustomAppearance.StartPreview(marker)
    previewMarker = marker
    previewLoop()
end

function CustomAppearance.UpdatePreview(marker)
    previewMarker = marker
end

function CustomAppearance.StopPreview()
    previewActive = false
    previewMarker = nil
end

return CustomAppearance
