if Sky.Config.inventory ~= "ox" and Sky.Config.inventory ~= "qbox" then return end
if Sky.Config.framework == "esx" or IsDuplicityVersion() then return end

AddEventHandler("ox_inventory:itemCount", function()
    TriggerEvent("sky_base:inventoryUpdated")
end)
