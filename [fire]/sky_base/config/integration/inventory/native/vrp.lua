---@diagnostic disable: duplicate-set-field, deprecated
-- Framework-native VRP inventory. Base layer for VRP servers. Guarded on the framework.
-- Legacy vRP uses kilograms and strength-based carrying capacity.
if Sky.Config.framework ~= "vrp" then return end
if not IsDuplicityVersion() then return end

local items_config = module("vrp", "cfg/items")
local item_definitions = items_config.items or items_config
local usable_item_choices = {}

local function register_item(name)
    local definition = item_definitions[name]
    vRP.defInventoryItem({
        name,
        definition[1] or name,
        definition[2] or "",
        usable_item_choices[name] or definition[3] or function() return {} end,
        definition[4] or 0
    })
end

if Sky.Config.inventory == "vrp" then
    function Sky.FW.GetInventoryStats(source)
        local user_id = vRP.getUserId({ source })
        if not user_id then
            Sky.Debug("error", "[inventory] vRP statistics unavailable: player %s is not loaded", source)
            return nil, "unavailable"
        end
        return SkyInventoryHelpers.NormalizeInventoryStats(vRP.getInventoryWeight({ user_id }),
            vRP.getInventoryMaxWeight({ user_id }), nil, nil, 1)
    end
end

---@description Registers a VRP usable item callback.
---@param name string
---@param callback function|nil
function Sky.FW.RegisterUsableItem(name, callback)
    local definition = item_definitions[name]
    if not definition then
        local label, description, weight = vRP.getItemDefinition({ name })
        definition = { label or name, description or "", nil, weight or 0 }
        item_definitions[name] = definition
    end

    if callback then
        usable_item_choices[name] = function(args)
            local choices = {}
            for key, value in pairs(definition[3] and definition[3](args) or {}) do
                choices[key] = value
            end
            choices.Use = {
                function(player)
                    callback(player, { name = name, label = vRP.getItemName({ name }), amount = 1 })
                end
            }
            return choices
        end
    else
        usable_item_choices[name] = nil
    end

    register_item(name)
    return true
end

function Sky.FW.RegisterItem(definition, options)
    if type(definition) ~= "table" or type(definition.name) ~= "string" or definition.name == "" then
        return false
    end

    local existing = item_definitions[definition.name]
    if type(options) == "table" and options.preserveExisting
        and vRP.getItemDefinition({ definition.name }) ~= nil then return true end

    item_definitions[definition.name] = {
        definition.label or existing and existing[1] or definition.name,
        definition.description or existing and existing[2] or "",
        existing and existing[3],
        definition.weight or existing and existing[4] or 0
    }
    register_item(definition.name)
    return vRP.getItemDefinition({ definition.name }) ~= nil
end

---@description Adds an item to the player's VRP inventory.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    if source == nil then return false end
    local user_id = vRP.getUserId({ source })
    if not user_id then return false end
    amount = tonumber(amount)
    if not amount or amount <= 0 or amount == math.huge or amount % 1 ~= 0 then return false end

    local before = vRP.getInventoryItemAmount({ user_id, item })
    vRP.giveInventoryItem({ user_id, item, amount, true })
    return vRP.getInventoryItemAmount({ user_id, item }) == before + amount
end

---@description Checks the legacy vRP strength-based inventory capacity.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryItem(source, item, amount, metadata)
    if source == nil then return false end
    local user_id = vRP.getUserId({ source })
    if not user_id then return false end
    amount = tonumber(amount)
    if not amount or amount <= 0 or amount == math.huge or amount % 1 ~= 0 then return false end
    if not vRP.getItemDefinition({ item }) then return false end

    local weight = vRP.getInventoryWeight({ user_id }) + vRP.getItemWeight({ item }) * amount
    return weight <= vRP.getInventoryMaxWeight({ user_id })
end

---@description Removes an item from the player's VRP inventory and returns the amount removed.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    if source == nil then return 0 end
    local user_id = vRP.getUserId({ source })
    if not user_id then return 0 end
    local removed = vRP.tryGetInventoryItem({ user_id, item, amount, true })
    return removed and amount or 0
end

---@description Checks whether the player has at least the given amount of an item.
---@param source number
---@param item string
---@param amount number
---@return boolean
function Sky.FW.HasItem(source, item, amount)
    if source == nil then return false end
    amount = tonumber(amount) or 1
    local user_id = vRP.getUserId({ source })
    if not user_id then return false end
    return (vRP.getInventoryItemAmount({ user_id, item }) or 0) >= amount
end

---@description Returns the player's VRP inventory as normalized item entries.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    if source == nil then return {} end
    local user_id = vRP.getUserId({ source })
    if not user_id then return {} end
    local data = vRP.getUserDataTable({ user_id })
    local items = {}
    for name, entry in pairs(data and data.inventory or {}) do
        items[#items + 1] = {
            name = name,
            label = vRP.getItemName({ name }),
            amount = entry.amount,
            count = entry.amount
        }
    end
    return items
end

---@description Returns the normalized item held by the player, or nil.
---@param source number
---@param item string
---@return table|nil
function Sky.FW.GetInventoryItem(source, item)
    if source == nil then return nil end
    local user_id = vRP.getUserId({ source })
    if not user_id then return nil end
    local amount = vRP.getInventoryItemAmount({ user_id, item })
    if not amount or amount <= 0 then return nil end
    return { name = item, label = vRP.getItemName({ item }), amount = amount, count = amount }
end

---@description Returns the framework's shared item definitions table.
---@return table
function Sky.FW.GetItems()
    local items = {}
    for name in pairs(item_definitions) do
        local label, description, weight = vRP.getItemDefinition({ name })
        if label then
            items[name] = { name = name, label = label, description = description, weight = weight }
        end
    end
    return items
end

---@description Returns the display label for an item.
---@param item string
---@return string
function Sky.FW.GetItemLabel(item)
    return vRP.getItemName({ item })
end

-- Legacy vRP exposes equipped weapons through client RPC, without an authoritative
-- server mutation/readback contract for these inventory operations.
function Sky.FW.CanCarryWeapon(source, weapon_name, metadata)
    Sky.Debug("debug", "[inventory] Native vRP weapon capacity checks are not supported")
    return false, "unsupported"
end

function Sky.FW.AddWeapon(source, weapon_name, ammo, metadata)
    Sky.Debug("debug", "[inventory] Native vRP weapon grants are not supported")
    return false, "unsupported"
end

function Sky.FW.RemoveWeapon(source, weapon_name, metadata)
    Sky.Debug("debug", "[inventory] Native vRP weapon removal is not supported")
    return false, "unsupported"
end
