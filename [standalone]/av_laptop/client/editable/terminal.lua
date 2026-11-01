local allExternal = {}
local allSuccess = {}

RegisterNUICallback("external", function(data, cb)
    local command = data and data.command
    local args = data and data.args
    dbug("external(command, args?)", command, args and json.encode(args) or "none")
    if command and allExternal[command] then
        dbug("Found external callback for command", command)
        local result = allExternal[command]({args = args, extraData = data and data.extraData})
        dbug("External callback result for command", command, result)
        if result == nil then
            result = true
        end
        cb(result)
    else
        dbug("No external callback found for command", command)
        cb(false)
    end
end)

RegisterNUICallback('success', function(data, cb)
    local command = data and data.command
    local args = data and data.args
    local token = data and data.token
    dbug("Command triggered successfully (command,args)", command, args and json.encode(args) or "none")
    local isAllowed = lib.callback.await('av_laptop:verifyPlayerCommand', false, command, args, token)
    dbug("Was player allowed to run this command?", isAllowed and "yes" or "no")
    if isAllowed then
        if command and allSuccess[command] then
            dbug("Found success callback for command", command)
            allSuccess[command]({args = args, extraData = data and data.extraData})
        end
    end
    cb("ok")
end)

RegisterNUICallback("failed", function(data, cb)
    local command = data and data.command
    local args = data and data.args
    dbug("Command failed to complete (command, args)", command, args and json.encode(args) or "none")
    cb("ok")
end)

exports("terminal", function(actions)
    dbug("terminal(actions)", actions and json.encode(actions) or "none")
    if not actions then return end
    SendNUIMessage({
        action = "terminal",
        data = {
            actions = actions
        }
    })
end)

exports("addExternal", function(command, callback)
    dbug("addExternal(command, callback)", command, callback and "function" or "none")
    if not command or not callback then return end
    allExternal[command] = callback
    dbug("External command added", command)
end)

exports("addSuccess", function(command, callback)
    dbug("addSuccess(command, callback)", command, callback and "function" or "none")
    if not command or not callback then return end
    allSuccess[command] = callback
    dbug("Success callback added", command)
end)

RegisterNetEvent("av_laptop:terminal", function(actions)
    dbug("Received terminal event with actions", actions and json.encode(actions) or "none")
    if not actions then return end
    SendNUIMessage({
        action = "terminal",
        data = {
            actions = actions
        }
    })
end)