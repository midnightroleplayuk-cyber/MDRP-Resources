gg.dispatch = gg.dispatch or {}

---@param data table
--- data.message   string   | Dispatch message text
--- data.code      string   | Dispatch code (e.g. "10-80")
--- data.icon      string   | FontAwesome icon string (unused in tk_dispatch)
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
    if type(data) ~= "table" then return end

    local coords = data.coords or GetEntityCoords(PlayerPedId())
    
    exports.tk_dispatch:addCall({
        title = data.message or "Dispatch Alert",
        code = data.code or "10-80",
        priority = data.priority,
        coords = coords,
        message = data.message,
        showLocation = true,
        showGender = false,
        showVehicle = data.vehicle ~= nil,
        showWeapon = false,
        showPlate = data.plate ~= nil,
        platePercentage = data.plate and 100 or 0,
        playSound = true,
        removeTime = data.time or 10000,
        jobs = data.jobs or {"police"},
        blip = {
            sprite = data.blipData and data.blipData.sprite or 1,
            color = data.blipData and data.blipData.color or 3,
            scale = data.blipData and data.blipData.scale or 0.8,
            radius = data.blipData and data.blipData.radius or nil,
            flash = data.blipData and data.blipData.flash or false,
        },
    })
end
