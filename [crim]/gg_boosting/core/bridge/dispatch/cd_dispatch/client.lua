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
    local plyrData = exports['cd_dispatch']:GetPlayerInfo()
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = data.jobs,
        coords = data.coords,
        title = data.message,
        message = data.message,
        flash = 0,
        unique_id = plyrData.unique_id,
        sound = 1,
        blip = {
            sprite = data.blipData.sprite,
            scale = data.blipData.scale,
            colour = data.blipData.color,
            flashes = false,
            text = data.message,
            time = (data.time / 1000),
            radius = 0,
        }
    })
end