RegisterCommand("clearchat", function()
    SendNUIMessage({ type = "clearMessages" })
end, false)

for _, cmd in ipairs(Config.Commands) do
    if cmd.type == "client" and cmd.command ~= "clearchat" and cmd.command ~= "ids" then
        RegisterCommand(cmd.command, function(source, args)
            if cmd.callback then cmd.callback(source, args) end
        end, false)
    end
end
