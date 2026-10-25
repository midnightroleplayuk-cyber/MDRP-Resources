---@type CLIBClient
clib = exports.cdev_lib:Get()
loc = clib.localizer.get

SoccerClientAPI = {}

SoccerClientAPI.GetScoreboardIdentifier = function()
    return GetPlayerServerId(PlayerId())
end

SoccerClientAPI.SetupGabzMBA = function()
    local interior = GetInteriorAtCoords(-324.22, -1968.49, 20.60)
    local entitySet = "football"

    if interior ~= 0 then
        local removeSets, newEntitySet = GabzConfig.Removals.interiors, GabzConfig.Sets[entitySet]
        local removeSigns, newSign = GabzConfig.Removals.signs, GabzConfig.Signs[entitySet]

        for i = 1, #removeSets do
            DeactivateInteriorEntitySet(interior, removeSets[i])
        end

        for i = 1, #removeSigns do
            RemoveIpl(removeSigns[i])
        end

        Wait(100)

        for i = 1, #newEntitySet do
            ActivateInteriorEntitySet(interior, newEntitySet[i])
        end

        if newSign then
            RequestIpl(newSign)
        end

        RefreshInterior(interior)
    end
end