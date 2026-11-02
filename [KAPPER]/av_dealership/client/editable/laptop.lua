function OpenManagementPC(name, label)
    local settings = {
        serial = name,
        name = label,
        apps = {
            ["documents"] = true,
            ["dealership"] = true,
            ["calculator"] = true,
            ["terminal"] = false,
            ["browser"] = false,
        },
        storage = 150
    }
    exports['av_laptop']:openPC(settings)
end
