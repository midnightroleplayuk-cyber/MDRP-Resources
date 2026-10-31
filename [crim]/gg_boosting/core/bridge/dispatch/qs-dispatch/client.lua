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
    local playerData = exports['qs-dispatch']:GetPlayerInfo()
    if not playerData then return print("Error getting player data") end

    local payload = {
        job = data.jobs or {'police'},
        callLocation = data.coords or vec3(0.0, 0.0, 0.0),
        callCode = {
            code = data.code or '10-80',
            snippet = data.snippet or 'General Alert'
        },
        message = data.message,
        flashes = false,
        image = nil,
        blip = {
            sprite = data.blipData.sprite or 1,
            scale = data.blipData.scale or 1.0,
            colour = data.blipData.color or 1,
            flashes = false,
            text = data.message or "Alert",
            time = data.length and (data.time * 1000) or 20000
        },
        otherData = {
            {
                text = data.name or 'N/A',
                icon = data.icon or 'fas fa-question'
            }
        }
    }
    exports['qs-dispatch']:getSSURL(function(image)
        payload.image = image or payload.image
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', payload)
    end)
end