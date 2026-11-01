-- List of vehicles and their specific classes
-- The script will return the class if the model exists in the table instead of running the default check
-- key index: vehicle model with thicks ` `
-- value:string the class to return
local customModels = {
    [`raptor17`] = "D",
    [`my_vehicle_model`] = "S+",
}

function getClass(vehicle)
    if not vehicle then return false end
    local isMotorCycle = false
    local model = GetEntityModel(vehicle)
    if customModels and customModels[model] then
        return customModels[model]
    end
    -- --- FETCHING VEHICLE HANDLING DATA ---
    -- GetVehicleHandlingFloat is a native function to retrieve specific properties from the vehicle's handling data.
    local fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', "fInitialDriveMaxFlatVel")
    -- Maximum driving speed multiplier. (Crucial for top speed/acceleration)
    local fInitialDriveForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', "fInitialDriveForce")
    -- Driving force multiplier (affects acceleration and torque).
    local fInitialDragCoeff = GetVehicleHandlingFloat(vehicle, 'CHandlingData', "fInitialDragCoeff")
    -- Drag coefficient (air resistance), influences top speed and deceleration.
    local fTractionCurveMax = GetVehicleHandlingFloat(vehicle, 'CHandlingData', "fTractionCurveMax")
    -- Maximum grip/traction value. (Handling/Grip)
    local fTractionCurveMin = GetVehicleHandlingFloat(vehicle, 'CHandlingData', "fTractionCurveMin")
    -- Minimum grip/traction value. (Handling/Braking)
    local fSuspensionReboundDamp = GetVehicleHandlingFloat(vehicle, 'CHandlingData', "fSuspensionReboundDamp")
    -- Suspension rebound damping, affects vehicle stability and handling feel.
    local fBrakeForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', "fBrakeForce")
    -- Braking force multiplier.

    -- --- FORCE ADJUSTMENT ---
    local force = fInitialDriveForce
    -- Initialize a local 'force' variable.
    if fInitialDriveForce > 0 and fInitialDriveForce < 1 then
        -- Apply a custom boost factor (1.1 multiplier) to vehicles with a low drive force (typically slower/utility vehicles).
        force = force * 1.1
    end

    -- --- CALCULATING PERFORMANCE METRICS ---

    local accel = (fInitialDriveMaxFlatVel * force) / 10
    -- Calculate Acceleration (accel) based on Max Flat Velocity and adjusted Drive Force.
    local speed = ((fInitialDriveMaxFlatVel / fInitialDragCoeff) * (fTractionCurveMax + fTractionCurveMin)) / 40
    -- Calculate Speed (top end potential) using a combination of Max Velocity, Drag, and Traction curves.

    if GetVehicleClass(vehicle) == 8 then
        -- Check if the vehicle's internal GTA class ID is '8' (Motorcycles).
        isMotorCycle = true
    end

    if isMotorCycle then
        -- Apply a custom boost multiplier to the calculated 'speed' metric for motorcycles.
        speed = speed * 2
    end

    local handling = (fTractionCurveMax + fSuspensionReboundDamp) * fTractionCurveMin
    -- Calculate Handling based on Max Traction, Suspension Damping, and Min Traction.
    if isMotorCycle then
        -- Apply a custom division factor to the calculated 'handling' metric for motorcycles (reducing their score).
        handling = handling / 2
    end

    local braking = ((fTractionCurveMin / fInitialDragCoeff) * fBrakeForce) * 7
    -- Calculate Braking effectiveness using Min Traction, Drag, and Brake Force.

    -- --- FINAL PERFORMANCE RATING ---
    local perfRating = ((accel * 5) + speed + handling + braking) * 15
    -- The core performance rating formula: Acceleration is heavily weighted (x5), then the total is scaled (x15).

    -- --- ASSIGNING CLASS BASED ON RATING ---
    local vehClass = "D"
    -- Default class is set to "D".

    if isMotorCycle then
        -- Motorcycles receive a specific class designation ("M") regardless of their perfRating.
        vehClass = "M"
    elseif perfRating > 700 then
        vehClass = "S"
        -- 'S' Class: Highest Performance
    elseif perfRating > 550 then
        vehClass = "A"
        -- 'A' Class: High Performance
    elseif perfRating > 400 then
        vehClass = "B"
        -- 'B' Class: Mid Performance
    elseif perfRating > 325 then
        vehClass = "C"
        -- 'C' Class: Entry Level Performance
    else
        vehClass = "D"
        -- 'D' Class: Lowest Performance / Utility
    end

    return vehClass
    -- Return the determined vehicle class string.
end

exports('getClass', getClass)