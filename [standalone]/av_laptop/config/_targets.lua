-- Config file for target scripts, no need to edit anything from here
Config = Config or {}
Config.Target = false

CreateThread(function()
    if GetResourceState("qb-target") == "started" then
        Config.Target = "qb-target"
    end
    if GetResourceState("ox_target") == "started" then
        Config.Target = "ox_target"
    end
end)

if lib.context == "client" then
    exports("disableTarget", function(state)
        if not Config.Target then return end
        if Config.Target == "ox_target" then
            return exports.ox_target:disableTargeting(state)
        end
        return exports['qb-target']:AllowTargeting(not state)
    end)
end