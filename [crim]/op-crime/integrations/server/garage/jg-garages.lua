if Config.GarageScript == "jg-advancedgarages" then 
    function createGangGarage(garageCoords, orgLabel, oldLabel, id)
        TriggerEvent('jg-advancedgarages:server:createGangGarage', {
            coords = vec4(garageCoords.x, garageCoords.y, garageCoords.z, garageCoords.w),
            label = orgLabel,
            oldLabel = oldLabel,
            id = tostring(id)
        })
    end

    function deleteGangGarage(orgLabel, id)
        TriggerEvent('jg-advancedgarages:server:deleteGangGarage', orgLabel)
    end

    function garagesReadyToRegister()
        TriggerEvent('jg-advancedgarages:server:registerAllGarages')
    end
end