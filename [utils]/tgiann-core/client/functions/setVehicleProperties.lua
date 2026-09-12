if config.framework == "esx" then
    tgiCore.SetVehicleProperties = myFramework.Game.SetVehicleProperties
elseif config.framework == "qb" then
    tgiCore.SetVehicleProperties = myFramework.Functions.SetVehicleProperties
else
    local gameBuild = GetGameBuildNumber()

    function tgiCore.SetVehicleProperties(vehicle, props, fixVehicle)
        if not DoesEntityExist(vehicle) then
            error(("Unable to set vehicle properties for '%s' (entity does not exist)"):format(vehicle))
        end

        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

        SetVehicleModKit(vehicle, 0)
        -- SetVehicleAutoRepairDisabled(vehicle, true)

        if props.extras then
            for id, disable in pairs(props.extras) do
                SetVehicleExtra(vehicle, tonumber(id) --[[@as number]], disable == 1)
            end
        end

        if props.plate then
            SetVehicleNumberPlateText(vehicle, props.plate)
        end

        if props.plateIndex then
            SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
        end

        if props.bodyHealth then
            SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
        end

        if props.engineHealth then
            SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
        end

        if props.tankHealth then
            SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0)
        end

        if props.fuelLevel then
            SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
        end

        if props.oilLevel then
            SetVehicleOilLevel(vehicle, props.oilLevel + 0.0)
        end

        if props.dirtLevel then
            SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
        end

        if props.color1 then
            if type(props.color1) == 'number' then
                ClearVehicleCustomPrimaryColour(vehicle)
                SetVehicleColours(vehicle, props.color1 --[[@as number]], colorSecondary --[[@as number]])
            else
                if props.paintType1 then SetVehicleModColor_1(vehicle, props.paintType1, colorPrimary, pearlescentColor) end

                SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
            end
        end

        if props.color2 then
            if type(props.color2) == 'number' then
                ClearVehicleCustomSecondaryColour(vehicle)
                SetVehicleColours(vehicle, props.color1 or colorPrimary --[[@as number]], props.color2 --[[@as number]])
            else
                if props.paintType2 then SetVehicleModColor_2(vehicle, props.paintType2, colorSecondary) end

                SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
            end
        end

        if props.pearlescentColor or props.wheelColor then
            SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor or wheelColor)
        end

        if props.interiorColor then
            SetVehicleInteriorColor(vehicle, props.interiorColor)
        end

        if props.dashboardColor then
            SetVehicleDashboardColor(vehicle, props.dashboardColor)
        end

        if props.wheels then
            SetVehicleWheelType(vehicle, props.wheels)
        end

        if props.wheelSize then
            SetVehicleWheelSize(vehicle, props.wheelSize)
        end

        if props.wheelWidth then
            SetVehicleWheelWidth(vehicle, props.wheelWidth)
        end

        if props.windowTint then
            SetVehicleWindowTint(vehicle, props.windowTint)
        end

        if props.neonEnabled then
            for i = 1, #props.neonEnabled do
                SetVehicleNeonLightEnabled(vehicle, i - 1, props.neonEnabled[i])
            end
        end

        if props.windows then
            for i = 1, #props.windows do
                RemoveVehicleWindow(vehicle, props.windows[i])
            end
        end

        if props.doors then
            for i = 1, #props.doors do
                SetVehicleDoorBroken(vehicle, props.doors[i], true)
            end
        end

        if props.tyres then
            for tyre, state in pairs(props.tyres) do
                SetVehicleTyreBurst(vehicle, tonumber(tyre) --[[@as number]], state == 2, 1000.0)
            end
        end

        if props.neonColor then
            SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
        end

        if props.modSmokeEnabled ~= nil then
            ToggleVehicleMod(vehicle, 20, props.modSmokeEnabled)
        end

        if props.tyreSmokeColor then
            SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
        end

        if props.modSpoilers then
            SetVehicleMod(vehicle, 0, props.modSpoilers, false)
        end

        if props.modFrontBumper then
            SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
        end

        if props.modRearBumper then
            SetVehicleMod(vehicle, 2, props.modRearBumper, false)
        end

        if props.modSideSkirt then
            SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
        end

        if props.modExhaust then
            SetVehicleMod(vehicle, 4, props.modExhaust, false)
        end

        if props.modFrame then
            SetVehicleMod(vehicle, 5, props.modFrame, false)
        end

        if props.modGrille then
            SetVehicleMod(vehicle, 6, props.modGrille, false)
        end

        if props.modHood then
            SetVehicleMod(vehicle, 7, props.modHood, false)
        end

        if props.modFender then
            SetVehicleMod(vehicle, 8, props.modFender, false)
        end

        if props.modRightFender then
            SetVehicleMod(vehicle, 9, props.modRightFender, false)
        end

        if props.modRoof then
            SetVehicleMod(vehicle, 10, props.modRoof, false)
        end

        if props.modEngine then
            SetVehicleMod(vehicle, 11, props.modEngine, false)
        end

        if props.modBrakes then
            SetVehicleMod(vehicle, 12, props.modBrakes, false)
        end

        if props.modTransmission then
            SetVehicleMod(vehicle, 13, props.modTransmission, false)
        end

        if props.modHorns then
            SetVehicleMod(vehicle, 14, props.modHorns, false)
        end

        if props.modSuspension then
            SetVehicleMod(vehicle, 15, props.modSuspension, false)
        end

        if props.modArmor then
            SetVehicleMod(vehicle, 16, props.modArmor, false)
        end

        if props.modNitrous then
            SetVehicleMod(vehicle, 17, props.modNitrous, false)
        end

        if props.modTurbo ~= nil then
            ToggleVehicleMod(vehicle, 18, props.modTurbo)
        end

        if props.modSubwoofer ~= nil then
            ToggleVehicleMod(vehicle, 19, props.modSubwoofer)
        end

        if props.modHydraulics ~= nil then
            ToggleVehicleMod(vehicle, 21, props.modHydraulics)
        end

        if props.modXenon ~= nil then
            ToggleVehicleMod(vehicle, 22, props.modXenon)
        end

        if props.xenonColor then
            SetVehicleXenonLightsColor(vehicle, props.xenonColor)
        end

        if props.modFrontWheels then
            SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
        end

        if props.modBackWheels then
            SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR)
        end

        if props.modPlateHolder then
            SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
        end

        if props.modVanityPlate then
            SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
        end

        if props.modTrimA then
            SetVehicleMod(vehicle, 27, props.modTrimA, false)
        end

        if props.modOrnaments then
            SetVehicleMod(vehicle, 28, props.modOrnaments, false)
        end

        if props.modDashboard then
            SetVehicleMod(vehicle, 29, props.modDashboard, false)
        end

        if props.modDial then
            SetVehicleMod(vehicle, 30, props.modDial, false)
        end

        if props.modDoorSpeaker then
            SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
        end

        if props.modSeats then
            SetVehicleMod(vehicle, 32, props.modSeats, false)
        end

        if props.modSteeringWheel then
            SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
        end

        if props.modShifterLeavers then
            SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
        end

        if props.modAPlate then
            SetVehicleMod(vehicle, 35, props.modAPlate, false)
        end

        if props.modSpeakers then
            SetVehicleMod(vehicle, 36, props.modSpeakers, false)
        end

        if props.modTrunk then
            SetVehicleMod(vehicle, 37, props.modTrunk, false)
        end

        if props.modHydrolic then
            SetVehicleMod(vehicle, 38, props.modHydrolic, false)
        end

        if props.modEngineBlock then
            SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
        end

        if props.modAirFilter then
            SetVehicleMod(vehicle, 40, props.modAirFilter, false)
        end

        if props.modStruts then
            SetVehicleMod(vehicle, 41, props.modStruts, false)
        end

        if props.modArchCover then
            SetVehicleMod(vehicle, 42, props.modArchCover, false)
        end

        if props.modAerials then
            SetVehicleMod(vehicle, 43, props.modAerials, false)
        end

        if props.modTrimB then
            SetVehicleMod(vehicle, 44, props.modTrimB, false)
        end

        if props.modTank then
            SetVehicleMod(vehicle, 45, props.modTank, false)
        end

        if props.modWindows then
            SetVehicleMod(vehicle, 46, props.modWindows, false)
        end

        if props.modDoorR then
            SetVehicleMod(vehicle, 47, props.modDoorR, false)
        end

        if props.modLivery then
            SetVehicleMod(vehicle, 48, props.modLivery, false)
            SetVehicleLivery(vehicle, props.modLivery)
        end

        if props.modRoofLivery then
            SetVehicleRoofLivery(vehicle, props.modRoofLivery)
        end

        if props.modLightbar then
            SetVehicleMod(vehicle, 49, props.modLightbar, false)
        end

        if props.bulletProofTyres ~= nil then
            SetVehicleTyresCanBurst(vehicle, props.bulletProofTyres)
        end

        if gameBuild >= 2372 and props.driftTyres then
            SetDriftTyresEnabled(vehicle, true)
        end

        if fixVehicle then
            SetVehicleFixed(vehicle)
        end
    end
end
