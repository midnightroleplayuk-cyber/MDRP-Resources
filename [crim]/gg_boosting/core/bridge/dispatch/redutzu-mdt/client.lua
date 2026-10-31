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
    local streetHash, crossingHash = GetStreetNameAtCoord(data.coords.x, data.coords.y, data.coords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    local payload = {
        code = data.code or '10-80',
        message = data.message or "Dispatch Alert",
        street = streetName,
        time = data.time or 10000,
        coords = data.coords,
    }
    TriggerServerEvent(GetCurrentResourceName() .. ":server:redutzu-mdt:alert", payload)
end