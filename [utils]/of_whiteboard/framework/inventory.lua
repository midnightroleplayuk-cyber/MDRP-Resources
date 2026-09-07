Inventory = { Name = nil, Functions = {} }

local IS_SERVER = IsDuplicityVersion()

-- Register a usable item across qb-family cores (used by the qb-style adapters)
local function createUsable(itemName, cb)
  if IsActiveFramework("qbx") then
    return exports.qbx_core:CreateUseableItem(itemName, cb)
  end
  if Framework.Core and Framework.Core.Functions and Framework.Core.Functions.CreateUseableItem then
    return Framework.Core.Functions.CreateUseableItem(itemName, cb)
  end
  error("Cannot register usable item :: no qb-style core available for " .. tostring(itemName))
end

-- Fire a configured item's event on the right side
local function fireItem(entry, source, item_data)
  if entry.target == "client" then
    TriggerClientEvent(entry.event, source, item_data)
  else
    TriggerEvent(entry.event, source, item_data)
  end
end

-- Wire every configured item to its event, given a register fn that binds
-- (itemName, handler)
local function bindConfiguredItems(register)
  for i = 1, #Config.items do
    local entry = Config.items[i]
    register(entry.item, function(source, item_data)
      fireItem(entry, source, item_data)
    end)
  end
end

local Adapters = {}

Adapters["ox_inventory"] = {
  resource = "ox_inventory",
  GiveItem = function(source, item, amount)
    local ok = exports.ox_inventory:AddItem(source, item, amount)
    return ok
  end,
  RemoveItem = function(source, item, amount)
    local ok = exports.ox_inventory:RemoveItem(source, item, amount, nil, nil, nil)
    return ok
  end,
  HasItem = function(source, item, amount)
    local data = exports.ox_inventory:GetItem(source, item, nil, true)
    return data and data.count >= (amount or 1)
  end,
  RegisterUsables = function()
    -- ox_inventory calls the export registered under this resource's name,
    -- keyed by the config `id` (the entry the item definition points at)
    for i = 1, #Config.items do
      local entry = Config.items[i]
      exports(entry.id, function(_, item_data, inventory)
        fireItem(entry, inventory.id, item_data)
      end)
    end
  end,
}

Adapters["qb-inventory"] = {
  resource = "qb-inventory",
  GiveItem = function(source, item, amount)
    return exports["qb-inventory"]:AddItem(source, item, amount, false, false, "of_whiteboard:GiveItem")
  end,
  RemoveItem = function(source, item, amount)
    return exports["qb-inventory"]:RemoveItem(source, item, amount, false, "of_whiteboard:RemoveItem")
  end,
  HasItem = function(source, item, amount)
    return exports["qb-inventory"]:HasItem(source, item, amount)
  end,
  RegisterUsables = function() bindConfiguredItems(createUsable) end,
}

Adapters["qs-inventory"] = {
  resource = "qs-inventory",
  GiveItem = function(source, item, amount)
    return exports["qs-inventory"]:AddItem(source, item, amount)
  end,
  RemoveItem = function(source, item, amount)
    return exports["qs-inventory"]:RemoveItem(source, item, amount)
  end,
  HasItem = function(source, item, amount)
    return (exports["qs-inventory"]:GetItemTotalAmount(source, item) or 0) >= (amount or 1)
  end,
  RegisterUsables = function() bindConfiguredItems(createUsable) end,
}

Adapters["codem-inventory"] = {
  resource = "codem-inventory",
  GiveItem = function(source, item, amount)
    return exports["codem-inventory"]:AddItem(source, item, amount)
  end,
  RemoveItem = function(source, item, amount)
    return exports["codem-inventory"]:RemoveItem(source, item, amount)
  end,
  HasItem = function(source, item, amount)
    local count = exports["codem-inventory"]:GetItemsTotalAmount(source, item)
    return (count or 0) >= (amount or 1)
  end,
  RegisterUsables = function()
    bindConfiguredItems(function(itemName, handler)
      exports["codem-inventory"]:RegisterUsableItem(itemName, handler)
    end)
  end,
}

Adapters["origen_inventory"] = {
  resource = "origen_inventory",
  GiveItem = function(source, item, amount)
    return exports.origen_inventory:addItem(source, item, amount, false, false, "of_whiteboard:GiveItem")
  end,
  RemoveItem = function(source, item, amount)
    return exports.origen_inventory:removeItem(source, item, amount)
  end,
  HasItem = function(source, item, amount)
    return exports.origen_inventory:hasItem(source, item, amount)
  end,
  RegisterUsables = function() bindConfiguredItems(createUsable) end,
}

local Noop = setmetatable({}, {
  __index = function() return function() return false end end,
})

local adapter = Config._inventory and Adapters[Config._inventory] or nil
Inventory.Name = Config._inventory

if not adapter then
  error(("No supported inventory found (Config.Inventory = %s), item checks will fail")
    :format(tostring(Config.Inventory)))
  adapter = Noop
end

if IS_SERVER then
  Inventory.Functions.GiveItem   = function(source, item, amount) return adapter.GiveItem(source, item, amount or 1) end
  Inventory.Functions.RemoveItem = function(source, item, amount) return adapter.RemoveItem(source, item, amount or 1) end
  Inventory.Functions.HasItem    = function(source, item, amount) return adapter.HasItem(source, item, amount or 1) end
  Inventory.Functions.RegisterUsables = function() return adapter.RegisterUsables() end
end
