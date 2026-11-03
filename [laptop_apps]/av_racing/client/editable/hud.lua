function HideHud(hide)
    if hide then
        -- Hide hud event
        DisplayRadar(false)
    else
        -- Show hud event
        DisplayRadar(true)
    end
end