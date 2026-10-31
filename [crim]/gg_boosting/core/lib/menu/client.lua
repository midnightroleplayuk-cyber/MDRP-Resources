gg.menu = gg.menu or {}


gg.menu.open = function(data, options)
    local id, title, menu = data.id, data.title, data.menu
    if GetResourceState("lation_ui") == "started" then
        exports.lation_ui:registerMenu({
            id = id,
            title = title,
            menu = menu,
            options = table.unpack({options})
        })

        exports.lation_ui:showMenu(id)
    else
        lib.registerContext({
            id = id,
            title = title,
            menu = menu,
            options = table.unpack({options})
        })
        lib.showContext(id)
    end
end

gg.menu.inputMenu = function(data)
    if type(data) ~= "table" then
        return false
    end

    local title       = data.title or "Input"
    local inputType   = data.type or "number"
    local label       = data.label or "Value"
    local description = data.description or nil
    local required    = data.required ~= false
    local default     = data.default or nil

    local quantity    = type(data.quantity) == "table" and data.quantity or {}
    local min         = tonumber(quantity.min) or 0
    local max         = tonumber(quantity.max) or 999999
    local result      = false

    if GetResourceState("lation_ui") == "started" then
        result = exports.lation_ui:input({
            title = title,
            options = {
                {
                    type = inputType,
                    label = label,
                    placeholder = description,
                    min = min,
                    max = max,
                    required = required,
                    default = default,
                },
            }
        })
    else
        result = lib.inputDialog(title, {
                {
                    type = inputType,
                    label = label,
                    description = description,
                    min = min,
                    max = max,
                    required = required,
                    default = default,
                },
        })
    end

    return result or false
end

gg.menu.alertDialog = function(data)
    if GetResourceState("lation_ui") == "started" then
        return exports.lation_ui:alert(data)
    else
        return lib.alertDialog(data)
    end
end


gg.menu.getOpenContextMenu = function()
    if GetResourceState("lation_ui") == "started" then
        return exports.lation_ui:getOpenMenu()
    else
        return lib.getOpenContextMenu()
    end    
end


-- gg.display.openMenu = function(data, options)
--     local id, title, menu = data.id, data.title, data.menu

--     lib.registerContext({
--         id = id,
--         title = title,
--         menu = menu,
--         options = table.unpack({options})
--     })
--     lib.showContext(id)
-- end
