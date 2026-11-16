local definitions, loaded = {}, {}

---@param name string
---@param body function
function defineModule(name, body)
    definitions[name] = body
end

---@param name string
---@return unknown
function requireModule(name)
    local mod = loaded[name]
    if mod ~= nil then return mod end

    local body = definitions[name]
    if not body then
        error(("module '%s' is not defined (is its file listed in fxmanifest.lua?)"):format(name), 2)
    end

    mod = body()
    if mod == nil then mod = true end
    loaded[name] = mod
    return mod
end
