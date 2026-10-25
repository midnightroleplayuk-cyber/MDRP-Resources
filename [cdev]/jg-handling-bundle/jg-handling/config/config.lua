Config = {} -- Do not touch

-- General
Config.Locale = "en"
Config.Framework = "auto" -- or "none", "QBCore", "Qbox" or "ESX" (frameworks are used for job support, character names etc)
Config.Notifications = "auto" -- or "okokNotify", "ps-ui", "nox_notify", "ox_lib", "default"
Config.SpeedUnit = "mph" -- or "kph"

-- Editor
Config.EditorCommand = "editor" -- chat command
Config.EditorAdminOnly = true -- Set to true for admin only 
Config.EditorJobRestriction = {} -- [Requires framework] Enter jobs here that can use the editor, for example {"mechanic", "government"}. if set to false & EditorAdminOnly is also false, the editor will be public.

-- The timing tool can also be used on it's own, if you set Config.EnableStandaloneTimingTool = true,
-- otherwise it will be locked to use within the handling editor preview only.
Config.EnableStandaloneTimingTool = true
Config.TimingToolOpenCommand = "timingtool"
Config.TimingToolExitCommand = "closetimingtool"
Config.TimingToolAdminOnly = false -- Set to true for admin only
Config.TimingToolJobRestriction = {} -- [Requires framework] Enter jobs here that can use the timing tool, for example {"mechanic", "tuner"}. if set to false & TimingToolAdminOnly is also false, the tool will be public.
Config.TimingToolResetKeyBind = 36
Config.TimingToolResetLabel = "CTRL"

-- Timing tool speed target measurements; values must be in mph, so convert to mph if you use a different unit
Config.SpeedTargets = {
  ["0-60"] = 60,
  ["0-100"] = 100
}

-- Timing tool distance target measurements, values must be in ft, so convert to ft if you use a different unit
Config.DistanceTargets = { 
  ["1/4 mile"] = 1320,
  ["1/2 mile"] = 2640,
  ["1 mile"] = 5280,
}

-- Misc
Config.AutoRunSQL = true