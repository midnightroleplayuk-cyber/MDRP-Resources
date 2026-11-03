Dispatch = Dispatch or {}

Dispatch['op-ambulancemdt'] = {
    alert = function(coords, message)
        local alertCoords = vector4(coords.x, coords.y, coords.z, 0.0)
        exports['op-ambulancemdt']:SendDispatchAlert('ambulance', 'Dispatch Alert', 'Patient requires assistance', red, 'fa-regular fa-message-medical', alertCoords)
    end
}