--[[
Runs right before the catalogue camera takes over, once the screen is
already faded out. `id` is the scene identifier and `scene` holds the saved
vehicle and camera placement.

Use it for anything the scene needs in the world: interior entity sets,
IPLs, props, exports from other resources, time or weather overrides.

Example:
    if id == "aX9k2m41" then
        local interior = GetInteriorAtCoords(scene.vehicle.coords.x, scene.vehicle.coords.y, scene.vehicle.coords.z)
        ActivateInteriorEntitySet(interior, "entity_set_style_3")
        RefreshInterior(interior)
    end
]]--
function OnCatalogueScene(id, scene)
end

--[[
Runs when the catalogue closes, while the screen is still faded out.
Undo here whatever OnCatalogueScene turned on.
]]--
function OnCatalogueSceneEnd(id, scene)
end

--[[
Runs the moment the catalogue starts opening, before the screen fades out.
`name` is the dealership the player is browsing.

This is where you hide your HUD, minimap, or anything else that would sit
on top of the showroom camera.

Example:
    exports["my_hud"]:setVisible(false)
    DisplayRadar(false)
]]--
function OnCatalogueOpen(name)
end

--[[
Runs once the catalogue is fully closed and the screen is fading back in.
Bring back whatever OnCatalogueOpen hid.

Example:
    exports["my_hud"]:setVisible(true)
    DisplayRadar(true)
]]--
function OnCatalogueClose(name)
end
