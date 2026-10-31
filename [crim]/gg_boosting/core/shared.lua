local shared = {}
local utility = require("utility")

shared.populateResources = function()
    local basePath = GetResourcePath(GetCurrentResourceName()):gsub('//', '/') .. '/core/bridge/'
    local categories = {}

    local function inDirectory(path, pattern)
        local windows = string.match(os.getenv('OS') or '', 'Windows')
        local command = ('%s%s%s'):format(
            windows and 'dir "' or 'ls "',
            path:gsub('\\', '/'),
            windows and '/" /b' or '/"'
        )

        local results = {}
        local handle = io.popen(command)

        if handle then
            for line in handle:lines() do
                if line:match(pattern) and line ~= '.' and line ~= '..' and not line:match('^%s*$') then
                    table.insert(results, line)
                end
            end
            handle:close()
        end

        return results
    end


    local categoryDirs = inDirectory(basePath, ".+")
    for _, categoryName in ipairs(categoryDirs) do
        if categoryName ~= "." and categoryName ~= ".." and categoryName ~= "desktop.ini" then
            local categoryPath = basePath .. categoryName .. "/"
            categories[categoryName] = {}
            local scriptDirs = inDirectory(categoryPath, ".+")
            for _, scriptName in ipairs(scriptDirs) do
                if scriptName ~= "." and scriptName ~= ".." and scriptName ~= "desktop.ini" then
                    table.insert(categories[categoryName], scriptName)
                end
            end
        end
    end

    return categories
end




local function isTableEmpty(tbl)
    if type(tbl) ~= "table" then
        error("Expected a table, got " .. type(tbl))
    end

    for _ in pairs(tbl) do
        return false
    end
    return true
end


shared.checkResources = function(showWarning)
    local activeResources = {}
    local resources = shared.populateResources()

    for category, resourceList in pairs(resources) do
        activeResources[category] = {}
        for _, resource in ipairs(resourceList) do
            -- Overide Logic
            if utility[category] and utility[category] ~= "" then
                if GetResourceState(utility[category]) ~= "started" and GetResourceState(utility[category]) ~= "starting" and GetResourceState(utility[category]) ~= "stopped" then
                    warn(("%s is not in the server"):format(utility[category]))
                end
                table.insert(activeResources[category], utility[category])
                break
            end
            
            -- Auto Detection Logic
            if GetResourceState(resource) == "started" or GetResourceState(resource) == "starting" or GetResourceState(resource) == "stopped" then
                if category == "framework" then
                    if GetResourceState("qbx_core") == "started" then
                        table.insert(activeResources[category], "qbx_core")
                        if utility.debugMode then
                            print(("Auto Detected %s: qbx_core"):format(category))
                        end
                        break
                    end
                    if utility.debugMode then
                        print(("Auto Detected %s: %s"):format(category, resource))
                    end
                    table.insert(activeResources[category], resource)
                end
                    if utility.debugMode then
                        print(("Auto Detected %s: %s"):format(category, resource))
                    end
                    table.insert(activeResources[category], resource)
                break
            end
        end

        local response = isTableEmpty(activeResources[category])

        if response then
            table.insert(activeResources[category], "default")
            if showWarning then
                if category == "framework" or category == "inventory" or category == "target" then
                    local option_resources = {}
                    for k,v in pairs(resources[category]) do
                        if v ~= "default" then table.insert(option_resources, v) end
                    end

                    print(("\n^1================= [ RESOURCE NOT FOUND ] =================^0"))
                    print(("   Missing Category: ^1%s^0"):format(category))
                    print(("   ^3Bridged Options (Ensure dependency is started before): ^0%s"):format(GetCurrentResourceName()))
                    print(("   ^2Available Options:^0 %s"):format(json.encode(option_resources, { indent = true })))
                    print("^1==========================================================^0\n")
                end
            end
        end
    end

    return activeResources
end

shared.loadResourceScripts = function()
    local activeResources = shared.checkResources(true)
    for category, resources in pairs(activeResources) do
        for _, resource in ipairs(resources) do
            local resourceName = GetCurrentResourceName()
            local baseDir = "core/bridge/" .. category .. "/" .. resource .. "/"
            local clientScript = baseDir .. "client.lua"
            local serverScript = baseDir .. "server.lua"
            if IsDuplicityVersion() then
                local serverCode = LoadResourceFile(resourceName, serverScript)
                if serverCode then
                    local fn, err = load(serverCode, ("@%s"):format(serverScript))
                    if fn then
                        pcall(fn)
                    else
                        print(("[ERROR] Failed to load server script '%s': %s"):format(serverScript, err))
                    end
                end
            end
            if not IsDuplicityVersion() then
                local clientCode = LoadResourceFile(resourceName, clientScript)
                if clientCode then
                    local fn, err = load(clientCode, ("@%s"):format(clientScript))
                    if fn then
                        pcall(fn)
                    else
                        print(("[ERROR] Failed to load client script '%s': %s"):format(clientScript, err))
                    end
                else
                    print(("[WARNING] Client script '%s' not found. Skipping."):format(clientScript))
                end
            end
        end
    end
end

return shared