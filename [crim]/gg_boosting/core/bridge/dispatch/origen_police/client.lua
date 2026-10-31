gg.dispatch = gg.dispatch or {}

---@param data table
--- data.message   string   | Dispatch message text
--- data.code      string   | Dispatch code (e.g. "10-80")
--- data.icon      string   | FontAwesome icon string
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
---   length       number   | Length in ms (converted to minutes internally)
---   flash        boolean  | Should blip flash
gg.dispatch.alert = function(data)
    local color = nil
    if data.vehicle then
        local r, g, b = GetVehicleColor(data.vehicle)
        color = {r, g, b}
    end
    local customData = {
        coords = data.coords or vector3(0.0, 0.0, 0.0),
        title = 'Alert '..(data.code or '10-80'),
        message = data.message,
        job = data.jobs or 'police',
        metadata = {
            model = data.vehicle and (GetDisplayNameFromVehicleModel(GetEntityModel(data.vehicle))) or nil,
            color = color,
            plate = data.vehicle and GetVehicleNumberPlateText(data.vehicle) or nil,
            speed = data.vehicle and (GetEntitySpeed(data.vehicle) * 3.6)..' kmh' or nil
        }
    }

    TriggerServerEvent("SendAlert:police", customData)
end