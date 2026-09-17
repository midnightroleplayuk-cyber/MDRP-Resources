Functions.hud = {}

-- A getter is optional, but avoids toggling a HUD that already matches the requested visibility
---@return boolean | nil visible @ Current HUD visibility, or nil when it cannot be determined
function Functions.hud.get()
    if (not HudSystem) then
        local hudVisible = not IsHudHidden()
        local radarVisible = not IsRadarHidden()
        if (hudVisible == radarVisible) then return hudVisible end
    end

    if (HudSystem == "rhud") then
        return exports["rhud"]:get_visible()
    end

    if (HudSystem == "bablo-hud") then
        return exports["bablo-hud"]:IsHudVisible()
    end
end

---@param visible boolean @ Whether the detected HUD should be visible
function Functions.hud.toggle(visible)
    if (Functions.hud.get() == visible) then return end

    if (HudSystem == "esx_hud") then
        exports["esx_hud"]:HudToggle(visible)
    elseif (HudSystem == "jg-hud") then
        exports["jg-hud"]:toggleHud(visible)
    elseif (HudSystem == "wais-hudv6") then
        if (visible) then exports["wais-hudv6"]:showHud() else exports["wais-hudv6"]:hideHud() end
    elseif (HudSystem == "0r-hud-v3") then
        exports["0r-hud-v3"]:ToggleVisible(visible)
    elseif (HudSystem == "17mov_Hud") then
        exports["17mov_Hud"]:ToggleDisplay(visible)
    elseif (HudSystem == "izzy-hudv5") then
        exports["izzy-hudv5"]:setDisplay(visible)
    elseif (HudSystem == "izzy-hudv6") then
        exports["izzy-hudv6"]:setDisplay(visible)
    elseif (HudSystem == "izzy-hudv7") then
        if (visible) then exports["izzy-hudv7"]:showHUD() else exports["izzy-hudv7"]:hideHUD() end
    elseif (HudSystem == "vms_hud") then
        exports["vms_hud"]:Display(visible)
    elseif (HudSystem == "rhud") then
        exports["rhud"]:set_visible(visible)
    elseif (HudSystem == "envi-hud") then
        exports["envi-hud"]:ToggleHUD(visible)
    elseif (HudSystem == "cx-hud") then
        if (visible) then exports["cx-hud"]:showHud() else exports["cx-hud"]:hideHud() end
    elseif (HudSystem == "tgiann-lumihud") then
        TriggerEvent("tgiann-lumihud:ui", visible)
    elseif (HudSystem == "hex_4_hud") then
        exports["hex_4_hud"]:HideHud(not visible)
    elseif (HudSystem == "minimal-hud") then
        exports["minimal-hud"]:toggleHud(visible)
    elseif (HudSystem == "tgg-hud") then
        exports["tgg-hud"]:ToggleHud(visible)
    elseif (HudSystem == "sync-hud") then
        exports["sync-hud"]:ToggleHUD(visible)
    elseif (HudSystem == "hex_hud_prem") then
        exports["hex_hud_prem"]:HideHud(not visible)
    elseif (HudSystem == "bablo-hud") then
        if (visible) then exports["bablo-hud"]:ShowHud() else exports["bablo-hud"]:HideHud() end
    elseif (not HudSystem) then
        DisplayHud(visible)
        DisplayRadar(visible)
    end
end

function Functions.hud.hide()
    Functions.hud.toggle(false)
end

function Functions.hud.show()
    Functions.hud.toggle(true)
end

return Functions.hud