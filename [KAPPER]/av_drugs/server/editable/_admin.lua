Config = Config or {}
Config.AdminLevel = "admin" -- admin level needed to run admin commands
Config.ShellCommand = "shell" -- command used to spawn a shell and get coords offsets for interactions
Config.PanelCommand = "admin:drugs" -- Opens admin panel


if GetResourceState("av_gangs") ~= "started" then
    RegisterCommand(Config.ShellCommand, function(source,args)
        local model = args[1]
        local src = source
        local hasPermissions = exports['av_laptop']:getPermission(src, Config.AdminLevel)
        if hasPermissions and model then
            TriggerClientEvent('av_drugs:testShell', source, model)
        end
    end)
end

RegisterCommand(Config.PanelCommand, function(source,_)
    local hasPermissions = exports['av_laptop']:getPermission(source, Config.AdminLevel)
    if hasPermissions then
        TriggerClientEvent('av_drugs:openAdmin',source)
    end
end)

function isAdmin(source) -- an extra check to prevent ppl using lua injectors or weird sht
    local res = exports['av_laptop']:getPermission(source, Config.AdminLevel)
    if res then return true end
    local identifier = exports['av_laptop']:getIdentifier(source)
    print("^3[WARNING] ^7Player ^3"..identifier.."^7 triggered an admin event without admin permissions!")
    print("^3[WARNING] ^7Player ^3"..identifier.."^7 triggered an admin event without admin permissions!")
    print("^3[WARNING] ^7Player ^3"..identifier.."^7 triggered an admin event without admin permissions!")
    return false
end