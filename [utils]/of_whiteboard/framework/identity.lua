Framework = Framework or {}
Framework.Functions = Framework.Functions or {}

-- Loaded after the core bridges so a framework that implements one of these wins.
-- Anything left unimplemented degrades to nil rather than erroring, which is what
-- the ownership and logging paths expect
local DEFAULTS = {
  GetIdentifier    = function() return nil end,
  GetCharacterName = function() return nil end,
  GetPhone         = function() return nil end,
  IsAdmin          = function() return false end,
}

for name, fallback in pairs(DEFAULTS) do
  if type(Framework.Functions[name]) ~= "function" then
    Framework.Functions[name] = fallback
  end
end

local function firstIdentifier(source, prefix)
  for _, id in ipairs(GetPlayerIdentifiers(source) or {}) do
    if id:sub(1, #prefix) == prefix then return id:sub(#prefix + 1) end
  end
  return nil
end

---Everything the logger may want about a player, resolved through the bridge.
---Missing pieces come back nil so callers can skip the field entirely
---@param source number
---@return { name: string?, identifier: string?, phone: string?, discord: string?, license: string? }
function Framework.Identity(source)
  local ok, name = pcall(Framework.Functions.GetCharacterName, source)
  local okId, identifier = pcall(Framework.Functions.GetIdentifier, source)
  local okPhone, phone = pcall(Framework.Functions.GetPhone, source)

  return {
    name       = ok and name or GetPlayerName(source),
    identifier = okId and identifier or nil,
    phone      = okPhone and phone or nil,
    discord    = firstIdentifier(source, "discord:"),
    license    = firstIdentifier(source, "license:"),
  }
end

---@param source number
---@return boolean
function Framework.IsAdmin(source)
  local cfg = Config.ownership or {}
  if not cfg.admin_override then return false end

  local ok, res = pcall(Framework.Functions.IsAdmin, source, cfg.admin_permission or "admin")
  return ok and res == true
end
