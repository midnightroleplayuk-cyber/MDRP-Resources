gg.dispatch = gg.dispatch or {}

---@param data table
--- data.message   string   | Dispatch message text
--- data.code      string   | Dispatch code (e.g. "10-80")
--- data.icon      string   | FontAwesome icon string (unused by rcore_dispatch)
--- data.priority  number   | Priority level (1 = high, 3 = low)
--- data.coords    vector3  | Location for the dispatch alert
--- data.vehicle   number   | Vehicle entity (optional)
--- data.plate     string   | Vehicle plate (optional)
--- data.time      number   | Alert duration in ms (10000 = 10s)
--- data.jobs      table    | List of jobs who see the alert
--- data.blipData  table    | Blip config {radius, sprite, color, scale, length, flash}
---   radius       number   | Blip radius
---   sprite       number   | Blip sprite ID
---   color        number   | Blip color ID
---   scale        number   | Blip scale
---   length       number   | Length in ms (converted to seconds internally)
---   flash        boolean  | Should blip flash
gg.dispatch.alert = function(data)
    local playerData = exports['rcore_dispatch']:GetPlayerData()
    local alertData = {
        code = data.code or '10-00',
        default_priority = (data.priority == 1 and 'high') or (data.priority == 2 and 'medium') or 'low',
        coords = data.coords or playerData.coords,
        job = data.jobs or 'police',
        text = data.message or 'Dispatch Alert',
        type = 'alerts',
        blip_time = data.time and (data.time / 1000) or 5,
        blip = {
            sprite = data.blipData and data.blipData.sprite or 54,
            colour = data.blipData and data.blipData.color or 3,
            scale = data.blipData and data.blipData.scale or 0.7,
            text = data.message or 'Dispatch Alert',
            flashes = data.blipData and data.blipData.flash or false,
            radius = data.blipData and data.blipData.radius or 0,
        }
    }

    TriggerServerEvent('rcore_dispatch:server:sendAlert', alertData)
end
