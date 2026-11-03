-- Open file: wire the radio into your other resources here.
Hooks = {}

---Called when a terminal presses the emergency button.
---@param src number
---@param data { issi: string, callsign: string, service: string, serviceKey: string, talkgroup: string, street: string, coords: vector3 }
function Hooks.OnEmergency(src, data)
    -- Example: send it to your dispatch resource. Swap for your dispatch's real export.
    -- if GetResourceState('vinewood_dispatch') == 'started' then
    --     exports.vinewood_dispatch:CreateAlert({
    --         code = 'EMERGENCY',
    --         title = ('Officer emergency: %s'):format(data.callsign),
    --         description = ('Emergency button activated on %s'):format(data.talkgroup),
    --         coords = data.coords,
    --         jobs = { data.serviceKey },
    --         priority = 1,
    --     })
    -- end
end

---Called after a terminal registers on the network.
function Hooks.OnPowerOn(src, unit) end

---Called after a terminal powers off (or is forced off).
function Hooks.OnPowerOff(src, reason) end
