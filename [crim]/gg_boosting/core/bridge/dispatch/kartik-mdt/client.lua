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
    local coords = data.coords or vector3(0.0, 0.0, 0.0)
    local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)

    local payload = {
        title = data.message,
        code = data.code,
        description = data.message,
        location = streetName,
        sound = "dispatch",
        x = coords.x,
        y = coords.y,
        z = coords.z,
        type = data.priority == 1 and "Alert" or "Call",
        weapon = data.weapon and {
            name = data.weapon
        } or nil,
        blip = data.blipData and {
            radius = data.blipData.radius or 0.0,
            sprite = data.blipData.sprite,
            color = data.blipData.color,
            scale = data.blipData.scale,
            length = math.floor((data.time or 60000) / 60000)
        } or nil,
        jobs = data.jobs
    }

    TriggerEvent('kartik-mdt:server:sendDispatchNotification', payload)
end