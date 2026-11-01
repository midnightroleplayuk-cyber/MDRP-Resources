-- Load as a client script in Hex Inventory after client/os_functions.lua.
local vendorCanOpenInventory = canOpenInventory
assert(type(vendorCanOpenInventory) == "function",
    "[sky_jobs_base] Load hex_restraints.lua after Hex Inventory's client/os_functions.lua")

function canOpenInventory(...)
    if GetResourceState("sky_jobs_base") == "started" and exports.sky_jobs_base:isPlayerCuffed() then
        return false
    end
    return vendorCanOpenInventory(...)
end
