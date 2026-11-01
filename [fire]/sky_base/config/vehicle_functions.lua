-- Client-side vehicle behavior. These functions are assigned to Sky.Vehicle by the vehicle module.
Functions.Vehicle = {}

function Functions.Vehicle.OnVehicleSpawn(vehicle, model_or_hash, coords, heading)
    
end

--- Gets the plate of a vehicle
function Functions.Vehicle.GetPlate(self)
    self.plate = Sky.Math.Trim(GetVehicleNumberPlateText(self.entity))
    return self.plate
end

--- Destroys the vehicle
function Functions.Vehicle.Remove(self)
    if self.entity and DoesEntityExist(self.entity) then
        SetEntityAsMissionEntity(self.entity, true, true)
        DeleteVehicle(self.entity)
        self.entity = nil
    end
end

function Functions.Vehicle.GiveKeys(self)
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(self.entity))
    local plate = GetVehicleNumberPlateText(self.entity)

    if Sky.Functions.GiveVehicleKeys then
        Sky.Functions.GiveVehicleKeys(self.entity, plate, model)
    else
        Sky.Debug("warn", "Sky.Vehicle:GiveKeys() called but no handler registered. Sky.Config.vehiclekeys=" .. tostring(Sky.Config.vehiclekeys))
    end
end

function Functions.Vehicle.RemoveKeys(self)
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(self.entity))
    local plate = GetVehicleNumberPlateText(self.entity)

    if Sky.Functions.RemoveVehicleKeys then
        Sky.Functions.RemoveVehicleKeys(self.entity, plate, model)
    else
        Sky.Debug("warn", "Sky.Vehicle:RemoveKeys() called but no handler registered. Sky.Config.vehiclekeys=" .. tostring(Sky.Config.vehiclekeys))
    end
end
