--[[
  Optional server-side police / dispatch hook (escrow-open).

  Client Editable.policeAlert can TriggerServerEvent into your own resource,
  or call this via the built-in event below.
]]

EditableServer = EditableServer or {}

---@param source number
---@param key string
---@param message string
---@param coords vector3|{x:number,y:number,z:number}|nil
function EditableServer.policeAlert(source, key, message, coords)
    -- Example:
    -- TriggerEvent('your-dispatch:server:alert', source, key, message, coords)
    -- or exports['ps-dispatch']:Something(...)
end

RegisterNetEvent(_e('server:editable:policeAlert'), function(key, message, coords)
    local src = source
    if EditableServer.policeAlert then
        EditableServer.policeAlert(src, key, message, coords)
    end
end)
