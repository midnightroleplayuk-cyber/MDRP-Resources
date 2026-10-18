Dispatch = Dispatch or {}

Dispatch['op-ambulancemdt'] = {
    alert = function(coords, message)
        local alertCoords = vector4(coords.x, coords.y, coords.z, 0.0)
        TriggerServerEvent('op-ambulancemdt:SendDispatchAlert', 'ambulance', 'Dispatch Alert', 'Patient requires assistance', red, 'medical_services', alertCoords)
    end
}