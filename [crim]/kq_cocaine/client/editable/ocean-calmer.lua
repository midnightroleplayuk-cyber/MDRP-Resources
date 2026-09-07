local islands = {
    { coords = vec3(5526.14, 2140.44, 14.8), radius = 500 },
    
    -- Cayo Perico scalar fix
    { coords = vec3(4840.571, -5174.425, 2.0), radius = 2000 },
}

local scalarSet = false

Citizen.CreateThread(function()
    while true do
        local sleep = 5000
        local playerCoords = GetEntityCoords(PlayerPedId())
        local withinIsland = false

        for _, island in ipairs(islands) do
            if #(playerCoords - island.coords) <= island.radius then
                withinIsland = true
                break
            end
        end

        if withinIsland then
            SetDeepOceanScaler(0.0)
            scalarSet = true
        elseif not withinIsland and scalarSet then
            ResetDeepOceanScaler()
            scalarSet = false
        end

        Citizen.Wait(sleep)
    end
end)
