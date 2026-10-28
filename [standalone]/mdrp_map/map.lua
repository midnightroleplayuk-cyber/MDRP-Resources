-- Extends the map boundaries to allow for a larger cursor area.
CreateThread(function()
    if Config.EnableCayoMap then
        local blip = AddBlipForCoord(6500.0, -6500.0, 0.0)
        SetBlipAlpha(blip, 0)
        SetBlipAsShortRange(blip, true)
    end
end)

CreateThread(function()
    while true do
        local interior = GetInteriorFromPrimaryView()

        if interior == 0 then
            -- Exterior
            SetRadarZoom(1100)
            SetRadarAsExteriorThisFrame()
            if Config.EnableCayoMap then
                SetRadarAsInteriorThisFrame('h4_fake_islandx', vec(4700.0, -5145.0), 0, 0)
            end
        else
            local cfg = Config.Interiors[interior]
            if cfg then
                SetRadarAsInteriorThisFrame(cfg.name, vec(cfg.x, cfg.y), 0, 0)
            else
                -- Interior with no override
                SetRadarZoom(0)
            end
        end

        Citizen.Wait(0)
    end
end)
