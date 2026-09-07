Notify = { Name = nil, Functions = {} }

local IS_SERVER = IsDuplicityVersion()
local DEFAULT_DURATION = 3000

local Adapters = {}

Adapters.ox_lib = {
  resource = "ox_lib",
  Send = function(source, message, kind, duration)
    local data = { description = message, type = kind or "inform", duration = duration or DEFAULT_DURATION }
    if IS_SERVER then
      TriggerClientEvent("ox_lib:notify", source, data)
    else
      lib.notify(data)
    end
  end,
}

Adapters.framework = {
  resource = nil, -- tied to the active Config.Framework, not auto-detected
  Send = function(source, message, kind, duration)
    if IS_SERVER then
      TriggerClientEvent("of_whiteboard:client:notify", source, message, kind, duration)
    elseif Framework.Functions and Framework.Functions.Notify then
      Framework.Functions.Notify(message, kind, duration)
    else
      lib.notify({ description = message, type = kind or "inform", duration = duration or DEFAULT_DURATION })
    end
  end,
}

local function resolveAdapter()
  local configured = Config.Notify
  if configured and Adapters[configured] then
    return configured, Adapters[configured]
  end
  if GetResourceState("ox_lib") == "started" then
    return "ox_lib", Adapters.ox_lib
  end
  return "framework", Adapters.framework
end

do
  local name, adapter = resolveAdapter()
  Notify.Name = name

  if IS_SERVER then
    ---@param source number
    Notify.Functions.Send = function(source, message, kind, duration)
      return adapter.Send(source, message, kind, duration)
    end
  else
    Notify.Functions.Send = function(message, kind, duration)
      return adapter.Send(nil, message, kind, duration)
    end

    RegisterNetEvent("of_whiteboard:client:notify", function(message, kind, duration)
      Notify.Functions.Send(message, kind, duration)
    end)
  end
end
