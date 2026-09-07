Framework = Framework or {}

-- Ordered so a more specific core wins when several are present
local FRAMEWORKS = {
  { name = "qbx", resource = "qbx_core" },
  { name = "qb",  resource = "qb-core" },
  { name = "esx", resource = "es_extended" },
}

local INVENTORIES = {
  "ox_inventory", "qb-inventory", "qs-inventory", "codem-inventory", "origen_inventory",
}

local function resolveFramework()
  if Config.Framework and Config.Framework ~= "auto" then return Config.Framework end
  for _, fw in ipairs(FRAMEWORKS) do
    if GetResourceState(fw.resource) == "started" then return fw.name end
  end
  return nil
end

local function resolveInventory()
  if Config.Inventory and Config.Inventory ~= "auto" then return Config.Inventory end
  for _, inv in ipairs(INVENTORIES) do
    if GetResourceState(inv) == "started" then return inv end
  end
  return nil
end

Config._framework = resolveFramework()
Config._inventory = resolveInventory()

---@param name string
---@return boolean
function IsActiveFramework(name)
  return Config._framework == name
end
