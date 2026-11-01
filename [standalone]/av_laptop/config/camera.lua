--[[
    The item name(s) below MUST match av_laptop_addons > Config.Camera.cameraItem
]]

Config.CameraItems = {
	["camera"] = true,
}

-- A camera's memory only holds what a camera can shoot
-- Anything else (documents, notes, folders...) is refused when moved onto it
Config.CameraFileTypes = {
	["image"] = true,
	["video"] = true,
}
