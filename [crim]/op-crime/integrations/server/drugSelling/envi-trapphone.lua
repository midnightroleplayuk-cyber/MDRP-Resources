local selected = tostring(Config.DrugSelling.DrugScript)

if selected == "envi-trap-phone" then
    RegisterServerEvent('envi-trap:stackBread')
    AddEventHandler('envi-trap:stackBread', function(drugLabel, amountOfDrug, amountType, drugItem, NetID, amountPaid, vehNetID, model, faceValue)
        local turfId = exports['op-crime']:getPlayerTurfZone(source)
        if turfId then 
            TriggerEvent('op-crime:drugSold', source, turfId, amountPaid)
        end
    end)
end