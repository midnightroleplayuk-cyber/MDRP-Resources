-- Business blips, players can toggle on/off their own blip to let know other players if the business is open/closed
Config = Config or {}
Config.Blips = {
    -- index key needs to be named exactly like the job name
    -- blips sprites and colors: https://docs.fivem.net/docs/game-references/blips/
    -- online means the blip will be enable/disable by default
    ['avscripts'] = { x = -1540.94, y = -417.42, z = 35.639, label = "AV Business", sprite = 59, color = 2, online = false },
}