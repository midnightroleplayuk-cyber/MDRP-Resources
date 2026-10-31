gg.dispatch = gg.dispatch or {}

---@param data table
--- data.message   string   | Dispatch message text
--- data.code      string   | Dispatch code (e.g. "10-80")
--- data.icon      string   | FontAwesome icon string (mapped into info block)
--- data.priority  number   | Priority level (1 = high, 3 = low)
--- data.coords    vector3  | Location for the dispatch alert
--- data.vehicle   number   | Vehicle entity (optional)
--- data.plate     string   | Vehicle plate (optional)
--- data.time      number   | Alert duration in ms (not directly supported by l2s)
--- data.jobs      table    | List of jobs who see the alert (mapped into departments)
--- data.blipData  table    | Blip config {radius, sprite, color, scale, length, flash}
gg.dispatch.alert = function(data)
    local playerData = exports['l2s-dispatch']:GetPlayerData()
    TriggerServerEvent('l2s-dispatch:server:AddNotification', {
        departments = data.jobs or {'POLICE'},
        title = data.code or '10-80',
        message = data.message or '',
        coords = vec2((data.coords or GetEntityCoords(PlayerPedId())).x, (data.coords or GetEntityCoords(PlayerPedId())).y),
        priority = data.priority or 1,
        sound = 1,
        street = playerData.street,
        reply = playerData.source,
        anonymous = false,
        blip = {
            sprite = data.blipData and data.blipData.sprite or 1,
            colour = data.blipData and data.blipData.color or 1,
            scale = data.blipData and data.blipData.scale or 1.0,
            text = (data.code or '') .. ' - ' .. (data.message or 'Alert'),
        },
        info = {
            { icon = data.icon or 'info', text = data.message or 'Dispatch Alert' },
            { icon = 'person', text = playerData.sex },
            data.plate and { icon = 'car', text = data.plate } or nil,
        }
    })
end
