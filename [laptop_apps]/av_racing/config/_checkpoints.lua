if lib.context == "server" then return end
Config = Config or {}
Config.FloatingCheckpoint = {
    enabled = false, -- true/false use default floating checkpoint
    text = "CHECKPOINT", -- Render the word CHECKPOINT, string or false (text = false)
    showDistance = true, -- Show the distance to checkpoint, the big 3D text, or false
    color = {r = 206, g = 255, b = 28}, -- Checkpoint RGB color
}

-- Sleepless waypoints is free and can be downloaded here: https://github.com/Sleepless-Development/sleepless_waypoints
Config.SleeplessWaypoints = {
    enabled = GetResourceState("sleepless_waypoints") == "started",
    type = "checkpoint",
    color = "#ceff1c",
    label = "CHECKPOINT",
    size = 1.0,
    drawDistance = 500.0,
    minHeight = 5.0,
    maxHeight = 80.0,
}