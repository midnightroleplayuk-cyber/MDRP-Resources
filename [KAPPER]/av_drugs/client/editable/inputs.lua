local p = nil

function showInputs(data)
    if not data then return false end
    if data and not data['inputs'] then
        print("^3[WARNING] ^7showInputs functions didn't received data['inputs'], verify your code!")
        print("^3[WARNING] ^7showInputs functions didn't received data['inputs'], verify your code!")
        print("^3[WARNING] ^7showInputs functions didn't received data['inputs'], verify your code!")
        return false
    end
    p = promise.new()
    SetNuiFocus(true,true)
    SendNUIMessage({
        message = "loadInput",
        state = true,
        inputs = data
    })
    local result = Citizen.Await(p)
    return result
end

RegisterNUICallback('results', function(data,cb)
    p:resolve(data)
    p = nil
    SetNuiFocus(false, false)
    cb('ok')
end)

function inputClosed()
    if p then
        p:resolve(false)
        p = nil
    end
end