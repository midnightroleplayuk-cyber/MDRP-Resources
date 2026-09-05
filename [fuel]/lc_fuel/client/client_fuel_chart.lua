

-----------------------------------------------------------------------------------------------------------------------------------------
-- Fuel consumption chart
-----------------------------------------------------------------------------------------------------------------------------------------

if Config.FuelConsumptionChart.enabled then
    RegisterCommand(Config.FuelConsumptionChart.command,function(source)
        toggleFuelConsumptionChart()
    end, false)

    RegisterCommand("fuel_focus", function()
        if isFuelConsumptionChartOpen then
            SetNuiFocus(true,true)
        end
    end, false)

    RegisterKeyMapping(
        "fuel_focus",             -- command triggered by key
        "Focus Fuel Chart UI",    -- description in keybindings
        "keyboard",
        Config.FuelConsumptionChart.focusShortcut
    )

    function toggleFuelConsumptionChart()
        loadNuiVariables()
        if isFuelConsumptionChartOpen then
            closeFuelConsumptionChartUI()
        else
            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped, false) then
                exports['lc_utils']:notify("error",Utils.translate("vehicle_not_found"))
                return
            end
            local vehicle = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(vehicle, -1) ~= ped or IsVehicleBlacklisted(vehicle) then
                exports['lc_utils']:notify("error",Utils.translate("vehicle_not_found"))
                return
            end

            SendNUIMessage({
                showFuelConsumptionChart = true,
                isRecording = isRecording,
                position = Config.FuelConsumptionChart.position,
                focusShortcut = Config.FuelConsumptionChart.focusShortcut,
            })
            isFuelConsumptionChartOpen = true
        end
    end

    function updateFuelConsumptionChart(fuelConsumptionData)
        SendNUIMessage({
            updateFuelConsumptionChart = true,
            fuelConsumptionData = fuelConsumptionData,
        })
    end

    function closeFuelConsumptionChartUI()
        SendNUIMessage({
            hideFuelConsumptionChart = true,
        })
        isFuelConsumptionChartOpen = false
        SetNuiFocus(false,false)
    end

    function storeDataForChart(vehicle, newFuelLevel, currentConsumption)
        if not isRecording then 
            updateFuelConsumptionChart({ fuel = nil, speed = nil, consumption = nil })
            return
         end

        local speed = GetEntitySpeed(vehicle) * 3.6
        if isFuelConsumptionChartOpen then
            updateFuelConsumptionChart({ fuel = newFuelLevel, speed = speed, consumption = currentConsumption })
        end
    end
end