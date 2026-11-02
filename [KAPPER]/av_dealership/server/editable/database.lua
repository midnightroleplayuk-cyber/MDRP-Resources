Database = {}
Database.VehiclesTable = "player_vehicles"
Database.OwnerColumn = "citizenid"
Database.ModsColumn = "mods"
Database.ModelColumn = "vehicle"
Database.PlatesColumn = "plate"

CreateThread(function()
    while GetResourceState("av_laptop") ~= "started" do Wait(100) end
    local framework = exports["av_laptop"]:getFramework()
    if framework == "esx" then
        Database.VehiclesTable = "owned_vehicles"
        Database.OwnerColumn = "owner"
        Database.ModsColumn = "vehicle"
        Database.ModelColumn = "model"
    end
end)
