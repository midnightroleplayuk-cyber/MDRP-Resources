Locales = Locales or {}
Locales.selected = Config.Locale
Locales.data = Locale or {}

if not Locale then
  error(("Failed to load locale: %s (missing config/locale/%s.lua)")
    :format(tostring(Config.Locale), tostring(Config.Locale)))
else
  Locale = nil -- release the global; Locales.data is the source of truth from here
end

---@param key string
---@return string
function T(key)
  if type(key) ~= "string" then return "locale:invalid_key" end
  return Locales.data[key] or findTableValue(Locales.data, key) or key
end

Framework = Framework or {}
CONST = CONST or {}

if not IsDuplicityVersion() then
  Client = {}
  Client.Resource = GetCurrentResourceName()
  Client.server_endpoint = GetCurrentServerEndpoint()

  CONST.DEFAULT_LOCALE      = "en"
  CONST.BUILDING_RADIUS     = 8.0
  CONST.HANDLE_BUILDING_KEY = Config.keys.select_building_bound or 176 -- ENTER
  CONST.STOP_BUILDING_KEY   = Config.keys.leave_building_mode or 200   -- ESC
  CONST.MAIN_COLOR          = { r = 108, g = 59, b = 255, a = 255 }
  CONST.RENDER_DISTANCE     = Config.render_distance or 10.0

  Nui = {}
  Nui.MenuOpened = false
else
  Server = {}
  Server.Resource = GetCurrentResourceName()

  lib.callback.register("of_whiteboard:server:do_checks", function(source, payload)
    payload = payload or {}

    local operator = Config.Check.__operator or "and"
    payload[operator] = true

    local ok, res = pcall(Framework.DoChecks, source, payload)
    if not ok then
      error("Error executing checks :: of_whiteboard:server:do_checks \n" .. tostring(res))
      return false
    end

    return res
  end)

  local succ, depend_data = pcall(DependencyCheck)
  if succ and depend_data and depend_data.passed then
    Server.DependStatus = depend_data.status
    PrintDetectedBanner()
  else
    error("Dependency check failed, some features will not work :: " ..
      json.encode((succ and depend_data and depend_data.status) or tostring(depend_data)))
  end

  if not (Framework.Functions and Framework.Functions.GetJob) then
    error(("No framework bridge loaded for '%s' :: check config/config.lua Config.Framework"):format(tostring(Config._framework)))
  end

  debugC("Framework detected", Config._framework, "inventory", Config._inventory)
end
