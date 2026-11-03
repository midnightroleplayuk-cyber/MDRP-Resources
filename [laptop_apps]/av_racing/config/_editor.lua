Config = Config or {}
Config.EditorKeys = {
	["add"] = { Label = "E - Add Checkpoint", key = 38 },
	["delete"] = { Label = "8 - Delete Latest", key = 162 },
	["toggle"] = { Label = "G - Show Editor", key = 113 },
	["distance"] = { Label = "Arrow Up/Down - Checkpoint Dist.", key = { decrease = 173, increase = 172 } },
	["rotate"] = { Label = "Arrow Keys - Rotate Checkpoint", key = { decrease = 174, increase = 175 } },
	["reset"] = { Label = "Caps Lock - Reset Rotation", key = 171 },
	["model"] = { Label = "Mouse Wheel - Change Model", key = { decrease = 14, increase = 15 } },
	["freecam"] = { Label = "F - Change Placement Mode", key = 23 },
}

--[[
    Gate mode (third placement mode, cycled with the same key as the free camera).

    Instead of dropping a whole checkpoint under the camera, you place ONE post, a
    coloured barrier stretches from it to wherever you aim, and a second press drops
    the opposite post. The two points set the checkpoint's width and angle at once,
    which makes it far easier to line a gate up with the real edges of the road.
]]
Config.CheckpointBarrier = {
	color = { r = 0, g = 200, b = 255 }, -- barrier colour while aiming the second post
	alpha = 120, -- 0-255 transparency of the barrier
	height = 2.5, -- how tall the barrier is drawn, in meters
	minWidth = 2.0, -- posts closer than this are rejected
	maxWidth = 60.0, -- posts further apart than this are rejected
}

-- Free camera settings for placing checkpoints without a vehicle
Config.Freecam = {
	enabled = true, -- or false if you don't want to use freecam
	startHeight = 15.0, -- how far above the ped the camera spawns
	moveSpeed = 0.7, -- base movement speed per frame (WASD / Space / Ctrl)
	sprintMultiplier = 3.0, -- speed multiplier while holding Shift
	slowMultiplier = 0.25, -- speed multiplier while holding Alt (fine placement)
	lookSensitivity = 5.0, -- mouse look sensitivity
	placeDistance = 150.0, -- max raycast distance to find the ground in front of the camera
	keys = {
		forward = 32, -- W
		backward = 33, -- S
		left = 34, -- A
		right = 35, -- D
		up = 22, -- Space
		down = 36, -- Left Ctrl
		sprint = 21, -- Left Shift
		slow = 19, -- Left Alt
		lookLR = 1, -- Mouse X
		lookUD = 2, -- Mouse Y
	},
}
