tgiCore.OpenMechanicMenu = function()
    if config.tgiannServer then
        return TriggerEvent("tgiann-mekanik:polisjob")
    end

    print("No event has been defined to open the mechanic menu. Please edit the tgiann-core/client/functions/mechanic.lua file according to your mechanic script.")
end
