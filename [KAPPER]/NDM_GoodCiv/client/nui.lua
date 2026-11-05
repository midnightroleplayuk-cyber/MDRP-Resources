-- Thin wrapper around the NUI: messages out, callbacks in.
Nui = {}

local pendingCpr

function Nui.Send(action, data)
    SendNUIMessage({ action = action, data = data })
end

function Nui.Toast(kind, text)
    Nui.Send('toast', { type = kind, text = text })
end

function Nui.Focus(on)
    SetNuiFocus(on, on)
end

---Help-text token for a key mapped with RegisterKeyMapping.
function Nui.KeyToken(command)
    return ('%X'):format((GetHashKey(command) | 0x80000000) & 0xFFFFFFFF)
end

function Nui.HelpText(text)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

---Run the CPR rhythm minigame and wait for the compression quality (0-1).
function Nui.RunCpr(duration, bpm)
    pendingCpr = promise.new()
    Nui.Focus(true)
    Nui.Send('cpr', { duration = duration, bpm = bpm })
    -- Never hang if the UI is closed some other way.
    local p = pendingCpr
    SetTimeout((duration + 5) * 1000, function()
        if p == pendingCpr then p:resolve(nil) end
    end)
    local result = Citizen.Await(pendingCpr)
    pendingCpr = nil
    return result
end

function Nui.CancelCpr()
    if pendingCpr then
        Nui.Send('cprCancel')
        pendingCpr:resolve(nil)
    end
end

RegisterNUICallback('cprResult', function(data, cb)
    cb('ok')
    if pendingCpr then pendingCpr:resolve({ quality = tonumber(data.quality) or 0.0 }) end
end)

-- Client event for NPC scripts (hf1_npcs target event): sign up / sign off as a carrier.
local lastToggle = 0
AddEventHandler('goodciv:client:toggleCarrier', function()
    if GetGameTimer() - lastToggle < 1500 then return end
    lastToggle = GetGameTimer()
    TriggerServerEvent('goodciv:server:toggleCarrier')
end)

RegisterNetEvent('goodciv:client:toast', function(kind, text)
    Nui.Toast(kind, text)
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then Nui.Focus(false) end
end)
