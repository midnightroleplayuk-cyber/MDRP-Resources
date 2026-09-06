local atmModels = {
    `prop_atm_01`,
    `prop_atm_02`,
    `prop_atm_03`,
    `prop_fleeca_atm`,
    `prop_atm_01_tube`,
    `prop_atm_02_strap`,
    `prop_atm_03_pole`
}

CreateThread(function()
    exports.ox_target:addModel(atmModels, {
        {
            name = 'use_atm_target',
            icon = 'fas --credit-card',
            label = 'Use ATM',
            distance = 3.0,
            onSelect = function(data)
                local entityCoords = GetEntityCoords(data.entity)
                TriggerServerEvent('hf1_atms:server:useATM', entityCoords)
            end
        }
    })
end)