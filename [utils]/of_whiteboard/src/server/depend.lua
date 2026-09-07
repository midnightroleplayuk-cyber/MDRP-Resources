local deps = {
    framework = {
        "qb-core",
        "qbx_core",
        "es_extended"
    },
    inventory = {
        "qb-inventory",
        "ox_inventory",
        "qs-inventory",
        "codem-inventory",
        "origen_inventory",
    },
    hard_depend = {
        "ox_lib"
    }
}
local not_found_cats = {}

function DependencyCheck()
  local aux = {}

    for cat, list in pairs(deps) do
        for _, name in ipairs(list) do
            if GetResourceState(name) == "started" then
                aux[cat] = name
            end
        end

        if not aux[cat] or aux[cat] == "auto" then
            error(("Missing %s resource, the script will stop working."):format(cat))
            not_found_cats[#not_found_cats + 1] = cat
            return { passed = false, status = not_found_cats }
        end
    end

    return { passed = true, status = aux }
end

function PrintDetectedBanner()
    print("^6-----------------------------------------------^7")
    print("^6[Overflow] ^7Dependencies detected successfully")
    print("  ^8Framework: ^7", Server.DependStatus.framework)
    print("  ^8Inventory: ^7", Server.DependStatus.inventory)
    -- print("  ^8Language: ^7", Config.Locale)
    print("^6-----------------------------------------------^7")
end
