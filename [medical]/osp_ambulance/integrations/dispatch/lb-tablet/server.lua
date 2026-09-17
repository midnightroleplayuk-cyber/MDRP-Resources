Dispatch = Dispatch or {}

Dispatch['lb-tablet'] = {
    alert = function(coords, message)
        exports["lb-tablet"]:AddDispatch({
            priority = 'high',
            code = '911',
            title = '911 Emergency',
            description = message,
            location = {
                label = '911 Emergency',
                coords = { x = coords.x, y = coords.y },
            },
            time = 120,
            mdt = 'ambulance',
            sound = 'notification2.mp3',
            blip = {
                sprite = 310,
                color = 1,
                size = 1.2,
                label = '911 Emergency'
            }
        })
    end
}
