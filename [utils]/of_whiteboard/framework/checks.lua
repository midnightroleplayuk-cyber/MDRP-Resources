Framework = Framework or {}
Framework.Check = {}

---@param source number
---@return boolean
Framework.Check.HasJob = function(source)
  local cfg = Config.Check and Config.Check.HasJob
  if not cfg then return true end

  if not Framework.Functions or not Framework.Functions.GetJob then
    error("No framework bridge loaded :: Framework.Functions.GetJob missing")
    return false
  end

  local name, grade = Framework.Functions.GetJob(source)
  if not name then return false end

  return name == cfg.name and (grade or 0) >= (cfg.grade or 0)
end

-- Runs every registered check. `payload.__operator` (set by the caller) decides
-- whether all must pass ("and") or any one is enough ("or")
---@param source number
---@param payload table
---@return boolean
Framework.DoChecks = function(source, payload)
  payload = payload or {}

  for _, check in pairs(Framework.Check) do
    local ok, passed = pcall(check, source)
    if not ok then
      error("Error executing framework check :: " .. tostring(passed))
      return false
    end

    if not passed and payload["and"] then return false end
    if passed and payload["or"] then return true end
  end

  -- "and": every check passed. "or": none passed
  return payload["and"] == true
end
